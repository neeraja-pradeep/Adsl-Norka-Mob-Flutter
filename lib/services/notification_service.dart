import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class NotificationService {
  
  static Future<Map<String, dynamic>?> getNotification() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$FamilyBaseURL/registration-info/',
      );
      print("Get notification response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error fetching notification: $e");
      rethrow;
    }
  }
}
