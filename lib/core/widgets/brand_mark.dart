import 'package:flutter/material.dart';

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
      semanticLabel: 'TailorDesk spool and thread',
    ),
  );
}
