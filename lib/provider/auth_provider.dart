import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/shimmer_manager.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isFirstTime = true;
  String _userNorkaId = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isFirstTime => _isFirstTime;
  String get userNorkaId => _userNorkaId;

  // Initialize authentication state from SharedPreferences
  Future<void> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _isFirstTime = prefs.getBool('is_first_time') ?? true;
    _userNorkaId = prefs.getString('user_norka_id') ?? '';

    notifyListeners();
  }

  // Login user
  Future<void> login(String norkaId) async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = true;
    _isFirstTime = false;
    _userNorkaId = norkaId;

    // Save to SharedPreferences
    await prefs.setBool('is_logged_in', true);
    await prefs.setBool('is_first_time', false);
    await prefs.setString('user_norka_id', norkaId);

    notifyListeners();
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = false;
    _userNorkaId = '';

    // Clear login state from SharedPreferences
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('user_norka_id');

    // Clear other user data
    await prefs.remove('norka_id');
    await prefs.remove('norka_response_data');
    await prefs.remove('has_shown_homepage_shimmer');
    await prefs.remove('has_shown_policies_shimmer');
    await prefs.remove('has_shown_documents_shimmer');
    await prefs.remove('has_shown_claims_shimmer');
    
    // Clear cached profile picture URL
    await prefs.remove('profile_picture_url');
    
    // Clear cached claims data
    await prefs.remove('cached_claims_data');
    await prefs.remove('cached_dependents');
    await prefs.remove('cached_claims');
    
    // Clear any additional verification/family related data
    await prefs.remove('verification_data');
    await prefs.remove('family_data');
    await prefs.remove('family_members_data');
    await prefs.remove('family_members_nrk_id');
    await prefs.remove('enrollment_data');
    await prefs.remove('enrollment_details_data');
    await prefs.remove('enrollment_details_nrk_id');
    await prefs.remove('payment_data');
    await prefs.remove('payment_history_data');
    await prefs.remove('payment_history_nrk_id');
    await prefs.remove('dates_details_data');
    await prefs.remove('dates_details_nrk_id');
    await prefs.remove('user_verification_data');
    await prefs.remove('otp_verification_data');
    await prefs.remove('unified_api_response');

    // Reset shimmer manager
    ShimmerManager.resetShimmerState();

    notifyListeners();
  }

  // Check if user should see onboarding
  bool shouldShowOnboarding() {
    return _isFirstTime && !_isLoggedIn;
  }

  // Mark onboarding as completed
  Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    _isFirstTime = false;
    await prefs.setBool('is_first_time', false);

    notifyListeners();
  }

  // Reset everything (for testing purposes)
  Future<void> resetAuth() async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = false;
    _isFirstTime = true;
    _userNorkaId = '';

    // Clear all auth-related data
    await prefs.remove('is_logged_in');
    await prefs.remove('is_first_time');
    await prefs.remove('user_norka_id');
    await prefs.remove('norka_id');
    await prefs.remove('norka_response_data');
    await prefs.remove('has_shown_homepage_shimmer');
    await prefs.remove('has_shown_policies_shimmer');
    await prefs.remove('has_shown_documents_shimmer');
    await prefs.remove('has_shown_claims_shimmer');
    
    // Clear cached claims data
    await prefs.remove('cached_claims_data');
    await prefs.remove('cached_dependents');
    await prefs.remove('cached_claims');

    notifyListeners();
  }
}
