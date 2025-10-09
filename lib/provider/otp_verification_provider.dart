import 'package:norkacare_app/services/otp_verification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OtpVerificationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _otpResponse;
  Map<String, dynamic>? _verificationResponse;
  Map<String, dynamic>? _norkaUserDetails;
  String _email = '';
  String _nrkId = '';
  String _otpExpiresAt = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get otpResponse => _otpResponse;
  Map<String, dynamic>? get verificationResponse => _verificationResponse;
  Map<String, dynamic>? get norkaUserDetails => _norkaUserDetails;
  String get email => _email;
  String get nrkId => _nrkId;
  String get otpExpiresAt => _otpExpiresAt;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearData() {
    _otpResponse = null;
    _verificationResponse = null;
    _norkaUserDetails = null;
    _errorMessage = '';
    _email = '';
    _nrkId = '';
    _otpExpiresAt = '';
    notifyListeners();
  }

  // Save NORKA ID to SharedPreferences
  Future<void> _saveNorkaIdToPrefs(String norkaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('norka_id', norkaId);
      debugPrint(
        "NORKA ID saved to SharedPreferences from OTP verification: $norkaId",
      );
    } catch (e) {
      debugPrint("Error saving NORKA ID to SharedPreferences: $e");
    }
  }

  // Save NORKA response data to SharedPreferences for NORKA provider to use
  Future<void> _saveNorkaResponseDataToPrefs(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('norka_response_data', jsonEncode(userData));
      debugPrint("NORKA response data saved to SharedPreferences");
    } catch (e) {
      debugPrint("Error saving NORKA response data to SharedPreferences: $e");
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

  // Send OTP to user's email
  Future<bool> sendOtp(String input) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      final response = await OtpVerificationService.sendOtp(input);
      _otpResponse = response;

      if (response['success'] == true) {
        // Extract email from new API response structure
        if (response['email_address'] != null) {
          _email = response['email_address'];
        } else if (response['data'] != null && response['data']['verification'] != null) {
          // Fallback to old structure for dummy API
          _email = response['data']['verification']['primary_email'] ?? '';
        } else {
          _email = '';
        }
        
        // Extract NRK ID from response if available, otherwise use input
        if (response['nrk_id'] != null) {
          _nrkId = response['nrk_id'];
        } else {
          _nrkId = input; // Fallback to input if no nrk_id in response
        }
        
        _otpExpiresAt = response['data']?['expires_at'] ?? '';
        _errorMessage = '';
        debugPrint("=== SEND OTP DEBUG ===");
        debugPrint("Input: $input");
        debugPrint("Response: $response");
        debugPrint("Extracted email: $_email");
        debugPrint("Extracted NRK ID: $_nrkId");
        debugPrint("======================");
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to send OTP';
        return false;
      }
    } on DioException catch (e) {
      _handleError(e);
      return false;
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP entered by user
  Future<bool> verifyOtp(String otp) async {
    if (_nrkId.isEmpty || _email.isEmpty) {
      _errorMessage = 'Missing required data for OTP verification';
      debugPrint("Missing data - NRK ID: $_nrkId, Email: $_email");
      return false;
    }

    _setLoading(true);
    _errorMessage = '';
    try {
      debugPrint("=== VERIFY OTP DEBUG ===");
      debugPrint("Using NRK ID: $_nrkId");
      debugPrint("Using Email: $_email");
      debugPrint("OTP: $otp");
      debugPrint("========================");
      
      final response = await OtpVerificationService.verifyOtp(
        input: _nrkId,
        email: _email,
        otp: otp,
      );
      _verificationResponse = response;

      if (response['success'] == true && response['verified'] == true) {
        _errorMessage = '';

        // Extract NRK ID from verification response if available
        if (response['user_data'] != null && response['user_data']['norka_id'] != null) {
          _nrkId = response['user_data']['norka_id'];
        }

        // Save NRK ID to SharedPreferences for profile access
        await _saveNorkaIdToPrefs(_nrkId);

        // Store user data from verification response
        if (response['user_data'] != null) {
          _norkaUserDetails = response['user_data'];
          debugPrint("User details from OTP verification: $_norkaUserDetails");
          
          // Also save to SharedPreferences for NORKA provider to use
          await _saveNorkaResponseDataToPrefs(response['user_data']);
        } else {
          debugPrint("No user_data found in OTP verification response");
          _errorMessage = 'User data not found in verification response';
          return false;
        }

        debugPrint("OTP verified successfully");
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Invalid OTP';
        return false;
      }
    } on DioException catch (e) {
      _handleError(e);
      return false;
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Resend OTP to user's email
  Future<bool> resendOtp() async {
    if (_nrkId.isEmpty || _email.isEmpty) {
      _errorMessage = 'Missing required data for OTP resend';
      return false;
    }

    _setLoading(true);
    _errorMessage = '';
    try {
      final response = await OtpVerificationService.resendOtp(
        input: _nrkId,
        email: _email,
      );

      if (response['success'] == true) {
        _errorMessage = '';
        debugPrint("OTP resent successfully to: $_email");
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to resend OTP';
        return false;
      }
    } on DioException catch (e) {
      _handleError(e);
      return false;
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check if user has completed payment
  Future<bool> checkPaymentStatus(String nrkId) async {
    try {
      debugPrint("Checking payment status for NRK ID: $nrkId");

      // Import the verification service to check payment history
      final response = await OtpVerificationService.checkPaymentStatus(nrkId);

      debugPrint("Payment status API response: $response");

      // Check if response has payment data
      // Check if there are any payments in the response
      if (response['data'] != null && response['data'] is List) {
        final payments = response['data'] as List;

        // bool hasPayment = payments.isNotEmpty;
        //           debugPrint(
        //             "Payment status check result: $hasPayment (found ${payments.length} payments)",
        //           );
        //           return hasPayment;
        if (payments.isNotEmpty) {
          // Check if any payment has captured status
          for (int i = 0; i < payments.length; i++) {
            final payment = payments[i];
            if (payment['rzp_payload'] != null &&
                payment['rzp_payload']['status'] == 'captured') {
              debugPrint(
                "Payment status check result: true (payment $i captured - status: ${payment['rzp_payload']['status']})",
              );
              return true;
            }
          }

          // If no captured payment found
          debugPrint(
            "Payment status check result: false (no captured payments found in ${payments.length} payments)",
          );
          return false;
        } else {
          debugPrint(
            "Payment status check result: false (no payments found)",
          );
          return false;
        }
      }

      // Alternative check for different response structure
      if (response['count'] != null && response['count'] > 0) {
        debugPrint(
          "Payment status check result: true (count: ${response['count']})",
        );
        return true;
      }

      debugPrint("No payment data found");
      return false;
    } catch (e) {
      debugPrint("Error checking payment status: $e");
      return false;
    }
  }

  // Check if user has enrollment numbers
  Future<bool> checkEnrollmentStatus(String nrkId) async {
    try {
      debugPrint("Checking enrollment status for NRK ID: $nrkId");

      // Call the service to check enrollment status (returns true if status code is 200/201)
      final hasEnrollment = await OtpVerificationService.checkEnrollmentStatus(nrkId);

      debugPrint("Enrollment status check result: $hasEnrollment");
      return hasEnrollment;
    } catch (e) {
      debugPrint("Error checking enrollment status: $e");
      return false;
    }
  }

  // Get verified customer data from Norka API
  Map<String, dynamic>? getVerifiedCustomerData() {
    // Return Norka user details if available
    if (_norkaUserDetails != null) {
      return _norkaUserDetails;
    }
    
    // Fallback to old verification response structure if Norka data is not available
    if (_verificationResponse != null &&
        _verificationResponse!['data'] != null &&
        _verificationResponse!['data']['verification'] != null) {
      return _verificationResponse!['data']['verification'];
    }
    return null;
  }
}
