import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'version.service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class VersionServiceImpl implements VersionService {
  VersionServiceImpl();

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

  Future<void> downloadAndInstallApk(
      BuildContext context, String latest, bool checkPermission) async {
    try {
      String app = 'Givepro';

      if (checkPermission) {
        Map<Permission, PermissionStatus> statuses = await [
          // Permission.storage,
          Permission.manageExternalStorage,
          Permission.requestInstallPackages,
        ].request();

        List<String> denied = [];
        statuses.forEach((permission, status) {
          if (!status.isGranted) {
            denied.add(permission.toString().split('.').last);
          }
        });

        if (denied.isNotEmpty) {
          if (context.mounted) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Permessi richiesti"),
                content: Text(
                    "Per procedere con l'aggiornamento, concedi i seguenti permessi:\n\n${denied.join('\n')}"),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Chiudi"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await openAppSettings(); // apre impostazioni app
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Apri impostazioni"),
                  ),
                ],
              ),
            );
          }
          return;
        }
      }

      final Directory baseDir = await getExternalStorageDirectory() ??
          (throw Exception("Impossibile accedere alla memoria esterna"));
      final Directory updateDir = Directory('${baseDir.path}/Updates');
      if (!updateDir.existsSync()) updateDir.createSync(recursive: true);
      final String filePath = '${updateDir.path}/Givepro $latest.apk';

      final Uri uri = Uri.parse(
          'https://apicasse.giveapp.it/api/Version/Latest-version/$app/Apk');

      double progress = 0.0;
      late void Function(void Function()) setDialogState;
      bool downloadCompleted = false;
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                setDialogState = setState;
                return AlertDialog(
                  title: const Text("Download aggiornamento"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Attendere il completamento del download..."),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 8),
                      Text("${(progress * 100).toStringAsFixed(0)}%"),
                    ],
                  ),
                  actions: [
                    checkPermission
                        ? ElevatedButton(
                            onPressed: () async {
                              // Chiude l'app
                              SystemNavigator.pop();
                              // Lancia l'installer
                              try {
                                await OpenFilex.open(filePath);
                              } catch (e, s) {
                                debugPrint(
                                    "❌ Errore durante l’apertura dell’APK: $e");
                                debugPrint(s.toString());

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Si è verificato un errore durante l’installazione."),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Installa"),
                          )
                        : ElevatedButton(
                            onPressed: downloadCompleted
                                ? () async {
                                    await SystemNavigator.pop();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Chiudi"),
                          ),
                  ],
                );
              },
            );
          },
        );
      }
      final request = http.Request('GET', uri);
      final response = await request.send();
      final totalBytes = response.contentLength ?? 0;
      int received = 0;
      final file = File(filePath);
      final sink = file.openWrite();

      await for (final chunk in response.stream) {
        received += chunk.length;
        sink.add(chunk);

        if (totalBytes > 0) {
          progress = received / totalBytes;
          setDialogState(() {});
        }
      }

      await sink.close();
// Aggiorna stato a download completato
      downloadCompleted = true;
      setDialogState(() {});

      debugPrint("✅ APK scaricato in: $filePath");
      // if (context.mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //         content:
      //             Text("Download completato. Premi Installa per aggiornare.")),
      //   );
      // }
    } catch (e) {
      debugPrint("❌ Errore durante il download dell'APK: $e");
      if (context.mounted) {
        Navigator.pop(context); // Chiude eventuale dialog aperto
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Errore durante il download dell'aggiornamento.")),
        );
      }
    }
  }

  @override
  Future<void> reloadApp() async {
    // Non necessario su APK, gestito con installazione manuale
  }

  @override
  Future<void> showUpdateDialogIfNeeded(BuildContext context) async {
    try {
      final current = await getCurrentVersion();
      final latest = await getLatestVersion();

      if (current != latest && context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("Nuova versione disponibile",
                style: Theme.of(context).textTheme.titleSmall),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "È disponibile una nuova versione. Aggiorna per continuare."),
                const SizedBox(height: 16),
                Text("Versione attuale: $current"),
                const SizedBox(height: 8),
                Text("Versione nuova: $latest"),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  downloadAndInstallApk(context, latest, false);
                },
                child: const Text("Installa manualmente"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  // Navigator.pop(context);
                  // Chiudi il dialog
                  // Avvia download e installazione
                  downloadAndInstallApk(context, latest, true);
                },
                child: const Text("Aggiorna"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint("Errore controllo versione mobile: $e");
    }
  }
}
