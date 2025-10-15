import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/app/providers/provider.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/versionService/version.service.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/core/themes/theme.notifier.dart';
import 'package:np_casse/screens/homeScreen/theme.mode.dart';
import 'package:provider/provider.dart';
import 'package:paged_datatable/paged_datatable.dart'; // Import your PagedDataTable
import 'package:intl/date_symbol_data_local.dart'; // Import this for locale initialization
import 'package:flutter_localizations/flutter_localizations.dart';

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
    final versionService = VersionServiceImpl();
    return MultiProvider(
      providers: [
        ...AppProvider.providers,
        Provider<VersionService>.value(value: versionService),
      ],
      child: const Core(),
    );
  }
}

// class Core extends StatelessWidget {
//   const Core({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeNotifier>(
//       builder: (context, themeNotifier, child) {
//         // Determina ThemeMode in base al tema corrente
//         ThemeMode mode;
//         switch (themeNotifier.currentMode) {
//           case AppThemeMode.light:
//           case AppThemeMode.blue: // blue è ora chiaro
//             mode = ThemeMode.light;
//             break;
//           case AppThemeMode.dark:
//             mode = ThemeMode.dark;
//             break;
//         }

//         return MaterialApp(
//           title: 'Give Pro',
//           debugShowCheckedModeBanner: false,
//           onGenerateRoute: AppRouter.generateRoute,
//           initialRoute: AppRouter.splashRoute,
//           supportedLocales: const [
//             Locale('it'),
//             Locale('en'),
//           ],
//           localizationsDelegates: const [
//             PagedDataTableLocalization.delegate,
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//           themeMode: mode,

//           // Ora usiamo direttamente il tema corrente dal notifier
//           theme: themeNotifier.currentTheme,
//           darkTheme: themeNotifier.currentTheme,
//         );
//       },
//     );
//   }
// }
class Core extends StatelessWidget {
  const Core({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProviderNotifier>(context);
    return MaterialApp(
      title: 'Give Pro',
      supportedLocales: const [
        Locale('it'), // Italiano
        Locale('en'), // Inglese
      ],
      localizationsDelegates: const [
        PagedDataTableLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
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
