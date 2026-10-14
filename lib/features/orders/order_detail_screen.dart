import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/localization/localization_extensions.dart';
import '../measurements/measurement_models.dart';
import '../measurements/measurement_templates.dart';
import '../settings/garment_catalog.dart';
import '../karigars/order_item_assignment_card.dart';
import '../karigars/karigar_models.dart';
import '../karigars/karigar_providers.dart';
import '../documents/document_preview_screen.dart';
import '../documents/order_document_service.dart';
import 'order_formatters.dart';
import 'order_models.dart';
import 'order_providers.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final int orderId;

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    OrderRecord record,
    int itemId,
    OrderItemStatus status,
  ) async {
    if (status == OrderItemStatus.delivered && record.balancePaisa > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(context.l10n.balanceOutstandingTitle),
          content: Text(
            '${formatPaisa(record.balancePaisa)} remains due. Mark this garment delivered anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.keepCurrentStatus),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.markDelivered),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    try {
      await ref.read(ordersDaoProvider).updateItemStatus(itemId, status);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.updateFailed)));
      }
    }
  }

  Future<void> _addLedger(
    BuildContext context,
    WidgetRef ref,
    OrderRecord record,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _LedgerDialog(order: record, ref: ref),
    );
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    OrderRecord record,
  ) async {
    final message = record.netPaidPaisa > 0
        ? 'Refund ${formatPaisa(record.netPaidPaisa)} before cancelling. Payment history will be preserved.'
        : 'Cancellation keeps the order history and removes its lines from the active total.';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.cancelOrderQuestion),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.keepOrder),
          ),
          FilledButton(
            onPressed: record.netPaidPaisa > 0
                ? null
                : () => Navigator.pop(context, true),
            child: Text(context.l10n.cancelOrder),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(ordersDaoProvider).cancelOrder(orderId);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.l10n.updateFailed)));
        }
      }
    }
  }

  Future<void> _editSchedule(
    BuildContext context,
    WidgetRef ref,
    OrderRecord record,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ScheduleDialog(order: record, ref: ref),
    );
  }

  Future<void> _documents(
    BuildContext context,
    WidgetRef ref,
    OrderRecord record,
  ) async {
    final histories = await Future.wait(
      record.items.map(
        (item) => ref
            .read(karigarsDaoProvider)
            .watchAssignmentsForItem(item.id)
            .first,
      ),
    );
    final assignments = <AssignmentRecord>[];
    for (final history in histories) {
      final active = history.where((entry) => entry.isActive).firstOrNull;
      final latest = active ?? history.firstOrNull;
      if (latest != null) assignments.add(latest);
    }
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(context.l10n.customerReceipt),
              subtitle: Text(context.l10n.receiptSubtitle),
              onTap: () => _openDocument(
                sheetContext,
                record,
                OrderDocumentKind.customerReceipt,
              ),
            ),
            if (assignments.isEmpty)
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(context.l10n.noWorkSlips),
                subtitle: Text(context.l10n.assignGarmentFirst),
              ),
            ...assignments.expand(
              (assignment) => [
                ListTile(
                  leading: const Icon(Icons.engineering_outlined),
                  title: Text(
                    '${localizedGarmentLabel(context.l10n, assignment.orderItem.garmentType, english: assignment.orderItem.garmentLabelEnglish, urdu: assignment.orderItem.garmentLabelUrdu)} — ${assignment.karigar.name}',
                  ),
                  subtitle: Text(context.l10n.financialPrivacyNotice),
                  onTap: () => _openDocument(
                    sheetContext,
                    record,
                    OrderDocumentKind.karigarSlip,
                    assignment,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.view_agenda_outlined),
                  title: Text(
                    context.l10n.combinedPageFor(assignment.karigar.name),
                  ),
                  subtitle: Text(context.l10n.combinedDocument),
                  onTap: () => _openDocument(
                    sheetContext,
                    record,
                    OrderDocumentKind.combined,
                    assignment,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDocument(
    BuildContext sheetContext,
    OrderRecord record,
    OrderDocumentKind kind, [
    AssignmentRecord? assignment,
  ]) {
    final navigator = Navigator.of(sheetContext, rootNavigator: true);
    Navigator.pop(sheetContext);
    navigator.push(
      MaterialPageRoute(
        builder: (_) => DocumentPreviewScreen(
          kind: kind,
          order: record,
          assignment: assignment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderProvider(orderId));
    return order.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.order)),
        body: EmptyState(
          icon: Icons.error_outline,
          title: context.l10n.couldNotLoad,
          subtitle: context.l10n.savedDataUnchanged,
        ),
      ),
      data: (record) {
        if (record == null) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.order)),
            body: EmptyState(
              icon: Icons.receipt_long_outlined,
              title: context.l10n.orderNotFound,
              subtitle: context.l10n.orderNotFoundHelp,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(record.order.orderNumber),
            actions: [
              IconButton(
                tooltip: context.l10n.printExportDocuments,
                onPressed: () => _documents(context, ref, record),
                icon: const Icon(Icons.print_outlined),
              ),
              if (record.progress != OrderProgress.cancelled)
                IconButton(
                  tooltip: context.l10n.editOrderDetails,
                  onPressed: () => _editSchedule(context, ref, record),
                  icon: const Icon(Icons.edit_calendar_outlined),
                ),
              if (record.progress != OrderProgress.cancelled &&
                  record.progress != OrderProgress.delivered)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'cancel') _cancel(context, ref, record);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'cancel',
                      child: Text(context.l10n.cancelOrder),
                    ),
                  ],
                ),
            ],
          ),
          body: ListView(
            padding: AppSpacing.pagePadding,
            children: [
              Card(
                color: record.balancePaisa > 0
                    ? AppColors.goldLight
                    : AppColors.successBg,
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.customer.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(record.customer.phone),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '${context.l10n.booked} ${DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(record.order.bookingDate)}',
                      ),
                      Text(
                        '${context.l10n.deliveryDate} ${DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(record.order.deliveryDate)}',
                      ),
                      Text(
                        context.l10n.progressLabel(
                          localizedStatus(context.l10n, record.progress.name),
                        ),
                      ),
                      Text(
                        context.l10n.paymentLabel(record.paymentStatusLabel),
                      ),
                      if (record.order.notes.isNotEmpty)
                        Text(context.l10n.notesPrefix(record.order.notes)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                context.l10n.garments,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...record.items.map(
                (item) => _OrderItemCard(
                  item: item,
                  orderDeliveryDate: record.order.deliveryDate,
                  enabled: record.progress != OrderProgress.cancelled,
                  onStatusChanged: (status) =>
                      _changeStatus(context, ref, record, item.id, status),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                context.l10n.paymentsRefunds,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...record.payments.map(
                (payment) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    payment.recordType == PaymentRecordType.refund.storageKey
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                  ),
                  title: Text(
                    '${payment.recordType == PaymentRecordType.refund.storageKey ? context.l10n.refund : context.l10n.payment} · ${formatPaisa(payment.amountPaisa)}',
                  ),
                  subtitle: Text(
                    '${DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(payment.paymentDate)} · ${localizedPaymentMethod(context.l10n, payment.method)}',
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: [
                      _MoneyRow(
                        label: context.l10n.orderTotal,
                        value: record.totalPaisa,
                      ),
                      _MoneyRow(
                        label: context.l10n.netPaid,
                        value: record.netPaidPaisa,
                      ),
                      const Divider(height: AppSpacing.lg),
                      _MoneyRow(
                        label: context.l10n.balance,
                        value: record.balancePaisa,
                        prominent: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (record.progress != OrderProgress.cancelled)
                FilledButton.icon(
                  onPressed: () => _addLedger(context, ref, record),
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(context.l10n.addPaymentRefund),
                ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({
    required this.item,
    required this.orderDeliveryDate,
    required this.enabled,
    required this.onStatusChanged,
  });
  final OrderItem item;
  final DateTime orderDeliveryDate;
  final bool enabled;
  final ValueChanged<OrderItemStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final values = decodeMeasurementValues(item.measurementValuesJson);
    final garmentLabel = localizedGarmentLabel(
      context.l10n,
      item.garmentType,
      english: item.garmentLabelEnglish,
      urdu: item.garmentLabelUrdu,
    );
    final fields = decodeFieldDefinitions(
      item.measurementFieldDefinitionsJson,
      item.garmentType,
    );
    final labels = {
      for (final field in fields)
        field.id: localizedMeasurementLabel(
          context.l10n,
          field.id,
          english: field.label,
          urdu: field.labelUrdu,
        ),
    };
    final unit = MeasurementUnit.fromStorage(item.measurementUnit);
    return Card(
      child: ExpansionTile(
        title: Text('$garmentLabel × ${item.quantity}'),
        subtitle: Text(
          '${item.measurementProfileName} · ${formatPaisa((item.quantity * item.stitchingPricePaisa) + item.clothChargePaisa + item.additionalChargePaisa)}',
        ),
        childrenPadding: AppSpacing.cardPadding,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: values.entries
                  .map(
                    (entry) => Text(
                      '${labels[entry.key] ?? entry.key.replaceAll('_', ' ')}: ${entry.value} ${unit.suffix}',
                    ),
                  )
                  .toList(),
            ),
          ),
          if (item.styleInstructions.isNotEmpty)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Text(context.l10n.stylePrefix(item.styleInstructions)),
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Text(
                'Stitching: ${formatPaisa(item.stitchingPricePaisa)} × ${item.quantity}\n'
                'Cloth: ${formatPaisa(item.clothChargePaisa)}\n'
                'Additional: ${formatPaisa(item.additionalChargePaisa)}'
                '${item.additionalChargeDescription.isEmpty ? '' : ' · ${item.additionalChargeDescription}'}',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OrderItemAssignmentCard(
            item: item,
            orderDeliveryDate: orderDeliveryDate,
            enabled: enabled,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<OrderItemStatus>(
            initialValue: OrderItemStatus.fromStorage(item.status),
            decoration: InputDecoration(labelText: context.l10n.garmentStatus),
            items: OrderItemStatus.values
                .where((status) => status != OrderItemStatus.cancelled)
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(
                      localizedStatus(context.l10n, status.storageKey),
                    ),
                  ),
                )
                .toList(),
            onChanged: enabled
                ? (status) {
                    if (status != null) onStatusChanged(status);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.value,
    this.prominent = false,
  });
  final String label;
  final int value;
  final bool prominent;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          formatPaisa(value),
          style: prominent
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: value > 0 ? AppColors.error : AppColors.primary,
                )
              : null,
        ),
      ],
    ),
  );
}

class _LedgerDialog extends StatefulWidget {
  const _LedgerDialog({required this.order, required this.ref});
  final OrderRecord order;
  final WidgetRef ref;
  @override
  State<_LedgerDialog> createState() => _LedgerDialogState();
}

class _LedgerDialogState extends State<_LedgerDialog> {
  final _amount = TextEditingController();
  final _notes = TextEditingController();
  PaymentRecordType _type = PaymentRecordType.payment;
  PaymentMethod _method = PaymentMethod.cash;
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = parseRupeesToPaisa(_amount.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.enterPositiveAmount)));
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.ref
          .read(ordersDaoProvider)
          .addLedgerEntry(
            orderId: widget.order.order.id,
            amountPaisa: amount,
            type: _type,
            method: _method,
            date: DateTime.now(),
            notes: _notes.text,
          );
      if (mounted) Navigator.pop(context);
    } on ExcessPaymentException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.paymentExceedsBalance)),
        );
      }
    } on ExcessRefundException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.refundExceedsPaid)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.updateFailed)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.ledgerEntry),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<PaymentRecordType>(
            segments: PaymentRecordType.values
                .map(
                  (type) => ButtonSegment(
                    value: type,
                    label: Text(
                      type == PaymentRecordType.refund
                          ? context.l10n.refund
                          : context.l10n.payment,
                    ),
                  ),
                )
                .toList(),
            selected: {_type},
            onSelectionChanged: (value) => setState(() => _type = value.first),
          ),
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: context.l10n.amount,
              prefixText: 'PKR ',
              helperText: _type == PaymentRecordType.payment
                  ? 'Balance: ${formatPaisa(widget.order.balancePaisa)}'
                  : 'Available to refund: ${formatPaisa(widget.order.netPaidPaisa)}',
            ),
          ),
          DropdownButtonFormField<PaymentMethod>(
            initialValue: _method,
            decoration: InputDecoration(labelText: context.l10n.method),
            items: PaymentMethod.values
                .map(
                  (method) => DropdownMenuItem(
                    value: method,
                    child: Text(
                      localizedPaymentMethod(context.l10n, method.storageKey),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _method = value ?? PaymentMethod.cash),
          ),
          if (_method == PaymentMethod.manualBankTransfer)
            Text(
              context.l10n.manualTransferNotice,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          TextField(
            controller: _notes,
            decoration: InputDecoration(labelText: context.l10n.notesOptional),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        child: Text(_saving ? context.l10n.saving : context.l10n.save),
      ),
    ],
  );
}

class _ScheduleDialog extends StatefulWidget {
  const _ScheduleDialog({required this.order, required this.ref});
  final OrderRecord order;
  final WidgetRef ref;

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  late DateTime _deliveryDate;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _deliveryDate = widget.order.order.deliveryDate;
    _notes = TextEditingController(text: widget.order.order.notes);
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.editOrderDetails),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.deliveryDate),
          subtitle: Text(DateFormat.yMMMd().format(_deliveryDate)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _deliveryDate,
              firstDate: widget.order.order.bookingDate,
              lastDate: DateTime(widget.order.order.bookingDate.year + 5),
            );
            if (picked != null) setState(() => _deliveryDate = picked);
          },
        ),
        TextField(
          controller: _notes,
          maxLines: 3,
          decoration: InputDecoration(labelText: context.l10n.orderNotes),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Booked charges and measurement snapshots cannot be edited.',
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () async {
          await widget.ref
              .read(ordersDaoProvider)
              .updateSchedule(
                orderId: widget.order.order.id,
                deliveryDate: _deliveryDate,
                notes: _notes.text,
              );
          if (context.mounted) Navigator.pop(context);
        },
        child: Text(context.l10n.save),
      ),
    ],
  );
}
