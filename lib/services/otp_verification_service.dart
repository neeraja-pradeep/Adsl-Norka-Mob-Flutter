import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class OtpVerificationService {
  // Send OTP to user's email
  static Future<Map<String, dynamic>> sendOtp(String input) async {
    try {
      print("Sending OTP request for input: $input");
      
      // Check if this is the test Norka ID for Google Play Store
      if (input == "M12345678") {
        print("Using dummy OTP API for test Norka ID: $input");
        final requestData = {"nrk_id_no": input};
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          'https://norkaapi.tqdemo.website/api/nrk-verification/verify-dummy/',
          data: requestData,
        );
        print("OTP sent response (dummy): ${response.data}");
        return response.data;
      } else {
        // Use new API for real inputs
        Map<String, dynamic> requestData;
        
        // Determine request body based on input type
        if (_isValidEmail(input)) {
          requestData = {"email": input};
          print("Sending OTP to email: $input");
        } else if (_isValidPhone(input) && _isLikelyPhoneNumber(input)) {
          requestData = {"mobile": input};
          print("Sending OTP to mobile: $input");
        } else {
          // Assume it's a NORKA ID
          requestData = {"nrk_id_no": input};
          print("Sending OTP to NORKA ID: $input");
        }

        print("Sending OTP request data: $requestData");
        
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          '$FamilyBaseURL/nrk-otp/phone/verify/',
          data: requestData,
        );
        print("OTP sent response: ${response.data}");
        return response.data;
      }
    } catch (e) {
      print("Error sending OTP: $e");
      rethrow;
    }
  }

  // Verify OTP entered by user
  static Future<Map<String, dynamic>> verifyOtp({
    required String input,
    required String email,
    required String otp,
  }) async {
    try {
      print("Verifying OTP request data for input: $input");
      
      // Check if this is the test Norka ID for Google Play Store
      if (input == "M12345678") {
        print("Using dummy OTP verification API for test Norka ID: $input");
        // Use nrk_id_no for dummy API
        final requestData = {"nrk_id_no": input, "email": email, "otp": otp};
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          'https://norkaapi.tqdemo.website/api/nrk-verification/verify-otp-dummy/',
          data: requestData,
        );
        print("OTP verification response (dummy): ${response.data}");
        return response.data;
      } else {
        // Use new API for real inputs
        final requestData = {"email": email, "otp": otp};
        print("Verifying OTP with email: $email");
        
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          '$FamilyBaseURL/nrk-otp/otp/verify/',
          data: requestData,
        );
        print("OTP verification response: ${response.data}");
        return response.data;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      rethrow;
    }
  }

  // Resend OTP to user's email
  static Future<Map<String, dynamic>> resendOtp({
    required String input,
    required String email,
  }) async {
    try {
      print("Resending OTP request data for input: $input");
      
      // Check if this is the test Norka ID for Google Play Store
      if (input == "M12345678") {
        print("Using dummy OTP resend API for test Norka ID: $input");
        // Use nrk_id_no for dummy API (same as send OTP)
        final requestData = {"nrk_id_no": input};
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          'https://norkaapi.tqdemo.website/api/nrk-verification/verify-dummy/',
          data: requestData,
        );
        print("OTP resend response (dummy): ${response.data}");
        return response.data;
      } else {
        // Use new API for real inputs (same as send OTP)
        Map<String, dynamic> requestData;
        
        // Determine request body based on input type
        if (_isValidEmail(input)) {
          requestData = {"email": input};
          print("Resending OTP to email: $input");
        } else if (_isValidPhone(input) && _isLikelyPhoneNumber(input)) {
          requestData = {"mobile": input};
          print("Resending OTP to mobile: $input");
        } else {
          // Assume it's a NORKA ID
          requestData = {"nrk_id_no": input};
          print("Resending OTP to NORKA ID: $input");
        }

        print("Resending OTP request data: $requestData");
        
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          '$FamilyBaseURL/nrk-otp/phone/verify/',
          data: requestData,
        );
        print("OTP resend response: ${response.data}");
        return response.data;
      }
    } catch (e) {
      print("Error resending OTP: $e");
      rethrow;
    }
  }

  // Check payment status for a user
  static Future<Map<String, dynamic>> checkPaymentStatus(String nrkId) async {
    try {
      print("Checking payment status for NRK ID: $nrkId");
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/razorpay/payments/by-nrk-id/?nrk_id_no=$nrkId',
      );
      print("Payment status response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error checking payment status: $e");
      rethrow;
    }
  }

  // Check enrollment status for a user
  static Future<bool> checkEnrollmentStatus(String nrkId) async {
    try {
      print("Checking enrollment status for NRK ID: $nrkId");
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/enrollment/get-enrollment-numbers/?nrk_id_no=$nrkId',
      );
      
      print("Enrollment status response code: ${response.statusCode}");
      print("Enrollment status response: ${response.data}");
      
      // Check if response status code is 200 or 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Enrollment status check: SUCCESS (${response.statusCode})");
        return true;
      } else {
        print("Enrollment status check: FAILED (${response.statusCode})");
        return false;
      }
    } catch (e) {
      print("Error checking enrollment status: $e");
      return false;
    }
  }

  // Helper method to validate email format
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Helper method to validate phone format
  static bool _isValidPhone(String phone) {
    // Check if phone starts with + (country code included)
    if (phone.startsWith('+')) {
      // Remove + and check if remaining digits are valid
      String digitsOnly = phone.substring(1).replaceAll(RegExp(r'\D'), '');
      return digitsOnly.length >= 7 && digitsOnly.length <= 15;
    } else {
      // No country code, check if it's a valid local number
      String digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
      return digitsOnly.length >= 7 && digitsOnly.length <= 15;
    }
  }

  // Helper method to determine if input is likely a phone number vs NORKA ID
  static bool _isLikelyPhoneNumber(String input) {
    // If it starts with +, it's definitely a phone number
    if (input.startsWith('+')) {
      return true;
    }
    
    // If input contains letters, it's definitely not a phone number (likely NORKA ID)
    if (input.contains(RegExp(r'[a-zA-Z]'))) {
      return false;
    }
    
    // Remove any non-digit characters
    String digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    
    // If original input had non-digit characters (other than +), it's not a simple phone number
    if (digitsOnly.length != input.length && !input.startsWith('+')) {
      return false;
    }
    
    // Phone numbers are typically 10 digits (without country code)
    // Anything else is likely a NORKA ID
    if (digitsOnly.length == 10) {
      return true;
    }
    
    // Default to NOT a phone number (treat as NORKA ID)
    return false;
  }

  // Send OTP via WhatsApp (for phone number update)
  static Future<Map<String, dynamic>> sendWhatsAppOtp(String phoneNumber) async {
    try {
      print("Sending WhatsApp OTP to: $phoneNumber");
      
      // Format phone number - remove + if present, should be format: 918589960592
      String formattedPhone = phoneNumber.replaceAll('+', '');
      
      final requestData = {
        "mobile_no": formattedPhone,
        "validity_minutes": 5,
      };
      
      print("WhatsApp OTP request data: $requestData");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/nrk-otp/whatsapp/send-otp/',
        data: requestData,
      );
      
      print("WhatsApp OTP sent response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error sending WhatsApp OTP: $e");
      rethrow;
    }
  }

  // Verify WhatsApp OTP (for phone number update)
  static Future<Map<String, dynamic>> verifyWhatsAppOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      print("Verifying WhatsApp OTP for: $phoneNumber");
      
      // Format phone number - remove + if present, should be format: 918589960592
      String formattedPhone = phoneNumber.replaceAll('+', '');
      
      final requestData = {
        "mobile_no": formattedPhone,
        "otp": otp,
      };
      
      print("WhatsApp OTP verification request data: $requestData");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/nrk-otp/whatsapp/verify-otp/',
        data: requestData,
      );
      
      print("WhatsApp OTP verification response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error verifying WhatsApp OTP: $e");
      rethrow;
    }
  }
}
