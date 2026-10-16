import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/garment_catalog.dart';
import '../../features/measurements/measurement_templates.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_en.dart';
import 'presentation_preferences.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? AppLocalizationsEn();
  bool get isUrdu => Localizations.localeOf(this).languageCode == 'ur';
}

String localizedGarmentLabel(
  AppLocalizations l10n,
  String garmentId, {
  String? english,
  String? urdu,
}) {
  final builtIn = switch (garmentId) {
    'shalwar_qameez' => l10n.garmentShalwarQameez,
    'coat' => l10n.garmentCoat,
    'trouser' => l10n.garmentTrouser,
    'shirt' => l10n.garmentShirt,
    'waistcoat' => l10n.garmentWaistcoat,
    'jacket' => l10n.garmentJacket,
    'kurta' => l10n.garmentKurta,
    'sherwani' => l10n.garmentSherwani,
    _ => null,
  };
  if (builtIn != null) return builtIn;
  final preferred = l10n.localeName == 'ur' ? urdu : english;
  final fallback = l10n.localeName == 'ur' ? english : urdu;
  return preferred?.trim().isNotEmpty == true
      ? preferred!.trim()
      : fallback?.trim().isNotEmpty == true
      ? fallback!.trim()
      : legacyGarmentLabel(garmentId);
}

String localizedMeasurementLabel(
  AppLocalizations l10n,
  String fieldId, {
  String? english,
  String? urdu,
}) {
  final builtIn = switch (fieldId) {
    'kameez_length' => l10n.measurementKameezLength,
    'length' => l10n.measurementLength,
    'shoulder' => l10n.measurementShoulder,
    'sleeve' => l10n.measurementSleeve,
    'collar' => l10n.measurementCollar,
    'chest' => l10n.measurementChest,
    'waist' => l10n.measurementWaist,
    'hip' => l10n.measurementHip,
    'shalwar_length' => l10n.measurementShalwarLength,
    'ankle_opening' => l10n.measurementAnkleOpening,
    'outseam' => l10n.measurementOutseam,
    'inseam' => l10n.measurementInseam,
    'thigh' => l10n.measurementThigh,
    'knee' => l10n.measurementKnee,
    'cuff' => l10n.measurementCuff,
    _ => null,
  };
  if (builtIn != null) return builtIn;
  final preferred = l10n.localeName == 'ur' ? urdu : english;
  final fallback = l10n.localeName == 'ur' ? english : urdu;
  return preferred?.trim().isNotEmpty == true
      ? preferred!.trim()
      : fallback?.trim().isNotEmpty == true
      ? fallback!.trim()
      : english?.trim().isNotEmpty == true
      ? english!.trim()
      : fieldId;
}

String localizedUnit(AppLocalizations l10n, String key) =>
    key == MeasurementUnit.centimetres.storageKey
    ? l10n.centimetres
    : l10n.inches;

String localizedBasis(AppLocalizations l10n, String key) =>
    key == MeasurementBasis.finishedGarment.storageKey
    ? l10n.finishedGarmentMeasurements
    : l10n.bodyMeasurements;

String localizedFit(AppLocalizations l10n, String key) => switch (key) {
  'slim' => l10n.slimFit,
  'loose' => l10n.looseFit,
  _ => l10n.regularFit,
};

String localizedPaymentMethod(AppLocalizations l10n, String key) =>
    key == 'manual_bank_transfer' ? l10n.manualBankTransfer : l10n.cash;

String localizedStatus(AppLocalizations l10n, String key) => switch (key) {
  'assigned' => l10n.assigned,
  'in_progress' || 'inProgress' => l10n.inProgress,
  'ready' => l10n.ready,
  'partially_delivered' || 'partiallyDelivered' => l10n.partiallyDelivered,
  'delivered' => l10n.delivered,
  'cancelled' => l10n.cancelled,
  'active' => l10n.active,
  'inactive' => l10n.inactive,
  _ => l10n.booked,
};

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(currentPresentationPreferencesProvider);
    final l10n = context.l10n;
    return Semantics(
      label: l10n.languageSelectorLabel,
      child: SegmentedButton<String>(
        showSelectedIcon: !compact,
        segments: [
          ButtonSegment(value: 'en', label: Text(l10n.english)),
          ButtonSegment(value: 'ur', label: Text(l10n.urdu)),
        ],
        selected: {preferences.languageCode},
        onSelectionChanged: (selection) => ref
            .read(presentationPreferencesRepositoryProvider)
            .setLanguage(selection.first),
      ),
    );
  }
}
