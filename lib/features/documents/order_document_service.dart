import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/database/app_database.dart';
import '../karigars/karigar_models.dart';
import '../measurements/measurement_models.dart';
import '../measurements/measurement_templates.dart';
import '../orders/order_formatters.dart';
import '../orders/order_models.dart';
import '../settings/shop_settings.dart';

enum OrderDocumentKind { customerReceipt, karigarSlip, combined }

class GeneratedOrderDocument {
  const GeneratedOrderDocument({
    required this.bytes,
    required this.fileName,
    required this.auditText,
  });

  final Uint8List bytes;
  final String fileName;

  /// Deterministic content projection used by tests and accessibility checks.
  final String auditText;
}

class OrderDocumentService {
  Future<GeneratedOrderDocument> generate({
    required OrderDocumentKind kind,
    required ShopDetails shop,
    required OrderRecord order,
    AssignmentRecord? assignment,
    DateTime? generatedAt,
  }) async {
    if (kind != OrderDocumentKind.customerReceipt && assignment == null) {
      throw ArgumentError('A karigar assignment is required for this document');
    }
    final regularData = await rootBundle.load(
      'assets/fonts/Roboto-Regular.ttf',
    );
    final mediumData = await rootBundle.load('assets/fonts/Roboto-Medium.ttf');
    return generateWithFonts(
      kind: kind,
      shop: shop,
      order: order,
      assignment: assignment,
      generatedAt: generatedAt,
      regularFont: regularData,
      mediumFont: mediumData,
    );
  }

  Future<GeneratedOrderDocument> generateWithFonts({
    required OrderDocumentKind kind,
    required ShopDetails shop,
    required OrderRecord order,
    required ByteData regularFont,
    required ByteData mediumFont,
    AssignmentRecord? assignment,
    DateTime? generatedAt,
  }) async {
    final created = generatedAt ?? DateTime.now();
    final regular = pw.Font.ttf(regularFont);
    final medium = pw.Font.ttf(mediumFont);
    final theme = pw.ThemeData.withFont(base: regular, bold: medium);
    final document = pw.Document(
      theme: theme,
      title: _title(kind, order.order.orderNumber),
      author: shop.name,
      creator: 'TailorDesk',
    );

    if (kind == OrderDocumentKind.combined && order.items.length == 1) {
      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(34, 32, 34, 34),
          build: (_) => pw.Column(
            children: [
              _pageHeader(shop, order.order.orderNumber, kind, 1, 1),
              ..._compactCombinedWidgets(shop, order, assignment!),
              pw.Spacer(),
              _pageFooter(created, 1, 1),
            ],
          ),
        ),
      );
    } else {
      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(34, 32, 34, 34),
          maxPages: 100,
          header: (context) => _pageHeader(
            shop,
            order.order.orderNumber,
            kind,
            context.pageNumber,
            context.pagesCount,
          ),
          footer: (context) =>
              _pageFooter(created, context.pageNumber, context.pagesCount),
          build: (_) {
            final content = <pw.Widget>[];
            if (kind == OrderDocumentKind.customerReceipt ||
                kind == OrderDocumentKind.combined) {
              content.addAll(_receiptWidgets(shop, order));
            }
            if (kind == OrderDocumentKind.combined) {
              content.addAll([
                pw.SizedBox(height: 18),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 12),
              ]);
            }
            if (kind == OrderDocumentKind.karigarSlip ||
                kind == OrderDocumentKind.combined) {
              content.addAll(_workSlipWidgets(order, assignment!));
            }
            return content;
          },
        ),
      );
    }

    final suffix = switch (kind) {
      OrderDocumentKind.customerReceipt => 'receipt',
      OrderDocumentKind.karigarSlip => 'work-slip',
      OrderDocumentKind.combined => 'combined',
    };
    return GeneratedOrderDocument(
      bytes: await document.save(),
      fileName: '${order.order.orderNumber}-$suffix.pdf',
      auditText: buildAuditText(
        kind: kind,
        shop: shop,
        order: order,
        assignment: assignment,
        generatedAt: created,
      ),
    );
  }

  String buildAuditText({
    required OrderDocumentKind kind,
    required ShopDetails shop,
    required OrderRecord order,
    AssignmentRecord? assignment,
    DateTime? generatedAt,
  }) {
    final lines = <String>[shop.name, order.order.orderNumber];
    if (kind == OrderDocumentKind.customerReceipt ||
        kind == OrderDocumentKind.combined) {
      lines.addAll([
        'ORDER RECEIPT',
        order.customer.name,
        ...order.items.map(
          (item) =>
              '${_garmentLabel(item.garmentType)} x ${item.quantity}${item.status == 'cancelled' ? ' CANCELLED EXCLUDED' : ''}',
        ),
        'Order total ${formatPaisa(order.totalPaisa)}',
        'Net paid ${formatPaisa(order.netPaidPaisa)}',
        'Balance ${formatPaisa(order.balancePaisa)}',
        'Payment ${order.paymentStatusLabel}',
      ]);
    }
    if (kind == OrderDocumentKind.karigarSlip ||
        kind == OrderDocumentKind.combined) {
      if (assignment == null) throw ArgumentError('Assignment required');
      final item = assignment.orderItem;
      final unit = MeasurementUnit.fromStorage(item.measurementUnit).suffix;
      lines.addAll([
        'KARIGAR WORK SLIP',
        assignment.karigar.name,
        '${_garmentLabel(item.garmentType)} x ${item.quantity}',
        ...decodeMeasurementValues(item.measurementValuesJson).entries.map(
          (entry) =>
              '${_measurementLabel(item.garmentType, entry.key)} ${entry.value} $unit',
        ),
        item.styleInstructions,
        assignment.assignment.workInstructions,
      ]);
    }
    lines.add('Generated ${(generatedAt ?? DateTime.now()).toIso8601String()}');
    return lines.where((line) => line.trim().isNotEmpty).join('\n');
  }

  List<pw.Widget> _receiptWidgets(ShopDetails shop, OrderRecord order) {
    final date = DateFormat('d MMM yyyy');
    return [
      _sectionTitle('ORDER RECEIPT'),
      pw.SizedBox(height: 8),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: _details([
              ['Customer', order.customer.name],
              ['Phone', order.customer.phone],
              if (order.customer.address.isNotEmpty)
                ['Address', order.customer.address],
            ]),
          ),
          pw.SizedBox(width: 18),
          pw.Expanded(
            child: _details([
              ['Order', order.order.orderNumber],
              ['Booked', date.format(order.order.bookingDate)],
              ['Promised', date.format(order.order.deliveryDate)],
            ]),
          ),
        ],
      ),
      pw.SizedBox(height: 14),
      ...order.items.map(_receiptItem),
      pw.SizedBox(height: 10),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Container(
          width: 230,
          padding: const pw.EdgeInsets.all(10),
          decoration: _boxDecoration(),
          child: pw.Column(
            children: [
              _amountRow('Order total', order.totalPaisa),
              _amountRow('Net paid', order.netPaidPaisa),
              pw.Divider(),
              _amountRow('Balance', order.balancePaisa, bold: true),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Payment status: ${order.paymentStatusLabel}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
        ),
      ),
      if (order.payments.any(
        (payment) => payment.method == 'manual_bank_transfer',
      )) ...[
        pw.SizedBox(height: 8),
        pw.Text(
          'Manual bank transfers are recorded but not electronically verified.',
          style: const pw.TextStyle(fontSize: 8),
        ),
      ],
      if (order.order.notes.isNotEmpty) ...[
        pw.SizedBox(height: 12),
        _noteBox('Order notes', order.order.notes),
      ],
      if (shop.receiptFooter.isNotEmpty) ...[
        pw.SizedBox(height: 16),
        pw.Center(
          child: pw.Text(
            shop.receiptFooter,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
      ],
    ];
  }

  List<pw.Widget> _compactCombinedWidgets(
    ShopDetails shop,
    OrderRecord order,
    AssignmentRecord assignment,
  ) {
    final item = order.items.single;
    final cancelled = item.status == 'cancelled';
    final itemTotal = cancelled
        ? 0
        : (item.quantity * item.stitchingPricePaisa) +
              item.clothChargePaisa +
              item.additionalChargePaisa;
    final unit = MeasurementUnit.fromStorage(item.measurementUnit);
    final deadline = assignment.assignment.internalDeadline;
    return [
      _sectionTitle('ORDER RECEIPT'),
      pw.SizedBox(height: 5),
      _details([
        ['Customer', '${order.customer.name} - ${order.customer.phone}'],
        [
          'Dates',
          'Booked ${DateFormat('d MMM yyyy').format(order.order.bookingDate)} - Promised ${DateFormat('d MMM yyyy').format(order.order.deliveryDate)}',
        ],
      ]),
      pw.SizedBox(height: 5),
      pw.Container(
        padding: const pw.EdgeInsets.all(7),
        decoration: _boxDecoration(
          color: cancelled ? PdfColors.grey200 : PdfColors.white,
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${_garmentLabel(item.garmentType)} x ${item.quantity}${cancelled ? ' - CANCELLED' : ''}',
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(formatPaisa(itemTotal)),
          ],
        ),
      ),
      pw.SizedBox(height: 5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text('Total ${formatPaisa(order.totalPaisa)}  |  '),
          pw.Text('Paid ${formatPaisa(order.netPaidPaisa)}  |  '),
          pw.Text(
            'Balance ${formatPaisa(order.balancePaisa)}',
            style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Payment status: ${order.paymentStatusLabel}',
          style: const pw.TextStyle(fontSize: 8),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Divider(borderStyle: pw.BorderStyle.dashed),
      pw.SizedBox(height: 7),
      _sectionTitle('KARIGAR WORK SLIP'),
      pw.SizedBox(height: 5),
      _details([
        ['Karigar', assignment.karigar.name],
        ['Garment', '${_garmentLabel(item.garmentType)} x ${item.quantity}'],
        if (deadline != null)
          ['Internal deadline', DateFormat('d MMM yyyy').format(deadline)],
      ]),
      pw.SizedBox(height: 5),
      pw.Container(
        padding: const pw.EdgeInsets.all(7),
        decoration: _boxDecoration(),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Frozen measurements (${unit.label})',
              style: const pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Wrap(
              spacing: 10,
              runSpacing: 4,
              children: decodeMeasurementValues(item.measurementValuesJson)
                  .entries
                  .map((entry) {
                    return pw.SizedBox(
                      width: 145,
                      child: pw.Text(
                        '${_measurementLabel(item.garmentType, entry.key)}: ${entry.value} ${unit.suffix}',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    );
                  })
                  .toList(),
            ),
          ],
        ),
      ),
      if (item.styleInstructions.isNotEmpty) ...[
        pw.SizedBox(height: 5),
        _compactNote('Style instructions', item.styleInstructions),
      ],
      if (assignment.assignment.workInstructions.isNotEmpty) ...[
        pw.SizedBox(height: 5),
        _compactNote('Work notes', assignment.assignment.workInstructions),
      ],
      if (shop.receiptFooter.isNotEmpty) ...[
        pw.SizedBox(height: 7),
        pw.Center(
          child: pw.Text(
            shop.receiptFooter,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
      ],
    ];
  }

  pw.Widget _compactNote(String title, String value) => pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(6),
    decoration: _boxDecoration(color: const PdfColor.fromInt(0xfff7f5f0)),
    child: pw.RichText(
      text: pw.TextSpan(
        style: const pw.TextStyle(fontSize: 8),
        children: [
          pw.TextSpan(
            text: '$title: ',
            style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(text: value),
        ],
      ),
    ),
  );

  pw.Widget _receiptItem(OrderItem item) {
    final cancelled = item.status == 'cancelled';
    final total =
        (item.quantity * item.stitchingPricePaisa) +
        item.clothChargePaisa +
        item.additionalChargePaisa;
    return pw.Inseparable(
      child: pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 7),
        padding: const pw.EdgeInsets.all(9),
        decoration: _boxDecoration(
          color: cancelled ? PdfColors.grey200 : PdfColors.white,
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${_garmentLabel(item.garmentType)} x ${item.quantity}',
                    style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  if (item.additionalChargeDescription.isNotEmpty)
                    pw.Text(
                      item.additionalChargeDescription,
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  if (cancelled)
                    pw.Text(
                      'CANCELLED - excluded from charges',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.red700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            pw.Text(
              cancelled ? 'PKR 0' : formatPaisa(total),
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<pw.Widget> _workSlipWidgets(
    OrderRecord order,
    AssignmentRecord assignment,
  ) {
    final item = assignment.orderItem;
    final unit = MeasurementUnit.fromStorage(item.measurementUnit);
    final values = decodeMeasurementValues(item.measurementValuesJson);
    final deadline = assignment.assignment.internalDeadline;
    return [
      _sectionTitle('KARIGAR WORK SLIP'),
      pw.SizedBox(height: 8),
      _details([
        ['Order', order.order.orderNumber],
        ['Karigar', assignment.karigar.name],
        ['Garment', '${_garmentLabel(item.garmentType)} x ${item.quantity}'],
        ['Profile', item.measurementProfileName],
        ['Measurement basis', item.measurementBasis.replaceAll('_', ' ')],
        if (deadline != null)
          ['Internal deadline', DateFormat('d MMM yyyy').format(deadline)],
      ]),
      pw.SizedBox(height: 12),
      pw.Inseparable(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: _boxDecoration(),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Frozen measurements (${unit.label})',
                style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 14,
                runSpacing: 7,
                children: values.entries.map((entry) {
                  return pw.SizedBox(
                    width: 145,
                    child: pw.Text(
                      '${_measurementLabel(item.garmentType, entry.key)}: ${entry.value} ${unit.suffix}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      if (item.styleInstructions.isNotEmpty) ...[
        pw.SizedBox(height: 10),
        _noteBox('Style instructions', item.styleInstructions),
      ],
      if (assignment.assignment.workInstructions.isNotEmpty) ...[
        pw.SizedBox(height: 8),
        _noteBox('Work notes', assignment.assignment.workInstructions),
      ],
      if (item.measurementNotes.isNotEmpty) ...[
        pw.SizedBox(height: 8),
        _noteBox('Measurement notes', item.measurementNotes),
      ],
    ];
  }

  pw.Widget _pageHeader(
    ShopDetails shop,
    String orderNumber,
    OrderDocumentKind kind,
    int page,
    int pages,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 9),
      margin: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColor.fromInt(0xff176b50),
            width: 1.2,
          ),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  shop.name,
                  style: const pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xff176b50),
                  ),
                ),
                if (shop.address.isNotEmpty)
                  pw.Text(shop.address, style: const pw.TextStyle(fontSize: 8)),
                if (shop.phone.isNotEmpty)
                  pw.Text(shop.phone, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
          pw.Text(
            '$orderNumber\nPage $page of $pages',
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  pw.Widget _pageFooter(
    DateTime generatedAt,
    int page,
    int pages,
  ) => pw.Container(
    padding: const pw.EdgeInsets.only(top: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generated ${DateFormat('d MMM yyyy, h:mm a').format(generatedAt)}',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
        ),
        pw.Text(
          '$page / $pages',
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
        ),
      ],
    ),
  );

  pw.Widget _sectionTitle(String title) => pw.Text(
    title,
    style: const pw.TextStyle(
      fontSize: 13,
      fontWeight: pw.FontWeight.bold,
      letterSpacing: 0.7,
    ),
  );

  pw.Widget _details(List<List<String>> rows) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: rows
        .map(
          (row) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '${row[0]}: ',
                    style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.TextSpan(text: row[1]),
                ],
              ),
            ),
          ),
        )
        .toList(),
  );

  pw.Widget _noteBox(String title, String value) => pw.Inseparable(
    child: pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(9),
      decoration: _boxDecoration(color: const PdfColor.fromInt(0xfff7f5f0)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    ),
  );

  pw.Widget _amountRow(String label, int value, {bool bold = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label),
            pw.Text(
              formatPaisa(value),
              style: bold
                  ? const pw.TextStyle(fontWeight: pw.FontWeight.bold)
                  : null,
            ),
          ],
        ),
      );

  pw.BoxDecoration _boxDecoration({PdfColor color = PdfColors.white}) =>
      pw.BoxDecoration(
        color: color,
        border: pw.Border.all(
          color: const PdfColor.fromInt(0xffe2e0db),
          width: 0.7,
        ),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(7)),
      );

  String _title(OrderDocumentKind kind, String orderNumber) =>
      '${switch (kind) {
        OrderDocumentKind.customerReceipt => 'Order Receipt',
        OrderDocumentKind.karigarSlip => 'Karigar Work Slip',
        OrderDocumentKind.combined => 'Combined Order Document',
      }} - $orderNumber';

  String _garmentLabel(String storage) =>
      GarmentType.fromStorage(storage).label;

  String _measurementLabel(String garmentStorage, String key) {
    final template =
        garmentMeasurementTemplates[GarmentType.fromStorage(garmentStorage)];
    for (final field
        in template?.fields ?? const <MeasurementFieldDefinition>[]) {
      if (field.key == key) return field.label;
    }
    return key.replaceAll('_', ' ');
  }
}
