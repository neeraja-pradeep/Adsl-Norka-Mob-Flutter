import 'package:norkacare_app/services/otp_verification_service.dart';
import 'package:norkacare_app/services/norka_service.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _handleError(DioException e) {
    _errorMessage =
        e.response?.data['message'] ?? 'An error occurred. Please try again.';
    if (e.response == null) {
      _errorMessage = 'Network error. Please check your internet connection.';
    }
    debugPrint("Dio Error: ${e.response}");
  }

  // Send OTP to user's email
  Future<bool> sendOtp(String nrkId) async {
    _setLoading(true);
    _errorMessage = '';
    try {
      final response = await OtpVerificationService.sendOtp(nrkId);
      _otpResponse = response;

      if (response['success'] == true && response['data'] != null) {
        _nrkId = nrkId;
        _email = response['data']['verification']['primary_email'] ?? '';
        _otpExpiresAt = response['data']['expires_at'] ?? '';
        _errorMessage = '';
        debugPrint("OTP sent successfully to: $_email");
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
      return false;
    }

    _setLoading(true);
    _errorMessage = '';
    try {
      final response = await OtpVerificationService.verifyOtp(
        nrkId: _nrkId,
        email: _email,
        otp: otp,
      );
      _verificationResponse = response;

      if (response['success'] == true) {
        _errorMessage = '';

        // Save NRK ID to SharedPreferences for profile access
        await _saveNorkaIdToPrefs(_nrkId);

        // Fetch user details from Norka API after successful OTP verification
        try {
          debugPrint("Fetching user details from Norka API for NRK ID: $_nrkId");
          final norkaResponse = await NorkaService.getpravasidata(_nrkId);
          _norkaUserDetails = norkaResponse;
          debugPrint("Norka user details fetched successfully: $norkaResponse");
        } catch (e) {
          debugPrint("Error fetching Norka user details: $e");
          // Don't fail the OTP verification if Norka API fails
          // The user can still proceed, but without pre-filled data
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
        nrkId: _nrkId,
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
