import 'package:norkacare_app/services/hospital_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HospitalProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _response;
  Map<String, dynamic>? _hospitalResponse;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get response => _response;
  Map<String, dynamic>? get hospitalResponse => _hospitalResponse;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearData() {
    _response = null;
    _hospitalResponse = null;
    _errorMessage = '';
    _statesDetails = {};
    _isStatesDetailsLoading = true;
    _citiesDetails = {};
    _isCitiesDetailsLoading = true;
    notifyListeners();
  }

  void _handleError(DioException e) {
    _errorMessage =
        e.response?.data['message'] ?? 'An error occurred. Please try again.';
    if (e.response == null) {
      _errorMessage = 'Network error. Please check your internet connection.';
    }
    debugPrint("Dio Error: ${e.response}");
  }

  Future<void> getHospitals(Map<String, dynamic> data) async {
    _setLoading(true);
    _errorMessage = '';
    _hospitalResponse = null; // Clear previous response
    try {
      debugPrint("=== HOSPITAL API REQUEST ===");
      debugPrint("Request Data: $data");

      final response = await HospitalService.getHospitals(data);
      _hospitalResponse = response;

      debugPrint("=== HOSPITAL API RESPONSE ===");
      debugPrint("Response: $response");
      debugPrint("=== END HOSPITAL API RESPONSE ===");

      // Check if response contains success indicators
      if (response != null) {
        // Check for success status
        bool hasSuccessStatus =
            response.containsKey('status') && response['status'] == 'SUCCESS';

        // Check for hospital data
        bool hasHospitalData =
            response.containsKey('data') &&
            response['data'] != null &&
            response['data'] is List &&
            (response['data'] as List).isNotEmpty;

        if (hasSuccessStatus && hasHospitalData) {
          _errorMessage = '';
          debugPrint("✅ Success: Hospital API call successful");
        } else if (response.containsKey('message')) {
          _errorMessage = response['message'];
          debugPrint("⚠️ API returned message: ${response['message']}");
        } else {
          _errorMessage = "Failed to retrieve Hospital data";
          debugPrint("❌ No valid Hospital data found in response");
        }
      } else {
        _errorMessage = "No response received from server";
        debugPrint("❌ No response received");
      }
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _errorMessage = "An unexpected error occurred.";
      debugPrint("General Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Map<String, dynamic> _statesDetails = {};
  bool _isStatesDetailsLoading = true;

  Map<String, dynamic> get statesDetails => _statesDetails;
  bool get isStatesDetailsLoading => _isStatesDetailsLoading;

  Future<void> getStatesDetails() async {
    try {
      _isStatesDetailsLoading = true;
      notifyListeners();
      final response = await HospitalService.getStates();
      print('>>>>>>>>$response');
      _statesDetails = response ?? {};
    } catch (e) {
      debugPrint('Error fetching states details: $e');
    } finally {
      _isStatesDetailsLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _citiesDetails = {};
  bool _isCitiesDetailsLoading = true;

  Map<String, dynamic> get citiesDetails => _citiesDetails;
  bool get isCitiesDetailsLoading => _isCitiesDetailsLoading;

  Future<void> getCitiesDetails(stateTypeID) async {
    try {
      _isCitiesDetailsLoading = true;
      notifyListeners();
      final response = await HospitalService.getCities(stateTypeID);
      print('>>>>>>>>$response');
      _citiesDetails = response ?? {};
    } catch (e) {
      debugPrint('Error fetching request id details: $e');
    } finally {
      _isCitiesDetailsLoading = false;
      notifyListeners();
    }
  }
}
