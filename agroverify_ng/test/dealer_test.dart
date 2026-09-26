import 'package:flutter_test/flutter_test.dart';
import 'package:agroverify_ng/domain/models/dealer.dart';

void main() {
  group('Dealer.isTrusted', () {
    test('a highly rated dealer with few reports is trusted', () {
      const dealer = Dealer(
        id: '1',
        name: 'Test Agro',
        location: 'Abuja',
        latitude: 9.0,
        longitude: 7.4,
        rating: 4.5,
        reportsCount: 0,
      );
      expect(dealer.isTrusted, isTrue);
    });

    test('a low rated dealer is untrustworthy', () {
      const dealer = Dealer(
        id: '2',
        name: 'Bad Agro',
        location: 'Minna',
        latitude: 9.6,
        longitude: 6.5,
        rating: 2.0,
        reportsCount: 5,
      );
      expect(dealer.isTrusted, isFalse);
    });

    test('a decently rated dealer with many reports is untrustworthy', () {
      const dealer = Dealer(
        id: '3',
        name: 'Risky Agro',
        location: 'Zaria',
        latitude: 11.0,
        longitude: 7.7,
        rating: 4.0,
        reportsCount: 4,
      );
      expect(dealer.isTrusted, isFalse);
    });
  });
}
