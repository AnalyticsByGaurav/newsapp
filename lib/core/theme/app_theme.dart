import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFFE53935);
  static const Color primaryDark = Color(0xFFC62828);
  static const Color primaryLight = Color(0xFFEF9A9A);
  static const Color accentColor = Color(0xFFF39C12);

  // Factory methods as specified
  static ThemeData light() => lightTheme;
  static ThemeData dark() => darkTheme;

  static const String fontFamily = 'NotoSansDevanagari';

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      surface: Colors.white,
      background: const Color(0xFFF5F5F5),
      error: const Color(0xFFB00020),
    ),
    fontFamily: fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: fontFamily, fontSize: 16, height: 1.6),
      bodyMedium: TextStyle(fontFamily: fontFamily, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(fontFamily: fontFamily, fontSize: 12, height: 1.4),
      labelLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
    ),
    dividerTheme: const DividerThemeData(thickness: 1, space: 1),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryLight,
      onPrimary: Colors.white,
      secondary: accentColor,
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      error: const Color(0xFFCF6679),
    ),
    fontFamily: fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2D2D2D),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2D2D2D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: fontFamily, fontSize: 16, height: 1.6),
      bodyMedium: TextStyle(fontFamily: fontFamily, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(fontFamily: fontFamily, fontSize: 12, height: 1.4),
      labelLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      space: 1,
      color: Color(0xFF3D3D3D),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryLight,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF1E1E1E),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8,
    ),
  );
}
