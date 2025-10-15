import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeUtils {
  ThemeUtils._(); // Private constructor to prevent instantiation

  static TextTheme getTextTheme(String fontName, Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    switch (fontName) {
      case 'Lato':
        return GoogleFonts.latoTextTheme(base);
      case 'Poppins':
        return GoogleFonts.poppinsTextTheme(base);
      case 'Montserrat':
        return GoogleFonts.montserratTextTheme(base);
      default:
        return GoogleFonts.robotoTextTheme(base);
    }
  }
}
