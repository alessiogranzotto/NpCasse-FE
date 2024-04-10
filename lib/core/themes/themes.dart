import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // *****************
  // static colors
  // *****************
  static const Color _lightPrimaryColor = Colors.white;
  // static final Color _lightPrimaryVariantColor = Colors.blueGrey.shade800;
  // static final Color _lightOnPrimaryColor = Colors.blueGrey.shade200;
  static const Color _lightTextColorPrimary = Colors.black;
  static const Color _appbarColorLight = Colors.blue;
  static const Color _lightcardColor = Colors.white;
  static final Color _lighthintColor = Colors.blueGrey.shade400;
  static const Color _lightbackground = Colors.white;
  static const Color _lightonBackground = Colors.black87;
  static const Color _lightprimary = Colors.white;
  static const Color _lightonPrimary = Colors.black87;
  static final Color _lightsecondary = Colors.lightBlue.shade200;
  static const Color _lightonSecondary = Colors.black87;
  static final Color _lighttertiary = Colors.lightGreen.shade200;
  static const Color _lightonTertiary = Colors.black87;
  static final Color _lightprimaryContainer = Colors.blue.shade900;
  static const Color _lightonPrimaryContainer = Colors.white;
  static const Color _lightsecondaryContainer = Colors.blue;
  static const Color _lightonSecondaryContainer = Colors.white;
  static final Color _lighttertiaryContainer = Colors.red.shade900;
  static const Color _lightonTertiaryContainer = Colors.white;
  static const Color _lightshadow = Colors.white54;
  static const Color _lightonSurface = Colors.black87;

  static final Color _darkPrimaryColor = Colors.blueGrey.shade900;
  // static final Color _darkPrimaryVariantColor = Colors.blueGrey.shade400;
  // static final Color _darkOnPrimaryColor = Colors.blueGrey.shade700;
  static const Color _darkTextColorPrimary = Colors.white;
  static final Color _appbarColorDark = Colors.indigo.shade900;
  static final Color _darkcardColor = Colors.grey.withAlpha(25);
  static final Color _darkhintColor = Colors.blueGrey.shade700;
  static const Color _darkbackground = Colors.black87;
  static const Color _darkonBackground = Colors.white;
  static const Color _darkprimary = Colors.black54;
  static const Color _darkonPrimary = Colors.white;
  static final Color _darksecondary = Colors.lightBlue.shade900;
  static const Color _darkonSecondary = Colors.white;
  static final Color _darktertiary = Colors.lightGreen.shade900;
  static const Color _darkonTertiary = Colors.white;
  static final Color _darkprimaryContainer = Colors.indigo.shade900;
  static const Color _darkonPrimaryContainer = Colors.white;
  static const Color _darksecondaryContainer = Colors.blue;
  static const Color _darkonSecondaryContainer = Colors.white;
  static final Color _darktertiaryContainer = Colors.red.shade900;
  static const Color _darkonTertiaryContainer = Colors.white;
  static final Color _darkshadow = Colors.blueGrey.shade900;
  static const Color _darkonSurface = Colors.white70;

  static const Color _iconColor = Colors.white;

  // static const Color _accentColor = Color.fromRGBO(74, 217, 217, 1);

  // *****************
  // Text Style - light
  // *****************

  static const TextStyle _lightTitleLargeText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 26,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightTitleMediumText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightTitleSmallText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightHeadlineLargeText = TextStyle(
      color: _lightonPrimaryContainer,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 20,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightHeadlineMediumText = TextStyle(
      color: _lightonPrimaryContainer,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 16,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightHeadlineSmallText = TextStyle(
      color: _lightonPrimaryContainer,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 12,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightBodyLargeText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 14,
      fontWeight: FontWeight.normal);

  static const TextStyle _lightBodyMediumText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 12);

  static const TextStyle _lightBodySmallText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 10,
      fontWeight: FontWeight.normal);

  static const TextStyle _lightLabelLargeText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightLabelMediumText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 12,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightLabelSmallText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 10,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightDisplayLargeText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 16,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightDisplayMediumText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 14,
      fontWeight: FontWeight.bold);

  static const TextStyle _lightDisplaySmallText = TextStyle(
      color: _lightTextColorPrimary,
      fontFamily: "Roboto",
      fontStyle: FontStyle.normal,
      fontSize: 12,
      fontWeight: FontWeight.bold);

  static const TextTheme _lightTextTheme = TextTheme(
    titleMedium: _lightTitleMediumText,
    titleLarge: _lightTitleLargeText,
    titleSmall: _lightTitleSmallText,
    headlineLarge: _lightHeadlineLargeText, // usati sulle AppBar
    headlineMedium: _lightHeadlineMediumText, // usati sulle AppBar
    headlineSmall: _lightHeadlineSmallText, // usati sulle AppBar
    bodyLarge: _lightBodyLargeText,
    bodyMedium: _lightBodyMediumText,
    bodySmall: _lightBodySmallText,
    labelLarge: _lightLabelLargeText,
    labelMedium: _lightLabelMediumText,
    labelSmall: _lightLabelSmallText,
    displayLarge: _lightDisplayLargeText,
    displayMedium: _lightDisplayMediumText,
    displaySmall: _lightDisplaySmallText,
  );

  // *****************
  // Text Style - dark
  // *****************
  static final TextStyle _darkTitleMediumText =
      _lightTitleMediumText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkBodyMediumText =
      _lightBodyMediumText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkTitleLargeText =
      _lightTitleLargeText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkTitleSmallText =
      _lightTitleSmallText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkHeadlineLargeText =
      _lightHeadlineLargeText.copyWith(color: _darkonPrimaryContainer);
  static final TextStyle _darkHeadlineMediumText =
      _lightHeadlineMediumText.copyWith(color: _darkonPrimaryContainer);
  static final TextStyle _darkHeadlineSmallText =
      _lightHeadlineSmallText.copyWith(color: _darkonPrimaryContainer);
  static final TextStyle _darkBodyLargeText =
      _lightBodyLargeText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkBodySmallText =
      _lightBodySmallText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkLabelLargeText =
      _lightLabelLargeText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkLabelMediumText =
      _lightLabelMediumText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkLabelSmallText =
      _lightLabelSmallText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkDisplayLargeText =
      _lightDisplayLargeText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkDisplayMediumText =
      _lightDisplayMediumText.copyWith(color: _darkTextColorPrimary);
  static final TextStyle _darkDisplaySmallText =
      _lightDisplaySmallText.copyWith(color: _darkTextColorPrimary);

  static final TextTheme _darkTextTheme = TextTheme(
      titleMedium: _darkTitleMediumText,
      bodyMedium: _darkBodyMediumText,
      titleLarge: _darkTitleLargeText,
      titleSmall: _darkTitleSmallText,
      headlineLarge: _darkHeadlineLargeText,
      headlineMedium: _darkHeadlineMediumText,
      headlineSmall: _darkHeadlineSmallText,
      bodyLarge: _darkBodyLargeText,
      bodySmall: _darkBodySmallText,
      labelLarge: _darkLabelLargeText,
      labelMedium: _darkLabelMediumText,
      labelSmall: _darkLabelSmallText,
      displayLarge: _darkDisplayLargeText,
      displayMedium: _darkDisplayMediumText,
      displaySmall: _darkDisplaySmallText);

  static final TextSelectionThemeData _textSelectionTheme =
      TextSelectionThemeData(
    cursorColor: _lightonBackground,
    selectionHandleColor: _lighthintColor,
  );

  // *****************
  // Theme light/dark
  // *****************

  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: _lightPrimaryColor,
      cardColor: _lightcardColor,
      hintColor: _lighthintColor,
      shadowColor: _lightshadow,
      appBarTheme: const AppBarTheme(
          color: _appbarColorLight,
          iconTheme: IconThemeData(color: _iconColor)),
      // bottomAppBarColor: _appbarColorLight,
      colorScheme: ColorScheme.light(
        background: _lightbackground,
        onBackground: _lightonBackground,
        primary: _lightprimary,
        onPrimary: _lightonPrimary,
        secondary: _lightsecondary,
        onSecondary: _lightonSecondary,
        tertiary: _lighttertiary,
        onTertiary: _lightonTertiary,
        primaryContainer: _lightprimaryContainer,
        onPrimaryContainer: _lightonPrimaryContainer,
        secondaryContainer: _lightsecondaryContainer,
        onSecondaryContainer: _lightonSecondaryContainer,
        tertiaryContainer: _lighttertiaryContainer,
        onTertiaryContainer: _lightonTertiaryContainer,
        shadow: _lightshadow,
        onSurface: _lightonSurface,
      ),
      textTheme: _lightTextTheme,
      textSelectionTheme: _textSelectionTheme);

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: _darkPrimaryColor,
      cardColor: _darkcardColor,
      hintColor: _darkhintColor,
      shadowColor: _darkshadow,
      appBarTheme: AppBarTheme(
          color: _appbarColorDark,
          iconTheme: const IconThemeData(color: _iconColor)),
      // bottomAppBarColor: _appbarColorDark,
      colorScheme: ColorScheme.dark(
        background: _darkbackground,
        onBackground: _darkonBackground,
        primary: _darkprimary,
        onPrimary: _darkonPrimary,
        secondary: _darksecondary,
        onSecondary: _darkonSecondary,
        tertiary: _darktertiary,
        onTertiary: _darkonTertiary,
        primaryContainer: _darkprimaryContainer,
        onPrimaryContainer: _darkonPrimaryContainer,
        secondaryContainer: _darksecondaryContainer,
        onSecondaryContainer: _darkonSecondaryContainer,
        tertiaryContainer: _darktertiaryContainer,
        onTertiaryContainer: _darkonTertiaryContainer,
        shadow: _darkshadow,
        onSurface: _darkonSurface,
      ),
      textTheme: _darkTextTheme,
      textSelectionTheme: _textSelectionTheme);
}
