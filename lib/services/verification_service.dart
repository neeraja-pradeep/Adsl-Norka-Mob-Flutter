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
        '$VidalBaseURL/enrollment/create',
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
        '$VidalBaseURL/enrollment/validate',
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

  // New unified API for dashboard - gets all user data in one call
  static Future getUserDetails(String nrkId) async {
    try {
      print("=== GET USER DETAILS (UNIFIED API) ===");
      print("NRK ID: $nrkId");
      print("API URL: $FamilyBaseURL/nrk-otp/user/details/$nrkId/");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/nrk-otp/user/details/$nrkId/',
      );
      
      print("User details response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error getting user details: $e");
      rethrow;
    }
  }

  // Update primary email
  static Future updatePrimaryEmail(String nrkId, String primaryEmail) async {
    try {
      print("=== UPDATE PRIMARY EMAIL ===");
      print("NRK ID: $nrkId");
      print("Primary Email: $primaryEmail");
      print("API URL: $FamilyBaseURL/nrk-otp/user/update/primary-email/");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.put(
        '$FamilyBaseURL/nrk-otp/user/update/primary-email/',
        data: {
          'nrk_id_no': nrkId,
          'primary_email': primaryEmail,
        },
      );
      
      print("Update primary email response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error updating primary email: $e");
      rethrow;
    }
  }

  // Update primary mobile
  static Future updatePrimaryMobile(String nrkId, String primaryMobile) async {
    try {
      print("=== UPDATE PRIMARY MOBILE ===");
      print("NRK ID: $nrkId");
      print("Primary Mobile: $primaryMobile");
      print("API URL: $FamilyBaseURL/nrk-otp/user/update/primary-mobile/");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.put(
        '$FamilyBaseURL/nrk-otp/user/update/primary-mobile/',
        data: {
          'nrk_id_no': nrkId,
          'primary_mobile': primaryMobile,
        },
      );
      
      print("Update primary mobile response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error updating primary mobile: $e");
      rethrow;
    }
  }

  // Update secondary email
  static Future updateSecondaryEmail(String nrkId, String secondaryEmail) async {
    try {
      print("=== UPDATE SECONDARY EMAIL ===");
      print("NRK ID: $nrkId");
      print("Secondary Email: $secondaryEmail");
      print("API URL: $FamilyBaseURL/nrk-otp/user/update/secondary-email/");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.put(
        '$FamilyBaseURL/nrk-otp/user/update/secondary-email/',
        data: {
          'nrk_id_no': nrkId,
          'secondary_email': secondaryEmail,
        },
      );
      
      print("Update secondary email response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error updating secondary email: $e");
      rethrow;
    }
  }

  // Update secondary mobile
  static Future updateSecondaryMobile(String nrkId, String secondaryMobile) async {
    try {
      print("=== UPDATE SECONDARY MOBILE ===");
      print("NRK ID: $nrkId");
      print("Secondary Mobile: $secondaryMobile");
      print("API URL: $FamilyBaseURL/nrk-otp/user/update/secondary-mobile/");
      
      var dio = await DioHelper.getInstance();
      var response = await dio.put(
        '$FamilyBaseURL/nrk-otp/user/update/secondary-mobile/',
        data: {
          'nrk_id_no': nrkId,
          'secondary_mobile': secondaryMobile,
        },
      );
      
      print("Update secondary mobile response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error updating secondary mobile: $e");
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
