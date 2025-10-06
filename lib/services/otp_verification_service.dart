import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class OtpVerificationService {
  // Send OTP to user's email
  static Future<Map<String, dynamic>> sendOtp(String nrkId) async {
    try {
      final requestData = {"nrk_id_no": nrkId};

      print("Sending OTP request data: $requestData");
      
      // Check if this is the test Norka ID for Google Play Store
      if (nrkId == "M12345678") {
        print("Using dummy OTP API for test Norka ID: $nrkId");
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          'https://norkaapi.tqdemo.website/api/nrk-verification/verify-dummy/',
          data: requestData,
        );
        print("OTP sent response (dummy): ${response.data}");
        return response.data;
      } else {
        // Use original API for real Norka IDs
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          '$FamilyBaseURL/nrk-verification/verify/',
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
    required String nrkId,
    required String email,
    required String otp,
  }) async {
    try {
      print("Verifying OTP request data for NRK ID: $nrkId");
      
      // Check if this is the test Norka ID for Google Play Store
      if (nrkId == "M12345678") {
        print("Using dummy OTP verification API for test Norka ID: $nrkId");
        // Use nrk_id_no for dummy API
        final requestData = {"nrk_id_no": nrkId, "email": email, "otp": otp};
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          'https://norkaapi.tqdemo.website/api/nrk-verification/verify-otp-dummy/',
          data: requestData,
        );
        print("OTP verification response (dummy): ${response.data}");
        return response.data;
      } else {
        // Use original API for real Norka IDs
        final requestData = {"nrk_id": nrkId, "email": email, "otp": otp};
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          '$FamilyBaseURL/nrk-verification/verify-otp/',
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
    required String nrkId,
    required String email,
  }) async {
    try {
      print("Resending OTP request data for NRK ID: $nrkId");
      
      // Check if this is the test Norka ID for Google Play Store
      if (nrkId == "M12345678") {
        print("Using dummy OTP resend API for test Norka ID: $nrkId");
        // Use nrk_id_no for dummy API (same as send OTP)
        final requestData = {"nrk_id_no": nrkId};
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          'https://norkaapi.tqdemo.website/api/nrk-verification/verify-dummy/',
          data: requestData,
        );
        print("OTP resend response (dummy): ${response.data}");
        return response.data;
      } else {
        // Use original API for real Norka IDs
        final requestData = {"nrk_id": nrkId, "email": email};
        var dio = await DioHelper.getInstance();
        var response = await dio.post(
          '$FamilyBaseURL/nrk-verification/resend-otp/',
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
}
