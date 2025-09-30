import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../utils/razorpay_config.dart';
import '../support/dio_helper.dart';

class RazorpayService {
  static late Razorpay _razorpay;
  static bool _isInitialized = false;

  // Initialize Razorpay
  static void initialize() {
    if (!_isInitialized) {
      _razorpay = Razorpay();
      _isInitialized = true;
      debugPrint('Razorpay initialized successfully');
    }
  }

  // Setup payment event handlers
  static void setupEventHandlers({
    required Function(PaymentSuccessResponse) onPaymentSuccess,
    required Function(PaymentFailureResponse) onPaymentError,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    if (!_isInitialized) {
      initialize();
    }

    _razorpay.clear();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onPaymentError);
    if (onExternalWallet != null) {
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
    }
  }

  // Create Razorpay order
  static Future<Map<String, dynamic>> createOrder({
    required int amount,
    required String currency,
    String? receipt,
    required String nrkIdNo,
  }) async {
    debugPrint('Creating order for ₹$amount (${amount * 100} paise)');

    final requestBody = {
      'amount': amount * 100,
      'currency': currency,
      'receipt': receipt ?? 'receipt_${DateTime.now().millisecondsSinceEpoch}',
      'payment_capture': 1,
      'nrk_id_no': nrkIdNo,
    };

    try {
      final dio = await DioHelper.getInstance();
      dio.options.headers = {
        'Content-Type': 'application/json',
        // Remove Razorpay authorization header for backend API
      };

      debugPrint('=== BACKEND RAZORPAY API REQUEST ===');
      debugPrint('URL: ${RazorpayConfig.backendOrdersEndpoint}');
      debugPrint('Method: POST');
      debugPrint('Headers: ${dio.options.headers}');
      debugPrint('Request Body: $requestBody');

      final response = await dio.post(
        RazorpayConfig.backendOrdersEndpoint,
        data: requestBody,
      );

      debugPrint('=== BACKEND RAZORPAY API RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Headers: ${response.headers}');
      debugPrint('Response Data: ${response.data}');
      debugPrint('Response Type: ${response.data.runtimeType}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final razorpayOrder =
            responseData['razorpay_order'] as Map<String, dynamic>;
        final localOrder = responseData['local_order'] as Map<String, dynamic>;
        final keyId = responseData['key_id'] as String;

        debugPrint('=== ORDER CREATION SUCCESS ===');
        debugPrint('Razorpay Order ID: ${razorpayOrder['id']}');
        debugPrint('Order Amount: ${razorpayOrder['amount']} paise');
        debugPrint('Order Currency: ${razorpayOrder['currency']}');
        debugPrint('Order Status: ${razorpayOrder['status']}');
        debugPrint('Order Receipt: ${razorpayOrder['receipt']}');
        debugPrint('Order Created At: ${razorpayOrder['created_at']}');
        debugPrint('Local Order ID: ${localOrder['id']}');
        debugPrint('NRK ID: ${localOrder['nrk_id_no']}');
        debugPrint('Key ID: $keyId');
        debugPrint('Full Response Data: $responseData');
        debugPrint('=== END ORDER RESPONSE ===');

        // Return the razorpay_order data for compatibility with existing code
        return razorpayOrder;
      } else {
        debugPrint('=== ORDER CREATION FAILED ===');
        debugPrint('Error Status: ${response.statusCode}');
        debugPrint('Error Data: ${response.data}');
        debugPrint('=== END ERROR RESPONSE ===');
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('=== API ERROR ===');
      debugPrint('Error: $e');
      debugPrint('Error Type: ${e.runtimeType}');
      debugPrint('=== END API ERROR ===');
      throw Exception('Failed to create order: $e');
    }
  }

  // static void openCheckout({
  //   required String orderId,
  //   required int amount,
  //   required String currency,
  //   required String name,
  //   required String description,
  //   Map<String, String>? prefill,
  // }) {
  //   debugPrint('Opening checkout for order: $orderId');

  //   var options = {
  //     'key': RazorpayConfig.keyId,
  //     'amount': amount * 100,
  //     'currency': currency,
  //     'name': name,
  //     'description': description,
  //     'order_id': orderId,
  //     'prefill': prefill ?? RazorpayConfig.defaultPrefill,
  //     'theme': RazorpayConfig.defaultTheme,
  //     'timeout': 300,
  //     'retry': {'enabled': true, 'max_count': 3},
  //   };

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     try {
  //       _razorpay.open(options);
  //       debugPrint('Razorpay opened successfully');
  //     } catch (e) {
  //       debugPrint("Error opening Razorpay: $e");
  //       Fluttertoast.showToast(
  //         msg: "Failed to open payment gateway",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //     }
  //   });
  // }

  // // Main payment processing method
  // static Future<void> processPayment({
  //   required int amount,
  //   required String currency,
  //   required String name,
  //   required String description,
  //   String? receipt,
  //   required String nrkIdNo,
  //   Map<String, String>? prefill,
  //   Function(String)? onOrderCreated,
  //   Function(String)? onError,
  // }) async {
  //   try {
  //     debugPrint('=== PAYMENT PROCESSING ===');
  //     debugPrint('Amount: ₹$amount (${amount * 100} paise)');
  //     debugPrint('Currency: $currency');
  //     debugPrint('Description: $description');
  //     debugPrint('NRK ID: $nrkIdNo');

  //     // Create order
  //     final orderResponse = await createOrder(
  //       amount: amount,
  //       currency: currency,
  //       receipt: receipt,
  //       nrkIdNo: nrkIdNo,
  //     );

  //     if (orderResponse['status'] == 'created') {
  //       final orderId = orderResponse['id'];
  //       onOrderCreated?.call(orderId);

  //       // Open checkout
  //       openCheckout(
  //         orderId: orderId,
  //         amount: amount,
  //         currency: currency,
  //         name: name,
  //         description: description,
  //         prefill: prefill,
  //       );
  //     } else {
  //       final errorMsg =
  //           'Failed to create order: ${orderResponse['error'] ?? 'Unknown error'}';
  //       onError?.call(errorMsg);
  //       throw Exception(errorMsg);
  //     }
  //   } catch (e) {
  //     final errorMsg = 'Payment processing failed: $e';
  //     onError?.call(errorMsg);
  //     throw Exception(errorMsg);
  //   }
  // }

  // Dispose Razorpay
  static void dispose() {
    if (_isInitialized) {
      _razorpay.clear();
      _isInitialized = false;
      debugPrint('Razorpay disposed successfully');
    }
  }
}
