import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../measurements/measurement_models.dart';
import '../measurements/measurement_templates.dart';
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
          title: const Text('Balance still outstanding'),
          content: Text(
            '${formatPaisa(record.balancePaisa)} remains due. Mark this garment delivered anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep current status'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Mark delivered'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not update garment status. Try again.'),
          ),
        );
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
        title: const Text('Cancel order?'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep order'),
          ),
          FilledButton(
            onPressed: record.netPaidPaisa > 0
                ? null
                : () => Navigator.pop(context, true),
            child: const Text('Cancel order'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(ordersDaoProvider).cancelOrder(orderId);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not cancel this order.')),
          );
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
              title: const Text('Customer receipt'),
              subtitle: const Text('Charges, payments, and balance'),
              onTap: () => _openDocument(
                sheetContext,
                record,
                OrderDocumentKind.customerReceipt,
              ),
            ),
            if (assignments.isEmpty)
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('No karigar work slips available'),
                subtitle: Text('Assign a garment to a karigar first.'),
              ),
            ...assignments.expand(
              (assignment) => [
                ListTile(
                  leading: const Icon(Icons.engineering_outlined),
                  title: Text(
                    '${GarmentType.fromStorage(assignment.orderItem.garmentType).label} - ${assignment.karigar.name}',
                  ),
                  subtitle: const Text(
                    'Karigar work slip without financial details',
                  ),
                  onTap: () => _openDocument(
                    sheetContext,
                    record,
                    OrderDocumentKind.karigarSlip,
                    assignment,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.view_agenda_outlined),
                  title: Text('Combined page - ${assignment.karigar.name}'),
                  subtitle: const Text(
                    'Customer receipt and selected work slip',
                  ),
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
        appBar: AppBar(title: const Text('Order')),
        body: const EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load order',
          subtitle: 'Your saved data has not been changed.',
        ),
      ),
      data: (record) {
        if (record == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order')),
            body: const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Order not found',
              subtitle: 'This order is not available.',
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(record.order.orderNumber),
            actions: [
              IconButton(
                tooltip: 'Print or export documents',
                onPressed: () => _documents(context, ref, record),
                icon: const Icon(Icons.print_outlined),
              ),
              if (record.progress != OrderProgress.cancelled)
                IconButton(
                  tooltip: 'Edit delivery date and notes',
                  onPressed: () => _editSchedule(context, ref, record),
                  icon: const Icon(Icons.edit_calendar_outlined),
                ),
              if (record.progress != OrderProgress.cancelled &&
                  record.progress != OrderProgress.delivered)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'cancel') _cancel(context, ref, record);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'cancel', child: Text('Cancel order')),
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
                        'Booked ${DateFormat.yMMMd().format(record.order.bookingDate)}',
                      ),
                      Text(
                        'Delivery ${DateFormat.yMMMd().format(record.order.deliveryDate)}',
                      ),
                      Text('Progress: ${record.progress.label}'),
                      Text('Payment: ${record.paymentStatusLabel}'),
                      if (record.order.notes.isNotEmpty)
                        Text('Notes: ${record.order.notes}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Garments', style: Theme.of(context).textTheme.titleMedium),
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
                'Payment ledger',
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
                    '${payment.recordType == PaymentRecordType.refund.storageKey ? 'Refund' : 'Payment'} · ${formatPaisa(payment.amountPaisa)}',
                  ),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(payment.paymentDate)} · ${payment.method == PaymentMethod.manualBankTransfer.storageKey ? 'Manual bank transfer (unverified)' : 'Cash'}',
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: [
                      _MoneyRow(label: 'Order total', value: record.totalPaisa),
                      _MoneyRow(label: 'Net paid', value: record.netPaidPaisa),
                      const Divider(height: AppSpacing.lg),
                      _MoneyRow(
                        label: 'Balance',
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
                  label: const Text('Add payment or refund'),
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
    final garment = GarmentType.fromStorage(item.garmentType);
    final unit = MeasurementUnit.fromStorage(item.measurementUnit);
    return Card(
      child: ExpansionTile(
        title: Text('${garment.label} × ${item.quantity}'),
        subtitle: Text(
          '${item.measurementProfileName} · ${formatPaisa((item.quantity * item.stitchingPricePaisa) + item.clothChargePaisa + item.additionalChargePaisa)}',
        ),
        childrenPadding: AppSpacing.cardPadding,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: values.entries
                  .map(
                    (entry) => Text(
                      '${entry.key.replaceAll('_', ' ')}: ${entry.value} ${unit.suffix}',
                    ),
                  )
                  .toList(),
            ),
          ),
          if (item.styleInstructions.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Text('Style: ${item.styleInstructions}'),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
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
            decoration: const InputDecoration(labelText: 'Garment status'),
            items: OrderItemStatus.values
                .where((status) => status != OrderItemStatus.cancelled)
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter an amount greater than zero.')),
      );
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
          const SnackBar(
            content: Text('Payment exceeds the outstanding balance.'),
          ),
        );
      }
    } on ExcessRefundException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refund exceeds the net amount paid.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save the ledger entry. Try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Payment ledger entry'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<PaymentRecordType>(
            segments: PaymentRecordType.values
                .map(
                  (type) => ButtonSegment(value: type, label: Text(type.label)),
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
              labelText: 'Amount',
              prefixText: 'PKR ',
              helperText: _type == PaymentRecordType.payment
                  ? 'Balance: ${formatPaisa(widget.order.balancePaisa)}'
                  : 'Available to refund: ${formatPaisa(widget.order.netPaidPaisa)}',
            ),
          ),
          DropdownButtonFormField<PaymentMethod>(
            initialValue: _method,
            decoration: const InputDecoration(labelText: 'Method'),
            items: PaymentMethod.values
                .map(
                  (method) => DropdownMenuItem(
                    value: method,
                    child: Text(method.label),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => _method = value ?? PaymentMethod.cash),
          ),
          if (_method == PaymentMethod.manualBankTransfer)
            const Text(
              'Recorded manually; transfer is not electronically verified.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        child: Text(_saving ? 'Saving…' : 'Save'),
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
    title: const Text('Edit order details'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Delivery date'),
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
          decoration: const InputDecoration(labelText: 'Order notes'),
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
        child: const Text('Cancel'),
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
        child: const Text('Save'),
      ),
    ],
  );
}
