import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class OtpVerificationService {
  // Send OTP to user's email
  static Future<Map<String, dynamic>> sendOtp(String nrkId) async {
    try {
      final requestData = {"nrk_id_no": nrkId};

      print("Sending OTP request data: $requestData");
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/nrk-verification/verify/',
        data: requestData,
      );
      print("OTP sent response: ${response.data}");
      return response.data;
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
      final requestData = {"nrk_id": nrkId, "email": email, "otp": otp};

      print("Verifying OTP request data: $requestData");
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/nrk-verification/verify-otp/',
        data: requestData,
      );
      print("OTP verification response: ${response.data}");
      return response.data;
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
      final requestData = {"nrk_id": nrkId, "email": email};

      print("Resending OTP request data: $requestData");
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/nrk-verification/resend-otp/',
        data: requestData,
      );
      print("OTP resend response: ${response.data}");
      return response.data;
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
