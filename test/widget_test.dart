import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_cv_builder/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ProfessionalCVBuilderApp(onboardingComplete: true),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Resumes'), findsOneWidget);
  });
}
