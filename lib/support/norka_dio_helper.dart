import 'package:dio/dio.dart';
import 'logger.dart';

class NorkaDioHelper {
  static Future<Dio> getInstance() async {
    Dio dio = Dio();

    dio.options.headers = {
      "Authorization":
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5YmZkZDhlZi0xYjE1LTQ5M2QtOTRlZi1jNzY1OTI5YmJkMzgiLCJqdGkiOiIyZGY0ZGU2YmI2MzlmNTY3Y2JmYjBlN2IxMDI4NzUxYTZlZDU1OTBiMzNiNDg5NDIzNWZlZmU3ZWVlMTU3MTEzMjI5YWM2MjkxNjk4YjE3YyIsImlhdCI6MTc1NjgxNTAwMi40MDg3MzQsIm5iZiI6MTc1NjgxNTAwMi40MDg3MzYsImV4cCI6MTg1MTUwOTQwMi40MDE3MDYsInN1YiI6IjY4MDk1Iiwic2NvcGVzIjpbInByYXZhc2ktZmV0Y2gtZGV0YWlscyJdfQ.hle3WEn7QEO-yIUXCXb9I73cwZMosUjJ4vUoQ0qQca8vHxbfvHfiw3_1N9VAfn_inKl9u25kRPjGvyCzbQkzlgtVpLghuDlN3dCxjcqP4yUdLiHWRLNAHaZIcqdf1IsmZsvwx5GdmDGPUHhcaMQ3_nTfxRRIgTZhkedckkHB-vQpEq_luqxECoRsby0gu8LSx28ihLe02eyJu3WsGluBSIEYVYdLeI-CawMJWhfxkBaKqz5XeRhQU34EEr2NBVxZ1XLQHU7Y8hyJfq0FsYN7IRC9ivot78Y_K7Ozhi5Zdc2M8_TAEGbqfQAlIzADRZvNtEtSiN_1__LohZlHGi5f9Wa3CaWj0VmNLIavF0ZrfHErW_AgnG9KjfpMS0-CI23uDubqZ1pAz12PFUgzcNMY8XGJpxB_biPbbZwZoPt4qDpyRhqH2veaLxEIxjlGr8vVQi0hTWl8t2Dkv2pFsjNTbrvdp32iGmkuj59WvpfYRDRtnHaXiVSfTNbhZgy0GBC2H0k3Oaw3_Akv0AMgboEgPR0eFYVkK8x-ESEkyANzwt57sMAuOW5UR7aFoGPLP7gYJn-JyLAjyUTWTIHbmcjEkH7MwirtUw-J055UPn1GdXXSZU1KMIGwMk-SiOlhqD4JFZNeSYG0usB05bX-jsxovnPzl9ehqvW_OGJ8VmhnpUM',
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log.d('API call - ${options.method} - ${options.uri}');
          log.d('Request Headers: ${options.headers}');
          if (options.data != null) {
            log.d('Request Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log.d('API Response - ${response.statusCode} - ${response.requestOptions.uri}');
          log.d('Response Headers: ${response.headers}');
          log.d('Response Data: ${response.data}');
          return handler.next(response);
        },
        onError: (e, handler) {
          if (e.response != null) {
            log.d(
              'API Error - ${e.response!.statusCode} - ${e.response!.statusMessage}',
            );
            log.d('Error Response Data: ${e.response!.data}');
          } else {
            log.d('API Error - No response: ${e.message}');
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
