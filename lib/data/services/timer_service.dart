import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartuaqyt/data/models/timer_entry.dart';
import 'package:smartuaqyt/data/services/connectivity_service.dart';
import 'package:smartuaqyt/data/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class TimerService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage;
  final ConnectivityService _connectivity;
  final _uuid = const Uuid();

  List<TimerEntry> _entries = [];
  bool _isSyncing = false;
  Timer? _syncTimer;
  StreamSubscription? _connectivitySubscription;

  TimerService(this._storage, this._connectivity) {
    _initConnectivity();
  }

  void _initConnectivity() {
    // Start periodic sync if online
    if (_connectivity.isOnline) {
      _startPeriodicSync();
    }

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      isOnline,
    ) {
      if (isOnline) {
        _startPeriodicSync();
      } else {
        _syncTimer?.cancel();
      }
    });
  }

  List<TimerEntry> get entries => _entries;
  bool get isSyncing => _isSyncing;

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) => syncData());
  }

  Future<void> loadEntries(String userId) async {
    // Load local entries first
    final localData = _storage.getTimings(userId);
    if (localData.isNotEmpty) {
      _entries =
          localData
              .map((e) => TimerEntry.fromJson(Map<String, dynamic>.from(e)))
              .toList();
      notifyListeners();
    }

    // If online, fetch from Firebase and merge
    if (_connectivity.isOnline) {
      try {
        final snapshot =
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('timings')
                .orderBy('timestamp', descending: true)
                .get();

        final remoteEntries =
            snapshot.docs.map((doc) => TimerEntry.fromFirestore(doc)).toList();

        // Merge remote and local entries
        final mergedEntries = <TimerEntry>[];
        final seenIds = <String>{};

        // Add remote entries first (they take precedence)
        for (final entry in remoteEntries) {
          mergedEntries.add(entry);
          seenIds.add(entry.id);
        }

        // Add local entries that aren't in remote
        for (final entry in _entries) {
          if (!seenIds.contains(entry.id)) {
            mergedEntries.add(entry);
          }
        }

        _entries = mergedEntries;
        await _saveLocal(userId);
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading remote entries: $e');
      }
    }
  }

  Future<void> addEntry(
    String userId,
    String name,
    String duration, [
    Map<String, dynamic> details = const {},
  ]) async {
    final entry = TimerEntry(
      id: _uuid.v4(),
      name: name,
      duration: duration,
      timestamp: DateTime.now(),
      isSynced: false,
      details: details,
    );

    _entries.insert(0, entry);
    notifyListeners();

    // Save locally first
    await _saveLocal(userId);

    // If online, save to Firebase
    if (_connectivity.isOnline) {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('timings')
            .doc(entry.id)
            .set(entry.toFirestore());

        // Update entry to mark as synced
        final index = _entries.indexWhere((e) => e.id == entry.id);
        if (index != -1) {
          _entries[index] = entry.copyWith(isSynced: true);
          await _saveLocal(userId);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error saving entry to Firebase: $e');
      }
    }
  }

  Future<void> syncData([String? userId]) async {
    if (!_connectivity.isOnline ||
        _isSyncing ||
        _entries.isEmpty ||
        userId == null)
      return;

    _isSyncing = true;
    notifyListeners();

    try {
      final unsyncedEntries = _entries.where((e) => !e.isSynced).toList();
      for (final entry in unsyncedEntries) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('timings')
            .doc(entry.id)
            .set(entry.toFirestore());

        final index = _entries.indexWhere((e) => e.id == entry.id);
        if (index != -1) {
          _entries[index] = entry.copyWith(isSynced: true);
        }
      }

      await _saveLocal(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing data: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> _saveLocal(String userId) async {
    final jsonList = _entries.map((e) => e.toJson()).toList();
    await _storage.saveTimings(userId, jsonList);
  }

  Future<void> clear() async {
    _entries = [];
    _syncTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
