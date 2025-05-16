import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  final List<String> stopwatchHistory = [
    "00:45.23", "01:15.90", "00:30.00",
    "02:10.12", "00:59.87", "01:05.33",
    "03:40.10", "00:10.01", "00:25.67", "02:30.22",
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // ─────────────── Drawer ───────────────
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
              leading: const Icon(Icons.info_outline),
              title: Text(loc.about),
              onTap: () => Navigator.pushReplacementNamed(context, '/about'),
            ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: Text(loc.settingsPageTitle),
              onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
            ),
            ListTile(
              leading: Icon(Icons.timer_outlined),
              title: Text('Timer'),
              onTap: () => Navigator.pushNamed(context, '/timer'),
            ),

          ],
        ),
      ),

      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),

      body: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.recentTimings,  // make sure you added this key to arb
                      style: TextStyle(
                        fontSize: screenSize.width > 600 ? 28 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/interactive'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        shape: const StadiumBorder(),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(loc.goToInteractivePage),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: stopwatchHistory.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.timer),
                              title: Text("${loc.session} ${index + 1}"),
                              subtitle: Text("${loc.timeLabel}: ${stopwatchHistory[index]}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
