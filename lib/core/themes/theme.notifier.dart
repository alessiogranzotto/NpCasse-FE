// // theme.notifier.dart
// import 'package:flutter/material.dart';
// import 'package:np_casse/core/themes/app.theme.dart';

// enum AppThemeMode { light, dark, blue }

// class ThemeNotifier extends ChangeNotifier {
//   AppThemeMode _currentMode = AppThemeMode.light;
//   String _fontFamily = AppTheme.defaultFont;

//   AppThemeMode get currentMode => _currentMode;
//   String get fontFamily => _fontFamily;

//   // restituisce ThemeData GENERATO con il font corrente
//   ThemeData get currentTheme {
//     switch (_currentMode) {
//       case AppThemeMode.light:
//         return AppTheme.buildTheme(
//           brightness: Brightness.light,
//           seedColor: Colors.grey.shade200,
//           font: _fontFamily,
//           scaffoldColor: Colors.white,
//         );
//       case AppThemeMode.dark:
//         return AppTheme.buildTheme(
//           brightness: Brightness.dark,
//           seedColor: Colors.grey.shade700,
//           font: _fontFamily,
//           scaffoldColor: Colors.black,
//         );
//       case AppThemeMode.blue:
//         return AppTheme.buildTheme(
//           brightness: Brightness.light,
//           seedColor: AppTheme
//               .blueTheme.colorScheme.primary, // oppure CustomColors.darkBlue
//           font: _fontFamily,
//           scaffoldColor: Colors.white,
//         );
//     }
//   }

//   void setThemeMode(AppThemeMode mode) {
//     if (_currentMode != mode) {
//       _currentMode = mode;
//       notifyListeners();
//     }
//   }

//   void updateFont(String font) {
//     if (_fontFamily != font) {
//       _fontFamily = font;
//       notifyListeners();
//     }
//   }
// }
