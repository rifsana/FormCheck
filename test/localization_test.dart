import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_check/core/localization/app_language.dart';
import 'package:form_check/core/localization/app_localizations.dart';
import 'package:form_check/core/localization/locale_controller.dart';
import 'package:form_check/features/settings/presentation/settings_screen.dart';
import 'package:form_check/features/welcome/presentation/welcome_screen.dart';

class TestLocaleNotifier extends LocaleNotifier {
  final Locale initial;
  TestLocaleNotifier(this.initial);

  @override
  Locale build() => initial;
}

Widget createLocalizedApp({Locale? initialLocale}) {
  return ProviderScope(
    overrides: [
      if (initialLocale != null)
        localeProvider.overrideWith(() => TestLocaleNotifier(initialLocale)),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final currentLocale = ref.watch(localeProvider);
        return MaterialApp(
          locale: currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const WelcomeScreen(),
        );
      },
    ),
  );
}

void main() {
  group('AppLanguage Model Tests', () {
    test('Contains all 13 specified Indian languages and English', () {
      final codes = AppLanguage.supportedLanguages.map((l) => l.code).toList();
      expect(
        codes,
        containsAll([
          'en',
          'hi',
          'ml',
          'ta',
          'te',
          'kn',
          'bn',
          'mr',
          'gu',
          'pa',
          'or',
          'as',
          'ur',
        ]),
      );
      expect(AppLanguage.supportedLanguages.length, equals(13));
    });

    test('Identifies Urdu as RTL', () {
      final urdu = AppLanguage.fromCode('ur');
      expect(urdu.isRtl, isTrue);
      expect(urdu.nativeName, equals('اردو'));

      final hindi = AppLanguage.fromCode('hi');
      expect(hindi.isRtl, isFalse);
    });

    test('Accurately represents language review status', () {
      expect(AppLanguage.fromCode('en').isReady, isTrue);
      expect(AppLanguage.fromCode('hi').isReady, isTrue);
      expect(AppLanguage.fromCode('ml').isReady, isTrue);
      expect(AppLanguage.fromCode('ur').isReady, isTrue);

      expect(AppLanguage.fromCode('ta').isReady, isFalse);
      expect(AppLanguage.fromCode('bn').isReady, isFalse);
    });
  });

  group('AppLocalizations Unit Tests', () {
    test('Translates and interpolates parameterized strings in all ready languages', () {
      final en = AppLocalizations(const Locale('en'));
      expect(en.stepOf(1), equals('STEP 1 OF 3'));
      expect(
        en.whatDocsAccepted(8),
        equals('What documents are accepted? (8)'),
      );

      final hi = AppLocalizations(const Locale('hi'));
      expect(hi.stepOf(1), equals('चरण 1 / 3'));
      expect(hi.welcomeHeadline, contains('पासपोर्ट दस्तावेज़ तैयार करें'));

      final ml = AppLocalizations(const Locale('ml'));
      expect(ml.stepOf(1), equals('ഘട്ടം 1 / 3'));
      expect(ml.welcomeHeadline, contains('പാസ്‌പോർട്ട് രേഖകൾ തയ്യാറാക്കുക'));

      final ur = AppLocalizations(const Locale('ur'));
      expect(ur.stepOf(1), equals('مرحلہ 1 از 3'));
      expect(ur.welcomeHeadline, contains('پاسپورٹ کی دستاویزات تیار کریں'));
    });
  });

  group('Multilingual UI & Language Switching Widget Tests', () {
    testWidgets('Renders default English and switches to Hindi immediately', (
      tester,
    ) async {
      await tester.pumpWidget(createLocalizedApp());
      await tester.pumpAndSettle();

      // Initial English state
      expect(find.text('Get your passport documents ready.'), findsOneWidget);
      expect(find.text('Check my documents'), findsOneWidget);

      // Open language sheet
      await tester.tap(find.byKey(const Key('language_selector_button')));
      await tester.pumpAndSettle();

      // Verify language options appear with native names
      expect(find.text('हिन्दी'), findsOneWidget);
      expect(find.text('മലയാളം'), findsOneWidget);
      expect(find.text('اردو'), findsOneWidget);

      // Tap Hindi option
      await tester.tap(find.byKey(const Key('lang_option_hi')));
      await tester.pumpAndSettle();

      // Verify UI immediately updated to Hindi!
      expect(find.text('अपने पासपोर्ट दस्तावेज़ तैयार करें।'), findsOneWidget);
      expect(find.text('मेरे दस्तावेज़ देखें'), findsOneWidget);
    });

    testWidgets('Switches to Malayalam immediately', (tester) async {
      await tester.pumpWidget(createLocalizedApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('language_selector_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('lang_option_ml')));
      await tester.pumpAndSettle();

      expect(
        find.text('നിങ്ങളുടെ പാസ്‌പോർട്ട് രേഖകൾ തയ്യാറാക്കുക.'),
        findsOneWidget,
      );
      expect(find.text('രേഖകൾ പരിശോധിക്കുക'), findsOneWidget);
    });

    testWidgets(
      'Switches to Urdu, displays Urdu text, and renders with RTL directionality',
      (tester) async {
        await tester.pumpWidget(createLocalizedApp());
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('language_selector_button')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('lang_option_ur')));
        await tester.pumpAndSettle();

        // Text rendered in Urdu
        expect(
          find.text('اپنے پاسپورٹ کی دستاویزات تیار کریں۔'),
          findsOneWidget,
        );
        expect(find.text('میرے دستاویزات چیک کریں'), findsOneWidget);

        // Verify Directionality is RTL
        final BuildContext context = tester.element(
          find.text('اپنے پاسپورٹ کی دستاویزات تیار کریں۔'),
        );
        expect(Directionality.of(context), equals(TextDirection.rtl));
      },
    );

    testWidgets(
      'Under-review language presents transparent review modal and preserves current language',
      (tester) async {
        await tester.pumpWidget(createLocalizedApp());
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('language_selector_button')));
        await tester.pumpAndSettle();

        // Tap an under-review language (e.g. Tamil)
        await tester.tap(find.byKey(const Key('lang_option_ta')));
        await tester.pumpAndSettle();

        // Dialog informing of official review appears
        expect(find.text('Language Under Official Review'), findsOneWidget);
        expect(find.text('I Understand'), findsOneWidget);

        // Dismiss dialog
        await tester.tap(find.text('I Understand'));
        await tester.pumpAndSettle();

        // English remains the active language
        expect(find.text('Get your passport documents ready.'), findsOneWidget);
      },
    );
  });

  group('Settings Screen Language Tile Tests', () {
    testWidgets('Settings screen renders current language and opens selector', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings & Language'), findsOneWidget);
      expect(find.text('English (English)'), findsOneWidget);

      // Tap language tile
      await tester.tap(find.byKey(const Key('settings_language_tile')));
      await tester.pumpAndSettle();

      expect(find.text('हिन्दी'), findsOneWidget);
    });
  });
}
