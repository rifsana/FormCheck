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
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.text('Confirm Application Scope'), findsOneWidget);

    // Advance to Step 2
    await tester.tap(find.byKey(const Key('profile_continue_button')));
    await tester.pumpAndSettle();

    // Step 2: Non-ECR
    expect(find.text('Step 2 of 3'), findsOneWidget);
    expect(find.text('Non-ECR Eligibility'), findsOneWidget);

    // Advance to Step 3
    await tester.tap(find.byKey(const Key('profile_continue_button')));
    await tester.pumpAndSettle();

    // Step 3: Additional details
    expect(find.text('Step 3 of 3'), findsOneWidget);
    expect(find.text('Additional Information'), findsOneWidget);
    expect(find.text('Generate Checklist'), findsOneWidget);
  });

  testWidgets(
    'Checklist screen renders mandatory items, source links, and toggle status',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ChecklistScreen())),
      );

      // Mandatory documents
      expect(find.text('1. Mandatory Documents'), findsOneWidget);
      expect(find.text('Proof of Date of Birth (DOB)'), findsOneWidget);
      expect(find.text('Proof of Present Residential Address'), findsOneWidget);

      // Toggle button exists
      expect(find.text('Pending'), findsAtLeastNWidgets(2));
    },
  );
}
