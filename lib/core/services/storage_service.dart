import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  
  // Storage keys
  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _hasCompletedProfileKey = 'has_completed_profile';
  
  /// Initialize the shared preferences instance
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Get whether the user has completed the onboarding
  bool hasCompletedOnboarding() {
    return _prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }
  
  /// Set whether the user has completed the onboarding
  Future<void> setHasCompletedOnboarding(bool value) async {
    await _prefs.setBool(_hasCompletedOnboardingKey, value);
  }
  
  /// Get whether the user is authenticated
  bool isAuthenticated() {
    return _prefs.getBool(_isAuthenticatedKey) ?? false;
  }
  
  /// Set whether the user is authenticated
  Future<void> setIsAuthenticated(bool value) async {
    await _prefs.setBool(_isAuthenticatedKey, value);
  }
  
  /// Get whether the user has completed their profile
  bool hasCompletedProfile() {
    return _prefs.getBool(_hasCompletedProfileKey) ?? false;
  }
  
  /// Set whether the user has completed their profile
  Future<void> setHasCompletedProfile(bool value) async {
    await _prefs.setBool(_hasCompletedProfileKey, value);
  }
  
  /// Clear all authentication and profile data (for logout)
  Future<void> clearAuthData() async {
    await _prefs.setBool(_isAuthenticatedKey, false);
    await _prefs.setBool(_hasCompletedProfileKey, false);
  }
  
  /// Clear all app data (for complete reset)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
} 