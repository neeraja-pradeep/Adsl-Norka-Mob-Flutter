import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/norka_dio_helper.dart';

class NorkaService {
  static Future getpravasidata(String norkaId) async {
    try {
      final requestData = {"norka_id": norkaId, "response_type": "full"};

      print("The logged data : ${requestData}");
      
      // Check if this is the test Norka ID for Google Play Store
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
        // Use original API for real Norka IDs
        var dio = await NorkaDioHelper.getInstance();
        var response = await dio.post(
          '$norkaBaseURL/get-pravasi-details',
          data: requestData,
        );
        print("user logged in : ${response.data}");
        return response.data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
