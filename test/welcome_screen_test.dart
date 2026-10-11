import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_check/features/welcome/presentation/welcome_screen.dart';
import 'package:form_check/core/constants/app_strings.dart';

void main() {
  testWidgets(
    'Redesigned Welcome screen renders minimal headline, benefit rows, and CTA button',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // FormCheck Branding & Headline
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.welcomeHeadline), findsOneWidget);
      expect(find.text(AppStrings.welcomeSupportingText), findsOneWidget);

      // 3 Compact Benefit Rows
      expect(find.text(AppStrings.benefit1Title), findsOneWidget);
      expect(find.text(AppStrings.benefit2Title), findsOneWidget);
      expect(find.text(AppStrings.benefit3Title), findsOneWidget);

      // Scope & Concise Notice
      expect(find.text(AppStrings.welcomeScopeCaption), findsOneWidget);
      expect(find.text(AppStrings.welcomeConciseDisclaimer), findsOneWidget);

      // CTA Button
      expect(find.byKey(const Key('check_documents_button')), findsOneWidget);
      expect(find.text(AppStrings.welcomeCta), findsOneWidget);

      // Official Link
      expect(find.text('Official Passport Seva Portal'), findsOneWidget);
    },
  );
}
