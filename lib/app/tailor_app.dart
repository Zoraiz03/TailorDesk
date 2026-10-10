import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'app_shell.dart';

/// Root application widget.
class TailorApp extends StatelessWidget {
  const TailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AppShell(),
    );
  }
}
