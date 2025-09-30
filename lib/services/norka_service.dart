import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/norka_dio_helper.dart';

class NorkaService {
  static Future getpravasidata(String norkaId) async {
    try {
      final requestData = {"norka_id": norkaId, "response_type": "full"};

      print("The logged data : ${requestData}");
      var dio = await NorkaDioHelper.getInstance();
      var response = await dio.post(
        '$norkaBaseURL/get-pravasi-details',
        // '$norkaBaseURL/accounts/login/',
        data: requestData,
      );
      print("user logged in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
