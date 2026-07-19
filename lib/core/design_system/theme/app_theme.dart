import 'package:flutter/material.dart';
import 'package:reimagined_spoon/core/design_system/theme/app_colors.dart';
import 'package:reimagined_spoon/core/design_system/theme/tokens/app_radii.dart';
import 'package:reimagined_spoon/core/design_system/theme/tokens/app_sizing.dart';
import 'package:reimagined_spoon/core/design_system/theme/tokens/app_spacing.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final brandScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: brightness,
    );
    final neutralScheme = ColorScheme.fromSeed(
      seedColor: AppColors.neutral,
      brightness: brightness,
    );
    final scheme = brandScheme.copyWith(
      surface: neutralScheme.surface,
      onSurface: neutralScheme.onSurface,
      onSurfaceVariant: neutralScheme.onSurfaceVariant,
      surfaceContainerLowest: neutralScheme.surfaceContainerLowest,
      surfaceContainerLow: neutralScheme.surfaceContainerLow,
      surfaceContainer: neutralScheme.surfaceContainer,
      surfaceContainerHigh: neutralScheme.surfaceContainerHigh,
      surfaceContainerHighest: neutralScheme.surfaceContainerHighest,
      outline: neutralScheme.outline,
      outlineVariant: neutralScheme.outlineVariant,
      inverseSurface: neutralScheme.inverseSurface,
      onInverseSurface: neutralScheme.onInverseSurface,
      surfaceTint: neutralScheme.surfaceTint,
      shadow: neutralScheme.shadow,
      scrim: neutralScheme.scrim,
    );
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
      borderSide: BorderSide(color: scheme.outline),
    );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, AppSizing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space24,
            vertical: AppSpacing.space12,
          ),
          elevation: 0,
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(0, AppSizing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space24,
            vertical: AppSpacing.space12,
          ),
          side: BorderSide(color: scheme.primary),
          shape: const StadiumBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space16,
        ),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: scheme.primary),
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
        disabledBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        subtitleTextStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
        ),
      ),
    );
  }
}
