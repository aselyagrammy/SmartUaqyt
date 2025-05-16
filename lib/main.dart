import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_page.dart';
import 'about_page.dart';
import 'interactive_page.dart';
import 'settings_page.dart';
import 'timer_page.dart';           // ← add this

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartUaqyt',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('kk'),
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (_locale != null) return _locale;
        if (deviceLocale == null) return const Locale('kk');
        return supportedLocales.firstWhere(
          (loc) => loc.languageCode == deviceLocale.languageCode,
          orElse: () => const Locale('kk'),
        );
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/home',
      routes: {
        '/home': (_) => HomePage(),
        '/about': (_) => AboutPage(),
        '/interactive': (_) => InteractivePage(),
        '/timer': (_) => TimerPage(),      // ← now recognized
        '/settings': (_) => SettingsPage(
              themeMode: _themeMode,
              onThemeChanged: (newMode) => setState(() => _themeMode = newMode),
              locale: _locale ?? const Locale('en'),
              onLocaleChanged: (newLocale) => setState(() => _locale = newLocale),
            ),
      },
    );
  }
}
