import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/unsaved_changes_guard.dart';
import '../../core/localization/localization_extensions.dart';
import 'measurement_models.dart';
import 'measurement_providers.dart';
import 'measurement_templates.dart';
import '../settings/garment_catalog.dart';
import '../settings/garment_catalog_providers.dart';
import '../settings/shop_settings_providers.dart';

class MeasurementFormScreen extends ConsumerStatefulWidget {
  const MeasurementFormScreen({
    super.key,
    required this.customer,
    this.existing,
  });

  final Customer customer;
  final MeasurementProfileRecord? existing;

  @override
  ConsumerState<MeasurementFormScreen> createState() =>
      _MeasurementFormScreenState();
}

class _MeasurementFormScreenState extends ConsumerState<MeasurementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _profileNameController;
  late final TextEditingController _styleController;
  late final TextEditingController _notesController;
  final Map<String, TextEditingController> _valueControllers = {};

  late String _garmentId;
  late String _garmentLabelEnglish;
  late String _garmentLabelUrdu;
  late List<GarmentTemplateField> _fieldDefinitions;
  int? _templateVersionId;
  late MeasurementUnit _unit;
  late MeasurementBasis _basis;
  late FitPreference _fit;
  bool _saving = false;
  bool _dirty = false;
  bool _saved = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final revision = widget.existing?.latestRevision;
    _garmentId = revision?.garmentType ?? GarmentType.shalwarQameez.storageKey;
    _garmentLabelEnglish = revision?.garmentLabelEnglish.isNotEmpty == true
        ? revision!.garmentLabelEnglish
        : legacyGarmentLabel(_garmentId);
    _garmentLabelUrdu = revision?.garmentLabelUrdu ?? '';
    _fieldDefinitions = revision == null
        ? decodeFieldDefinitions('', _garmentId)
        : decodeFieldDefinitions(revision.fieldDefinitionsJson, _garmentId);
    _templateVersionId = revision?.templateVersionId;
    _unit = revision == null
        ? MeasurementUnit.inches
        : MeasurementUnit.fromStorage(revision.unit);
    if (revision == null) {
      ref.read(shopSettingsRepositoryProvider).get().then((details) {
        if (mounted && !_dirty) {
          setState(() {
            _unit = MeasurementUnit.fromStorage(details.defaultMeasurementUnit);
          });
        }
      });
    }
    _basis = revision == null
        ? MeasurementBasis.body
        : MeasurementBasis.fromStorage(revision.measurementBasis);
    _fit = revision == null
        ? FitPreference.regular
        : FitPreference.fromStorage(revision.fitPreference);
    _profileNameController = TextEditingController(
      text: revision?.profileName ?? '',
    );
    _styleController = TextEditingController(
      text: revision?.styleInstructions ?? '',
    );
    _notesController = TextEditingController(text: revision?.notes ?? '');
    for (final controller in [
      _profileNameController,
      _styleController,
      _notesController,
    ]) {
      controller.addListener(_markDirty);
    }
    _createValueControllers(widget.existing?.values ?? const {});
  }

  void _markDirty() {
    if (mounted && !_dirty) setState(() => _dirty = true);
  }

  void _createValueControllers(Map<String, double> values) {
    for (final field in _fieldDefinitions.where((item) => !item.archived)) {
      _valueControllers[field.id] = TextEditingController(
        text: values[field.id]?.toString() ?? '',
      )..addListener(_markDirty);
    }
  }

  bool get _hasEnteredValues => _valueControllers.values.any(
    (controller) => controller.text.trim().isNotEmpty,
  );

  Future<bool> _confirmClearValues(String change) async {
    if (!_hasEnteredValues) return true;
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(context.l10n.changePrompt(change)),
            content: Text(context.l10n.clearMeasurementsWarning),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(context.l10n.keepValues),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(context.l10n.clearAndChange),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _changeGarment(GarmentCatalogRecord garment) async {
    if (garment.entry.garmentId == _garmentId ||
        !await _confirmClearValues(context.l10n.garment)) {
      return;
    }
    for (final controller in _valueControllers.values) {
      controller.dispose();
    }
    _valueControllers.clear();
    setState(() {
      _dirty = true;
      _garmentId = garment.entry.garmentId;
      _garmentLabelEnglish = garment.entry.displayName;
      _garmentLabelUrdu = garment.entry.displayNameUrdu ?? '';
      _fieldDefinitions = garment.fields;
      _templateVersionId = garment.templateVersion.id;
      _basis = MeasurementBasis.fromStorage(
        garment.templateVersion.measurementConvention,
      );
      _createValueControllers(const {});
    });
  }

  Future<void> _changeUnit(MeasurementUnit unit) async {
    if (unit == _unit || !await _confirmClearValues(context.l10n.unit)) return;
    for (final controller in _valueControllers.values) {
      controller.clear();
    }
    setState(() {
      _dirty = true;
      _unit = unit;
    });
  }

  Future<void> _changeBasis(MeasurementBasis basis) async {
    if (basis == _basis ||
        !await _confirmClearValues(context.l10n.measurementBasis)) {
      return;
    }
    for (final controller in _valueControllers.values) {
      controller.clear();
    }
    setState(() {
      _dirty = true;
      _basis = basis;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    final values = <String, double>{};
    for (final entry in _valueControllers.entries) {
      final source = entry.value.text.trim().replaceAll(',', '.');
      if (source.isNotEmpty) values[entry.key] = double.parse(source);
    }
    final draft = MeasurementDraft.catalog(
      customerId: widget.customer.id,
      garmentId: _garmentId,
      garmentLabelEnglish: _garmentLabelEnglish,
      garmentLabelUrdu: _garmentLabelUrdu,
      profileName: _profileNameController.text,
      unit: _unit,
      basis: _basis,
      values: values,
      fitPreference: _fit,
      templateVersionId: _templateVersionId,
      fieldDefinitions: _fieldDefinitions,
      styleInstructions: _styleController.text,
      notes: _notesController.text,
    );

    try {
      final dao = ref.read(measurementsDaoProvider);
      final existing = widget.existing;
      if (existing == null) {
        await dao.createProfile(draft);
      } else {
        await dao.createRevision(profileId: existing.profile.id, draft: draft);
      }
      if (mounted) {
        setState(() => _saved = true);
        await WidgetsBinding.instance.endOfFrame;
        if (mounted) Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.measurementSaveFailed)),
      );
    }
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _styleController.dispose();
    _notesController.dispose();
    for (final controller in _valueControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableGarments = ref.watch(enabledGarmentCatalogProvider);
    final allGarments = ref.watch(garmentCatalogProvider);
    final garmentRecords = _isEditing
        ? allGarments.value ?? const <GarmentCatalogRecord>[]
        : availableGarments.value ?? const <GarmentCatalogRecord>[];
    if (!_isEditing &&
        garmentRecords.isNotEmpty &&
        _templateVersionId == null) {
      final selected =
          garmentRecords
              .where((item) => item.entry.garmentId == _garmentId)
              .firstOrNull ??
          garmentRecords.first;
      if (selected.entry.garmentId != _garmentId) {
        for (final controller in _valueControllers.values) {
          controller.dispose();
        }
        _valueControllers.clear();
      }
      _garmentId = selected.entry.garmentId;
      _garmentLabelEnglish = selected.entry.displayName;
      _garmentLabelUrdu = selected.entry.displayNameUrdu ?? '';
      _fieldDefinitions = selected.fields;
      _templateVersionId = selected.templateVersion.id;
      _basis = MeasurementBasis.fromStorage(
        selected.templateVersion.measurementConvention,
      );
      if (_valueControllers.isEmpty) _createValueControllers(const {});
    }
    return UnsavedChangesGuard(
      hasUnsavedChanges: _dirty && !_saved,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing
                ? context.l10n.editMeasurement
                : context.l10n.addMeasurement,
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: AppSpacing.pagePadding,
              children: [
                _CustomerSummary(customer: widget.customer),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  context.l10n.measurementProfile,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  key: const ValueKey('measurement-garment'),
                  initialValue:
                      garmentRecords.any(
                        (item) => item.entry.garmentId == _garmentId,
                      )
                      ? _garmentId
                      : null,
                  decoration: InputDecoration(
                    labelText: context.l10n.garment,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.checkroom_outlined),
                  ),
                  items: garmentRecords
                      .map(
                        (garment) => DropdownMenuItem(
                          value: garment.entry.garmentId,
                          child: Text(
                            localizedGarmentLabel(
                              context.l10n,
                              garment.entry.garmentId,
                              english: garment.entry.displayName,
                              urdu: garment.entry.displayNameUrdu,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isEditing
                      ? null
                      : (value) {
                          if (value != null) {
                            final garment = garmentRecords.firstWhere(
                              (item) => item.entry.garmentId == value,
                            );
                            _changeGarment(garment);
                          }
                        },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: const ValueKey('measurement-profile-name'),
                  controller: _profileNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: context.l10n.profileName,
                    hintText: context.l10n.profileNameHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? context.l10n.enterProfileName
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  context.l10n.measurementContext,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.measurementContextHelp,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<MeasurementBasis>(
                    segments: MeasurementBasis.values
                        .map(
                          (basis) => ButtonSegment(
                            value: basis,
                            label: Text(
                              basis == MeasurementBasis.body
                                  ? context.l10n.bodyMeasurements
                                  : context.l10n.finishedGarmentMeasurements,
                            ),
                          ),
                        )
                        .toList(),
                    selected: {_basis},
                    onSelectionChanged: _isEditing
                        ? null
                        : (selection) => _changeBasis(selection.first),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<MeasurementUnit>(
                    segments: MeasurementUnit.values
                        .map(
                          (unit) => ButtonSegment(
                            value: unit,
                            label: Text(
                              localizedUnit(context.l10n, unit.storageKey),
                            ),
                          ),
                        )
                        .toList(),
                    selected: {_unit},
                    onSelectionChanged: _isEditing
                        ? null
                        : (selection) => _changeUnit(selection.first),
                  ),
                ),
                if (_isEditing) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Garment, basis, and unit stay fixed when revising a profile. Create a separate profile to change them.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        localizedGarmentLabel(
                          context.l10n,
                          _garmentId,
                          english: _garmentLabelEnglish,
                          urdu: _garmentLabelUrdu,
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      _unit.suffix,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Required fields are marked *. Optional fields may be left blank.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth >= 560
                        ? (constraints.maxWidth - AppSpacing.md) / 2
                        : constraints.maxWidth;
                    return Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: _fieldDefinitions
                          .where((field) => !field.archived)
                          .map(
                            (field) => SizedBox(
                              width: width,
                              child: _MeasurementValueField(
                                definition: field,
                                controller: _valueControllers[field.id]!,
                                unitSuffix: _unit.suffix,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  context.l10n.fit,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<FitPreference>(
                    segments: FitPreference.values
                        .map(
                          (fit) => ButtonSegment(
                            value: fit,
                            label: Text(
                              localizedFit(context.l10n, fit.storageKey),
                            ),
                          ),
                        )
                        .toList(),
                    selected: {_fit},
                    onSelectionChanged: (selection) => setState(() {
                      _dirty = true;
                      _fit = selection.first;
                    }),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _styleController,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: context.l10n.styleInstructions,
                    hintText: context.l10n.styleHint,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: context.l10n.notes,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                FilledButton.icon(
                  key: const ValueKey('save-measurements'),
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _saving
                        ? context.l10n.saving
                        : _isEditing
                        ? context.l10n.saveNewVersion
                        : context.l10n.saveMeasurements,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomerSummary extends StatelessWidget {
  const _CustomerSummary({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.primary,
          child: Icon(Icons.person_outline),
        ),
        title: Text(customer.name),
        subtitle: Text(customer.phone),
      ),
    );
  }
}

class _MeasurementValueField extends StatelessWidget {
  const _MeasurementValueField({
    required this.definition,
    required this.controller,
    required this.unitSuffix,
  });

  final GarmentTemplateField definition;
  final TextEditingController controller;
  final String unitSuffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('measurement-${definition.id}'),
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(
        labelText:
            '${localizedMeasurementLabel(context.l10n, definition.id, english: definition.label, urdu: definition.labelUrdu)}${definition.required ? ' *' : ''}',
        suffixText: unitSuffix,
        border: const OutlineInputBorder(),
      ),
      validator: (source) {
        final value = source?.trim() ?? '';
        if (value.isEmpty) {
          return definition.required ? context.l10n.required : null;
        }
        final parsed = double.tryParse(value.replaceAll(',', '.'));
        if (parsed == null) return context.l10n.enterNumber;
        if (parsed <= 0) {
          return context.l10n.measurementPositive(
            localizedMeasurementLabel(
              context.l10n,
              definition.id,
              english: definition.label,
              urdu: definition.labelUrdu,
            ),
          );
        }
        return null;
      },
    );
  }
}
