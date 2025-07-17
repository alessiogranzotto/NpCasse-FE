import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/app/providers/provider.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/themes/themes.dart';
import 'package:np_casse/screens/homeScreen/theme.mode.dart';
import 'package:provider/provider.dart';
import 'package:paged_datatable/paged_datatable.dart'; // Import your PagedDataTable
import 'package:intl/date_symbol_data_local.dart'; // Import this for locale initialization

void main() {
  initializeDateFormatting('it', null);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const NpCasseApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class NpCasseApp extends StatelessWidget {
  const NpCasseApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: const Core(),
    );
  }
}

class Core extends StatelessWidget {
  const Core({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProviderNotifier>(context);
    return MaterialApp(
      title: 'Give Pro',
      localizationsDelegates: [
        PagedDataTableLocalization.delegate, // Add this line
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        // You can add more locales here if needed
      ],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splashRoute,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      // theme: ThemeData(
      //   useMaterial3: true, // Assicurati di usare Material Design 3
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.red, // Qui imposti il colore di base
      //   ),
      // ),
      darkTheme: AppTheme.blueTheme,
    );
  }
}
