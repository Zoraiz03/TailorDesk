import 'package:flutter/material.dart';

/// Tailoring app colour palette.
///
/// Warm, premium tones with deep emerald as the primary action colour.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF176B50);
  static const Color primaryLight = Color(0xFFD6EDE5);
  static const Color gold = Color(0xFFB88B45);
  static const Color goldLight = Color(0xFFF5ECD7);

  // ── Neutral ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF7F5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF202824);
  static const Color textSecondary = Color(0xFF5F6B64);
  static const Color border = Color(0xFFE2E0DB);
  static const Color divider = Color(0xFFEDEBE6);

  // ── Status ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF0277BD);

  // ── Status backgrounds ─────────────────────────────────────────────────
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color errorBg = Color(0xFFFFEBEE);
  static const Color infoBg = Color(0xFFE1F5FE);
}
