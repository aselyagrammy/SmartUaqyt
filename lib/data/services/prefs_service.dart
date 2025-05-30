import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrefsService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _lang = 'en';
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>>? _doc;

  ThemeMode get themeMode => _themeMode;
  String get lang => _lang;

  void attach(User? user) {
    if (user == null) return;
    _doc = _db.collection('users').doc(user.uid);
    _load();
  }

  Future<void> _load() async {
    if (_doc == null) return;
    try {
      final snap = await _doc!.get();
      if (snap.exists) {
        final data = snap.data()!;
        _themeMode =
            (data['theme'] ?? 'system') == 'dark'
                ? ThemeMode.dark
                : (data['theme'] == 'light'
                    ? ThemeMode.light
                    : ThemeMode.system);
        _lang = data['lang'] ?? 'en';
      }
    } catch (e) {
      debugPrint('Prefs load error: $e');
    }
    notifyListeners();
  }

  Future<void> update({ThemeMode? theme, String? lang}) async {
    if (theme != null) _themeMode = theme;
    if (lang != null) _lang = lang;
    notifyListeners();
    await _doc?.set({
      'theme':
          _themeMode == ThemeMode.dark
              ? 'dark'
              : (_themeMode == ThemeMode.light ? 'light' : 'system'),
      'lang': _lang,
    });
  }
}
