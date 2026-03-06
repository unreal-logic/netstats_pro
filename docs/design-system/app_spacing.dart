import 'package:flutter/material.dart';

/// AppSpacing — 8px base grid
///
/// Use these constants everywhere instead of raw numbers.
/// Helps maintain rhythm and consistency across the app.
abstract final class AppSpacing {
  static const double px2 = 2;
  static const double px4 = 4;
  static const double px6 = 6;
  static const double px8 = 8;
  static const double px10 = 10;
  static const double px12 = 12;
  static const double px14 = 14;
  static const double px16 = 16;
  static const double px20 = 20;
  static const double px24 = 24;
  static const double px28 = 28;
  static const double px32 = 32;
  static const double px40 = 40;
  static const double px48 = 48;
  static const double px56 = 56;
  static const double px64 = 64;
  static const double px80 = 80;
  static const double px96 = 96;

  // ─── Named aliases ────────────────────────────────────────────────────────
  static const double xs = px4;
  static const double sm = px8;
  static const double md = px16;
  static const double lg = px24;
  static const double xl = px32;
  static const double xxl = px48;
  static const double xxxl = px64;

  // ─── Insets ───────────────────────────────────────────────────────────────
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: px24);
  static const EdgeInsets cardPadding = EdgeInsets.all(px16);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(px20);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: px12,
    vertical: px6,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: px24,
    vertical: px16,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: px16,
    vertical: px16,
  );
  static const EdgeInsets sectionGap = EdgeInsets.only(bottom: px24);

  // ─── SizedBox helpers ─────────────────────────────────────────────────────
  static const Widget gap4 = SizedBox(height: px4, width: px4);
  static const Widget gap8 = SizedBox(height: px8, width: px8);
  static const Widget gap12 = SizedBox(height: px12, width: px12);
  static const Widget gap16 = SizedBox(height: px16, width: px16);
  static const Widget gap24 = SizedBox(height: px24, width: px24);

  static const Widget vGap4 = SizedBox(height: px4);
  static const Widget vGap8 = SizedBox(height: px8);
  static const Widget vGap12 = SizedBox(height: px12);
  static const Widget vGap16 = SizedBox(height: px16);
  static const Widget vGap24 = SizedBox(height: px24);
  static const Widget vGap32 = SizedBox(height: px32);
  static const Widget vGap40 = SizedBox(height: px40);

  static const Widget hGap4 = SizedBox(width: px4);
  static const Widget hGap8 = SizedBox(width: px8);
  static const Widget hGap12 = SizedBox(width: px12);
  static const Widget hGap16 = SizedBox(width: px16);
  static const Widget hGap24 = SizedBox(width: px24);
}

/// AppRadius — Border radius tokens
///
/// The design uses a 12px default corner with larger 16px for cards
/// and full-pill for badges/chips.
abstract final class AppRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12; // Default — matches HTML tailwind DEFAULT
  static const double lg = 16; // rounded-2xl
  static const double xl = 20;
  static const double xxl = 24;
  static const double pill = 999;

  // ─── BorderRadius objects ─────────────────────────────────────────────────
  static const BorderRadius brNone = BorderRadius.zero;
  static const BorderRadius brXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));

  // ─── ShapeBorder helpers ──────────────────────────────────────────────────
  static RoundedRectangleBorder shape(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  static const RoundedRectangleBorder shapeMd = RoundedRectangleBorder(
    borderRadius: brMd,
  );
  static const RoundedRectangleBorder shapeLg = RoundedRectangleBorder(
    borderRadius: brLg,
  );
  static const RoundedRectangleBorder shapeXl = RoundedRectangleBorder(
    borderRadius: brXl,
  );
}

/// AppElevation — Shadow tokens aligned with Material 3 tonal elevation
abstract final class AppElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 3;
  static const double high = 6;
  static const double raised = 12;

  /// Blue-tinted shadow for primary buttons
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Subtle elevation shadow for cards in light mode
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];
}
