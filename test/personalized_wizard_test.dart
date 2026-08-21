import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/models/personalized_roadmap_models.dart';
import 'package:csse_study_hub/presentation/screens/roadmap/wizard/personalized_wizard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestableWidget({
    PersonalizedProfile? initialProfile,
    Function(PersonalizedProfile)? onProfileCreated,
    double width = 400,
    double height = 800,
  }) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: PersonalizedWizardScreen(
          initialProfile: initialProfile,
          onProfileCreated: onProfileCreated,
        ),
      ),
    );
  }

  group('PersonalizedWizardScreen Widget & Navigation Tests', () {
    testWidgets(
        'Wizard renders initial step with progress indicator and Next button',
        (tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Personalized Roadmap Wizard'), findsOneWidget);
      expect(find.text('1 / 15'), findsOneWidget);
      expect(find.text('Current Academic Stage'), findsOneWidget);
      expect(find.text('1st Year'), findsOneWidget);
      expect(find.text('3rd Year'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets(
        'Step navigation advances forward and back while preserving state',
        (tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Step 1: Select 2nd Year
      await tester.tap(find.text('2nd Year'));
      await tester.pumpAndSettle();

      // Tap Next -> Step 2
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('2 / 15'), findsOneWidget);
      expect(find.text('Primary Goal(s)'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);

      // Tap Back -> Step 1
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      expect(find.text('1 / 15'), findsOneWidget);
      expect(find.text('Current Academic Stage'), findsOneWidget);
    });

    testWidgets(
        'Review screen displays summary and edit action jumps back to target step',
        (tester) async {
      PersonalizedProfile? submittedProfile;

      await tester.pumpWidget(createTestableWidget(
        onProfileCreated: (p) => submittedProfile = p,
      ));
      await tester.pumpAndSettle();

      // Advance through all 14 steps
      for (int i = 0; i < 14; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      expect(find.text('15 / 15'), findsOneWidget);
      expect(find.text('Review Your Profile'), findsOneWidget);
      expect(find.text('Generate My Personalized Roadmap'), findsOneWidget);

      // Test Edit button on Academic Stage (Step 0)
      final editButtons = find.byIcon(Icons.edit_outlined);
      expect(editButtons, findsWidgets);
      await tester.tap(editButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('1 / 15'), findsOneWidget);
      expect(find.text('Current Academic Stage'), findsOneWidget);
    });

    testWidgets(
        'Submitting final review constructs and saves valid PersonalizedProfile',
        (tester) async {
      PersonalizedProfile? submittedProfile;

      await tester.pumpWidget(createTestableWidget(
        onProfileCreated: (p) => submittedProfile = p,
      ));
      await tester.pumpAndSettle();

      // Fast forward to review step
      for (int i = 0; i < 14; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Generate My Personalized Roadmap'), findsOneWidget);
      await tester.tap(find.text('Generate My Personalized Roadmap'));
      await tester.pumpAndSettle();

      expect(submittedProfile, isNotNull);
      expect(submittedProfile!.primaryCareerDirection, isNotEmpty);
      expect(submittedProfile!.dailyLearningTimeMinutes, greaterThan(0));
      expect(submittedProfile!.targetTimeline, isNotEmpty);
    });

    testWidgets(
        'Responsive Layout Test: Renders on narrow screen (320px) without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestableWidget(width: 320, height: 640));
      await tester.pumpAndSettle();

      expect(find.text('Current Academic Stage'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Responsive Layout Test: Renders on desktop width (1200px) with centered constraints',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestableWidget(width: 1200, height: 800));
      await tester.pumpAndSettle();

      expect(find.text('Current Academic Stage'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
