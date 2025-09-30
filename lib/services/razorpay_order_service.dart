// import 'package:flutter/material.dart';
// import '../utils/razorpay_config.dart';
// import '../support/dio_helper.dart';

// class RazorpayOrderService {
//   // Create Razorpay order
//   static Future<Map<String, dynamic>> createOrder({
//     required int amount,
//     required String currency,
//     String? receipt,
//   }) async {
//     debugPrint('Creating order for ₹$amount (${amount * 100} paise)');

//     final requestBody = {
//       'amount': amount * 100,
//       'currency': currency,
//       'receipt': receipt ?? 'receipt_${DateTime.now().millisecondsSinceEpoch}',
//       'payment_capture': 1,
//     };

//     try {
//       final dio = await DioHelper.getInstance();
//       dio.options.headers = {
//         'Content-Type': 'application/json',
//         'Authorization': RazorpayConfig.authorizationHeader,
//       };

//       debugPrint('=== RAZORPAY ORDER API REQUEST ===');
//       debugPrint('URL: ${RazorpayConfig.ordersEndpoint}');
//       debugPrint('Method: POST');
//       debugPrint('Headers: ${dio.options.headers}');
//       debugPrint('Request Body: $requestBody');

//       final response = await dio.post(
//         RazorpayConfig.ordersEndpoint,
//         data: requestBody,
//       );

//       debugPrint('=== RAZORPAY ORDER API RESPONSE ===');
//       debugPrint('Status Code: ${response.statusCode}');
//       debugPrint('Response Data: ${response.data}');

//       if (response.statusCode == 200) {
//         final orderData = response.data as Map<String, dynamic>;
//         debugPrint('=== ORDER CREATION SUCCESS ===');
//         debugPrint('Order ID: ${orderData['id']}');
//         debugPrint('Order Amount: ${orderData['amount']} paise');
//         debugPrint('Order Currency: ${orderData['currency']}');
//         debugPrint('Order Status: ${orderData['status']}');
//         return orderData;
//       } else {
//         debugPrint('=== ORDER CREATION FAILED ===');
//         debugPrint('Error Status: ${response.statusCode}');
//         debugPrint('Error Data: ${response.data}');
//         throw Exception('Failed to create order: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('=== ORDER API ERROR ===');
//       debugPrint('Error: $e');
//       throw Exception('Failed to create order: $e');
//     }
//   }
// }
