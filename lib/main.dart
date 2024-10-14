import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/app/providers/provider.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:paged_datatable/paged_datatable.dart'; // Import your PagedDataTable

void main() {
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
    return MaterialApp(
      title: 'Np casse',
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
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.blueTheme,
    );
  }
}
