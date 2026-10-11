import 'dart:convert';

import '../../core/database/app_database.dart';
import 'measurement_templates.dart';

class MeasurementDraft {
  const MeasurementDraft({
    required this.customerId,
    required this.garmentType,
    required this.profileName,
    required this.unit,
    required this.basis,
    required this.values,
    required this.fitPreference,
    this.styleInstructions = '',
    this.notes = '',
  });

  final int customerId;
  final GarmentType garmentType;
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
    final template = garmentMeasurementTemplates[garmentType]!;
    for (final field in template.fields) {
      final value = values[field.key];
      if (field.required && value == null) {
        throw ArgumentError('Missing required measurement: ${field.label}');
      }
      if (value != null && (!value.isFinite || value <= 0)) {
        throw ArgumentError('${field.label} must be positive');
      }
    }
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
