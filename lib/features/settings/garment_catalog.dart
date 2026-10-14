import 'dart:convert';

import '../../core/database/app_database.dart';
import '../measurements/measurement_templates.dart';

class GarmentTemplateField {
  const GarmentTemplateField({
    required this.id,
    required this.label,
    required this.order,
    required this.required,
    this.labelUrdu,
    this.archived = false,
  });

  final String id;
  final String label;
  final String? labelUrdu;
  final int order;
  final bool required;
  final bool archived;

  Map<String, Object> toJson() => {
    'id': id,
    'label': label,
    if (labelUrdu?.trim().isNotEmpty == true) 'labelUrdu': labelUrdu!.trim(),
    'order': order,
    'required': required,
    'archived': archived,
  };
}

class GarmentCatalogRecord {
  const GarmentCatalogRecord({
    required this.entry,
    required this.templateVersion,
    required this.fields,
  });

  final GarmentCatalogEntry entry;
  final MeasurementTemplateVersion templateVersion;
  final List<GarmentTemplateField> fields;

  String get fieldDefinitionsJson =>
      jsonEncode(fields.map((field) => field.toJson()).toList(growable: false));
}

List<GarmentTemplateField> decodeFieldDefinitions(
  String source,
  String garmentId,
) {
  if (source.isNotEmpty) {
    try {
      final decoded = jsonDecode(source) as List<dynamic>;
      return decoded.map((item) {
        final value = item as Map<String, dynamic>;
        return GarmentTemplateField(
          id: value['id'] as String,
          label: value['label'] as String,
          labelUrdu: value['labelUrdu'] as String?,
          order: value['order'] as int,
          required: value['required'] as bool,
          archived: value['archived'] as bool? ?? false,
        );
      }).toList()..sort((left, right) => left.order.compareTo(right.order));
    } catch (_) {
      // Older records have no field-definition snapshot. Fall back only to
      // the stable built-in definition that existed when they were created.
    }
  }
  final type = GarmentType.tryFromStorage(garmentId);
  final legacy = type == null ? null : garmentMeasurementTemplates[type];
  return [
    for (final indexed in (legacy?.fields ?? const []).indexed)
      GarmentTemplateField(
        id: indexed.$2.key,
        label: indexed.$2.label,
        order: indexed.$1,
        required: indexed.$2.required,
      ),
  ];
}

String legacyGarmentLabel(String storage) =>
    GarmentType.tryFromStorage(storage)?.label ??
    storage
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
