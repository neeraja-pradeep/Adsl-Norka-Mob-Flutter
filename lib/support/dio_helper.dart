import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

class DioHelper {
  static Future<Dio> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('accessToken') ?? "";
    String country = prefs.getString('country') ?? "Unknown";
    String regionName = prefs.getString('administrativeArea') ?? "Unknown";
    String city = prefs.getString('locality') ?? "Unknown";
    double lat = prefs.getDouble('latitude') ?? 0;
    double lon = prefs.getDouble('longitude') ?? 0;

    // log.i("Access Token: $token");
    // log.i("Ocp-Apim-Subscription-Key: 1aa0de51057a4821a0b97734e51b0bfc");
    log.i(
      "Location Headers => Country: $country, Region: $regionName, City: $city, Lat: $lat, Lon: $lon",
    );

    Dio dio = Dio();

    dio.options.headers = {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
      "Content-Type": "application/json",
      "country": country,
      "regionName": regionName,
      "city": city,
      "latitude": lat.toString(),
      "longitude": lon.toString(),
      "Ocp-Apim-Subscription-Key": "1aa0de51057a4821a0b97734e51b0bfc",
      // "Host": "devapigw.vidalhealthtpa.com",
      // "group-id": "123",
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log.d('API call - ${options.method} - ${options.uri}');
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response != null) {
            log.d(
              'API Error - ${e.response!.statusCode} - ${e.response!.statusMessage}',
            );
            log.d(e.response!.data);
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
