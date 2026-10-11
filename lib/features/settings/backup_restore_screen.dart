import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/database/database_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'backup/backup_service.dart';

/// Backup & Restore screen — Stage 1 empty state.
class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() =>
      _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  bool _busy = false;
  String? _status;

  Future<void> _backup() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _status = 'Creating a consistent database snapshot…';
    });
    try {
      final bytes = await BackupService().createBackup(
        ref.read(databaseProvider),
      );
      if (!mounted) return;
      final fileName =
          'tailordesk-backup-${DateTime.now().toIso8601String().substring(0, 10)}.tailorbackup';
      final exported = _isDesktop
          ? await _saveBackup(bytes, fileName)
          : await SharePlus.instance
                .share(
                  ShareParams(
                    files: [XFile.fromData(bytes, mimeType: 'application/zip')],
                    fileNameOverrides: [fileName],
                    subject: 'TailorDesk backup',
                    text:
                        'Keep this backup outside your device to protect against device loss.',
                    sharePositionOrigin: _shareOrigin(),
                  ),
                )
                .then((result) => result.status != ShareResultStatus.dismissed);
      if (!mounted) return;
      setState(() {
        _status = !exported
            ? 'Backup export was cancelled.'
            : 'Backup created and handed to the selected destination.';
      });
    } catch (error) {
      if (mounted) setState(() => _status = 'Backup failed: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool get _isDesktop =>
      !kIsWeb &&
      {
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      }.contains(defaultTargetPlatform);

  Future<bool> _saveBackup(Uint8List bytes, String fileName) async {
    final location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'TailorDesk backup',
          extensions: ['tailorbackup', 'zip'],
          mimeTypes: ['application/zip'],
          uniformTypeIdentifiers: ['public.zip-archive'],
        ),
      ],
    );
    if (location == null) return false;
    await XFile.fromData(
      bytes,
      mimeType: 'application/zip',
      name: fileName,
    ).saveTo(location.path);
    return true;
  }

  Future<void> _restore() async {
    if (_busy) return;
    const type = XTypeGroup(
      label: 'TailorDesk backup',
      extensions: ['tailorbackup', 'zip'],
      mimeTypes: ['application/zip'],
      uniformTypeIdentifiers: ['public.zip-archive'],
      webWildCards: ['.tailorbackup', '.zip'],
    );
    final selected = await openFile(acceptedTypeGroups: const [type]);
    if (selected == null || !mounted) {
      setState(() => _status = 'Restore selection was cancelled.');
      return;
    }
    Uint8List bytes;
    try {
      bytes = await selected.readAsBytes();
      setState(() {
        _busy = true;
        _status = 'Validating backup structure, checksum, and database…';
      });
      await BackupService().validate(bytes);
    } catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _status = 'Backup rejected: $error';
        });
      }
      return;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
        title: const Text('Replace all local data?'),
        content: const Text(
          'Restore replaces this device’s customers, measurements, orders, payments, karigars, assignments, and settings. It does not merge data. A safety copy of the current database will be created first.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Replace local data'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      setState(
        () => _status = 'Restore was cancelled. Local data was not changed.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _status = 'Creating safety copy and restoring…';
    });
    try {
      final safetyPath = await BackupService().restore(
        ref.read(databaseProvider),
        bytes,
      );
      ref.invalidate(databaseProvider);
      if (mounted) {
        setState(
          () => _status =
              'Restore completed. A safety copy was kept at $safetyPath',
        );
      }
    } catch (error) {
      ref.invalidate(databaseProvider);
      if (mounted) setState(() => _status = 'Restore failed: $error');
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
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore'), centerTitle: false),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          if (kIsWeb)
            const Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Text(
                  'Database backup and restore are unavailable in the web build. Use the Android, iOS, macOS, or Windows app.',
                ),
              ),
            ),
          _ActionCard(
            icon: Icons.cloud_upload_outlined,
            title: 'Export backup',
            description:
                'Creates a versioned local archive with a consistent SQLite snapshot and SHA-256 checksum. The archive is not encrypted.',
            buttonLabel: 'Create and export backup',
            onPressed: kIsWeb || _busy ? null : _backup,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ActionCard(
            icon: Icons.restore_outlined,
            title: 'Restore backup',
            description:
                'Validates the archive in a temporary location, creates a safety copy, then replaces local data. Restore does not merge records.',
            buttonLabel: 'Choose backup to restore',
            destructive: true,
            onPressed: kIsWeb || _busy ? null : _restore,
          ),
          if (_busy) ...[
            const SizedBox(height: AppSpacing.xl),
            const LinearProgressIndicator(),
          ],
          if (_status != null) ...[
            const SizedBox(height: AppSpacing.md),
            Semantics(liveRegion: true, child: Text(_status!)),
          ],
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Keep a backup outside this device. That copy can protect your records if the device is lost or damaged.',
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: destructive ? AppColors.error : AppColors.primary,
            size: 30,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(description),
          const SizedBox(height: AppSpacing.lg),
          destructive
              ? OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  onPressed: onPressed,
                  icon: const Icon(Icons.warning_amber_outlined),
                  label: Text(buttonLabel),
                )
              : FilledButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.save_alt_outlined),
                  label: Text(buttonLabel),
                ),
        ],
      ),
    ),
  );
}
