import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_check/features/welcome/presentation/welcome_screen.dart';
import 'package:form_check/core/constants/app_strings.dart';

void main() {
  testWidgets(
    'Welcome screen renders FormCheck branding, disclaimer, and start button',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Branding & Header
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(
        find.text('Prepare your passport\ndocuments with confidence.'),
        findsOneWidget,
      );

      // Disclaimer
      expect(find.text(AppStrings.independentNoticeTitle), findsOneWidget);

      // Start button
      expect(find.byKey(const Key('start_preparation_button')), findsOneWidget);
    },
  );
}
