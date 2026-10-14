import 'dart:convert';

import '../../core/database/app_database.dart';
import 'measurement_templates.dart';
import '../settings/garment_catalog.dart';

class MeasurementDraft {
  MeasurementDraft({
    required this.customerId,
    required GarmentType garmentType,
    required this.profileName,
    required this.unit,
    required this.basis,
    required this.values,
    required this.fitPreference,
    this.styleInstructions = '',
    this.notes = '',
  }) : garmentType = garmentType,
       garmentId = garmentType.storageKey,
       garmentLabelEnglish = garmentType.label,
       garmentLabelUrdu = '',
       templateVersionId = null,
       fieldDefinitions = null;

  MeasurementDraft.catalog({
    required this.customerId,
    required this.garmentId,
    required this.garmentLabelEnglish,
    this.garmentLabelUrdu = '',
    required this.profileName,
    required this.unit,
    required this.basis,
    required this.values,
    required this.fitPreference,
    required this.templateVersionId,
    required this.fieldDefinitions,
    this.styleInstructions = '',
    this.notes = '',
  }) : garmentType = null;

  final int customerId;
  final GarmentType? garmentType;
  final String garmentId;
  final String garmentLabelEnglish;
  final String garmentLabelUrdu;
  final int? templateVersionId;
  final List<GarmentTemplateField>? fieldDefinitions;
  final String profileName;
  final MeasurementUnit unit;
  final MeasurementBasis basis;
  final Map<String, double> values;
  final FitPreference fitPreference;
  final String styleInstructions;
  final String notes;

  void validate() {
    if (profileName.trim().isEmpty) {
      throw ArgumentError.value(profileName, 'profileName', 'Cannot be empty');
    }
    final fields =
        fieldDefinitions ??
        [
          for (final indexed
              in garmentMeasurementTemplates[garmentType]!.fields.indexed)
            GarmentTemplateField(
              id: indexed.$2.key,
              label: indexed.$2.label,
              order: indexed.$1,
              required: indexed.$2.required,
            ),
        ];
    for (final field in fields.where((item) => !item.archived)) {
      final value = values[field.id];
      if (field.required && value == null) {
        throw ArgumentError('Missing required measurement: ${field.label}');
      }
      if (value != null && (!value.isFinite || value <= 0)) {
        throw ArgumentError('${field.label} must be positive');
      }
    }
  }

  String encodeFieldDefinitions() {
    final fields =
        fieldDefinitions ??
        [
          for (final indexed
              in garmentMeasurementTemplates[garmentType]!.fields.indexed)
            GarmentTemplateField(
              id: indexed.$2.key,
              label: indexed.$2.label,
              order: indexed.$1,
              required: indexed.$2.required,
            ),
        ];
    return jsonEncode(
      fields.map((field) => field.toJson()).toList(growable: false),
    );
  }

  String encodeValues() {
    final ordered = Map.fromEntries(
      values.entries.toList()
        ..sort((left, right) => left.key.compareTo(right.key)),
    );
    return jsonEncode(ordered);
  }
}

class MeasurementProfileRecord {
  const MeasurementProfileRecord({
    required this.profile,
    required this.latestRevision,
  });

  final MeasurementProfile profile;
  final MeasurementRevision latestRevision;

  Map<String, double> get values =>
      decodeMeasurementValues(latestRevision.valuesJson);
}

Map<String, double> decodeMeasurementValues(String source) {
  final decoded = jsonDecode(source) as Map<String, dynamic>;
  return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
}
