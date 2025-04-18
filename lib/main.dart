import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ required for AppLocalizations

import 'home_page.dart';
import 'about_page.dart';
import 'interactive_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartUaqyt',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // 🌗 Auto light/dark mode
      supportedLocales: const [
        Locale('en'), // English
        Locale('ru'), // Russian
        Locale('kk'), // Kazakh
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return Locale('kk');
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return Locale('kk'); // fallback to Kazakh
      },
      localizationsDelegates: const [
        AppLocalizations.delegate, // ✅ required for AppLocalizations.of(context)
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/interactive': (context) => InteractivePage(),
      },
    );
  }
}
