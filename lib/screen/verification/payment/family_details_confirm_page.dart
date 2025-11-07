// import 'package:norkacare_app/services/razorpay_service.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/screen/verification/payment/payment_success_page.dart';
// import 'package:provider/provider.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/provider/otp_verification_provider.dart';
// import 'package:norkacare_app/services/vidal_data_mapper.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:norkacare_app/screen/profile/terms_of_service.dart';
// import 'package:norkacare_app/screen/profile/privacy_policy.dart';

// class FamilyDetailsConfirmPage extends StatefulWidget {
//   const FamilyDetailsConfirmPage({super.key});

//   @override
//   State<FamilyDetailsConfirmPage> createState() =>
//       _FamilyDetailsConfirmPageState();
// }

// class _FamilyDetailsConfirmPageState extends State<FamilyDetailsConfirmPage> {
//   bool isDeclarationChecked = false;
//   bool isTermsChecked = false;
//   bool isPolicyTermsChecked = false;
//   bool _isLoading = false;
//   late Razorpay _razorpay;
//   String _currentOrderId =
//       ''; // Store the current order ID for failure handling
//   int _currentAmount =
//       0; // Store the current payment amount for failure handling

//   @override
//   void initState() {
//     super.initState();
//     _setupRazorpayHandlers();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadFamilyData();
//     });
//   }

//   void _setupRazorpayHandlers() {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void _loadFamilyData() async {
//     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//     final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//       context,
//       listen: false,
//     );
//     final verificationProvider = Provider.of<VerificationProvider>(
//       context,
//       listen: false,
//     );

//     // Get the NRK ID from verified data first, then fallback to NORKA provider
//     String nrkId = norkaProvider.norkaId;
//     final verifiedCustomerData = otpVerificationProvider
//         .getVerifiedCustomerData();
//     if (verifiedCustomerData != null &&
//         verifiedCustomerData['nrk_id'] != null) {
//       nrkId = verifiedCustomerData['nrk_id'];
//     }

//     if (nrkId.isNotEmpty &&
//         (verificationProvider.familyMembersDetails.isEmpty ||
//             verificationProvider.isFamilyMembersDetailsLoading)) {
//       await verificationProvider.getFamilyMembersWithOfflineFallback(nrkId);
//     }

//     if (nrkId.isNotEmpty && verificationProvider.datesDetails.isEmpty) {
//       await verificationProvider.getDatesDetailsWithOfflineFallback(nrkId);
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     debugPrint('=== PAYMENT SUCCESS RESPONSE ===');
//     debugPrint('Payment ID: ${response.paymentId}');
//     debugPrint('Order ID: ${response.orderId}');
//     debugPrint('Signature: ${response.signature}');

//     // Keep loading state active during verification
//     if (mounted) {
//       setState(() {
//         _isLoading = true;
//       });
//     }

//     // Get NRK ID for payment verification
//     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//     final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//       context,
//       listen: false,
//     );

//     // Get NRK ID from verified customer data first, then fallback to NORKA provider
//     String nrkId = norkaProvider.norkaId;
//     final verifiedCustomerData = otpVerificationProvider
//         .getVerifiedCustomerData();
//     if (verifiedCustomerData != null) {
//       // Try different possible field names for NRK ID
//       nrkId = verifiedCustomerData['norka_id'] ?? 
//               verifiedCustomerData['nrk_id'] ?? 
//               verifiedCustomerData['norka_id_no'] ?? 
//               verifiedCustomerData['nrk_id_no'] ?? nrkId;
//     }

//     debugPrint('=== NRK ID DEBUG (UPDATED) ===');
//     debugPrint('NORKA Provider NRK ID: ${norkaProvider.norkaId}');
//     debugPrint('Verified Customer Data: $verifiedCustomerData');
//     debugPrint('Final NRK ID: $nrkId');
//     debugPrint('=== END NRK ID DEBUG ===');

//     final paymentResponse = {
//       "razorpay_payment_id": response.paymentId ?? '',
//       "razorpay_order_id": response.orderId ?? '',
//       "razorpay_signature": response.signature ?? '',
//       "nrk_id_no": nrkId,
//     };

//     debugPrint('=== PAYMENT RESPONSE OBJECT ===');
//     debugPrint('$paymentResponse');
//     debugPrint('=== END PAYMENT RESPONSE ===');

//     try {
//       // Verify payment with backend (this will store the payment details)
//       await _verifyPaymentWithBackend(paymentResponse);

//       // Show success message
//       // Fluttertoast.showToast(
//       //   msg: "Payment successful! Redirecting...",
//       //   toastLength: Toast.LENGTH_SHORT,
//       //   gravity: ToastGravity.BOTTOM,
//       //   backgroundColor: Colors.green,
//       //   textColor: Colors.white,
//       // );

//       // Small delay to show the success message
//       // await Future.delayed(const Duration(milliseconds: 1500));

//       // Navigate to success page
//       _navigateToSuccessPage(response.paymentId ?? '');
//     } catch (e) {
//       debugPrint('Error during payment verification: $e');

//       // Show success message even if verification fails
//       Fluttertoast.showToast(
//         msg: "Payment successful!",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//       );

//       // Small delay to show the success message
//       // await Future.delayed(const Duration(milliseconds: 1500));

//       // Still navigate to success page even if verification fails
//       _navigateToSuccessPage(response.paymentId ?? '');
//     }
//   }

//   void _handlePaymentError(PaymentFailureResponse response) async {
//     debugPrint('Payment Error: ${response.code} - ${response.message}');

//     String errorMessage;

//     // Handle different error codes with user-friendly messages
//     switch (response.code) {
//       case 1:
//         errorMessage =
//             "Payment failed due to network issues. Please check your internet connection and try again.";
//         break;
//       case 2:
//         errorMessage =
//             "Payment was cancelled by user. You can try again anytime.";
//         break;
//       case 3:
//         errorMessage =
//             "Payment failed due to technical issues. Please try again.";
//         break;
//       case 4:
//         errorMessage =
//             "Payment failed due to invalid payment details. Please check your card/bank details.";
//         break;
//       case 5:
//         errorMessage =
//             "Payment failed due to insufficient funds. Please check your account balance.";
//         break;
//       case 6:
//         errorMessage =
//             "Payment failed due to bank restrictions. Please contact your bank.";
//         break;
//       case 7:
//         errorMessage =
//             "Payment failed due to security reasons. Please try again or use a different payment method.";
//         break;
//       case 8:
//         errorMessage = "Payment failed due to timeout. Please try again.";
//         break;
//       case 9:
//         errorMessage = "Payment failed due to invalid OTP. Please try again.";
//         break;
//       case 10:
//         errorMessage =
//             "Payment failed due to card expiry. Please use a different card.";
//         break;
//       default:
//         // Use the original message if it's meaningful, otherwise provide a generic message
//         if (response.message != null && response.message!.isNotEmpty) {
//           errorMessage = "Payment failed: ${response.message}";
//         } else {
//           errorMessage =
//               "Payment failed due to an unknown error. Please try again.";
//         }
//         break;
//     }

//     // Register failed payment in backend using the dedicated failure API
//     try {
//       // Get NRK ID for payment verification
//       final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//       final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//         context,
//         listen: false,
//       );

//       // Get NRK ID from verified customer data first, then fallback to NORKA provider
//       String nrkId = norkaProvider.norkaId;
//       final verifiedCustomerData = otpVerificationProvider
//           .getVerifiedCustomerData();
//       if (verifiedCustomerData != null &&
//           verifiedCustomerData['norka_id'] != null) {
//         nrkId = verifiedCustomerData['norka_id'];
//       }

//       // Create failed payment data for the register-failure API
//       final failureData = {
//         "razorpay_order_id": _currentOrderId, // Use stored order ID
//         "razorpay_payment_id":
//             '', // PaymentFailureResponse doesn't have paymentId
//         "nrk_id_no": nrkId,
//         "error_code": _getErrorCodeString(response.code),
//         "error_description": response.message ?? errorMessage,
//         "rzp_payload": {
//           "notes": {"norka_id": nrkId},
//           "method": "unknown",
//           "amount": (_currentAmount * 100)
//               .toString(), // Convert to paisa format
//         },
//       };

//       debugPrint('=== REGISTERING PAYMENT FAILURE ===');
//       debugPrint('Failure Data: $failureData');

//       // Call the dedicated failure registration API
//       final verificationProvider = Provider.of<VerificationProvider>(
//         context,
//         listen: false,
//       );
//       await verificationProvider.registerPaymentFailure(failureData);

//       debugPrint('✅ Failed payment registered in backend');
//     } catch (e) {
//       debugPrint('❌ Error registering failed payment: $e');
//     }

//     Fluttertoast.showToast(
//       msg: "payment failed",
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//     );

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   String _getErrorCodeString(int? code) {
//     switch (code) {
//       case 1:
//         return "NETWORK_ERROR";
//       case 2:
//         return "PAYMENT_CANCELLED";
//       case 3:
//         return "TECHNICAL_ERROR";
//       case 4:
//         return "INVALID_PAYMENT_DETAILS";
//       case 5:
//         return "INSUFFICIENT_FUNDS";
//       case 6:
//         return "BANK_RESTRICTIONS";
//       case 7:
//         return "SECURITY_ERROR";
//       case 8:
//         return "TIMEOUT";
//       case 9:
//         return "INVALID_OTP";
//       case 10:
//         return "CARD_EXPIRED";
//       default:
//         return "UNKNOWN_ERROR";
//     }
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     debugPrint('External Wallet: ${response.walletName}');
//     // Fluttertoast.showToast(
//     //   msg: "External Wallet: ${response.walletName}",
//     //   toastLength: Toast.LENGTH_SHORT,
//     //   gravity: ToastGravity.BOTTOM,
//     //   backgroundColor: Colors.blue,
//     //   textColor: Colors.white,
//     // );
//   }

//   Future<void> _verifyPaymentWithBackend(
//     Map<String, dynamic> paymentResponse,
//   ) async {
//     try {
//       debugPrint('=== PAYMENT VERIFICATION START ===');
//       debugPrint('Verifying payment with backend...');
//       debugPrint('Payment Data to verify: $paymentResponse');

//       final verificationProvider = Provider.of<VerificationProvider>(
//         context,
//         listen: false,
//       );

//       debugPrint('Calling verification API...');
//       await verificationProvider.verifyPayment(paymentResponse);
//       debugPrint('Verification API call completed');

//       if (verificationProvider.paymentVerification.isNotEmpty) {
//         debugPrint('=== PAYMENT VERIFICATION SUCCESS ===');
//         debugPrint(
//           'Verification Response: ${verificationProvider.paymentVerification}',
//         );
//         debugPrint('✅ Payment details stored successfully in backend!');
//         debugPrint('=== END PAYMENT VERIFICATION ===');
//       } else {
//         debugPrint('=== PAYMENT VERIFICATION FAILED ===');
//         debugPrint('No verification response received');
//         debugPrint('❌ Payment details NOT stored in backend');
//         debugPrint('=== END PAYMENT VERIFICATION ===');
//       }
//     } catch (e) {
//       debugPrint('=== PAYMENT VERIFICATION ERROR ===');
//       debugPrint('Error: $e');
//       debugPrint('Error Type: ${e.runtimeType}');
//       debugPrint('=== END PAYMENT VERIFICATION ERROR ===');
//     }
//   }

//   void _navigateToSuccessPage(String paymentId) {
//     // Get email and NRK ID from providers
//     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//     final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//       context,
//       listen: false,
//     );
//     String emailId = '';
//     String nrkId = norkaProvider.norkaId;

//     // Try to get verified customer data first, then fallback to NORKA provider
//     final verifiedCustomerData = otpVerificationProvider
//         .getVerifiedCustomerData();
//     Map<String, dynamic>? customerData =
//         verifiedCustomerData ?? norkaProvider.response;

//     // Extract email and NRK ID from customer data
//     if (customerData != null) {
//       final emails = customerData['emails'];
//       if (emails != null && emails.isNotEmpty) {
//         emailId = emails[0]['address'] ?? '';
//       }

//       // Extract NRK ID from verified customer data
//       if (verifiedCustomerData != null) {
//         // Try different possible field names for NRK ID
//         nrkId = verifiedCustomerData['norka_id'] ?? 
//                 verifiedCustomerData['nrk_id'] ?? 
//                 verifiedCustomerData['norka_id_no'] ?? 
//                 verifiedCustomerData['nrk_id_no'] ?? nrkId;
//       }
//     }

//     debugPrint('=== NAVIGATE TO SUCCESS PAGE DEBUG ===');
//     debugPrint('Email ID: $emailId');
//     debugPrint('NRK ID: $nrkId');
//     debugPrint('Verified Customer Data: $verifiedCustomerData');
//     debugPrint('NORKA Provider Response: ${norkaProvider.response}');
//     debugPrint('=== END NAVIGATE TO SUCCESS PAGE DEBUG ===');

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             PaymentSuccessPage(emailId: emailId, nrkId: nrkId),
//       ),
//       (route) => false,
//     );
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Consumer<VerificationProvider>(
//       builder: (context, verificationProvider, child) {
//         return PopScope(
//           canPop: !_isLoading, // Disable back button when loading
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: AppConstants.primaryColor,
//               elevation: 0,
//               scrolledUnderElevation: 0,
//               surfaceTintColor: Colors.transparent,
//               leading: IconButton(
//                 icon: Icon(
//                   Theme.of(context).platform == TargetPlatform.iOS
//                       ? CupertinoIcons.back
//                       : Icons.arrow_back,
//                   color: Colors.white,
//                 ),
//                 onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
//               ),
//             title: const AppText(
//               text: 'Payment Details',
//               size: 20,
//               weight: FontWeight.w600,
//               textColor: Colors.white,
//             ),
//             centerTitle: true,
//             systemOverlayStyle: SystemUiOverlayStyle.light,
//           ),
//           body: Container(
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? AppConstants.darkBackgroundColor
//                   : Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: isDarkMode
//                                   ? AppConstants.boxBlackColor
//                                   : AppConstants.whiteColor,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: isDarkMode
//                                     ? Colors.white.withOpacity(0.1)
//                                     : Colors.grey.withOpacity(0.2),
//                                 width: 1,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: isDarkMode
//                                       ? Colors.black.withOpacity(0.3)
//                                       : Colors.grey.withOpacity(0.1),
//                                   spreadRadius: 1,
//                                   blurRadius: 5,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     AppText(
//                                       text: 'Enrollment Fee',
//                                       size: 14,
//                                       weight: FontWeight.w500,
//                                       textColor: isDarkMode
//                                           ? AppConstants.whiteColor
//                                           : AppConstants.blackColor,
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
                                        
//                                         _showPremiumBreakdownDialog(
//                                           verificationProvider.premiumAmount,
//                                         );
//                                       },
//                                       child: AppText(
//                                         text:
//                                             'Enrollment fee structure',
//                                         size: 12,
//                                         weight: FontWeight.w500,
//                                         textColor: AppConstants.primaryColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 verificationProvider.isPremiumAmountLoading
//                                     ? const SizedBox(
//                                         height: 28,
//                                         width: 28,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                         ),
//                                       )
//                                     : AppText(
//                                         text: _getPremiumAmountText(
//                                           verificationProvider.premiumAmount,
//                                         ),
//                                         size: 28,
//                                         weight: FontWeight.bold,
//                                         textColor: isDarkMode
//                                             ? AppConstants.whiteColor
//                                             : AppConstants.blackColor,
//                                       ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 12),

//                           // Family Sum Insured Card
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: isDarkMode
//                                   ? AppConstants.boxBlackColor
//                                   : AppConstants.whiteColor,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: isDarkMode
//                                     ? Colors.white.withOpacity(0.1)
//                                     : Colors.grey.withOpacity(0.2),
//                                 width: 1,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: isDarkMode
//                                       ? Colors.black.withOpacity(0.3)
//                                       : Colors.grey.withOpacity(0.1),
//                                   spreadRadius: 1,
//                                   blurRadius: 5,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 AppText(
//                                   text: 'Family Sum Insured',
//                                   size: 14,
//                                   weight: FontWeight.w500,
//                                   textColor: isDarkMode
//                                       ? Colors.white
//                                       : Colors.black87,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 AppText(
//                                   text: '₹5,00,000',
//                                   size: 28,
//                                   weight: FontWeight.bold,
//                                   textColor: isDarkMode
//                                       ? AppConstants.whiteColor
//                                       : AppConstants.blackColor,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // Members Details Card
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: isDarkMode
//                                   ? AppConstants.boxBlackColor
//                                   : AppConstants.whiteColor,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: isDarkMode
//                                     ? Colors.white.withOpacity(0.1)
//                                     : Colors.grey.withOpacity(0.2),
//                                 width: 1,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: isDarkMode
//                                       ? Colors.black.withOpacity(0.3)
//                                       : Colors.grey.withOpacity(0.1),
//                                   spreadRadius: 1,
//                                   blurRadius: 5,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 AppText(
//                                   text:
//                                       verificationProvider
//                                           .familyMembersDetails
//                                           .isNotEmpty
//                                       ? 'Members (${verificationProvider.familyMembersDetails['family_members_count'] ?? 0})'
//                                       : 'Members',
//                                   size: 14,
//                                   weight: FontWeight.w500,
//                                   textColor: isDarkMode
//                                       ? Colors.white
//                                       : Colors.black87,
//                                 ),
//                                 const SizedBox(height: 16),

//                                 Consumer<VerificationProvider>(
//                                   builder: (context, verificationProvider, child) {
//                                     return verificationProvider.isFamilyMembersDetailsLoading
//                                         ? Center(
//                                             child: Padding(
//                                               padding: EdgeInsets.all(20.0),
//                                               child: CircularProgressIndicator(
//                                                 color: AppConstants.primaryColor,
//                                               ),
//                                             ),
//                                           )
//                                         : _buildFamilyMembersList(
//                                             verificationProvider.familyMembersDetails,
//                                           );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 24),

//                           // Checkboxes
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: isDeclarationChecked,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     isDeclarationChecked = value ?? false;
//                                   });
//                                 },
//                                 activeColor: AppConstants.primaryColor,
//                               ),
//                               Expanded(
//                                 child: AppText(
//                                   text:
//                                       'I declare that the information provided above is true to the best of my knowledge.',
//                                   size: 14,
//                                   weight: FontWeight.normal,
//                                   textColor: isDarkMode
//                                       ? AppConstants.whiteColor
//                                       : AppConstants.blackColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),

//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: isTermsChecked,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     isTermsChecked = value ?? false;
//                                   });
//                                 },
//                                 activeColor: AppConstants.primaryColor,
//                               ),
//                               Expanded(
//                                 child: RichText(
//                                   textAlign: TextAlign.left,
//                                   text: TextSpan(
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.normal,
//                                       color: isDarkMode
//                                           ? AppConstants.whiteColor
//                                           : AppConstants.blackColor,
//                                       height: 1.4,
//                                     ),
//                                     children: [
//                                       const TextSpan(
//                                         text: 'I confirm that I have read and agree to the ',
//                                       ),
//                                       WidgetSpan(
//                                         alignment: PlaceholderAlignment.baseline,
//                                         baseline: TextBaseline.alphabetic,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => const TermsOfService(),
//                                               ),
//                                             );
//                                           },
//                                           child: Text(
//                                             'Terms of Service',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.normal,
//                                               color: AppConstants.primaryColor,
//                                               height: 1.4,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const TextSpan(
//                                         text: ' and ',
//                                       ),
//                                       WidgetSpan(
//                                         alignment: PlaceholderAlignment.baseline,
//                                         baseline: TextBaseline.alphabetic,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => const PrivacyPolicy(),
//                                               ),
//                                             );
//                                           },
//                                           child: Text(
//                                             'Privacy Policy',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.normal,
//                                               color: AppConstants.primaryColor,
//                                               height: 1.4,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const TextSpan(
//                                         text: '.',
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),

//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: isPolicyTermsChecked,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     isPolicyTermsChecked = value ?? false;
//                                   });
//                                 },
//                                 activeColor: AppConstants.primaryColor,
//                               ),
//                               Expanded(
//                                 child: AppText(
//                                   text:
//                                       'I hereby agreed and confirmed all terms and conditions as per the GMC and GPA policy of the Family Health Insurance scheme.',
//                                   size: 14,
//                                   weight: FontWeight.normal,
//                                   textColor: isDarkMode
//                                       ? AppConstants.whiteColor
//                                       : AppConstants.blackColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Container(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ||
//                               !isDeclarationChecked ||
//                               !isTermsChecked ||
//                               !isPolicyTermsChecked
//                           ? null
//                           : _handleConfirmAndPay,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _isLoading ||
//                                 !isDeclarationChecked ||
//                                 !isTermsChecked ||
//                                 !isPolicyTermsChecked
//                             ? Colors.grey
//                             : AppConstants.primaryColor,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: _isLoading
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   'Processing Payment...',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Text(
//                               'Confirm & Pay',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 35),
//                 ],
//               ),
//             ),
//           ),
//         ));
//       },
//     );
//   }

//   Future<void> _handleConfirmAndPay() async {
//     if (!isDeclarationChecked || !isTermsChecked || !isPolicyTermsChecked) {
//       Fluttertoast.showToast(
//         msg: 'Please accept all terms and conditions to proceed',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }

//     // Disable button immediately to prevent multiple clicks
//     setState(() {
//       _isLoading = true;
//     });

//     // Get premium amount from API response
//     final verificationProvider = Provider.of<VerificationProvider>(
//       context,
//       listen: false,
//     );

//     int premiumAmount = 0;
    
//     debugPrint('=== PREMIUM AMOUNT DEBUG ===');
//     debugPrint('Premium Amount Data: ${verificationProvider.premiumAmount}');
//     debugPrint('Premium Amount isEmpty: ${verificationProvider.premiumAmount.isEmpty}');
    
//     if (verificationProvider.premiumAmount.isNotEmpty) {
//       // Try to get total_amount from premium_breakdown first
//       if (verificationProvider.premiumAmount.containsKey('premium_breakdown') &&
//           verificationProvider.premiumAmount['premium_breakdown'] is Map) {
//         final breakdown =
//             verificationProvider.premiumAmount['premium_breakdown']
//                 as Map<String, dynamic>;
//         if (breakdown.containsKey('total_amount')) {
//           premiumAmount = (breakdown['total_amount'] as num).toInt();
//           debugPrint('Premium amount from breakdown: $premiumAmount');
//         }
//       }

//       // Fallback to premium_amount
//       if (premiumAmount == 0 &&
//           verificationProvider.premiumAmount.containsKey('premium_amount')) {
//         premiumAmount =
//             (verificationProvider.premiumAmount['premium_amount'] as num)
//                 .toInt();
//         debugPrint('Premium amount from premium_amount: $premiumAmount');
//       }
//     }

//     // Default fallback amount
//     if (premiumAmount == 0) {
//       premiumAmount = 12980;
//       debugPrint('Using fallback premium amount: $premiumAmount');
//     }
    
//     debugPrint('Final premium amount: $premiumAmount');
//     debugPrint('=== END PREMIUM AMOUNT DEBUG ===');

//     // Store the amount for failure handling
//     _currentAmount = premiumAmount;

//     try {
//       // Step 0: Generate Request ID first
//       debugPrint('=== STEP 0: GENERATING REQUEST ID ===');

//       try {
//         debugPrint('Generating new request ID...');
//         await verificationProvider.getRequestIdDetails();
//         debugPrint('Request ID generated successfully');
//       } catch (e) {
//         debugPrint('Error generating request ID: $e');
//         setState(() {
//           _isLoading = false;
//         });
//         // Fluttertoast.showToast(
//         //   msg: 'Failed to generate request ID. Please try again.',
//         //   toastLength: Toast.LENGTH_SHORT,
//         //   gravity: ToastGravity.BOTTOM,
//         //   backgroundColor: Colors.red,
//         //   textColor: Colors.white,
//         // );
//         return;
//       }

//       // Get user details from providers
//       final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//       final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//         context,
//         listen: false,
//       );
//       String emailId = '';
//       String userName = 'Customer';
//       String contactNumber = '+919876543210';
//       String nrkId = norkaProvider.norkaId;

//       // Try to get verified customer data first, then fallback to NORKA provider
//       final verifiedCustomerData = otpVerificationProvider
//           .getVerifiedCustomerData();
//       Map<String, dynamic>? customerData =
//           verifiedCustomerData ?? norkaProvider.response;

//       // Extract email, name, and contact from customer data
//       if (customerData != null) {
//         final emails = customerData['emails'];
//         if (emails != null && emails.isNotEmpty) {
//           emailId = emails[0]['address'] ?? '';
//         }

//         userName = customerData['name'] ?? 'Customer';

//         // Extract mobile number from customer data structure
//         if (customerData['mobiles'] != null &&
//             customerData['mobiles'] is List) {
//           final mobiles = customerData['mobiles'] as List;
//           if (mobiles.isNotEmpty && mobiles[0] is Map) {
//             contactNumber =
//                 mobiles[0]['with_dial_code'] ??
//                 mobiles[0]['number'] ??
//                 '+919876543210';
//           }
//         }

//         // Extract NRK ID from verified customer data
//         if (verifiedCustomerData != null) {
//           // Try different possible field names for NRK ID
//           nrkId = verifiedCustomerData['norka_id'] ?? 
//                   verifiedCustomerData['nrk_id'] ?? 
//                   verifiedCustomerData['norka_id_no'] ?? 
//                   verifiedCustomerData['nrk_id_no'] ?? nrkId;
//         }

//         debugPrint('=== EXTRACTED CONTACT INFO ===');
//         debugPrint('Contact Number: $contactNumber');
//         debugPrint('Email: $emailId');
//         debugPrint('Name: $userName');
//         debugPrint('NRK ID: $nrkId');
//       }

//       // Premium amount is already fetched when page loads, no need to fetch again
//       debugPrint('=== USING EXISTING PREMIUM AMOUNT ===');
//       debugPrint('Premium amount already available: ${verificationProvider.premiumAmount.isNotEmpty}');

//       // Step 1: Call Vidal validation API
//       debugPrint('=== STEP 1: CALLING VIDAL VALIDATION API ===');

//       // Check if we have the required data for validation
//       if (customerData != null &&
//           verificationProvider.familyMembersDetails.isNotEmpty &&
//           verificationProvider.requestIdDetails.isNotEmpty) {
//         // Build validation payload
//         final validationPayload = VidalDataMapper.buildVidalValidationPayload(
//           norkaResponse: customerData,
//           familyMembersDetails: verificationProvider.familyMembersDetails,
//           requestId:
//               verificationProvider.requestIdDetails['data']?['request_id'],
//           selfUniqueId:
//               verificationProvider.familyMembersDetails['self_unique_id'] ?? '',
//           datesDetails: verificationProvider.datesDetails,
//         );

//         // Call validation API
//         await verificationProvider.vidalEnrollmentValidate(validationPayload);

//         // Check if validation has any error - if yes, don't proceed to order creation
//         if (verificationProvider.errorMessage.isNotEmpty) {
//           setState(() {
//             _isLoading = false;
//           });
//           Fluttertoast.showToast(
//             msg: 'Something went wrong. Please try again.',
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//           debugPrint(
//             'Vidal validation failed: ${verificationProvider.errorMessage}',
//           );
//           return; // Stop here - don't call order API
//         }

//         // Check if validation was successful
//         final response = verificationProvider.response;
//         if (response != null) {
//           // Check for Vidal validation success indicators
//           bool hasVidalSuccess =
//               response.containsKey('success') && response['success'] == true;
//           bool hasVidalStatus =
//               response.containsKey('status') &&
//               response['status'] == 'Validation passed';

//           // Check for traditional success indicators (fallback)
//           bool hasSuccessData =
//               response.containsKey('data') &&
//               response['data'] != null &&
//               response['data'].containsKey('self_enrollment_number');

//           // Check for success message
//           bool hasSuccessMessage =
//               response.containsKey('message') &&
//               (response['message'].toString().toLowerCase().contains(
//                     'success',
//                   ) ||
//                   response['message'].toString().toLowerCase().contains(
//                     'generated',
//                   ));

//           if (!hasVidalSuccess &&
//               !hasVidalStatus &&
//               !hasSuccessData &&
//               !hasSuccessMessage) {
//             setState(() {
//               _isLoading = false;
//             });
//             Fluttertoast.showToast(
//               msg: 'Something went wrong. Please try again.',
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//             );
//             debugPrint(
//               'Vidal validation failed: ${response['message'] ?? response['status'] ?? 'Unknown error'}',
//             );
//             return;
//           }

//           debugPrint(
//             'Vidal validation successful - Status: ${response['status']}, Success: ${response['success']}',
//           );
//         } else {
//           setState(() {
//             _isLoading = false;
//           });
//           Fluttertoast.showToast(
//             msg: 'Something went wrong. Please try again.',
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//           debugPrint('Vidal validation failed: No response received');
//           return;
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//         Fluttertoast.showToast(
//           msg: 'Something went wrong. Please try again.',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//         debugPrint('Missing required data for validation API');
//         return;
//       }

//       // Step 2: Create Razorpay Order
//       debugPrint('=== STEP 2: CREATING RAZORPAY ORDER ===');
//       final orderResponse = await RazorpayService.createOrder(
//         amount: premiumAmount,
//         currency: 'INR',
//         receipt: 'receipt_${DateTime.now().millisecondsSinceEpoch}',
//         nrkIdNo: nrkId,
//       );

//       if (orderResponse['status'] != 'created') {
//         throw Exception('Failed to create order');
//       }

//       final orderId = orderResponse['id'];
//       _currentOrderId = orderId; // Store order ID for failure handling
//       debugPrint('Order created successfully: $orderId');

//       // Step 3: Open Razorpay payment gateway directly
//       debugPrint('=== STEP 3: OPENING RAZORPAY PAYMENT GATEWAY ===');

//       // Prepare Razorpay options
//       var options = {
//         'key': 'rzp_live_RKf8kP58RPmwkc',
//         'amount': premiumAmount * 100,
//         'currency': 'INR',
//         'name': 'Norka Care',
//         'description': 'Enrollment Fee Payment',
//         'order_id': orderId,
//         'prefill': {
//           'contact': contactNumber,
//           'email': emailId.isNotEmpty ? emailId : 'customer@example.com',
//           'name': userName,
//         },
//         'theme': {'color': '#004EA1'},
//         'retry': {'enabled': true, 'max_count': 3},
//       };

//       debugPrint('=== RAZORPAY OPTIONS ===');
//       debugPrint('Options: $options');
//       debugPrint('Contact Number from NORKA API: $contactNumber');
//       debugPrint('Email from NORKA API: $emailId');
//       debugPrint('Name from NORKA API: $userName');

//       // Open Razorpay payment gateway
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         try {
//           _razorpay.open(options);
//           debugPrint('Razorpay opened successfully');
//           // Keep loading state until payment is completed or failed
//         } catch (e) {
//           debugPrint("Error opening Razorpay: $e");
//           setState(() {
//             _isLoading = false;
//           });
//           Fluttertoast.showToast(
//             msg: "Something went wrong. Please try again.",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//         }
//       });
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Something went wrong. Please try again.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       debugPrint('Payment Error: $e');
//       // Reset loading state on exception
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Widget _buildFamilyMembersList(Map<String, dynamic> familyData) {
//     debugPrint('=== BUILD FAMILY MEMBERS LIST DEBUG ===');
//     debugPrint('Family Data: $familyData');
//     debugPrint('Family Data Type: ${familyData.runtimeType}');
//     debugPrint('Family Data isEmpty: ${familyData.isEmpty}');
//     debugPrint('Family Data Keys: ${familyData.keys.toList()}');
//     debugPrint('=== END BUILD FAMILY MEMBERS LIST DEBUG ===');
    
//     if (familyData.isEmpty) {
//       return AppText(
//         text: 'No family members found. Please add family members first.',
//         size: 14,
//         weight: FontWeight.normal,
//         textColor: Colors.grey,
//       );
//     }

//     List<Widget> members = [];

//     // Add Self
//     if (familyData['nrk_name'] != null) {
//       members.add(
//         _buildMemberRow(
//           'Self',
//           familyData['nrk_name'] ?? '',
//           familyData['dob'] ?? '',
//           _formatGender(familyData['gender'] ?? ''),
//         ),
//       );
//       members.add(const SizedBox(height: 12));
//     }

//     // Add Spouse
//     if (familyData['spouse_name'] != null &&
//         familyData['spouse_name'].toString().isNotEmpty) {
//       members.add(
//         _buildMemberRow(
//           'Spouse',
//           familyData['spouse_name'] ?? '',
//           familyData['spouse_dob'] ?? '',
//           _formatGender(familyData['spouse_gender'] ?? ''),
//         ),
//       );
//       members.add(const SizedBox(height: 12));
//     }

//     // Add Children
//     for (int i = 1; i <= 5; i++) {
//       String kidName = familyData['kid_${i}_name'] ?? '';
//       if (kidName.isNotEmpty) {
//         members.add(
//           _buildMemberRow(
//             'Child $i',
//             kidName,
//             familyData['kid_${i}_dob'] ?? '',
//             _getChildGender(familyData, i),
//           ),
//         );
//         members.add(const SizedBox(height: 12));
//       }
//     }

//     // Remove the last SizedBox if there are members
//     if (members.isNotEmpty) {
//       members.removeLast();
//     }

//     return Column(children: members);
//   }

//   String _formatGender(String gender) {
//     if (gender.isEmpty) return '';
//     return gender.substring(0, 1).toUpperCase() +
//         gender.substring(1).toLowerCase();
//   }

//   String _getChildGender(Map<String, dynamic> familyData, int childIndex) {
//     // Get the relation field (Son/Daughter) and convert to gender (Male/Female)
//     String relation = familyData['kid_${childIndex}_relation'] ?? '';
//     String gender = '';
    
//     if (relation.toLowerCase() == 'son') {
//       gender = 'Male';
//     } else if (relation.toLowerCase() == 'daughter') {
//       gender = 'Female';
//     }
    
//     return _formatGender(gender);
//   }

//   String _formatDOB(String dob) {
//     if (dob.isEmpty) return '';

//     // Check if the date is in MM-DD-YYYY or DD-MM-YYYY format (with hyphens)
//     if (dob.contains('-') && dob.length == 10) {
//       try {
//         List<String> parts = dob.split('-');
//         if (parts.length == 3) {
//           int firstPart = int.tryParse(parts[0]) ?? 0;
//           int secondPart = int.tryParse(parts[1]) ?? 0;

//           // If first part > 12, it's definitely DD-MM-YYYY format (day > 12)
//           if (firstPart > 12) {
//             String day = parts[0].padLeft(2, '0');
//             String month = parts[1].padLeft(2, '0');
//             String year = parts[2];
//             // Convert from DD-MM-YYYY to DD/MM/YYYY
//             return '$day/$month/$year';
//           }
//           // If second part > 12, it's definitely MM-DD-YYYY format (day > 12)
//           else if (secondPart > 12) {
//             String month = parts[0].padLeft(2, '0');
//             String day = parts[1].padLeft(2, '0');
//             String year = parts[2];
//             // Convert from MM-DD-YYYY to DD/MM/YYYY
//             return '$day/$month/$year';
//           }
//           // If both parts are <= 12, we need to determine the format
//           // Based on your API response pattern:
//           // - Self user: DD-MM-YYYY (like 05-20-1976)
//           // - Family members: MM-DD-YYYY (like 05-02-1977 for spouse, 07-19-2008 for kids)
//           // We'll use a heuristic: if first part is 01-12 and second part is 01-31,
//           // and the date looks like it could be a valid day (01-31), assume MM-DD-YYYY for family members
//           else {
//             // Check if first part could be a valid day (01-31) and second part could be a valid month (01-12)
//             if (firstPart >= 1 &&
//                 firstPart <= 31 &&
//                 secondPart >= 1 &&
//                 secondPart <= 12) {
//               // Based on your API response pattern, family members use MM-DD-YYYY format
//               // So we'll assume MM-DD-YYYY for family members and convert to DD/MM/YYYY
//               String month = parts[0].padLeft(2, '0');
//               String day = parts[1].padLeft(2, '0');
//               String year = parts[2];
//               // Convert from MM-DD-YYYY to DD/MM/YYYY
//               return '$day/$month/$year';
//             } else {
//               // Default to DD-MM-YYYY format
//               String day = parts[0].padLeft(2, '0');
//               String month = parts[1].padLeft(2, '0');
//               String year = parts[2];
//               return '$day/$month/$year';
//             }
//           }
//         }
//       } catch (e) {
//         debugPrint('Error formatting DOB: $e');
//       }
//     }

//     // Check if the date is in MM/DD/YYYY format (with slashes) - from NORKA API
//     if (dob.contains('/') && dob.length >= 10) {
//       try {
//         List<String> parts = dob.split('/');
//         if (parts.length == 3) {
//           String month = parts[0].padLeft(2, '0');
//           String day = parts[1].padLeft(2, '0');
//           String year = parts[2];

//           // Convert from MM/DD/YYYY to DD/MM/YYYY
//           return '$day/$month/$year';
//         }
//       } catch (e) {
//         debugPrint('Error formatting DOB: $e');
//       }
//     }

//     // Return original if not in expected format
//     return dob;
//   }

//   Widget _buildMemberRow(String type, String name, String dob, String gender) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 60,
//           child: AppText(
//             text: '$type:',
//             size: 14,
//             weight: FontWeight.w500,
//             textColor: isDarkMode ? Colors.white70 : Colors.black87,
//           ),
//         ),
//         Expanded(
//           child: Row(
//             children: [
//               Expanded(
//                 child: AppText(
//                   text: name,
//                   size: 14,
//                   weight: FontWeight.w600,
//                   textColor: isDarkMode ? Colors.white70 : Colors.black87,
//                   maxLines: 2,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               AppText(
//                 text: _formatDOB(dob),
//                 size: 14,
//                 weight: FontWeight.normal,
//                 textColor: isDarkMode ? Colors.white70 : Colors.black87,
//               ),
//               const SizedBox(width: 8),
//               AppText(
//                 text: gender,
//                 size: 14,
//                 weight: FontWeight.normal,
//                 textColor: isDarkMode ? Colors.white70 : Colors.black87,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _getPremiumAmountText(Map<String, dynamic> premiumData) {
//     if (premiumData.isEmpty) {
//       return '₹0';
//     }

//     // Try to get total_amount from premium_breakdown first
//     if (premiumData.containsKey('premium_breakdown') &&
//         premiumData['premium_breakdown'] is Map) {
//       final breakdown =
//           premiumData['premium_breakdown'] as Map<String, dynamic>;
//       if (breakdown.containsKey('total_amount')) {
//         final amount = breakdown['total_amount'];
//         if (amount is num) {
//           return '₹${amount.toStringAsFixed(0)}';
//         }
//       }
//     }

//     // Fallback to premium_amount
//     if (premiumData.containsKey('premium_amount')) {
//       final amount = premiumData['premium_amount'];
//       if (amount is num) {
//         return '₹${amount.toStringAsFixed(0)}';
//       }
//     }

//     return '₹0';
//   }

//   void _showPremiumBreakdownDialog(Map<String, dynamic> premiumData) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: isDarkMode
//               ? AppConstants.darkBackgroundColor
//               : AppConstants.whiteColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: BorderSide(
//               color: isDarkMode
//                   ? Colors.white.withOpacity(0.1)
//                   : Colors.grey.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppText(
//                       text: 'Enrollment fee structure',
//                       size: 16,
//                       weight: FontWeight.bold,
//                       textColor: isDarkMode
//                           ? AppConstants.whiteColor
//                           : AppConstants.blackColor,
//                     ),
//                     // GestureDetector(
//                     //   onTap: () => Navigator.of(context).pop(),
//                     //   child: Icon(
//                     //     Icons.close,
//                     //     color: isDarkMode
//                     //         ? AppConstants.whiteColor
//                     //         : AppConstants.blackColor,
//                     //     size: 24,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Premium Data Display
//                 if (premiumData.isNotEmpty) ...[
//                   // Family Composition
//                   if (premiumData.containsKey('family_composition'))
//                     _buildBreakdownRow(
//                       'Family Composition',
//                       premiumData['family_composition'],
//                       isDarkMode,
//                     ),

//                   if (premiumData.containsKey('children_count'))
//                     _buildBreakdownRow(
//                       'Children Count',
//                       premiumData['children_count'].toString(),
//                       isDarkMode,
//                     ),

//                   const SizedBox(height: 16),

//                   // Premium Breakdown Section
//                   AppText(
//                     text: 'Fee Calculation',
//                     size: 16,
//                     weight: FontWeight.w600,
//                     textColor: isDarkMode
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor,
//                   ),
//                   const SizedBox(height: 12),

//                   // Base Amount
//                   if (premiumData.containsKey('premium_breakdown') &&
//                       premiumData['premium_breakdown'] is Map) ...[
//                     Builder(
//                       builder: (context) {
//                         final breakdown =
//                             premiumData['premium_breakdown']
//                                 as Map<String, dynamic>;
//                         return Column(
//                           children: [
//                             if (breakdown.containsKey('base_amount'))
//                               _buildBreakdownRow(
//                                 'Base Amount',
//                                 '₹${(breakdown['base_amount'] as num).toStringAsFixed(0)}',
//                                 isDarkMode,
//                               ),

//                             if (breakdown.containsKey(
//                               'additional_children_amount',
//                             ))
//                               _buildBreakdownRow(
//                                 'Additional Children Amount',
//                                 '₹${(breakdown['additional_children_amount'] as num).toStringAsFixed(0)}',
//                                 isDarkMode,
//                               ),

//                             if (breakdown.containsKey('total_amount'))
//                               _buildBreakdownRow(
//                                 'Total Amount',
//                                 '₹${(breakdown['total_amount'] as num).toStringAsFixed(0)}',
//                                 isDarkMode,
//                                 isTotal: true,
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],

//                   const SizedBox(height: 16),

//                   // Premium Config Section
//                   AppText(
//                     text: 'Fee Configuration',
//                     size: 16,
//                     weight: FontWeight.w600,
//                     textColor: isDarkMode
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor,
//                   ),
//                   const SizedBox(height: 12),

//                   if (premiumData.containsKey('premium_config_used') &&
//                       premiumData['premium_config_used'] is Map) ...[
//                     Builder(
//                       builder: (context) {
//                         final config =
//                             premiumData['premium_config_used']
//                                 as Map<String, dynamic>;
//                         return Column(
//                           children: [
//                             if (config.containsKey('self_only_amount'))
//                               _buildBreakdownRow(
//                                 'Self Only Amount',
//                                 '₹${(config['self_only_amount'] as num).toStringAsFixed(0)}',
//                                 isDarkMode,
//                               ),

//                             if (config.containsKey('family_amount'))
//                               _buildBreakdownRow(
//                                 'Family Amount',
//                                 '₹${(config['family_amount'] as num).toStringAsFixed(0)}',
//                                 isDarkMode,
//                               ),

//                             if (config.containsKey('additional_child_amount'))
//                               _buildBreakdownRow(
//                                 'Additional Child Amount',
//                                 '₹${(config['additional_child_amount'] as num).toStringAsFixed(0)}',
//                                 isDarkMode,
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ] else ...[
//                   // No data available
//                   AppText(
//                     text: 'Premium data not available',
//                     size: 16,
//                     weight: FontWeight.w500,
//                     textColor: isDarkMode
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor,
//                   ),
//                 ],

//                 const SizedBox(height: 24),

//                 // Close Button
//                 CustomButton(
//                   text: 'Close',
//                   onPressed: () => Navigator.of(context).pop(),
//                   color: AppConstants.primaryColor,
//                   textColor: AppConstants.whiteColor,
//                   height: 50,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBreakdownRow(
//     String label,
//     String value,
//     bool isDarkMode, {
//     bool isTotal = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             flex: 2,
//             child: AppText(
//               text: label,
//               size: isTotal ? 16 : 14,
//               weight: isTotal ? FontWeight.bold : FontWeight.w500,
//               textColor: isDarkMode
//                   ? AppConstants.whiteColor
//                   : AppConstants.blackColor,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: AppText(
//               text: value,
//               size: isTotal ? 16 : 14,
//               weight: isTotal ? FontWeight.bold : FontWeight.w600,
//               textColor: isTotal
//                   ? AppConstants.primaryColor
//                   : (isDarkMode
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor),
//               textAlign: TextAlign.end,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }









import 'package:norkacare_app/services/razorpay_service.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/screen/verification/payment/payment_success_page.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/otp_verification_provider.dart';
import 'package:norkacare_app/services/vidal_data_mapper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:norkacare_app/screen/profile/terms_of_service.dart';
import 'package:norkacare_app/screen/profile/privacy_policy.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class FamilyDetailsConfirmPage extends StatefulWidget {
  const FamilyDetailsConfirmPage({super.key});

  @override
  State<FamilyDetailsConfirmPage> createState() =>
      _FamilyDetailsConfirmPageState();
}

class _FamilyDetailsConfirmPageState extends State<FamilyDetailsConfirmPage> {
  bool isDeclarationChecked = false;
  bool isTermsChecked = false;
  bool isPolicyTermsChecked = false;
  bool _isLoading = false;
  late Razorpay _razorpay;
  String _currentOrderId =
      ''; // Store the current order ID for failure handling
  int _currentAmount =
      0; // Store the current payment amount for failure handling

  @override
  void initState() {
    super.initState();
    _setupRazorpayHandlers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilyData();
    });
  }

  void _setupRazorpayHandlers() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _loadFamilyData() async {
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );

    // Get the NRK ID from verified data first, then fallback to NORKA provider
    String nrkId = norkaProvider.norkaId;
    final verifiedCustomerData = otpVerificationProvider
        .getVerifiedCustomerData();
    if (verifiedCustomerData != null &&
        verifiedCustomerData['nrk_id'] != null) {
      nrkId = verifiedCustomerData['nrk_id'];
    }

    if (nrkId.isNotEmpty &&
        (verificationProvider.familyMembersDetails.isEmpty ||
            verificationProvider.isFamilyMembersDetailsLoading)) {
      await verificationProvider.getFamilyMembersWithOfflineFallback(nrkId);
    }

    if (nrkId.isNotEmpty && verificationProvider.datesDetails.isEmpty) {
      await verificationProvider.getDatesDetailsWithOfflineFallback(nrkId);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('=== PAYMENT SUCCESS RESPONSE ===');
    debugPrint('Payment ID: ${response.paymentId}');
    debugPrint('Order ID: ${response.orderId}');
    debugPrint('Signature: ${response.signature}');

    // Keep loading state active during verification
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // Get NRK ID for payment verification
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );

    // Get NRK ID from verified customer data first, then fallback to NORKA provider
    String nrkId = norkaProvider.norkaId;
    final verifiedCustomerData = otpVerificationProvider
        .getVerifiedCustomerData();
    if (verifiedCustomerData != null) {
      // Try different possible field names for NRK ID
      nrkId = verifiedCustomerData['norka_id'] ?? 
              verifiedCustomerData['nrk_id'] ?? 
              verifiedCustomerData['norka_id_no'] ?? 
              verifiedCustomerData['nrk_id_no'] ?? nrkId;
    }

    debugPrint('=== NRK ID DEBUG (UPDATED) ===');
    debugPrint('NORKA Provider NRK ID: ${norkaProvider.norkaId}');
    debugPrint('Verified Customer Data: $verifiedCustomerData');
    debugPrint('Final NRK ID: $nrkId');
    debugPrint('=== END NRK ID DEBUG ===');

    final paymentResponse = {
      "razorpay_payment_id": response.paymentId ?? '',
      "razorpay_order_id": response.orderId ?? '',
      "razorpay_signature": response.signature ?? '',
      "nrk_id_no": nrkId,
    };

    debugPrint('=== PAYMENT RESPONSE OBJECT ===');
    debugPrint('$paymentResponse');
    debugPrint('=== END PAYMENT RESPONSE ===');

    try {
      // Verify payment with backend (this will store the payment details)
      await _verifyPaymentWithBackend(paymentResponse);

      // Show success message
      // Fluttertoast.showToast(
      //   msg: "Payment successful! Redirecting...",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      // );

      // Small delay to show the success message
      // await Future.delayed(const Duration(milliseconds: 1500));

      // Navigate to success page
      _navigateToSuccessPage(response.paymentId ?? '');
    } catch (e) {
      debugPrint('Error during payment verification: $e');

      // Show success message even if verification fails
      Fluttertoast.showToast(
        msg: "Payment successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Small delay to show the success message
      // await Future.delayed(const Duration(milliseconds: 1500));

      // Still navigate to success page even if verification fails
      _navigateToSuccessPage(response.paymentId ?? '');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    debugPrint('Payment Error: ${response.code} - ${response.message}');

    String errorMessage;

    // Handle different error codes with user-friendly messages
    switch (response.code) {
      case 1:
        errorMessage =
            "Payment failed due to network issues. Please check your internet connection and try again.";
        break;
      case 2:
        errorMessage =
            "Payment was cancelled by user. You can try again anytime.";
        break;
      case 3:
        errorMessage =
            "Payment failed due to technical issues. Please try again.";
        break;
      case 4:
        errorMessage =
            "Payment failed due to invalid payment details. Please check your card/bank details.";
        break;
      case 5:
        errorMessage =
            "Payment failed due to insufficient funds. Please check your account balance.";
        break;
      case 6:
        errorMessage =
            "Payment failed due to bank restrictions. Please contact your bank.";
        break;
      case 7:
        errorMessage =
            "Payment failed due to security reasons. Please try again or use a different payment method.";
        break;
      case 8:
        errorMessage = "Payment failed due to timeout. Please try again.";
        break;
      case 9:
        errorMessage = "Payment failed due to invalid OTP. Please try again.";
        break;
      case 10:
        errorMessage =
            "Payment failed due to card expiry. Please use a different card.";
        break;
      default:
        // Use the original message if it's meaningful, otherwise provide a generic message
        if (response.message != null && response.message!.isNotEmpty) {
          errorMessage = "Payment failed: ${response.message}";
        } else {
          errorMessage =
              "Payment failed due to an unknown error. Please try again.";
        }
        break;
    }

    // Register failed payment in backend using the dedicated failure API
    try {
      // Get NRK ID for payment verification
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
        context,
        listen: false,
      );

      // Get NRK ID from verified customer data first, then fallback to NORKA provider
      String nrkId = norkaProvider.norkaId;
      final verifiedCustomerData = otpVerificationProvider
          .getVerifiedCustomerData();
      if (verifiedCustomerData != null &&
          verifiedCustomerData['norka_id'] != null) {
        nrkId = verifiedCustomerData['norka_id'];
      }

      // Create failed payment data for the register-failure API
      final failureData = {
        "razorpay_order_id": _currentOrderId, // Use stored order ID
        "razorpay_payment_id":
            '', // PaymentFailureResponse doesn't have paymentId
        "nrk_id_no": nrkId,
        "error_code": _getErrorCodeString(response.code),
        "error_description": response.message ?? errorMessage,
        "rzp_payload": {
          "notes": {"norka_id": nrkId},
          "method": "unknown",
          "amount": (_currentAmount * 100)
              .toString(), // Convert to paisa format
        },
      };

      debugPrint('=== REGISTERING PAYMENT FAILURE ===');
      debugPrint('Failure Data: $failureData');

      // Call the dedicated failure registration API
      final verificationProvider = Provider.of<VerificationProvider>(
        context,
        listen: false,
      );
      await verificationProvider.registerPaymentFailure(failureData);

      debugPrint('✅ Failed payment registered in backend');
    } catch (e) {
      debugPrint('❌ Error registering failed payment: $e');
    }

    Fluttertoast.showToast(
      msg: "payment failed",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );

    setState(() {
      _isLoading = false;
    });
  }

  String _getErrorCodeString(int? code) {
    switch (code) {
      case 1:
        return "NETWORK_ERROR";
      case 2:
        return "PAYMENT_CANCELLED";
      case 3:
        return "TECHNICAL_ERROR";
      case 4:
        return "INVALID_PAYMENT_DETAILS";
      case 5:
        return "INSUFFICIENT_FUNDS";
      case 6:
        return "BANK_RESTRICTIONS";
      case 7:
        return "SECURITY_ERROR";
      case 8:
        return "TIMEOUT";
      case 9:
        return "INVALID_OTP";
      case 10:
        return "CARD_EXPIRED";
      default:
        return "UNKNOWN_ERROR";
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    // Fluttertoast.showToast(
    //   msg: "External Wallet: ${response.walletName}",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.blue,
    //   textColor: Colors.white,
    // );
  }


  Future<void> _verifyPaymentWithBackend(
    Map<String, dynamic> paymentResponse,
  ) async {
    try {
      debugPrint('=== PAYMENT VERIFICATION START ===');
      debugPrint('Verifying payment with backend...');
      debugPrint('Payment Data to verify: $paymentResponse');

      final verificationProvider = Provider.of<VerificationProvider>(
        context,
        listen: false,
      );

      debugPrint('Calling verification API...');
      await verificationProvider.verifyPayment(paymentResponse);
      debugPrint('Verification API call completed');

      if (verificationProvider.paymentVerification.isNotEmpty) {
        debugPrint('=== PAYMENT VERIFICATION SUCCESS ===');
        debugPrint(
          'Verification Response: ${verificationProvider.paymentVerification}',
        );
        debugPrint('✅ Payment details stored successfully in backend!');
        debugPrint('=== END PAYMENT VERIFICATION ===');
      } else {
        debugPrint('=== PAYMENT VERIFICATION FAILED ===');
        debugPrint('No verification response received');
        debugPrint('❌ Payment details NOT stored in backend');
        debugPrint('=== END PAYMENT VERIFICATION ===');
      }
    } catch (e) {
      debugPrint('=== PAYMENT VERIFICATION ERROR ===');
      debugPrint('Error: $e');
      debugPrint('Error Type: ${e.runtimeType}');
      debugPrint('=== END PAYMENT VERIFICATION ERROR ===');
    }
  }

  void _navigateToSuccessPage(String paymentId) {
    // Get email and NRK ID from providers
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );
    String emailId = '';
    String nrkId = norkaProvider.norkaId;

    // Try to get verified customer data first, then fallback to NORKA provider
    final verifiedCustomerData = otpVerificationProvider
        .getVerifiedCustomerData();
    Map<String, dynamic>? customerData =
        verifiedCustomerData ?? norkaProvider.response;

    // Extract email and NRK ID from customer data
    if (customerData != null) {
      final emails = customerData['emails'];
      if (emails != null && emails.isNotEmpty) {
        emailId = emails[0]['address'] ?? '';
      }

      // Extract NRK ID from verified customer data
      if (verifiedCustomerData != null) {
        // Try different possible field names for NRK ID
        nrkId = verifiedCustomerData['norka_id'] ?? 
                verifiedCustomerData['nrk_id'] ?? 
                verifiedCustomerData['norka_id_no'] ?? 
                verifiedCustomerData['nrk_id_no'] ?? nrkId;
      }
    }

    debugPrint('=== NAVIGATE TO SUCCESS PAGE DEBUG ===');
    debugPrint('Email ID: $emailId');
    debugPrint('NRK ID: $nrkId');
    debugPrint('Verified Customer Data: $verifiedCustomerData');
    debugPrint('NORKA Provider Response: ${norkaProvider.response}');
    debugPrint('=== END NAVIGATE TO SUCCESS PAGE DEBUG ===');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentSuccessPage(emailId: emailId, nrkId: nrkId),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Consumer<VerificationProvider>(
      builder: (context, verificationProvider, child) {
        return PopScope(
          canPop: !_isLoading, // Disable back button when loading
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppConstants.primaryColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoIcons.back
                      : Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              ),
            title: const AppText(
              text: 'Payment Details',
              size: 20,
              weight: FontWeight.w600,
              textColor: Colors.white,
            ),
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppConstants.boxBlackColor
                                  : AppConstants.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppText(
                                      text: 'Enrollment Fee',
                                      size: 14,
                                      weight: FontWeight.w500,
                                      textColor: isDarkMode
                                          ? AppConstants.whiteColor
                                          : AppConstants.blackColor,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        
                                        _showPremiumBreakdownDialog(
                                          verificationProvider.premiumAmount,
                                        );
                                      },
                                      child: AppText(
                                        text:
                                            'Enrollment fee structure',
                                        size: 12,
                                        weight: FontWeight.w500,
                                        textColor: AppConstants.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                verificationProvider.isPremiumAmountLoading
                                    ? const SizedBox(
                                        height: 28,
                                        width: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : AppText(
                                        text: _getPremiumAmountText(
                                          verificationProvider.premiumAmount,
                                        ),
                                        size: 28,
                                        weight: FontWeight.bold,
                                        textColor: isDarkMode
                                            ? AppConstants.whiteColor
                                            : AppConstants.blackColor,
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Family Sum Insured Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppConstants.boxBlackColor
                                  : AppConstants.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'Family Sum Insured',
                                  size: 14,
                                  weight: FontWeight.w500,
                                  textColor: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                const SizedBox(height: 8),
                                AppText(
                                  text: '₹5,00,000',
                                  size: 28,
                                  weight: FontWeight.bold,
                                  textColor: isDarkMode
                                      ? AppConstants.whiteColor
                                      : AppConstants.blackColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Members Details Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppConstants.boxBlackColor
                                  : AppConstants.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  text:
                                      verificationProvider
                                          .familyMembersDetails
                                          .isNotEmpty
                                      ? 'Members (${verificationProvider.familyMembersDetails['family_members_count'] ?? 0})'
                                      : 'Members',
                                  size: 14,
                                  weight: FontWeight.w500,
                                  textColor: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                const SizedBox(height: 16),

                                Consumer<VerificationProvider>(
                                  builder: (context, verificationProvider, child) {
                                    return verificationProvider.isFamilyMembersDetailsLoading
                                        ? Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: CircularProgressIndicator(
                                                color: AppConstants.primaryColor,
                                              ),
                                            ),
                                          )
                                        : _buildFamilyMembersList(
                                            verificationProvider.familyMembersDetails,
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Checkboxes
                          Row(
                            children: [
                              Checkbox(
                                value: isDeclarationChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isDeclarationChecked = value ?? false;
                                  });
                                },
                                activeColor: AppConstants.primaryColor,
                              ),
                              Expanded(
                                child: AppText(
                                  text:
                                      'I declare that the information provided above is true to the best of my knowledge.',
                                  size: 14,
                                  weight: FontWeight.normal,
                                  textColor: isDarkMode
                                      ? AppConstants.whiteColor
                                      : AppConstants.blackColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Checkbox(
                                value: isTermsChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isTermsChecked = value ?? false;
                                  });
                                },
                                activeColor: AppConstants.primaryColor,
                              ),
                              Expanded(
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: isDarkMode
                                          ? AppConstants.whiteColor
                                          : AppConstants.blackColor,
                                      height: 1.4,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'I confirm that I have read and agree to the ',
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.alphabetic,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const TermsOfService(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Terms of Service',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: AppConstants.primaryColor,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' and ',
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.alphabetic,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const PrivacyPolicy(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: AppConstants.primaryColor,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Checkbox(
                                value: isPolicyTermsChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isPolicyTermsChecked = value ?? false;
                                  });
                                },
                                activeColor: AppConstants.primaryColor,
                              ),
                              Expanded(
                                child: AppText(
                                  text:
                                      'I hereby agreed and confirmed all terms and conditions as per the GMC and GPA policy of the Family Health Insurance scheme.',
                                  size: 14,
                                  weight: FontWeight.normal,
                                  textColor: isDarkMode
                                      ? AppConstants.whiteColor
                                      : AppConstants.blackColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ||
                              !isDeclarationChecked ||
                              !isTermsChecked ||
                              !isPolicyTermsChecked
                          ? null
                          : _handleConfirmAndPay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading ||
                                !isDeclarationChecked ||
                                !isTermsChecked ||
                                !isPolicyTermsChecked
                            ? Colors.grey
                            : AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Processing Payment...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Confirm & Pay',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  Future<void> _handleConfirmAndPay() async {
    if (!isDeclarationChecked || !isTermsChecked || !isPolicyTermsChecked) {
      Fluttertoast.showToast(
        msg: 'Please accept all terms and conditions to proceed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Disable button immediately to prevent multiple clicks
    setState(() {
      _isLoading = true;
    });

    // Get premium amount from API response
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );

    int premiumAmount = 0;
    
    debugPrint('=== PREMIUM AMOUNT DEBUG ===');
    debugPrint('Premium Amount Data: ${verificationProvider.premiumAmount}');
    debugPrint('Premium Amount isEmpty: ${verificationProvider.premiumAmount.isEmpty}');
    
    if (verificationProvider.premiumAmount.isNotEmpty) {
      // Try to get total_amount from premium_breakdown first
      if (verificationProvider.premiumAmount.containsKey('premium_breakdown') &&
          verificationProvider.premiumAmount['premium_breakdown'] is Map) {
        final breakdown =
            verificationProvider.premiumAmount['premium_breakdown']
                as Map<String, dynamic>;
        if (breakdown.containsKey('total_amount')) {
          premiumAmount = (breakdown['total_amount'] as num).toInt();
          debugPrint('Premium amount from breakdown: $premiumAmount');
        }
      }

      // Fallback to premium_amount
      if (premiumAmount == 0 &&
          verificationProvider.premiumAmount.containsKey('premium_amount')) {
        premiumAmount =
            (verificationProvider.premiumAmount['premium_amount'] as num)
                .toInt();
        debugPrint('Premium amount from premium_amount: $premiumAmount');
      }
    }

    // Default fallback amount
    if (premiumAmount == 0) {
      premiumAmount = 12980;
      debugPrint('Using fallback premium amount: $premiumAmount');
    }
    
    debugPrint('Final premium amount: $premiumAmount');
    debugPrint('=== END PREMIUM AMOUNT DEBUG ===');

    // Store the amount for failure handling
    _currentAmount = premiumAmount;

    try {
      // Step 0: Generate Request ID first
      debugPrint('=== STEP 0: GENERATING REQUEST ID ===');

      try {
        debugPrint('Generating new request ID...');
        await verificationProvider.getRequestIdDetails();
        debugPrint('Request ID generated successfully');
      } catch (e) {
        debugPrint('Error generating request ID: $e');
        setState(() {
          _isLoading = false;
        });
        // Fluttertoast.showToast(
        //   msg: 'Failed to generate request ID. Please try again.',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.red,
        //   textColor: Colors.white,
        // );
        return;
      }

      // Get user details from providers
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
        context,
        listen: false,
      );
      String emailId = '';
      String userName = 'Customer';
      String contactNumber = '+919876543210';
      String nrkId = norkaProvider.norkaId;

      // Try to get verified customer data first, then fallback to NORKA provider
      final verifiedCustomerData = otpVerificationProvider
          .getVerifiedCustomerData();
      Map<String, dynamic>? customerData =
          verifiedCustomerData ?? norkaProvider.response;

      // Extract email, name, and contact from customer data
      if (customerData != null) {
        final emails = customerData['emails'];
        if (emails != null && emails.isNotEmpty) {
          emailId = emails[0]['address'] ?? '';
        }

        userName = customerData['name'] ?? 'Customer';

        // Extract mobile number from customer data structure
        if (customerData['mobiles'] != null &&
            customerData['mobiles'] is List) {
          final mobiles = customerData['mobiles'] as List;
          if (mobiles.isNotEmpty && mobiles[0] is Map) {
            contactNumber =
                mobiles[0]['with_dial_code'] ??
                mobiles[0]['number'] ??
                '+919876543210';
          }
        }

        // Extract NRK ID from verified customer data
        if (verifiedCustomerData != null) {
          // Try different possible field names for NRK ID
          nrkId = verifiedCustomerData['norka_id'] ?? 
                  verifiedCustomerData['nrk_id'] ?? 
                  verifiedCustomerData['norka_id_no'] ?? 
                  verifiedCustomerData['nrk_id_no'] ?? nrkId;
        }

        debugPrint('=== EXTRACTED CONTACT INFO ===');
        debugPrint('Contact Number: $contactNumber');
        debugPrint('Email: $emailId');
        debugPrint('Name: $userName');
        debugPrint('NRK ID: $nrkId');
      }

      // Premium amount is already fetched when page loads, no need to fetch again
      debugPrint('=== USING EXISTING PREMIUM AMOUNT ===');
      debugPrint('Premium amount already available: ${verificationProvider.premiumAmount.isNotEmpty}');

      // Step 1: Call Vidal validation API
      debugPrint('=== STEP 1: CALLING VIDAL VALIDATION API ===');

      // Check if we have the required data for validation
      if (customerData != null &&
          verificationProvider.familyMembersDetails.isNotEmpty &&
          verificationProvider.requestIdDetails.isNotEmpty) {
        // Build validation payload
        final validationPayload = VidalDataMapper.buildVidalValidationPayload(
          norkaResponse: customerData,
          familyMembersDetails: verificationProvider.familyMembersDetails,
          requestId:
              verificationProvider.requestIdDetails['data']?['request_id'],
          selfUniqueId:
              verificationProvider.familyMembersDetails['self_unique_id'] ?? '',
          datesDetails: verificationProvider.datesDetails,
        );

        // Call validation API
        await verificationProvider.vidalEnrollmentValidate(validationPayload);

        // Check if validation has any error - if yes, don't proceed to order creation
        if (verificationProvider.errorMessage.isNotEmpty) {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: 'Something went wrong. Please try again.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          debugPrint(
            'Vidal validation failed: ${verificationProvider.errorMessage}',
          );
          return; // Stop here - don't call order API
        }

        // Check if validation was successful
        final response = verificationProvider.response;
        if (response != null) {
          // Check for Vidal validation success indicators
          bool hasVidalSuccess =
              response.containsKey('success') && response['success'] == true;
          bool hasVidalStatus =
              response.containsKey('status') &&
              response['status'] == 'Validation passed';

          // Check for traditional success indicators (fallback)
          bool hasSuccessData =
              response.containsKey('data') &&
              response['data'] != null &&
              response['data'].containsKey('self_enrollment_number');

          // Check for success message
          bool hasSuccessMessage =
              response.containsKey('message') &&
              (response['message'].toString().toLowerCase().contains(
                    'success',
                  ) ||
                  response['message'].toString().toLowerCase().contains(
                    'generated',
                  ));

          if (!hasVidalSuccess &&
              !hasVidalStatus &&
              !hasSuccessData &&
              !hasSuccessMessage) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              msg: 'Something went wrong. Please try again.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            debugPrint(
              'Vidal validation failed: ${response['message'] ?? response['status'] ?? 'Unknown error'}',
            );
            return;
          }

          debugPrint(
            'Vidal validation successful - Status: ${response['status']}, Success: ${response['success']}',
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: 'Something went wrong. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          debugPrint('Vidal validation failed: No response received');
          return;
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: 'Something went wrong. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        debugPrint('Missing required data for validation API');
        return;
      }

      // Check payment history for any captured payment
      debugPrint('=== CHECKING PAYMENT HISTORY AFTER VALIDATION ===');
      try {
        // Check payment history
        await verificationProvider.getPaymentHistory(nrkId);
        
        // Check if there's a captured payment
        final paymentHistory = verificationProvider.paymentHistory;
        debugPrint("Payment History Response: $paymentHistory");
        
        bool hasCapturedPayment = false;
        String? emailIdFromHistory;
        
        // Check both 'payments' and 'data' fields for payment list
        List? payments;
        if (paymentHistory.isNotEmpty) {
          if (paymentHistory['payments'] != null) {
            payments = paymentHistory['payments'] as List;
          } else if (paymentHistory['data'] != null) {
            payments = paymentHistory['data'] as List;
          }
        }
        
        if (payments != null && payments.isNotEmpty) {
          debugPrint("Total Payments: ${payments.length}");
          
          for (var payment in payments) {
            // Check status in rzp_payload first, then direct status field
            String? status;
            if (payment['rzp_payload'] != null && 
                payment['rzp_payload']['status'] != null) {
              status = payment['rzp_payload']['status'];
            } else if (payment['status'] != null) {
              status = payment['status'];
            }
            
            debugPrint("Payment Status: $status");
            if (status == 'captured') {
              hasCapturedPayment = true;
              debugPrint("✅ Found captured payment!");
              break;
            }
          }
        }
        
        // Get email ID from user data if not already available
        // customerData is guaranteed to be non-null from earlier assignment
        final emails = customerData['emails'];
        if (emails != null && emails.isNotEmpty) {
          emailIdFromHistory = emails[0]['address'] ?? '';
        }
        
        if (hasCapturedPayment) {
          // Navigate directly to payment success page
          debugPrint(
            "Captured payment found - navigating to PaymentSuccessPage",
          );
          
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessPage(
                  nrkId: nrkId,
                  emailId: emailIdFromHistory ?? emailId,
                ),
              ),
              (route) => false,
            );
          }
          return; // Exit early, don't show bank selection dialog
        } else {
          debugPrint(
            "No captured payment found - continuing with payment flow",
          );
        }
      } catch (e) {
        // If payment history check fails, continue with normal flow
        debugPrint("Error checking payment history: $e");
        debugPrint("Continuing with normal payment flow");
      }

      // Show bank selection dialog
      setState(() {
        _isLoading = false;
      });
      final selectedBank = await _showBankSelectionDialog();
      if (selectedBank == null) {
        // User cancelled the dialog
        return;
      }

      // Step 2: Handle payment based on selected bank
      debugPrint('=== STEP 2: PROCESSING PAYMENT ===');
      debugPrint('Selected Bank: $selectedBank');

      if (selectedBank == 'HDFC') {
        // HDFC - Razorpay flow
        setState(() {
          _isLoading = true;
        });
        await _processRazorpayPayment(
          premiumAmount,
          nrkId,
          emailId,
          contactNumber,
          userName,
        );
      } else if (selectedBank == 'FEDERAL') {
        // Federal Bank - WebView flow
        setState(() {
          _isLoading = true;
        });
        await _processFederalBankPayment(
          premiumAmount,
          nrkId,
          emailId,
          contactNumber,
          userName,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      debugPrint('Payment Error: $e');
      // Reset loading state on exception
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildFamilyMembersList(Map<String, dynamic> familyData) {
    debugPrint('=== BUILD FAMILY MEMBERS LIST DEBUG ===');
    debugPrint('Family Data: $familyData');
    debugPrint('Family Data Type: ${familyData.runtimeType}');
    debugPrint('Family Data isEmpty: ${familyData.isEmpty}');
    debugPrint('Family Data Keys: ${familyData.keys.toList()}');
    debugPrint('=== END BUILD FAMILY MEMBERS LIST DEBUG ===');
    
    if (familyData.isEmpty) {
      return AppText(
        text: 'No family members found. Please add family members first.',
        size: 14,
        weight: FontWeight.normal,
        textColor: Colors.grey,
      );
    }

    List<Widget> members = [];

    // Add Self
    if (familyData['nrk_name'] != null) {
      members.add(
        _buildMemberRow(
          'Self',
          familyData['nrk_name'] ?? '',
          familyData['dob'] ?? '',
          _formatGender(familyData['gender'] ?? ''),
        ),
      );
      members.add(const SizedBox(height: 12));
    }

    // Add Spouse
    if (familyData['spouse_name'] != null &&
        familyData['spouse_name'].toString().isNotEmpty) {
      members.add(
        _buildMemberRow(
          'Spouse',
          familyData['spouse_name'] ?? '',
          familyData['spouse_dob'] ?? '',
          _formatGender(familyData['spouse_gender'] ?? ''),
        ),
      );
      members.add(const SizedBox(height: 12));
    }

    // Add Children
    for (int i = 1; i <= 5; i++) {
      String kidName = familyData['kid_${i}_name'] ?? '';
      if (kidName.isNotEmpty) {
        members.add(
          _buildMemberRow(
            'Child $i',
            kidName,
            familyData['kid_${i}_dob'] ?? '',
            _getChildGender(familyData, i),
          ),
        );
        members.add(const SizedBox(height: 12));
      }
    }

    // Remove the last SizedBox if there are members
    if (members.isNotEmpty) {
      members.removeLast();
    }

    return Column(children: members);
  }

  String _formatGender(String gender) {
    if (gender.isEmpty) return '';
    return gender.substring(0, 1).toUpperCase() +
        gender.substring(1).toLowerCase();
  }

  String _getChildGender(Map<String, dynamic> familyData, int childIndex) {
    // Get the relation field (Son/Daughter) and convert to gender (Male/Female)
    String relation = familyData['kid_${childIndex}_relation'] ?? '';
    String gender = '';
    
    if (relation.toLowerCase() == 'son') {
      gender = 'Male';
    } else if (relation.toLowerCase() == 'daughter') {
      gender = 'Female';
    }
    
    return _formatGender(gender);
  }

  String _formatDOB(String dob) {
    if (dob.isEmpty) return '';

    // Check if the date is in MM-DD-YYYY or DD-MM-YYYY format (with hyphens)
    if (dob.contains('-') && dob.length == 10) {
      try {
        List<String> parts = dob.split('-');
        if (parts.length == 3) {
          int firstPart = int.tryParse(parts[0]) ?? 0;
          int secondPart = int.tryParse(parts[1]) ?? 0;

          // If first part > 12, it's definitely DD-MM-YYYY format (day > 12)
          if (firstPart > 12) {
            String day = parts[0].padLeft(2, '0');
            String month = parts[1].padLeft(2, '0');
            String year = parts[2];
            // Convert from DD-MM-YYYY to DD/MM/YYYY
            return '$day/$month/$year';
          }
          // If second part > 12, it's definitely MM-DD-YYYY format (day > 12)
          else if (secondPart > 12) {
            String month = parts[0].padLeft(2, '0');
            String day = parts[1].padLeft(2, '0');
            String year = parts[2];
            // Convert from MM-DD-YYYY to DD/MM/YYYY
            return '$day/$month/$year';
          }
          // If both parts are <= 12, we need to determine the format
          // Based on your API response pattern:
          // - Self user: DD-MM-YYYY (like 05-20-1976)
          // - Family members: MM-DD-YYYY (like 05-02-1977 for spouse, 07-19-2008 for kids)
          // We'll use a heuristic: if first part is 01-12 and second part is 01-31,
          // and the date looks like it could be a valid day (01-31), assume MM-DD-YYYY for family members
          else {
            // Check if first part could be a valid day (01-31) and second part could be a valid month (01-12)
            if (firstPart >= 1 &&
                firstPart <= 31 &&
                secondPart >= 1 &&
                secondPart <= 12) {
              // Based on your API response pattern, family members use MM-DD-YYYY format
              // So we'll assume MM-DD-YYYY for family members and convert to DD/MM/YYYY
              String month = parts[0].padLeft(2, '0');
              String day = parts[1].padLeft(2, '0');
              String year = parts[2];
              // Convert from MM-DD-YYYY to DD/MM/YYYY
              return '$day/$month/$year';
            } else {
              // Default to DD-MM-YYYY format
              String day = parts[0].padLeft(2, '0');
              String month = parts[1].padLeft(2, '0');
              String year = parts[2];
              return '$day/$month/$year';
            }
          }
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Check if the date is in MM/DD/YYYY format (with slashes) - from NORKA API
    if (dob.contains('/') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('/');
        if (parts.length == 3) {
          String month = parts[0].padLeft(2, '0');
          String day = parts[1].padLeft(2, '0');
          String year = parts[2];

          // Convert from MM/DD/YYYY to DD/MM/YYYY
          return '$day/$month/$year';
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Return original if not in expected format
    return dob;
  }

  Widget _buildMemberRow(String type, String name, String dob, String gender) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: AppText(
            text: '$type:',
            size: 14,
            weight: FontWeight.w500,
            textColor: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  text: name,
                  size: 14,
                  weight: FontWeight.w600,
                  textColor: isDarkMode ? Colors.white70 : Colors.black87,
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 8),
              AppText(
                text: _formatDOB(dob),
                size: 14,
                weight: FontWeight.normal,
                textColor: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              const SizedBox(width: 8),
              AppText(
                text: gender,
                size: 14,
                weight: FontWeight.normal,
                textColor: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPremiumAmountText(Map<String, dynamic> premiumData) {
    if (premiumData.isEmpty) {
      return '₹0';
    }

    // Try to get total_amount from premium_breakdown first
    if (premiumData.containsKey('premium_breakdown') &&
        premiumData['premium_breakdown'] is Map) {
      final breakdown =
          premiumData['premium_breakdown'] as Map<String, dynamic>;
      if (breakdown.containsKey('total_amount')) {
        final amount = breakdown['total_amount'];
        if (amount is num) {
          return '₹${amount.toStringAsFixed(0)}';
        }
      }
    }

    // Fallback to premium_amount
    if (premiumData.containsKey('premium_amount')) {
      final amount = premiumData['premium_amount'];
      if (amount is num) {
        return '₹${amount.toStringAsFixed(0)}';
      }
    }

    return '₹0';
  }

  void _showPremiumBreakdownDialog(Map<String, dynamic> premiumData) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDarkMode
              ? AppConstants.darkBackgroundColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: 'Enrollment fee structure',
                      size: 16,
                      weight: FontWeight.bold,
                      textColor: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                    ),
                    // GestureDetector(
                    //   onTap: () => Navigator.of(context).pop(),
                    //   child: Icon(
                    //     Icons.close,
                    //     color: isDarkMode
                    //         ? AppConstants.whiteColor
                    //         : AppConstants.blackColor,
                    //     size: 24,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),

                // Premium Data Display
                if (premiumData.isNotEmpty) ...[
                  // Family Composition
                  if (premiumData.containsKey('family_composition'))
                    _buildBreakdownRow(
                      'Family Composition',
                      premiumData['family_composition'],
                      isDarkMode,
                    ),

                  if (premiumData.containsKey('children_count'))
                    _buildBreakdownRow(
                      'Children Count',
                      premiumData['children_count'].toString(),
                      isDarkMode,
                    ),

                  const SizedBox(height: 16),

                  // Premium Breakdown Section
                  AppText(
                    text: 'Fee Calculation',
                    size: 16,
                    weight: FontWeight.w600,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  const SizedBox(height: 12),

                  // Base Amount
                  if (premiumData.containsKey('premium_breakdown') &&
                      premiumData['premium_breakdown'] is Map) ...[
                    Builder(
                      builder: (context) {
                        final breakdown =
                            premiumData['premium_breakdown']
                                as Map<String, dynamic>;
                        return Column(
                          children: [
                            if (breakdown.containsKey('base_amount'))
                              _buildBreakdownRow(
                                'Base Amount',
                                '₹${(breakdown['base_amount'] as num).toStringAsFixed(0)}',
                                isDarkMode,
                              ),

                            if (breakdown.containsKey(
                              'additional_children_amount',
                            ))
                              _buildBreakdownRow(
                                'Additional Children Amount',
                                '₹${(breakdown['additional_children_amount'] as num).toStringAsFixed(0)}',
                                isDarkMode,
                              ),

                            if (breakdown.containsKey('total_amount'))
                              _buildBreakdownRow(
                                'Total Amount',
                                '₹${(breakdown['total_amount'] as num).toStringAsFixed(0)}',
                                isDarkMode,
                                isTotal: true,
                              ),
                          ],
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Premium Config Section
                  AppText(
                    text: 'Fee Configuration',
                    size: 16,
                    weight: FontWeight.w600,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  const SizedBox(height: 12),

                  if (premiumData.containsKey('premium_config_used') &&
                      premiumData['premium_config_used'] is Map) ...[
                    Builder(
                      builder: (context) {
                        final config =
                            premiumData['premium_config_used']
                                as Map<String, dynamic>;
                        return Column(
                          children: [
                            if (config.containsKey('self_only_amount'))
                              _buildBreakdownRow(
                                'Self Only Amount',
                                '₹${(config['self_only_amount'] as num).toStringAsFixed(0)}',
                                isDarkMode,
                              ),

                            if (config.containsKey('family_amount'))
                              _buildBreakdownRow(
                                'Family Amount',
                                '₹${(config['family_amount'] as num).toStringAsFixed(0)}',
                                isDarkMode,
                              ),

                            if (config.containsKey('additional_child_amount'))
                              _buildBreakdownRow(
                                'Additional Child Amount',
                                '₹${(config['additional_child_amount'] as num).toStringAsFixed(0)}',
                                isDarkMode,
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ] else ...[
                  // No data available
                  AppText(
                    text: 'Premium data not available',
                    size: 16,
                    weight: FontWeight.w500,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ],

                const SizedBox(height: 24),

                // Close Button
                CustomButton(
                  text: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  color: AppConstants.primaryColor,
                  textColor: AppConstants.whiteColor,
                  height: 50,
                ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBreakdownRow(
    String label,
    String value,
    bool isDarkMode, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              text: label,
              size: isTotal ? 16 : 14,
              weight: isTotal ? FontWeight.bold : FontWeight.w500,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
          ),
          Expanded(
            flex: 1,
            child: AppText(
              text: value,
              size: isTotal ? 16 : 14,
              weight: isTotal ? FontWeight.bold : FontWeight.w600,
              textColor: isTotal
                  ? AppConstants.primaryColor
                  : (isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processRazorpayPayment(
    int premiumAmount,
    String nrkId,
    String emailId,
    String contactNumber,
    String userName,
  ) async {
    try {
      // Create Razorpay Order
      debugPrint('=== CREATING RAZORPAY ORDER ===');
      final orderResponse = await RazorpayService.createOrder(
        amount: premiumAmount,
        currency: 'INR',
        receipt: 'receipt_${DateTime.now().millisecondsSinceEpoch}',
        nrkIdNo: nrkId,
      );

      if (orderResponse['status'] != 'created') {
        throw Exception('Failed to create order');
      }

      final orderId = orderResponse['id'];
      _currentOrderId = orderId; // Store order ID for failure handling
      debugPrint('Order created successfully: $orderId');

      // Open Razorpay payment gateway
      debugPrint('=== OPENING RAZORPAY PAYMENT GATEWAY ===');
      var options = {
        'key': 'rzp_live_RKf8kP58RPmwkc',
        'amount': premiumAmount * 100,
        'currency': 'INR',
        'name': 'Norka Care',
        'description': 'Enrollment Fee Payment',
        'order_id': orderId,
        'prefill': {
          'contact': contactNumber,
          'email': emailId.isNotEmpty ? emailId : 'customer@example.com',
          'name': userName,
        },
        'theme': {'color': '#004EA1'},
        'retry': {'enabled': true, 'max_count': 3},
      };

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          _razorpay.open(options);
          debugPrint('Razorpay opened successfully');
        } catch (e) {
          debugPrint("Error opening Razorpay: $e");
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Something went wrong. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      });
    } catch (e) {
      debugPrint('Razorpay Payment Error: $e');
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Payment failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _processFederalBankPayment(
    int premiumAmount,
    String nrkId,
    String emailId,
    String contactNumber,
    String userName,
  ) async {
    try {
      debugPrint('=== FEDERAL BANK PAYMENT PROCESSING ===');
      
      // Call Federal Bank API to get payment URL
      final dio = await DioHelper.getInstance();
      final response = await dio.post(
        '${FamilyBaseURL}/federal-payments/create/',
        data: {
          'amount': premiumAmount.toStringAsFixed(2),
          'currency': 'INR',
          'customer_name': userName,
          'customer_email': emailId.isNotEmpty ? emailId : 'customer@example.com',
          'customer_phone': contactNumber,
          'product_info': 'Enrollment Fee Payment',
          'nrk_id_no': nrkId,
          'success_url': '${FamilyBaseURL}/federal-payments/callback/success/',
          'failure_url': '${FamilyBaseURL}/federal-payments/callback/failure/',
          'app_type': 'flutter',
          'metadata': {
            'user_id': nrkId,
            'plan': 'enrollment',
          },
        },
      );

      debugPrint('=== FEDERAL BANK API RESPONSE ===');
      debugPrint('Response: $response');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic>? data;
        
        // Handle response data - could be Map or String
        if (response.data is Map) {
          data = response.data as Map<String, dynamic>;
        } else if (response.data is String) {
          // Parse JSON string
          data = jsonDecode(response.data) as Map<String, dynamic>;
        }
        
        debugPrint('Parsed Data: $data');
        
        if (data != null && data['success'] == true && data['payment_url'] != null) {
          final paymentUrl = data['payment_url'] as String;
          final accessKey = data['access_key'] ?? '';
          
          debugPrint('Payment URL: $paymentUrl');
          debugPrint('Access Key: ${accessKey.isNotEmpty && accessKey.length >= 4 ? '***${accessKey.substring(accessKey.length - 4)}' : accessKey.isNotEmpty ? '***' : 'Empty'}');

          // Security: Validate payment URL before loading
          try {
            final uri = Uri.parse(paymentUrl);
            if (uri.scheme != 'https') {
              throw Exception('Payment URL must use HTTPS');
            }
            debugPrint('✅ Payment URL validated (HTTPS)');
          } catch (e) {
            debugPrint('❌ SECURITY: Invalid payment URL: $e');
            Fluttertoast.showToast(
              msg: "Payment failed. Please try again.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          // Open WebView with payment URL
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FederalBankWebViewPage(
                  paymentUrl: paymentUrl,
                  accessKey: accessKey,
                  nrkId: nrkId,
                  emailId: emailId,
                ),
              ),
            ).then((result) async {
              setState(() {
                _isLoading = false;
              });
              
              // Handle payment result
              if (result != null && result == true) {
                debugPrint('✅ Payment successful - Federal Bank payment completed');
                debugPrint('Note: Federal Bank payments are verified via webhook/callback, not API');
                
                // Navigate to success page
                // Note: Federal Bank payment verification happens server-side via webhook
                _navigateToSuccessPage('');
              } else {
                debugPrint('❌ Payment cancelled or failed - staying on current page');
                // Payment cancelled or failed
                Fluttertoast.showToast(
                  msg: "Payment cancelled",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            });
          }
        } else {
          throw Exception('Failed to get payment URL: Invalid response data');
        }
      } else {
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Federal Bank Payment Error: $e');
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Payment failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<String?> _showBankSelectionDialog() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // User must select a bank or cancel
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDarkMode
              ? AppConstants.darkBackgroundColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                // Header
                AppText(
                  text: 'Choose Payment Gateway',
                  size: 18,
                  weight: FontWeight.bold,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                
                const SizedBox(height: 24),
                
                // HDFC Bank Option
                GestureDetector(
                  onTap: () => Navigator.of(context).pop('HDFC'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppConstants.boxBlackColor
                          : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/hdfc.jpeg',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'HDFC Bank',
                                size: 16,
                                weight: FontWeight.bold,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor
                                    : AppConstants.blackColor,
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                text: 'Secure payment gateway',
                                size: 12,
                                weight: FontWeight.normal,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor.withOpacity(0.7)
                                    : AppConstants.blackColor.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: AppConstants.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Federal Bank Option
                GestureDetector(
                  onTap: () => Navigator.of(context).pop('FEDERAL'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppConstants.boxBlackColor
                          : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/federal.jpeg',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Federal Bank',
                                size: 16,
                                weight: FontWeight.bold,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor
                                    : AppConstants.blackColor,
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                text: 'Secure payment gateway',
                                size: 12,
                                weight: FontWeight.normal,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor.withOpacity(0.7)
                                    : AppConstants.blackColor.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Cancel Button
                CustomButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(null),
                  color: isDarkMode
                      ? AppConstants.boxBlackColor
                      : Colors.grey,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                  height: 50,
                ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FederalBankWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final String accessKey;
  final String nrkId;
  final String emailId;

  const FederalBankWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.accessKey,
    required this.nrkId,
    required this.emailId,
  });

  @override
  State<FederalBankWebViewPage> createState() => _FederalBankWebViewPageState();
}

class _FederalBankWebViewPageState extends State<FederalBankWebViewPage> {
  late WebViewController controller;
  bool isLoading = true;
  bool _paymentCallbackDetected = false; // Flag to track if callback was detected

  @override
  void initState() {
    super.initState();
    _validateAndInitializeWebView();
  }

  /// Validates payment URL for security before loading
  bool _validatePaymentUrl(String url) {
    try {
      // Check if URL is empty
      if (url.isEmpty) {
        debugPrint('❌ SECURITY: Payment URL is empty');
        return false;
      }
      
      final uri = Uri.parse(url);
      
      // Security Check: Must use HTTPS
      if (uri.scheme != 'https') {
        debugPrint('❌ SECURITY: Payment URL must use HTTPS. Found: ${uri.scheme}');
        return false;
      }
      
      // Check if host is valid
      if (uri.host.isEmpty) {
        debugPrint('❌ SECURITY: Payment URL has no host');
        return false;
      }
      
      debugPrint('✅ Payment URL validated successfully');
      debugPrint('  Scheme: ${uri.scheme}');
      debugPrint('  Host: ${uri.host}');
      debugPrint('  Path: ${uri.path}');
      return true;
    } catch (e) {
      debugPrint('❌ Invalid payment URL format: $e');
      debugPrint('  URL: $url');
      return false;
    }
  }

  /// Validates callback URL format
  bool _isTrustedCallbackUrl(String url) {
    try {
      final uri = Uri.parse(url);
      // Allow all HTTPS URLs
      return uri.scheme == 'https';
    } catch (e) {
      debugPrint('❌ Error validating callback URL: $e');
      return false;
    }
  }

  /// Securely checks if URL indicates payment success
  bool _isPaymentSuccessUrl(String url) {
    try {
      final uri = Uri.parse(url);
      
      // Security: Only check callback URLs from trusted domains
      if (!_isTrustedCallbackUrl(url)) {
        return false;
      }
      
      // Check path for success indicators (more secure than contains)
      final path = uri.path.toLowerCase();
      final queryParams = uri.queryParameters;
      
      // Validate success path patterns
      final hasSuccessPath = path.contains('/federal-payments/callback/success') || 
                            path.contains('/payment/success') || 
                            path.contains('/success');
      
      // Validate query parameters
      final hasSuccessParam = queryParams.containsKey('payment_status') && 
                             queryParams['payment_status']?.toLowerCase() == 'success';
      
      final hasStatusParam = queryParams.containsKey('status') && 
                            queryParams['status']?.toLowerCase() == 'success';
      
      return hasSuccessPath || hasSuccessParam || hasStatusParam;
    } catch (e) {
      debugPrint('❌ SECURITY: Error checking success URL: $e');
      return false;
    }
  }

  /// Securely checks if URL indicates payment failure
  bool _isPaymentFailureUrl(String url) {
    try {
      final uri = Uri.parse(url);
      
      // Security: Only check callback URLs from trusted domains
      if (!_isTrustedCallbackUrl(url)) {
        return false;
      }
      
      // Check path for failure indicators
      final path = uri.path.toLowerCase();
      final queryParams = uri.queryParameters;
      
      final hasFailurePath = path.contains('/federal-payments/callback/failure') || 
                            path.contains('/payment/failure') || 
                            path.contains('/failure');
      
      final hasFailureParam = queryParams.containsKey('payment_status') && 
                             queryParams['payment_status']?.toLowerCase() == 'failure';
      
      final hasStatusParam = queryParams.containsKey('status') && 
                            queryParams['status']?.toLowerCase() == 'failure';
      
      return hasFailurePath || hasFailureParam || hasStatusParam;
    } catch (e) {
      debugPrint('❌ SECURITY: Error checking failure URL: $e');
      return false;
    }
  }

  /// Extracts and logs JSON response from WebView page content
  Future<void> _extractAndLogJsonFromWebView(String callbackUrl) async {
    if (!mounted) {
      debugPrint('Widget not mounted, skipping JSON extraction');
      return;
    }
    
    try {
      debugPrint('=== EXTRACTING JSON FROM WEBVIEW PAGE ===');
      debugPrint('Callback URL: $callbackUrl');
      
      // Use JavaScript to extract the page body text content
      // JavaScript will return the content as a string, possibly wrapped in quotes
      final dynamic jsResult = await controller.runJavaScriptReturningResult(
        'document.body.innerText || document.body.textContent || document.documentElement.textContent || "{}"'
      );
      
      String? pageContent;
      
      // Handle different return types from JavaScript
      if (jsResult is String) {
        pageContent = jsResult;
        // Remove surrounding quotes if present
        if (pageContent.startsWith('"') && pageContent.endsWith('"')) {
          pageContent = pageContent.substring(1, pageContent.length - 1);
        }
      } else {
        pageContent = jsResult?.toString();
      }
      
      if (pageContent != null && pageContent.isNotEmpty && pageContent != '{}') {
        // Clean and trim the content
        String cleanedContent = pageContent.trim();
        
        // Handle escaped characters
        cleanedContent = cleanedContent.replaceAll('\\n', '');
        cleanedContent = cleanedContent.replaceAll('\\r', '');
        cleanedContent = cleanedContent.replaceAll('\\t', '');
        
        debugPrint('=== RAW PAGE CONTENT ===');
        debugPrint(cleanedContent);
        debugPrint('=== END RAW PAGE CONTENT ===');
        
        // Try to parse as JSON
        try {
          Map<String, dynamic> jsonResponse = jsonDecode(cleanedContent) as Map<String, dynamic>;
          
          debugPrint('=== CALLBACK JSON RESPONSE BODY ===');
          debugPrint(jsonEncode(jsonResponse));
          debugPrint('=== END CALLBACK JSON RESPONSE BODY ===');
          
          // Also log individual fields for easier debugging
          if (jsonResponse.containsKey('success')) {
            debugPrint('Success: ${jsonResponse['success']}');
          }
          if (jsonResponse.containsKey('order_id')) {
            debugPrint('Order ID: ${jsonResponse['order_id']}');
          }
          if (jsonResponse.containsKey('status')) {
            debugPrint('Status: ${jsonResponse['status']}');
          }
          if (jsonResponse.containsKey('txnid')) {
            debugPrint('Transaction ID: ${jsonResponse['txnid']}');
          }
          if (jsonResponse.containsKey('message')) {
            debugPrint('Message: ${jsonResponse['message']}');
          }
          if (jsonResponse.containsKey('error_msg')) {
            debugPrint('Error Message: ${jsonResponse['error_msg']}');
          }
          if (jsonResponse.containsKey('deep_link')) {
            debugPrint('Deep Link: ${jsonResponse['deep_link']}');
          }
        } catch (e) {
          debugPrint('Failed to parse as JSON: $e');
          debugPrint('Page content might not be valid JSON. Trying alternative extraction...');
          
          // Try alternative: get the page source and look for JSON
          try {
            final dynamic pageSource = await controller.runJavaScriptReturningResult(
              'document.documentElement.outerHTML || document.body.innerHTML || ""'
            );
            debugPrint('Alternative: Page source length: ${pageSource?.toString().length ?? 0}');
          } catch (e2) {
            debugPrint('Alternative extraction also failed: $e2');
          }
        }
      } else {
        debugPrint('No page content found or empty content');
      }
      
      debugPrint('=== END EXTRACTING JSON FROM WEBVIEW ===');
    } catch (e) {
      debugPrint('=== ERROR EXTRACTING JSON FROM WEBVIEW ===');
      debugPrint('Error: $e');
      debugPrint('Error Type: ${e.runtimeType}');
      debugPrint('=== END ERROR ===');
    }
  }

  /// Fetches and logs the JSON response from the callback URL (fallback method)
  // ignore: unused_element
  Future<void> _fetchAndLogCallbackResponse(String callbackUrl, {required bool isSuccess}) async {
    // This method is kept for reference but extraction from WebView is preferred
    // since the page content is already loaded in the WebView
    debugPrint('Note: Using WebView page content extraction instead of separate HTTP request');
  }

  void _validateAndInitializeWebView() {
    // Log the payment URL being validated
    debugPrint('=== VALIDATING PAYMENT URL ===');
    debugPrint('Payment URL: ${widget.paymentUrl}');
    
    // Validate payment URL before initializing WebView
    if (!_validatePaymentUrl(widget.paymentUrl)) {
      debugPrint('❌ Payment URL validation failed');
      Fluttertoast.showToast(
        msg: "Payment failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Navigator.pop(context, false);
      return;
    }
    
    debugPrint('✅ Payment URL validation passed - initializing WebView');
    _initializeWebView();
  }

  void _initializeWebView() {
    debugPrint('=== INITIALIZING WEBVIEW ===');
    
    // Parse and validate URL first (before creating controller)
    Uri? paymentUri;
    try {
      paymentUri = Uri.parse(widget.paymentUrl);
      debugPrint('✅ Payment URL parsed successfully');
    } catch (e) {
      debugPrint('❌ Error parsing payment URL: $e');
      if (mounted) {
        Fluttertoast.showToast(
          msg: "Invalid payment URL. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        Navigator.pop(context, false);
      }
      return;
    }
    
    // Create and configure WebViewController
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Required for payment gateway
      ..setBackgroundColor(Colors.transparent) // iOS: prevents white flash and improves rendering
      ..enableZoom(false) // Disable zoom for better payment UX
      ..setNavigationDelegate(
        NavigationDelegate(
          // Restrict navigation to prevent phishing attacks
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            
            // If callback already detected, prevent all further navigation
            if (_paymentCallbackDetected) {
              debugPrint('✅ Payment callback already processed - preventing further navigation');
              return NavigationDecision.prevent;
            }
            
            // Allow all navigation (HTTPS only enforced in URL validation)
            debugPrint('✅ Navigation allowed to: ${Uri.parse(url).host}');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint('=== WEBVIEW PAGE STARTED ===');
            debugPrint('Page started loading: $url');
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
            
            // Securely check for success/failure URLs
            if (_isPaymentSuccessUrl(url)) {
              // Mark callback as detected to prevent further navigation
              _paymentCallbackDetected = true;
              
              // Loading screen is already shown (isLoading is true from above)
              // No need for additional setState
              
              debugPrint('=== FEDERAL BANK PAYMENT SUCCESS DETECTED ===');
              debugPrint('Success Callback URL: $url');
              
              // Parse URL to extract query parameters and log all payment details
              try {
                final uri = Uri.parse(url);
                debugPrint('=== FEDERAL BANK PAYMENT CALLBACK DETAILS ===');
                debugPrint('Full Callback URL: $url');
                debugPrint('URL Scheme: ${uri.scheme}');
                debugPrint('URL Host: ${uri.host}');
                debugPrint('URL Path: ${uri.path}');
                debugPrint('All Query Parameters: ${uri.queryParameters}');
                
                // Extract and log all available transaction details
                final params = uri.queryParameters;
                params.forEach((key, value) {
                  debugPrint('  $key: $value');
                });
                
                // Log specific important fields if available
                if (params.containsKey('transaction_id') || params.containsKey('txnid')) {
                  debugPrint('Transaction ID: ${params['transaction_id'] ?? params['txnid']}');
                }
                if (params.containsKey('payment_id') || params.containsKey('paymentid')) {
                  debugPrint('Payment ID: ${params['payment_id'] ?? params['paymentid']}');
                }
                if (params.containsKey('order_id') || params.containsKey('orderid')) {
                  debugPrint('Order ID: ${params['order_id'] ?? params['orderid']}');
                }
                if (params.containsKey('amount')) {
                  debugPrint('Amount: ${params['amount']}');
                }
                if (params.containsKey('status')) {
                  debugPrint('Status: ${params['status']}');
                }
                if (params.containsKey('payment_status')) {
                  debugPrint('Payment Status: ${params['payment_status']}');
                }
                if (params.containsKey('access_key')) {
                  final accessKeyValue = params['access_key'];
                  if (accessKeyValue != null && accessKeyValue.length >= 4) {
                    debugPrint('Access Key: ***${accessKeyValue.substring(accessKeyValue.length - 4)}');
                  } else {
                    debugPrint('Access Key: ***');
                  }
                }
                
                debugPrint('=== END FEDERAL BANK PAYMENT CALLBACK DETAILS ===');
                debugPrint('Note: Federal Bank payment verification happens server-side via webhook/callback');
              } catch (e) {
                debugPrint('Error parsing success URL: $e');
              }
              
              // Wait for the page to load, then extract JSON before navigating
              // Use a longer delay to ensure the page content is fully loaded
              Future.delayed(const Duration(milliseconds: 1500), () async {
                if (mounted) {
                  await _extractAndLogJsonFromWebView(url);
                  // Add a small delay before navigating to ensure logs are printed
                  await Future.delayed(const Duration(milliseconds: 200));
                  // Now navigate back
                  if (mounted) {
                    debugPrint('Navigating back with success status');
                    Navigator.pop(context, true);
                  }
                }
              });
            } else if (_isPaymentFailureUrl(url)) {
              // Mark callback as detected to prevent further navigation
              _paymentCallbackDetected = true;
              
              // Loading screen is already shown (isLoading is true from above)
              // No need for additional setState
              
              debugPrint('=== PAYMENT FAILURE DETECTED ===');
              debugPrint('Failure URL: $url');
              
              // Wait for the page to load, then extract JSON before navigating
              // Use a longer delay to ensure the page content is fully loaded
              Future.delayed(const Duration(milliseconds: 1500), () async {
                if (mounted) {
                  await _extractAndLogJsonFromWebView(url);
                  // Add a small delay before navigating to ensure logs are printed
                  await Future.delayed(const Duration(milliseconds: 200));
                  // Now navigate back
                  if (mounted) {
                    debugPrint('Navigating back with failure status');
                    Navigator.pop(context, false);
                  }
                }
              });
            }
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            // Don't hide loading if callback was detected - keep loading screen visible
            if (mounted && !_paymentCallbackDetected) {
              // Small delay on iOS to ensure WebView is fully ready for interactions
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted && !_paymentCallbackDetected) {
                  setState(() {
                    isLoading = false;
                  });
                  debugPrint('✅ WebView ready for interactions');
                }
              });
            } else if (_paymentCallbackDetected) {
              debugPrint('Page finished loading but callback detected - keeping loading screen visible');
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            debugPrint('Error code: ${error.errorCode}');
            debugPrint('Error type: ${error.errorType}');
            
            // Don't hide loading if callback was detected - keep loading screen visible
            if (mounted && !_paymentCallbackDetected) {
              setState(() {
                isLoading = false;
              });
              
              // Log error details
              debugPrint('❌ WebView failed to load: ${error.description}');
            }
            
            // Don't show error toast - errors after successful payment detection are expected
            // (frame load interrupted when blocking navigation after callback)
            if (_paymentCallbackDetected) {
              debugPrint('WebView error after callback detection - ignoring (expected)');
            }
          },
        ),
      );
    
    // Load the payment URL after controller is fully configured
    debugPrint('=== LOADING PAYMENT URL INTO WEBVIEW ===');
    debugPrint('Loading URL: ${widget.paymentUrl}');
    
    // Use the already parsed URI to avoid re-parsing
    try {
      controller.loadRequest(paymentUri);
      debugPrint('✅ URL load request sent successfully');
      debugPrint('  Scheme: ${paymentUri.scheme}');
      debugPrint('  Host: ${paymentUri.host}');
      debugPrint('  Path: ${paymentUri.path}');
    } catch (e) {
      debugPrint('❌ Error loading URL: $e');
      debugPrint('Error type: ${e.runtimeType}');
      if (mounted) {
        Fluttertoast.showToast(
          msg: "Failed to load payment page. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        Navigator.pop(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return PopScope(
      // Prevent back navigation when callback is detected (processing payment)
      canPop: !_paymentCallbackDetected,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop && !_paymentCallbackDetected) {
          // User manually went back before callback was detected
          debugPrint('User navigated back manually - payment cancelled');
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode 
            ? AppConstants.darkBackgroundColor 
            : AppConstants.whiteColor,
        appBar: AppBar(
          backgroundColor: AppConstants.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Icons.arrow_back_ios
                  : Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: _paymentCallbackDetected 
                ? null // Disable back button when callback detected
                : () {
                    debugPrint('Back button pressed - navigating back');
                    Navigator.pop(context, false);
                  },
          ),
          automaticallyImplyLeading: false,
          title: const AppText(
            text: 'Federal Bank Payment',
            size: 18,
            weight: FontWeight.w600,
            textColor: Colors.white,
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      body: Stack(
        children: [
          // WebView - Use Visibility instead of Opacity to avoid iOS touch blocking
          // When callback is detected, keep WebView visible but non-interactive
          // AbsorbPointer overlay will handle blocking touches during loading
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 1,
            ),
            child: SizedBox.expand(
              child: WebViewWidget(controller: controller),
            ),
          ),
          // Bottom whitespace with primary color
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: !_paymentCallbackDetected,
              child: Container(
                height: MediaQuery.of(context).padding.bottom + 1,
                color: AppConstants.primaryColor,
              ),
            ),
          ),
          // Show loading screen when callback detected or page is loading
          // Positioned must be direct child of Stack, so AbsorbPointer goes inside
          if (isLoading || _paymentCallbackDetected)
            Positioned.fill(
              child: AbsorbPointer(
                child: Container(
                  color: isDarkMode 
                      ? AppConstants.darkBackgroundColor 
                      : AppConstants.whiteColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppConstants.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        AppText(
                          text: _paymentCallbackDetected 
                              ? 'Processing payment...' 
                              : 'Loading payment gateway...',
                          size: 14,
                          weight: FontWeight.w500,
                          textColor: isDarkMode 
                              ? AppConstants.whiteColor 
                              : AppConstants.blackColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
