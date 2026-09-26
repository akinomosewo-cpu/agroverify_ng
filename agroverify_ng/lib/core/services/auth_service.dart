import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

/// A locally-registered farmer account. Nothing here ever leaves the
/// device — there is no backend for auth, only a local Hive box.
class AuthUser {
  final String name;
  final String phone;
  const AuthUser({required this.name, required this.phone});
}

enum AuthErrorType { invalidInput, phoneExists, notFound, wrongPassword }

class AuthException implements Exception {
  final AuthErrorType type;
  const AuthException(this.type);
}

/// Local-only authentication for AgroVerify NG.
///
/// Scanning, dealer ratings and reporting all work fully without an
/// account — a farmer is never blocked by a login wall. Creating an
/// account is optional and only unlocks saved scan/report history across
/// app restarts. Credentials are salted-hashed and stored in a local Hive
/// box; there is no server round trip and no plaintext password storage.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _boxName = 'agroverify_auth';
  static const _usersKey = 'users';
  static const _sessionKey = 'session_phone';
  static bool _hiveReady = false;

  Box? _box;

  /// Points Hive at a plain filesystem directory using only `dart:io`, so
  /// it works identically in the real app and under `flutter test` without
  /// depending on the `path_provider` platform channel.
  static Future<void> _ensureHiveReady() async {
    if (_hiveReady) return;
    if (!Hive.isBoxOpen(_boxName)) {
      try {
        final dir = Directory('${Directory.systemTemp.path}/agroverify_ng_hive');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        Hive.init(dir.path);
      } catch (_) {
        // Hive may already be initialized elsewhere (e.g. a previous test) —
        // that's fine, openBox below will just reuse it.
      }
    }
    _hiveReady = true;
  }

  Future<Box> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    await _ensureHiveReady();
    _box = Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);
    return _box!;
  }

  String _hash(String value) => sha256.convert(utf8.encode('agroverify::$value')).toString();

  /// Phone numbers are the account identifier; normalise so "080 1234 5678"
  /// and "0801234-5678" resolve to the same account.
  String normalizePhone(String phone) => phone.trim().replaceAll(RegExp(r'[\s-]+'), '');

  Future<Map<String, dynamic>> _readUsers(Box box) async {
    final raw = box.get(_usersKey);
    if (raw == null) return <String, dynamic>{};
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<AuthUser> signUp({
    required String name,
    required String phone,
    required String password,
  }) async {
    final box = await _openBox();
    final trimmedName = name.trim();
    final normalizedPhone = normalizePhone(phone);
    if (trimmedName.isEmpty || normalizedPhone.length < 7 || password.length < 4) {
      throw const AuthException(AuthErrorType.invalidInput);
    }
    final users = await _readUsers(box);
    if (users.containsKey(normalizedPhone)) {
      throw const AuthException(AuthErrorType.phoneExists);
    }
    users[normalizedPhone] = {
      'name': trimmedName,
      'phone': normalizedPhone,
      'passwordHash': _hash(password),
    };
    await box.put(_usersKey, users);
    await box.put(_sessionKey, normalizedPhone);
    return AuthUser(name: trimmedName, phone: normalizedPhone);
  }

  Future<AuthUser> logIn({required String phone, required String password}) async {
    final box = await _openBox();
    final normalizedPhone = normalizePhone(phone);
    final users = await _readUsers(box);
    final record = users[normalizedPhone];
    if (record == null) {
      throw const AuthException(AuthErrorType.notFound);
    }
    final data = Map<String, dynamic>.from(record as Map);
    if (data['passwordHash'] != _hash(password)) {
      throw const AuthException(AuthErrorType.wrongPassword);
    }
    await box.put(_sessionKey, normalizedPhone);
    return AuthUser(name: data['name'] as String, phone: normalizedPhone);
  }

  Future<void> logOut() async {
    final box = await _openBox();
    await box.delete(_sessionKey);
  }

  /// The currently signed-in farmer, or `null` when using the app as a
  /// guest (the default, unauthenticated state).
  Future<AuthUser?> currentUser() async {
    final box = await _openBox();
    final phone = box.get(_sessionKey) as String?;
    if (phone == null) return null;
    final users = await _readUsers(box);
    final record = users[phone];
    if (record == null) return null;
    final data = Map<String, dynamic>.from(record as Map);
    return AuthUser(name: data['name'] as String, phone: phone);
  }

  /// Clears all local accounts and the active session. Used by tests, and
  /// available for a future "forget this device" setting.
  Future<void> debugReset() async {
    final box = await _openBox();
    await box.clear();
  }
}
