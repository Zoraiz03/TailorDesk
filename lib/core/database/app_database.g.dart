// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String key;
  final String value;
  const AppSetting({required this.id, required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({int? id, String? key, String? value}) => AppSetting(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    this.value = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? value,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    address,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, address, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       phone = Value(phone);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? address,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MeasurementProfilesTable extends MeasurementProfiles
    with TableInfo<$MeasurementProfilesTable, MeasurementProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _garmentTypeMeta = const VerificationMeta(
    'garmentType',
  );
  @override
  late final GeneratedColumn<String> garmentType = GeneratedColumn<String>(
    'garment_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileNameMeta = const VerificationMeta(
    'profileName',
  );
  @override
  late final GeneratedColumn<String> profileName = GeneratedColumn<String>(
    'profile_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    garmentType,
    profileName,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('garment_type')) {
      context.handle(
        _garmentTypeMeta,
        garmentType.isAcceptableOrUnknown(
          data['garment_type']!,
          _garmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_garmentTypeMeta);
    }
    if (data.containsKey('profile_name')) {
      context.handle(
        _profileNameMeta,
        profileName.isAcceptableOrUnknown(
          data['profile_name']!,
          _profileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasurementProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      garmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_type'],
      )!,
      profileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MeasurementProfilesTable createAlias(String alias) {
    return $MeasurementProfilesTable(attachedDatabase, alias);
  }
}

class MeasurementProfile extends DataClass
    implements Insertable<MeasurementProfile> {
  final int id;
  final int customerId;
  final String garmentType;
  final String profileName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MeasurementProfile({
    required this.id,
    required this.customerId,
    required this.garmentType,
    required this.profileName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<int>(customerId);
    map['garment_type'] = Variable<String>(garmentType);
    map['profile_name'] = Variable<String>(profileName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MeasurementProfilesCompanion toCompanion(bool nullToAbsent) {
    return MeasurementProfilesCompanion(
      id: Value(id),
      customerId: Value(customerId),
      garmentType: Value(garmentType),
      profileName: Value(profileName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MeasurementProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementProfile(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int>(json['customerId']),
      garmentType: serializer.fromJson<String>(json['garmentType']),
      profileName: serializer.fromJson<String>(json['profileName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int>(customerId),
      'garmentType': serializer.toJson<String>(garmentType),
      'profileName': serializer.toJson<String>(profileName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MeasurementProfile copyWith({
    int? id,
    int? customerId,
    String? garmentType,
    String? profileName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MeasurementProfile(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    garmentType: garmentType ?? this.garmentType,
    profileName: profileName ?? this.profileName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MeasurementProfile copyWithCompanion(MeasurementProfilesCompanion data) {
    return MeasurementProfile(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      garmentType: data.garmentType.present
          ? data.garmentType.value
          : this.garmentType,
      profileName: data.profileName.present
          ? data.profileName.value
          : this.profileName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementProfile(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('garmentType: $garmentType, ')
          ..write('profileName: $profileName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    garmentType,
    profileName,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementProfile &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.garmentType == this.garmentType &&
          other.profileName == this.profileName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MeasurementProfilesCompanion extends UpdateCompanion<MeasurementProfile> {
  final Value<int> id;
  final Value<int> customerId;
  final Value<String> garmentType;
  final Value<String> profileName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MeasurementProfilesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.garmentType = const Value.absent(),
    this.profileName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MeasurementProfilesCompanion.insert({
    this.id = const Value.absent(),
    required int customerId,
    required String garmentType,
    required String profileName,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : customerId = Value(customerId),
       garmentType = Value(garmentType),
       profileName = Value(profileName);
  static Insertable<MeasurementProfile> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<String>? garmentType,
    Expression<String>? profileName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (garmentType != null) 'garment_type': garmentType,
      if (profileName != null) 'profile_name': profileName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MeasurementProfilesCompanion copyWith({
    Value<int>? id,
    Value<int>? customerId,
    Value<String>? garmentType,
    Value<String>? profileName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MeasurementProfilesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      garmentType: garmentType ?? this.garmentType,
      profileName: profileName ?? this.profileName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (garmentType.present) {
      map['garment_type'] = Variable<String>(garmentType.value);
    }
    if (profileName.present) {
      map['profile_name'] = Variable<String>(profileName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementProfilesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('garmentType: $garmentType, ')
          ..write('profileName: $profileName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GarmentCatalogEntriesTable extends GarmentCatalogEntries
    with TableInfo<$GarmentCatalogEntriesTable, GarmentCatalogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GarmentCatalogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _garmentIdMeta = const VerificationMeta(
    'garmentId',
  );
  @override
  late final GeneratedColumn<String> garmentId = GeneratedColumn<String>(
    'garment_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameUrduMeta = const VerificationMeta(
    'displayNameUrdu',
  );
  @override
  late final GeneratedColumn<String> displayNameUrdu = GeneratedColumn<String>(
    'display_name_urdu',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultStitchingPricePaisaMeta =
      const VerificationMeta('defaultStitchingPricePaisa');
  @override
  late final GeneratedColumn<int> defaultStitchingPricePaisa =
      GeneratedColumn<int>(
        'default_stitching_price_paisa',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    garmentId,
    displayName,
    displayNameUrdu,
    enabled,
    displayOrder,
    defaultStitchingPricePaisa,
    isCustom,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'garment_catalog_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<GarmentCatalogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('garment_id')) {
      context.handle(
        _garmentIdMeta,
        garmentId.isAcceptableOrUnknown(data['garment_id']!, _garmentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_garmentIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('display_name_urdu')) {
      context.handle(
        _displayNameUrduMeta,
        displayNameUrdu.isAcceptableOrUnknown(
          data['display_name_urdu']!,
          _displayNameUrduMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    if (data.containsKey('default_stitching_price_paisa')) {
      context.handle(
        _defaultStitchingPricePaisaMeta,
        defaultStitchingPricePaisa.isAcceptableOrUnknown(
          data['default_stitching_price_paisa']!,
          _defaultStitchingPricePaisaMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {garmentId};
  @override
  GarmentCatalogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GarmentCatalogEntry(
      garmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      displayNameUrdu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name_urdu'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      defaultStitchingPricePaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_stitching_price_paisa'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GarmentCatalogEntriesTable createAlias(String alias) {
    return $GarmentCatalogEntriesTable(attachedDatabase, alias);
  }
}

class GarmentCatalogEntry extends DataClass
    implements Insertable<GarmentCatalogEntry> {
  final String garmentId;
  final String displayName;
  final String? displayNameUrdu;
  final bool enabled;
  final int displayOrder;
  final int defaultStitchingPricePaisa;
  final bool isCustom;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GarmentCatalogEntry({
    required this.garmentId,
    required this.displayName,
    this.displayNameUrdu,
    required this.enabled,
    required this.displayOrder,
    required this.defaultStitchingPricePaisa,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['garment_id'] = Variable<String>(garmentId);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || displayNameUrdu != null) {
      map['display_name_urdu'] = Variable<String>(displayNameUrdu);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['display_order'] = Variable<int>(displayOrder);
    map['default_stitching_price_paisa'] = Variable<int>(
      defaultStitchingPricePaisa,
    );
    map['is_custom'] = Variable<bool>(isCustom);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GarmentCatalogEntriesCompanion toCompanion(bool nullToAbsent) {
    return GarmentCatalogEntriesCompanion(
      garmentId: Value(garmentId),
      displayName: Value(displayName),
      displayNameUrdu: displayNameUrdu == null && nullToAbsent
          ? const Value.absent()
          : Value(displayNameUrdu),
      enabled: Value(enabled),
      displayOrder: Value(displayOrder),
      defaultStitchingPricePaisa: Value(defaultStitchingPricePaisa),
      isCustom: Value(isCustom),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GarmentCatalogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GarmentCatalogEntry(
      garmentId: serializer.fromJson<String>(json['garmentId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      displayNameUrdu: serializer.fromJson<String?>(json['displayNameUrdu']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      defaultStitchingPricePaisa: serializer.fromJson<int>(
        json['defaultStitchingPricePaisa'],
      ),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'garmentId': serializer.toJson<String>(garmentId),
      'displayName': serializer.toJson<String>(displayName),
      'displayNameUrdu': serializer.toJson<String?>(displayNameUrdu),
      'enabled': serializer.toJson<bool>(enabled),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'defaultStitchingPricePaisa': serializer.toJson<int>(
        defaultStitchingPricePaisa,
      ),
      'isCustom': serializer.toJson<bool>(isCustom),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GarmentCatalogEntry copyWith({
    String? garmentId,
    String? displayName,
    Value<String?> displayNameUrdu = const Value.absent(),
    bool? enabled,
    int? displayOrder,
    int? defaultStitchingPricePaisa,
    bool? isCustom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GarmentCatalogEntry(
    garmentId: garmentId ?? this.garmentId,
    displayName: displayName ?? this.displayName,
    displayNameUrdu: displayNameUrdu.present
        ? displayNameUrdu.value
        : this.displayNameUrdu,
    enabled: enabled ?? this.enabled,
    displayOrder: displayOrder ?? this.displayOrder,
    defaultStitchingPricePaisa:
        defaultStitchingPricePaisa ?? this.defaultStitchingPricePaisa,
    isCustom: isCustom ?? this.isCustom,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GarmentCatalogEntry copyWithCompanion(GarmentCatalogEntriesCompanion data) {
    return GarmentCatalogEntry(
      garmentId: data.garmentId.present ? data.garmentId.value : this.garmentId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      displayNameUrdu: data.displayNameUrdu.present
          ? data.displayNameUrdu.value
          : this.displayNameUrdu,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      defaultStitchingPricePaisa: data.defaultStitchingPricePaisa.present
          ? data.defaultStitchingPricePaisa.value
          : this.defaultStitchingPricePaisa,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GarmentCatalogEntry(')
          ..write('garmentId: $garmentId, ')
          ..write('displayName: $displayName, ')
          ..write('displayNameUrdu: $displayNameUrdu, ')
          ..write('enabled: $enabled, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('defaultStitchingPricePaisa: $defaultStitchingPricePaisa, ')
          ..write('isCustom: $isCustom, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    garmentId,
    displayName,
    displayNameUrdu,
    enabled,
    displayOrder,
    defaultStitchingPricePaisa,
    isCustom,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GarmentCatalogEntry &&
          other.garmentId == this.garmentId &&
          other.displayName == this.displayName &&
          other.displayNameUrdu == this.displayNameUrdu &&
          other.enabled == this.enabled &&
          other.displayOrder == this.displayOrder &&
          other.defaultStitchingPricePaisa == this.defaultStitchingPricePaisa &&
          other.isCustom == this.isCustom &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GarmentCatalogEntriesCompanion
    extends UpdateCompanion<GarmentCatalogEntry> {
  final Value<String> garmentId;
  final Value<String> displayName;
  final Value<String?> displayNameUrdu;
  final Value<bool> enabled;
  final Value<int> displayOrder;
  final Value<int> defaultStitchingPricePaisa;
  final Value<bool> isCustom;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GarmentCatalogEntriesCompanion({
    this.garmentId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.displayNameUrdu = const Value.absent(),
    this.enabled = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.defaultStitchingPricePaisa = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GarmentCatalogEntriesCompanion.insert({
    required String garmentId,
    required String displayName,
    this.displayNameUrdu = const Value.absent(),
    this.enabled = const Value.absent(),
    required int displayOrder,
    this.defaultStitchingPricePaisa = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : garmentId = Value(garmentId),
       displayName = Value(displayName),
       displayOrder = Value(displayOrder);
  static Insertable<GarmentCatalogEntry> custom({
    Expression<String>? garmentId,
    Expression<String>? displayName,
    Expression<String>? displayNameUrdu,
    Expression<bool>? enabled,
    Expression<int>? displayOrder,
    Expression<int>? defaultStitchingPricePaisa,
    Expression<bool>? isCustom,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (garmentId != null) 'garment_id': garmentId,
      if (displayName != null) 'display_name': displayName,
      if (displayNameUrdu != null) 'display_name_urdu': displayNameUrdu,
      if (enabled != null) 'enabled': enabled,
      if (displayOrder != null) 'display_order': displayOrder,
      if (defaultStitchingPricePaisa != null)
        'default_stitching_price_paisa': defaultStitchingPricePaisa,
      if (isCustom != null) 'is_custom': isCustom,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GarmentCatalogEntriesCompanion copyWith({
    Value<String>? garmentId,
    Value<String>? displayName,
    Value<String?>? displayNameUrdu,
    Value<bool>? enabled,
    Value<int>? displayOrder,
    Value<int>? defaultStitchingPricePaisa,
    Value<bool>? isCustom,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GarmentCatalogEntriesCompanion(
      garmentId: garmentId ?? this.garmentId,
      displayName: displayName ?? this.displayName,
      displayNameUrdu: displayNameUrdu ?? this.displayNameUrdu,
      enabled: enabled ?? this.enabled,
      displayOrder: displayOrder ?? this.displayOrder,
      defaultStitchingPricePaisa:
          defaultStitchingPricePaisa ?? this.defaultStitchingPricePaisa,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (garmentId.present) {
      map['garment_id'] = Variable<String>(garmentId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (displayNameUrdu.present) {
      map['display_name_urdu'] = Variable<String>(displayNameUrdu.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (defaultStitchingPricePaisa.present) {
      map['default_stitching_price_paisa'] = Variable<int>(
        defaultStitchingPricePaisa.value,
      );
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GarmentCatalogEntriesCompanion(')
          ..write('garmentId: $garmentId, ')
          ..write('displayName: $displayName, ')
          ..write('displayNameUrdu: $displayNameUrdu, ')
          ..write('enabled: $enabled, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('defaultStitchingPricePaisa: $defaultStitchingPricePaisa, ')
          ..write('isCustom: $isCustom, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurementTemplateVersionsTable extends MeasurementTemplateVersions
    with
        TableInfo<
          $MeasurementTemplateVersionsTable,
          MeasurementTemplateVersion
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementTemplateVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _garmentIdMeta = const VerificationMeta(
    'garmentId',
  );
  @override
  late final GeneratedColumn<String> garmentId = GeneratedColumn<String>(
    'garment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES garment_catalog_entries (garment_id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _versionNumberMeta = const VerificationMeta(
    'versionNumber',
  );
  @override
  late final GeneratedColumn<int> versionNumber = GeneratedColumn<int>(
    'version_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementConventionMeta =
      const VerificationMeta('measurementConvention');
  @override
  late final GeneratedColumn<String> measurementConvention =
      GeneratedColumn<String>(
        'measurement_convention',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1,
          maxTextLength: 30,
        ),
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    garmentId,
    versionNumber,
    measurementConvention,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_template_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementTemplateVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('garment_id')) {
      context.handle(
        _garmentIdMeta,
        garmentId.isAcceptableOrUnknown(data['garment_id']!, _garmentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_garmentIdMeta);
    }
    if (data.containsKey('version_number')) {
      context.handle(
        _versionNumberMeta,
        versionNumber.isAcceptableOrUnknown(
          data['version_number']!,
          _versionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionNumberMeta);
    }
    if (data.containsKey('measurement_convention')) {
      context.handle(
        _measurementConventionMeta,
        measurementConvention.isAcceptableOrUnknown(
          data['measurement_convention']!,
          _measurementConventionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementConventionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {garmentId, versionNumber},
  ];
  @override
  MeasurementTemplateVersion map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementTemplateVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      garmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_id'],
      )!,
      versionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version_number'],
      )!,
      measurementConvention: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_convention'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MeasurementTemplateVersionsTable createAlias(String alias) {
    return $MeasurementTemplateVersionsTable(attachedDatabase, alias);
  }
}

class MeasurementTemplateVersion extends DataClass
    implements Insertable<MeasurementTemplateVersion> {
  final int id;
  final String garmentId;
  final int versionNumber;
  final String measurementConvention;
  final DateTime createdAt;
  const MeasurementTemplateVersion({
    required this.id,
    required this.garmentId,
    required this.versionNumber,
    required this.measurementConvention,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['garment_id'] = Variable<String>(garmentId);
    map['version_number'] = Variable<int>(versionNumber);
    map['measurement_convention'] = Variable<String>(measurementConvention);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MeasurementTemplateVersionsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementTemplateVersionsCompanion(
      id: Value(id),
      garmentId: Value(garmentId),
      versionNumber: Value(versionNumber),
      measurementConvention: Value(measurementConvention),
      createdAt: Value(createdAt),
    );
  }

  factory MeasurementTemplateVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementTemplateVersion(
      id: serializer.fromJson<int>(json['id']),
      garmentId: serializer.fromJson<String>(json['garmentId']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
      measurementConvention: serializer.fromJson<String>(
        json['measurementConvention'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'garmentId': serializer.toJson<String>(garmentId),
      'versionNumber': serializer.toJson<int>(versionNumber),
      'measurementConvention': serializer.toJson<String>(measurementConvention),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MeasurementTemplateVersion copyWith({
    int? id,
    String? garmentId,
    int? versionNumber,
    String? measurementConvention,
    DateTime? createdAt,
  }) => MeasurementTemplateVersion(
    id: id ?? this.id,
    garmentId: garmentId ?? this.garmentId,
    versionNumber: versionNumber ?? this.versionNumber,
    measurementConvention: measurementConvention ?? this.measurementConvention,
    createdAt: createdAt ?? this.createdAt,
  );
  MeasurementTemplateVersion copyWithCompanion(
    MeasurementTemplateVersionsCompanion data,
  ) {
    return MeasurementTemplateVersion(
      id: data.id.present ? data.id.value : this.id,
      garmentId: data.garmentId.present ? data.garmentId.value : this.garmentId,
      versionNumber: data.versionNumber.present
          ? data.versionNumber.value
          : this.versionNumber,
      measurementConvention: data.measurementConvention.present
          ? data.measurementConvention.value
          : this.measurementConvention,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementTemplateVersion(')
          ..write('id: $id, ')
          ..write('garmentId: $garmentId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('measurementConvention: $measurementConvention, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    garmentId,
    versionNumber,
    measurementConvention,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementTemplateVersion &&
          other.id == this.id &&
          other.garmentId == this.garmentId &&
          other.versionNumber == this.versionNumber &&
          other.measurementConvention == this.measurementConvention &&
          other.createdAt == this.createdAt);
}

class MeasurementTemplateVersionsCompanion
    extends UpdateCompanion<MeasurementTemplateVersion> {
  final Value<int> id;
  final Value<String> garmentId;
  final Value<int> versionNumber;
  final Value<String> measurementConvention;
  final Value<DateTime> createdAt;
  const MeasurementTemplateVersionsCompanion({
    this.id = const Value.absent(),
    this.garmentId = const Value.absent(),
    this.versionNumber = const Value.absent(),
    this.measurementConvention = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MeasurementTemplateVersionsCompanion.insert({
    this.id = const Value.absent(),
    required String garmentId,
    required int versionNumber,
    required String measurementConvention,
    this.createdAt = const Value.absent(),
  }) : garmentId = Value(garmentId),
       versionNumber = Value(versionNumber),
       measurementConvention = Value(measurementConvention);
  static Insertable<MeasurementTemplateVersion> custom({
    Expression<int>? id,
    Expression<String>? garmentId,
    Expression<int>? versionNumber,
    Expression<String>? measurementConvention,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (garmentId != null) 'garment_id': garmentId,
      if (versionNumber != null) 'version_number': versionNumber,
      if (measurementConvention != null)
        'measurement_convention': measurementConvention,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MeasurementTemplateVersionsCompanion copyWith({
    Value<int>? id,
    Value<String>? garmentId,
    Value<int>? versionNumber,
    Value<String>? measurementConvention,
    Value<DateTime>? createdAt,
  }) {
    return MeasurementTemplateVersionsCompanion(
      id: id ?? this.id,
      garmentId: garmentId ?? this.garmentId,
      versionNumber: versionNumber ?? this.versionNumber,
      measurementConvention:
          measurementConvention ?? this.measurementConvention,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (garmentId.present) {
      map['garment_id'] = Variable<String>(garmentId.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (measurementConvention.present) {
      map['measurement_convention'] = Variable<String>(
        measurementConvention.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementTemplateVersionsCompanion(')
          ..write('id: $id, ')
          ..write('garmentId: $garmentId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('measurementConvention: $measurementConvention, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MeasurementRevisionsTable extends MeasurementRevisions
    with TableInfo<$MeasurementRevisionsTable, MeasurementRevision> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementRevisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES measurement_profiles (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _revisionNumberMeta = const VerificationMeta(
    'revisionNumber',
  );
  @override
  late final GeneratedColumn<int> revisionNumber = GeneratedColumn<int>(
    'revision_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _garmentTypeMeta = const VerificationMeta(
    'garmentType',
  );
  @override
  late final GeneratedColumn<String> garmentType = GeneratedColumn<String>(
    'garment_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _garmentLabelEnglishMeta =
      const VerificationMeta('garmentLabelEnglish');
  @override
  late final GeneratedColumn<String> garmentLabelEnglish =
      GeneratedColumn<String>(
        'garment_label_english',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _garmentLabelUrduMeta = const VerificationMeta(
    'garmentLabelUrdu',
  );
  @override
  late final GeneratedColumn<String> garmentLabelUrdu = GeneratedColumn<String>(
    'garment_label_urdu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _profileNameMeta = const VerificationMeta(
    'profileName',
  );
  @override
  late final GeneratedColumn<String> profileName = GeneratedColumn<String>(
    'profile_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementBasisMeta = const VerificationMeta(
    'measurementBasis',
  );
  @override
  late final GeneratedColumn<String> measurementBasis = GeneratedColumn<String>(
    'measurement_basis',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateVersionIdMeta = const VerificationMeta(
    'templateVersionId',
  );
  @override
  late final GeneratedColumn<int> templateVersionId = GeneratedColumn<int>(
    'template_version_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES measurement_template_versions (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _fieldDefinitionsJsonMeta =
      const VerificationMeta('fieldDefinitionsJson');
  @override
  late final GeneratedColumn<String> fieldDefinitionsJson =
      GeneratedColumn<String>(
        'field_definitions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _fitPreferenceMeta = const VerificationMeta(
    'fitPreference',
  );
  @override
  late final GeneratedColumn<String> fitPreference = GeneratedColumn<String>(
    'fit_preference',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _styleInstructionsMeta = const VerificationMeta(
    'styleInstructions',
  );
  @override
  late final GeneratedColumn<String> styleInstructions =
      GeneratedColumn<String>(
        'style_instructions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    revisionNumber,
    garmentType,
    garmentLabelEnglish,
    garmentLabelUrdu,
    profileName,
    unit,
    measurementBasis,
    valuesJson,
    templateVersionId,
    fieldDefinitionsJson,
    fitPreference,
    styleInstructions,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_revisions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementRevision> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('revision_number')) {
      context.handle(
        _revisionNumberMeta,
        revisionNumber.isAcceptableOrUnknown(
          data['revision_number']!,
          _revisionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_revisionNumberMeta);
    }
    if (data.containsKey('garment_type')) {
      context.handle(
        _garmentTypeMeta,
        garmentType.isAcceptableOrUnknown(
          data['garment_type']!,
          _garmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_garmentTypeMeta);
    }
    if (data.containsKey('garment_label_english')) {
      context.handle(
        _garmentLabelEnglishMeta,
        garmentLabelEnglish.isAcceptableOrUnknown(
          data['garment_label_english']!,
          _garmentLabelEnglishMeta,
        ),
      );
    }
    if (data.containsKey('garment_label_urdu')) {
      context.handle(
        _garmentLabelUrduMeta,
        garmentLabelUrdu.isAcceptableOrUnknown(
          data['garment_label_urdu']!,
          _garmentLabelUrduMeta,
        ),
      );
    }
    if (data.containsKey('profile_name')) {
      context.handle(
        _profileNameMeta,
        profileName.isAcceptableOrUnknown(
          data['profile_name']!,
          _profileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileNameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('measurement_basis')) {
      context.handle(
        _measurementBasisMeta,
        measurementBasis.isAcceptableOrUnknown(
          data['measurement_basis']!,
          _measurementBasisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementBasisMeta);
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valuesJsonMeta);
    }
    if (data.containsKey('template_version_id')) {
      context.handle(
        _templateVersionIdMeta,
        templateVersionId.isAcceptableOrUnknown(
          data['template_version_id']!,
          _templateVersionIdMeta,
        ),
      );
    }
    if (data.containsKey('field_definitions_json')) {
      context.handle(
        _fieldDefinitionsJsonMeta,
        fieldDefinitionsJson.isAcceptableOrUnknown(
          data['field_definitions_json']!,
          _fieldDefinitionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('fit_preference')) {
      context.handle(
        _fitPreferenceMeta,
        fitPreference.isAcceptableOrUnknown(
          data['fit_preference']!,
          _fitPreferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fitPreferenceMeta);
    }
    if (data.containsKey('style_instructions')) {
      context.handle(
        _styleInstructionsMeta,
        styleInstructions.isAcceptableOrUnknown(
          data['style_instructions']!,
          _styleInstructionsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, revisionNumber},
  ];
  @override
  MeasurementRevision map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementRevision(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      revisionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision_number'],
      )!,
      garmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_type'],
      )!,
      garmentLabelEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_label_english'],
      )!,
      garmentLabelUrdu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_label_urdu'],
      )!,
      profileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      measurementBasis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_basis'],
      )!,
      valuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values_json'],
      )!,
      templateVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_version_id'],
      ),
      fieldDefinitionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_definitions_json'],
      )!,
      fitPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fit_preference'],
      )!,
      styleInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style_instructions'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MeasurementRevisionsTable createAlias(String alias) {
    return $MeasurementRevisionsTable(attachedDatabase, alias);
  }
}

class MeasurementRevision extends DataClass
    implements Insertable<MeasurementRevision> {
  final int id;
  final int profileId;
  final int revisionNumber;
  final String garmentType;
  final String garmentLabelEnglish;
  final String garmentLabelUrdu;
  final String profileName;
  final String unit;
  final String measurementBasis;
  final String valuesJson;
  final int? templateVersionId;
  final String fieldDefinitionsJson;
  final String fitPreference;
  final String styleInstructions;
  final String notes;
  final DateTime createdAt;
  const MeasurementRevision({
    required this.id,
    required this.profileId,
    required this.revisionNumber,
    required this.garmentType,
    required this.garmentLabelEnglish,
    required this.garmentLabelUrdu,
    required this.profileName,
    required this.unit,
    required this.measurementBasis,
    required this.valuesJson,
    this.templateVersionId,
    required this.fieldDefinitionsJson,
    required this.fitPreference,
    required this.styleInstructions,
    required this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['revision_number'] = Variable<int>(revisionNumber);
    map['garment_type'] = Variable<String>(garmentType);
    map['garment_label_english'] = Variable<String>(garmentLabelEnglish);
    map['garment_label_urdu'] = Variable<String>(garmentLabelUrdu);
    map['profile_name'] = Variable<String>(profileName);
    map['unit'] = Variable<String>(unit);
    map['measurement_basis'] = Variable<String>(measurementBasis);
    map['values_json'] = Variable<String>(valuesJson);
    if (!nullToAbsent || templateVersionId != null) {
      map['template_version_id'] = Variable<int>(templateVersionId);
    }
    map['field_definitions_json'] = Variable<String>(fieldDefinitionsJson);
    map['fit_preference'] = Variable<String>(fitPreference);
    map['style_instructions'] = Variable<String>(styleInstructions);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MeasurementRevisionsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementRevisionsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      revisionNumber: Value(revisionNumber),
      garmentType: Value(garmentType),
      garmentLabelEnglish: Value(garmentLabelEnglish),
      garmentLabelUrdu: Value(garmentLabelUrdu),
      profileName: Value(profileName),
      unit: Value(unit),
      measurementBasis: Value(measurementBasis),
      valuesJson: Value(valuesJson),
      templateVersionId: templateVersionId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateVersionId),
      fieldDefinitionsJson: Value(fieldDefinitionsJson),
      fitPreference: Value(fitPreference),
      styleInstructions: Value(styleInstructions),
      notes: Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory MeasurementRevision.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementRevision(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      revisionNumber: serializer.fromJson<int>(json['revisionNumber']),
      garmentType: serializer.fromJson<String>(json['garmentType']),
      garmentLabelEnglish: serializer.fromJson<String>(
        json['garmentLabelEnglish'],
      ),
      garmentLabelUrdu: serializer.fromJson<String>(json['garmentLabelUrdu']),
      profileName: serializer.fromJson<String>(json['profileName']),
      unit: serializer.fromJson<String>(json['unit']),
      measurementBasis: serializer.fromJson<String>(json['measurementBasis']),
      valuesJson: serializer.fromJson<String>(json['valuesJson']),
      templateVersionId: serializer.fromJson<int?>(json['templateVersionId']),
      fieldDefinitionsJson: serializer.fromJson<String>(
        json['fieldDefinitionsJson'],
      ),
      fitPreference: serializer.fromJson<String>(json['fitPreference']),
      styleInstructions: serializer.fromJson<String>(json['styleInstructions']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'revisionNumber': serializer.toJson<int>(revisionNumber),
      'garmentType': serializer.toJson<String>(garmentType),
      'garmentLabelEnglish': serializer.toJson<String>(garmentLabelEnglish),
      'garmentLabelUrdu': serializer.toJson<String>(garmentLabelUrdu),
      'profileName': serializer.toJson<String>(profileName),
      'unit': serializer.toJson<String>(unit),
      'measurementBasis': serializer.toJson<String>(measurementBasis),
      'valuesJson': serializer.toJson<String>(valuesJson),
      'templateVersionId': serializer.toJson<int?>(templateVersionId),
      'fieldDefinitionsJson': serializer.toJson<String>(fieldDefinitionsJson),
      'fitPreference': serializer.toJson<String>(fitPreference),
      'styleInstructions': serializer.toJson<String>(styleInstructions),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MeasurementRevision copyWith({
    int? id,
    int? profileId,
    int? revisionNumber,
    String? garmentType,
    String? garmentLabelEnglish,
    String? garmentLabelUrdu,
    String? profileName,
    String? unit,
    String? measurementBasis,
    String? valuesJson,
    Value<int?> templateVersionId = const Value.absent(),
    String? fieldDefinitionsJson,
    String? fitPreference,
    String? styleInstructions,
    String? notes,
    DateTime? createdAt,
  }) => MeasurementRevision(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    revisionNumber: revisionNumber ?? this.revisionNumber,
    garmentType: garmentType ?? this.garmentType,
    garmentLabelEnglish: garmentLabelEnglish ?? this.garmentLabelEnglish,
    garmentLabelUrdu: garmentLabelUrdu ?? this.garmentLabelUrdu,
    profileName: profileName ?? this.profileName,
    unit: unit ?? this.unit,
    measurementBasis: measurementBasis ?? this.measurementBasis,
    valuesJson: valuesJson ?? this.valuesJson,
    templateVersionId: templateVersionId.present
        ? templateVersionId.value
        : this.templateVersionId,
    fieldDefinitionsJson: fieldDefinitionsJson ?? this.fieldDefinitionsJson,
    fitPreference: fitPreference ?? this.fitPreference,
    styleInstructions: styleInstructions ?? this.styleInstructions,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  MeasurementRevision copyWithCompanion(MeasurementRevisionsCompanion data) {
    return MeasurementRevision(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      revisionNumber: data.revisionNumber.present
          ? data.revisionNumber.value
          : this.revisionNumber,
      garmentType: data.garmentType.present
          ? data.garmentType.value
          : this.garmentType,
      garmentLabelEnglish: data.garmentLabelEnglish.present
          ? data.garmentLabelEnglish.value
          : this.garmentLabelEnglish,
      garmentLabelUrdu: data.garmentLabelUrdu.present
          ? data.garmentLabelUrdu.value
          : this.garmentLabelUrdu,
      profileName: data.profileName.present
          ? data.profileName.value
          : this.profileName,
      unit: data.unit.present ? data.unit.value : this.unit,
      measurementBasis: data.measurementBasis.present
          ? data.measurementBasis.value
          : this.measurementBasis,
      valuesJson: data.valuesJson.present
          ? data.valuesJson.value
          : this.valuesJson,
      templateVersionId: data.templateVersionId.present
          ? data.templateVersionId.value
          : this.templateVersionId,
      fieldDefinitionsJson: data.fieldDefinitionsJson.present
          ? data.fieldDefinitionsJson.value
          : this.fieldDefinitionsJson,
      fitPreference: data.fitPreference.present
          ? data.fitPreference.value
          : this.fitPreference,
      styleInstructions: data.styleInstructions.present
          ? data.styleInstructions.value
          : this.styleInstructions,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementRevision(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('revisionNumber: $revisionNumber, ')
          ..write('garmentType: $garmentType, ')
          ..write('garmentLabelEnglish: $garmentLabelEnglish, ')
          ..write('garmentLabelUrdu: $garmentLabelUrdu, ')
          ..write('profileName: $profileName, ')
          ..write('unit: $unit, ')
          ..write('measurementBasis: $measurementBasis, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('templateVersionId: $templateVersionId, ')
          ..write('fieldDefinitionsJson: $fieldDefinitionsJson, ')
          ..write('fitPreference: $fitPreference, ')
          ..write('styleInstructions: $styleInstructions, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    revisionNumber,
    garmentType,
    garmentLabelEnglish,
    garmentLabelUrdu,
    profileName,
    unit,
    measurementBasis,
    valuesJson,
    templateVersionId,
    fieldDefinitionsJson,
    fitPreference,
    styleInstructions,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementRevision &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.revisionNumber == this.revisionNumber &&
          other.garmentType == this.garmentType &&
          other.garmentLabelEnglish == this.garmentLabelEnglish &&
          other.garmentLabelUrdu == this.garmentLabelUrdu &&
          other.profileName == this.profileName &&
          other.unit == this.unit &&
          other.measurementBasis == this.measurementBasis &&
          other.valuesJson == this.valuesJson &&
          other.templateVersionId == this.templateVersionId &&
          other.fieldDefinitionsJson == this.fieldDefinitionsJson &&
          other.fitPreference == this.fitPreference &&
          other.styleInstructions == this.styleInstructions &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class MeasurementRevisionsCompanion
    extends UpdateCompanion<MeasurementRevision> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> revisionNumber;
  final Value<String> garmentType;
  final Value<String> garmentLabelEnglish;
  final Value<String> garmentLabelUrdu;
  final Value<String> profileName;
  final Value<String> unit;
  final Value<String> measurementBasis;
  final Value<String> valuesJson;
  final Value<int?> templateVersionId;
  final Value<String> fieldDefinitionsJson;
  final Value<String> fitPreference;
  final Value<String> styleInstructions;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  const MeasurementRevisionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.revisionNumber = const Value.absent(),
    this.garmentType = const Value.absent(),
    this.garmentLabelEnglish = const Value.absent(),
    this.garmentLabelUrdu = const Value.absent(),
    this.profileName = const Value.absent(),
    this.unit = const Value.absent(),
    this.measurementBasis = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.templateVersionId = const Value.absent(),
    this.fieldDefinitionsJson = const Value.absent(),
    this.fitPreference = const Value.absent(),
    this.styleInstructions = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MeasurementRevisionsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required int revisionNumber,
    required String garmentType,
    this.garmentLabelEnglish = const Value.absent(),
    this.garmentLabelUrdu = const Value.absent(),
    required String profileName,
    required String unit,
    required String measurementBasis,
    required String valuesJson,
    this.templateVersionId = const Value.absent(),
    this.fieldDefinitionsJson = const Value.absent(),
    required String fitPreference,
    this.styleInstructions = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : profileId = Value(profileId),
       revisionNumber = Value(revisionNumber),
       garmentType = Value(garmentType),
       profileName = Value(profileName),
       unit = Value(unit),
       measurementBasis = Value(measurementBasis),
       valuesJson = Value(valuesJson),
       fitPreference = Value(fitPreference);
  static Insertable<MeasurementRevision> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? revisionNumber,
    Expression<String>? garmentType,
    Expression<String>? garmentLabelEnglish,
    Expression<String>? garmentLabelUrdu,
    Expression<String>? profileName,
    Expression<String>? unit,
    Expression<String>? measurementBasis,
    Expression<String>? valuesJson,
    Expression<int>? templateVersionId,
    Expression<String>? fieldDefinitionsJson,
    Expression<String>? fitPreference,
    Expression<String>? styleInstructions,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (revisionNumber != null) 'revision_number': revisionNumber,
      if (garmentType != null) 'garment_type': garmentType,
      if (garmentLabelEnglish != null)
        'garment_label_english': garmentLabelEnglish,
      if (garmentLabelUrdu != null) 'garment_label_urdu': garmentLabelUrdu,
      if (profileName != null) 'profile_name': profileName,
      if (unit != null) 'unit': unit,
      if (measurementBasis != null) 'measurement_basis': measurementBasis,
      if (valuesJson != null) 'values_json': valuesJson,
      if (templateVersionId != null) 'template_version_id': templateVersionId,
      if (fieldDefinitionsJson != null)
        'field_definitions_json': fieldDefinitionsJson,
      if (fitPreference != null) 'fit_preference': fitPreference,
      if (styleInstructions != null) 'style_instructions': styleInstructions,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MeasurementRevisionsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? revisionNumber,
    Value<String>? garmentType,
    Value<String>? garmentLabelEnglish,
    Value<String>? garmentLabelUrdu,
    Value<String>? profileName,
    Value<String>? unit,
    Value<String>? measurementBasis,
    Value<String>? valuesJson,
    Value<int?>? templateVersionId,
    Value<String>? fieldDefinitionsJson,
    Value<String>? fitPreference,
    Value<String>? styleInstructions,
    Value<String>? notes,
    Value<DateTime>? createdAt,
  }) {
    return MeasurementRevisionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      revisionNumber: revisionNumber ?? this.revisionNumber,
      garmentType: garmentType ?? this.garmentType,
      garmentLabelEnglish: garmentLabelEnglish ?? this.garmentLabelEnglish,
      garmentLabelUrdu: garmentLabelUrdu ?? this.garmentLabelUrdu,
      profileName: profileName ?? this.profileName,
      unit: unit ?? this.unit,
      measurementBasis: measurementBasis ?? this.measurementBasis,
      valuesJson: valuesJson ?? this.valuesJson,
      templateVersionId: templateVersionId ?? this.templateVersionId,
      fieldDefinitionsJson: fieldDefinitionsJson ?? this.fieldDefinitionsJson,
      fitPreference: fitPreference ?? this.fitPreference,
      styleInstructions: styleInstructions ?? this.styleInstructions,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (revisionNumber.present) {
      map['revision_number'] = Variable<int>(revisionNumber.value);
    }
    if (garmentType.present) {
      map['garment_type'] = Variable<String>(garmentType.value);
    }
    if (garmentLabelEnglish.present) {
      map['garment_label_english'] = Variable<String>(
        garmentLabelEnglish.value,
      );
    }
    if (garmentLabelUrdu.present) {
      map['garment_label_urdu'] = Variable<String>(garmentLabelUrdu.value);
    }
    if (profileName.present) {
      map['profile_name'] = Variable<String>(profileName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (measurementBasis.present) {
      map['measurement_basis'] = Variable<String>(measurementBasis.value);
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    if (templateVersionId.present) {
      map['template_version_id'] = Variable<int>(templateVersionId.value);
    }
    if (fieldDefinitionsJson.present) {
      map['field_definitions_json'] = Variable<String>(
        fieldDefinitionsJson.value,
      );
    }
    if (fitPreference.present) {
      map['fit_preference'] = Variable<String>(fitPreference.value);
    }
    if (styleInstructions.present) {
      map['style_instructions'] = Variable<String>(styleInstructions.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementRevisionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('revisionNumber: $revisionNumber, ')
          ..write('garmentType: $garmentType, ')
          ..write('garmentLabelEnglish: $garmentLabelEnglish, ')
          ..write('garmentLabelUrdu: $garmentLabelUrdu, ')
          ..write('profileName: $profileName, ')
          ..write('unit: $unit, ')
          ..write('measurementBasis: $measurementBasis, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('templateVersionId: $templateVersionId, ')
          ..write('fieldDefinitionsJson: $fieldDefinitionsJson, ')
          ..write('fitPreference: $fitPreference, ')
          ..write('styleInstructions: $styleInstructions, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _submissionKeyMeta = const VerificationMeta(
    'submissionKey',
  );
  @override
  late final GeneratedColumn<String> submissionKey = GeneratedColumn<String>(
    'submission_key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _bookingDateMeta = const VerificationMeta(
    'bookingDate',
  );
  @override
  late final GeneratedColumn<DateTime> bookingDate = GeneratedColumn<DateTime>(
    'booking_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryDateMeta = const VerificationMeta(
    'deliveryDate',
  );
  @override
  late final GeneratedColumn<DateTime> deliveryDate = GeneratedColumn<DateTime>(
    'delivery_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderNumber,
    submissionKey,
    customerId,
    bookingDate,
    deliveryDate,
    notes,
    cancelledAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('submission_key')) {
      context.handle(
        _submissionKeyMeta,
        submissionKey.isAcceptableOrUnknown(
          data['submission_key']!,
          _submissionKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submissionKeyMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('booking_date')) {
      context.handle(
        _bookingDateMeta,
        bookingDate.isAcceptableOrUnknown(
          data['booking_date']!,
          _bookingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bookingDateMeta);
    }
    if (data.containsKey('delivery_date')) {
      context.handle(
        _deliveryDateMeta,
        deliveryDate.isAcceptableOrUnknown(
          data['delivery_date']!,
          _deliveryDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deliveryDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_number'],
      )!,
      submissionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submission_key'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      bookingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}booking_date'],
      )!,
      deliveryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivery_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final String orderNumber;
  final String submissionKey;
  final int customerId;
  final DateTime bookingDate;
  final DateTime deliveryDate;
  final String notes;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Order({
    required this.id,
    required this.orderNumber,
    required this.submissionKey,
    required this.customerId,
    required this.bookingDate,
    required this.deliveryDate,
    required this.notes,
    this.cancelledAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_number'] = Variable<String>(orderNumber);
    map['submission_key'] = Variable<String>(submissionKey);
    map['customer_id'] = Variable<int>(customerId);
    map['booking_date'] = Variable<DateTime>(bookingDate);
    map['delivery_date'] = Variable<DateTime>(deliveryDate);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      submissionKey: Value(submissionKey),
      customerId: Value(customerId),
      bookingDate: Value(bookingDate),
      deliveryDate: Value(deliveryDate),
      notes: Value(notes),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      submissionKey: serializer.fromJson<String>(json['submissionKey']),
      customerId: serializer.fromJson<int>(json['customerId']),
      bookingDate: serializer.fromJson<DateTime>(json['bookingDate']),
      deliveryDate: serializer.fromJson<DateTime>(json['deliveryDate']),
      notes: serializer.fromJson<String>(json['notes']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'submissionKey': serializer.toJson<String>(submissionKey),
      'customerId': serializer.toJson<int>(customerId),
      'bookingDate': serializer.toJson<DateTime>(bookingDate),
      'deliveryDate': serializer.toJson<DateTime>(deliveryDate),
      'notes': serializer.toJson<String>(notes),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Order copyWith({
    int? id,
    String? orderNumber,
    String? submissionKey,
    int? customerId,
    DateTime? bookingDate,
    DateTime? deliveryDate,
    String? notes,
    Value<DateTime?> cancelledAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Order(
    id: id ?? this.id,
    orderNumber: orderNumber ?? this.orderNumber,
    submissionKey: submissionKey ?? this.submissionKey,
    customerId: customerId ?? this.customerId,
    bookingDate: bookingDate ?? this.bookingDate,
    deliveryDate: deliveryDate ?? this.deliveryDate,
    notes: notes ?? this.notes,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      orderNumber: data.orderNumber.present
          ? data.orderNumber.value
          : this.orderNumber,
      submissionKey: data.submissionKey.present
          ? data.submissionKey.value
          : this.submissionKey,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      bookingDate: data.bookingDate.present
          ? data.bookingDate.value
          : this.bookingDate,
      deliveryDate: data.deliveryDate.present
          ? data.deliveryDate.value
          : this.deliveryDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('submissionKey: $submissionKey, ')
          ..write('customerId: $customerId, ')
          ..write('bookingDate: $bookingDate, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('notes: $notes, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderNumber,
    submissionKey,
    customerId,
    bookingDate,
    deliveryDate,
    notes,
    cancelledAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.submissionKey == this.submissionKey &&
          other.customerId == this.customerId &&
          other.bookingDate == this.bookingDate &&
          other.deliveryDate == this.deliveryDate &&
          other.notes == this.notes &&
          other.cancelledAt == this.cancelledAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> orderNumber;
  final Value<String> submissionKey;
  final Value<int> customerId;
  final Value<DateTime> bookingDate;
  final Value<DateTime> deliveryDate;
  final Value<String> notes;
  final Value<DateTime?> cancelledAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.submissionKey = const Value.absent(),
    this.customerId = const Value.absent(),
    this.bookingDate = const Value.absent(),
    this.deliveryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String orderNumber,
    required String submissionKey,
    required int customerId,
    required DateTime bookingDate,
    required DateTime deliveryDate,
    this.notes = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : orderNumber = Value(orderNumber),
       submissionKey = Value(submissionKey),
       customerId = Value(customerId),
       bookingDate = Value(bookingDate),
       deliveryDate = Value(deliveryDate);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? orderNumber,
    Expression<String>? submissionKey,
    Expression<int>? customerId,
    Expression<DateTime>? bookingDate,
    Expression<DateTime>? deliveryDate,
    Expression<String>? notes,
    Expression<DateTime>? cancelledAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (submissionKey != null) 'submission_key': submissionKey,
      if (customerId != null) 'customer_id': customerId,
      if (bookingDate != null) 'booking_date': bookingDate,
      if (deliveryDate != null) 'delivery_date': deliveryDate,
      if (notes != null) 'notes': notes,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? orderNumber,
    Value<String>? submissionKey,
    Value<int>? customerId,
    Value<DateTime>? bookingDate,
    Value<DateTime>? deliveryDate,
    Value<String>? notes,
    Value<DateTime?>? cancelledAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      submissionKey: submissionKey ?? this.submissionKey,
      customerId: customerId ?? this.customerId,
      bookingDate: bookingDate ?? this.bookingDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (submissionKey.present) {
      map['submission_key'] = Variable<String>(submissionKey.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (bookingDate.present) {
      map['booking_date'] = Variable<DateTime>(bookingDate.value);
    }
    if (deliveryDate.present) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('submissionKey: $submissionKey, ')
          ..write('customerId: $customerId, ')
          ..write('bookingDate: $bookingDate, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('notes: $notes, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _measurementRevisionIdMeta =
      const VerificationMeta('measurementRevisionId');
  @override
  late final GeneratedColumn<int> measurementRevisionId = GeneratedColumn<int>(
    'measurement_revision_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES measurement_revisions (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _garmentTypeMeta = const VerificationMeta(
    'garmentType',
  );
  @override
  late final GeneratedColumn<String> garmentType = GeneratedColumn<String>(
    'garment_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _garmentLabelEnglishMeta =
      const VerificationMeta('garmentLabelEnglish');
  @override
  late final GeneratedColumn<String> garmentLabelEnglish =
      GeneratedColumn<String>(
        'garment_label_english',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _garmentLabelUrduMeta = const VerificationMeta(
    'garmentLabelUrdu',
  );
  @override
  late final GeneratedColumn<String> garmentLabelUrdu = GeneratedColumn<String>(
    'garment_label_urdu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementProfileNameMeta =
      const VerificationMeta('measurementProfileName');
  @override
  late final GeneratedColumn<String> measurementProfileName =
      GeneratedColumn<String>(
        'measurement_profile_name',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1,
          maxTextLength: 100,
        ),
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _measurementUnitMeta = const VerificationMeta(
    'measurementUnit',
  );
  @override
  late final GeneratedColumn<String> measurementUnit = GeneratedColumn<String>(
    'measurement_unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementBasisMeta = const VerificationMeta(
    'measurementBasis',
  );
  @override
  late final GeneratedColumn<String> measurementBasis = GeneratedColumn<String>(
    'measurement_basis',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementValuesJsonMeta =
      const VerificationMeta('measurementValuesJson');
  @override
  late final GeneratedColumn<String> measurementValuesJson =
      GeneratedColumn<String>(
        'measurement_values_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _measurementFieldDefinitionsJsonMeta =
      const VerificationMeta('measurementFieldDefinitionsJson');
  @override
  late final GeneratedColumn<String> measurementFieldDefinitionsJson =
      GeneratedColumn<String>(
        'measurement_field_definitions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _fitPreferenceMeta = const VerificationMeta(
    'fitPreference',
  );
  @override
  late final GeneratedColumn<String> fitPreference = GeneratedColumn<String>(
    'fit_preference',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementNotesMeta = const VerificationMeta(
    'measurementNotes',
  );
  @override
  late final GeneratedColumn<String> measurementNotes = GeneratedColumn<String>(
    'measurement_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _styleInstructionsMeta = const VerificationMeta(
    'styleInstructions',
  );
  @override
  late final GeneratedColumn<String> styleInstructions =
      GeneratedColumn<String>(
        'style_instructions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _stitchingPricePaisaMeta =
      const VerificationMeta('stitchingPricePaisa');
  @override
  late final GeneratedColumn<int> stitchingPricePaisa = GeneratedColumn<int>(
    'stitching_price_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clothChargePaisaMeta = const VerificationMeta(
    'clothChargePaisa',
  );
  @override
  late final GeneratedColumn<int> clothChargePaisa = GeneratedColumn<int>(
    'cloth_charge_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _additionalChargePaisaMeta =
      const VerificationMeta('additionalChargePaisa');
  @override
  late final GeneratedColumn<int> additionalChargePaisa = GeneratedColumn<int>(
    'additional_charge_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _additionalChargeDescriptionMeta =
      const VerificationMeta('additionalChargeDescription');
  @override
  late final GeneratedColumn<String> additionalChargeDescription =
      GeneratedColumn<String>(
        'additional_charge_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('booked'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    measurementRevisionId,
    garmentType,
    garmentLabelEnglish,
    garmentLabelUrdu,
    quantity,
    measurementProfileName,
    measurementUnit,
    measurementBasis,
    measurementValuesJson,
    measurementFieldDefinitionsJson,
    fitPreference,
    measurementNotes,
    styleInstructions,
    stitchingPricePaisa,
    clothChargePaisa,
    additionalChargePaisa,
    additionalChargeDescription,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('measurement_revision_id')) {
      context.handle(
        _measurementRevisionIdMeta,
        measurementRevisionId.isAcceptableOrUnknown(
          data['measurement_revision_id']!,
          _measurementRevisionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementRevisionIdMeta);
    }
    if (data.containsKey('garment_type')) {
      context.handle(
        _garmentTypeMeta,
        garmentType.isAcceptableOrUnknown(
          data['garment_type']!,
          _garmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_garmentTypeMeta);
    }
    if (data.containsKey('garment_label_english')) {
      context.handle(
        _garmentLabelEnglishMeta,
        garmentLabelEnglish.isAcceptableOrUnknown(
          data['garment_label_english']!,
          _garmentLabelEnglishMeta,
        ),
      );
    }
    if (data.containsKey('garment_label_urdu')) {
      context.handle(
        _garmentLabelUrduMeta,
        garmentLabelUrdu.isAcceptableOrUnknown(
          data['garment_label_urdu']!,
          _garmentLabelUrduMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('measurement_profile_name')) {
      context.handle(
        _measurementProfileNameMeta,
        measurementProfileName.isAcceptableOrUnknown(
          data['measurement_profile_name']!,
          _measurementProfileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementProfileNameMeta);
    }
    if (data.containsKey('measurement_unit')) {
      context.handle(
        _measurementUnitMeta,
        measurementUnit.isAcceptableOrUnknown(
          data['measurement_unit']!,
          _measurementUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementUnitMeta);
    }
    if (data.containsKey('measurement_basis')) {
      context.handle(
        _measurementBasisMeta,
        measurementBasis.isAcceptableOrUnknown(
          data['measurement_basis']!,
          _measurementBasisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementBasisMeta);
    }
    if (data.containsKey('measurement_values_json')) {
      context.handle(
        _measurementValuesJsonMeta,
        measurementValuesJson.isAcceptableOrUnknown(
          data['measurement_values_json']!,
          _measurementValuesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementValuesJsonMeta);
    }
    if (data.containsKey('measurement_field_definitions_json')) {
      context.handle(
        _measurementFieldDefinitionsJsonMeta,
        measurementFieldDefinitionsJson.isAcceptableOrUnknown(
          data['measurement_field_definitions_json']!,
          _measurementFieldDefinitionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('fit_preference')) {
      context.handle(
        _fitPreferenceMeta,
        fitPreference.isAcceptableOrUnknown(
          data['fit_preference']!,
          _fitPreferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fitPreferenceMeta);
    }
    if (data.containsKey('measurement_notes')) {
      context.handle(
        _measurementNotesMeta,
        measurementNotes.isAcceptableOrUnknown(
          data['measurement_notes']!,
          _measurementNotesMeta,
        ),
      );
    }
    if (data.containsKey('style_instructions')) {
      context.handle(
        _styleInstructionsMeta,
        styleInstructions.isAcceptableOrUnknown(
          data['style_instructions']!,
          _styleInstructionsMeta,
        ),
      );
    }
    if (data.containsKey('stitching_price_paisa')) {
      context.handle(
        _stitchingPricePaisaMeta,
        stitchingPricePaisa.isAcceptableOrUnknown(
          data['stitching_price_paisa']!,
          _stitchingPricePaisaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stitchingPricePaisaMeta);
    }
    if (data.containsKey('cloth_charge_paisa')) {
      context.handle(
        _clothChargePaisaMeta,
        clothChargePaisa.isAcceptableOrUnknown(
          data['cloth_charge_paisa']!,
          _clothChargePaisaMeta,
        ),
      );
    }
    if (data.containsKey('additional_charge_paisa')) {
      context.handle(
        _additionalChargePaisaMeta,
        additionalChargePaisa.isAcceptableOrUnknown(
          data['additional_charge_paisa']!,
          _additionalChargePaisaMeta,
        ),
      );
    }
    if (data.containsKey('additional_charge_description')) {
      context.handle(
        _additionalChargeDescriptionMeta,
        additionalChargeDescription.isAcceptableOrUnknown(
          data['additional_charge_description']!,
          _additionalChargeDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      measurementRevisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measurement_revision_id'],
      )!,
      garmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_type'],
      )!,
      garmentLabelEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_label_english'],
      )!,
      garmentLabelUrdu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_label_urdu'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      measurementProfileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_profile_name'],
      )!,
      measurementUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_unit'],
      )!,
      measurementBasis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_basis'],
      )!,
      measurementValuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_values_json'],
      )!,
      measurementFieldDefinitionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_field_definitions_json'],
      )!,
      fitPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fit_preference'],
      )!,
      measurementNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_notes'],
      )!,
      styleInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style_instructions'],
      )!,
      stitchingPricePaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stitching_price_paisa'],
      )!,
      clothChargePaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cloth_charge_paisa'],
      )!,
      additionalChargePaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}additional_charge_paisa'],
      )!,
      additionalChargeDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}additional_charge_description'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int measurementRevisionId;
  final String garmentType;
  final String garmentLabelEnglish;
  final String garmentLabelUrdu;
  final int quantity;
  final String measurementProfileName;
  final String measurementUnit;
  final String measurementBasis;
  final String measurementValuesJson;
  final String measurementFieldDefinitionsJson;
  final String fitPreference;
  final String measurementNotes;
  final String styleInstructions;
  final int stitchingPricePaisa;
  final int clothChargePaisa;
  final int additionalChargePaisa;
  final String additionalChargeDescription;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OrderItem({
    required this.id,
    required this.orderId,
    required this.measurementRevisionId,
    required this.garmentType,
    required this.garmentLabelEnglish,
    required this.garmentLabelUrdu,
    required this.quantity,
    required this.measurementProfileName,
    required this.measurementUnit,
    required this.measurementBasis,
    required this.measurementValuesJson,
    required this.measurementFieldDefinitionsJson,
    required this.fitPreference,
    required this.measurementNotes,
    required this.styleInstructions,
    required this.stitchingPricePaisa,
    required this.clothChargePaisa,
    required this.additionalChargePaisa,
    required this.additionalChargeDescription,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['measurement_revision_id'] = Variable<int>(measurementRevisionId);
    map['garment_type'] = Variable<String>(garmentType);
    map['garment_label_english'] = Variable<String>(garmentLabelEnglish);
    map['garment_label_urdu'] = Variable<String>(garmentLabelUrdu);
    map['quantity'] = Variable<int>(quantity);
    map['measurement_profile_name'] = Variable<String>(measurementProfileName);
    map['measurement_unit'] = Variable<String>(measurementUnit);
    map['measurement_basis'] = Variable<String>(measurementBasis);
    map['measurement_values_json'] = Variable<String>(measurementValuesJson);
    map['measurement_field_definitions_json'] = Variable<String>(
      measurementFieldDefinitionsJson,
    );
    map['fit_preference'] = Variable<String>(fitPreference);
    map['measurement_notes'] = Variable<String>(measurementNotes);
    map['style_instructions'] = Variable<String>(styleInstructions);
    map['stitching_price_paisa'] = Variable<int>(stitchingPricePaisa);
    map['cloth_charge_paisa'] = Variable<int>(clothChargePaisa);
    map['additional_charge_paisa'] = Variable<int>(additionalChargePaisa);
    map['additional_charge_description'] = Variable<String>(
      additionalChargeDescription,
    );
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      measurementRevisionId: Value(measurementRevisionId),
      garmentType: Value(garmentType),
      garmentLabelEnglish: Value(garmentLabelEnglish),
      garmentLabelUrdu: Value(garmentLabelUrdu),
      quantity: Value(quantity),
      measurementProfileName: Value(measurementProfileName),
      measurementUnit: Value(measurementUnit),
      measurementBasis: Value(measurementBasis),
      measurementValuesJson: Value(measurementValuesJson),
      measurementFieldDefinitionsJson: Value(measurementFieldDefinitionsJson),
      fitPreference: Value(fitPreference),
      measurementNotes: Value(measurementNotes),
      styleInstructions: Value(styleInstructions),
      stitchingPricePaisa: Value(stitchingPricePaisa),
      clothChargePaisa: Value(clothChargePaisa),
      additionalChargePaisa: Value(additionalChargePaisa),
      additionalChargeDescription: Value(additionalChargeDescription),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      measurementRevisionId: serializer.fromJson<int>(
        json['measurementRevisionId'],
      ),
      garmentType: serializer.fromJson<String>(json['garmentType']),
      garmentLabelEnglish: serializer.fromJson<String>(
        json['garmentLabelEnglish'],
      ),
      garmentLabelUrdu: serializer.fromJson<String>(json['garmentLabelUrdu']),
      quantity: serializer.fromJson<int>(json['quantity']),
      measurementProfileName: serializer.fromJson<String>(
        json['measurementProfileName'],
      ),
      measurementUnit: serializer.fromJson<String>(json['measurementUnit']),
      measurementBasis: serializer.fromJson<String>(json['measurementBasis']),
      measurementValuesJson: serializer.fromJson<String>(
        json['measurementValuesJson'],
      ),
      measurementFieldDefinitionsJson: serializer.fromJson<String>(
        json['measurementFieldDefinitionsJson'],
      ),
      fitPreference: serializer.fromJson<String>(json['fitPreference']),
      measurementNotes: serializer.fromJson<String>(json['measurementNotes']),
      styleInstructions: serializer.fromJson<String>(json['styleInstructions']),
      stitchingPricePaisa: serializer.fromJson<int>(
        json['stitchingPricePaisa'],
      ),
      clothChargePaisa: serializer.fromJson<int>(json['clothChargePaisa']),
      additionalChargePaisa: serializer.fromJson<int>(
        json['additionalChargePaisa'],
      ),
      additionalChargeDescription: serializer.fromJson<String>(
        json['additionalChargeDescription'],
      ),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'measurementRevisionId': serializer.toJson<int>(measurementRevisionId),
      'garmentType': serializer.toJson<String>(garmentType),
      'garmentLabelEnglish': serializer.toJson<String>(garmentLabelEnglish),
      'garmentLabelUrdu': serializer.toJson<String>(garmentLabelUrdu),
      'quantity': serializer.toJson<int>(quantity),
      'measurementProfileName': serializer.toJson<String>(
        measurementProfileName,
      ),
      'measurementUnit': serializer.toJson<String>(measurementUnit),
      'measurementBasis': serializer.toJson<String>(measurementBasis),
      'measurementValuesJson': serializer.toJson<String>(measurementValuesJson),
      'measurementFieldDefinitionsJson': serializer.toJson<String>(
        measurementFieldDefinitionsJson,
      ),
      'fitPreference': serializer.toJson<String>(fitPreference),
      'measurementNotes': serializer.toJson<String>(measurementNotes),
      'styleInstructions': serializer.toJson<String>(styleInstructions),
      'stitchingPricePaisa': serializer.toJson<int>(stitchingPricePaisa),
      'clothChargePaisa': serializer.toJson<int>(clothChargePaisa),
      'additionalChargePaisa': serializer.toJson<int>(additionalChargePaisa),
      'additionalChargeDescription': serializer.toJson<String>(
        additionalChargeDescription,
      ),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OrderItem copyWith({
    int? id,
    int? orderId,
    int? measurementRevisionId,
    String? garmentType,
    String? garmentLabelEnglish,
    String? garmentLabelUrdu,
    int? quantity,
    String? measurementProfileName,
    String? measurementUnit,
    String? measurementBasis,
    String? measurementValuesJson,
    String? measurementFieldDefinitionsJson,
    String? fitPreference,
    String? measurementNotes,
    String? styleInstructions,
    int? stitchingPricePaisa,
    int? clothChargePaisa,
    int? additionalChargePaisa,
    String? additionalChargeDescription,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OrderItem(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    measurementRevisionId: measurementRevisionId ?? this.measurementRevisionId,
    garmentType: garmentType ?? this.garmentType,
    garmentLabelEnglish: garmentLabelEnglish ?? this.garmentLabelEnglish,
    garmentLabelUrdu: garmentLabelUrdu ?? this.garmentLabelUrdu,
    quantity: quantity ?? this.quantity,
    measurementProfileName:
        measurementProfileName ?? this.measurementProfileName,
    measurementUnit: measurementUnit ?? this.measurementUnit,
    measurementBasis: measurementBasis ?? this.measurementBasis,
    measurementValuesJson: measurementValuesJson ?? this.measurementValuesJson,
    measurementFieldDefinitionsJson:
        measurementFieldDefinitionsJson ?? this.measurementFieldDefinitionsJson,
    fitPreference: fitPreference ?? this.fitPreference,
    measurementNotes: measurementNotes ?? this.measurementNotes,
    styleInstructions: styleInstructions ?? this.styleInstructions,
    stitchingPricePaisa: stitchingPricePaisa ?? this.stitchingPricePaisa,
    clothChargePaisa: clothChargePaisa ?? this.clothChargePaisa,
    additionalChargePaisa: additionalChargePaisa ?? this.additionalChargePaisa,
    additionalChargeDescription:
        additionalChargeDescription ?? this.additionalChargeDescription,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      measurementRevisionId: data.measurementRevisionId.present
          ? data.measurementRevisionId.value
          : this.measurementRevisionId,
      garmentType: data.garmentType.present
          ? data.garmentType.value
          : this.garmentType,
      garmentLabelEnglish: data.garmentLabelEnglish.present
          ? data.garmentLabelEnglish.value
          : this.garmentLabelEnglish,
      garmentLabelUrdu: data.garmentLabelUrdu.present
          ? data.garmentLabelUrdu.value
          : this.garmentLabelUrdu,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      measurementProfileName: data.measurementProfileName.present
          ? data.measurementProfileName.value
          : this.measurementProfileName,
      measurementUnit: data.measurementUnit.present
          ? data.measurementUnit.value
          : this.measurementUnit,
      measurementBasis: data.measurementBasis.present
          ? data.measurementBasis.value
          : this.measurementBasis,
      measurementValuesJson: data.measurementValuesJson.present
          ? data.measurementValuesJson.value
          : this.measurementValuesJson,
      measurementFieldDefinitionsJson:
          data.measurementFieldDefinitionsJson.present
          ? data.measurementFieldDefinitionsJson.value
          : this.measurementFieldDefinitionsJson,
      fitPreference: data.fitPreference.present
          ? data.fitPreference.value
          : this.fitPreference,
      measurementNotes: data.measurementNotes.present
          ? data.measurementNotes.value
          : this.measurementNotes,
      styleInstructions: data.styleInstructions.present
          ? data.styleInstructions.value
          : this.styleInstructions,
      stitchingPricePaisa: data.stitchingPricePaisa.present
          ? data.stitchingPricePaisa.value
          : this.stitchingPricePaisa,
      clothChargePaisa: data.clothChargePaisa.present
          ? data.clothChargePaisa.value
          : this.clothChargePaisa,
      additionalChargePaisa: data.additionalChargePaisa.present
          ? data.additionalChargePaisa.value
          : this.additionalChargePaisa,
      additionalChargeDescription: data.additionalChargeDescription.present
          ? data.additionalChargeDescription.value
          : this.additionalChargeDescription,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('measurementRevisionId: $measurementRevisionId, ')
          ..write('garmentType: $garmentType, ')
          ..write('garmentLabelEnglish: $garmentLabelEnglish, ')
          ..write('garmentLabelUrdu: $garmentLabelUrdu, ')
          ..write('quantity: $quantity, ')
          ..write('measurementProfileName: $measurementProfileName, ')
          ..write('measurementUnit: $measurementUnit, ')
          ..write('measurementBasis: $measurementBasis, ')
          ..write('measurementValuesJson: $measurementValuesJson, ')
          ..write(
            'measurementFieldDefinitionsJson: $measurementFieldDefinitionsJson, ',
          )
          ..write('fitPreference: $fitPreference, ')
          ..write('measurementNotes: $measurementNotes, ')
          ..write('styleInstructions: $styleInstructions, ')
          ..write('stitchingPricePaisa: $stitchingPricePaisa, ')
          ..write('clothChargePaisa: $clothChargePaisa, ')
          ..write('additionalChargePaisa: $additionalChargePaisa, ')
          ..write('additionalChargeDescription: $additionalChargeDescription, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    orderId,
    measurementRevisionId,
    garmentType,
    garmentLabelEnglish,
    garmentLabelUrdu,
    quantity,
    measurementProfileName,
    measurementUnit,
    measurementBasis,
    measurementValuesJson,
    measurementFieldDefinitionsJson,
    fitPreference,
    measurementNotes,
    styleInstructions,
    stitchingPricePaisa,
    clothChargePaisa,
    additionalChargePaisa,
    additionalChargeDescription,
    status,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.measurementRevisionId == this.measurementRevisionId &&
          other.garmentType == this.garmentType &&
          other.garmentLabelEnglish == this.garmentLabelEnglish &&
          other.garmentLabelUrdu == this.garmentLabelUrdu &&
          other.quantity == this.quantity &&
          other.measurementProfileName == this.measurementProfileName &&
          other.measurementUnit == this.measurementUnit &&
          other.measurementBasis == this.measurementBasis &&
          other.measurementValuesJson == this.measurementValuesJson &&
          other.measurementFieldDefinitionsJson ==
              this.measurementFieldDefinitionsJson &&
          other.fitPreference == this.fitPreference &&
          other.measurementNotes == this.measurementNotes &&
          other.styleInstructions == this.styleInstructions &&
          other.stitchingPricePaisa == this.stitchingPricePaisa &&
          other.clothChargePaisa == this.clothChargePaisa &&
          other.additionalChargePaisa == this.additionalChargePaisa &&
          other.additionalChargeDescription ==
              this.additionalChargeDescription &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> measurementRevisionId;
  final Value<String> garmentType;
  final Value<String> garmentLabelEnglish;
  final Value<String> garmentLabelUrdu;
  final Value<int> quantity;
  final Value<String> measurementProfileName;
  final Value<String> measurementUnit;
  final Value<String> measurementBasis;
  final Value<String> measurementValuesJson;
  final Value<String> measurementFieldDefinitionsJson;
  final Value<String> fitPreference;
  final Value<String> measurementNotes;
  final Value<String> styleInstructions;
  final Value<int> stitchingPricePaisa;
  final Value<int> clothChargePaisa;
  final Value<int> additionalChargePaisa;
  final Value<String> additionalChargeDescription;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.measurementRevisionId = const Value.absent(),
    this.garmentType = const Value.absent(),
    this.garmentLabelEnglish = const Value.absent(),
    this.garmentLabelUrdu = const Value.absent(),
    this.quantity = const Value.absent(),
    this.measurementProfileName = const Value.absent(),
    this.measurementUnit = const Value.absent(),
    this.measurementBasis = const Value.absent(),
    this.measurementValuesJson = const Value.absent(),
    this.measurementFieldDefinitionsJson = const Value.absent(),
    this.fitPreference = const Value.absent(),
    this.measurementNotes = const Value.absent(),
    this.styleInstructions = const Value.absent(),
    this.stitchingPricePaisa = const Value.absent(),
    this.clothChargePaisa = const Value.absent(),
    this.additionalChargePaisa = const Value.absent(),
    this.additionalChargeDescription = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int measurementRevisionId,
    required String garmentType,
    this.garmentLabelEnglish = const Value.absent(),
    this.garmentLabelUrdu = const Value.absent(),
    required int quantity,
    required String measurementProfileName,
    required String measurementUnit,
    required String measurementBasis,
    required String measurementValuesJson,
    this.measurementFieldDefinitionsJson = const Value.absent(),
    required String fitPreference,
    this.measurementNotes = const Value.absent(),
    this.styleInstructions = const Value.absent(),
    required int stitchingPricePaisa,
    this.clothChargePaisa = const Value.absent(),
    this.additionalChargePaisa = const Value.absent(),
    this.additionalChargeDescription = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : orderId = Value(orderId),
       measurementRevisionId = Value(measurementRevisionId),
       garmentType = Value(garmentType),
       quantity = Value(quantity),
       measurementProfileName = Value(measurementProfileName),
       measurementUnit = Value(measurementUnit),
       measurementBasis = Value(measurementBasis),
       measurementValuesJson = Value(measurementValuesJson),
       fitPreference = Value(fitPreference),
       stitchingPricePaisa = Value(stitchingPricePaisa);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? measurementRevisionId,
    Expression<String>? garmentType,
    Expression<String>? garmentLabelEnglish,
    Expression<String>? garmentLabelUrdu,
    Expression<int>? quantity,
    Expression<String>? measurementProfileName,
    Expression<String>? measurementUnit,
    Expression<String>? measurementBasis,
    Expression<String>? measurementValuesJson,
    Expression<String>? measurementFieldDefinitionsJson,
    Expression<String>? fitPreference,
    Expression<String>? measurementNotes,
    Expression<String>? styleInstructions,
    Expression<int>? stitchingPricePaisa,
    Expression<int>? clothChargePaisa,
    Expression<int>? additionalChargePaisa,
    Expression<String>? additionalChargeDescription,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (measurementRevisionId != null)
        'measurement_revision_id': measurementRevisionId,
      if (garmentType != null) 'garment_type': garmentType,
      if (garmentLabelEnglish != null)
        'garment_label_english': garmentLabelEnglish,
      if (garmentLabelUrdu != null) 'garment_label_urdu': garmentLabelUrdu,
      if (quantity != null) 'quantity': quantity,
      if (measurementProfileName != null)
        'measurement_profile_name': measurementProfileName,
      if (measurementUnit != null) 'measurement_unit': measurementUnit,
      if (measurementBasis != null) 'measurement_basis': measurementBasis,
      if (measurementValuesJson != null)
        'measurement_values_json': measurementValuesJson,
      if (measurementFieldDefinitionsJson != null)
        'measurement_field_definitions_json': measurementFieldDefinitionsJson,
      if (fitPreference != null) 'fit_preference': fitPreference,
      if (measurementNotes != null) 'measurement_notes': measurementNotes,
      if (styleInstructions != null) 'style_instructions': styleInstructions,
      if (stitchingPricePaisa != null)
        'stitching_price_paisa': stitchingPricePaisa,
      if (clothChargePaisa != null) 'cloth_charge_paisa': clothChargePaisa,
      if (additionalChargePaisa != null)
        'additional_charge_paisa': additionalChargePaisa,
      if (additionalChargeDescription != null)
        'additional_charge_description': additionalChargeDescription,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrderItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<int>? measurementRevisionId,
    Value<String>? garmentType,
    Value<String>? garmentLabelEnglish,
    Value<String>? garmentLabelUrdu,
    Value<int>? quantity,
    Value<String>? measurementProfileName,
    Value<String>? measurementUnit,
    Value<String>? measurementBasis,
    Value<String>? measurementValuesJson,
    Value<String>? measurementFieldDefinitionsJson,
    Value<String>? fitPreference,
    Value<String>? measurementNotes,
    Value<String>? styleInstructions,
    Value<int>? stitchingPricePaisa,
    Value<int>? clothChargePaisa,
    Value<int>? additionalChargePaisa,
    Value<String>? additionalChargeDescription,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      measurementRevisionId:
          measurementRevisionId ?? this.measurementRevisionId,
      garmentType: garmentType ?? this.garmentType,
      garmentLabelEnglish: garmentLabelEnglish ?? this.garmentLabelEnglish,
      garmentLabelUrdu: garmentLabelUrdu ?? this.garmentLabelUrdu,
      quantity: quantity ?? this.quantity,
      measurementProfileName:
          measurementProfileName ?? this.measurementProfileName,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      measurementBasis: measurementBasis ?? this.measurementBasis,
      measurementValuesJson:
          measurementValuesJson ?? this.measurementValuesJson,
      measurementFieldDefinitionsJson:
          measurementFieldDefinitionsJson ??
          this.measurementFieldDefinitionsJson,
      fitPreference: fitPreference ?? this.fitPreference,
      measurementNotes: measurementNotes ?? this.measurementNotes,
      styleInstructions: styleInstructions ?? this.styleInstructions,
      stitchingPricePaisa: stitchingPricePaisa ?? this.stitchingPricePaisa,
      clothChargePaisa: clothChargePaisa ?? this.clothChargePaisa,
      additionalChargePaisa:
          additionalChargePaisa ?? this.additionalChargePaisa,
      additionalChargeDescription:
          additionalChargeDescription ?? this.additionalChargeDescription,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (measurementRevisionId.present) {
      map['measurement_revision_id'] = Variable<int>(
        measurementRevisionId.value,
      );
    }
    if (garmentType.present) {
      map['garment_type'] = Variable<String>(garmentType.value);
    }
    if (garmentLabelEnglish.present) {
      map['garment_label_english'] = Variable<String>(
        garmentLabelEnglish.value,
      );
    }
    if (garmentLabelUrdu.present) {
      map['garment_label_urdu'] = Variable<String>(garmentLabelUrdu.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (measurementProfileName.present) {
      map['measurement_profile_name'] = Variable<String>(
        measurementProfileName.value,
      );
    }
    if (measurementUnit.present) {
      map['measurement_unit'] = Variable<String>(measurementUnit.value);
    }
    if (measurementBasis.present) {
      map['measurement_basis'] = Variable<String>(measurementBasis.value);
    }
    if (measurementValuesJson.present) {
      map['measurement_values_json'] = Variable<String>(
        measurementValuesJson.value,
      );
    }
    if (measurementFieldDefinitionsJson.present) {
      map['measurement_field_definitions_json'] = Variable<String>(
        measurementFieldDefinitionsJson.value,
      );
    }
    if (fitPreference.present) {
      map['fit_preference'] = Variable<String>(fitPreference.value);
    }
    if (measurementNotes.present) {
      map['measurement_notes'] = Variable<String>(measurementNotes.value);
    }
    if (styleInstructions.present) {
      map['style_instructions'] = Variable<String>(styleInstructions.value);
    }
    if (stitchingPricePaisa.present) {
      map['stitching_price_paisa'] = Variable<int>(stitchingPricePaisa.value);
    }
    if (clothChargePaisa.present) {
      map['cloth_charge_paisa'] = Variable<int>(clothChargePaisa.value);
    }
    if (additionalChargePaisa.present) {
      map['additional_charge_paisa'] = Variable<int>(
        additionalChargePaisa.value,
      );
    }
    if (additionalChargeDescription.present) {
      map['additional_charge_description'] = Variable<String>(
        additionalChargeDescription.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('measurementRevisionId: $measurementRevisionId, ')
          ..write('garmentType: $garmentType, ')
          ..write('garmentLabelEnglish: $garmentLabelEnglish, ')
          ..write('garmentLabelUrdu: $garmentLabelUrdu, ')
          ..write('quantity: $quantity, ')
          ..write('measurementProfileName: $measurementProfileName, ')
          ..write('measurementUnit: $measurementUnit, ')
          ..write('measurementBasis: $measurementBasis, ')
          ..write('measurementValuesJson: $measurementValuesJson, ')
          ..write(
            'measurementFieldDefinitionsJson: $measurementFieldDefinitionsJson, ',
          )
          ..write('fitPreference: $fitPreference, ')
          ..write('measurementNotes: $measurementNotes, ')
          ..write('styleInstructions: $styleInstructions, ')
          ..write('stitchingPricePaisa: $stitchingPricePaisa, ')
          ..write('clothChargePaisa: $clothChargePaisa, ')
          ..write('additionalChargePaisa: $additionalChargePaisa, ')
          ..write('additionalChargeDescription: $additionalChargeDescription, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _amountPaisaMeta = const VerificationMeta(
    'amountPaisa',
  );
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
    'amount_paisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    amountPaisa,
    paymentDate,
    method,
    recordType,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
        _amountPaisaMeta,
        amountPaisa.isAcceptableOrUnknown(
          data['amount_paisa']!,
          _amountPaisaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      amountPaisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paisa'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int orderId;
  final int amountPaisa;
  final DateTime paymentDate;
  final String method;
  final String recordType;
  final String notes;
  final DateTime createdAt;
  const Payment({
    required this.id,
    required this.orderId,
    required this.amountPaisa,
    required this.paymentDate,
    required this.method,
    required this.recordType,
    required this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    map['method'] = Variable<String>(method);
    map['record_type'] = Variable<String>(recordType);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      amountPaisa: Value(amountPaisa),
      paymentDate: Value(paymentDate),
      method: Value(method),
      recordType: Value(recordType),
      notes: Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      method: serializer.fromJson<String>(json['method']),
      recordType: serializer.fromJson<String>(json['recordType']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'method': serializer.toJson<String>(method),
      'recordType': serializer.toJson<String>(recordType),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith({
    int? id,
    int? orderId,
    int? amountPaisa,
    DateTime? paymentDate,
    String? method,
    String? recordType,
    String? notes,
    DateTime? createdAt,
  }) => Payment(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    amountPaisa: amountPaisa ?? this.amountPaisa,
    paymentDate: paymentDate ?? this.paymentDate,
    method: method ?? this.method,
    recordType: recordType ?? this.recordType,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      amountPaisa: data.amountPaisa.present
          ? data.amountPaisa.value
          : this.amountPaisa,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      method: data.method.present ? data.method.value : this.method,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('method: $method, ')
          ..write('recordType: $recordType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    amountPaisa,
    paymentDate,
    method,
    recordType,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.amountPaisa == this.amountPaisa &&
          other.paymentDate == this.paymentDate &&
          other.method == this.method &&
          other.recordType == this.recordType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> amountPaisa;
  final Value<DateTime> paymentDate;
  final Value<String> method;
  final Value<String> recordType;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.method = const Value.absent(),
    this.recordType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int amountPaisa,
    required DateTime paymentDate,
    required String method,
    required String recordType,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : orderId = Value(orderId),
       amountPaisa = Value(amountPaisa),
       paymentDate = Value(paymentDate),
       method = Value(method),
       recordType = Value(recordType);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? amountPaisa,
    Expression<DateTime>? paymentDate,
    Expression<String>? method,
    Expression<String>? recordType,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (method != null) 'method': method,
      if (recordType != null) 'record_type': recordType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<int>? amountPaisa,
    Value<DateTime>? paymentDate,
    Value<String>? method,
    Value<String>? recordType,
    Value<String>? notes,
    Value<DateTime>? createdAt,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      paymentDate: paymentDate ?? this.paymentDate,
      method: method ?? this.method,
      recordType: recordType ?? this.recordType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('method: $method, ')
          ..write('recordType: $recordType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KarigarsTable extends Karigars with TableInfo<$KarigarsTable, Karigar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KarigarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _skillsMeta = const VerificationMeta('skills');
  @override
  late final GeneratedColumn<String> skills = GeneratedColumn<String>(
    'skills',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    address,
    skills,
    status,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'karigars';
  @override
  VerificationContext validateIntegrity(
    Insertable<Karigar> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('skills')) {
      context.handle(
        _skillsMeta,
        skills.isAcceptableOrUnknown(data['skills']!, _skillsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Karigar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Karigar(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      skills: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skills'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KarigarsTable createAlias(String alias) {
    return $KarigarsTable(attachedDatabase, alias);
  }
}

class Karigar extends DataClass implements Insertable<Karigar> {
  final int id;
  final String name;
  final String phone;
  final String address;

  /// Comma-separated garment skills, e.g. "shirt,trouser".
  final String skills;

  /// 'active' or 'inactive'.
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Karigar({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.skills,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['skills'] = Variable<String>(skills);
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KarigarsCompanion toCompanion(bool nullToAbsent) {
    return KarigarsCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      skills: Value(skills),
      status: Value(status),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Karigar.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Karigar(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      skills: serializer.fromJson<String>(json['skills']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'skills': serializer.toJson<String>(skills),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Karigar copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? skills,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Karigar(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    skills: skills ?? this.skills,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Karigar copyWithCompanion(KarigarsCompanion data) {
    return Karigar(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      skills: data.skills.present ? data.skills.value : this.skills,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Karigar(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('skills: $skills, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    address,
    skills,
    status,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Karigar &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.skills == this.skills &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KarigarsCompanion extends UpdateCompanion<Karigar> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> skills;
  final Value<String> status;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KarigarsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.skills = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KarigarsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.skills = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Karigar> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? skills,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (skills != null) 'skills': skills,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KarigarsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? address,
    Value<String>? skills,
    Value<String>? status,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KarigarsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      skills: skills ?? this.skills,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (skills.present) {
      map['skills'] = Variable<String>(skills.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KarigarsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('skills: $skills, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KarigarAssignmentsTable extends KarigarAssignments
    with TableInfo<$KarigarAssignmentsTable, KarigarAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KarigarAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderItemIdMeta = const VerificationMeta(
    'orderItemId',
  );
  @override
  late final GeneratedColumn<int> orderItemId = GeneratedColumn<int>(
    'order_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES order_items (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _karigarIdMeta = const VerificationMeta(
    'karigarId',
  );
  @override
  late final GeneratedColumn<int> karigarId = GeneratedColumn<int>(
    'karigar_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES karigars (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _internalDeadlineMeta = const VerificationMeta(
    'internalDeadline',
  );
  @override
  late final GeneratedColumn<DateTime> internalDeadline =
      GeneratedColumn<DateTime>(
        'internal_deadline',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _workInstructionsMeta = const VerificationMeta(
    'workInstructions',
  );
  @override
  late final GeneratedColumn<String> workInstructions = GeneratedColumn<String>(
    'work_instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('assigned'),
  );
  static const VerificationMeta _reassignReasonMeta = const VerificationMeta(
    'reassignReason',
  );
  @override
  late final GeneratedColumn<String> reassignReason = GeneratedColumn<String>(
    'reassign_reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _assignedAtMeta = const VerificationMeta(
    'assignedAt',
  );
  @override
  late final GeneratedColumn<DateTime> assignedAt = GeneratedColumn<DateTime>(
    'assigned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderItemId,
    karigarId,
    internalDeadline,
    workInstructions,
    status,
    reassignReason,
    assignedAt,
    startedAt,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'karigar_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<KarigarAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_item_id')) {
      context.handle(
        _orderItemIdMeta,
        orderItemId.isAcceptableOrUnknown(
          data['order_item_id']!,
          _orderItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderItemIdMeta);
    }
    if (data.containsKey('karigar_id')) {
      context.handle(
        _karigarIdMeta,
        karigarId.isAcceptableOrUnknown(data['karigar_id']!, _karigarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_karigarIdMeta);
    }
    if (data.containsKey('internal_deadline')) {
      context.handle(
        _internalDeadlineMeta,
        internalDeadline.isAcceptableOrUnknown(
          data['internal_deadline']!,
          _internalDeadlineMeta,
        ),
      );
    }
    if (data.containsKey('work_instructions')) {
      context.handle(
        _workInstructionsMeta,
        workInstructions.isAcceptableOrUnknown(
          data['work_instructions']!,
          _workInstructionsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reassign_reason')) {
      context.handle(
        _reassignReasonMeta,
        reassignReason.isAcceptableOrUnknown(
          data['reassign_reason']!,
          _reassignReasonMeta,
        ),
      );
    }
    if (data.containsKey('assigned_at')) {
      context.handle(
        _assignedAtMeta,
        assignedAt.isAcceptableOrUnknown(data['assigned_at']!, _assignedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_assignedAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KarigarAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KarigarAssignment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_item_id'],
      )!,
      karigarId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}karigar_id'],
      )!,
      internalDeadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}internal_deadline'],
      ),
      workInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_instructions'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reassignReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reassign_reason'],
      )!,
      assignedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_at'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KarigarAssignmentsTable createAlias(String alias) {
    return $KarigarAssignmentsTable(attachedDatabase, alias);
  }
}

class KarigarAssignment extends DataClass
    implements Insertable<KarigarAssignment> {
  final int id;
  final int orderItemId;
  final int karigarId;

  /// Internal shop deadline for this assignment (may differ from order delivery).
  final DateTime? internalDeadline;
  final String workInstructions;

  /// 'assigned', 'in_progress', 'completed', or 'cancelled'.
  final String status;

  /// Free-text reason recorded on reassignment or alteration return.
  final String reassignReason;
  final DateTime assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const KarigarAssignment({
    required this.id,
    required this.orderItemId,
    required this.karigarId,
    this.internalDeadline,
    required this.workInstructions,
    required this.status,
    required this.reassignReason,
    required this.assignedAt,
    this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_item_id'] = Variable<int>(orderItemId);
    map['karigar_id'] = Variable<int>(karigarId);
    if (!nullToAbsent || internalDeadline != null) {
      map['internal_deadline'] = Variable<DateTime>(internalDeadline);
    }
    map['work_instructions'] = Variable<String>(workInstructions);
    map['status'] = Variable<String>(status);
    map['reassign_reason'] = Variable<String>(reassignReason);
    map['assigned_at'] = Variable<DateTime>(assignedAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KarigarAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return KarigarAssignmentsCompanion(
      id: Value(id),
      orderItemId: Value(orderItemId),
      karigarId: Value(karigarId),
      internalDeadline: internalDeadline == null && nullToAbsent
          ? const Value.absent()
          : Value(internalDeadline),
      workInstructions: Value(workInstructions),
      status: Value(status),
      reassignReason: Value(reassignReason),
      assignedAt: Value(assignedAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KarigarAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KarigarAssignment(
      id: serializer.fromJson<int>(json['id']),
      orderItemId: serializer.fromJson<int>(json['orderItemId']),
      karigarId: serializer.fromJson<int>(json['karigarId']),
      internalDeadline: serializer.fromJson<DateTime?>(
        json['internalDeadline'],
      ),
      workInstructions: serializer.fromJson<String>(json['workInstructions']),
      status: serializer.fromJson<String>(json['status']),
      reassignReason: serializer.fromJson<String>(json['reassignReason']),
      assignedAt: serializer.fromJson<DateTime>(json['assignedAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderItemId': serializer.toJson<int>(orderItemId),
      'karigarId': serializer.toJson<int>(karigarId),
      'internalDeadline': serializer.toJson<DateTime?>(internalDeadline),
      'workInstructions': serializer.toJson<String>(workInstructions),
      'status': serializer.toJson<String>(status),
      'reassignReason': serializer.toJson<String>(reassignReason),
      'assignedAt': serializer.toJson<DateTime>(assignedAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KarigarAssignment copyWith({
    int? id,
    int? orderItemId,
    int? karigarId,
    Value<DateTime?> internalDeadline = const Value.absent(),
    String? workInstructions,
    String? status,
    String? reassignReason,
    DateTime? assignedAt,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => KarigarAssignment(
    id: id ?? this.id,
    orderItemId: orderItemId ?? this.orderItemId,
    karigarId: karigarId ?? this.karigarId,
    internalDeadline: internalDeadline.present
        ? internalDeadline.value
        : this.internalDeadline,
    workInstructions: workInstructions ?? this.workInstructions,
    status: status ?? this.status,
    reassignReason: reassignReason ?? this.reassignReason,
    assignedAt: assignedAt ?? this.assignedAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KarigarAssignment copyWithCompanion(KarigarAssignmentsCompanion data) {
    return KarigarAssignment(
      id: data.id.present ? data.id.value : this.id,
      orderItemId: data.orderItemId.present
          ? data.orderItemId.value
          : this.orderItemId,
      karigarId: data.karigarId.present ? data.karigarId.value : this.karigarId,
      internalDeadline: data.internalDeadline.present
          ? data.internalDeadline.value
          : this.internalDeadline,
      workInstructions: data.workInstructions.present
          ? data.workInstructions.value
          : this.workInstructions,
      status: data.status.present ? data.status.value : this.status,
      reassignReason: data.reassignReason.present
          ? data.reassignReason.value
          : this.reassignReason,
      assignedAt: data.assignedAt.present
          ? data.assignedAt.value
          : this.assignedAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KarigarAssignment(')
          ..write('id: $id, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('karigarId: $karigarId, ')
          ..write('internalDeadline: $internalDeadline, ')
          ..write('workInstructions: $workInstructions, ')
          ..write('status: $status, ')
          ..write('reassignReason: $reassignReason, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderItemId,
    karigarId,
    internalDeadline,
    workInstructions,
    status,
    reassignReason,
    assignedAt,
    startedAt,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KarigarAssignment &&
          other.id == this.id &&
          other.orderItemId == this.orderItemId &&
          other.karigarId == this.karigarId &&
          other.internalDeadline == this.internalDeadline &&
          other.workInstructions == this.workInstructions &&
          other.status == this.status &&
          other.reassignReason == this.reassignReason &&
          other.assignedAt == this.assignedAt &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class KarigarAssignmentsCompanion extends UpdateCompanion<KarigarAssignment> {
  final Value<int> id;
  final Value<int> orderItemId;
  final Value<int> karigarId;
  final Value<DateTime?> internalDeadline;
  final Value<String> workInstructions;
  final Value<String> status;
  final Value<String> reassignReason;
  final Value<DateTime> assignedAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  const KarigarAssignmentsCompanion({
    this.id = const Value.absent(),
    this.orderItemId = const Value.absent(),
    this.karigarId = const Value.absent(),
    this.internalDeadline = const Value.absent(),
    this.workInstructions = const Value.absent(),
    this.status = const Value.absent(),
    this.reassignReason = const Value.absent(),
    this.assignedAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KarigarAssignmentsCompanion.insert({
    this.id = const Value.absent(),
    required int orderItemId,
    required int karigarId,
    this.internalDeadline = const Value.absent(),
    this.workInstructions = const Value.absent(),
    this.status = const Value.absent(),
    this.reassignReason = const Value.absent(),
    required DateTime assignedAt,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : orderItemId = Value(orderItemId),
       karigarId = Value(karigarId),
       assignedAt = Value(assignedAt);
  static Insertable<KarigarAssignment> custom({
    Expression<int>? id,
    Expression<int>? orderItemId,
    Expression<int>? karigarId,
    Expression<DateTime>? internalDeadline,
    Expression<String>? workInstructions,
    Expression<String>? status,
    Expression<String>? reassignReason,
    Expression<DateTime>? assignedAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderItemId != null) 'order_item_id': orderItemId,
      if (karigarId != null) 'karigar_id': karigarId,
      if (internalDeadline != null) 'internal_deadline': internalDeadline,
      if (workInstructions != null) 'work_instructions': workInstructions,
      if (status != null) 'status': status,
      if (reassignReason != null) 'reassign_reason': reassignReason,
      if (assignedAt != null) 'assigned_at': assignedAt,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KarigarAssignmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderItemId,
    Value<int>? karigarId,
    Value<DateTime?>? internalDeadline,
    Value<String>? workInstructions,
    Value<String>? status,
    Value<String>? reassignReason,
    Value<DateTime>? assignedAt,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? updatedAt,
  }) {
    return KarigarAssignmentsCompanion(
      id: id ?? this.id,
      orderItemId: orderItemId ?? this.orderItemId,
      karigarId: karigarId ?? this.karigarId,
      internalDeadline: internalDeadline ?? this.internalDeadline,
      workInstructions: workInstructions ?? this.workInstructions,
      status: status ?? this.status,
      reassignReason: reassignReason ?? this.reassignReason,
      assignedAt: assignedAt ?? this.assignedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderItemId.present) {
      map['order_item_id'] = Variable<int>(orderItemId.value);
    }
    if (karigarId.present) {
      map['karigar_id'] = Variable<int>(karigarId.value);
    }
    if (internalDeadline.present) {
      map['internal_deadline'] = Variable<DateTime>(internalDeadline.value);
    }
    if (workInstructions.present) {
      map['work_instructions'] = Variable<String>(workInstructions.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reassignReason.present) {
      map['reassign_reason'] = Variable<String>(reassignReason.value);
    }
    if (assignedAt.present) {
      map['assigned_at'] = Variable<DateTime>(assignedAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KarigarAssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('karigarId: $karigarId, ')
          ..write('internalDeadline: $internalDeadline, ')
          ..write('workInstructions: $workInstructions, ')
          ..write('status: $status, ')
          ..write('reassignReason: $reassignReason, ')
          ..write('assignedAt: $assignedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MeasurementTemplateFieldsTable extends MeasurementTemplateFields
    with TableInfo<$MeasurementTemplateFieldsTable, MeasurementTemplateField> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementTemplateFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _templateVersionIdMeta = const VerificationMeta(
    'templateVersionId',
  );
  @override
  late final GeneratedColumn<int> templateVersionId = GeneratedColumn<int>(
    'template_version_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES measurement_template_versions (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayLabelMeta = const VerificationMeta(
    'displayLabel',
  );
  @override
  late final GeneratedColumn<String> displayLabel = GeneratedColumn<String>(
    'display_label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayLabelUrduMeta = const VerificationMeta(
    'displayLabelUrdu',
  );
  @override
  late final GeneratedColumn<String> displayLabelUrdu = GeneratedColumn<String>(
    'display_label_urdu',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateVersionId,
    fieldId,
    displayLabel,
    displayLabelUrdu,
    displayOrder,
    isRequired,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_template_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementTemplateField> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_version_id')) {
      context.handle(
        _templateVersionIdMeta,
        templateVersionId.isAcceptableOrUnknown(
          data['template_version_id']!,
          _templateVersionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateVersionIdMeta);
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('display_label')) {
      context.handle(
        _displayLabelMeta,
        displayLabel.isAcceptableOrUnknown(
          data['display_label']!,
          _displayLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayLabelMeta);
    }
    if (data.containsKey('display_label_urdu')) {
      context.handle(
        _displayLabelUrduMeta,
        displayLabelUrdu.isAcceptableOrUnknown(
          data['display_label_urdu']!,
          _displayLabelUrduMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    } else if (isInserting) {
      context.missing(_isRequiredMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {templateVersionId, fieldId},
  ];
  @override
  MeasurementTemplateField map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementTemplateField(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_version_id'],
      )!,
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      displayLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_label'],
      )!,
      displayLabelUrdu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_label_urdu'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $MeasurementTemplateFieldsTable createAlias(String alias) {
    return $MeasurementTemplateFieldsTable(attachedDatabase, alias);
  }
}

class MeasurementTemplateField extends DataClass
    implements Insertable<MeasurementTemplateField> {
  final int id;
  final int templateVersionId;
  final String fieldId;
  final String displayLabel;
  final String? displayLabelUrdu;
  final int displayOrder;
  final bool isRequired;
  final bool isArchived;
  const MeasurementTemplateField({
    required this.id,
    required this.templateVersionId,
    required this.fieldId,
    required this.displayLabel,
    this.displayLabelUrdu,
    required this.displayOrder,
    required this.isRequired,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_version_id'] = Variable<int>(templateVersionId);
    map['field_id'] = Variable<String>(fieldId);
    map['display_label'] = Variable<String>(displayLabel);
    if (!nullToAbsent || displayLabelUrdu != null) {
      map['display_label_urdu'] = Variable<String>(displayLabelUrdu);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['is_required'] = Variable<bool>(isRequired);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  MeasurementTemplateFieldsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementTemplateFieldsCompanion(
      id: Value(id),
      templateVersionId: Value(templateVersionId),
      fieldId: Value(fieldId),
      displayLabel: Value(displayLabel),
      displayLabelUrdu: displayLabelUrdu == null && nullToAbsent
          ? const Value.absent()
          : Value(displayLabelUrdu),
      displayOrder: Value(displayOrder),
      isRequired: Value(isRequired),
      isArchived: Value(isArchived),
    );
  }

  factory MeasurementTemplateField.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementTemplateField(
      id: serializer.fromJson<int>(json['id']),
      templateVersionId: serializer.fromJson<int>(json['templateVersionId']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      displayLabel: serializer.fromJson<String>(json['displayLabel']),
      displayLabelUrdu: serializer.fromJson<String?>(json['displayLabelUrdu']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateVersionId': serializer.toJson<int>(templateVersionId),
      'fieldId': serializer.toJson<String>(fieldId),
      'displayLabel': serializer.toJson<String>(displayLabel),
      'displayLabelUrdu': serializer.toJson<String?>(displayLabelUrdu),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isRequired': serializer.toJson<bool>(isRequired),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  MeasurementTemplateField copyWith({
    int? id,
    int? templateVersionId,
    String? fieldId,
    String? displayLabel,
    Value<String?> displayLabelUrdu = const Value.absent(),
    int? displayOrder,
    bool? isRequired,
    bool? isArchived,
  }) => MeasurementTemplateField(
    id: id ?? this.id,
    templateVersionId: templateVersionId ?? this.templateVersionId,
    fieldId: fieldId ?? this.fieldId,
    displayLabel: displayLabel ?? this.displayLabel,
    displayLabelUrdu: displayLabelUrdu.present
        ? displayLabelUrdu.value
        : this.displayLabelUrdu,
    displayOrder: displayOrder ?? this.displayOrder,
    isRequired: isRequired ?? this.isRequired,
    isArchived: isArchived ?? this.isArchived,
  );
  MeasurementTemplateField copyWithCompanion(
    MeasurementTemplateFieldsCompanion data,
  ) {
    return MeasurementTemplateField(
      id: data.id.present ? data.id.value : this.id,
      templateVersionId: data.templateVersionId.present
          ? data.templateVersionId.value
          : this.templateVersionId,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      displayLabel: data.displayLabel.present
          ? data.displayLabel.value
          : this.displayLabel,
      displayLabelUrdu: data.displayLabelUrdu.present
          ? data.displayLabelUrdu.value
          : this.displayLabelUrdu,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementTemplateField(')
          ..write('id: $id, ')
          ..write('templateVersionId: $templateVersionId, ')
          ..write('fieldId: $fieldId, ')
          ..write('displayLabel: $displayLabel, ')
          ..write('displayLabelUrdu: $displayLabelUrdu, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isRequired: $isRequired, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateVersionId,
    fieldId,
    displayLabel,
    displayLabelUrdu,
    displayOrder,
    isRequired,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementTemplateField &&
          other.id == this.id &&
          other.templateVersionId == this.templateVersionId &&
          other.fieldId == this.fieldId &&
          other.displayLabel == this.displayLabel &&
          other.displayLabelUrdu == this.displayLabelUrdu &&
          other.displayOrder == this.displayOrder &&
          other.isRequired == this.isRequired &&
          other.isArchived == this.isArchived);
}

class MeasurementTemplateFieldsCompanion
    extends UpdateCompanion<MeasurementTemplateField> {
  final Value<int> id;
  final Value<int> templateVersionId;
  final Value<String> fieldId;
  final Value<String> displayLabel;
  final Value<String?> displayLabelUrdu;
  final Value<int> displayOrder;
  final Value<bool> isRequired;
  final Value<bool> isArchived;
  const MeasurementTemplateFieldsCompanion({
    this.id = const Value.absent(),
    this.templateVersionId = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.displayLabel = const Value.absent(),
    this.displayLabelUrdu = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  MeasurementTemplateFieldsCompanion.insert({
    this.id = const Value.absent(),
    required int templateVersionId,
    required String fieldId,
    required String displayLabel,
    this.displayLabelUrdu = const Value.absent(),
    required int displayOrder,
    required bool isRequired,
    this.isArchived = const Value.absent(),
  }) : templateVersionId = Value(templateVersionId),
       fieldId = Value(fieldId),
       displayLabel = Value(displayLabel),
       displayOrder = Value(displayOrder),
       isRequired = Value(isRequired);
  static Insertable<MeasurementTemplateField> custom({
    Expression<int>? id,
    Expression<int>? templateVersionId,
    Expression<String>? fieldId,
    Expression<String>? displayLabel,
    Expression<String>? displayLabelUrdu,
    Expression<int>? displayOrder,
    Expression<bool>? isRequired,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateVersionId != null) 'template_version_id': templateVersionId,
      if (fieldId != null) 'field_id': fieldId,
      if (displayLabel != null) 'display_label': displayLabel,
      if (displayLabelUrdu != null) 'display_label_urdu': displayLabelUrdu,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isRequired != null) 'is_required': isRequired,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  MeasurementTemplateFieldsCompanion copyWith({
    Value<int>? id,
    Value<int>? templateVersionId,
    Value<String>? fieldId,
    Value<String>? displayLabel,
    Value<String?>? displayLabelUrdu,
    Value<int>? displayOrder,
    Value<bool>? isRequired,
    Value<bool>? isArchived,
  }) {
    return MeasurementTemplateFieldsCompanion(
      id: id ?? this.id,
      templateVersionId: templateVersionId ?? this.templateVersionId,
      fieldId: fieldId ?? this.fieldId,
      displayLabel: displayLabel ?? this.displayLabel,
      displayLabelUrdu: displayLabelUrdu ?? this.displayLabelUrdu,
      displayOrder: displayOrder ?? this.displayOrder,
      isRequired: isRequired ?? this.isRequired,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateVersionId.present) {
      map['template_version_id'] = Variable<int>(templateVersionId.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (displayLabel.present) {
      map['display_label'] = Variable<String>(displayLabel.value);
    }
    if (displayLabelUrdu.present) {
      map['display_label_urdu'] = Variable<String>(displayLabelUrdu.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementTemplateFieldsCompanion(')
          ..write('id: $id, ')
          ..write('templateVersionId: $templateVersionId, ')
          ..write('fieldId: $fieldId, ')
          ..write('displayLabel: $displayLabel, ')
          ..write('displayLabelUrdu: $displayLabelUrdu, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isRequired: $isRequired, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $MeasurementProfilesTable measurementProfiles =
      $MeasurementProfilesTable(this);
  late final $GarmentCatalogEntriesTable garmentCatalogEntries =
      $GarmentCatalogEntriesTable(this);
  late final $MeasurementTemplateVersionsTable measurementTemplateVersions =
      $MeasurementTemplateVersionsTable(this);
  late final $MeasurementRevisionsTable measurementRevisions =
      $MeasurementRevisionsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $KarigarsTable karigars = $KarigarsTable(this);
  late final $KarigarAssignmentsTable karigarAssignments =
      $KarigarAssignmentsTable(this);
  late final $MeasurementTemplateFieldsTable measurementTemplateFields =
      $MeasurementTemplateFieldsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    customers,
    measurementProfiles,
    garmentCatalogEntries,
    measurementTemplateVersions,
    measurementRevisions,
    orders,
    orderItems,
    payments,
    karigars,
    karigarAssignments,
    measurementTemplateFields,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      required String key,
      Value<String> value,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> value,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => AppSettingsCompanion(id: id, key: key, value: value),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                Value<String> value = const Value.absent(),
              }) => AppSettingsCompanion.insert(id: id, key: key, value: value),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String name,
      required String phone,
      Value<String> address,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<String> address,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $MeasurementProfilesTable,
    List<MeasurementProfile>
  >
  _measurementProfilesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.measurementProfiles,
        aliasName: 'customers__id__measurement_profiles__customer_id',
      );

  $$MeasurementProfilesTableProcessedTableManager get measurementProfilesRefs {
    final manager = $$MeasurementProfilesTableTableManager(
      $_db,
      $_db.measurementProfiles,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _measurementProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'customers__id__orders__customer_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> measurementProfilesRefs(
    Expression<bool> Function($$MeasurementProfilesTableFilterComposer f) f,
  ) {
    final $$MeasurementProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurementProfiles,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementProfilesTableFilterComposer(
            $db: $db,
            $table: $db.measurementProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> measurementProfilesRefs<T extends Object>(
    Expression<T> Function($$MeasurementProfilesTableAnnotationComposer a) f,
  ) {
    final $$MeasurementProfilesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.measurementProfiles,
          getReferencedColumn: (t) => t.customerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementProfilesTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementProfiles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({
            bool measurementProfilesRefs,
            bool ordersRefs,
          })
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phone,
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, Customer>(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({measurementProfilesRefs = false, ordersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (measurementProfilesRefs) db.measurementProfiles,
                    if (ordersRefs) db.orders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (measurementProfilesRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          MeasurementProfile
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._measurementProfilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).measurementProfilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordersRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Order
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._ordersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).ordersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool measurementProfilesRefs, bool ordersRefs})
    >;
typedef $$MeasurementProfilesTableCreateCompanionBuilder =
    MeasurementProfilesCompanion Function({
      Value<int> id,
      required int customerId,
      required String garmentType,
      required String profileName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$MeasurementProfilesTableUpdateCompanionBuilder =
    MeasurementProfilesCompanion Function({
      Value<int> id,
      Value<int> customerId,
      Value<String> garmentType,
      Value<String> profileName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$MeasurementProfilesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MeasurementProfilesTable,
          MeasurementProfile
        > {
  $$MeasurementProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias('measurement_profiles__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MeasurementRevisionsTable,
    List<MeasurementRevision>
  >
  _measurementRevisionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.measurementRevisions,
        aliasName:
            'measurement_profiles__id__measurement_revisions__profile_id',
      );

  $$MeasurementRevisionsTableProcessedTableManager
  get measurementRevisionsRefs {
    final manager = $$MeasurementRevisionsTableTableManager(
      $_db,
      $_db.measurementRevisions,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _measurementRevisionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MeasurementProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementProfilesTable> {
  $$MeasurementProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> measurementRevisionsRefs(
    Expression<bool> Function($$MeasurementRevisionsTableFilterComposer f) f,
  ) {
    final $$MeasurementRevisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurementRevisions,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementRevisionsTableFilterComposer(
            $db: $db,
            $table: $db.measurementRevisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MeasurementProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementProfilesTable> {
  $$MeasurementProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementProfilesTable> {
  $$MeasurementProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> measurementRevisionsRefs<T extends Object>(
    Expression<T> Function($$MeasurementRevisionsTableAnnotationComposer a) f,
  ) {
    final $$MeasurementRevisionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.measurementRevisions,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementRevisionsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementRevisions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MeasurementProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementProfilesTable,
          MeasurementProfile,
          $$MeasurementProfilesTableFilterComposer,
          $$MeasurementProfilesTableOrderingComposer,
          $$MeasurementProfilesTableAnnotationComposer,
          $$MeasurementProfilesTableCreateCompanionBuilder,
          $$MeasurementProfilesTableUpdateCompanionBuilder,
          (MeasurementProfile, $$MeasurementProfilesTableReferences),
          MeasurementProfile,
          PrefetchHooks Function({
            bool customerId,
            bool measurementRevisionsRefs,
          })
        > {
  $$MeasurementProfilesTableTableManager(
    _$AppDatabase db,
    $MeasurementProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MeasurementProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<String> garmentType = const Value.absent(),
                Value<String> profileName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MeasurementProfilesCompanion(
                id: id,
                customerId: customerId,
                garmentType: garmentType,
                profileName: profileName,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int customerId,
                required String garmentType,
                required String profileName,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MeasurementProfilesCompanion.insert(
                id: id,
                customerId: customerId,
                garmentType: garmentType,
                profileName: profileName,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MeasurementProfilesTable, MeasurementProfile>(
                    table,
                  ),
                  $$MeasurementProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({customerId = false, measurementRevisionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (measurementRevisionsRefs) db.measurementRevisions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable:
                                        $$MeasurementProfilesTableReferences
                                            ._customerIdTable(db),
                                    referencedColumn:
                                        $$MeasurementProfilesTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (measurementRevisionsRefs)
                        await $_getPrefetchedData<
                          MeasurementProfile,
                          $MeasurementProfilesTable,
                          MeasurementRevision
                        >(
                          currentTable: table,
                          referencedTable: $$MeasurementProfilesTableReferences
                              ._measurementRevisionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeasurementProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).measurementRevisionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MeasurementProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementProfilesTable,
      MeasurementProfile,
      $$MeasurementProfilesTableFilterComposer,
      $$MeasurementProfilesTableOrderingComposer,
      $$MeasurementProfilesTableAnnotationComposer,
      $$MeasurementProfilesTableCreateCompanionBuilder,
      $$MeasurementProfilesTableUpdateCompanionBuilder,
      (MeasurementProfile, $$MeasurementProfilesTableReferences),
      MeasurementProfile,
      PrefetchHooks Function({bool customerId, bool measurementRevisionsRefs})
    >;
typedef $$GarmentCatalogEntriesTableCreateCompanionBuilder =
    GarmentCatalogEntriesCompanion Function({
      required String garmentId,
      required String displayName,
      Value<String?> displayNameUrdu,
      Value<bool> enabled,
      required int displayOrder,
      Value<int> defaultStitchingPricePaisa,
      Value<bool> isCustom,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$GarmentCatalogEntriesTableUpdateCompanionBuilder =
    GarmentCatalogEntriesCompanion Function({
      Value<String> garmentId,
      Value<String> displayName,
      Value<String?> displayNameUrdu,
      Value<bool> enabled,
      Value<int> displayOrder,
      Value<int> defaultStitchingPricePaisa,
      Value<bool> isCustom,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GarmentCatalogEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GarmentCatalogEntriesTable,
          GarmentCatalogEntry
        > {
  $$GarmentCatalogEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $MeasurementTemplateVersionsTable,
    List<MeasurementTemplateVersion>
  >
  _measurementTemplateVersionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.measurementTemplateVersions,
    aliasName:
        'garment_catalog_entries__garment_id__measurement_template_versions__garment_id',
  );

  $$MeasurementTemplateVersionsTableProcessedTableManager
  get measurementTemplateVersionsRefs {
    final manager =
        $$MeasurementTemplateVersionsTableTableManager(
          $_db,
          $_db.measurementTemplateVersions,
        ).filter(
          (f) => f.garmentId.garmentId.sqlEquals(
            $_itemColumn<String>('garment_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _measurementTemplateVersionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GarmentCatalogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $GarmentCatalogEntriesTable> {
  $$GarmentCatalogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get garmentId => $composableBuilder(
    column: $table.garmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayNameUrdu => $composableBuilder(
    column: $table.displayNameUrdu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultStitchingPricePaisa => $composableBuilder(
    column: $table.defaultStitchingPricePaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> measurementTemplateVersionsRefs(
    Expression<bool> Function(
      $$MeasurementTemplateVersionsTableFilterComposer f,
    )
    f,
  ) {
    final $$MeasurementTemplateVersionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.garmentId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.garmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableFilterComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GarmentCatalogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $GarmentCatalogEntriesTable> {
  $$GarmentCatalogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get garmentId => $composableBuilder(
    column: $table.garmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayNameUrdu => $composableBuilder(
    column: $table.displayNameUrdu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultStitchingPricePaisa => $composableBuilder(
    column: $table.defaultStitchingPricePaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GarmentCatalogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GarmentCatalogEntriesTable> {
  $$GarmentCatalogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get garmentId =>
      $composableBuilder(column: $table.garmentId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayNameUrdu => $composableBuilder(
    column: $table.displayNameUrdu,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultStitchingPricePaisa => $composableBuilder(
    column: $table.defaultStitchingPricePaisa,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> measurementTemplateVersionsRefs<T extends Object>(
    Expression<T> Function(
      $$MeasurementTemplateVersionsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$MeasurementTemplateVersionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.garmentId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.garmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GarmentCatalogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GarmentCatalogEntriesTable,
          GarmentCatalogEntry,
          $$GarmentCatalogEntriesTableFilterComposer,
          $$GarmentCatalogEntriesTableOrderingComposer,
          $$GarmentCatalogEntriesTableAnnotationComposer,
          $$GarmentCatalogEntriesTableCreateCompanionBuilder,
          $$GarmentCatalogEntriesTableUpdateCompanionBuilder,
          (GarmentCatalogEntry, $$GarmentCatalogEntriesTableReferences),
          GarmentCatalogEntry,
          PrefetchHooks Function({bool measurementTemplateVersionsRefs})
        > {
  $$GarmentCatalogEntriesTableTableManager(
    _$AppDatabase db,
    $GarmentCatalogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GarmentCatalogEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GarmentCatalogEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GarmentCatalogEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> garmentId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> displayNameUrdu = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> defaultStitchingPricePaisa = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GarmentCatalogEntriesCompanion(
                garmentId: garmentId,
                displayName: displayName,
                displayNameUrdu: displayNameUrdu,
                enabled: enabled,
                displayOrder: displayOrder,
                defaultStitchingPricePaisa: defaultStitchingPricePaisa,
                isCustom: isCustom,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String garmentId,
                required String displayName,
                Value<String?> displayNameUrdu = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                required int displayOrder,
                Value<int> defaultStitchingPricePaisa = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GarmentCatalogEntriesCompanion.insert(
                garmentId: garmentId,
                displayName: displayName,
                displayNameUrdu: displayNameUrdu,
                enabled: enabled,
                displayOrder: displayOrder,
                defaultStitchingPricePaisa: defaultStitchingPricePaisa,
                isCustom: isCustom,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GarmentCatalogEntriesTable, GarmentCatalogEntry>(
                    table,
                  ),
                  $$GarmentCatalogEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({measurementTemplateVersionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (measurementTemplateVersionsRefs)
                  db.measurementTemplateVersions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (measurementTemplateVersionsRefs)
                    await $_getPrefetchedData<
                      GarmentCatalogEntry,
                      $GarmentCatalogEntriesTable,
                      MeasurementTemplateVersion
                    >(
                      currentTable: table,
                      referencedTable: $$GarmentCatalogEntriesTableReferences
                          ._measurementTemplateVersionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GarmentCatalogEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).measurementTemplateVersionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.garmentId == item.garmentId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GarmentCatalogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GarmentCatalogEntriesTable,
      GarmentCatalogEntry,
      $$GarmentCatalogEntriesTableFilterComposer,
      $$GarmentCatalogEntriesTableOrderingComposer,
      $$GarmentCatalogEntriesTableAnnotationComposer,
      $$GarmentCatalogEntriesTableCreateCompanionBuilder,
      $$GarmentCatalogEntriesTableUpdateCompanionBuilder,
      (GarmentCatalogEntry, $$GarmentCatalogEntriesTableReferences),
      GarmentCatalogEntry,
      PrefetchHooks Function({bool measurementTemplateVersionsRefs})
    >;
typedef $$MeasurementTemplateVersionsTableCreateCompanionBuilder =
    MeasurementTemplateVersionsCompanion Function({
      Value<int> id,
      required String garmentId,
      required int versionNumber,
      required String measurementConvention,
      Value<DateTime> createdAt,
    });
typedef $$MeasurementTemplateVersionsTableUpdateCompanionBuilder =
    MeasurementTemplateVersionsCompanion Function({
      Value<int> id,
      Value<String> garmentId,
      Value<int> versionNumber,
      Value<String> measurementConvention,
      Value<DateTime> createdAt,
    });

final class $$MeasurementTemplateVersionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MeasurementTemplateVersionsTable,
          MeasurementTemplateVersion
        > {
  $$MeasurementTemplateVersionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GarmentCatalogEntriesTable _garmentIdTable(
    _$AppDatabase db,
  ) => db.garmentCatalogEntries.createAlias(
    'measurement_template_versions__garment_id__garment_catalog_entries__garment_id',
  );

  $$GarmentCatalogEntriesTableProcessedTableManager get garmentId {
    final $_column = $_itemColumn<String>('garment_id')!;

    final manager = $$GarmentCatalogEntriesTableTableManager(
      $_db,
      $_db.garmentCatalogEntries,
    ).filter((f) => f.garmentId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_garmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MeasurementRevisionsTable,
    List<MeasurementRevision>
  >
  _measurementRevisionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.measurementRevisions,
    aliasName:
        'measurement_template_versions__id__measurement_revisions__template_version_id',
  );

  $$MeasurementRevisionsTableProcessedTableManager
  get measurementRevisionsRefs {
    final manager = $$MeasurementRevisionsTableTableManager(
      $_db,
      $_db.measurementRevisions,
    ).filter((f) => f.templateVersionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _measurementRevisionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MeasurementTemplateFieldsTable,
    List<MeasurementTemplateField>
  >
  _measurementTemplateFieldsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.measurementTemplateFields,
    aliasName:
        'measurement_template_versions__id__measurement_template_fields__template_version_id',
  );

  $$MeasurementTemplateFieldsTableProcessedTableManager
  get measurementTemplateFieldsRefs {
    final manager = $$MeasurementTemplateFieldsTableTableManager(
      $_db,
      $_db.measurementTemplateFields,
    ).filter((f) => f.templateVersionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _measurementTemplateFieldsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MeasurementTemplateVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementTemplateVersionsTable> {
  $$MeasurementTemplateVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementConvention => $composableBuilder(
    column: $table.measurementConvention,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GarmentCatalogEntriesTableFilterComposer get garmentId {
    final $$GarmentCatalogEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.garmentId,
          referencedTable: $db.garmentCatalogEntries,
          getReferencedColumn: (t) => t.garmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GarmentCatalogEntriesTableFilterComposer(
                $db: $db,
                $table: $db.garmentCatalogEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> measurementRevisionsRefs(
    Expression<bool> Function($$MeasurementRevisionsTableFilterComposer f) f,
  ) {
    final $$MeasurementRevisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurementRevisions,
      getReferencedColumn: (t) => t.templateVersionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementRevisionsTableFilterComposer(
            $db: $db,
            $table: $db.measurementRevisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> measurementTemplateFieldsRefs(
    Expression<bool> Function($$MeasurementTemplateFieldsTableFilterComposer f)
    f,
  ) {
    final $$MeasurementTemplateFieldsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.measurementTemplateFields,
          getReferencedColumn: (t) => t.templateVersionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateFieldsTableFilterComposer(
                $db: $db,
                $table: $db.measurementTemplateFields,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MeasurementTemplateVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementTemplateVersionsTable> {
  $$MeasurementTemplateVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementConvention => $composableBuilder(
    column: $table.measurementConvention,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GarmentCatalogEntriesTableOrderingComposer get garmentId {
    final $$GarmentCatalogEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.garmentId,
          referencedTable: $db.garmentCatalogEntries,
          getReferencedColumn: (t) => t.garmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GarmentCatalogEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.garmentCatalogEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MeasurementTemplateVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementTemplateVersionsTable> {
  $$MeasurementTemplateVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementConvention => $composableBuilder(
    column: $table.measurementConvention,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GarmentCatalogEntriesTableAnnotationComposer get garmentId {
    final $$GarmentCatalogEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.garmentId,
          referencedTable: $db.garmentCatalogEntries,
          getReferencedColumn: (t) => t.garmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GarmentCatalogEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.garmentCatalogEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> measurementRevisionsRefs<T extends Object>(
    Expression<T> Function($$MeasurementRevisionsTableAnnotationComposer a) f,
  ) {
    final $$MeasurementRevisionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.measurementRevisions,
          getReferencedColumn: (t) => t.templateVersionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementRevisionsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementRevisions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> measurementTemplateFieldsRefs<T extends Object>(
    Expression<T> Function($$MeasurementTemplateFieldsTableAnnotationComposer a)
    f,
  ) {
    final $$MeasurementTemplateFieldsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.measurementTemplateFields,
          getReferencedColumn: (t) => t.templateVersionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateFieldsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementTemplateFields,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MeasurementTemplateVersionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementTemplateVersionsTable,
          MeasurementTemplateVersion,
          $$MeasurementTemplateVersionsTableFilterComposer,
          $$MeasurementTemplateVersionsTableOrderingComposer,
          $$MeasurementTemplateVersionsTableAnnotationComposer,
          $$MeasurementTemplateVersionsTableCreateCompanionBuilder,
          $$MeasurementTemplateVersionsTableUpdateCompanionBuilder,
          (
            MeasurementTemplateVersion,
            $$MeasurementTemplateVersionsTableReferences,
          ),
          MeasurementTemplateVersion,
          PrefetchHooks Function({
            bool garmentId,
            bool measurementRevisionsRefs,
            bool measurementTemplateFieldsRefs,
          })
        > {
  $$MeasurementTemplateVersionsTableTableManager(
    _$AppDatabase db,
    $MeasurementTemplateVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementTemplateVersionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MeasurementTemplateVersionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MeasurementTemplateVersionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> garmentId = const Value.absent(),
                Value<int> versionNumber = const Value.absent(),
                Value<String> measurementConvention = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MeasurementTemplateVersionsCompanion(
                id: id,
                garmentId: garmentId,
                versionNumber: versionNumber,
                measurementConvention: measurementConvention,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String garmentId,
                required int versionNumber,
                required String measurementConvention,
                Value<DateTime> createdAt = const Value.absent(),
              }) => MeasurementTemplateVersionsCompanion.insert(
                id: id,
                garmentId: garmentId,
                versionNumber: versionNumber,
                measurementConvention: measurementConvention,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $MeasurementTemplateVersionsTable,
                    MeasurementTemplateVersion
                  >(table),
                  $$MeasurementTemplateVersionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                garmentId = false,
                measurementRevisionsRefs = false,
                measurementTemplateFieldsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (measurementRevisionsRefs) db.measurementRevisions,
                    if (measurementTemplateFieldsRefs)
                      db.measurementTemplateFields,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (garmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.garmentId,
                                    referencedTable:
                                        $$MeasurementTemplateVersionsTableReferences
                                            ._garmentIdTable(db),
                                    referencedColumn:
                                        $$MeasurementTemplateVersionsTableReferences
                                            ._garmentIdTable(db)
                                            .garmentId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (measurementRevisionsRefs)
                        await $_getPrefetchedData<
                          MeasurementTemplateVersion,
                          $MeasurementTemplateVersionsTable,
                          MeasurementRevision
                        >(
                          currentTable: table,
                          referencedTable:
                              $$MeasurementTemplateVersionsTableReferences
                                  ._measurementRevisionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeasurementTemplateVersionsTableReferences(
                                db,
                                table,
                                p0,
                              ).measurementRevisionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateVersionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (measurementTemplateFieldsRefs)
                        await $_getPrefetchedData<
                          MeasurementTemplateVersion,
                          $MeasurementTemplateVersionsTable,
                          MeasurementTemplateField
                        >(
                          currentTable: table,
                          referencedTable:
                              $$MeasurementTemplateVersionsTableReferences
                                  ._measurementTemplateFieldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeasurementTemplateVersionsTableReferences(
                                db,
                                table,
                                p0,
                              ).measurementTemplateFieldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateVersionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MeasurementTemplateVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementTemplateVersionsTable,
      MeasurementTemplateVersion,
      $$MeasurementTemplateVersionsTableFilterComposer,
      $$MeasurementTemplateVersionsTableOrderingComposer,
      $$MeasurementTemplateVersionsTableAnnotationComposer,
      $$MeasurementTemplateVersionsTableCreateCompanionBuilder,
      $$MeasurementTemplateVersionsTableUpdateCompanionBuilder,
      (
        MeasurementTemplateVersion,
        $$MeasurementTemplateVersionsTableReferences,
      ),
      MeasurementTemplateVersion,
      PrefetchHooks Function({
        bool garmentId,
        bool measurementRevisionsRefs,
        bool measurementTemplateFieldsRefs,
      })
    >;
typedef $$MeasurementRevisionsTableCreateCompanionBuilder =
    MeasurementRevisionsCompanion Function({
      Value<int> id,
      required int profileId,
      required int revisionNumber,
      required String garmentType,
      Value<String> garmentLabelEnglish,
      Value<String> garmentLabelUrdu,
      required String profileName,
      required String unit,
      required String measurementBasis,
      required String valuesJson,
      Value<int?> templateVersionId,
      Value<String> fieldDefinitionsJson,
      required String fitPreference,
      Value<String> styleInstructions,
      Value<String> notes,
      Value<DateTime> createdAt,
    });
typedef $$MeasurementRevisionsTableUpdateCompanionBuilder =
    MeasurementRevisionsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> revisionNumber,
      Value<String> garmentType,
      Value<String> garmentLabelEnglish,
      Value<String> garmentLabelUrdu,
      Value<String> profileName,
      Value<String> unit,
      Value<String> measurementBasis,
      Value<String> valuesJson,
      Value<int?> templateVersionId,
      Value<String> fieldDefinitionsJson,
      Value<String> fitPreference,
      Value<String> styleInstructions,
      Value<String> notes,
      Value<DateTime> createdAt,
    });

final class $$MeasurementRevisionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MeasurementRevisionsTable,
          MeasurementRevision
        > {
  $$MeasurementRevisionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MeasurementProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.measurementProfiles.createAlias(
        'measurement_revisions__profile_id__measurement_profiles__id',
      );

  $$MeasurementProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$MeasurementProfilesTableTableManager(
      $_db,
      $_db.measurementProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MeasurementTemplateVersionsTable _templateVersionIdTable(
    _$AppDatabase db,
  ) => db.measurementTemplateVersions.createAlias(
    'measurement_revisions__template_version_id__measurement_template_versions__id',
  );

  $$MeasurementTemplateVersionsTableProcessedTableManager?
  get templateVersionId {
    final $_column = $_itemColumn<int>('template_version_id');
    if ($_column == null) return null;
    final manager = $$MeasurementTemplateVersionsTableTableManager(
      $_db,
      $_db.measurementTemplateVersions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName:
        'measurement_revisions__id__order_items__measurement_revision_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems).filter(
      (f) => f.measurementRevisionId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MeasurementRevisionsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementRevisionsTable> {
  $$MeasurementRevisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentLabelEnglish => $composableBuilder(
    column: $table.garmentLabelEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentLabelUrdu => $composableBuilder(
    column: $table.garmentLabelUrdu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementBasis => $composableBuilder(
    column: $table.measurementBasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldDefinitionsJson => $composableBuilder(
    column: $table.fieldDefinitionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fitPreference => $composableBuilder(
    column: $table.fitPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get styleInstructions => $composableBuilder(
    column: $table.styleInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MeasurementProfilesTableFilterComposer get profileId {
    final $$MeasurementProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.measurementProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementProfilesTableFilterComposer(
            $db: $db,
            $table: $db.measurementProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeasurementTemplateVersionsTableFilterComposer get templateVersionId {
    final $$MeasurementTemplateVersionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateVersionId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableFilterComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.measurementRevisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MeasurementRevisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementRevisionsTable> {
  $$MeasurementRevisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentLabelEnglish => $composableBuilder(
    column: $table.garmentLabelEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentLabelUrdu => $composableBuilder(
    column: $table.garmentLabelUrdu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementBasis => $composableBuilder(
    column: $table.measurementBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldDefinitionsJson => $composableBuilder(
    column: $table.fieldDefinitionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fitPreference => $composableBuilder(
    column: $table.fitPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get styleInstructions => $composableBuilder(
    column: $table.styleInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeasurementProfilesTableOrderingComposer get profileId {
    final $$MeasurementProfilesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.profileId,
          referencedTable: $db.measurementProfiles,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementProfilesTableOrderingComposer(
                $db: $db,
                $table: $db.measurementProfiles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$MeasurementTemplateVersionsTableOrderingComposer get templateVersionId {
    final $$MeasurementTemplateVersionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateVersionId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableOrderingComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MeasurementRevisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementRevisionsTable> {
  $$MeasurementRevisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get garmentLabelEnglish => $composableBuilder(
    column: $table.garmentLabelEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get garmentLabelUrdu => $composableBuilder(
    column: $table.garmentLabelUrdu,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileName => $composableBuilder(
    column: $table.profileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get measurementBasis => $composableBuilder(
    column: $table.measurementBasis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldDefinitionsJson => $composableBuilder(
    column: $table.fieldDefinitionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fitPreference => $composableBuilder(
    column: $table.fitPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get styleInstructions => $composableBuilder(
    column: $table.styleInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MeasurementProfilesTableAnnotationComposer get profileId {
    final $$MeasurementProfilesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.profileId,
          referencedTable: $db.measurementProfiles,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementProfilesTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementProfiles,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$MeasurementTemplateVersionsTableAnnotationComposer get templateVersionId {
    final $$MeasurementTemplateVersionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateVersionId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.measurementRevisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MeasurementRevisionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementRevisionsTable,
          MeasurementRevision,
          $$MeasurementRevisionsTableFilterComposer,
          $$MeasurementRevisionsTableOrderingComposer,
          $$MeasurementRevisionsTableAnnotationComposer,
          $$MeasurementRevisionsTableCreateCompanionBuilder,
          $$MeasurementRevisionsTableUpdateCompanionBuilder,
          (MeasurementRevision, $$MeasurementRevisionsTableReferences),
          MeasurementRevision,
          PrefetchHooks Function({
            bool profileId,
            bool templateVersionId,
            bool orderItemsRefs,
          })
        > {
  $$MeasurementRevisionsTableTableManager(
    _$AppDatabase db,
    $MeasurementRevisionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementRevisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementRevisionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MeasurementRevisionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> revisionNumber = const Value.absent(),
                Value<String> garmentType = const Value.absent(),
                Value<String> garmentLabelEnglish = const Value.absent(),
                Value<String> garmentLabelUrdu = const Value.absent(),
                Value<String> profileName = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> measurementBasis = const Value.absent(),
                Value<String> valuesJson = const Value.absent(),
                Value<int?> templateVersionId = const Value.absent(),
                Value<String> fieldDefinitionsJson = const Value.absent(),
                Value<String> fitPreference = const Value.absent(),
                Value<String> styleInstructions = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MeasurementRevisionsCompanion(
                id: id,
                profileId: profileId,
                revisionNumber: revisionNumber,
                garmentType: garmentType,
                garmentLabelEnglish: garmentLabelEnglish,
                garmentLabelUrdu: garmentLabelUrdu,
                profileName: profileName,
                unit: unit,
                measurementBasis: measurementBasis,
                valuesJson: valuesJson,
                templateVersionId: templateVersionId,
                fieldDefinitionsJson: fieldDefinitionsJson,
                fitPreference: fitPreference,
                styleInstructions: styleInstructions,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required int revisionNumber,
                required String garmentType,
                Value<String> garmentLabelEnglish = const Value.absent(),
                Value<String> garmentLabelUrdu = const Value.absent(),
                required String profileName,
                required String unit,
                required String measurementBasis,
                required String valuesJson,
                Value<int?> templateVersionId = const Value.absent(),
                Value<String> fieldDefinitionsJson = const Value.absent(),
                required String fitPreference,
                Value<String> styleInstructions = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MeasurementRevisionsCompanion.insert(
                id: id,
                profileId: profileId,
                revisionNumber: revisionNumber,
                garmentType: garmentType,
                garmentLabelEnglish: garmentLabelEnglish,
                garmentLabelUrdu: garmentLabelUrdu,
                profileName: profileName,
                unit: unit,
                measurementBasis: measurementBasis,
                valuesJson: valuesJson,
                templateVersionId: templateVersionId,
                fieldDefinitionsJson: fieldDefinitionsJson,
                fitPreference: fitPreference,
                styleInstructions: styleInstructions,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MeasurementRevisionsTable, MeasurementRevision>(
                    table,
                  ),
                  $$MeasurementRevisionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                templateVersionId = false,
                orderItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (profileId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.profileId,
                                    referencedTable:
                                        $$MeasurementRevisionsTableReferences
                                            ._profileIdTable(db),
                                    referencedColumn:
                                        $$MeasurementRevisionsTableReferences
                                            ._profileIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (templateVersionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.templateVersionId,
                                    referencedTable:
                                        $$MeasurementRevisionsTableReferences
                                            ._templateVersionIdTable(db),
                                    referencedColumn:
                                        $$MeasurementRevisionsTableReferences
                                            ._templateVersionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          MeasurementRevision,
                          $MeasurementRevisionsTable,
                          OrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$MeasurementRevisionsTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeasurementRevisionsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.measurementRevisionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MeasurementRevisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementRevisionsTable,
      MeasurementRevision,
      $$MeasurementRevisionsTableFilterComposer,
      $$MeasurementRevisionsTableOrderingComposer,
      $$MeasurementRevisionsTableAnnotationComposer,
      $$MeasurementRevisionsTableCreateCompanionBuilder,
      $$MeasurementRevisionsTableUpdateCompanionBuilder,
      (MeasurementRevision, $$MeasurementRevisionsTableReferences),
      MeasurementRevision,
      PrefetchHooks Function({
        bool profileId,
        bool templateVersionId,
        bool orderItemsRefs,
      })
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      required String orderNumber,
      required String submissionKey,
      required int customerId,
      required DateTime bookingDate,
      required DateTime deliveryDate,
      Value<String> notes,
      Value<DateTime?> cancelledAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      Value<String> orderNumber,
      Value<String> submissionKey,
      Value<int> customerId,
      Value<DateTime> bookingDate,
      Value<DateTime> deliveryDate,
      Value<String> notes,
      Value<DateTime?> cancelledAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('orders__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: 'orders__id__order_items__order_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'orders__id__payments__order_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get submissionKey => $composableBuilder(
    column: $table.submissionKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bookingDate => $composableBuilder(
    column: $table.bookingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get submissionKey => $composableBuilder(
    column: $table.submissionKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bookingDate => $composableBuilder(
    column: $table.bookingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get submissionKey => $composableBuilder(
    column: $table.submissionKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get bookingDate => $composableBuilder(
    column: $table.bookingDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({
            bool customerId,
            bool orderItemsRefs,
            bool paymentsRefs,
          })
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> orderNumber = const Value.absent(),
                Value<String> submissionKey = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<DateTime> bookingDate = const Value.absent(),
                Value<DateTime> deliveryDate = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                orderNumber: orderNumber,
                submissionKey: submissionKey,
                customerId: customerId,
                bookingDate: bookingDate,
                deliveryDate: deliveryDate,
                notes: notes,
                cancelledAt: cancelledAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String orderNumber,
                required String submissionKey,
                required int customerId,
                required DateTime bookingDate,
                required DateTime deliveryDate,
                Value<String> notes = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                orderNumber: orderNumber,
                submissionKey: submissionKey,
                customerId: customerId,
                bookingDate: bookingDate,
                deliveryDate: deliveryDate,
                notes: notes,
                cancelledAt: cancelledAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdersTable, Order>(table),
                  $$OrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                orderItemsRefs = false,
                paymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemsRefs) db.orderItems,
                    if (paymentsRefs) db.payments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$OrdersTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          OrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<Order, $OrdersTable, Payment>(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({
        bool customerId,
        bool orderItemsRefs,
        bool paymentsRefs,
      })
    >;
typedef $$OrderItemsTableCreateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<int> id,
      required int orderId,
      required int measurementRevisionId,
      required String garmentType,
      Value<String> garmentLabelEnglish,
      Value<String> garmentLabelUrdu,
      required int quantity,
      required String measurementProfileName,
      required String measurementUnit,
      required String measurementBasis,
      required String measurementValuesJson,
      Value<String> measurementFieldDefinitionsJson,
      required String fitPreference,
      Value<String> measurementNotes,
      Value<String> styleInstructions,
      required int stitchingPricePaisa,
      Value<int> clothChargePaisa,
      Value<int> additionalChargePaisa,
      Value<String> additionalChargeDescription,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$OrderItemsTableUpdateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<int> id,
      Value<int> orderId,
      Value<int> measurementRevisionId,
      Value<String> garmentType,
      Value<String> garmentLabelEnglish,
      Value<String> garmentLabelUrdu,
      Value<int> quantity,
      Value<String> measurementProfileName,
      Value<String> measurementUnit,
      Value<String> measurementBasis,
      Value<String> measurementValuesJson,
      Value<String> measurementFieldDefinitionsJson,
      Value<String> fitPreference,
      Value<String> measurementNotes,
      Value<String> styleInstructions,
      Value<int> stitchingPricePaisa,
      Value<int> clothChargePaisa,
      Value<int> additionalChargePaisa,
      Value<String> additionalChargeDescription,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('order_items__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MeasurementRevisionsTable _measurementRevisionIdTable(
    _$AppDatabase db,
  ) => db.measurementRevisions.createAlias(
    'order_items__measurement_revision_id__measurement_revisions__id',
  );

  $$MeasurementRevisionsTableProcessedTableManager get measurementRevisionId {
    final $_column = $_itemColumn<int>('measurement_revision_id')!;

    final manager = $$MeasurementRevisionsTableTableManager(
      $_db,
      $_db.measurementRevisions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _measurementRevisionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$KarigarAssignmentsTable, List<KarigarAssignment>>
  _karigarAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.karigarAssignments,
        aliasName: 'order_items__id__karigar_assignments__order_item_id',
      );

  $$KarigarAssignmentsTableProcessedTableManager get karigarAssignmentsRefs {
    final manager = $$KarigarAssignmentsTableTableManager(
      $_db,
      $_db.karigarAssignments,
    ).filter((f) => f.orderItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _karigarAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentLabelEnglish => $composableBuilder(
    column: $table.garmentLabelEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentLabelUrdu => $composableBuilder(
    column: $table.garmentLabelUrdu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementProfileName => $composableBuilder(
    column: $table.measurementProfileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementUnit => $composableBuilder(
    column: $table.measurementUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementBasis => $composableBuilder(
    column: $table.measurementBasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementValuesJson => $composableBuilder(
    column: $table.measurementValuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementFieldDefinitionsJson =>
      $composableBuilder(
        column: $table.measurementFieldDefinitionsJson,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get fitPreference => $composableBuilder(
    column: $table.fitPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementNotes => $composableBuilder(
    column: $table.measurementNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get styleInstructions => $composableBuilder(
    column: $table.styleInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stitchingPricePaisa => $composableBuilder(
    column: $table.stitchingPricePaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clothChargePaisa => $composableBuilder(
    column: $table.clothChargePaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get additionalChargePaisa => $composableBuilder(
    column: $table.additionalChargePaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get additionalChargeDescription => $composableBuilder(
    column: $table.additionalChargeDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeasurementRevisionsTableFilterComposer get measurementRevisionId {
    final $$MeasurementRevisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.measurementRevisionId,
      referencedTable: $db.measurementRevisions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementRevisionsTableFilterComposer(
            $db: $db,
            $table: $db.measurementRevisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> karigarAssignmentsRefs(
    Expression<bool> Function($$KarigarAssignmentsTableFilterComposer f) f,
  ) {
    final $$KarigarAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.karigarAssignments,
      getReferencedColumn: (t) => t.orderItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KarigarAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.karigarAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentLabelEnglish => $composableBuilder(
    column: $table.garmentLabelEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentLabelUrdu => $composableBuilder(
    column: $table.garmentLabelUrdu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementProfileName => $composableBuilder(
    column: $table.measurementProfileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementUnit => $composableBuilder(
    column: $table.measurementUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementBasis => $composableBuilder(
    column: $table.measurementBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementValuesJson => $composableBuilder(
    column: $table.measurementValuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementFieldDefinitionsJson =>
      $composableBuilder(
        column: $table.measurementFieldDefinitionsJson,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get fitPreference => $composableBuilder(
    column: $table.fitPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementNotes => $composableBuilder(
    column: $table.measurementNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get styleInstructions => $composableBuilder(
    column: $table.styleInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stitchingPricePaisa => $composableBuilder(
    column: $table.stitchingPricePaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clothChargePaisa => $composableBuilder(
    column: $table.clothChargePaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get additionalChargePaisa => $composableBuilder(
    column: $table.additionalChargePaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get additionalChargeDescription => $composableBuilder(
    column: $table.additionalChargeDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeasurementRevisionsTableOrderingComposer get measurementRevisionId {
    final $$MeasurementRevisionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.measurementRevisionId,
          referencedTable: $db.measurementRevisions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementRevisionsTableOrderingComposer(
                $db: $db,
                $table: $db.measurementRevisions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get garmentType => $composableBuilder(
    column: $table.garmentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get garmentLabelEnglish => $composableBuilder(
    column: $table.garmentLabelEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get garmentLabelUrdu => $composableBuilder(
    column: $table.garmentLabelUrdu,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get measurementProfileName => $composableBuilder(
    column: $table.measurementProfileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementUnit => $composableBuilder(
    column: $table.measurementUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementBasis => $composableBuilder(
    column: $table.measurementBasis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementValuesJson => $composableBuilder(
    column: $table.measurementValuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementFieldDefinitionsJson =>
      $composableBuilder(
        column: $table.measurementFieldDefinitionsJson,
        builder: (column) => column,
      );

  GeneratedColumn<String> get fitPreference => $composableBuilder(
    column: $table.fitPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementNotes => $composableBuilder(
    column: $table.measurementNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get styleInstructions => $composableBuilder(
    column: $table.styleInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stitchingPricePaisa => $composableBuilder(
    column: $table.stitchingPricePaisa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clothChargePaisa => $composableBuilder(
    column: $table.clothChargePaisa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get additionalChargePaisa => $composableBuilder(
    column: $table.additionalChargePaisa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get additionalChargeDescription => $composableBuilder(
    column: $table.additionalChargeDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MeasurementRevisionsTableAnnotationComposer get measurementRevisionId {
    final $$MeasurementRevisionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.measurementRevisionId,
          referencedTable: $db.measurementRevisions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementRevisionsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementRevisions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> karigarAssignmentsRefs<T extends Object>(
    Expression<T> Function($$KarigarAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$KarigarAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.karigarAssignments,
          getReferencedColumn: (t) => t.orderItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KarigarAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.karigarAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItem,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (OrderItem, $$OrderItemsTableReferences),
          OrderItem,
          PrefetchHooks Function({
            bool orderId,
            bool measurementRevisionId,
            bool karigarAssignmentsRefs,
          })
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int> measurementRevisionId = const Value.absent(),
                Value<String> garmentType = const Value.absent(),
                Value<String> garmentLabelEnglish = const Value.absent(),
                Value<String> garmentLabelUrdu = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> measurementProfileName = const Value.absent(),
                Value<String> measurementUnit = const Value.absent(),
                Value<String> measurementBasis = const Value.absent(),
                Value<String> measurementValuesJson = const Value.absent(),
                Value<String> measurementFieldDefinitionsJson =
                    const Value.absent(),
                Value<String> fitPreference = const Value.absent(),
                Value<String> measurementNotes = const Value.absent(),
                Value<String> styleInstructions = const Value.absent(),
                Value<int> stitchingPricePaisa = const Value.absent(),
                Value<int> clothChargePaisa = const Value.absent(),
                Value<int> additionalChargePaisa = const Value.absent(),
                Value<String> additionalChargeDescription =
                    const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrderItemsCompanion(
                id: id,
                orderId: orderId,
                measurementRevisionId: measurementRevisionId,
                garmentType: garmentType,
                garmentLabelEnglish: garmentLabelEnglish,
                garmentLabelUrdu: garmentLabelUrdu,
                quantity: quantity,
                measurementProfileName: measurementProfileName,
                measurementUnit: measurementUnit,
                measurementBasis: measurementBasis,
                measurementValuesJson: measurementValuesJson,
                measurementFieldDefinitionsJson:
                    measurementFieldDefinitionsJson,
                fitPreference: fitPreference,
                measurementNotes: measurementNotes,
                styleInstructions: styleInstructions,
                stitchingPricePaisa: stitchingPricePaisa,
                clothChargePaisa: clothChargePaisa,
                additionalChargePaisa: additionalChargePaisa,
                additionalChargeDescription: additionalChargeDescription,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required int measurementRevisionId,
                required String garmentType,
                Value<String> garmentLabelEnglish = const Value.absent(),
                Value<String> garmentLabelUrdu = const Value.absent(),
                required int quantity,
                required String measurementProfileName,
                required String measurementUnit,
                required String measurementBasis,
                required String measurementValuesJson,
                Value<String> measurementFieldDefinitionsJson =
                    const Value.absent(),
                required String fitPreference,
                Value<String> measurementNotes = const Value.absent(),
                Value<String> styleInstructions = const Value.absent(),
                required int stitchingPricePaisa,
                Value<int> clothChargePaisa = const Value.absent(),
                Value<int> additionalChargePaisa = const Value.absent(),
                Value<String> additionalChargeDescription =
                    const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrderItemsCompanion.insert(
                id: id,
                orderId: orderId,
                measurementRevisionId: measurementRevisionId,
                garmentType: garmentType,
                garmentLabelEnglish: garmentLabelEnglish,
                garmentLabelUrdu: garmentLabelUrdu,
                quantity: quantity,
                measurementProfileName: measurementProfileName,
                measurementUnit: measurementUnit,
                measurementBasis: measurementBasis,
                measurementValuesJson: measurementValuesJson,
                measurementFieldDefinitionsJson:
                    measurementFieldDefinitionsJson,
                fitPreference: fitPreference,
                measurementNotes: measurementNotes,
                styleInstructions: styleInstructions,
                stitchingPricePaisa: stitchingPricePaisa,
                clothChargePaisa: clothChargePaisa,
                additionalChargePaisa: additionalChargePaisa,
                additionalChargeDescription: additionalChargeDescription,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderItemsTable, OrderItem>(table),
                  $$OrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                orderId = false,
                measurementRevisionId = false,
                karigarAssignmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (karigarAssignmentsRefs) db.karigarAssignments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (orderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderId,
                                    referencedTable: $$OrderItemsTableReferences
                                        ._orderIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableReferences
                                            ._orderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (measurementRevisionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.measurementRevisionId,
                                    referencedTable: $$OrderItemsTableReferences
                                        ._measurementRevisionIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableReferences
                                            ._measurementRevisionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (karigarAssignmentsRefs)
                        await $_getPrefetchedData<
                          OrderItem,
                          $OrderItemsTable,
                          KarigarAssignment
                        >(
                          currentTable: table,
                          referencedTable: $$OrderItemsTableReferences
                              ._karigarAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrderItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).karigarAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItem,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItem, $$OrderItemsTableReferences),
      OrderItem,
      PrefetchHooks Function({
        bool orderId,
        bool measurementRevisionId,
        bool karigarAssignmentsRefs,
      })
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int orderId,
      required int amountPaisa,
      required DateTime paymentDate,
      required String method,
      required String recordType,
      Value<String> notes,
      Value<DateTime> createdAt,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> orderId,
      Value<int> amountPaisa,
      Value<DateTime> paymentDate,
      Value<String> method,
      Value<String> recordType,
      Value<String> notes,
      Value<DateTime> createdAt,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('payments__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
    column: $table.amountPaisa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool orderId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int> amountPaisa = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> recordType = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                orderId: orderId,
                amountPaisa: amountPaisa,
                paymentDate: paymentDate,
                method: method,
                recordType: recordType,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required int amountPaisa,
                required DateTime paymentDate,
                required String method,
                required String recordType,
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                orderId: orderId,
                amountPaisa: amountPaisa,
                paymentDate: paymentDate,
                method: method,
                recordType: recordType,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentsTable, Payment>(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$PaymentsTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._orderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$KarigarsTableCreateCompanionBuilder =
    KarigarsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> phone,
      Value<String> address,
      Value<String> skills,
      Value<String> status,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$KarigarsTableUpdateCompanionBuilder =
    KarigarsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<String> address,
      Value<String> skills,
      Value<String> status,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$KarigarsTableReferences
    extends BaseReferences<_$AppDatabase, $KarigarsTable, Karigar> {
  $$KarigarsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$KarigarAssignmentsTable, List<KarigarAssignment>>
  _karigarAssignmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.karigarAssignments,
        aliasName: 'karigars__id__karigar_assignments__karigar_id',
      );

  $$KarigarAssignmentsTableProcessedTableManager get karigarAssignmentsRefs {
    final manager = $$KarigarAssignmentsTableTableManager(
      $_db,
      $_db.karigarAssignments,
    ).filter((f) => f.karigarId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _karigarAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KarigarsTableFilterComposer
    extends Composer<_$AppDatabase, $KarigarsTable> {
  $$KarigarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> karigarAssignmentsRefs(
    Expression<bool> Function($$KarigarAssignmentsTableFilterComposer f) f,
  ) {
    final $$KarigarAssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.karigarAssignments,
      getReferencedColumn: (t) => t.karigarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KarigarAssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.karigarAssignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KarigarsTableOrderingComposer
    extends Composer<_$AppDatabase, $KarigarsTable> {
  $$KarigarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skills => $composableBuilder(
    column: $table.skills,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KarigarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KarigarsTable> {
  $$KarigarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get skills =>
      $composableBuilder(column: $table.skills, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> karigarAssignmentsRefs<T extends Object>(
    Expression<T> Function($$KarigarAssignmentsTableAnnotationComposer a) f,
  ) {
    final $$KarigarAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.karigarAssignments,
          getReferencedColumn: (t) => t.karigarId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KarigarAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.karigarAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$KarigarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KarigarsTable,
          Karigar,
          $$KarigarsTableFilterComposer,
          $$KarigarsTableOrderingComposer,
          $$KarigarsTableAnnotationComposer,
          $$KarigarsTableCreateCompanionBuilder,
          $$KarigarsTableUpdateCompanionBuilder,
          (Karigar, $$KarigarsTableReferences),
          Karigar,
          PrefetchHooks Function({bool karigarAssignmentsRefs})
        > {
  $$KarigarsTableTableManager(_$AppDatabase db, $KarigarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KarigarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KarigarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KarigarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> skills = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KarigarsCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                skills: skills,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> skills = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KarigarsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                skills: skills,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KarigarsTable, Karigar>(table),
                  $$KarigarsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({karigarAssignmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (karigarAssignmentsRefs) db.karigarAssignments,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (karigarAssignmentsRefs)
                    await $_getPrefetchedData<
                      Karigar,
                      $KarigarsTable,
                      KarigarAssignment
                    >(
                      currentTable: table,
                      referencedTable: $$KarigarsTableReferences
                          ._karigarAssignmentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$KarigarsTableReferences(
                        db,
                        table,
                        p0,
                      ).karigarAssignmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.karigarId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KarigarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KarigarsTable,
      Karigar,
      $$KarigarsTableFilterComposer,
      $$KarigarsTableOrderingComposer,
      $$KarigarsTableAnnotationComposer,
      $$KarigarsTableCreateCompanionBuilder,
      $$KarigarsTableUpdateCompanionBuilder,
      (Karigar, $$KarigarsTableReferences),
      Karigar,
      PrefetchHooks Function({bool karigarAssignmentsRefs})
    >;
typedef $$KarigarAssignmentsTableCreateCompanionBuilder =
    KarigarAssignmentsCompanion Function({
      Value<int> id,
      required int orderItemId,
      required int karigarId,
      Value<DateTime?> internalDeadline,
      Value<String> workInstructions,
      Value<String> status,
      Value<String> reassignReason,
      required DateTime assignedAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
    });
typedef $$KarigarAssignmentsTableUpdateCompanionBuilder =
    KarigarAssignmentsCompanion Function({
      Value<int> id,
      Value<int> orderItemId,
      Value<int> karigarId,
      Value<DateTime?> internalDeadline,
      Value<String> workInstructions,
      Value<String> status,
      Value<String> reassignReason,
      Value<DateTime> assignedAt,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime> updatedAt,
    });

final class $$KarigarAssignmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $KarigarAssignmentsTable,
          KarigarAssignment
        > {
  $$KarigarAssignmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrderItemsTable _orderItemIdTable(_$AppDatabase db) => db.orderItems
      .createAlias('karigar_assignments__order_item_id__order_items__id');

  $$OrderItemsTableProcessedTableManager get orderItemId {
    final $_column = $_itemColumn<int>('order_item_id')!;

    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KarigarsTable _karigarIdTable(_$AppDatabase db) =>
      db.karigars.createAlias('karigar_assignments__karigar_id__karigars__id');

  $$KarigarsTableProcessedTableManager get karigarId {
    final $_column = $_itemColumn<int>('karigar_id')!;

    final manager = $$KarigarsTableTableManager(
      $_db,
      $_db.karigars,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_karigarIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KarigarAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $KarigarAssignmentsTable> {
  $$KarigarAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get internalDeadline => $composableBuilder(
    column: $table.internalDeadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workInstructions => $composableBuilder(
    column: $table.workInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reassignReason => $composableBuilder(
    column: $table.reassignReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OrderItemsTableFilterComposer get orderItemId {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KarigarsTableFilterComposer get karigarId {
    final $$KarigarsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.karigarId,
      referencedTable: $db.karigars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KarigarsTableFilterComposer(
            $db: $db,
            $table: $db.karigars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KarigarAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $KarigarAssignmentsTable> {
  $$KarigarAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get internalDeadline => $composableBuilder(
    column: $table.internalDeadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workInstructions => $composableBuilder(
    column: $table.workInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reassignReason => $composableBuilder(
    column: $table.reassignReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrderItemsTableOrderingComposer get orderItemId {
    final $$OrderItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableOrderingComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KarigarsTableOrderingComposer get karigarId {
    final $$KarigarsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.karigarId,
      referencedTable: $db.karigars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KarigarsTableOrderingComposer(
            $db: $db,
            $table: $db.karigars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KarigarAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KarigarAssignmentsTable> {
  $$KarigarAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get internalDeadline => $composableBuilder(
    column: $table.internalDeadline,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workInstructions => $composableBuilder(
    column: $table.workInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reassignReason => $composableBuilder(
    column: $table.reassignReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get assignedAt => $composableBuilder(
    column: $table.assignedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$OrderItemsTableAnnotationComposer get orderItemId {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KarigarsTableAnnotationComposer get karigarId {
    final $$KarigarsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.karigarId,
      referencedTable: $db.karigars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KarigarsTableAnnotationComposer(
            $db: $db,
            $table: $db.karigars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KarigarAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KarigarAssignmentsTable,
          KarigarAssignment,
          $$KarigarAssignmentsTableFilterComposer,
          $$KarigarAssignmentsTableOrderingComposer,
          $$KarigarAssignmentsTableAnnotationComposer,
          $$KarigarAssignmentsTableCreateCompanionBuilder,
          $$KarigarAssignmentsTableUpdateCompanionBuilder,
          (KarigarAssignment, $$KarigarAssignmentsTableReferences),
          KarigarAssignment,
          PrefetchHooks Function({bool orderItemId, bool karigarId})
        > {
  $$KarigarAssignmentsTableTableManager(
    _$AppDatabase db,
    $KarigarAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KarigarAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KarigarAssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KarigarAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderItemId = const Value.absent(),
                Value<int> karigarId = const Value.absent(),
                Value<DateTime?> internalDeadline = const Value.absent(),
                Value<String> workInstructions = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> reassignReason = const Value.absent(),
                Value<DateTime> assignedAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KarigarAssignmentsCompanion(
                id: id,
                orderItemId: orderItemId,
                karigarId: karigarId,
                internalDeadline: internalDeadline,
                workInstructions: workInstructions,
                status: status,
                reassignReason: reassignReason,
                assignedAt: assignedAt,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderItemId,
                required int karigarId,
                Value<DateTime?> internalDeadline = const Value.absent(),
                Value<String> workInstructions = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> reassignReason = const Value.absent(),
                required DateTime assignedAt,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KarigarAssignmentsCompanion.insert(
                id: id,
                orderItemId: orderItemId,
                karigarId: karigarId,
                internalDeadline: internalDeadline,
                workInstructions: workInstructions,
                status: status,
                reassignReason: reassignReason,
                assignedAt: assignedAt,
                startedAt: startedAt,
                completedAt: completedAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KarigarAssignmentsTable, KarigarAssignment>(
                    table,
                  ),
                  $$KarigarAssignmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderItemId = false, karigarId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderItemId,
                                referencedTable:
                                    $$KarigarAssignmentsTableReferences
                                        ._orderItemIdTable(db),
                                referencedColumn:
                                    $$KarigarAssignmentsTableReferences
                                        ._orderItemIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (karigarId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.karigarId,
                                referencedTable:
                                    $$KarigarAssignmentsTableReferences
                                        ._karigarIdTable(db),
                                referencedColumn:
                                    $$KarigarAssignmentsTableReferences
                                        ._karigarIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KarigarAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KarigarAssignmentsTable,
      KarigarAssignment,
      $$KarigarAssignmentsTableFilterComposer,
      $$KarigarAssignmentsTableOrderingComposer,
      $$KarigarAssignmentsTableAnnotationComposer,
      $$KarigarAssignmentsTableCreateCompanionBuilder,
      $$KarigarAssignmentsTableUpdateCompanionBuilder,
      (KarigarAssignment, $$KarigarAssignmentsTableReferences),
      KarigarAssignment,
      PrefetchHooks Function({bool orderItemId, bool karigarId})
    >;
typedef $$MeasurementTemplateFieldsTableCreateCompanionBuilder =
    MeasurementTemplateFieldsCompanion Function({
      Value<int> id,
      required int templateVersionId,
      required String fieldId,
      required String displayLabel,
      Value<String?> displayLabelUrdu,
      required int displayOrder,
      required bool isRequired,
      Value<bool> isArchived,
    });
typedef $$MeasurementTemplateFieldsTableUpdateCompanionBuilder =
    MeasurementTemplateFieldsCompanion Function({
      Value<int> id,
      Value<int> templateVersionId,
      Value<String> fieldId,
      Value<String> displayLabel,
      Value<String?> displayLabelUrdu,
      Value<int> displayOrder,
      Value<bool> isRequired,
      Value<bool> isArchived,
    });

final class $$MeasurementTemplateFieldsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MeasurementTemplateFieldsTable,
          MeasurementTemplateField
        > {
  $$MeasurementTemplateFieldsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MeasurementTemplateVersionsTable _templateVersionIdTable(
    _$AppDatabase db,
  ) => db.measurementTemplateVersions.createAlias(
    'measurement_template_fields__template_version_id__measurement_template_versions__id',
  );

  $$MeasurementTemplateVersionsTableProcessedTableManager
  get templateVersionId {
    final $_column = $_itemColumn<int>('template_version_id')!;

    final manager = $$MeasurementTemplateVersionsTableTableManager(
      $_db,
      $_db.measurementTemplateVersions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MeasurementTemplateFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementTemplateFieldsTable> {
  $$MeasurementTemplateFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayLabel => $composableBuilder(
    column: $table.displayLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayLabelUrdu => $composableBuilder(
    column: $table.displayLabelUrdu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  $$MeasurementTemplateVersionsTableFilterComposer get templateVersionId {
    final $$MeasurementTemplateVersionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateVersionId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableFilterComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MeasurementTemplateFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementTemplateFieldsTable> {
  $$MeasurementTemplateFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayLabel => $composableBuilder(
    column: $table.displayLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayLabelUrdu => $composableBuilder(
    column: $table.displayLabelUrdu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeasurementTemplateVersionsTableOrderingComposer get templateVersionId {
    final $$MeasurementTemplateVersionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateVersionId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableOrderingComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MeasurementTemplateFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementTemplateFieldsTable> {
  $$MeasurementTemplateFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get displayLabel => $composableBuilder(
    column: $table.displayLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayLabelUrdu => $composableBuilder(
    column: $table.displayLabelUrdu,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  $$MeasurementTemplateVersionsTableAnnotationComposer get templateVersionId {
    final $$MeasurementTemplateVersionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateVersionId,
          referencedTable: $db.measurementTemplateVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MeasurementTemplateVersionsTableAnnotationComposer(
                $db: $db,
                $table: $db.measurementTemplateVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MeasurementTemplateFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementTemplateFieldsTable,
          MeasurementTemplateField,
          $$MeasurementTemplateFieldsTableFilterComposer,
          $$MeasurementTemplateFieldsTableOrderingComposer,
          $$MeasurementTemplateFieldsTableAnnotationComposer,
          $$MeasurementTemplateFieldsTableCreateCompanionBuilder,
          $$MeasurementTemplateFieldsTableUpdateCompanionBuilder,
          (
            MeasurementTemplateField,
            $$MeasurementTemplateFieldsTableReferences,
          ),
          MeasurementTemplateField,
          PrefetchHooks Function({bool templateVersionId})
        > {
  $$MeasurementTemplateFieldsTableTableManager(
    _$AppDatabase db,
    $MeasurementTemplateFieldsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementTemplateFieldsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MeasurementTemplateFieldsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MeasurementTemplateFieldsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateVersionId = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<String> displayLabel = const Value.absent(),
                Value<String?> displayLabelUrdu = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => MeasurementTemplateFieldsCompanion(
                id: id,
                templateVersionId: templateVersionId,
                fieldId: fieldId,
                displayLabel: displayLabel,
                displayLabelUrdu: displayLabelUrdu,
                displayOrder: displayOrder,
                isRequired: isRequired,
                isArchived: isArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateVersionId,
                required String fieldId,
                required String displayLabel,
                Value<String?> displayLabelUrdu = const Value.absent(),
                required int displayOrder,
                required bool isRequired,
                Value<bool> isArchived = const Value.absent(),
              }) => MeasurementTemplateFieldsCompanion.insert(
                id: id,
                templateVersionId: templateVersionId,
                fieldId: fieldId,
                displayLabel: displayLabel,
                displayLabelUrdu: displayLabelUrdu,
                displayOrder: displayOrder,
                isRequired: isRequired,
                isArchived: isArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $MeasurementTemplateFieldsTable,
                    MeasurementTemplateField
                  >(table),
                  $$MeasurementTemplateFieldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateVersionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateVersionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateVersionId,
                                referencedTable:
                                    $$MeasurementTemplateFieldsTableReferences
                                        ._templateVersionIdTable(db),
                                referencedColumn:
                                    $$MeasurementTemplateFieldsTableReferences
                                        ._templateVersionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MeasurementTemplateFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementTemplateFieldsTable,
      MeasurementTemplateField,
      $$MeasurementTemplateFieldsTableFilterComposer,
      $$MeasurementTemplateFieldsTableOrderingComposer,
      $$MeasurementTemplateFieldsTableAnnotationComposer,
      $$MeasurementTemplateFieldsTableCreateCompanionBuilder,
      $$MeasurementTemplateFieldsTableUpdateCompanionBuilder,
      (MeasurementTemplateField, $$MeasurementTemplateFieldsTableReferences),
      MeasurementTemplateField,
      PrefetchHooks Function({bool templateVersionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$MeasurementProfilesTableTableManager get measurementProfiles =>
      $$MeasurementProfilesTableTableManager(_db, _db.measurementProfiles);
  $$GarmentCatalogEntriesTableTableManager get garmentCatalogEntries =>
      $$GarmentCatalogEntriesTableTableManager(_db, _db.garmentCatalogEntries);
  $$MeasurementTemplateVersionsTableTableManager
  get measurementTemplateVersions =>
      $$MeasurementTemplateVersionsTableTableManager(
        _db,
        _db.measurementTemplateVersions,
      );
  $$MeasurementRevisionsTableTableManager get measurementRevisions =>
      $$MeasurementRevisionsTableTableManager(_db, _db.measurementRevisions);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$KarigarsTableTableManager get karigars =>
      $$KarigarsTableTableManager(_db, _db.karigars);
  $$KarigarAssignmentsTableTableManager get karigarAssignments =>
      $$KarigarAssignmentsTableTableManager(_db, _db.karigarAssignments);
  $$MeasurementTemplateFieldsTableTableManager get measurementTemplateFields =>
      $$MeasurementTemplateFieldsTableTableManager(
        _db,
        _db.measurementTemplateFields,
      );
}
