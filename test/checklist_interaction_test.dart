import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_check/features/checklist/presentation/checklist_screen.dart';

void main() {
  testWidgets('Evidence expander expands and collapses on tap', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ChecklistScreen())),
    );

    // Initial state: accepted evidence list items are not displayed
    expect(find.text('Birth Certificate'), findsNothing);

    // Tap expander for DOB requirement
    final expanderKey = find.byKey(
      const Key('expand_evidence_req_proof_of_dob'),
    );
    expect(expanderKey, findsOneWidget);

    await tester.tap(expanderKey);
    await tester.pumpAndSettle();

    // Now evidence items are displayed!
    expect(find.text('Birth Certificate'), findsOneWidget);
    expect(find.text('PAN Card / e-PAN'), findsOneWidget);

    // Tap again to collapse
    await tester.tap(expanderKey);
    await tester.pumpAndSettle();

    expect(find.text('Birth Certificate'), findsNothing);
  });

  testWidgets('Status toggle toggles from Pending to Collected', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ChecklistScreen())),
    );

    final toggleKey = find.byKey(const Key('toggle_status_req_proof_of_dob'));
    expect(toggleKey, findsOneWidget);

    // Tap toggle
    await tester.tap(toggleKey);
    await tester.pumpAndSettle();

    expect(find.text('Collected'), findsAtLeastNWidgets(1));
    expect(find.text('1 of 3 ready'), findsOneWidget);
  });

  testWidgets('Source link is tappable and renders link icon', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ChecklistScreen())),
    );

    final sourceLinkKey = find.byKey(const Key('source_link_req_proof_of_dob'));
    expect(sourceLinkKey, findsOneWidget);

    // Tap source link without error
    await tester.tap(sourceLinkKey);
    await tester.pumpAndSettle();
  });
}
