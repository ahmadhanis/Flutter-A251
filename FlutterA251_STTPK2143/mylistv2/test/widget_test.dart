import 'package:flutter_test/flutter_test.dart';
import 'package:mylistv2/main.dart';
import 'package:mylistv2/loginscreen.dart';

void main() {
  testWidgets('SplashScreen navigates to LoginScreen', (WidgetTester tester) async {

    // Load the app (SplashScreen will show first)
    await tester.pumpWidget(const MyApp());

    // SplashScreen should be visible
    expect(find.text("MyList V2"), findsOneWidget);

    // Fast forward time by 6 seconds to allow navigation (Splash waits 5)
    await tester.pump(const Duration(seconds: 6));

    // Rebuild after time passage
    await tester.pumpAndSettle();

    // Now LoginScreen should appear
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
