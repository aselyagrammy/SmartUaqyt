import 'package:flutter/material.dart';
import 'package:smartuaqyt/l10n/generated/app_localizations.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      // ─────────────── Drawer ───────────────
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                loc.appTitle,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(loc.home),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(loc.about),
              onTap: () => Navigator.pop(context), // already here
            ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: Text(loc.settingsPageTitle),
              onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
            ),
          ],
        ),
      ),

      appBar: AppBar(title: Text(loc.about)),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.appDescriptionTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              loc.appDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Text(
              loc.creditsTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              loc.credits,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
