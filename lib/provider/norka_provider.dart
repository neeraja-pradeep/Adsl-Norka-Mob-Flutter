import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NorkaProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _response;
  Map<String, dynamic>? _verificationResponse;
  String _norkaId = '';
  bool _hasUserDataLoadedOnce = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get response => _response;
  Map<String, dynamic>? get verificationResponse => _verificationResponse;
  String get norkaId => _norkaId;
  bool get hasUserDataLoadedOnce => _hasUserDataLoadedOnce;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearData() {
    _response = null;
    _verificationResponse = null;
    _errorMessage = '';
    _norkaId = '';
    _hasUserDataLoadedOnce = false;
    notifyListeners();
  }

  // Clear all stored data including SharedPreferences
  Future<void> clearAllData() async {
    clearData();
    await clearNorkaIdFromPrefs();
    await _clearStoredResponseData();
  }

  // Clear stored response data from SharedPreferences
  Future<void> _clearStoredResponseData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('norka_response_data');
      debugPrint("Stored response data cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing stored response data: $e");
    }
  }

  // Save NORKA ID to SharedPreferences
  Future<void> saveNorkaIdToPrefs(String norkaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('norka_id', norkaId);
      debugPrint("NORKA ID saved to SharedPreferences: $norkaId");
    } catch (e) {
      debugPrint("Error saving NORKA ID to SharedPreferences: $e");
    }
  }

  // Retrieve NORKA ID from SharedPreferences
  Future<String> getNorkaIdFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final norkaId = prefs.getString('norka_id') ?? '';
      debugPrint("NORKA ID retrieved from SharedPreferences: $norkaId");
      return norkaId;
    } catch (e) {
      debugPrint("Error retrieving NORKA ID from SharedPreferences: $e");
      return '';
    }
  }

  // Clear NORKA ID from SharedPreferences
  Future<void> clearNorkaIdFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('norka_id');
      await prefs.remove('norka_response_data');
      debugPrint("NORKA ID and response data cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing NORKA data from SharedPreferences: $e");
    }
  }

  // Save full NORKA response data to SharedPreferences
  Future<void> saveResponseDataToPrefs(
    Map<String, dynamic> responseData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('norka_response_data', jsonEncode(responseData));
      debugPrint("NORKA response data saved to SharedPreferences");
    } catch (e) {
      debugPrint("Error saving NORKA response data to SharedPreferences: $e");
    }
  }

  // Retrieve full NORKA response data from SharedPreferences
  Future<Map<String, dynamic>?> getResponseDataFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final responseDataString = prefs.getString('norka_response_data');
      if (responseDataString != null && responseDataString.isNotEmpty) {
        final responseData = Map<String, dynamic>.from(
          jsonDecode(responseDataString),
        );
        debugPrint("NORKA response data retrieved from SharedPreferences");
        return responseData;
      }
      return null;
    } catch (e) {
      debugPrint(
        "Error retrieving NORKA response data from SharedPreferences: $e",
      );
      return null;
    }
  }


  // Method to set response data from OTP verification (replaces API call)
  void setResponseDataFromOtpVerification(Map<String, dynamic> userData, String norkaId) {
    _response = userData;
    _norkaId = norkaId;
    _hasUserDataLoadedOnce = true;
    _errorMessage = '';
    
    // Save to SharedPreferences for persistence
    saveNorkaIdToPrefs(_norkaId);
    saveResponseDataToPrefs(userData);
    
    debugPrint("NORKA response data set from OTP verification: $_response");
    notifyListeners();
  }

  Future<void> getpravasidata(String norkaId) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      // Try to get stored response data first
      final storedResponse = await getResponseDataFromPrefs();
      if (storedResponse != null) {
        _response = storedResponse;
        _norkaId = norkaId;
        _hasUserDataLoadedOnce = true;
        _errorMessage = '';
        debugPrint("Using stored NORKA response data: $_response");
      } else {
        _errorMessage = 'No user data available. Please complete OTP verification first.';
        debugPrint("No stored NORKA response data found");
      }
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Method to refresh user data by calling API with stored NORKA ID
  Future<void> refreshUserData() async {
    final storedNorkaId = await getNorkaIdFromPrefs();
    if (storedNorkaId.isNotEmpty) {
      await getpravasidata(storedNorkaId);
    } else {
      debugPrint("No stored NORKA ID found for refresh");
    }
  }

  // Method to load user data only if not loaded before (similar to family members pattern)
  Future<void> loadUserDataIfNeeded() async {
    if (!_hasUserDataLoadedOnce) {
      final storedNorkaId = await getNorkaIdFromPrefs();
      if (storedNorkaId.isNotEmpty) {
        await getpravasidata(storedNorkaId);
      } else {
        debugPrint("No stored NORKA ID found for loading user data");
      }
    }
  }

  // Method to initialize NORKA ID from SharedPreferences on app start
  Future<void> initializeFromPrefs() async {
    final storedNorkaId = await getNorkaIdFromPrefs();
    if (storedNorkaId.isNotEmpty) {
      _norkaId = storedNorkaId;
      debugPrint("NORKA ID initialized from SharedPreferences: $_norkaId");

      // Also try to load the stored response data if available
      await _loadStoredResponseData();
    }
  }

  // Method to load stored response data from SharedPreferences
  Future<void> _loadStoredResponseData() async {
    try {
      final storedResponse = await getResponseDataFromPrefs();
      if (storedResponse != null) {
        _response = storedResponse;
        _hasUserDataLoadedOnce = true;
        debugPrint("Stored response data loaded from SharedPreferences");
      }
    } catch (e) {
      debugPrint("Error loading stored response data: $e");
    }
  }
}
