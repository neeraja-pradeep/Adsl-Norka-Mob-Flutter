import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class HospitalService {
  static Future getHospitals(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$VidalBaseURL/vidal/public/hospitals',
        data: data,
      );
      print("user logged in : ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getStates() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$VidalBaseURL/vidal/public/states');
      print("States fetched: ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getCities(stateTypeID) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$VidalBaseURL/vidal/public/cities?stateTypeId=$stateTypeID',
      );
      print("Cities fetched: ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
