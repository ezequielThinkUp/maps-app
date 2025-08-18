import 'package:flutter/material.dart';
import 'color_schema.dart';
import 'text_theme.dart';

class AppTheme {
  // Tema claro
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    textTheme: AppTextTheme.textTheme,
    fontFamily: 'Inter',

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorSchema.surface,
      foregroundColor: AppColorSchema.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextTheme.heading3.copyWith(
        color: AppColorSchema.onSurface,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColorSchema.surface,
      elevation: 2,
      shadowColor: AppColorSchema.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorSchema.primary,
        foregroundColor: AppColorSchema.onPrimary,
        elevation: 2,
        shadowColor: AppColorSchema.shadow.withValues(alpha: 0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextTheme.button,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorSchema.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: AppTextTheme.button.copyWith(color: AppColorSchema.primary),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorSchema.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColorSchema.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColorSchema.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColorSchema.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: AppTextTheme.textTheme.bodyMedium!.copyWith(
        color: AppColorSchema.onSurfaceVariant,
      ),
      hintStyle: AppTextTheme.textTheme.bodyMedium!.copyWith(
        color: AppColorSchema.onSurfaceVariant,
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorSchema.surface,
      selectedItemColor: AppColorSchema.primary,
      unselectedItemColor: AppColorSchema.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorSchema.primary,
      foregroundColor: AppColorSchema.onPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Tema oscuro
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    textTheme: AppTextTheme.textTheme,
    fontFamily: 'Inter',

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.surface,
      foregroundColor: _darkColorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextTheme.heading3.copyWith(
        color: _darkColorScheme.onSurface,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: _darkColorScheme.surface,
      elevation: 2,
      shadowColor: AppColorSchema.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorSchema.primary,
        foregroundColor: AppColorSchema.onPrimary,
        elevation: 2,
        shadowColor: AppColorSchema.shadow.withValues(alpha: 0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextTheme.button,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorSchema.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: AppTextTheme.button.copyWith(color: AppColorSchema.primary),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkColorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _darkColorScheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColorSchema.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColorSchema.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: AppTextTheme.textTheme.bodyMedium!.copyWith(
        color: _darkColorScheme.onSurfaceVariant,
      ),
      hintStyle: AppTextTheme.textTheme.bodyMedium!.copyWith(
        color: _darkColorScheme.onSurfaceVariant,
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _darkColorScheme.surface,
      selectedItemColor: AppColorSchema.primary,
      unselectedItemColor: _darkColorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorSchema.primary,
      foregroundColor: AppColorSchema.onPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Color Scheme para tema claro
  static ColorScheme get _lightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: AppColorSchema.primary,
    onPrimary: AppColorSchema.onPrimary,
    primaryContainer: AppColorSchema.primaryContainer,
    onPrimaryContainer: AppColorSchema.onPrimaryContainer,
    secondary: AppColorSchema.secondary,
    onSecondary: AppColorSchema.onSecondary,
    secondaryContainer: AppColorSchema.secondaryContainer,
    onSecondaryContainer: AppColorSchema.onSecondaryContainer,
    tertiary: AppColorSchema.tertiary,
    onTertiary: AppColorSchema.onTertiary,
    tertiaryContainer: AppColorSchema.tertiaryContainer,
    onTertiaryContainer: AppColorSchema.onTertiaryContainer,
    error: AppColorSchema.error,
    onError: AppColorSchema.onError,
    errorContainer: AppColorSchema.errorContainer,
    onErrorContainer: AppColorSchema.onErrorContainer,
    surface: AppColorSchema.surface,
    onSurface: AppColorSchema.onSurface,
    surfaceContainerHighest: AppColorSchema.surfaceContainerHighest,
    onSurfaceVariant: AppColorSchema.onSurfaceVariant,
    outline: AppColorSchema.outline,
    outlineVariant: AppColorSchema.outlineVariant,
    shadow: AppColorSchema.shadow,
    scrim: AppColorSchema.scrim,
  );

  // Color Scheme para tema oscuro
  static ColorScheme get _darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorSchema.primary,
    onPrimary: AppColorSchema.onPrimary,
    primaryContainer: AppColorSchema.primaryContainer,
    onPrimaryContainer: AppColorSchema.onPrimaryContainer,
    secondary: AppColorSchema.secondary,
    onSecondary: AppColorSchema.onSecondary,
    secondaryContainer: AppColorSchema.secondaryContainer,
    onSecondaryContainer: AppColorSchema.onSecondaryContainer,
    tertiary: AppColorSchema.tertiary,
    onTertiary: AppColorSchema.onTertiary,
    tertiaryContainer: AppColorSchema.tertiaryContainer,
    onTertiaryContainer: AppColorSchema.onTertiaryContainer,
    error: AppColorSchema.error,
    onError: AppColorSchema.onError,
    errorContainer: AppColorSchema.errorContainer,
    onErrorContainer: AppColorSchema.onErrorContainer,
    surface: Color(0xFF1F2937), // Adaptado para modo oscuro
    onSurface: Color(0xFFF9FAFB), // Adaptado para modo oscuro
    surfaceContainerHighest: Color(0xFF374151), // Adaptado para modo oscuro
    onSurfaceVariant: Color(0xFFD1D5DB), // Adaptado para modo oscuro
    outline: Color(0xFF4B5563), // Adaptado para modo oscuro
    outlineVariant: Color(0xFF6B7280), // Adaptado para modo oscuro
    shadow: AppColorSchema.shadow,
    scrim: AppColorSchema.scrim,
  );
}
