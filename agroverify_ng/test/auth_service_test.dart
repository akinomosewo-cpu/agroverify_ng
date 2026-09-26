import 'package:flutter_test/flutter_test.dart';
import 'package:agroverify_ng/core/services/auth_service.dart';

void main() {
  late AuthService auth;

  setUp(() async {
    auth = AuthService.instance;
    await auth.debugReset();
  });

  group('AuthService', () {
    test('has no signed-in user by default (guest mode)', () async {
      expect(await auth.currentUser(), isNull);
    });

    test('sign up creates and signs in a new local account', () async {
      final user = await auth.signUp(name: 'Musa Bello', phone: '0803 123 4567', password: 'pass1234');
      expect(user.name, 'Musa Bello');
      expect(user.phone, '08031234567');

      final current = await auth.currentUser();
      expect(current, isNotNull);
      expect(current!.phone, '08031234567');
    });

    test('sign up rejects a phone number already registered on this device', () async {
      await auth.signUp(name: 'Musa Bello', phone: '08031234567', password: 'pass1234');
      expect(
        () => auth.signUp(name: 'Someone Else', phone: '08031234567', password: 'other1234'),
        throwsA(isA<AuthException>().having((e) => e.type, 'type', AuthErrorType.phoneExists)),
      );
    });

    test('sign up rejects weak/invalid input', () async {
      expect(
        () => auth.signUp(name: '', phone: '08031234567', password: 'pass1234'),
        throwsA(isA<AuthException>().having((e) => e.type, 'type', AuthErrorType.invalidInput)),
      );
      expect(
        () => auth.signUp(name: 'Musa', phone: '08031234567', password: '123'),
        throwsA(isA<AuthException>().having((e) => e.type, 'type', AuthErrorType.invalidInput)),
      );
    });

    test('log in succeeds with correct credentials and fails with wrong password', () async {
      await auth.signUp(name: 'Ada Okafor', phone: '08099998888', password: 'secret99');
      await auth.logOut();
      expect(await auth.currentUser(), isNull);

      final user = await auth.logIn(phone: '08099998888', password: 'secret99');
      expect(user.name, 'Ada Okafor');

      await auth.logOut();
      expect(
        () => auth.logIn(phone: '08099998888', password: 'wrong-password'),
        throwsA(isA<AuthException>().having((e) => e.type, 'type', AuthErrorType.wrongPassword)),
      );
    });

    test('log in fails for an unregistered phone number', () async {
      expect(
        () => auth.logIn(phone: '07000000000', password: 'whatever1'),
        throwsA(isA<AuthException>().having((e) => e.type, 'type', AuthErrorType.notFound)),
      );
    });

    test('log out clears the active session without deleting the account', () async {
      await auth.signUp(name: 'Ngozi Eze', phone: '08111112222', password: 'farmer12');
      await auth.logOut();
      expect(await auth.currentUser(), isNull);

      final user = await auth.logIn(phone: '08111112222', password: 'farmer12');
      expect(user.name, 'Ngozi Eze');
    });
  });
}
