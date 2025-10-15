// import 'package:flutter/material.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/themes/theme.notifier.dart';
// import 'package:provider/provider.dart';

// class MyGiveProScreen extends StatelessWidget {
//   const MyGiveProScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
//     final cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     final themeNotifier = context.watch<ThemeNotifier>();

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//         foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         title: Text(
//           'My Give Pro ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             // ===========================
//             // Selezione tema
//             // ===========================
//             const Text(
//               "Seleziona Tema:",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             RadioListTile<AppThemeMode>(
//               title: const Text("Light"),
//               value: AppThemeMode.light,
//               groupValue: themeNotifier.currentMode,
//               onChanged: (val) {
//                 if (val != null) themeNotifier.setThemeMode(val);
//               },
//             ),
//             RadioListTile<AppThemeMode>(
//               title: const Text("Dark"),
//               value: AppThemeMode.dark,
//               groupValue: themeNotifier.currentMode,
//               onChanged: (val) {
//                 if (val != null) themeNotifier.setThemeMode(val);
//               },
//             ),
//             RadioListTile<AppThemeMode>(
//               title: const Text("Blue"),
//               value: AppThemeMode.blue,
//               groupValue: themeNotifier.currentMode,
//               onChanged: (val) {
//                 if (val != null) themeNotifier.setThemeMode(val);
//               },
//             ),
//             const SizedBox(height: 32),

//             // ===========================
//             // Selezione font
//             // ===========================
//             const Text(
//               "Seleziona Font:",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             DropdownButton<String>(
//               value: themeNotifier.fontFamily,
//               items: const [
//                 DropdownMenuItem(value: 'Open Sans', child: Text("Open Sans")),
//                 DropdownMenuItem(value: 'Roboto', child: Text("Roboto")),
//                 DropdownMenuItem(value: 'Lato', child: Text("Lato")),
//                 DropdownMenuItem(value: 'Poppins', child: Text("Poppins")),
//                 DropdownMenuItem(
//                     value: 'Montserrat', child: Text("Montserrat")),
//               ],
//               onChanged: (val) {
//                 if (val != null) themeNotifier.updateFont(val);
//               },
//             ),
//             const SizedBox(height: 32),

//             // ===========================
//             // Widget di test
//             // ===========================
//             Text(
//               "Titolo test",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 16),
//             Card(
//               elevation: 4,
//               color: Theme.of(context).colorScheme.surface,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   "Questa è una card di test per vedere i colori del tema.",
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text("Bottone di test"),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Test bodySmall",
//               style: Theme.of(context).textTheme.bodySmall,
//             ),
//             const SizedBox(height: 16),
//             Center(
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   "Font corrente: ${themeNotifier.fontFamily}",
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Theme.of(context).colorScheme.onPrimaryContainer,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }
