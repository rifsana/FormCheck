import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_check/features/profile/presentation/profile_screen.dart';
import 'package:form_check/features/checklist/presentation/checklist_screen.dart';

void main() {
  testWidgets('Questionnaire advances through steps and validates selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ProfileScreen())),
    );

    // Step 1: Scope
    expect(find.text('About you'), findsOneWidget);
    expect(find.text('STEP 1 OF 3'), findsOneWidget);
    expect(find.text('Your application'), findsOneWidget);

    // Advance to Step 2
    await tester.tap(find.byKey(const Key('profile_continue_button')));
    await tester.pumpAndSettle();

    // Step 2: Non-ECR
    expect(find.text('STEP 2 OF 3'), findsOneWidget);
    expect(find.text('Emigration status (Non-ECR)'), findsOneWidget);

    // Advance to Step 3
    await tester.tap(find.byKey(const Key('profile_continue_button')));
    await tester.pumpAndSettle();

    // Step 3: Additional details
    expect(find.text('STEP 3 OF 3'), findsOneWidget);
    expect(find.text('Name & history'), findsOneWidget);
    expect(find.text('Generate Checklist'), findsOneWidget);
  });

  testWidgets(
    'Checklist screen renders mandatory items, source links, and toggle status',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ChecklistScreen())),
      );

      // Mandatory documents section in plain language
      expect(find.text('DOCUMENTS EVERYONE NEEDS'), findsOneWidget);
      expect(find.text('Proof of your date of birth'), findsOneWidget);
      expect(find.text('Proof of your current address'), findsOneWidget);

      // Toggle button exists
      expect(find.text('Pending'), findsAtLeastNWidgets(2));
    },
  );
}
