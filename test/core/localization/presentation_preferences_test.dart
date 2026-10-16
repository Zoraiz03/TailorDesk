import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/core/database/database_provider.dart';
import 'package:tailor/core/localization/localization_extensions.dart';
import 'package:tailor/core/localization/presentation_preferences.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/l10n/app_localizations.dart';

void main() {
  test(
    'language and document preferences persist across database reopen',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'tailordesk_l10n_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/tailor.sqlite');
      var database = AppDatabase(NativeDatabase(file));
      final preferences = PresentationPreferencesRepository(database);

      await preferences.setLanguage('ur');
      await preferences.setDocumentLanguage(DocumentLanguage.bilingual);
      final saved = await preferences.watch().first;
      expect(saved.languageCode, 'ur');
      expect(saved.documentLanguage, DocumentLanguage.bilingual);
      final customerId = await CustomersDao(
        database,
      ).createCustomer(name: 'Allowed', phone: '0300');
      expect(customerId, isPositive);
      await database.close();

      database = AppDatabase(NativeDatabase(file));
      addTearDown(database.close);
      final reopened = await PresentationPreferencesRepository(
        database,
      ).watch().first;
      expect(reopened.languageCode, 'ur');
      expect(reopened.documentLanguage, DocumentLanguage.bilingual);
    },
  );

  testWidgets('language selector applies Urdu and RTL immediately', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const _PreferenceHarness(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('App language: English or Urdu'), findsOneWidget);

    await tester.tap(find.text('اردو'));
    await tester.pumpAndSettle();

    expect(find.text('ایپ کی زبان: انگریزی یا اردو'), findsOneWidget);
    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await database.close();
    await tester.pumpAndSettle();
  });
}

class _PreferenceHarness extends ConsumerWidget {
  const _PreferenceHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(currentPresentationPreferencesProvider);
    return MaterialApp(
      locale: preferences.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(
            children: [
              Text(context.l10n.languageSelectorLabel),
              const LanguageSelector(),
            ],
          ),
        ),
      ),
    );
  }
}
