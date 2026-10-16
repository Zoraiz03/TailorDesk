import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/database/app_database.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/localization/presentation_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_en.dart';
import '../../l10n/app_localizations_ur.dart';
import '../karigars/karigar_models.dart';
import '../measurements/measurement_models.dart';
import '../measurements/measurement_templates.dart';
import '../settings/garment_catalog.dart';
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
  final AppLocalizations _english = AppLocalizationsEn();
  final AppLocalizations _urdu = AppLocalizationsUr();
  DocumentLanguage _language = DocumentLanguage.english;

  String _text(String Function(AppLocalizations value) read) =>
      switch (_language) {
        DocumentLanguage.english => read(_english),
        DocumentLanguage.urdu => read(_urdu),
        DocumentLanguage.bilingual => '${read(_english)} / ${read(_urdu)}',
      };

  Future<GeneratedOrderDocument> generate({
    required OrderDocumentKind kind,
    required ShopDetails shop,
    required OrderRecord order,
    AssignmentRecord? assignment,
    DateTime? generatedAt,
    DocumentLanguage documentLanguage = DocumentLanguage.english,
  }) async {
    if (kind != OrderDocumentKind.customerReceipt && assignment == null) {
      throw ArgumentError('A karigar assignment is required for this document');
    }
    final regularData = await rootBundle.load(
      'assets/fonts/Roboto-Regular.ttf',
    );
    final mediumData = await rootBundle.load('assets/fonts/Roboto-Medium.ttf');
    final urduRegularData = await rootBundle.load(
      'assets/fonts/NotoNaskhArabic-Regular.ttf',
    );
    final urduMediumData = await rootBundle.load(
      'assets/fonts/NotoNaskhArabic-Medium.ttf',
    );
    return generateWithFonts(
      kind: kind,
      shop: shop,
      order: order,
      assignment: assignment,
      generatedAt: generatedAt,
      regularFont: regularData,
      mediumFont: mediumData,
      urduRegularFont: urduRegularData,
      urduMediumFont: urduMediumData,
      documentLanguage: documentLanguage,
    );
  }

  Future<GeneratedOrderDocument> generateWithFonts({
    required OrderDocumentKind kind,
    required ShopDetails shop,
    required OrderRecord order,
    required ByteData regularFont,
    required ByteData mediumFont,
    ByteData? urduRegularFont,
    ByteData? urduMediumFont,
    DocumentLanguage documentLanguage = DocumentLanguage.english,
    AssignmentRecord? assignment,
    DateTime? generatedAt,
  }) async {
    final created = generatedAt ?? DateTime.now();
    _language = documentLanguage;
    if (documentLanguage != DocumentLanguage.english &&
        (urduRegularFont == null || urduMediumFont == null)) {
      throw ArgumentError('Urdu document fonts are required');
    }
    final latinRegular = pw.Font.ttf(regularFont);
    final latinMedium = pw.Font.ttf(mediumFont);
    final regular = documentLanguage == DocumentLanguage.english
        ? latinRegular
        : pw.Font.ttf(urduRegularFont!);
    final medium = documentLanguage == DocumentLanguage.english
        ? latinMedium
        : pw.Font.ttf(urduMediumFont!);
    final theme = pw.ThemeData.withFont(
      base: regular,
      bold: medium,
      fontFallback: documentLanguage == DocumentLanguage.english
          ? [if (urduRegularFont != null) pw.Font.ttf(urduRegularFont)]
          : [latinRegular],
    );
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
          textDirection: documentLanguage == DocumentLanguage.english
              ? pw.TextDirection.ltr
              : pw.TextDirection.rtl,
          build: (_) => pw.Column(
            children: [
              _pageHeader(shop, order.order.orderNumber, kind, 1, 1),
              ..._compactCombinedWidgets(shop, order, assignment!),
              pw.Spacer(),
              _pageFooter(created, 1, 1, orderNumber: order.order.orderNumber),
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
          textDirection: documentLanguage == DocumentLanguage.english
              ? pw.TextDirection.ltr
              : pw.TextDirection.rtl,
          footer: (context) => _pageFooter(
            created,
            context.pageNumber,
            context.pagesCount,
            orderNumber: order.order.orderNumber,
          ),
          build: (_) {
            final content = <pw.Widget>[
              _pageHeader(
                shop,
                order.order.orderNumber,
                kind,
                1,
                1,
                showPageCount: false,
              ),
            ];
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
        documentLanguage: documentLanguage,
      ),
    );
  }

  String buildAuditText({
    required OrderDocumentKind kind,
    required ShopDetails shop,
    required OrderRecord order,
    AssignmentRecord? assignment,
    DateTime? generatedAt,
    DocumentLanguage documentLanguage = DocumentLanguage.english,
  }) {
    _language = documentLanguage;
    final lines = <String>[shop.name, order.order.orderNumber];
    if (kind == OrderDocumentKind.customerReceipt ||
        kind == OrderDocumentKind.combined) {
      lines.addAll([
        _text((l) => l.orderReceiptHeading),
        order.customer.name,
        ...order.items.map(
          (item) =>
              '${_garmentLabel(item)} × ${item.quantity}${item.status == 'cancelled' ? ' ${_text((l) => l.cancelledExcluded)}' : ''}',
        ),
        '${_text((l) => l.orderTotal)} ${formatPaisa(order.totalPaisa)}',
        '${_text((l) => l.netPaid)} ${formatPaisa(order.netPaidPaisa)}',
        '${_text((l) => l.balance)} ${formatPaisa(order.balancePaisa)}',
        '${_text((l) => l.payment)} ${_paymentStatus(order)}',
      ]);
    }
    if (kind == OrderDocumentKind.karigarSlip ||
        kind == OrderDocumentKind.combined) {
      if (assignment == null) throw ArgumentError('Assignment required');
      final item = assignment.orderItem;
      final unit = MeasurementUnit.fromStorage(item.measurementUnit).suffix;
      lines.addAll([
        _text((l) => l.workSlipHeading),
        assignment.karigar.name,
        '${_garmentLabel(item)} × ${item.quantity}',
        ...decodeMeasurementValues(item.measurementValuesJson).entries.map(
          (entry) =>
              '${_measurementLabel(item, entry.key)} ${entry.value} $unit',
        ),
        item.styleInstructions,
        assignment.assignment.workInstructions,
      ]);
    }
    lines.add(
      '${_text((l) => l.generated)} ${(generatedAt ?? DateTime.now()).toIso8601String()}',
    );
    return lines.where((line) => line.trim().isNotEmpty).join('\n');
  }

  List<pw.Widget> _receiptWidgets(ShopDetails shop, OrderRecord order) {
    final date = DateFormat('d MMM yyyy');
    return [
      _sectionTitle(_text((l) => l.orderReceiptHeading)),
      pw.SizedBox(height: 8),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: _details([
              [_text((l) => l.customer), order.customer.name],
              [_text((l) => l.phone), order.customer.phone],
              if (order.customer.address.isNotEmpty)
                [_text((l) => l.address), order.customer.address],
            ]),
          ),
          pw.SizedBox(width: 18),
          pw.Expanded(
            child: _details([
              [_text((l) => l.order), order.order.orderNumber],
              [_text((l) => l.booked), date.format(order.order.bookingDate)],
              [_text((l) => l.promised), date.format(order.order.deliveryDate)],
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
              _amountRow(_text((l) => l.orderTotal), order.totalPaisa),
              _amountRow(_text((l) => l.netPaid), order.netPaidPaisa),
              pw.Divider(),
              _amountRow(
                _text((l) => l.balance),
                order.balancePaisa,
                bold: true,
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: _adaptiveText(
                  '${_text((l) => l.paymentStatusDocument)}: ${_paymentStatus(order)}',
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
        _adaptiveText(
          _text((l) => l.manualTransferNotice),
          style: const pw.TextStyle(fontSize: 8),
        ),
      ],
      if (order.order.notes.isNotEmpty) ...[
        pw.SizedBox(height: 12),
        _noteBox(_text((l) => l.orderNotes), order.order.notes),
      ],
      if (shop.receiptFooter.isNotEmpty) ...[
        pw.SizedBox(height: 16),
        pw.Center(
          child: _adaptiveText(
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
      _sectionTitle(_text((l) => l.orderReceiptHeading)),
      pw.SizedBox(height: 5),
      _details([
        [
          _text((l) => l.customer),
          '${order.customer.name} - ${order.customer.phone}',
        ],
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
            _adaptiveText(
              '${_garmentLabel(item)} × ${item.quantity}${cancelled ? ' - ${_text((l) => l.cancelled)}' : ''}',
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              formatPaisa(itemTotal),
              textDirection: pw.TextDirection.ltr,
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          _adaptiveText(
            '${_text((l) => l.total)} ${formatPaisa(order.totalPaisa)}  |  ',
          ),
          _adaptiveText(
            '${_text((l) => l.paid)} ${formatPaisa(order.netPaidPaisa)}  |  ',
          ),
          _adaptiveText(
            '${_text((l) => l.balance)} ${formatPaisa(order.balancePaisa)}',
            style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: _adaptiveText(
          '${_text((l) => l.paymentStatusDocument)}: ${_paymentStatus(order)}',
          style: const pw.TextStyle(fontSize: 8),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Divider(borderStyle: pw.BorderStyle.dashed),
      pw.SizedBox(height: 7),
      _sectionTitle(_text((l) => l.workSlipHeading)),
      pw.SizedBox(height: 5),
      _details([
        [_text((l) => l.workerName), assignment.karigar.name],
        [_text((l) => l.garment), '${_garmentLabel(item)} × ${item.quantity}'],
        if (deadline != null)
          [
            _text((l) => l.internalDeadline),
            DateFormat('d MMM yyyy').format(deadline),
          ],
      ]),
      pw.SizedBox(height: 5),
      pw.Container(
        padding: const pw.EdgeInsets.all(7),
        decoration: _boxDecoration(),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _adaptiveText(
              '${_text((l) => l.frozenMeasurements)} / ${_unitLabel(unit)}',
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
                      child: _adaptiveText(
                        '${_measurementLabel(item, entry.key)}: ${entry.value} ${unit.suffix}',
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
        _compactNote(_text((l) => l.styleInstructions), item.styleInstructions),
      ],
      if (assignment.assignment.workInstructions.isNotEmpty) ...[
        pw.SizedBox(height: 5),
        _compactNote(
          _text((l) => l.workNotes),
          assignment.assignment.workInstructions,
        ),
      ],
      if (shop.receiptFooter.isNotEmpty) ...[
        pw.SizedBox(height: 7),
        pw.Center(
          child: _adaptiveText(
            shop.receiptFooter,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
      ],
    ];
  }

  pw.Widget _compactNote(String title, String value) {
    final text = '$title: $value';
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(6),
      decoration: _boxDecoration(color: const PdfColor.fromInt(0xfff7f5f0)),
      child: _adaptiveText(text, style: const pw.TextStyle(fontSize: 8)),
    );
  }

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
                  _adaptiveText(
                    '${_garmentLabel(item)} × ${item.quantity}',
                    style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  if (item.additionalChargeDescription.isNotEmpty)
                    _adaptiveText(
                      item.additionalChargeDescription,
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  if (cancelled)
                    _adaptiveText(
                      _text((l) => l.cancelledExcluded),
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
              textDirection: pw.TextDirection.ltr,
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
      _sectionTitle(_text((l) => l.workSlipHeading)),
      pw.SizedBox(height: 8),
      _details([
        [_text((l) => l.order), order.order.orderNumber],
        [_text((l) => l.workerName), assignment.karigar.name],
        [_text((l) => l.garment), '${_garmentLabel(item)} × ${item.quantity}'],
        [_text((l) => l.profile), item.measurementProfileName],
        [_text((l) => l.measurementBasis), _basisLabel(item.measurementBasis)],
        if (deadline != null)
          [
            _text((l) => l.internalDeadline),
            DateFormat('d MMM yyyy').format(deadline),
          ],
      ]),
      pw.SizedBox(height: 12),
      pw.Inseparable(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: _boxDecoration(),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _adaptiveText(
                '${_text((l) => l.frozenMeasurements)} / ${_unitLabel(unit)}',
                style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 14,
                runSpacing: 7,
                children: values.entries.map((entry) {
                  return pw.SizedBox(
                    width: 145,
                    child: _adaptiveText(
                      '${_measurementLabel(item, entry.key)}: ${entry.value} ${unit.suffix}',
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
        _noteBox(_text((l) => l.styleInstructions), item.styleInstructions),
      ],
      if (assignment.assignment.workInstructions.isNotEmpty) ...[
        pw.SizedBox(height: 8),
        _noteBox(
          _text((l) => l.workNotes),
          assignment.assignment.workInstructions,
        ),
      ],
      if (item.measurementNotes.isNotEmpty) ...[
        pw.SizedBox(height: 8),
        _noteBox(_text((l) => l.measurementNotes), item.measurementNotes),
      ],
    ];
  }

  pw.Widget _pageHeader(
    ShopDetails shop,
    String orderNumber,
    OrderDocumentKind kind,
    int page,
    int pages, {
    bool showPageCount = true,
  }) {
    return pw.Container(
      height: 92,
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
                _adaptiveText(
                  shop.name,
                  style: const pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xff176b50),
                  ),
                ),
                if (shop.address.isNotEmpty)
                  _adaptiveText(
                    shop.address,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                if (shop.phone.isNotEmpty)
                  pw.Text(
                    shop.phone,
                    textDirection: pw.TextDirection.ltr,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                orderNumber,
                textDirection: pw.TextDirection.ltr,
                style: const pw.TextStyle(fontSize: 8),
              ),
              if (showPageCount)
                _adaptiveText(
                  _text((l) => l.pageOf(page, pages)),
                  textAlign: pw.TextAlign.right,
                  style: const pw.TextStyle(fontSize: 8),
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _pageFooter(
    DateTime generatedAt,
    int page,
    int pages, {
    required String orderNumber,
  }) => pw.Container(
    height: 18,
    padding: const pw.EdgeInsets.only(top: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            _adaptiveText(
              _text((l) => l.generated),
              style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
            ),
            pw.SizedBox(width: 3),
            pw.Text(
              DateFormat('d MMM yyyy, h:mm a').format(generatedAt),
              textDirection: pw.TextDirection.ltr,
              style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Text(
          orderNumber,
          textDirection: pw.TextDirection.ltr,
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
        ),
        pw.Text(
          '$page / $pages',
          textDirection: pw.TextDirection.ltr,
          style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
        ),
      ],
    ),
  );

  pw.Widget _sectionTitle(String title) => _adaptiveText(
    title,
    style: const pw.TextStyle(
      fontSize: 13,
      fontWeight: pw.FontWeight.bold,
      letterSpacing: 0.7,
    ),
  );

  pw.Widget _details(List<List<String>> rows) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: rows.map((row) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _adaptiveText(
              '${row[0]}:',
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(width: 3),
            pw.Flexible(child: _adaptiveText(row[1])),
          ],
        ),
      );
    }).toList(),
  );

  pw.Widget _noteBox(String title, String value) => pw.Inseparable(
    child: pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(9),
      decoration: _boxDecoration(color: const PdfColor.fromInt(0xfff7f5f0)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _adaptiveText(
            title,
            style: const pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
          ),
          pw.SizedBox(height: 3),
          _adaptiveText(value, style: const pw.TextStyle(fontSize: 9)),
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
            _adaptiveText(label),
            pw.Text(
              formatPaisa(value),
              textDirection: pw.TextDirection.ltr,
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
        OrderDocumentKind.customerReceipt => _text((l) => l.customerReceipt),
        OrderDocumentKind.karigarSlip => _text((l) => l.karigarSlip),
        OrderDocumentKind.combined => _text((l) => l.combinedDocument),
      }} - $orderNumber';

  String _garmentLabel(OrderItem item) {
    final english = localizedGarmentLabel(
      _english,
      item.garmentType,
      english: item.garmentLabelEnglish,
      urdu: item.garmentLabelUrdu,
    );
    final urdu = localizedGarmentLabel(
      _urdu,
      item.garmentType,
      english: item.garmentLabelEnglish,
      urdu: item.garmentLabelUrdu,
    );
    return _languageValue(english, urdu);
  }

  String _measurementLabel(OrderItem item, String key) {
    for (final field in decodeFieldDefinitions(
      item.measurementFieldDefinitionsJson,
      item.garmentType,
    )) {
      if (field.id == key) {
        final english = localizedMeasurementLabel(
          _english,
          key,
          english: field.label,
          urdu: field.labelUrdu,
        );
        final urdu = localizedMeasurementLabel(
          _urdu,
          key,
          english: field.label,
          urdu: field.labelUrdu,
        );
        return _languageValue(english, urdu);
      }
    }
    return key.replaceAll('_', ' ');
  }

  String _languageValue(String english, String urdu) => switch (_language) {
    DocumentLanguage.english => english,
    DocumentLanguage.urdu => urdu,
    DocumentLanguage.bilingual =>
      english == urdu ? english : '$english / $urdu',
  };

  String _paymentStatus(OrderRecord order) {
    if (order.balancePaisa <= 0) return _text((l) => l.paid);
    if (order.netPaidPaisa <= 0) return _text((l) => l.unpaid);
    return _text((l) => l.partiallyPaid);
  }

  String _unitLabel(MeasurementUnit unit) => unit == MeasurementUnit.centimetres
      ? _text((l) => l.centimetres)
      : _text((l) => l.inches);

  String _basisLabel(String basis) => basis == 'finished_garment'
      ? _text((l) => l.finishedGarmentMeasurements)
      : _text((l) => l.bodyMeasurements);

  pw.TextDirection _directionFor(String value) =>
      RegExp(r'[\u0600-\u06ff]').hasMatch(value)
      ? pw.TextDirection.rtl
      : pw.TextDirection.ltr;

  pw.Widget _adaptiveText(
    String value, {
    pw.TextStyle? style,
    pw.TextAlign? textAlign,
  }) {
    final hasArabic = RegExp(r'[\u0600-\u06ff]').hasMatch(value);
    final hasLatinLetters = RegExp(r'[A-Za-z]').hasMatch(value);
    if (!hasArabic || !hasLatinLetters) {
      return pw.Text(
        value,
        textDirection: _directionFor(value),
        textAlign: textAlign,
        style: style,
      );
    }

    final slashPieces = value
        .split(RegExp(r'\s*/\s*'))
        .map((piece) => piece.trim())
        .where((piece) => piece.isNotEmpty)
        .toList();
    final pieces = <String>[];
    for (final piece in slashPieces) {
      final pieceHasArabic = RegExp(r'[\u0600-\u06ff]').hasMatch(piece);
      final pieceHasLatin = RegExp(r'[A-Za-z]').hasMatch(piece);
      if (!pieceHasArabic || !pieceHasLatin) {
        pieces.add(piece);
        continue;
      }
      final words = piece.split(RegExp(r'\s+'));
      final arabicWords = words
          .where((word) => RegExp(r'[\u0600-\u06ff]').hasMatch(word))
          .toList();
      final latinWords = words
          .where((word) => !RegExp(r'[\u0600-\u06ff]').hasMatch(word))
          .toList();
      if (arabicWords.isNotEmpty) pieces.add(arabicWords.join(' '));
      if (latinWords.isNotEmpty) pieces.add(latinWords.join(' '));
    }
    final arabicPieces = pieces
        .where((piece) => RegExp(r'[\u0600-\u06ff]').hasMatch(piece))
        .toList();
    final latinPieces = pieces
        .where((piece) => !RegExp(r'[\u0600-\u06ff]').hasMatch(piece))
        .toList();

    if (arabicPieces.isEmpty || latinPieces.isEmpty) {
      return pw.Text(
        value,
        textDirection: _directionFor(value),
        textAlign: textAlign,
        style: style,
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        for (final piece in arabicPieces)
          pw.Text(
            piece,
            textDirection: pw.TextDirection.rtl,
            textAlign: textAlign,
            style: style,
          ),
        for (final piece in latinPieces)
          pw.Text(
            piece,
            textDirection: pw.TextDirection.ltr,
            textAlign: textAlign,
            style: style,
          ),
      ],
    );
  }
}
