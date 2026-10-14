import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import '../core/localization/localization_extensions.dart';
import 'app_shell.dart';
import '../features/settings/setup_screen.dart';
import '../features/settings/shop_settings_providers.dart';
import '../core/localization/presentation_preferences.dart';
import '../l10n/app_localizations.dart';

/// Root application widget.
class TailorApp extends ConsumerWidget {
  const TailorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(shopSetupProvider);
    final preferences = ref.watch(currentPresentationPreferencesProvider);
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      locale: preferences.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(urdu: preferences.languageCode == 'ur'),
      home: setup.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => const _SettingsLoadError(),
        data: (value) => value.completed
            ? const AppShell()
            : SetupScreen(initialStep: value.step),
      ),
    );
  }
}

class _SettingsLoadError extends StatelessWidget {
  const _SettingsLoadError();

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(context.l10n.couldNotLoadSettings)));
}
