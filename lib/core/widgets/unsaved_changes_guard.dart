import 'package:flutter/material.dart';

import '../localization/localization_extensions.dart';

/// Prevents an accidental back navigation from discarding edited form data.
class UnsavedChangesGuard extends StatefulWidget {
  const UnsavedChangesGuard({
    super.key,
    required this.hasUnsavedChanges,
    required this.child,
  });

  final bool hasUnsavedChanges;
  final Widget child;

  @override
  State<UnsavedChangesGuard> createState() => _UnsavedChangesGuardState();
}

class _UnsavedChangesGuardState extends State<UnsavedChangesGuard> {
  bool _asking = false;

  Future<void> _handlePop(bool didPop) async {
    if (didPop || _asking || !widget.hasUnsavedChanges) return;
    _asking = true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.edit_note_outlined),
        title: Text(context.l10n.confirmDiscardTitle),
        content: Text(context.l10n.confirmDiscardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.discard),
          ),
        ],
      ),
    );
    _asking = false;
    if (discard == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !widget.hasUnsavedChanges,
    onPopInvokedWithResult: (didPop, _) => _handlePop(didPop),
    child: widget.child,
  );
}
