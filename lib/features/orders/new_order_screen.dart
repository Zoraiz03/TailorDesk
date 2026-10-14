import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/unsaved_changes_guard.dart';
import '../../core/localization/localization_extensions.dart';
import '../customers/customer_providers.dart';
import '../measurements/measurement_form_screen.dart';
import '../measurements/measurement_models.dart';
import '../measurements/measurement_providers.dart';
import '../settings/garment_catalog.dart';
import '../settings/garment_catalog_providers.dart';
import 'order_formatters.dart';
import 'order_models.dart';
import 'order_providers.dart';

class NewOrderScreen extends ConsumerStatefulWidget {
  const NewOrderScreen({super.key, this.initialCustomer});

  final Customer? initialCustomer;

  @override
  ConsumerState<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends ConsumerState<NewOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notes = TextEditingController();
  final _advance = TextEditingController();
  late final String _submissionKey;
  late DateTime _bookingDate;
  late DateTime _deliveryDate;
  int? _customerId;
  final List<_DraftLine> _lines = [];
  PaymentMethod _advanceMethod = PaymentMethod.cash;
  bool _saving = false;
  bool _saved = false;
  String _customerQuery = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _submissionKey = 'order-${now.microsecondsSinceEpoch}';
    _bookingDate = DateTime(now.year, now.month, now.day);
    _deliveryDate = _bookingDate.add(const Duration(days: 7));
    _customerId = widget.initialCustomer?.id;
    _notes.addListener(_refreshDirtyState);
    _advance.addListener(_refreshDirtyState);
  }

  void _refreshDirtyState() {
    if (mounted) setState(() {});
  }

  bool get _hasUnsavedChanges =>
      !_saved &&
      (_customerId != null ||
          _lines.isNotEmpty ||
          _notes.text.isNotEmpty ||
          _advance.text.isNotEmpty);

  @override
  void dispose() {
    _notes.dispose();
    _advance.dispose();
    super.dispose();
  }

  int get _total => _lines.fold(0, (sum, line) => sum + line.draft.totalPaisa);

  Future<void> _pickDeliveryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: _bookingDate,
      lastDate: DateTime(_bookingDate.year + 5),
    );
    if (picked != null) setState(() => _deliveryDate = picked);
  }

  Future<void> _addLine(
    List<MeasurementProfileRecord> profiles,
    Map<String, GarmentCatalogRecord> catalog,
  ) async {
    if (profiles.isEmpty) return;
    final line = await showDialog<_DraftLine>(
      context: context,
      builder: (_) => _LineDialog(profiles: profiles, catalog: catalog),
    );
    if (line != null) setState(() => _lines.add(line));
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    if (_customerId == null) return;
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.addGarmentLine)));
      return;
    }
    final advance = _advance.text.trim().isEmpty
        ? 0
        : parseRupeesToPaisa(_advance.text);
    if (advance == null || advance < 0 || advance > _total) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.advanceLimit)));
      return;
    }
    setState(() => _saving = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.reviewOrder),
        content: Text(
          '${_lines.length} garment line${_lines.length == 1 ? '' : 's'}\n'
          'Delivery: ${DateFormat.yMMMd().format(_deliveryDate)}\n'
          'Total: ${formatPaisa(_total)}\n'
          'Advance: ${formatPaisa(advance)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.goBack),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.saveOrder),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      if (mounted) setState(() => _saving = false);
      return;
    }
    try {
      final id = await ref
          .read(ordersDaoProvider)
          .createOrder(
            NewOrderDraft(
              submissionKey: _submissionKey,
              customerId: _customerId!,
              bookingDate: _bookingDate,
              deliveryDate: _deliveryDate,
              lines: _lines.map((line) => line.draft).toList(),
              notes: _notes.text,
              advancePaisa: advance,
              advanceMethod: _advanceMethod,
            ),
          );
      if (mounted) {
        setState(() => _saved = true);
        await WidgetsBinding.instance.endOfFrame;
        if (mounted) Navigator.pop(context, id);
      }
    } on DuplicateOrderSubmissionException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.orderAlreadySaved)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.orderSaveFailed)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider);
    final profiles = _customerId == null
        ? const AsyncValue<List<MeasurementProfileRecord>>.data([])
        : ref.watch(customerMeasurementRevisionsProvider(_customerId!));
    final enabledCatalog = ref.watch(enabledGarmentCatalogProvider);
    final catalogById = {
      for (final item in enabledCatalog.value ?? const <GarmentCatalogRecord>[])
        item.entry.garmentId: item,
    };
    final selectedCustomer = customers.value
        ?.where((c) => c.id == _customerId)
        .firstOrNull;
    return UnsavedChangesGuard(
      hasUnsavedChanges: _hasUnsavedChanges,
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.newOrder)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: AppSpacing.pagePadding,
            children: [
              Text(
                context.l10n.customer,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              customers.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(context.l10n.couldNotLoadCustomers),
                data: (values) {
                  final query = _customerQuery.trim().toLowerCase();
                  final visible = values.where((customer) {
                    if (customer.id == _customerId) return true;
                    return '${customer.name} ${customer.phone}'
                        .toLowerCase()
                        .contains(query);
                  }).toList();
                  return Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: context.l10n.searchCustomers,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) =>
                            setState(() => _customerQuery = value),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<int>(
                        initialValue: _customerId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: context.l10n.selectCustomer,
                        ),
                        items: visible
                            .map(
                              (customer) => DropdownMenuItem(
                                value: customer.id,
                                child: Text(
                                  '${customer.name} · ${customer.phone}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        validator: (value) =>
                            value == null ? context.l10n.selectCustomer : null,
                        onChanged: (value) => setState(() {
                          _customerId = value;
                          _lines.clear();
                        }),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                context.l10n.garments,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ..._lines.indexed.map((entry) {
                final index = entry.$1;
                final line = entry.$2;
                return Card(
                  child: ListTile(
                    title: Text(
                      '${line.garmentLabel} × ${line.draft.quantity}',
                    ),
                    subtitle: Text(
                      '${line.profileName} · ${formatPaisa(line.draft.totalPaisa)}',
                    ),
                    trailing: IconButton(
                      tooltip: context.l10n.removeGarment,
                      onPressed: () => setState(() => _lines.removeAt(index)),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              }),
              profiles.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(context.l10n.couldNotLoadMeasurements),
                data: (values) {
                  final enabledValues = values
                      .where(
                        (record) => catalogById.containsKey(
                          record.latestRevision.garmentType,
                        ),
                      )
                      .toList();
                  if (_customerId != null && enabledValues.isEmpty) {
                    return OutlinedButton.icon(
                      onPressed: selectedCustomer == null
                          ? null
                          : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MeasurementFormScreen(
                                  customer: selectedCustomer,
                                ),
                              ),
                            ),
                      icon: const Icon(Icons.straighten),
                      label: Text(context.l10n.createMeasurementsFirst),
                    );
                  }
                  return OutlinedButton.icon(
                    onPressed: enabledValues.isEmpty
                        ? null
                        : () => _addLine(enabledValues, catalogById),
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.addGarment),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                '${context.l10n.deliveryDate} & ${context.l10n.notes}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.deliveryDate),
                subtitle: Text(DateFormat.yMMMd().format(_deliveryDate)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDeliveryDate,
              ),
              TextFormField(
                controller: _notes,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.l10n.orderNotesOptional,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                context.l10n.payment,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _advance,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: context.l10n.advancePkr,
                  prefixText: 'PKR ',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<PaymentMethod>(
                initialValue: _advanceMethod,
                decoration: InputDecoration(
                  labelText: context.l10n.advanceMethod,
                ),
                items: PaymentMethod.values
                    .map(
                      (method) => DropdownMenuItem(
                        value: method,
                        child: Text(
                          localizedPaymentMethod(
                            context.l10n,
                            method.storageKey,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(
                  () => _advanceMethod = value ?? PaymentMethod.cash,
                ),
              ),
              if (_advanceMethod == PaymentMethod.manualBankTransfer)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(context.l10n.manualTransferNotice),
                ),
              const SizedBox(height: AppSpacing.xxl),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Row(
                    children: [
                      Expanded(child: Text(context.l10n.orderTotal)),
                      Text(
                        formatPaisa(_total),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  _saving ? context.l10n.saving : context.l10n.reviewOrder,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftLine {
  const _DraftLine({
    required this.draft,
    required this.garmentLabel,
    required this.profileName,
  });
  final OrderLineDraft draft;
  final String garmentLabel;
  final String profileName;
}

class _LineDialog extends StatefulWidget {
  const _LineDialog({required this.profiles, required this.catalog});
  final List<MeasurementProfileRecord> profiles;
  final Map<String, GarmentCatalogRecord> catalog;

  @override
  State<_LineDialog> createState() => _LineDialogState();
}

class _LineDialogState extends State<_LineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController(text: '1');
  final _stitching = TextEditingController();
  final _cloth = TextEditingController();
  final _additional = TextEditingController();
  final _additionalDescription = TextEditingController();
  final _style = TextEditingController();
  late MeasurementProfileRecord _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profiles.first;
    _style.text = _profile.latestRevision.styleInstructions;
    _applyDefaultPrice();
  }

  void _applyDefaultPrice() {
    final price = widget
        .catalog[_profile.latestRevision.garmentType]
        ?.entry
        .defaultStitchingPricePaisa;
    _stitching.text = price == null || price == 0 ? '' : '${price ~/ 100}';
  }

  @override
  void dispose() {
    for (final controller in [
      _quantity,
      _stitching,
      _cloth,
      _additional,
      _additionalDescription,
      _style,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  int _money(TextEditingController controller) => controller.text.trim().isEmpty
      ? 0
      : (parseRupeesToPaisa(controller.text) ?? -1);

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final additional = _money(_additional);
    if (additional > 0 && _additionalDescription.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.describeAdditionalCharge)),
      );
      return;
    }
    final garmentLabel = localizedGarmentLabel(
      context.l10n,
      _profile.latestRevision.garmentType,
      english: _profile.latestRevision.garmentLabelEnglish,
      urdu: _profile.latestRevision.garmentLabelUrdu,
    );
    Navigator.pop(
      context,
      _DraftLine(
        garmentLabel: garmentLabel,
        profileName: _profile.latestRevision.profileName,
        draft: OrderLineDraft(
          measurementRevisionId: _profile.latestRevision.id,
          quantity: int.parse(_quantity.text),
          stitchingPricePaisa: _money(_stitching),
          clothChargePaisa: _money(_cloth),
          additionalChargePaisa: additional,
          additionalChargeDescription: _additionalDescription.text,
          styleInstructions: _style.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration(String label) =>
        InputDecoration(labelText: label, prefixText: 'PKR ');
    String? moneyValidator(String? value, {bool optional = false}) {
      if (optional && (value == null || value.trim().isEmpty)) return null;
      final parsed = parseRupeesToPaisa(value ?? '');
      return parsed == null || parsed < 0 ? context.l10n.enterNumber : null;
    }

    return AlertDialog(
      title: Text(context.l10n.addGarment),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<MeasurementProfileRecord>(
                  initialValue: _profile,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.measurementProfile,
                  ),
                  items: widget.profiles.map((record) {
                    final revision = record.latestRevision;
                    return DropdownMenuItem(
                      value: record,
                      child: Text(
                        '${localizedGarmentLabel(context.l10n, revision.garmentType, english: revision.garmentLabelEnglish, urdu: revision.garmentLabelUrdu)} · ${revision.profileName} · ${context.l10n.revisionNumber(revision.revisionNumber)}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() {
                    _profile = value ?? _profile;
                    _style.text = _profile.latestRevision.styleInstructions;
                    _applyDefaultPrice();
                  }),
                ),
                TextFormField(
                  controller: _quantity,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: context.l10n.quantity),
                  validator: (value) => (int.tryParse(value ?? '') ?? 0) <= 0
                      ? context.l10n.enterNumber
                      : null,
                ),
                TextFormField(
                  controller: _stitching,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: decoration(context.l10n.stitchingPrice),
                  validator: (value) => moneyValidator(value),
                ),
                TextFormField(
                  controller: _cloth,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: decoration(context.l10n.clothCharge),
                  validator: (value) => moneyValidator(value, optional: true),
                ),
                TextFormField(
                  controller: _additional,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: decoration(context.l10n.additionalCharge),
                  validator: (value) => moneyValidator(value, optional: true),
                ),
                TextFormField(
                  controller: _additionalDescription,
                  decoration: InputDecoration(
                    labelText: context.l10n.additionalChargeDescription,
                  ),
                ),
                TextFormField(
                  controller: _style,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: context.l10n.styleInstructions,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Uses revision ${_profile.latestRevision.revisionNumber}. Its ${_profile.latestRevision.unit} values and instructions will be frozen with the order.',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(context.l10n.addLine)),
      ],
    );
  }
}
