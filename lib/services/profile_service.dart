// import 'package:norkacare_app/support/dio_helper.dart';

// class TestStateService {
//   // static Future getUserDetails() async {
//   //   try {
//   //     var dio = await DioHelper.getInstance();
//   //     var response = await dio.get('$baseURL/v1/user/user/details');
//   //     return response.data;
//   //   } catch (e) {
//   //     rethrow;
//   //   }
//   // }

//   static Future getStates() async {
//     try {
//       var dio = await DioHelper.getInstance();
//       var response = await dio.get(
//         'https://devapigw.vidalhealthtpa.com/partner-integration/api/public-static/states',
//       );
//       print('>>>>>>>>$response');
//       print('States API Response: ${response.data}');

//       return response.data;
//     } catch (e) {
//       print('Error fetching states: $e');
//       rethrow;
//     }
//   }
// }
