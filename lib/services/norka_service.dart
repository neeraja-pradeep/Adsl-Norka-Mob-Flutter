import 'package:norkacare_app/support/norka_dio_helper.dart';

class NorkaService {
  // This service is now deprecated - use OTP verification response data instead
  // Keeping only dummy API for testing purposes
  static Future getpravasidata(String norkaId) async {
    try {
      final requestData = {"norka_id": norkaId, "response_type": "full"};

      print("The logged data : ${requestData}");
      
      // Only support dummy API for test Norka ID
      if (norkaId == "M12345678") {
        print("Using dummy API for test Norka ID: $norkaId");
        var dio = await NorkaDioHelper.getInstance();
        var response = await dio.post(
          'https://norkaapi.tqdemo.website/api/accounts/login/',
          data: requestData,
        );
        print("user logged in (dummy): ${response.data}");
        return response.data;
      } else {
        // For real NORKA IDs, throw an error as we should use OTP verification data
        throw Exception("NORKA API calls are deprecated. Use OTP verification response data instead.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
