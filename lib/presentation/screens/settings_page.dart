import 'package:flutter/material.dart';
import 'package:smartuaqyt/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../data/services/prefs_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PrefsService>();
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsPageTitle)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(loc.appTitle, style: const TextStyle(fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(loc.home),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(loc.about),
              onTap: () => Navigator.pushReplacementNamed(context, '/about'),
            ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: Text(loc.settingsPageTitle),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.themeLabel, style: textTheme.titleMedium),
            DropdownButton<ThemeMode>(
              value: prefs.themeMode,
              onChanged: (m) => prefs.update(theme: m),
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(loc.languageLabel, style: textTheme.titleMedium),
            DropdownButton<Locale>(
              value: Locale(prefs.lang),
              onChanged: (l) => prefs.update(lang: l!.languageCode),
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
                DropdownMenuItem(
                  value: Locale('kk'),
                  child: Text('Қазақ тілі'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
