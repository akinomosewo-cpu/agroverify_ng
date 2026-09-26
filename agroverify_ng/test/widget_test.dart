import 'package:flutter_test/flutter_test.dart';
import 'package:agroverify_ng/main.dart';

void main() {
  testWidgets('App starts on the home page and shows key sections', (WidgetTester tester) async {
    await tester.pumpWidget(const AgroVerifyApp());
    await tester.pumpAndSettle();

    expect(find.text('AgroVerify NG'), findsOneWidget);
    expect(find.text('Recent Activity'), findsOneWidget);
    expect(find.text('Scan inputs to verify'), findsOneWidget);
    expect(find.text('Rate agro-dealers'), findsOneWidget);
    expect(find.text('Report fake products'), findsOneWidget);
  });
}
