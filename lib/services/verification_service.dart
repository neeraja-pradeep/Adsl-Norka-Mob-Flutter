import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';
import 'package:dio/dio.dart';

class VerificationService {
  static Future AddFamilyMembers(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/family-info/create/',
        data: data,
      );
      print("user logged in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getFamilyMembers(String nrkId) async {
    try {
      print("=== GET FAMILY MEMBERS DEBUG ===");
      print("NRK ID: $nrkId");
      print("API URL: $FamilyBaseURL/family-info/by-nrk-id/?nrk_id_no=$nrkId");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/family-info/by-nrk-id/?nrk_id_no=$nrkId',
      );
      
      print("=== FAMILY MEMBERS API RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
      print("Response Data Type: ${response.data.runtimeType}");
      print("=== END FAMILY MEMBERS API RESPONSE ===");
      
      return response.data;
    } catch (e) {
      print("=== GET FAMILY MEMBERS ERROR ===");
      print("Error: $e");
      print("Error Type: ${e.runtimeType}");
      if (e is DioException) {
        print("DioException Status Code: ${e.response?.statusCode}");
        print("DioException Response Data: ${e.response?.data}");
      }
      print("=== END GET FAMILY MEMBERS ERROR ===");
      rethrow;
    }
  }

  static Future Enrolling(data) async {
    try {
      print("=== CREATE ENROLLMENT API REQUEST ===");
      print("API URL: $FamilyBaseURL/enrollment/create-enrollment-numbers/");
      print("Request Data: $data");
      print("Request Data Type: ${data.runtimeType}");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/enrollment/create-enrollment-numbers/',
        data: data,
      );
      
      print("=== CREATE ENROLLMENT API RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Data: ${response.data}");
      print("Response Data Type: ${response.data.runtimeType}");
      
      // Log specific enrollment fields if available
      if (response.data != null && response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        print("=== ENROLLMENT RESPONSE DETAILS ===");
        print("Success: ${responseData['success']}");
        print("Message: ${responseData['message']}");
        print("Data: ${responseData['data']}");
        
        if (responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;
          print("Self Enrollment Number: ${data['self_enrollment_number']}");
          print("Spouse Enrollment Number: ${data['spouse_enrollment_number']}");
          print("Child1 Enrollment Number: ${data['child1_enrollment_number']}");
          print("Child2 Enrollment Number: ${data['child2_enrollment_number']}");
          print("Child3 Enrollment Number: ${data['child3_enrollment_number']}");
          print("Child4 Enrollment Number: ${data['child4_enrollment_number']}");
          print("Child5 Enrollment Number: ${data['child5_enrollment_number']}");
        }
        print("=== END ENROLLMENT RESPONSE DETAILS ===");
      }
      
      print("=== END CREATE ENROLLMENT API RESPONSE ===");
      return response.data;
    } catch (e) {
      print("=== CREATE ENROLLMENT API ERROR ===");
      print("Error: $e");
      print("Error Type: ${e.runtimeType}");
      if (e is DioException) {
        print("DioException Status Code: ${e.response?.statusCode}");
        print("DioException Response Data: ${e.response?.data}");
        print("DioException Request Data: ${e.requestOptions.data}");
      }
      print("=== END CREATE ENROLLMENT API ERROR ===");
      rethrow;
    }
  }

  static Future getEnrollmentDetails(String nrk_Id) async {
    try {
      print("=== GET ENROLLMENT DETAILS API REQUEST ===");
      print("NRK ID: $nrk_Id");
      print("API URL: $FamilyBaseURL/enrollment/get-enrollment-numbers/?nrk_id_no=$nrk_Id");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/enrollment/get-enrollment-numbers/?nrk_id_no=$nrk_Id',
      );
      
      print("=== GET ENROLLMENT DETAILS API RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Data: ${response.data}");
      print("Response Data Type: ${response.data.runtimeType}");
      
      // Log specific enrollment fields if available
      if (response.data != null && response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        print("=== ENROLLMENT DETAILS RESPONSE ===");
        print("Success: ${responseData['success']}");
        print("Message: ${responseData['message']}");
        print("Data: ${responseData['data']}");
        
        if (responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;
          print("Self Enrollment Number: ${data['self_enrollment_number']}");
          print("Spouse Enrollment Number: ${data['spouse_enrollment_number']}");
          print("Child1 Enrollment Number: ${data['child1_enrollment_number']}");
          print("Child2 Enrollment Number: ${data['child2_enrollment_number']}");
          print("Child3 Enrollment Number: ${data['child3_enrollment_number']}");
          print("Child4 Enrollment Number: ${data['child4_enrollment_number']}");
          print("Child5 Enrollment Number: ${data['child5_enrollment_number']}");
        }
        print("=== END ENROLLMENT DETAILS RESPONSE ===");
      }
      
      print("=== END GET ENROLLMENT DETAILS API RESPONSE ===");
      return response.data;
    } catch (e) {
      print("=== GET ENROLLMENT DETAILS API ERROR ===");
      print("Error: $e");
      print("Error Type: ${e.runtimeType}");
      if (e is DioException) {
        print("DioException Status Code: ${e.response?.statusCode}");
        print("DioException Response Data: ${e.response?.data}");
        print("DioException Request URL: ${e.requestOptions.uri}");
      }
      print("=== END GET ENROLLMENT DETAILS API ERROR ===");
      rethrow;
    }
  }

  static Future vidalEnrollment(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$VidalBaseURL/vidal/enrollment/create',
        data: data,
      );
      print("user logged in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future generateRequestId() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$FamilyBaseURL/request-id/generate/');
      print("Family members fetched: ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future vidalEnrollmentValidate(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$VidalBaseURL/vidal/enrollment/validate',
        data: data,
      );
      print("user logged in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future vidalEnrollmentEcard(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$VidalBaseURL/vidal/claims/ecard',
        data: data,
      );
      print("user logged in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getDatesDetails(String nrkId) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$FamilyBaseURL/nrk-status/$nrkId/');
      print("get dates in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getPremiumAmount(String nrkId) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/enrollment-payment/get-premium-amount/?nrk_id_no=$nrkId',
      );
      print("get premium amount in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future verifyPayment(Map<String, dynamic> paymentData) async {
    try {
      print("=== VERIFICATION SERVICE: Starting payment verification ===");
      print("Payment data: $paymentData");
      print("API URL: $FamilyBaseURL/razorpay/payments/verify/");

      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/razorpay/payments/verify/?platform=flutter',
        data: paymentData,
      );

      print("=== VERIFICATION SERVICE: API Response ===");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
      print("=== END VERIFICATION SERVICE ===");

      return response.data;
    } catch (e) {
      print("=== VERIFICATION SERVICE ERROR ===");
      print("Error: $e");
      print("=== END VERIFICATION SERVICE ERROR ===");
      rethrow;
    }
  }

  static Future registerPaymentFailure(Map<String, dynamic> failureData) async {
    try {
      print("=== REGISTER PAYMENT FAILURE: Starting failure registration ===");
      print("Failure data: $failureData");
      print("API URL: $FamilyBaseURL/razorpay/payments/register-failure/");

      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$FamilyBaseURL/razorpay/payments/register-failure/',
        data: failureData,
      );

      print("=== REGISTER PAYMENT FAILURE: API Response ===");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
      print("=== END REGISTER PAYMENT FAILURE ===");

      return response.data;
    } catch (e) {
      print("=== REGISTER PAYMENT FAILURE ERROR ===");
      print("Error: $e");
      print("=== END REGISTER PAYMENT FAILURE ERROR ===");
      rethrow;
    }
  }

  static Future getPaymentHistory(String nrkId) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/razorpay/payments/by-nrk-id/?nrk_id_no=$nrkId',
      );
      print("get payment history in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
