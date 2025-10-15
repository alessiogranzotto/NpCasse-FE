import 'package:flutter/material.dart';
export 'version.service.mobile.dart'
    if (dart.library.html) 'version.service.web.dart';

abstract class VersionService {
  Future<String> getCurrentVersion();
  Future<String> getLatestVersion();
  Future<void> reloadApp();
  Future<void> showUpdateDialogIfNeeded(BuildContext context);
}
