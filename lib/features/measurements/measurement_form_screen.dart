import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/unsaved_changes_guard.dart';
import 'measurement_models.dart';
import 'measurement_providers.dart';
import 'measurement_templates.dart';

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

  late GarmentType _garmentType;
  late MeasurementUnit _unit;
  late MeasurementBasis _basis;
  late FitPreference _fit;
  bool _saving = false;
  bool _dirty = false;
  bool _saved = false;

  bool get _isEditing => widget.existing != null;
  GarmentMeasurementTemplate get _template =>
      garmentMeasurementTemplates[_garmentType]!;

  @override
  void initState() {
    super.initState();
    final revision = widget.existing?.latestRevision;
    _garmentType = revision == null
        ? GarmentType.shalwarQameez
        : GarmentType.fromStorage(revision.garmentType);
    _unit = revision == null
        ? MeasurementUnit.inches
        : MeasurementUnit.fromStorage(revision.unit);
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
    for (final field in _template.fields) {
      _valueControllers[field.key] = TextEditingController(
        text: values[field.key]?.toString() ?? '',
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
            title: Text('Change $change?'),
            content: const Text(
              'Entered measurement values will be cleared. Values are never converted or reinterpreted automatically.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Keep Values'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Clear & Change'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _changeGarment(GarmentType type) async {
    if (type == _garmentType || !await _confirmClearValues('garment')) return;
    for (final controller in _valueControllers.values) {
      controller.dispose();
    }
    _valueControllers.clear();
    setState(() {
      _dirty = true;
      _garmentType = type;
      _createValueControllers(const {});
    });
  }

  Future<void> _changeUnit(MeasurementUnit unit) async {
    if (unit == _unit || !await _confirmClearValues('unit')) return;
    for (final controller in _valueControllers.values) {
      controller.clear();
    }
    setState(() {
      _dirty = true;
      _unit = unit;
    });
  }

  Future<void> _changeBasis(MeasurementBasis basis) async {
    if (basis == _basis || !await _confirmClearValues('measurement basis')) {
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
    final draft = MeasurementDraft(
      customerId: widget.customer.id,
      garmentType: _garmentType,
      profileName: _profileNameController.text,
      unit: _unit,
      basis: _basis,
      values: values,
      fitPreference: _fit,
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
        const SnackBar(
          content: Text('Could not save measurements. Please try again.'),
        ),
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
    return UnsavedChangesGuard(
      hasUnsavedChanges: _dirty && !_saved,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? 'New Measurement Revision' : 'Add Measurements',
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
                Text('Profile', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<GarmentType>(
                  key: const ValueKey('measurement-garment'),
                  initialValue: _garmentType,
                  decoration: const InputDecoration(
                    labelText: 'Garment',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.checkroom_outlined),
                  ),
                  items: GarmentType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        ),
                      )
                      .toList(),
                  onChanged: _isEditing
                      ? null
                      : (value) {
                          if (value != null) _changeGarment(value);
                        },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: const ValueKey('measurement-profile-name'),
                  controller: _profileNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Profile name',
                    hintText: 'e.g. Everyday or Wedding',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a profile name'
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Measurement context',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Choose whether these are body or finished-garment measurements. The app does not add allowances or convert between them.',
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
                                  ? 'Body'
                                  : 'Finished garment',
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
                            label: Text(unit.label),
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
                        '${_garmentType.label} values',
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
                      children: _template.fields
                          .map(
                            (field) => SizedBox(
                              width: width,
                              child: _MeasurementValueField(
                                definition: field,
                                controller: _valueControllers[field.key]!,
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
                  'Fit preference',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<FitPreference>(
                    segments: FitPreference.values
                        .map(
                          (fit) =>
                              ButtonSegment(value: fit, label: Text(fit.label)),
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
                  decoration: const InputDecoration(
                    labelText: 'Style instructions (optional)',
                    hintText: 'Collar, cuff, pocket, or finishing preferences',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
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
                        ? 'Saving…'
                        : _isEditing
                        ? 'Save New Revision'
                        : 'Save Measurements',
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

  final MeasurementFieldDefinition definition;
  final TextEditingController controller;
  final String unitSuffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('measurement-${definition.key}'),
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(
        labelText: '${definition.label}${definition.required ? ' *' : ''}',
        suffixText: unitSuffix,
        border: const OutlineInputBorder(),
      ),
      validator: (source) {
        final value = source?.trim() ?? '';
        if (value.isEmpty) {
          return definition.required ? 'Required' : null;
        }
        final parsed = double.tryParse(value.replaceAll(',', '.'));
        if (parsed == null) return 'Enter a number';
        if (parsed <= 0) return 'Must be positive';
        return null;
      },
    );
  }
}
