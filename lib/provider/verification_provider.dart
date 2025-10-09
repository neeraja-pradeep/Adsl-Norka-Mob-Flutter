import 'package:norkacare_app/services/verification_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VerificationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _response;
  Map<String, dynamic>? _verificationResponse;
  Map<String, dynamic>? _unifiedApiResponse;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get response => _response;
  Map<String, dynamic>? get verificationResponse => _verificationResponse;
  Map<String, dynamic>? getUnifiedApiResponse() => _unifiedApiResponse;

  // Load unified API response from SharedPreferences
  Future<void> loadUnifiedApiResponseFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final responseJson = prefs.getString('unified_api_response');
      if (responseJson != null) {
        _unifiedApiResponse = jsonDecode(responseJson);
        debugPrint("Unified API response loaded from SharedPreferences");
        
        // Extract and set individual data pieces from the loaded response
        if (_unifiedApiResponse != null && _unifiedApiResponse!['success'] == true && _unifiedApiResponse!['user_details'] != null) {
          final userDetails = _unifiedApiResponse!['user_details'];
          
          // Extract family info
          if (userDetails['family_info'] != null) {
            _familyMembersDetails = userDetails['family_info'];
            _hasFamilyMembersLoadedOnce = true;
            debugPrint('Family info loaded from SharedPreferences');
          }
          
          // Extract enrollment info
          if (userDetails['enrollment_info'] != null) {
            _enrollmentDetails = userDetails['enrollment_info'];
            _hasEnrollmentDetailsLoadedOnce = true;
            debugPrint('Enrollment info loaded from SharedPreferences');
          }
          
          // Extract payment info
          if (userDetails['razorpay_payments'] != null) {
            _paymentHistory = {
              'payments': userDetails['razorpay_payments'],
              'total_payments_count': userDetails['total_payments_count'],
              'total_paid_amount': userDetails['total_paid_amount'],
              'last_payment_date': userDetails['last_payment_date'],
            };
            _hasPaymentHistoryLoadedOnce = true;
            debugPrint('Payment info loaded from SharedPreferences');
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading unified API response: $e");
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearData() {
    _response = null;
    _verificationResponse = null;
    _errorMessage = '';
    _familyMembersDetails = {};
    _isFamilyMembersDetailsLoading = true;
    _hasFamilyMembersLoadedOnce = false; // Reset this flag too
    _enrollmentDetails = {};
    _isEnrollmentDetailsLoading = true;
    _hasEnrollmentDetailsLoadedOnce = false; // Reset this flag too
    _requestIdDetails = {};
    _isRequestIdDetailsLoading = true;
    _paymentHistory = {};
    _isPaymentHistoryLoading = true;
    _hasPaymentHistoryLoadedOnce = false; // Reset this flag too
    _paymentVerification = {};
    _isPaymentVerificationLoading = false;
    _datesDetails = {};
    _isDatesDetailsLoading = true;
    _premiumAmount = {};
    _isPremiumAmountLoading = true;
    notifyListeners();
  }

  // Clear all stored data including SharedPreferences
  Future<void> clearAllData() async {
    clearData();
    await _clearStoredFamilyData();
    await _clearStoredEnrollmentData();
    await _clearStoredPaymentData();
    await _clearStoredDatesData();
    await _clearStoredUnifiedApiResponse();
    
    // Reset loading flags to ensure clean state
    _hasFamilyMembersLoadedOnce = false;
    _hasEnrollmentDetailsLoadedOnce = false;
    _hasPaymentHistoryLoadedOnce = false;
    
    debugPrint("✅ VerificationProvider: All data and flags cleared");
  }

  // Clear stored family data from SharedPreferences
  Future<void> _clearStoredFamilyData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('family_members_data');
      await prefs.remove('family_members_nrk_id');
      debugPrint("Stored family data cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing stored family data: $e");
    }
  }

  // Clear stored enrollment data from SharedPreferences
  Future<void> _clearStoredEnrollmentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('enrollment_details_data');
      await prefs.remove('enrollment_details_nrk_id');
      debugPrint("Stored enrollment data cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing stored enrollment data: $e");
    }
  }

  // Clear stored payment data from SharedPreferences
  Future<void> _clearStoredPaymentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('payment_history_data');
      await prefs.remove('payment_history_nrk_id');
      debugPrint("Stored payment data cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing stored payment data: $e");
    }
  }

  // Clear stored dates data from SharedPreferences
  Future<void> _clearStoredDatesData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('dates_details_data');
      await prefs.remove('dates_details_nrk_id');
      debugPrint("Stored dates data cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing stored dates data: $e");
    }
  }

  // Save unified API response to SharedPreferences
  Future<void> _saveUnifiedApiResponseToPrefs(Map<String, dynamic> response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final responseJson = jsonEncode(response);
      await prefs.setString('unified_api_response', responseJson);
      debugPrint("Unified API response saved to SharedPreferences");
    } catch (e) {
      debugPrint("Error saving unified API response: $e");
    }
  }

  // Clear stored unified API response from SharedPreferences
  Future<void> _clearStoredUnifiedApiResponse() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('unified_api_response');
      debugPrint("Stored unified API response cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing stored unified API response: $e");
    }
  }

  // Update primary email
  Future<Map<String, dynamic>> updatePrimaryEmail(String nrkId, String primaryEmail) async {
    try {
      debugPrint('=== UPDATE PRIMARY EMAIL ===');
      debugPrint('NRK ID: $nrkId');
      debugPrint('Primary Email: $primaryEmail');
      
      final response = await VerificationService.updatePrimaryEmail(nrkId, primaryEmail);
      
      if (response['success'] == true) {
        // Update local data
        if (_unifiedApiResponse != null && _unifiedApiResponse!['user_details'] != null) {
          _unifiedApiResponse!['user_details']['nrk_user']['primary_email'] = primaryEmail;
          // Save updated response to SharedPreferences
          await _saveUnifiedApiResponseToPrefs(_unifiedApiResponse!);
        }
        debugPrint('Primary email updated successfully');
      }
      
      return response;
    } catch (e) {
      debugPrint("Error updating primary email: $e");
      return {'success': false, 'message': 'Failed to update primary email: $e'};
    }
  }

  // Update primary mobile
  Future<Map<String, dynamic>> updatePrimaryMobile(String nrkId, String primaryMobile) async {
    try {
      debugPrint('=== UPDATE PRIMARY MOBILE ===');
      debugPrint('NRK ID: $nrkId');
      debugPrint('Primary Mobile: $primaryMobile');
      
      final response = await VerificationService.updatePrimaryMobile(nrkId, primaryMobile);
      
      if (response['success'] == true) {
        // Update local data
        if (_unifiedApiResponse != null && _unifiedApiResponse!['user_details'] != null) {
          _unifiedApiResponse!['user_details']['nrk_user']['primary_mobile'] = primaryMobile;
          // Save updated response to SharedPreferences
          await _saveUnifiedApiResponseToPrefs(_unifiedApiResponse!);
        }
        debugPrint('Primary mobile updated successfully');
      }
      
      return response;
    } catch (e) {
      debugPrint("Error updating primary mobile: $e");
      return {'success': false, 'message': 'Failed to update primary mobile: $e'};
    }
  }

  // Update secondary email
  Future<Map<String, dynamic>> updateSecondaryEmail(String nrkId, String secondaryEmail) async {
    try {
      debugPrint('=== UPDATE SECONDARY EMAIL ===');
      debugPrint('NRK ID: $nrkId');
      debugPrint('Secondary Email: $secondaryEmail');
      
      final response = await VerificationService.updateSecondaryEmail(nrkId, secondaryEmail);
      
      if (response['success'] == true) {
        // Update local data
        if (_unifiedApiResponse != null && _unifiedApiResponse!['user_details'] != null) {
          _unifiedApiResponse!['user_details']['nrk_user']['secondary_email'] = secondaryEmail;
          // Save updated response to SharedPreferences
          await _saveUnifiedApiResponseToPrefs(_unifiedApiResponse!);
        }
        debugPrint('Secondary email updated successfully');
      }
      
      return response;
    } catch (e) {
      debugPrint("Error updating secondary email: $e");
      return {'success': false, 'message': 'Failed to update secondary email: $e'};
    }
  }

  // Update secondary mobile
  Future<Map<String, dynamic>> updateSecondaryMobile(String nrkId, String secondaryMobile) async {
    try {
      debugPrint('=== UPDATE SECONDARY MOBILE ===');
      debugPrint('NRK ID: $nrkId');
      debugPrint('Secondary Mobile: $secondaryMobile');
      
      final response = await VerificationService.updateSecondaryMobile(nrkId, secondaryMobile);
      
      if (response['success'] == true) {
        // Update local data
        if (_unifiedApiResponse != null && _unifiedApiResponse!['user_details'] != null) {
          _unifiedApiResponse!['user_details']['nrk_user']['secondary_mobile'] = secondaryMobile;
          // Save updated response to SharedPreferences
          await _saveUnifiedApiResponseToPrefs(_unifiedApiResponse!);
        }
        debugPrint('Secondary mobile updated successfully');
      }
      
      return response;
    } catch (e) {
      debugPrint("Error updating secondary mobile: $e");
      return {'success': false, 'message': 'Failed to update secondary mobile: $e'};
    }
  }

  // Save family details to SharedPreferences
  Future<void> saveFamilyDetailsToPrefs(
    Map<String, dynamic> familyData,
    String nrkId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('family_members_data', jsonEncode(familyData));
      await prefs.setString('family_members_nrk_id', nrkId);
      debugPrint("Family details saved to SharedPreferences for NRK ID: $nrkId");
    } catch (e) {
      debugPrint("Error saving family details to SharedPreferences: $e");
    }
  }

  // Retrieve family details from SharedPreferences
  Future<Map<String, dynamic>?> getFamilyDetailsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final familyDataString = prefs.getString('family_members_data');
      if (familyDataString != null && familyDataString.isNotEmpty) {
        final familyData = Map<String, dynamic>.from(
          jsonDecode(familyDataString),
        );
        debugPrint("Family details retrieved from SharedPreferences");
        return familyData;
      }
      return null;
    } catch (e) {
      debugPrint(
        "Error retrieving family details from SharedPreferences: $e",
      );
      return null;
    }
  }

  // Get stored NRK ID for family data
  Future<String> getStoredFamilyNrkId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('family_members_nrk_id') ?? '';
    } catch (e) {
      debugPrint("Error retrieving stored family NRK ID: $e");
      return '';
    }
  }

  // Save enrollment details to SharedPreferences
  Future<void> saveEnrollmentDetailsToPrefs(
    Map<String, dynamic> enrollmentData,
    String nrkId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('enrollment_details_data', jsonEncode(enrollmentData));
      await prefs.setString('enrollment_details_nrk_id', nrkId);
      debugPrint("Enrollment details saved to SharedPreferences for NRK ID: $nrkId");
    } catch (e) {
      debugPrint("Error saving enrollment details to SharedPreferences: $e");
    }
  }

  // Retrieve enrollment details from SharedPreferences
  Future<Map<String, dynamic>?> getEnrollmentDetailsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enrollmentDataString = prefs.getString('enrollment_details_data');
      if (enrollmentDataString != null && enrollmentDataString.isNotEmpty) {
        final enrollmentData = Map<String, dynamic>.from(
          jsonDecode(enrollmentDataString),
        );
        debugPrint("Enrollment details retrieved from SharedPreferences");
        return enrollmentData;
      }
      return null;
    } catch (e) {
      debugPrint(
        "Error retrieving enrollment details from SharedPreferences: $e",
      );
      return null;
    }
  }

  // Get stored NRK ID for enrollment data
  Future<String> getStoredEnrollmentNrkId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('enrollment_details_nrk_id') ?? '';
    } catch (e) {
      debugPrint("Error retrieving stored enrollment NRK ID: $e");
      return '';
    }
  }

  // Save payment history to SharedPreferences
  Future<void> savePaymentHistoryToPrefs(
    Map<String, dynamic> paymentData,
    String nrkId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('payment_history_data', jsonEncode(paymentData));
      await prefs.setString('payment_history_nrk_id', nrkId);
      debugPrint("Payment history saved to SharedPreferences for NRK ID: $nrkId");
    } catch (e) {
      debugPrint("Error saving payment history to SharedPreferences: $e");
    }
  }

  // Retrieve payment history from SharedPreferences
  Future<Map<String, dynamic>?> getPaymentHistoryFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentDataString = prefs.getString('payment_history_data');
      if (paymentDataString != null && paymentDataString.isNotEmpty) {
        final paymentData = Map<String, dynamic>.from(
          jsonDecode(paymentDataString),
        );
        debugPrint("Payment history retrieved from SharedPreferences");
        return paymentData;
      }
      return null;
    } catch (e) {
      debugPrint(
        "Error retrieving payment history from SharedPreferences: $e",
      );
      return null;
    }
  }

  // Get stored NRK ID for payment data
  Future<String> getStoredPaymentNrkId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('payment_history_nrk_id') ?? '';
    } catch (e) {
      debugPrint("Error retrieving stored payment NRK ID: $e");
      return '';
    }
  }

  // Save dates details to SharedPreferences
  Future<void> saveDatesDetailsToPrefs(
    Map<String, dynamic> datesData,
    String nrkId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dates_details_data', jsonEncode(datesData));
      await prefs.setString('dates_details_nrk_id', nrkId);
      debugPrint("Dates details saved to SharedPreferences for NRK ID: $nrkId");
    } catch (e) {
      debugPrint("Error saving dates details to SharedPreferences: $e");
    }
  }

  // Retrieve dates details from SharedPreferences
  Future<Map<String, dynamic>?> getDatesDetailsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final datesDataString = prefs.getString('dates_details_data');
      if (datesDataString != null && datesDataString.isNotEmpty) {
        final datesData = Map<String, dynamic>.from(
          jsonDecode(datesDataString),
        );
        debugPrint("Dates details retrieved from SharedPreferences");
        return datesData;
      }
      return null;
    } catch (e) {
      debugPrint(
        "Error retrieving dates details from SharedPreferences: $e",
      );
      return null;
    }
  }

  // Get stored NRK ID for dates data
  Future<String> getStoredDatesNrkId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('dates_details_nrk_id') ?? '';
    } catch (e) {
      debugPrint("Error retrieving stored dates NRK ID: $e");
      return '';
    }
  }

  void _handleError(DioException e) {
    _errorMessage =
        e.response?.data['message'] ?? 'An error occurred. Please try again.';
    if (e.response == null) {
      _errorMessage = 'Network error. Please check your internet connection.';
    }
    debugPrint("Dio Error: ${e.response}");
  }

  Future<void> AddFamilyMembers(Map<String, dynamic> data) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      final response = await VerificationService.AddFamilyMembers(data);
      _response = response;
      debugPrint(">>>>>>>$response");

      // Check if response contains success indicators
      if (response != null) {
        // Check for success indicators in the response data
        bool hasSuccessData =
            response.containsKey('data') &&
            response['data'] != null &&
            (response['data'].containsKey('sl_no') ||
                response['data'].containsKey('nrk_id_no') ||
                response['data'].containsKey('family_members_count'));

        // Check for success message
        bool hasSuccessMessage =
            response.containsKey('message') &&
            (response['message'].toString().toLowerCase().contains('success') ||
                response['message'].toString().toLowerCase().contains(
                  'created',
                ));

        if (hasSuccessData || hasSuccessMessage) {
          _errorMessage = '';
          debugPrint("✅ Success: API call successful, clearing error message");
        } else if (response.containsKey('message')) {
          _errorMessage = response['message'];
          debugPrint("⚠️ API returned message: ${response['message']}");
        } else {
          _errorMessage = '';
          debugPrint("✅ Success: No specific message, treating as success");
        }
      } else {
        _errorMessage = '';
        debugPrint("✅ Success: No response, treating as success");
      }
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Map<String, dynamic> _familyMembersDetails = {};
  bool _isFamilyMembersDetailsLoading = true;
  bool _hasFamilyMembersLoadedOnce = false;

  Map<String, dynamic> get familyMembersDetails => _familyMembersDetails;
  bool get isFamilyMembersDetailsLoading => _isFamilyMembersDetailsLoading;
  bool get hasFamilyMembersLoadedOnce => _hasFamilyMembersLoadedOnce;

  Future<void> getFamilyMembers(String nrkId) async {
    try {
      debugPrint('=== VERIFICATION PROVIDER: Getting family members ===');
      debugPrint('NRK ID: $nrkId');
      
      _isFamilyMembersDetailsLoading = true;
      notifyListeners();
      
      final response = await VerificationService.getFamilyMembers(nrkId);
      
      debugPrint('=== VERIFICATION PROVIDER: Family members response ===');
      debugPrint('Response: $response');
      debugPrint('Response Type: ${response.runtimeType}');
      debugPrint('Response is Map: ${response is Map}');
      if (response is Map) {
        debugPrint('Response Keys: ${response.keys.toList()}');
        debugPrint('Response isEmpty: ${response.isEmpty}');
      }
      debugPrint('=== END VERIFICATION PROVIDER RESPONSE ===');
      
      _familyMembersDetails = response ?? {};
      _hasFamilyMembersLoadedOnce = true;
      
      // Save family details to SharedPreferences for offline access
      if (_familyMembersDetails.isNotEmpty) {
        await saveFamilyDetailsToPrefs(_familyMembersDetails, nrkId);
      }
      
      debugPrint('Family members details set: $_familyMembersDetails');
    } catch (e) {
      debugPrint('=== VERIFICATION PROVIDER ERROR ===');
      debugPrint('Error fetching family members: $e');
      debugPrint('Error Type: ${e.runtimeType}');
      
      // Try to load from SharedPreferences when API fails
      await _loadFamilyDetailsFromPrefs(nrkId);
      
      // Handle 404 errors gracefully - no family data available yet
      if (e is DioException && e.response?.statusCode == 404) {
        debugPrint(
          'No family information found for NRK ID: $nrkId - this is normal for new users',
        );
        if (_familyMembersDetails.isEmpty) {
          _familyMembersDetails = {}; // Set empty data instead of showing error
        }
      } else {
        if (_familyMembersDetails.isEmpty) {
          _familyMembersDetails = {}; // Set empty data for other errors too
        }
      }
      debugPrint('=== END VERIFICATION PROVIDER ERROR ===');
    } finally {
      _isFamilyMembersDetailsLoading = false;
      notifyListeners();
    }
  }

  // Load family details from SharedPreferences when offline
  Future<void> _loadFamilyDetailsFromPrefs(String nrkId) async {
    try {
      final storedNrkId = await getStoredFamilyNrkId();
      if (storedNrkId == nrkId) {
        final storedFamilyData = await getFamilyDetailsFromPrefs();
        if (storedFamilyData != null && storedFamilyData.isNotEmpty) {
          _familyMembersDetails = storedFamilyData;
          _hasFamilyMembersLoadedOnce = true;
          debugPrint('Family details loaded from SharedPreferences for offline access');
        }
      }
    } catch (e) {
      debugPrint('Error loading family details from SharedPreferences: $e');
    }
  }

  // Method to load family details with offline fallback
  Future<void> getFamilyMembersWithOfflineFallback(String nrkId) async {
    try {
      // First try to get from API
      await getFamilyMembers(nrkId);
    } catch (e) {
      debugPrint('API call failed, trying to load from SharedPreferences: $e');
      // If API fails, try to load from SharedPreferences
      await _loadFamilyDetailsFromPrefs(nrkId);
      _isFamilyMembersDetailsLoading = false;
      _hasFamilyMembersLoadedOnce = true;
      notifyListeners();
    }
  }

  // Load enrollment details from SharedPreferences when offline
  Future<void> _loadEnrollmentDetailsFromPrefs(String nrkId) async {
    try {
      final storedNrkId = await getStoredEnrollmentNrkId();
      if (storedNrkId == nrkId) {
        final storedEnrollmentData = await getEnrollmentDetailsFromPrefs();
        if (storedEnrollmentData != null && storedEnrollmentData.isNotEmpty) {
          _enrollmentDetails = storedEnrollmentData;
          _hasEnrollmentDetailsLoadedOnce = true;
          debugPrint('Enrollment details loaded from SharedPreferences for offline access');
        }
      }
    } catch (e) {
      debugPrint('Error loading enrollment details from SharedPreferences: $e');
    }
  }

  // Method to load enrollment details with offline fallback
  Future<void> getEnrollmentDetailsWithOfflineFallback(String nrkId) async {
    try {
      // First try to get from API
      await getEnrollmentDetails(nrkId);
    } catch (e) {
      debugPrint('API call failed, trying to load from SharedPreferences: $e');
      // If API fails, try to load from SharedPreferences
      await _loadEnrollmentDetailsFromPrefs(nrkId);
      _isEnrollmentDetailsLoading = false;
      _hasEnrollmentDetailsLoadedOnce = true;
      notifyListeners();
    }
  }

  // Method to initialize family data from SharedPreferences on app start
  Future<void> initializeFamilyDataFromPrefs() async {
    try {
      final storedNrkId = await getStoredFamilyNrkId();
      if (storedNrkId.isNotEmpty) {
        final storedFamilyData = await getFamilyDetailsFromPrefs();
        if (storedFamilyData != null && storedFamilyData.isNotEmpty) {
          _familyMembersDetails = storedFamilyData;
          _hasFamilyMembersLoadedOnce = true;
          _isFamilyMembersDetailsLoading = false;
          debugPrint('Family data initialized from SharedPreferences on app start');
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error initializing family data from SharedPreferences: $e');
    }
  }

  // Method to initialize enrollment data from SharedPreferences on app start
  Future<void> initializeEnrollmentDataFromPrefs() async {
    try {
      final storedNrkId = await getStoredEnrollmentNrkId();
      if (storedNrkId.isNotEmpty) {
        final storedEnrollmentData = await getEnrollmentDetailsFromPrefs();
        if (storedEnrollmentData != null && storedEnrollmentData.isNotEmpty) {
          _enrollmentDetails = storedEnrollmentData;
          _hasEnrollmentDetailsLoadedOnce = true;
          _isEnrollmentDetailsLoading = false;
          debugPrint('Enrollment data initialized from SharedPreferences on app start');
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error initializing enrollment data from SharedPreferences: $e');
    }
  }

  // Load payment history from SharedPreferences when offline
  Future<void> _loadPaymentHistoryFromPrefs(String nrkId) async {
    try {
      final storedNrkId = await getStoredPaymentNrkId();
      if (storedNrkId == nrkId) {
        final storedPaymentData = await getPaymentHistoryFromPrefs();
        if (storedPaymentData != null && storedPaymentData.isNotEmpty) {
          _paymentHistory = storedPaymentData;
          _hasPaymentHistoryLoadedOnce = true;
          debugPrint('Payment history loaded from SharedPreferences for offline access');
        }
      }
    } catch (e) {
      debugPrint('Error loading payment history from SharedPreferences: $e');
    }
  }

  // Method to load payment history with offline fallback
  Future<void> getPaymentHistoryWithOfflineFallback(String nrkId) async {
    try {
      // First try to get from API
      await getPaymentHistory(nrkId);
    } catch (e) {
      debugPrint('API call failed, trying to load from SharedPreferences: $e');
      // If API fails, try to load from SharedPreferences
      await _loadPaymentHistoryFromPrefs(nrkId);
      _isPaymentHistoryLoading = false;
      _hasPaymentHistoryLoadedOnce = true;
      notifyListeners();
    }
  }

  // Method to initialize payment history from SharedPreferences on app start
  Future<void> initializePaymentHistoryFromPrefs() async {
    try {
      final storedNrkId = await getStoredPaymentNrkId();
      if (storedNrkId.isNotEmpty) {
        final storedPaymentData = await getPaymentHistoryFromPrefs();
        if (storedPaymentData != null && storedPaymentData.isNotEmpty) {
          _paymentHistory = storedPaymentData;
          _hasPaymentHistoryLoadedOnce = true;
          _isPaymentHistoryLoading = false;
          debugPrint('Payment history initialized from SharedPreferences on app start');
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error initializing payment history from SharedPreferences: $e');
    }
  }

  // Load dates details from SharedPreferences when offline
  Future<void> _loadDatesDetailsFromPrefs(String nrkId) async {
    try {
      final storedNrkId = await getStoredDatesNrkId();
      if (storedNrkId == nrkId) {
        final storedDatesData = await getDatesDetailsFromPrefs();
        if (storedDatesData != null && storedDatesData.isNotEmpty) {
          _datesDetails = storedDatesData;
          debugPrint('Dates details loaded from SharedPreferences for offline access');
        }
      }
    } catch (e) {
      debugPrint('Error loading dates details from SharedPreferences: $e');
    }
  }

  // Method to load dates details with offline fallback
  Future<void> getDatesDetailsWithOfflineFallback(String nrkId) async {
    try {
      // First try to get from API
      await getDatesDetails(nrkId);
    } catch (e) {
      debugPrint('API call failed, trying to load from SharedPreferences: $e');
      // If API fails, try to load from SharedPreferences
      await _loadDatesDetailsFromPrefs(nrkId);
      _isDatesDetailsLoading = false;
      notifyListeners();
    }
  }

  // Method to initialize dates details from SharedPreferences on app start
  Future<void> initializeDatesDetailsFromPrefs() async {
    try {
      final storedNrkId = await getStoredDatesNrkId();
      if (storedNrkId.isNotEmpty) {
        final storedDatesData = await getDatesDetailsFromPrefs();
        if (storedDatesData != null && storedDatesData.isNotEmpty) {
          _datesDetails = storedDatesData;
          _isDatesDetailsLoading = false;
          debugPrint('Dates details initialized from SharedPreferences on app start');
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error initializing dates details from SharedPreferences: $e');
    }
  }

  void clearFamilyMembersData() {
    _familyMembersDetails = {};
    _isFamilyMembersDetailsLoading = false; // Don't set loading to true when clearing
    notifyListeners();
  }

  void clearEnrollmentData() {
    _enrollmentDetails = {};
    _isEnrollmentDetailsLoading = true;
    notifyListeners();
  }

  Future<void> Enrolling(Map<String, dynamic> data) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      debugPrint("=== VERIFICATION PROVIDER - ENROLLING CALLED ===");
      debugPrint("Input Data: $data");
      
      final response = await VerificationService.Enrolling(data);
      _response = response;
      
      debugPrint("=== VERIFICATION PROVIDER - ENROLLING RESPONSE ===");
      debugPrint("Raw Response: $response");
      debugPrint("Response Type: ${response.runtimeType}");

      // Check if response contains success indicators
      if (response != null) {
        debugPrint("=== RESPONSE ANALYSIS ===");
        debugPrint("Response is not null");
        
        // Check for success indicators in the response
        bool hasSuccessData =
            response.containsKey('data') &&
            response['data'] != null &&
            response['data'].containsKey('self_enrollment_number');

        // Check for success message
        bool hasSuccessMessage =
            response.containsKey('message') &&
            (response['message'].toString().toLowerCase().contains('success') ||
                response['message'].toString().toLowerCase().contains(
                  'generated',
                ));

        debugPrint("Has Success Data: $hasSuccessData");
        debugPrint("Has Success Message: $hasSuccessMessage");
        debugPrint("Contains 'data' key: ${response.containsKey('data')}");
        debugPrint("Contains 'message' key: ${response.containsKey('message')}");
        
        if (response.containsKey('data') && response['data'] != null) {
          debugPrint("Data content: ${response['data']}");
          if (response['data'].containsKey('self_enrollment_number')) {
            debugPrint("Self enrollment number: ${response['data']['self_enrollment_number']}");
          }
        }
        
        if (response.containsKey('message')) {
          debugPrint("Message content: ${response['message']}");
        }

        if (hasSuccessData || hasSuccessMessage) {
          _errorMessage = '';
          debugPrint("✅ Success: API call successful, clearing error message");

          // Store enrollment details from the response
          if (response.containsKey('data') && response['data'] != null) {
            _enrollmentDetails = response;
            _isEnrollmentDetailsLoading = false;
            debugPrint("✅ Enrollment details stored from POST response");
            debugPrint("Stored enrollment details: $_enrollmentDetails");
          }
        } else if (response.containsKey('message')) {
          _errorMessage = response['message'];
          debugPrint("⚠️ API returned message: ${response['message']}");
        } else {
          _errorMessage = '';
          debugPrint("✅ Success: No specific message, treating as success");
        }
      } else {
        _errorMessage = '';
        debugPrint("✅ Success: No response, treating as success");
      }
      
      debugPrint("=== FINAL PROVIDER STATE ===");
      debugPrint("Error Message: $_errorMessage");
      debugPrint("Enrollment Details: $_enrollmentDetails");
      debugPrint("Is Loading: $_isLoading");
      debugPrint("=== END VERIFICATION PROVIDER - ENROLLING ===");
      
    } on DioException catch (e) {
      debugPrint("=== ENROLLING DIO EXCEPTION ===");
      debugPrint("DioException: $e");
      debugPrint("Status Code: ${e.response?.statusCode}");
      debugPrint("Response Data: ${e.response?.data}");
      _handleError(e);
    } catch (e) {
      debugPrint("=== ENROLLING GENERAL ERROR ===");
      debugPrint("General Error: $e");
      debugPrint("Error Type: ${e.runtimeType}");
      _errorMessage = "An unexpected error occurred.";
    } finally {
      _setLoading(false);
      debugPrint("=== ENROLLING FINALLY BLOCK ===");
      debugPrint("Loading set to false");
    }
  }

  Map<String, dynamic> _enrollmentDetails = {};
  bool _isEnrollmentDetailsLoading = true;
  bool _hasEnrollmentDetailsLoadedOnce = false;

  Map<String, dynamic> get enrollmentDetails => _enrollmentDetails;
  bool get isEnrollmentDetailsLoading => _isEnrollmentDetailsLoading;
  bool get hasEnrollmentDetailsLoadedOnce => _hasEnrollmentDetailsLoadedOnce;

  Future<void> getEnrollmentDetails(String nrkId) async {
    try {
      debugPrint("=== VERIFICATION PROVIDER - GET ENROLLMENT DETAILS CALLED ===");
      debugPrint("NRK ID: $nrkId");
      
      _isEnrollmentDetailsLoading = true;
      notifyListeners();
      
      final response = await VerificationService.getEnrollmentDetails(nrkId);
      
      debugPrint("=== VERIFICATION PROVIDER - GET ENROLLMENT DETAILS RESPONSE ===");
      debugPrint("Raw Response: $response");
      debugPrint("Response Type: ${response.runtimeType}");
      
      _enrollmentDetails = response ?? {};
      _hasEnrollmentDetailsLoadedOnce = true;
      
      // Save enrollment details to SharedPreferences for offline access
      if (_enrollmentDetails.isNotEmpty) {
        await saveEnrollmentDetailsToPrefs(_enrollmentDetails, nrkId);
      }
      
      debugPrint("=== ENROLLMENT DETAILS ANALYSIS ===");
      debugPrint("Stored Enrollment Details: $_enrollmentDetails");
      debugPrint("Has Data Key: ${_enrollmentDetails.containsKey('data')}");
      
      if (_enrollmentDetails.containsKey('data') && _enrollmentDetails['data'] != null) {
        final data = _enrollmentDetails['data'] as Map<String, dynamic>;
        debugPrint("Self Enrollment Number: ${data['self_enrollment_number']}");
        debugPrint("Spouse Enrollment Number: ${data['spouse_enrollment_number']}");
        debugPrint("Child1 Enrollment Number: ${data['child1_enrollment_number']}");
        debugPrint("Child2 Enrollment Number: ${data['child2_enrollment_number']}");
        debugPrint("Child3 Enrollment Number: ${data['child3_enrollment_number']}");
        debugPrint("Child4 Enrollment Number: ${data['child4_enrollment_number']}");
        debugPrint("Child5 Enrollment Number: ${data['child5_enrollment_number']}");
      }
      
      debugPrint("=== END VERIFICATION PROVIDER - GET ENROLLMENT DETAILS ===");
      
    } catch (e) {
      debugPrint('=== GET ENROLLMENT DETAILS ERROR ===');
      debugPrint('Error fetching enrollment details: $e');
      debugPrint('Error Type: ${e.runtimeType}');
      
      // Try to load from SharedPreferences when API fails
      await _loadEnrollmentDetailsFromPrefs(nrkId);
      
      // Handle 404 errors gracefully - no enrollment data available yet
      if (e is DioException && e.response?.statusCode == 404) {
        debugPrint(
          'No enrollment information found for NRK ID: $nrkId - this is normal for new users',
        );
        if (_enrollmentDetails.isEmpty) {
          _enrollmentDetails = {}; // Set empty data instead of showing error
        }
      } else if (e is DioException) {
        debugPrint('DioException Status Code: ${e.response?.statusCode}');
        debugPrint('DioException Response Data: ${e.response?.data}');
        if (_enrollmentDetails.isEmpty) {
          _enrollmentDetails = {}; // Set empty data for other errors too
        }
      }
      
      debugPrint('=== END GET ENROLLMENT DETAILS ERROR ===');
    } finally {
      _isEnrollmentDetailsLoading = false;
      notifyListeners();
      debugPrint("=== GET ENROLLMENT DETAILS FINALLY ===");
      debugPrint("Loading set to false");
    }
  }

  Future<void> vidalEnrollment(Map<String, dynamic> data) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      debugPrint("=== VIDAL ENROLLMENT API REQUEST ===");
      debugPrint("Request Data: $data");

      final response = await VerificationService.vidalEnrollment(data);
      _response = response;

      debugPrint("=== VIDAL ENROLLMENT API RESPONSE ===");
      debugPrint("Response: $response");
      debugPrint("=== END VIDAL API RESPONSE ===");

      // Check if response contains success indicators
      if (response != null) {
        // Check for success indicators in the response
        bool hasSuccessData =
            response.containsKey('data') &&
            response['data'] != null &&
            response['data'].containsKey('self_enrollment_number');

        // Check for success message
        bool hasSuccessMessage =
            response.containsKey('message') &&
            (response['message'].toString().toLowerCase().contains('success') ||
                response['message'].toString().toLowerCase().contains(
                  'generated',
                ));

        if (hasSuccessData || hasSuccessMessage) {
          _errorMessage = '';
          debugPrint("✅ Success: API call successful, clearing error message");
        } else if (response.containsKey('message')) {
          _errorMessage = response['message'];
          debugPrint("⚠️ API returned message: ${response['message']}");
        } else {
          _errorMessage = '';
          debugPrint("✅ Success: No specific message, treating as success");
        }
      } else {
        _errorMessage = '';
        debugPrint("✅ Success: No response, treating as success");
      }
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Map<String, dynamic> _requestIdDetails = {};
  bool _isRequestIdDetailsLoading = true;

  Map<String, dynamic> get requestIdDetails => _requestIdDetails;
  bool get isRequestIdDetailsLoading => _isRequestIdDetailsLoading;

  Future<void> getRequestIdDetails() async {
    try {
      _isRequestIdDetailsLoading = true;
      notifyListeners();
      final response = await VerificationService.generateRequestId();
      print('>>>>>>>>$response');
      _requestIdDetails = response ?? {};
    } catch (e) {
      debugPrint('Error fetching request id details: $e');
    } finally {
      _isRequestIdDetailsLoading = false;
      notifyListeners();
    }
  }

  Future<void> vidalEnrollmentValidate(Map<String, dynamic> data) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      debugPrint("=== VIDAL ENROLLMENT API REQUEST ===");
      debugPrint("Request Data: $data");

      final response = await VerificationService.vidalEnrollmentValidate(data);
      _response = response;

      debugPrint("=== VIDAL ENROLLMENT API RESPONSE ===");
      debugPrint("Response: $response");
      debugPrint("=== END VIDAL API RESPONSE ===");

      // Check if response contains success indicators
      if (response != null) {
        // First check if API explicitly returned success: false
        if (response.containsKey('success') && response['success'] == false) {
          _errorMessage =
              response['error']?['message'] ??
              response['message'] ??
              'Validation failed';
          debugPrint("❌ Vidal validation failed: $_errorMessage");
        }
        // Check for error field
        else if (response.containsKey('error')) {
          _errorMessage =
              response['error']?['message'] ??
              response['message'] ??
              'Validation failed';
          debugPrint("❌ Vidal validation failed: $_errorMessage");
        }
        // Check for success indicators in the response
        else {
          bool hasSuccessData =
              response.containsKey('data') &&
              response['data'] != null &&
              response['data'].containsKey('self_enrollment_number');

          // Check for success message
          bool hasSuccessMessage =
              response.containsKey('message') &&
              (response['message'].toString().toLowerCase().contains(
                    'success',
                  ) ||
                  response['message'].toString().toLowerCase().contains(
                    'generated',
                  ));

          if (hasSuccessData || hasSuccessMessage) {
            _errorMessage = '';
            debugPrint(
              "✅ Success: API call successful, clearing error message",
            );
          } else if (response.containsKey('message')) {
            _errorMessage = response['message'];
            debugPrint("⚠️ API returned message: ${response['message']}");
          } else {
            _errorMessage = '';
            debugPrint("✅ Success: No specific message, treating as success");
          }
        }
      } else {
        _errorMessage = '';
        debugPrint("✅ Success: No response, treating as success");
      }
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> vidalEnrollmentEcard(Map<String, dynamic> data) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      debugPrint("=== VIDAL E-CARD API REQUEST ===");
      debugPrint("Request Data: $data");

      final response = await VerificationService.vidalEnrollmentEcard(data);
      _response = response;

      debugPrint("=== VIDAL E-CARD API RESPONSE ===");
      debugPrint("Response: $response");
      debugPrint("=== END VIDAL E-CARD API RESPONSE ===");

      // Check if response contains success indicators
      if (response != null) {
        // Check for success status
        bool hasSuccessStatus =
            response.containsKey('status') && response['status'] == 'SUCCESS';

        // Check for e-card data
        bool hasEcardData =
            response.containsKey('data') &&
            response['data'] != null &&
            response['data'] is List &&
            (response['data'] as List).isNotEmpty;

        if (hasSuccessStatus && hasEcardData) {
          _errorMessage = '';
          debugPrint("✅ Success: E-Card API call successful");
        } else if (response.containsKey('message')) {
          _errorMessage = response['message'];
          debugPrint("⚠️ API returned message: ${response['message']}");
        } else {
          _errorMessage = "Failed to retrieve E-Card data";
          debugPrint("❌ No valid E-Card data found in response");
        }
      } else {
        _errorMessage = "No response received from server";
        debugPrint("❌ No response received");
      }
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Map<String, dynamic> _datesDetails = {};
  bool _isDatesDetailsLoading = true;

  Map<String, dynamic> get datesDetails => _datesDetails;
  bool get isDatesDetailsLoading => _isDatesDetailsLoading;

  Future<void> getDatesDetails(String nrkId) async {
    try {
      _isDatesDetailsLoading = true;
      notifyListeners();
      final response = await VerificationService.getDatesDetails(nrkId);
      print('>>>>>>>>$response');
      _datesDetails = response ?? {};
      
      // Save dates details to SharedPreferences for offline access
      if (_datesDetails.isNotEmpty) {
        await saveDatesDetailsToPrefs(_datesDetails, nrkId);
      }
    } catch (e) {
      debugPrint('Error fetching dates details: $e');
      
      // Try to load from SharedPreferences when API fails
      await _loadDatesDetailsFromPrefs(nrkId);
      
      // Handle 404 errors gracefully - no dates data available yet
      if (e is DioException && e.response?.statusCode == 404) {
        debugPrint(
          'No dates information found for NRK ID: $nrkId - this is normal for new users',
        );
        if (_datesDetails.isEmpty) {
          _datesDetails = {}; // Set empty data instead of showing error
        }
      } else {
        if (_datesDetails.isEmpty) {
          _datesDetails = {}; // Set empty data for other errors too
        }
      }
    } finally {
      _isDatesDetailsLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _premiumAmount = {};
  bool _isPremiumAmountLoading = true;

  Map<String, dynamic> get premiumAmount => _premiumAmount;
  bool get isPremiumAmountLoading => _isPremiumAmountLoading;

  Future<void> getPremiumAmount(String nrkId) async {
    try {
      _isPremiumAmountLoading = true;
      notifyListeners();
      final response = await VerificationService.getPremiumAmount(nrkId);
      print('>>>>>>>>$response');
      _premiumAmount = response ?? {};
    } catch (e) {
      debugPrint('Error fetching premium amount: $e');
      // Handle 404 errors gracefully - no premium data available yet
      if (e is DioException && e.response?.statusCode == 404) {
        debugPrint(
          'No premium information found for NRK ID: $nrkId - this is normal for new users',
        );
        _premiumAmount = {}; // Set empty data instead of showing error
      }
    } finally {
      _isPremiumAmountLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _paymentVerification = {};
  bool _isPaymentVerificationLoading = false;

  Map<String, dynamic> get paymentVerification => _paymentVerification;
  bool get isPaymentVerificationLoading => _isPaymentVerificationLoading;

  Future<void> verifyPayment(Map<String, dynamic> paymentData) async {
    try {
      debugPrint(
        '=== VERIFICATION PROVIDER: Starting payment verification ===',
      );
      debugPrint('Payment data: $paymentData');

      _isPaymentVerificationLoading = true;
      notifyListeners();

      final response = await VerificationService.verifyPayment(paymentData);

      debugPrint('=== VERIFICATION PROVIDER: Service response ===');
      debugPrint('Response: $response');
      debugPrint('=== END VERIFICATION PROVIDER ===');

      _paymentVerification = response ?? {};
    } catch (e) {
      debugPrint('=== VERIFICATION PROVIDER ERROR ===');
      debugPrint('Error verifying payment: $e');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('=== END VERIFICATION PROVIDER ERROR ===');
      _paymentVerification = {'error': e.toString()};
    } finally {
      _isPaymentVerificationLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerPaymentFailure(Map<String, dynamic> failureData) async {
    try {
      debugPrint(
        '=== VERIFICATION PROVIDER: Starting payment failure registration ===',
      );
      debugPrint('Failure data: $failureData');

      _isPaymentVerificationLoading = true;
      notifyListeners();

      final response = await VerificationService.registerPaymentFailure(
        failureData,
      );

      debugPrint(
        '=== VERIFICATION PROVIDER: Failure registration response ===',
      );
      debugPrint('Response: $response');
      debugPrint('=== END VERIFICATION PROVIDER ===');

      _paymentVerification = response ?? {};
    } catch (e) {
      debugPrint('=== VERIFICATION PROVIDER ERROR ===');
      debugPrint('Error registering payment failure: $e');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('=== END VERIFICATION PROVIDER ERROR ===');
      _paymentVerification = {'error': e.toString()};
    } finally {
      _isPaymentVerificationLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _paymentHistory = {};
  bool _isPaymentHistoryLoading = true;
  bool _hasPaymentHistoryLoadedOnce = false;

  Map<String, dynamic> get paymentHistory => _paymentHistory;
  bool get isPaymentHistoryLoading => _isPaymentHistoryLoading;
  bool get hasPaymentHistoryLoadedOnce => _hasPaymentHistoryLoadedOnce;

  Future<void> getPaymentHistory(String nrkId) async {
    try {
      debugPrint('=== PAYMENT HISTORY API REQUEST ===');
      debugPrint('NRK ID: $nrkId');
      _isPaymentHistoryLoading = true;
      notifyListeners();
      final response = await VerificationService.getPaymentHistory(nrkId);
      debugPrint('=== PAYMENT HISTORY API RESPONSE ===');
      debugPrint('Response: $response');
      _paymentHistory = response ?? {};
      _hasPaymentHistoryLoadedOnce = true;
      
      // Save payment history to SharedPreferences for offline access
      if (_paymentHistory.isNotEmpty) {
        await savePaymentHistoryToPrefs(_paymentHistory, nrkId);
      }
      
      debugPrint('=== PAYMENT HISTORY LOADED ONCE SET TO TRUE ===');
    } catch (e) {
      debugPrint('Error fetching payment history: $e');
      
      // Try to load from SharedPreferences when API fails
      await _loadPaymentHistoryFromPrefs(nrkId);
    } finally {
      _isPaymentHistoryLoading = false;
      debugPrint('=== PAYMENT HISTORY LOADING SET TO FALSE ===');
      notifyListeners();
    }
  }

  // New unified method for dashboard - gets all user data in one API call
  Future<void> getUserDetailsForDashboard(String nrkId) async {
    try {
      debugPrint('=== DASHBOARD: Getting unified user details ===');
      debugPrint('NRK ID: $nrkId');
      
      // Always make fresh API call to ensure we have current user's data
      // This prevents showing previous user's data after logout/login
      // Also ensures fresh data after payments or other updates
      debugPrint('=== DASHBOARD: Making fresh API call for current user ===');
      
      _isFamilyMembersDetailsLoading = true;
      _isEnrollmentDetailsLoading = true;
      _isPaymentHistoryLoading = true;
      notifyListeners();
      
      final response = await VerificationService.getUserDetails(nrkId);
      
      // Store the unified API response for access by other components
      _unifiedApiResponse = response;
      
      // Persist the unified API response to SharedPreferences
      await _saveUnifiedApiResponseToPrefs(response);
      
      debugPrint('=== DASHBOARD: Unified user details response ===');
      debugPrint('Response: $response');
      
      if (response['success'] == true && response['user_details'] != null) {
        final userDetails = response['user_details'];
        
        // Extract family info
        if (userDetails['family_info'] != null) {
          _familyMembersDetails = userDetails['family_info'];
          _hasFamilyMembersLoadedOnce = true;
          debugPrint('Family info extracted: $_familyMembersDetails');
        }
        
        // Extract enrollment info
        if (userDetails['enrollment_info'] != null) {
          _enrollmentDetails = userDetails['enrollment_info'];
          _hasEnrollmentDetailsLoadedOnce = true;
          debugPrint('Enrollment info extracted: $_enrollmentDetails');
        }
        
        // Extract payment info
        if (userDetails['razorpay_payments'] != null) {
          _paymentHistory = {
            'payments': userDetails['razorpay_payments'],
            'total_payments_count': userDetails['total_payments_count'],
            'total_paid_amount': userDetails['total_paid_amount'],
            'last_payment_date': userDetails['last_payment_date'],
          };
          _hasPaymentHistoryLoadedOnce = true;
          debugPrint('Payment info extracted: $_paymentHistory');
        }
        
        _errorMessage = '';
        debugPrint('=== DASHBOARD: All data extracted successfully ===');
      } else {
        _errorMessage = response['message'] ?? 'Failed to get user details';
        debugPrint('Error in unified API response: $_errorMessage');
      }
    } catch (e) {
      _errorMessage = "Failed to get user details: $e";
      debugPrint("Error getting unified user details: $e");
      
      // Try to load cached data from SharedPreferences when API fails
      debugPrint("=== DASHBOARD: API failed, trying to load cached data ===");
      await loadUnifiedApiResponseFromPrefs();
      
      if (_unifiedApiResponse != null) {
        debugPrint("=== DASHBOARD: Successfully loaded cached data ===");
        _errorMessage = ''; // Clear error message since we have cached data
      } else {
        debugPrint("=== DASHBOARD: No cached data available ===");
      }
    } finally {
      _isFamilyMembersDetailsLoading = false;
      _isEnrollmentDetailsLoading = false;
      _isPaymentHistoryLoading = false;
      notifyListeners();
    }
  }
}
