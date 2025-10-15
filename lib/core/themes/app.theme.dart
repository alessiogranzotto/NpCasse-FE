import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static final Color _bluePrimaryColor = Colors.blueGrey.shade900;
  static const Color _iconColor = Colors.white;

  // static const Color _accentColor = Color.fromRGBO(74, 217, 217, 1);

  // *****************
  // Text Style - light
  // *****************
  static final TextStyle _lightTitleLargeText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightTitleMediumText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightTitleSmallText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightHeadlineLargeText = GoogleFonts.openSans(
    color: _lightonPrimaryContainer,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightHeadlineMediumText = GoogleFonts.openSans(
    color: _lightonPrimaryContainer,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightHeadlineSmallText = GoogleFonts.openSans(
    color: _lightonPrimaryContainer,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightBodyLargeText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle _lightBodyMediumText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle _lightBodySmallText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle _lightLabelLargeText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightLabelMediumText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightLabelSmallText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightDisplayLargeText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightDisplayMediumText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightDisplaySmallText = GoogleFonts.openSans(
    color: _lightTextColorPrimary,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static TextTheme _lightTextTheme = TextTheme(
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
    selectionColor: Colors.blueAccent,
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

  static final ThemeData blueTheme = ThemeData(
      scaffoldBackgroundColor: _bluePrimaryColor,
      cardColor: _darkcardColor,
      hintColor: _darkhintColor,
      shadowColor: _darkshadow,
      appBarTheme: const AppBarTheme(
          color: CustomColors.darkBlue,
          iconTheme: IconThemeData(color: _iconColor)),
      // bottomAppBarColor: _appbarColorDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.darkBlue,
        // background: _darkbackground,
        // onBackground: _darkonBackground,
        // primary: _darkprimary,
        // onPrimary: _darkonPrimary,
        // secondary: _darksecondary,
        // onSecondary: _darkonSecondary,
        // tertiary: _darktertiary,
        // onTertiary: _darkonTertiary,
        // primaryContainer: _darkprimaryContainer,
        // onPrimaryContainer: _darkonPrimaryContainer,
        // secondaryContainer: _darksecondaryContainer,
        // onSecondaryContainer: _darkonSecondaryContainer,
        // tertiaryContainer: _darktertiaryContainer,
        // onTertiaryContainer: _darkonTertiaryContainer,
        // shadow: _darkshadow,
        // onSurface: _darkonSurface,
      ),
      textTheme: _darkTextTheme,
      textSelectionTheme: _textSelectionTheme);
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static const Color darkBlue = Color(0xFF0C2044);
}

// class AppTheme {
//   AppTheme._();

//   static const String defaultFont = 'Open Sans';

//   static TextTheme _baseTextTheme(Color textColor, String font) => TextTheme(
//         titleLarge: GoogleFonts.getFont(font,
//             color: textColor, fontSize: 26, fontWeight: FontWeight.bold),
//         titleMedium: GoogleFonts.getFont(font,
//             color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
//         titleSmall: GoogleFonts.getFont(font,
//             color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
//         bodyLarge: GoogleFonts.getFont(font, color: textColor, fontSize: 14),
//         bodyMedium: GoogleFonts.getFont(font, color: textColor, fontSize: 12),
//         bodySmall: GoogleFonts.getFont(font, color: textColor, fontSize: 10),
//         labelLarge: GoogleFonts.getFont(font,
//             color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
//       );

//   static ThemeData buildTheme({
//     required Brightness brightness,
//     required Color seedColor,
//     required String font,
//     Color? scaffoldColor,
//   }) {
//     final colorScheme =
//         ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
//     final textColor =
//         brightness == Brightness.dark ? Colors.white : Colors.black87;
//     final textTheme = _baseTextTheme(textColor, font);

//     return ThemeData(
//       brightness: brightness,
//       colorScheme: colorScheme,
//       scaffoldBackgroundColor: scaffoldColor ?? colorScheme.surface,
//       textTheme: textTheme,
//       primaryTextTheme: textTheme,
//       appBarTheme: AppBarTheme(
//         backgroundColor: colorScheme.primaryContainer,
//         foregroundColor: colorScheme.onPrimaryContainer,
//         titleTextStyle: GoogleFonts.getFont(font,
//             color: colorScheme.onPrimaryContainer,
//             fontSize: 20,
//             fontWeight: FontWeight.bold),
//         iconTheme: IconThemeData(color: colorScheme.onPrimaryContainer),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: colorScheme.primary,
//           foregroundColor: colorScheme.onPrimary,
//           textStyle: GoogleFonts.getFont(font, fontWeight: FontWeight.bold),
//         ),
//       ),
//       textSelectionTheme: TextSelectionThemeData(
//         cursorColor: colorScheme.primary,
//         selectionColor: colorScheme.primaryContainer.withAlpha(80),
//       ),
//     );
//   }

//   // predefiniti (usali come convenienza ma non obbligatori)
//   static ThemeData get lightTheme => buildTheme(
//         brightness: Brightness.light,
//         seedColor: Colors.grey.shade200,
//         font: defaultFont,
//         scaffoldColor: Colors.white,
//       );

//   static ThemeData get darkTheme => buildTheme(
//         brightness: Brightness.dark,
//         seedColor: Colors.grey.shade700,
//         font: defaultFont,
//         scaffoldColor: Colors.black,
//       );

//   static ThemeData get blueTheme => buildTheme(
//         brightness: Brightness.light,
//         seedColor: CustomColors.darkBlue,
//         font: defaultFont,
//         scaffoldColor: Colors.white,
//       );
// }
