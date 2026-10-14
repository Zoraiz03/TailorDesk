import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/localization/localization_extensions.dart';
import 'license_models.dart';
import 'license_providers.dart';
import 'license_service.dart';

const _activationRequestFileName = 'tailordesk-activation-request.json';

class ActivationScreen extends ConsumerStatefulWidget {
  const ActivationScreen({super.key, this.popOnSuccess = false});

  final bool popOnSuccess;

  @override
  ConsumerState<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends ConsumerState<ActivationScreen> {
  bool _busy = false;
  String? _message;

  Uint8List _requestBytes(String installationId) =>
      LicenseService.activationRequestBytesForInstallation(installationId);

  Future<void> _copyRequest(String installationId) async {
    // On the web, clipboard access must start in the button's user-activation
    // window. Do not await secure storage before invoking the clipboard API.
    final json = String.fromCharCodes(_requestBytes(installationId));
    try {
      await Clipboard.setData(ClipboardData(text: json));
      if (mounted) {
        setState(() => _message = context.l10n.activationCopied);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message = context.l10n.copyBlocked);
      }
    }
  }

  Future<void> _shareRequest(String installationId) async {
    final bytes = _requestBytes(installationId);
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'application/json',
              name: _activationRequestFileName,
            ),
          ],
          fileNameOverrides: const [_activationRequestFileName],
          subject: context.l10n.activationShareSubject,
          text: context.l10n.activationShareBody,
          sharePositionOrigin: _shareOrigin(),
          downloadFallbackEnabled: false,
        ),
      );
      if (mounted && result.status != ShareResultStatus.dismissed) {
        setState(() => _message = context.l10n.activationShared);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message = context.l10n.shareUnsupported);
      }
    }
  }

  Future<void> _downloadRequest(String installationId) async {
    final bytes = _requestBytes(installationId);
    try {
      final file = XFile.fromData(
        bytes,
        mimeType: 'application/json',
        name: _activationRequestFileName,
      );
      if (kIsWeb) {
        // cross_file implements saveTo as an explicit browser download. This
        // does not depend on Clipboard or Web Share permissions.
        await file.saveTo('');
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        final saved = await const MethodChannel('tailordesk/delivery')
            .invokeMethod<bool>('saveActivationRequest', {
              'bytes': bytes,
              'name': _activationRequestFileName,
            });
        if (saved != true) {
          if (mounted) {
            setState(() => _message = context.l10n.downloadCancelled);
          }
          return;
        }
      } else {
        final location = await getSaveLocation(
          suggestedName: _activationRequestFileName,
          acceptedTypeGroups: const [
            XTypeGroup(
              label: 'TailorDesk activation request',
              extensions: ['json'],
              mimeTypes: ['application/json'],
              uniformTypeIdentifiers: ['public.json'],
            ),
          ],
        );
        if (location == null) {
          if (mounted) {
            setState(() => _message = context.l10n.downloadCancelled);
          }
          return;
        }
        await file.saveTo(location.path);
      }
      if (mounted) {
        setState(() => _message = context.l10n.downloadComplete);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message = context.l10n.downloadFailed);
      }
    }
  }

  Future<void> _import() async {
    if (_busy) return;
    const type = XTypeGroup(
      label: 'TailorDesk license',
      extensions: ['tailorlicense', 'json'],
      // Files copied through USB/download tools are commonly classified as
      // octet-stream on Android even though the signed envelope is JSON.
      mimeTypes: ['application/json', 'application/octet-stream'],
      uniformTypeIdentifiers: ['public.json'],
    );
    final file = await openFile(acceptedTypeGroups: const [type]);
    if (file == null) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await ref
          .read(licenseStateProvider.notifier)
          .importLicense(await file.readAsBytes());
      if (!mounted) return;
      if (result.isActive) {
        setState(() => _message = context.l10n.licenseActivated);
        if (widget.popOnSuccess) Navigator.pop(context, true);
      } else {
        setState(
          () =>
              _message = localizedLicenseMessage(context.l10n, result.message),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message = context.l10n.licenseImportFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Rect _shareOrigin() {
    final box = context.findRenderObject() as RenderBox?;
    return box == null
        ? const Rect.fromLTWH(0, 0, 1, 1)
        : box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(licenseStateProvider);
    return Scaffold(
      appBar: widget.popOnSuccess
          ? AppBar(title: Text(context.l10n.activationRequired))
          : null,
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _errorState(),
        data: (value) => SafeArea(
          child: ListView(
            padding: AppSpacing.pagePadding,
            children: [
              if (!widget.popOnSuccess) ...[
                const SizedBox(height: AppSpacing.xxl),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: BrandMark(),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: LanguageSelector(compact: true),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                value.isActivated
                    ? context.l10n.activatedTitle
                    : context.l10n.activateTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                value.isActivated
                    ? context.l10n.renewLicenseBody
                    : context.l10n.activationRequiredBody,
              ),
              const SizedBox(height: AppSpacing.xl),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.installationCode,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: SelectableText(
                          value.installationId.isEmpty
                              ? context.l10n.notAvailable
                              : value.installationId,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontFamily: 'monospace'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          OutlinedButton.icon(
                            onPressed: value.installationId.isEmpty
                                ? null
                                : () => _copyRequest(value.installationId),
                            icon: const Icon(Icons.copy_outlined),
                            label: Text(context.l10n.copyRequest),
                          ),
                          OutlinedButton.icon(
                            onPressed: value.installationId.isEmpty
                                ? null
                                : () => _shareRequest(value.installationId),
                            icon: const Icon(Icons.share_outlined),
                            label: Text(context.l10n.shareRequest),
                          ),
                          OutlinedButton.icon(
                            onPressed: value.installationId.isEmpty
                                ? null
                                : () => _downloadRequest(value.installationId),
                            icon: const Icon(Icons.download_outlined),
                            label: Text(context.l10n.downloadRequest),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _busy || value.installationId.isEmpty
                    ? null
                    : _import,
                icon: const Icon(Icons.file_open_outlined),
                label: Text(
                  _busy ? context.l10n.validating : context.l10n.importLicense,
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              if (_message != null || !value.isActivated) ...[
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _message ??
                        localizedLicenseMessage(
                          context.l10n,
                          value.validation.message,
                        ),
                    style: TextStyle(
                      color: value.isActivated
                          ? AppColors.primary
                          : AppColors.error,
                    ),
                  ),
                ),
              ],
              if (!value.isActivated && value.hasBusinessData) ...[
                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                Text(context.l10n.readOnlyMessage),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(readOnlySessionProvider.notifier).enable(),
                  icon: const Icon(Icons.visibility_outlined),
                  label: Text(context.l10n.readOnly),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                context.l10n.releaseMaintenanceNote(currentReleaseSequence),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorState() => Center(
    child: Padding(
      padding: AppSpacing.pagePadding,
      child: Text(context.l10n.couldNotLoadSettings),
    ),
  );
}
