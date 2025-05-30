import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smartuaqyt/data/services/storage_service.dart';
import 'package:smartuaqyt/data/services/timer_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storage;
  final TimerService _timerService;

  User? get user => _auth.currentUser;
  String? get currentUserId => user?.uid;
  String? get currentUserEmail => user?.email;
  bool get isAuth => user != null;
  Stream<User?> get changes => _auth.authStateChanges();

  AuthService(this._storage, this._timerService) {
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _storage.saveAuthState(currentUserId, currentUserEmail);
      await _timerService.loadEntries(currentUserId ?? '');
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _storage.saveAuthState(currentUserId, currentUserEmail);
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Clear local data first
      await _timerService.clear();
      await _storage.clearAuthState();

      // Then sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }
}
