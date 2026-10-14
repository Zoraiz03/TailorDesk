import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/localization/presentation_preferences.dart';
import '../karigars/karigar_models.dart';
import '../orders/order_models.dart';
import '../settings/shop_settings_providers.dart';
import 'order_document_service.dart';

class DocumentPreviewScreen extends ConsumerStatefulWidget {
  const DocumentPreviewScreen({
    super.key,
    required this.kind,
    required this.order,
    this.assignment,
  });

  final OrderDocumentKind kind;
  final OrderRecord order;
  final AssignmentRecord? assignment;

  @override
  ConsumerState<DocumentPreviewScreen> createState() =>
      _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends ConsumerState<DocumentPreviewScreen> {
  late final Future<GeneratedOrderDocument> _document;

  @override
  void initState() {
    super.initState();
    _document = _build();
  }

  Future<GeneratedOrderDocument> _build() async {
    final shop = await ref.read(shopSettingsRepositoryProvider).get();
    return OrderDocumentService().generate(
      kind: widget.kind,
      shop: shop,
      order: widget.order,
      assignment: widget.assignment,
      documentLanguage: ref
          .read(currentPresentationPreferencesProvider)
          .documentLanguage,
    );
  }

  Future<void> _print(GeneratedOrderDocument document) async {
    try {
      final completed = await Printing.layoutPdf(
        name: document.fileName,
        format: PdfPageFormat.a4,
        dynamicLayout: false,
        onLayout: (_) async => document.bytes,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            completed
                ? context.l10n.printJobSent
                : context.l10n.printingCancelled,
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.printFailed)));
      }
    }
  }

  Future<void> _export(GeneratedOrderDocument document) async {
    try {
      final completed = _isDesktop
          ? await _saveToChosenLocation(document)
          : await Printing.sharePdf(
              bytes: document.bytes,
              filename: document.fileName,
              subject:
                  '${context.l10n.order} ${widget.order.order.orderNumber}',
            );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            completed
                ? context.l10n.pdfExportComplete
                : context.l10n.pdfExportCancelled,
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.pdfExportFailed)));
      }
    }
  }

  bool get _isDesktop =>
      !kIsWeb &&
      {
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      }.contains(defaultTargetPlatform);

  Future<bool> _saveToChosenLocation(GeneratedOrderDocument document) async {
    final location = await getSaveLocation(
      suggestedName: document.fileName,
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'PDF document',
          extensions: ['pdf'],
          mimeTypes: ['application/pdf'],
          uniformTypeIdentifiers: ['com.adobe.pdf'],
        ),
      ],
    );
    if (location == null) return false;
    await XFile.fromData(
      document.bytes,
      mimeType: 'application/pdf',
      name: document.fileName,
    ).saveTo(location.path);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeneratedOrderDocument>(
      future: _document,
      builder: (context, snapshot) {
        final document = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(_title(widget.kind)),
            actions: [
              if (!kIsWeb)
                IconButton(
                  tooltip: context.l10n.print,
                  onPressed: document == null ? null : () => _print(document),
                  icon: const Icon(Icons.print_outlined),
                ),
              IconButton(
                tooltip: context.l10n.exportPdf,
                onPressed: document == null ? null : () => _export(document),
                icon: const Icon(Icons.ios_share_outlined),
              ),
            ],
          ),
          body: switch (snapshot.connectionState) {
            ConnectionState.waiting || ConnectionState.active => const Center(
              child: CircularProgressIndicator(),
            ),
            _ when snapshot.hasError => Padding(
              padding: AppSpacing.pagePadding,
              child: Center(
                child: Text(
                  context.l10n.documentGenerationFailed,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _ when kIsWeb => Padding(
              padding: AppSpacing.pagePadding,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.picture_as_pdf_outlined, size: 52),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      document!.fileName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(context.l10n.webPdfHelp, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton.icon(
                      onPressed: () => _export(document),
                      icon: const Icon(Icons.download_outlined),
                      label: Text(context.l10n.exportPdf),
                    ),
                  ],
                ),
              ),
            ),
            _ => PdfPreview(
              build: (_) async => document.bytes,
              initialPageFormat: PdfPageFormat.a4,
              canChangePageFormat: false,
              canChangeOrientation: false,
              canDebug: false,
              allowPrinting: false,
              allowSharing: false,
              useActions: false,
              pdfFileName: document!.fileName,
              onError: (_, error) =>
                  Center(child: Text(context.l10n.documentPreviewFailed)),
            ),
          },
        );
      },
    );
  }

  String _title(OrderDocumentKind kind) => switch (kind) {
    OrderDocumentKind.customerReceipt => context.l10n.customerReceipt,
    OrderDocumentKind.karigarSlip => context.l10n.karigarSlip,
    OrderDocumentKind.combined => context.l10n.combinedDocument,
  };
}
