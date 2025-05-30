import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class StorageService extends ChangeNotifier {
  static const String _timingsBoxName = 'timings';
  static const String _syncQueueBoxName = 'sync_queue';
  static const String _prefsBoxName = 'prefs';

  late Box<String> _timingsBox;
  late Box<String> _syncQueueBox;
  late Box<String> _prefsBox;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);

      _timingsBox = await Hive.openBox<String>(_timingsBoxName);
      _syncQueueBox = await Hive.openBox<String>(_syncQueueBoxName);
      _prefsBox = await Hive.openBox<String>(_prefsBoxName);

      _initialized = true;
    } catch (e) {
      debugPrint('Failed to initialize storage: $e');
      // Fallback to in-memory storage for development/testing
      _timingsBox = await Hive.openBox<String>(_timingsBoxName, path: '');
      _syncQueueBox = await Hive.openBox<String>(_syncQueueBoxName, path: '');
      _prefsBox = await Hive.openBox<String>(_prefsBoxName, path: '');
      _initialized = true;
    }
  }

  // Timings storage
  Future<void> saveTimings(
    String userId,
    List<Map<String, dynamic>> timings,
  ) async {
    await _timingsBox.put(userId, json.encode(timings));
    notifyListeners();
  }

  List<Map<String, dynamic>> getTimings(String userId) {
    final data = _timingsBox.get(userId);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(
      json.decode(data).map((x) => Map<String, dynamic>.from(x)),
    );
  }

  // Sync queue management
  Future<void> addToSyncQueue(String userId, Map<String, dynamic> data) async {
    final queue = getSyncQueue(userId);
    queue.add(data);
    await _syncQueueBox.put(userId, json.encode(queue));
  }

  List<Map<String, dynamic>> getSyncQueue(String userId) {
    final data = _syncQueueBox.get(userId);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(
      json.decode(data).map((x) => Map<String, dynamic>.from(x)),
    );
  }

  Future<void> clearSyncQueue(String userId) async {
    await _syncQueueBox.delete(userId);
  }

  // Preferences storage
  Future<void> savePrefs(String userId, Map<String, dynamic> prefs) async {
    await _prefsBox.put(userId, json.encode(prefs));
    notifyListeners();
  }

  Map<String, dynamic> getPrefs(String userId) {
    final data = _prefsBox.get(userId);
    if (data == null) return {};
    return Map<String, dynamic>.from(json.decode(data));
  }

  // Auth persistence
  Future<void> saveAuthState(String? userId, String? email) async {
    await _prefsBox.put(
      'auth_state',
      json.encode({
        'userId': userId,
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
  }

  Map<String, dynamic>? getAuthState() {
    final data = _prefsBox.get('auth_state');
    if (data == null) return null;
    return Map<String, dynamic>.from(json.decode(data));
  }

  Future<void> clearAuthState() async {
    await _prefsBox.delete('auth_state');
  }
}
