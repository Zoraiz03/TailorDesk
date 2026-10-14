enum GarmentType {
  shalwarQameez('shalwar_qameez', 'Shalwar Qameez'),
  coat('coat', 'Coat'),
  trouser('trouser', 'Trouser'),
  shirt('shirt', 'Shirt'),
  waistcoat('waistcoat', 'Waistcoat'),
  jacket('jacket', 'Jacket');

  const GarmentType(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static GarmentType fromStorage(String value) => values.firstWhere(
    (type) => type.storageKey == value,
    orElse: () => GarmentType.shalwarQameez,
  );

  static GarmentType? tryFromStorage(String value) {
    for (final type in values) {
      if (type.storageKey == value) return type;
    }
    return null;
  }
}

enum MeasurementUnit {
  inches('inches', 'Inches', 'in'),
  centimetres('centimetres', 'Centimetres', 'cm');

  const MeasurementUnit(this.storageKey, this.label, this.suffix);

  final String storageKey;
  final String label;
  final String suffix;

  static MeasurementUnit fromStorage(String value) => values.firstWhere(
    (unit) => unit.storageKey == value,
    orElse: () => MeasurementUnit.inches,
  );
}

enum MeasurementBasis {
  body('body', 'Body measurements'),
  finishedGarment('finished_garment', 'Finished-garment measurements');

  const MeasurementBasis(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static MeasurementBasis fromStorage(String value) => values.firstWhere(
    (basis) => basis.storageKey == value,
    orElse: () => MeasurementBasis.body,
  );
}

enum FitPreference {
  regular('regular', 'Regular'),
  slim('slim', 'Slim'),
  loose('loose', 'Loose');

  const FitPreference(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static FitPreference fromStorage(String value) => values.firstWhere(
    (fit) => fit.storageKey == value,
    orElse: () => FitPreference.regular,
  );
}

class MeasurementFieldDefinition {
  const MeasurementFieldDefinition({
    required this.key,
    required this.label,
    required this.required,
  });

  final String key;
  final String label;
  final bool required;
}

class GarmentMeasurementTemplate {
  const GarmentMeasurementTemplate({required this.type, required this.fields});

  final GarmentType type;
  final List<MeasurementFieldDefinition> fields;
}

const _required = true;
const _optional = false;

/// Provisional field sets pending review by a working tailor.
///
/// A profile explicitly records whether its numbers are body measurements or
/// finished-garment measurements. The app never converts between the two and
/// does not add tailoring allowances.
const garmentMeasurementTemplates = <GarmentType, GarmentMeasurementTemplate>{
  GarmentType.shalwarQameez: GarmentMeasurementTemplate(
    type: GarmentType.shalwarQameez,
    fields: [
      MeasurementFieldDefinition(
        key: 'kameez_length',
        label: 'Kameez length',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'shoulder',
        label: 'Shoulder',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'sleeve',
        label: 'Sleeve',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'collar',
        label: 'Collar',
        required: _optional,
      ),
      MeasurementFieldDefinition(
        key: 'chest',
        label: 'Chest',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'waist',
        label: 'Waist',
        required: _required,
      ),
      MeasurementFieldDefinition(key: 'hip', label: 'Hip', required: _required),
      MeasurementFieldDefinition(
        key: 'shalwar_length',
        label: 'Shalwar length',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'ankle_opening',
        label: 'Ankle opening',
        required: _optional,
      ),
    ],
  ),
  GarmentType.coat: GarmentMeasurementTemplate(
    type: GarmentType.coat,
    fields: [
      MeasurementFieldDefinition(
        key: 'length',
        label: 'Length',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'shoulder',
        label: 'Shoulder',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'sleeve',
        label: 'Sleeve',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'chest',
        label: 'Chest',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'waist',
        label: 'Waist',
        required: _required,
      ),
      MeasurementFieldDefinition(key: 'hip', label: 'Hip', required: _optional),
    ],
  ),
  GarmentType.trouser: GarmentMeasurementTemplate(
    type: GarmentType.trouser,
    fields: [
      MeasurementFieldDefinition(
        key: 'waist',
        label: 'Waist',
        required: _required,
      ),
      MeasurementFieldDefinition(key: 'hip', label: 'Hip', required: _required),
      MeasurementFieldDefinition(
        key: 'outseam',
        label: 'Outseam',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'inseam',
        label: 'Inseam',
        required: _optional,
      ),
      MeasurementFieldDefinition(
        key: 'thigh',
        label: 'Thigh',
        required: _optional,
      ),
      MeasurementFieldDefinition(
        key: 'knee',
        label: 'Knee',
        required: _optional,
      ),
      MeasurementFieldDefinition(
        key: 'ankle_opening',
        label: 'Ankle opening',
        required: _optional,
      ),
    ],
  ),
  GarmentType.shirt: GarmentMeasurementTemplate(
    type: GarmentType.shirt,
    fields: [
      MeasurementFieldDefinition(
        key: 'length',
        label: 'Length',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'shoulder',
        label: 'Shoulder',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'sleeve',
        label: 'Sleeve',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'collar',
        label: 'Collar',
        required: _optional,
      ),
      MeasurementFieldDefinition(
        key: 'chest',
        label: 'Chest',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'waist',
        label: 'Waist',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'cuff',
        label: 'Cuff',
        required: _optional,
      ),
    ],
  ),
  GarmentType.waistcoat: GarmentMeasurementTemplate(
    type: GarmentType.waistcoat,
    fields: [
      MeasurementFieldDefinition(
        key: 'length',
        label: 'Length',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'shoulder',
        label: 'Shoulder',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'chest',
        label: 'Chest',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'waist',
        label: 'Waist',
        required: _required,
      ),
      MeasurementFieldDefinition(key: 'hip', label: 'Hip', required: _optional),
    ],
  ),
  GarmentType.jacket: GarmentMeasurementTemplate(
    type: GarmentType.jacket,
    fields: [
      MeasurementFieldDefinition(
        key: 'length',
        label: 'Length',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'shoulder',
        label: 'Shoulder',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'sleeve',
        label: 'Sleeve',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'chest',
        label: 'Chest',
        required: _required,
      ),
      MeasurementFieldDefinition(
        key: 'waist',
        label: 'Waist',
        required: _required,
      ),
      MeasurementFieldDefinition(key: 'hip', label: 'Hip', required: _optional),
    ],
  ),
};
