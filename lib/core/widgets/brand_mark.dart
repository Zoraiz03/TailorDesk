import 'package:flutter/material.dart';

import '../localization/localization_extensions.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 64});
  final double size;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size / 4),
    child: Image.asset(
      'assets/branding/tailordesk.png',
      width: size,
      height: size,
      semanticLabel: context.l10n.brandMarkLabel,
    ),
  );
}
