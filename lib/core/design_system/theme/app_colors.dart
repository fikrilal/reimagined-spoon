import 'package:flutter/material.dart';

/// Primitive color seeds ported from mobile-core-kit.
///
/// Widgets should prefer semantic roles from [ColorScheme] instead of reading
/// these values directly.
abstract final class AppColors {
  static const brand = Color(0xFF9FE870);
  static const neutral = Color(0xFF868685);
  static const success = Color(0xFF2F5711);
  static const warning = Color(0xFFEDC843);
  static const info = Color(0xFFA0E1E1);
}
