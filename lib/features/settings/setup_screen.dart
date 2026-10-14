import 'package:flutter/material.dart';

import '../../core/widgets/brand_mark.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/localization/localization_extensions.dart';
import '../orders/order_formatters.dart';
import 'garment_catalog.dart';
import 'garment_catalog_providers.dart';
import 'shop_settings.dart';
import 'shop_settings_providers.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key, this.initialStep = 0});

  final int initialStep;

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _prices = {};
  late int _step;
  String _unit = 'inches';
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep.clamp(0, 3);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    for (final controller in _prices.values) {
      controller.dispose();
    }
    super.dispose();
  }

  ShopDetails _details(ShopDetails prior) => ShopDetails(
    name: _name.text,
    phone: _phone.text,
    address: _address.text,
    receiptFooter: prior.receiptFooter,
    defaultMeasurementUnit: _unit,
  );

  Future<void> _continue(
    ShopDetails prior,
    List<GarmentCatalogRecord> catalog,
  ) async {
    if (_saving) return;
    if (_step == 0 && !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (_step == 3) {
        await _savePrices(catalog);
        await ref
            .read(shopSettingsRepositoryProvider)
            .completeSetup(_details(prior));
      } else {
        await ref
            .read(shopSettingsRepositoryProvider)
            .saveSetupProgress(_details(prior), _step + 1);
        if (mounted) setState(() => _step++);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _savePrices(List<GarmentCatalogRecord> catalog) async {
    final repository = ref.read(garmentCatalogRepositoryProvider);
    for (final garment in catalog) {
      final text = _prices[garment.entry.garmentId]?.text.trim() ?? '';
      if (text.isEmpty) continue;
      final price = parseRupeesToPaisa(text);
      if (price != null && price >= 0) {
        await repository.updateEntry(
          garmentId: garment.entry.garmentId,
          defaultPricePaisa: price,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(shopDetailsProvider);
    final catalog = ref.watch(garmentCatalogProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: BrandMark(size: 40),
        ),
        title: Text(context.l10n.setupTitle),
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 12),
            child: LanguageSelector(compact: true),
          ),
        ],
      ),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.couldNotLoadSetup)),
        data: (shop) {
          if (!_loaded) {
            _loaded = true;
            _name.text = shop.name == ShopDetails.defaults.name
                ? ''
                : shop.name;
            _phone.text = shop.phone;
            _address.text = shop.address;
            _unit = shop.defaultMeasurementUnit;
          }
          return catalog.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                Center(child: Text(context.l10n.couldNotLoadSetup)),
            data: (garments) => SafeArea(
              child: Column(
                children: [
                  LinearProgressIndicator(value: (_step + 1) / 4),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: AppSpacing.pagePadding,
                        children: [
                          Text(
                            [
                              context.l10n.yourShop,
                              context.l10n.measurements,
                              context.l10n.garments,
                              context.l10n.defaultPrices,
                            ][_step],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(context.l10n.stepOf(_step + 1, 4)),
                          const SizedBox(height: AppSpacing.xl),
                          if (_step == 0) ...[
                            TextFormField(
                              controller: _name,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: context.l10n.shopNameRequired,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? context.l10n.enterShopName
                                  : null,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: context.l10n.phoneOptional,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _address,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: context.l10n.addressOptional,
                              ),
                            ),
                          ],
                          if (_step == 1) ...[
                            Text(context.l10n.measurementUnitPrompt),
                            const SizedBox(height: AppSpacing.md),
                            SegmentedButton<String>(
                              segments: [
                                ButtonSegment(
                                  value: 'inches',
                                  label: Text(context.l10n.inches),
                                ),
                                ButtonSegment(
                                  value: 'centimetres',
                                  label: Text(context.l10n.centimetres),
                                ),
                              ],
                              selected: {_unit},
                              onSelectionChanged: (value) =>
                                  setState(() => _unit = value.first),
                            ),
                          ],
                          if (_step == 2) ...[
                            Text(context.l10n.enableGarmentsPrompt),
                            const SizedBox(height: AppSpacing.md),
                            for (final garment in garments)
                              SwitchListTile(
                                title: Text(
                                  localizedGarmentLabel(
                                    context.l10n,
                                    garment.entry.garmentId,
                                    english: garment.entry.displayName,
                                    urdu: garment.entry.displayNameUrdu,
                                  ),
                                ),
                                value: garment.entry.enabled,
                                onChanged: (value) async {
                                  await ref
                                      .read(garmentCatalogRepositoryProvider)
                                      .updateEntry(
                                        garmentId: garment.entry.garmentId,
                                        enabled: value,
                                      );
                                  ref.invalidate(garmentCatalogProvider);
                                  ref.invalidate(enabledGarmentCatalogProvider);
                                },
                              ),
                          ],
                          if (_step == 3) ...[
                            const Text(
                              'Optional. These prices only prefill new order lines and can be changed before booking.',
                            ),
                            const SizedBox(height: AppSpacing.md),
                            for (final garment in garments.where(
                              (item) => item.entry.enabled,
                            )) ...[
                              TextFormField(
                                controller: _prices.putIfAbsent(
                                  garment.entry.garmentId,
                                  () => TextEditingController(
                                    text:
                                        garment
                                                .entry
                                                .defaultStitchingPricePaisa ==
                                            0
                                        ? ''
                                        : '${garment.entry.defaultStitchingPricePaisa ~/ 100}',
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: localizedGarmentLabel(
                                    context.l10n,
                                    garment.entry.garmentId,
                                    english: garment.entry.displayName,
                                    urdu: garment.entry.displayNameUrdu,
                                  ),
                                  prefixText: 'PKR ',
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: AppSpacing.pagePadding,
                    child: Row(
                      children: [
                        if (_step > 0)
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () => setState(() => _step--),
                            child: Text(context.l10n.back),
                          ),
                        const Spacer(),
                        FilledButton(
                          onPressed: _saving
                              ? null
                              : () => _continue(shop, garments),
                          child: Text(
                            _step == 3
                                ? context.l10n.finishSetup
                                : context.l10n.continueLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
