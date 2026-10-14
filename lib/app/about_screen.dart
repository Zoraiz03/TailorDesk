import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_spacing.dart';
import '../core/localization/localization_extensions.dart';
import '../core/widgets/brand_mark.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<String> _version() async {
    try {
      return await const MethodChannel(
            'tailordesk/delivery',
          ).invokeMethod<String>('appVersion') ??
          'Unavailable';
    } on MissingPluginException {
      return 'See the installed application details';
    } on PlatformException {
      return 'Unavailable';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.aboutTailorDesk)),
    body: ListView(
      padding: AppSpacing.pagePadding,
      children: [
        const Align(alignment: Alignment.centerLeft, child: BrandMark()),
        const SizedBox(height: AppSpacing.lg),
        Text('TailorDesk', style: Theme.of(context).textTheme.headlineSmall),
        Text(context.l10n.offlineTagline),
        const SizedBox(height: AppSpacing.lg),
        FutureBuilder<String>(
          future: _version(),
          builder: (context, snapshot) => Text(
            context.l10n.versionLabel(snapshot.data ?? context.l10n.loading),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Your shop details appear on customer receipts. Business records '
          'are stored on this device. Export backups outside the phone regularly. '
          'There is no automatic cloud synchronisation.',
        ),
        const SizedBox(height: AppSpacing.lg),
        TextButton(
          onPressed: () =>
              showLicensePage(context: context, applicationName: 'TailorDesk'),
          child: Text(context.l10n.openSourceNotices),
        ),
      ],
    ),
  );
}
