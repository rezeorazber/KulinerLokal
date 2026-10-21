import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  static const String _prefUserKey = 'auth_user_data';
  static const String _prefIsLoggedInKey = 'auth_is_logged_in';
  static const String _prefIsGuestKey = 'auth_is_guest';

  UserModel _currentUser = UserModel.defaultUser();
  bool _isLoggedIn = false;
  bool _isGuest = false;
  bool _isLoading = false;

  AuthProvider() {
    _loadFromPreferences();
  }

  // Getters
  UserModel get user => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;
  bool get isLoading => _isLoading;

  String get displayName => _currentUser.name;
  String get displayBio => _currentUser.bio;
  String get displayEmail => _currentUser.email;

  String get initials {
    final parts = _currentUser.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'KL';
  }

  // Load persisted session
  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_prefIsLoggedInKey) ?? false;
      _isGuest = prefs.getBool(_prefIsGuestKey) ?? false;

      final userDataString = prefs.getString(_prefUserKey);
      if (userDataString != null) {
        final Map<String, dynamic> decoded = jsonDecode(userDataString);
        _currentUser = UserModel.fromJson(decoded);
      } else {
        _currentUser = _isGuest ? UserModel.guestUser() : UserModel.defaultUser();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth from prefs: $e');
    }
  }

  // Save current session
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefIsLoggedInKey, _isLoggedIn);
      await prefs.setBool(_prefIsGuestKey, _isGuest);
      await prefs.setString(_prefUserKey, jsonEncode(_currentUser.toJson()));
    } catch (e) {
      debugPrint('Error saving auth to prefs: $e');
    }
  }

  // 1-Click Simulated Google Sign-In for Demo
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    // Smooth simulation delay for realistic demo experience
    await Future.delayed(const Duration(milliseconds: 700));

    _currentUser = UserModel.defaultUser();
    _isLoggedIn = true;
    _isGuest = false;
    _isLoading = false;

    await _saveToPreferences();
    notifyListeners();
    return true;
  }

  // Email / Password Login
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final effectiveName = email.contains('@')
        ? email.split('@').first.replaceAll('.', ' ')
        : 'Pengguna Kuliner';

    _currentUser = _currentUser.copyWith(
      name: effectiveName.split(' ').map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '').join(' ').trim(),
      email: email,
    );
    _isLoggedIn = true;
    _isGuest = false;
    _isLoading = false;

    await _saveToPreferences();
    notifyListeners();
    return true;
  }

  // Continue as Guest ("Jelajahi dulu")
  Future<void> continueAsGuest() async {
    _currentUser = UserModel.guestUser();
    _isLoggedIn = false;
    _isGuest = true;
    await _saveToPreferences();
    notifyListeners();
  }

  // Update Profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String bio,
    String? avatarUrl,
  }) async {
    _currentUser = _currentUser.copyWith(
      name: name.trim(),
      email: email.trim(),
      bio: bio.trim(),
      avatarUrl: avatarUrl,
    );
    await _saveToPreferences();
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _isLoggedIn = false;
    _isGuest = false;
    _currentUser = UserModel.defaultUser();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefIsLoggedInKey);
    await prefs.remove(_prefIsGuestKey);
    await prefs.remove(_prefUserKey);

    notifyListeners();
  }
}
