import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AppLanguage { en, ru, kk }

class InteractivePage extends StatefulWidget {
  @override
  _InteractivePageState createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage> {
  late String message;
  bool isVisible = true;
  bool isDark = false;
  AppLanguage selectedLanguage = AppLanguage.en;

  @override
  void initState() {
    super.initState();
    message = ""; // initialized in build using localization
  }

  void _toggleMessage() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void _changeMessage() {
    setState(() {
      message = AppLocalizations.of(context)!.longPressedMessage;
    });
  }

  String _getGreetingFor(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.en:
        return "Welcome to SmartUaqyt!";
      case AppLanguage.ru:
        return "Добро пожаловать в СмартУақыт!";
      case AppLanguage.kk:
        return "SmartUaqyt-қа қош келдіңіз!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (message.isEmpty) {
      message = localizations.greeting;
    }

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.interactivePageTitle),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
              },
            ),
          ],
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Language Selector
                  DropdownButton<AppLanguage>(
                    value: selectedLanguage,
                    onChanged: (AppLanguage? newLang) {
                      if (newLang != null) {
                        setState(() {
                          selectedLanguage = newLang;
                          message = _getGreetingFor(newLang);
                        });
                      }
                    },
                    items: AppLanguage.values.map((AppLanguage lang) {
                      return DropdownMenuItem<AppLanguage>(
                        value: lang,
                        child: Text(lang.toString().split('.').last.toUpperCase()),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Message Box with Gestures
                  GestureDetector(
                    onTap: _toggleMessage,
                    onLongPress: _changeMessage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: isVisible
                          ? Text(
                              message,
                              style: const TextStyle(fontSize: 22),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              localizations.hidden,
                              style: const TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
