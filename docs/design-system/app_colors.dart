import 'package:flutter/material.dart';

/// AppColors — Design System Color Tokens
///
/// Derived from a blue-primary (#3b82f6) palette with slate neutrals.
/// Follows Material 3 ColorScheme conventions.
/// All raw hex values live here; never hard-code colours elsewhere.
abstract final class AppColors {
  // ─── Brand ───────────────────────────────────────────────────────────────
  static const Color primary          = Color(0xFF3B82F6); // blue-500
  static const Color primaryContainer = Color(0xFF1D4ED8); // blue-700
  static const Color onPrimary        = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFBFDBFE); // blue-200

  // ─── Semantic ────────────────────────────────────────────────────────────
  static const Color success  = Color(0xFF22C55E); // green-500
  static const Color warning  = Color(0xFFF59E0B); // amber-500
  static const Color error    = Color(0xFFEF4444); // red-500
  static const Color info     = Color(0xFF06B6D4); // cyan-500

  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onWarning = Color(0xFF000000);
  static const Color onError   = Color(0xFFFFFFFF);
  static const Color onInfo    = Color(0xFF000000);

  // ─── Dark Neutrals (Slate) ───────────────────────────────────────────────
  static const Color slate50  = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  // ─── Dark Surface Palette ────────────────────────────────────────────────
  static const Color darkBackground        = Color(0xFF0F172A); // slate-900
  static const Color darkSurface           = Color(0xFF1E293B); // slate-800
  static const Color darkSurfaceVariant    = Color(0xFF334155); // slate-700
  static const Color darkSurfaceContainer  = Color(0xFF0F172A);
  static const Color darkOutline           = Color(0xFF1E293B); // slate-800
  static const Color darkOutlineVariant    = Color(0xFF334155); // slate-700

  static const Color darkOnBackground      = Color(0xFFF1F5F9); // slate-100
  static const Color darkOnSurface         = Color(0xFFF1F5F9);
  static const Color darkOnSurfaceVariant  = Color(0xFF94A3B8); // slate-400
  static const Color darkOnSurfaceMuted    = Color(0xFF475569); // slate-600

  // ─── Light Surface Palette ───────────────────────────────────────────────
  static const Color lightBackground       = Color(0xFFF8FAFC); // slate-50
  static const Color lightSurface          = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant   = Color(0xFFF1F5F9); // slate-100
  static const Color lightSurfaceContainer = Color(0xFFE2E8F0); // slate-200
  static const Color lightOutline          = Color(0xFFCBD5E1); // slate-300
  static const Color lightOutlineVariant   = Color(0xFFE2E8F0); // slate-200

  static const Color lightOnBackground     = Color(0xFF0F172A); // slate-900
  static const Color lightOnSurface        = Color(0xFF0F172A);
  static const Color lightOnSurfaceVariant = Color(0xFF475569); // slate-600
  static const Color lightOnSurfaceMuted   = Color(0xFF94A3B8); // slate-400

  // ─── Primary Tinted Surfaces ─────────────────────────────────────────────
  /// Blue tint at 10% opacity — used for selected radio tiles, active pills
  static const Color primarySubtle = Color(0x193B82F6);
  static const Color primaryFaint  = Color(0x0A3B82F6);
}
