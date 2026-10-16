import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/shop_settings_providers.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

enum DocumentLanguage { english, urdu, bilingual }

class PresentationPreferences {
  const PresentationPreferences({
    this.languageCode = 'en',
    this.documentLanguage = DocumentLanguage.english,
  });

  final String languageCode;
  final DocumentLanguage documentLanguage;

  Locale get locale => Locale(languageCode == 'ur' ? 'ur' : 'en');
}

class PresentationPreferencesRepository {
  PresentationPreferencesRepository(this.database);

  final AppDatabase database;

  static const languageKey = 'presentation_language';
  static const documentLanguageKey = 'document_language';

  Stream<PresentationPreferences> watch() =>
      database.select(database.appSettings).watch().map(_fromRows);

  PresentationPreferences _fromRows(List<AppSetting> rows) {
    final values = {for (final row in rows) row.key: row.value};
    final language = values[languageKey] == 'ur' ? 'ur' : 'en';
    final document = switch (values[documentLanguageKey]) {
      'ur' => DocumentLanguage.urdu,
      'bilingual' => DocumentLanguage.bilingual,
      _ => DocumentLanguage.english,
    };
    return PresentationPreferences(
      languageCode: language,
      documentLanguage: document,
    );
  }

  Future<void> setLanguage(String code) =>
      _put(languageKey, code == 'ur' ? 'ur' : 'en');

  Future<void> setDocumentLanguage(DocumentLanguage language) =>
      _put(documentLanguageKey, switch (language) {
        DocumentLanguage.english => 'en',
        DocumentLanguage.urdu => 'ur',
        DocumentLanguage.bilingual => 'bilingual',
      });

  Future<void> _put(String key, String value) => database
      .into(database.appSettings)
      .insert(
        AppSettingsCompanion.insert(key: key, value: Value(value)),
        mode: InsertMode.insertOrReplace,
      );
}

final presentationPreferencesRepositoryProvider =
    Provider<PresentationPreferencesRepository>(
      (ref) => PresentationPreferencesRepository(ref.watch(databaseProvider)),
    );

final presentationPreferencesProvider = StreamProvider<PresentationPreferences>(
  (ref) => ref.watch(presentationPreferencesRepositoryProvider).watch(),
);

final currentPresentationPreferencesProvider =
    Provider<PresentationPreferences>(
      (ref) => ref
          .watch(presentationPreferencesProvider)
          .when(
            data: (value) => value,
            loading: () => const PresentationPreferences(),
            error: (_, __) => const PresentationPreferences(),
          ),
    );

/// Invalidates shop settings when document preferences are shown beside them.
void refreshPresentationPreferences(WidgetRef ref) {
  ref.invalidate(presentationPreferencesProvider);
  ref.invalidate(shopDetailsProvider);
}
