// import 'package:norkacare_app/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/screen/verification/payment/payment_success_page.dart';

// class RazorpayCheckoutPage extends StatefulWidget {
//   final String orderId;
//   final int amount;
//   final String currency;
//   final String name;
//   final String description;
//   final String image;
//   final Map<String, String> prefill;
//   final Map<String, String> notes;
//   final String callbackUrl;
//   final String cancelUrl;

//   const RazorpayCheckoutPage({
//     super.key,
//     required this.orderId,
//     required this.amount,
//     required this.currency,
//     required this.name,
//     required this.description,
//     required this.image,
//     required this.prefill,
//     required this.notes,
//     required this.callbackUrl,
//     required this.cancelUrl,
//   });

//   @override
//   State<RazorpayCheckoutPage> createState() => _RazorpayCheckoutPageState();
// }

// class _RazorpayCheckoutPageState extends State<RazorpayCheckoutPage> {
//   bool _isLoading = false;
//   bool _hasError = false;
//   late Razorpay _razorpay;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint('=== RAZORPAY CHECKOUT PAGE INITIALIZED ===');
//     debugPrint('Order ID: ${widget.orderId}');
//     debugPrint('Amount: ${widget.amount}');
//     debugPrint('Name: ${widget.name}');
//     debugPrint('Description: ${widget.description}');
//     _setupRazorpayHandlers();
//   }

//   void _setupRazorpayHandlers() {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     debugPrint('=== PAYMENT SUCCESS RESPONSE ===');
//     debugPrint('Payment ID: ${response.paymentId}');
//     debugPrint('Order ID: ${response.orderId}');
//     debugPrint('Signature: ${response.signature}');

//     // Create the response object as requested
//     final paymentResponse = {
//       "razorpay_payment_id": response.paymentId ?? '',
//       "razorpay_order_id": response.orderId ?? '',
//       "razorpay_signature": response.signature ?? '',
//     };

//     debugPrint('=== PAYMENT RESPONSE OBJECT ===');
//     debugPrint('$paymentResponse');
//     debugPrint('=== END PAYMENT RESPONSE ===');

//     // Navigate to success page
//     _navigateToSuccessPage(response.paymentId ?? '');
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     debugPrint('Payment Error: ${response.code} - ${response.message}');
//     Fluttertoast.showToast(
//       msg: "Payment Failed: ${response.message}",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//     );

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     debugPrint('External Wallet: ${response.walletName}');
//     Fluttertoast.showToast(
//       msg: "External Wallet: ${response.walletName}",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.blue,
//       textColor: Colors.white,
//     );
//   }

//   void _navigateToSuccessPage(String paymentId) {
//     // Get email and NRK ID from providers
//     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//     String emailId = '';
//     String nrkId = norkaProvider.norkaId;

//     // Extract email from NORKA provider response
//     if (norkaProvider.response != null) {
//       final emails = norkaProvider.response!['emails'];
//       if (emails != null && emails.isNotEmpty) {
//         emailId = emails[0]['address'] ?? '';
//       }
//     }

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             PaymentSuccessPage(emailId: emailId, nrkId: nrkId),
//       ),
//       (route) => false,
//     );
//   }

//   Future<void> _handleSubmitPayment() async {
//     debugPrint('=== SUBMIT PAYMENT CLICKED ===');
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       // Open Razorpay checkout with the order details
//       var options = {
//         'key': 'rzp_test_R9THzwql6lKlIL',
//         'amount': widget.amount * 100,
//         'currency': widget.currency,
//         'name': widget.name,
//         'description': widget.description,
//         'order_id': widget.orderId,
//         'prefill': {
//           'contact': widget.prefill['contact'] ?? '',
//           'email': widget.prefill['email'] ?? '',
//           'name': widget.prefill['name'] ?? '',
//         },
//         'theme': {'color': '#004EA1'}, // Using app primary color
//         'timeout': 300,
//         'retry': {'enabled': true, 'max_count': 3},
//       };

//       debugPrint('=== OPENING RAZORPAY CHECKOUT ===');
//       debugPrint('Options: $options');

//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         try {
//           _razorpay.open(options);
//           debugPrint('Razorpay opened successfully');
//           setState(() {
//             _isLoading = false;
//           });
//         } catch (e) {
//           debugPrint("Error opening Razorpay: $e");
//           setState(() {
//             _isLoading = false;
//             _hasError = true;
//           });
//           Fluttertoast.showToast(
//             msg: "Failed to open payment gateway",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//         }
//       });
//     } catch (e) {
//       debugPrint('Error in Submit Payment: $e');
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//       Fluttertoast.showToast(
//         msg: 'Failed to initialize payment: $e',
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     debugPrint('=== BUILDING RAZORPAY CHECKOUT PAGE ===');
//     debugPrint('_isLoading: $_isLoading');
//     debugPrint('_hasError: $_hasError');
//     debugPrint('isDarkMode: $isDarkMode');

//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.black : Colors.white,
//       appBar: AppBar(
//         title: const Text('Payment'),
//         centerTitle: true,
//         backgroundColor: isDarkMode ? Colors.black : Colors.white,
//         foregroundColor: isDarkMode ? Colors.white : Colors.black,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//       ),
//       body: Stack(
//         children: [
//           if (_hasError)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Failed to load payment page',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Please check your internet connection and try again',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: isDarkMode ? Colors.white70 : Colors.black54,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _hasError = false;
//                         _isLoading = true;
//                       });
//                       _handleSubmitPayment();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//           else
//             _buildCheckoutForm(isDarkMode),
//           if (_isLoading && !_hasError)
//             Container(
//               color: isDarkMode ? Colors.black : Colors.white,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         isDarkMode ? Colors.white : Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Processing payment...',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isDarkMode ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCheckoutForm(bool isDarkMode) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Order Summary Card
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Order Summary',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Insurance Premium',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isDarkMode ? Colors.white70 : Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       '₹${widget.amount}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: isDarkMode ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Order ID',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     ),
//                     Text(
//                       widget.orderId,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Payment Details Card
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Payment Details',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildDetailRow(
//                   'Name',
//                   widget.prefill['name'] ?? '',
//                   isDarkMode,
//                 ),
//                 _buildDetailRow(
//                   'Email',
//                   widget.prefill['email'] ?? '',
//                   isDarkMode,
//                 ),
//                 _buildDetailRow(
//                   'Contact',
//                   widget.prefill['contact'] ?? '',
//                   isDarkMode,
//                 ),
//                 _buildDetailRow('Currency', widget.currency, isDarkMode),
//               ],
//             ),
//           ),
//           const Spacer(),

//           // Submit Button
//           Container(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: _isLoading ? null : _handleSubmitPayment,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppConstants.primaryColor,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 2,
//               ),
//               child: _isLoading
//                   ? Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           'Processing Payment...',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     )
//                   : Text(
//                       'Submit Payment - ₹${widget.amount}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, bool isDarkMode) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: isDarkMode ? Colors.white70 : Colors.black54,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: isDarkMode ? Colors.white : Colors.black87,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
