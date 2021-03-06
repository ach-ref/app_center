import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app_center/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'tap on the floating action button; verify counter',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Finds the floating action button to tap on.
      final Finder fab = find.byTooltip('Increment');
      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      await tester.pumpAndSettle();

      await tester.pump(Duration(seconds: 3));

      expect(find.text('1'), findsOneWidget);
    },
  );
}
