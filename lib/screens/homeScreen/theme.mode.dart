import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  system,
  dark,
}

class ThemeProviderNotifier extends ChangeNotifier {
  AppThemeMode _appThemeMode = AppThemeMode.system;

  AppThemeMode get appThemeMode => _appThemeMode;

  ThemeMode get themeMode {
    switch (_appThemeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeProvider() {
    _loadTheme();
  }

  void setTheme(AppThemeMode mode) {
    _appThemeMode = mode;
    _saveTheme(mode);
    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('appThemeMode') ?? 'system';
    _appThemeMode = AppThemeMode.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => AppThemeMode.system,
    );
    notifyListeners();
  }

  void _saveTheme(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('appThemeMode', mode.name);
  }
}

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProviderNotifier>(context);
    final selected = <AppThemeMode>{provider.appThemeMode};

    return SegmentedButton<AppThemeMode>(
      segments: const [
        ButtonSegment(
          value: AppThemeMode.light,
          // label: Text('Chiaro'),
          icon: Icon(Icons.light_mode),
        ),
        ButtonSegment(
          value: AppThemeMode.system,
          // label: Text('Sistema'),
          icon: Icon(Icons.settings),
        ),
        ButtonSegment(
          value: AppThemeMode.dark,
          // label: Text('Scuro'),
          icon: Icon(Icons.dark_mode),
        ),
      ],
      selected: selected,
      onSelectionChanged: (Set<AppThemeMode> newSelection) {
        if (newSelection.isNotEmpty) {
          provider.setTheme(newSelection.first);
        }
      },
      showSelectedIcon: false,
    );
  }
}
