import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/auth_service.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Before the saved session has been read from disk. Brief and only ever
/// seen for a moment during app start — never gates the UI.
class AuthUnknown extends AuthState {
  const AuthUnknown();
}

/// The default state: using the app without an account. Every feature —
/// scanning, dealer ratings, reporting — works fully in this state.
class AuthGuest extends AuthState {
  const AuthGuest();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user.phone, user.name];
}

/// Drives the optional local sign-up/login flow. Farmers are never forced
/// through this — [AuthGuest] is a perfectly normal, fully-functional
/// state — but signing up lets them keep their scan/report history across
/// app restarts.
class AuthCubit extends Cubit<AuthState> {
  final AuthService _service;

  AuthCubit({AuthService? service})
      : _service = service ?? AuthService.instance,
        super(const AuthUnknown()) {
    _restore();
  }

  Future<void> _restore() async {
    final user = await _service.currentUser();
    emit(user != null ? AuthAuthenticated(user) : const AuthGuest());
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
  }) async {
    final user = await _service.signUp(name: name, phone: phone, password: password);
    emit(AuthAuthenticated(user));
  }

  Future<void> logIn({required String phone, required String password}) async {
    final user = await _service.logIn(phone: phone, password: password);
    emit(AuthAuthenticated(user));
  }

  Future<void> logOut() async {
    await _service.logOut();
    emit(const AuthGuest());
  }
}
