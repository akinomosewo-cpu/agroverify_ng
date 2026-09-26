import 'package:flutter_test/flutter_test.dart';
import 'package:agroverify_ng/core/services/verification_service.dart';

void main() {
  group('VerificationService.isPlausibleCode', () {
    final service = VerificationService();

    test('rejects empty code', () {
      expect(service.isPlausibleCode(''), isFalse);
      expect(service.isPlausibleCode('   '), isFalse);
    });

    test('rejects too-short code', () {
      expect(service.isPlausibleCode('AB-1'), isFalse);
    });

    test('rejects codes with invalid characters', () {
      expect(service.isPlausibleCode('SC 1234 5678'), isFalse);
      expect(service.isPlausibleCode('SC#1234#5678'), isFalse);
    });

    test('accepts a well-formed code', () {
      expect(service.isPlausibleCode('SC-1234-5678'), isTrue);
    });
  });

  group('VerificationService.verify', () {
    final service = VerificationService();

    test('returns genuine for a known good code', () {
      final result = service.verify('SC-1234-5678');
      expect(result.status, VerificationStatus.genuine);
      expect(result.productName, isNotNull);
      expect(result.brand, 'SEEDCO');
    });

    test('is case-insensitive and trims whitespace', () {
      final result = service.verify('  sc-1234-5678  ');
      expect(result.status, VerificationStatus.genuine);
    });

    test('returns counterfeit for a known bad code', () {
      final result = service.verify('SC-0000-0000');
      expect(result.status, VerificationStatus.counterfeit);
    });

    test('returns unknown for an unregistered but plausible code', () {
      final result = service.verify('ZZ-9876-5432');
      expect(result.status, VerificationStatus.unknown);
    });

    test('returns unknown for an implausible code without crashing', () {
      final result = service.verify('!!');
      expect(result.status, VerificationStatus.unknown);
      expect(result.message, isNotNull);
    });
  });
}
