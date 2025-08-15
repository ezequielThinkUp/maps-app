import 'package:flutter/material.dart';
import 'color_schema.dart';

class AppTextTheme {
  // Tipografías base
  static const String _fontFamily = 'Inter';
  static const String _fontFamilyDisplay = 'Poppins';

  // Text Theme principal
  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // Estilos personalizados
  static TextStyle get heading1 => textTheme.displayLarge!.copyWith(
    fontFamily: _fontFamilyDisplay,
    fontWeight: FontWeight.bold,
    color: AppColorSchema.onBackground,
  );

  static TextStyle get heading2 => textTheme.displayMedium!.copyWith(
    fontFamily: _fontFamilyDisplay,
    fontWeight: FontWeight.w600,
    color: AppColorSchema.onBackground,
  );

  static TextStyle get heading3 => textTheme.displaySmall!.copyWith(
    fontFamily: _fontFamilyDisplay,
    fontWeight: FontWeight.w600,
    color: AppColorSchema.onBackground,
  );

  static TextStyle get bodyText => textTheme.bodyLarge!.copyWith(
    fontFamily: _fontFamily,
    color: AppColorSchema.onSurface,
  );

  static TextStyle get caption => textTheme.bodySmall!.copyWith(
    fontFamily: _fontFamily,
    color: AppColorSchema.onSurfaceVariant,
  );

  static TextStyle get button => textTheme.labelLarge!.copyWith(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    color: AppColorSchema.onPrimary,
  );

  // Estilos para estados específicos
  static TextStyle get error => textTheme.bodyMedium!.copyWith(
    color: AppColorSchema.error,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get success => textTheme.bodyMedium!.copyWith(
    color: AppColorSchema.success,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get link => textTheme.bodyMedium!.copyWith(
    color: AppColorSchema.primary,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );
}
