import 'package:flutter/material.dart';

class AppColorSchema {
  // Colores primarios
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF1E3A8A);

  // Colores secundarios
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryContainer = Color(0xFFD1FAE5);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF064E3B);

  // Colores terciarios
  static const Color tertiary = Color(0xFFF59E0B);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF92400E);

  // Colores de error
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF991B1B);

  // Colores de superficie
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color onSurface = Color(0xFF1F2937);
  static const Color onSurfaceVariant = Color(0xFF6B7280);

  // Colores de fondo
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1F2937);

  // Colores de outline
  static const Color outline = Color(0xFFE5E7EB);
  static const Color outlineVariant = Color(0xFFD1D5DB);

  // Colores de sombra
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Colores de estado
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Colores de gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // Colores de transparencia
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);

  static Color surfaceWithOpacity(double opacity) =>
      surface.withOpacity(opacity);
}
