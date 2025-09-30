// import 'package:flutter/material.dart';
// import '../services/profile_service.dart';

// class TestProfileProvider extends ChangeNotifier {
//   Map<String, dynamic> _userDetails = {};
//   List<Map<String, dynamic>> _states = [];
//   bool _isDetailsLoading = true;
//   bool _isStatesLoading = false;

//   Map<String, dynamic> get userDetails => _userDetails;
//   List<Map<String, dynamic>> get states => _states;
//   bool get isDetailsLoading => _isDetailsLoading;
//   bool get isStatesLoading => _isStatesLoading;

//   // Future<void> getUserDetails() async {
//   //   try {
//   //     _isDetailsLoading = true;
//   //     notifyListeners();
//   //     final response = await StateService.getUserDetails();
//   //     print('>>>>>>>>$response');
//   //     _userDetails = response['data'] ?? {};
//   //   } catch (e) {
//   //     debugPrint('Error fetching services: $e');
//   //   } finally {
//   //     _isDetailsLoading = false;
//   //     notifyListeners();
//   //   }
//   // }

//   Future<void> getStates() async {
//     try {
//       _isStatesLoading = true;
//       notifyListeners();
//       final response = await TestStateService.getStates();
//       print('>>>>>>>>$response');
//       if (response['successful'] == true && response['data'] != null) {
//         _states = List<Map<String, dynamic>>.from(response['data']);
//       } else {
//         _states = [];
//       }
//     } catch (e) {
//       debugPrint('Error fetching states: $e');
//       _states = [];
//     } finally {
//       _isStatesLoading = false;
//       notifyListeners();
//     }
//   }
// }
