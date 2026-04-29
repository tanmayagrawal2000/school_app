import 'package:flutter_test/flutter_test.dart';
import 'package:sgm_school_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SGMSchoolApp());
    expect(find.byType(SGMSchoolApp), findsOneWidget);
  });
}
