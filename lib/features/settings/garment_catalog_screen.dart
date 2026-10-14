import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/localization/localization_extensions.dart';
import '../orders/order_formatters.dart';
import 'garment_catalog.dart';
import 'garment_catalog_providers.dart';

class GarmentCatalogScreen extends ConsumerWidget {
  const GarmentCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(garmentCatalogProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.garmentsTemplates)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TemplateEditorScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.customGarment),
      ),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.retry)),
        data: (items) => ListView(
          padding: AppSpacing.pagePadding,
          children: [
            Text(context.l10n.disabledGarmentsHelp),
            const SizedBox(height: AppSpacing.lg),
            for (final indexed in items.indexed)
              _GarmentCard(
                record: indexed.$2,
                canMoveUp: indexed.$1 > 0,
                canMoveDown: indexed.$1 < items.length - 1,
                onMove: (offset) async {
                  final ids = items
                      .map((item) => item.entry.garmentId)
                      .toList();
                  final target = indexed.$1 + offset;
                  final value = ids.removeAt(indexed.$1);
                  ids.insert(target, value);
                  await ref.read(garmentCatalogRepositoryProvider).reorder(ids);
                  ref.invalidate(garmentCatalogProvider);
                  ref.invalidate(enabledGarmentCatalogProvider);
                },
              ),
            const SizedBox(height: 88),
          ],
        ),
      ),
    );
  }
}

class _GarmentCard extends ConsumerWidget {
  const _GarmentCard({
    required this.record,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onMove,
  });

  final GarmentCatalogRecord record;
  final bool canMoveUp;
  final bool canMoveDown;
  final ValueChanged<int> onMove;

  Future<void> _editPrice(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: record.entry.defaultStitchingPricePaisa == 0
          ? ''
          : '${record.entry.defaultStitchingPricePaisa ~/ 100}',
    );
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${localizedGarmentLabel(context.l10n, record.entry.garmentId, english: record.entry.displayName, urdu: record.entry.displayNameUrdu)} ${context.l10n.defaultPrices}',
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            prefixText: 'PKR ',
            labelText: context.l10n.pricePerPiece,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              parseRupeesToPaisa(
                controller.text.trim().isEmpty ? '0' : controller.text,
              ),
            ),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) {
      await ref
          .read(garmentCatalogRepositoryProvider)
          .updateEntry(
            garmentId: record.entry.garmentId,
            defaultPricePaisa: result,
          );
      ref.invalidate(garmentCatalogProvider);
      ref.invalidate(enabledGarmentCatalogProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    child: Padding(
      padding: AppSpacing.cardPadding,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              localizedGarmentLabel(
                context.l10n,
                record.entry.garmentId,
                english: record.entry.displayName,
                urdu: record.entry.displayNameUrdu,
              ),
            ),
            subtitle: Text(
              context.l10n.templateVersion(
                record.templateVersion.versionNumber,
                localizedBasis(
                  context.l10n,
                  record.templateVersion.measurementConvention,
                ),
              ),
            ),
            value: record.entry.enabled,
            onChanged: (value) async {
              await ref
                  .read(garmentCatalogRepositoryProvider)
                  .updateEntry(
                    garmentId: record.entry.garmentId,
                    enabled: value,
                  );
              ref.invalidate(garmentCatalogProvider);
              ref.invalidate(enabledGarmentCatalogProvider);
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _editPrice(context, ref),
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(
                    record.entry.defaultStitchingPricePaisa == 0
                        ? context.l10n.setDefaultPrice
                        : formatPaisa(record.entry.defaultStitchingPricePaisa),
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.moveUp,
                onPressed: canMoveUp ? () => onMove(-1) : null,
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                tooltip: context.l10n.moveDown,
                onPressed: canMoveDown ? () => onMove(1) : null,
                icon: const Icon(Icons.arrow_downward),
              ),
              IconButton(
                tooltip: context.l10n.reviseTemplate,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TemplateEditorScreen(existing: record),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class TemplateEditorScreen extends ConsumerStatefulWidget {
  const TemplateEditorScreen({super.key, this.existing});

  final GarmentCatalogRecord? existing;

  @override
  ConsumerState<TemplateEditorScreen> createState() =>
      _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends ConsumerState<TemplateEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _nameUrdu;
  late final List<_FieldDraft> _fields;
  late String _convention;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(
      text: widget.existing?.entry.displayName ?? '',
    );
    _nameUrdu = TextEditingController(
      text: widget.existing?.entry.displayNameUrdu ?? '',
    );
    _convention =
        widget.existing?.templateVersion.measurementConvention ?? 'body';
    _fields = [
      for (final field
          in widget.existing?.fields.where((item) => !item.archived) ??
              const <GarmentTemplateField>[])
        _FieldDraft(
          id: field.id,
          label: field.label,
          labelUrdu: field.labelUrdu ?? '',
          required: field.required,
        ),
    ];
    if (_fields.isEmpty) {
      _fields.add(_FieldDraft());
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _nameUrdu.dispose();
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final fields = [
      for (final indexed in _fields.indexed)
        GarmentTemplateField(
          id: indexed.$2.id.text.trim(),
          label: indexed.$2.label.text.trim(),
          labelUrdu: indexed.$2.labelUrdu.text.trim(),
          order: indexed.$1,
          required: indexed.$2.required,
        ),
    ];
    try {
      final repository = ref.read(garmentCatalogRepositoryProvider);
      if (widget.existing == null) {
        await repository.createCustomTemplate(
          name: _name.text,
          nameUrdu: _nameUrdu.text,
          convention: _convention,
          fields: fields,
        );
      } else {
        await repository.reviseTemplate(
          garmentId: widget.existing!.entry.garmentId,
          name: _name.text,
          nameUrdu: _nameUrdu.text,
          convention: _convention,
          fields: fields,
        );
      }
      ref.invalidate(garmentCatalogProvider);
      ref.invalidate(enabledGarmentCatalogProvider);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.existing == null
            ? context.l10n.customGarment
            : context.l10n.reviseTemplate,
      ),
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          TextFormField(
            controller: _name,
            enabled: widget.existing == null || widget.existing!.entry.isCustom,
            decoration: InputDecoration(labelText: context.l10n.garmentName),
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.enterName
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _nameUrdu,
            enabled: widget.existing == null || widget.existing!.entry.isCustom,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: context.l10n.garmentNameUrdu,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _convention,
            decoration: InputDecoration(
              labelText: context.l10n.measurementConvention,
            ),
            items: [
              DropdownMenuItem(
                value: 'body',
                child: Text(context.l10n.bodyMeasurements),
              ),
              DropdownMenuItem(
                value: 'finished_garment',
                child: Text(context.l10n.finishedGarmentMeasurements),
              ),
            ],
            onChanged: (value) =>
                setState(() => _convention = value ?? _convention),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(context.l10n.noFormulaNotice),
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.fields,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final indexed in _fields.indexed)
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  children: [
                    TextFormField(
                      controller: indexed.$2.id,
                      enabled:
                          widget.existing == null ||
                          !widget.existing!.fields.any(
                            (field) => field.id == indexed.$2.id.text,
                          ),
                      decoration: InputDecoration(
                        labelText: context.l10n.stableFieldId,
                        hintText: context.l10n.stableFieldIdHint,
                      ),
                      validator: (value) =>
                          value == null ||
                              !RegExp(
                                r'^[a-z][a-z0-9_]*$',
                              ).hasMatch(value.trim())
                          ? context.l10n.stableFieldIdHint
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: indexed.$2.label,
                      decoration: InputDecoration(
                        labelText: context.l10n.englishLabel,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? context.l10n.enterName
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: indexed.$2.labelUrdu,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: context.l10n.urduLabel,
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.l10n.required),
                      value: indexed.$2.required,
                      onChanged: (value) =>
                          setState(() => indexed.$2.required = value ?? false),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: IconButton(
                        tooltip: context.l10n.archiveField,
                        onPressed: _fields.length == 1
                            ? null
                            : () => setState(() {
                                final removed = _fields.removeAt(indexed.$1);
                                removed.dispose();
                              }),
                        icon: const Icon(Icons.archive_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: () => setState(() => _fields.add(_FieldDraft())),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addField),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(
              widget.existing == null
                  ? context.l10n.createTemplate
                  : context.l10n.saveNewVersion,
            ),
          ),
        ],
      ),
    ),
  );
}

class _FieldDraft {
  _FieldDraft({
    String id = '',
    String label = '',
    String labelUrdu = '',
    this.required = false,
  }) : id = TextEditingController(text: id),
       label = TextEditingController(text: label),
       labelUrdu = TextEditingController(text: labelUrdu);

  final TextEditingController id;
  final TextEditingController label;
  final TextEditingController labelUrdu;
  bool required;

  void dispose() {
    id.dispose();
    label.dispose();
    labelUrdu.dispose();
  }
}
