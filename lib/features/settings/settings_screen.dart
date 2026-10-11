import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/unsaved_changes_guard.dart';
import 'shop_settings.dart';
import 'shop_settings_providers.dart';

/// Settings screen — Stage 1 empty state.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(shopDetailsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load settings',
          subtitle: 'Your saved shop details have not been changed.',
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(shopDetailsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ),
        data: (value) => ListView(
          padding: AppSpacing.pagePadding,
          children: [
            Text('Shop details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            const Text('These details appear on receipts and work documents.'),
            const SizedBox(height: AppSpacing.lg),
            _ShopDetailsForm(initial: value),
          ],
        ),
      ),
    );
  }
}

class _ShopDetailsForm extends ConsumerStatefulWidget {
  const _ShopDetailsForm({required this.initial});
  final ShopDetails initial;

  @override
  ConsumerState<_ShopDetailsForm> createState() => _ShopDetailsFormState();
}

class _ShopDetailsFormState extends ConsumerState<_ShopDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  late final TextEditingController _footer;
  bool _saving = false;
  late ShopDetails _savedDetails;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.name);
    _address = TextEditingController(text: widget.initial.address);
    _phone = TextEditingController(text: widget.initial.phone);
    _footer = TextEditingController(text: widget.initial.receiptFooter);
    _savedDetails = widget.initial;
    for (final controller in [_name, _address, _phone, _footer]) {
      controller.addListener(_refreshDirtyState);
    }
  }

  void _refreshDirtyState() {
    if (mounted) setState(() {});
  }

  ShopDetails get _currentDetails => ShopDetails(
    name: _name.text,
    address: _address.text,
    phone: _phone.text,
    receiptFooter: _footer.text,
  );

  bool get _hasUnsavedChanges {
    final current = _currentDetails;
    return current.name != _savedDetails.name ||
        current.address != _savedDetails.address ||
        current.phone != _savedDetails.phone ||
        current.receiptFooter != _savedDetails.receiptFooter;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _footer.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final details = _currentDetails;
      await ref.read(shopSettingsRepositoryProvider).save(details);
      if (mounted) {
        setState(() => _savedDetails = details);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Shop details saved.')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save shop details. Try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => UnsavedChangesGuard(
    hasUnsavedChanges: _hasUnsavedChanges,
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Shop name *'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter the shop name'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _address,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _footer,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Receipt footer',
              hintText: 'Thank you for your business.',
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(_saving ? 'Saving…' : 'Save shop details'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ),
    ),
  );
}
