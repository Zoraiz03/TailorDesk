import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/unsaved_changes_guard.dart';
import 'shop_settings.dart';
import 'shop_settings_providers.dart';
import 'garment_catalog_screen.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/localization/presentation_preferences.dart';

/// Settings screen — Stage 1 empty state.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(shopDetailsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings), centerTitle: false),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => EmptyState(
          icon: Icons.error_outline,
          title: context.l10n.couldNotLoadSettings,
          subtitle: context.l10n.settingsUnchanged,
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(shopDetailsProvider),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ),
        data: (value) => ListView(
          padding: AppSpacing.pagePadding,
          children: [
            Text(
              context.l10n.presentationPreferences,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            const LanguageSelector(),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.documentLanguageHelp),
            const SizedBox(height: AppSpacing.sm),
            _DocumentLanguageSelector(),
            if (context.isUrdu) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.provisionalUrduNotice,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
            Text(
              context.l10n.shopDetails,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(context.l10n.shopDetailsHelp),
            const SizedBox(height: AppSpacing.lg),
            _ShopDetailsForm(initial: value),
            const SizedBox(height: AppSpacing.xxl),
            Card(
              child: ListTile(
                leading: const Icon(Icons.checkroom_outlined),
                title: Text(context.l10n.garmentsTemplates),
                subtitle: Text(context.l10n.garmentsTemplatesSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GarmentCatalogScreen(),
                  ),
                ),
              ),
            ),
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
  late String _unit;
  bool _saving = false;
  late ShopDetails _savedDetails;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.name);
    _address = TextEditingController(text: widget.initial.address);
    _phone = TextEditingController(text: widget.initial.phone);
    _footer = TextEditingController(text: widget.initial.receiptFooter);
    _unit = widget.initial.defaultMeasurementUnit;
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
    defaultMeasurementUnit: _unit,
  );

  bool get _hasUnsavedChanges {
    final current = _currentDetails;
    return current.name != _savedDetails.name ||
        current.address != _savedDetails.address ||
        current.phone != _savedDetails.phone ||
        current.receiptFooter != _savedDetails.receiptFooter ||
        current.defaultMeasurementUnit != _savedDetails.defaultMeasurementUnit;
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
        ).showSnackBar(SnackBar(content: Text(context.l10n.shopDetailsSaved)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.shopDetailsSaveFailed)),
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
            decoration: InputDecoration(
              labelText: context.l10n.shopNameRequired,
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.enterShopName
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _unit,
            decoration: InputDecoration(
              labelText: context.l10n.defaultMeasurementUnit,
            ),
            items: [
              DropdownMenuItem(
                value: 'inches',
                child: Text(context.l10n.inches),
              ),
              DropdownMenuItem(
                value: 'centimetres',
                child: Text(context.l10n.centimetres),
              ),
            ],
            onChanged: (value) => setState(() => _unit = value ?? _unit),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _address,
            maxLines: 2,
            decoration: InputDecoration(labelText: context.l10n.address),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: context.l10n.phone),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _footer,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: context.l10n.receiptFooter,
              hintText: context.l10n.receiptFooterHint,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(
              _saving ? context.l10n.saving : context.l10n.saveShopDetails,
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ),
    ),
  );
}

class _DocumentLanguageSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref
        .watch(currentPresentationPreferencesProvider)
        .documentLanguage;
    return SegmentedButton<DocumentLanguage>(
      segments: [
        ButtonSegment(
          value: DocumentLanguage.english,
          label: Text(context.l10n.documentEnglish),
        ),
        ButtonSegment(
          value: DocumentLanguage.urdu,
          label: Text(context.l10n.documentUrdu),
        ),
        ButtonSegment(
          value: DocumentLanguage.bilingual,
          label: Text(context.l10n.documentBilingual),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) => ref
          .read(presentationPreferencesRepositoryProvider)
          .setDocumentLanguage(selection.first),
    );
  }
}
