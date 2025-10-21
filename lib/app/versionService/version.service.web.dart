import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/routes/api_routes.dart';
import 'version.service.dart';

class VersionServiceImpl implements VersionService {
  VersionServiceImpl();

  /// Recupera la versione corrente dall'app (memorizzata in localStorage)
  @override
  Future<String> getCurrentVersion() async {
    return AppKeys.version;
  }

  @override
  Future<String> getLatestVersion() async {
    try {
      String app = 'Givepro';
      final response = await http
          .get(Uri.parse('${ApiRoutes.baseVersionURL}/$app/Version-code'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['latestVersion'] ?? "0.0.0";
      } else {
        throw Exception('Errore nel recupero versione');
      }
    } catch (e) {
      debugPrint("Errore getLatestVersion: $e");
      return "0.0.0";
    }
  }

  /// Salva la versione corrente in localStorage
  Future<void> saveCurrentVersion(String version) async {
    try {
      html.window.localStorage['current_version'] = version;
    } catch (_) {}
  }

  /// Mostra un dialog che invita l'utente a ricaricare l'app se esiste una nuova versione
  @override
  Future<void> showUpdateDialogIfNeeded(BuildContext context) async {
    try {
      final current = await getCurrentVersion();
      final latest = await getLatestVersion();
      if (current != latest) {
        // if (context.mounted) {
        //   await showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (context) => AlertDialog(
        //       title: Text("Nuova versione disponibile",
        //           style: Theme.of(context).textTheme.titleSmall),
        //       content: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           const Text(
        //               "È disponibile una nuova versione. Aggiorna per continuare."),
        //           const SizedBox(height: 16),
        //           Text("Versione attuale: $current"),
        //           const SizedBox(height: 8),
        //           Text("Versione nuova: $latest"),
        //         ],
        //       ),
        //       actions: [
        //         ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Colors.blue, // colore del bottone
        //             foregroundColor: Colors.white,
        //             textStyle: const TextStyle(fontWeight: FontWeight.bold),
        //           ),
        //           onPressed: () async {
        //             // Salva la versione corrente solo quando l’utente clicca
        //             await saveCurrentVersion(latest);
        //             html.window.location.reload();
        //           },
        //           child: const Text("Aggiorna"),
        //         ),
        //       ],
        //     ),
        //   );
        // }
        await saveCurrentVersion(latest);
        html.window.location.reload();
      }
    } catch (e) {
      // Ignora errori, non vogliamo bloccare l'app
      print("Errore controllo versione web: $e");
    }
  }

  @override
  Future<void> reloadApp() async {
    try {
      html.window.location.reload();
    } catch (_) {}
  }
}
