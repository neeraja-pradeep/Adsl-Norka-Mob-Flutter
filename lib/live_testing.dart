// // ECARD live testing


// // import 'package:norkacare_app/navigation/app_navigation_bar.dart';
// // import 'package:norkacare_app/utils/constants.dart';
// // import 'package:norkacare_app/widgets/custom_button.dart';
// // import 'package:norkacare_app/widgets/app_text.dart';
// // import 'package:norkacare_app/provider/verification_provider.dart';
// // import 'package:norkacare_app/provider/norka_provider.dart';
// // import 'package:norkacare_app/widgets/toast_message.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // class PaymentSuccessPage extends StatefulWidget {
// //   final String? emailId;
// //   final String? nrkId;

// //   const PaymentSuccessPage({super.key, this.emailId, this.nrkId});

// //   @override
// //   State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
// // }

// // class _PaymentSuccessPageState extends State<PaymentSuccessPage>
// //     with TickerProviderStateMixin {
// //   late AnimationController _scaleController;
// //   late AnimationController _fadeController;
// //   late Animation<double> _scaleAnimation;
// //   late Animation<double> _fadeAnimation;
// //   bool _isLoading = false;
// //   bool _isEnrolling = false;
// //   String _enrollmentNumber = 'NC1234567890'; // Default fallback
// //   Map<String, dynamic> _enrollmentDetails = {};

// //   @override
// //   void initState() {
// //     super.initState();
// //     _scaleController = AnimationController(
// //       duration: const Duration(milliseconds: 800),
// //       vsync: this,
// //     );
// //     _fadeController = AnimationController(
// //       duration: const Duration(milliseconds: 1200),
// //       vsync: this,
// //     );

// //     _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
// //     );

// //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
// //     );

// //     _scaleController.forward();
// //     _fadeController.forward();

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _handleEnrollmentProcess();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _scaleController.dispose();
// //     _fadeController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

// //     return Scaffold(
// //       backgroundColor: isDarkMode
// //           ? AppConstants.darkBackgroundColor
// //           : AppConstants.whiteBackgroundColor,
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 60),

// //               // Success Animation
// //               ScaleTransition(
// //                 scale: _scaleAnimation,
// //                 child: Container(
// //                   width: 120,
// //                   height: 120,
// //                   decoration: BoxDecoration(
// //                     color: isDarkMode
// //                         ? AppConstants.primaryColor
// //                         : AppConstants.primaryColor,
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color:
// //                             (isDarkMode
// //                                     ? AppConstants.primaryColor
// //                                     : AppConstants.primaryColor)
// //                                 .withOpacity(0.3),
// //                         blurRadius: 20,
// //                         spreadRadius: 5,
// //                       ),
// //                     ],
// //                   ),
// //                   child: const Icon(Icons.check, size: 60, color: Colors.white),
// //                 ),
// //               ),
// //               const SizedBox(height: 40),

// //               // Success Title
// //               FadeTransition(
// //                 opacity: _fadeAnimation,
// //                 child: AppText(
// //                   text: 'Payment Successful',
// //                   size: 28,
// //                   weight: FontWeight.bold,
// //                   textColor: isDarkMode
// //                       ? AppConstants.whiteColor
// //                       : AppConstants.blackColor,
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               // Confirmation Message
// //               FadeTransition(
// //                 opacity: _fadeAnimation,
// //                 child: AppText(
// //                   text: 'You have successfully enrolled',
// //                   size: 18,
// //                   weight: FontWeight.w500,
// //                   textColor: isDarkMode
// //                       ? AppConstants.whiteColor
// //                       : AppConstants.blackColor,
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),
// //               const SizedBox(height: 24),

// //               FadeTransition(
// //                 opacity: _fadeAnimation,
// //                 child: AppText(
// //                   text: 'Enrollment number: $_enrollmentNumber',
// //                   size: 16,
// //                   weight: FontWeight.w500,
// //                   textColor: isDarkMode
// //                       ? AppConstants.whiteColor
// //                       : AppConstants.blackColor,
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),

// //               const SizedBox(height: 16),

// //               const Spacer(),

// //               FadeTransition(
// //                 opacity: _fadeAnimation,
// //                 child: Column(
// //                   children: [
// //                     Container(
// //                       width: double.infinity,
// //                       height: 50,
// //                       decoration: BoxDecoration(
// //                         color: isDarkMode
// //                             ? AppConstants.whiteColor
// //                             : AppConstants.primaryColor,
// //                         borderRadius: BorderRadius.circular(10),
// //                         border: Border.all(
// //                           color: AppConstants.primaryColor,
// //                           width: 1,
// //                         ),
// //                       ),
// //                       child: ElevatedButton(
// //                         onPressed: _handleViewECard,
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.transparent,
// //                           shadowColor: Colors.transparent,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                         ),
// //                         child: AppText(
// //                           text: 'Download E-Card',
// //                           size: 16,
// //                           weight: FontWeight.w600,
// //                           textColor: isDarkMode
// //                               ? AppConstants.primaryColor
// //                               : AppConstants.whiteColor,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),

// //                     // Back to Home Button
// //                     CustomButton(
// //                       text: _isLoading || _isEnrolling
// //                           ? 'Processing...'
// //                           : 'Back to Home',
// //                       onPressed: (_isLoading || _isEnrolling)
// //                           ? () {}
// //                           : _handleBackToHome,
// //                       color: AppConstants.primaryColor,
// //                       textColor: AppConstants.whiteColor,
// //                       height: 50,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 30),
// //               // Policy Information Message
// //               FadeTransition(
// //                 opacity: _fadeAnimation,
// //                 child: Container(
// //                   padding: const EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     color: isDarkMode
// //                         ? AppConstants.primaryColor.withOpacity(0.1)
// //                         : AppConstants.primaryColor.withOpacity(0.05),
// //                     borderRadius: BorderRadius.circular(12),
// //                     border: Border.all(
// //                       color: isDarkMode
// //                           ? AppConstants.primaryColor.withOpacity(0.2)
// //                           : AppConstants.primaryColor.withOpacity(0.2),
// //                     ),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Icon(
// //                             Icons.info_outline,
// //                             color: AppConstants.primaryColor,
// //                             size: 20,
// //                           ),
// //                           const SizedBox(width: 8),
// //                           AppText(
// //                             text: 'Next Steps',
// //                             size: 16,
// //                             weight: FontWeight.w600,
// //                             textColor: AppConstants.primaryColor,
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 8),
// //                       AppText(
// //                         text:
// //                             'Check your "My Policy" to track your E-Card. You can also track E-Card and download your E-Card and Policy conditions.',
// //                         size: 14,
// //                         weight: FontWeight.normal,
// //                         textColor: AppConstants.greyColor,
// //                         textAlign: TextAlign.left,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _handleViewECard() async {
// //     // Show E-Card as a physical card-like design
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           backgroundColor: Colors.transparent,
// //           child: Container(
// //             width: double.infinity,
// //             height: 220,
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //                 colors: [
// //                   AppConstants.primaryColor,
// //                   AppConstants.primaryColor.withOpacity(0.8),
// //                 ],
// //               ),
// //               borderRadius: BorderRadius.circular(20),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.3),
// //                   blurRadius: 20,
// //                   spreadRadius: 5,
// //                   offset: const Offset(0, 10),
// //                 ),
// //               ],
// //             ),
// //             child: Stack(
// //               children: [
// //                 // Card content
// //                 Padding(
// //                   padding: const EdgeInsets.all(20),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Header
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           AppText(
// //                             text: 'NORKA CARE',
// //                             size: 16,
// //                             weight: FontWeight.bold,
// //                             textColor: Colors.white,
// //                           ),
// //                           AppText(
// //                             text: 'E-CARD',
// //                             size: 12,
// //                             weight: FontWeight.w500,
// //                             textColor: Colors.white.withOpacity(0.9),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 20),

// //                       // Member name
// //                       AppText(
// //                         text: _enrollmentDetails['nrk_name'] ?? 'AMALNATH C K',
// //                         size: 18,
// //                         weight: FontWeight.bold,
// //                         textColor: Colors.white,
// //                       ),
// //                       const SizedBox(height: 8),

// //                       // Policy number
// //                       AppText(
// //                         text:
// //                             'Policy: ${_enrollmentDetails['self_enrollment_number'] ?? _enrollmentNumber}',
// //                         size: 12,
// //                         weight: FontWeight.w500,
// //                         textColor: Colors.white.withOpacity(0.9),
// //                       ),
// //                       const SizedBox(height: 4),

// //                       // Sum insured
// //                       AppText(
// //                         text: 'Sum Insured: ₹5,00,000',
// //                         size: 12,
// //                         weight: FontWeight.w500,
// //                         textColor: Colors.white.withOpacity(0.9),
// //                       ),
// //                       const Spacer(),

// //                       // Validity
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               AppText(
// //                                 text: 'VALID FROM',
// //                                 size: 8,
// //                                 weight: FontWeight.w500,
// //                                 textColor: Colors.white.withOpacity(0.7),
// //                               ),
// //                               AppText(
// //                                 text: '08/09/2025',
// //                                 size: 10,
// //                                 weight: FontWeight.bold,
// //                                 textColor: Colors.white,
// //                               ),
// //                             ],
// //                           ),
// //                           Column(
// //                             crossAxisAlignment: CrossAxisAlignment.end,
// //                             children: [
// //                               AppText(
// //                                 text: 'VALID UNTIL',
// //                                 size: 8,
// //                                 weight: FontWeight.w500,
// //                                 textColor: Colors.white.withOpacity(0.7),
// //                               ),
// //                               AppText(
// //                                 text: '07/09/2026',
// //                                 size: 10,
// //                                 weight: FontWeight.bold,
// //                                 textColor: Colors.white,
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _handleEnrollmentProcess() async {
// //     setState(() {
// //       _isEnrolling = true;
// //     });

// //     try {
// //       final verificationProvider = Provider.of<VerificationProvider>(
// //         context,
// //         listen: false,
// //       );
// //       final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

// //       // Clear any previous enrollment data to ensure fresh data
// //       verificationProvider.clearEnrollmentData();

// //       // Get email and NRK ID from providers or widget parameters
// //       String emailId = widget.emailId ?? '';
// //       String nrkId = widget.nrkId ?? '';

// //       // If not provided in widget, try to get from providers
// //       if (emailId.isEmpty && norkaProvider.response != null) {
// //         final emails = norkaProvider.response!['emails'];
// //         if (emails != null && emails.isNotEmpty) {
// //           emailId = emails[0]['address'] ?? '';
// //         }
// //       }

// //       if (nrkId.isEmpty) {
// //         nrkId = norkaProvider.norkaId;
// //       }

// //       if (emailId.isEmpty || nrkId.isEmpty) {
// //         ToastMessage.failedToast(
// //           'Unable to process enrollment: Missing user data',
// //         );
// //         return;
// //       }

// //       // Step 1: Call enrollment POST API
// //       final enrollmentData = {'email_id': emailId, 'nrk_id_no': nrkId};

// //       await verificationProvider.Enrolling(enrollmentData);

// //       if (verificationProvider.errorMessage.isNotEmpty) {
// //         ToastMessage.failedToast(
// //           'Enrollment failed: ${verificationProvider.errorMessage}',
// //         );
// //         return;
// //       }

// //       // Check if enrollment data is available in the POST response
// //       if (verificationProvider.response != null &&
// //           verificationProvider.response!['data'] != null) {
// //         final data = verificationProvider.response!['data'];
// //         _enrollmentDetails = data;
// //         _enrollmentNumber = data['self_enrollment_number'] ?? 'NC1234567890';
// //         setState(() {});
// //         ToastMessage.successToast('Enrollment completed successfully!');
// //       } else {
// //         // Fallback: Fetch enrollment details using GET API
// //         await verificationProvider.getEnrollmentDetails(nrkId);

// //         if (verificationProvider.enrollmentDetails.isNotEmpty) {
// //           final data = verificationProvider.enrollmentDetails['data'];
// //           if (data != null) {
// //             _enrollmentDetails = data;
// //             _enrollmentNumber =
// //                 data['self_enrollment_number'] ?? 'NC1234567890';
// //             setState(() {});
// //             ToastMessage.successToast('Enrollment completed successfully!');
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint('Enrollment error: $e');
// //       ToastMessage.failedToast('Enrollment process failed. Please try again.');
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isEnrolling = false;
// //         });
// //       }
// //     }
// //   }

// //   Future<void> _handleBackToHome() async {
// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       // Simulate API call or data processing
// //       await Future.delayed(const Duration(seconds: 1));

// //       if (mounted) {
// //         Navigator.pushAndRemoveUntil(
// //           context,
// //           MaterialPageRoute(builder: (context) => const AppNavigationBar()),
// //           (route) => false,
// //         );
// //       }
// //     } catch (e) {
// //       // Handle error if needed
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }
// // }

// import 'dart:convert';
// import 'package:norkacare_app/navigation/app_navigation_bar.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/provider/otp_verification_provider.dart';
// import 'package:norkacare_app/provider/auth_provider.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:norkacare_app/services/vidal_data_mapper.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PaymentSuccessPage extends StatefulWidget {
//   final String? emailId;
//   final String? nrkId;

//   const PaymentSuccessPage({super.key, this.emailId, this.nrkId});

//   @override
//   State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
// }

// class _PaymentSuccessPageState extends State<PaymentSuccessPage>
//     with TickerProviderStateMixin {
//   late AnimationController _scaleController;
//   late AnimationController _fadeController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   bool _isLoading = false;
//   bool _isEnrolling = false;
//   String _enrollmentNumber = 'NC1234567890'; // Default fallback

//   @override
//   void initState() {
//     super.initState();
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );

//     _scaleController.forward();
//     _fadeController.forward();

//     // Call enrollment APIs after payment success
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _handleEnrollmentProcess();
//     });
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDarkMode
//           ? AppConstants.darkBackgroundColor
//           : AppConstants.whiteBackgroundColor,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const SizedBox(height: 60),

//               // Success Animation
//               ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.primaryColor
//                         : AppConstants.primaryColor,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color:
//                             (isDarkMode
//                                     ? AppConstants.primaryColor
//                                     : AppConstants.primaryColor)
//                                 .withOpacity(0.3),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.check, size: 60, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // Success Title
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: AppText(
//                   text: 'Policy Enrolled Successfully',
//                   size: 20,
//                   weight: FontWeight.bold,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Confirmation Message
//               // FadeTransition(
//               //   opacity: _fadeAnimation,
//               //   child: AppText(
//               //     text: 'You have successfully enrolled',
//               //     size: 18,
//               //     weight: FontWeight.w500,
//               //     textColor: isDarkMode
//               //         ? AppConstants.whiteColor
//               //         : AppConstants.blackColor,
//               //     textAlign: TextAlign.center,
//               //   ),
//               // ),
//               // const SizedBox(height: 24),
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: AppText(
//                   text: 'Enrollment number: $_enrollmentNumber',
//                   size: 16,
//                   weight: FontWeight.w500,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//               const SizedBox(height: 16),

//               const Spacer(),

//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   children: [
//                     CustomButton(
//                       text: 'Download E-Card',
//                       onPressed: _handleViewECard,
//                       color: AppConstants.secondaryColor,
//                       textColor: AppConstants.blackColor,
//                       height: 50,
//                     ),
//                     const SizedBox(height: 12),

//                     // Back to Home Button
//                     CustomButton(
//                       text: _isLoading || _isEnrolling
//                           ? 'Processing...'
//                           : 'Back to Home',
//                       onPressed: (_isLoading || _isEnrolling)
//                           ? () {}
//                           : _handleBackToHome,
//                       color: AppConstants.primaryColor,
//                       textColor: AppConstants.whiteColor,
//                       height: 50,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Policy Information Message
//               //   FadeTransition(
//               //     opacity: _fadeAnimation,
//               //     child: Container(
//               //       padding: const EdgeInsets.all(16),
//               //       decoration: BoxDecoration(
//               //         color: isDarkMode
//               //             ? AppConstants.primaryColor.withOpacity(0.1)
//               //             : AppConstants.primaryColor.withOpacity(0.05),
//               //         borderRadius: BorderRadius.circular(12),
//               //         border: Border.all(
//               //           color: isDarkMode
//               //               ? AppConstants.primaryColor.withOpacity(0.2)
//               //               : AppConstants.primaryColor.withOpacity(0.2),
//               //         ),
//               //       ),
//               //       child: Column(
//               //         children: [
//               //           Row(
//               //             children: [
//               //               Icon(
//               //                 Icons.info_outline,
//               //                 color: AppConstants.primaryColor,
//               //                 size: 20,
//               //               ),
//               //               const SizedBox(width: 8),
//               //               AppText(
//               //                 text: 'Next Steps',
//               //                 size: 16,
//               //                 weight: FontWeight.w600,
//               //                 textColor: AppConstants.primaryColor,
//               //               ),
//               //             ],
//               //           ),
//               //           const SizedBox(height: 8),
//               //           AppText(
//               //             text:
//               //                 'Check your "My Policy" to track your E-Card. You can also track E-Card and download your E-Card and Policy conditions.',
//               //             size: 14,
//               //             weight: FontWeight.normal,
//               //             textColor: AppConstants.greyColor,
//               //             textAlign: TextAlign.left,
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleViewECard() async {
//     final verificationProvider = Provider.of<VerificationProvider>(
//       context,
//       listen: false,
//     );
//     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 AppConstants.primaryColor,
//               ),
//             ),
//           ),
//         );
//       },
//     );

//     try {
//       // Get the NORKA ID from provider or widget
//       String employeeCode = '';

//       // Try to get from widget first
//       if (widget.nrkId != null && widget.nrkId!.isNotEmpty) {
//         employeeCode = widget.nrkId!;
//       } else {
//         // Try to get from verified customer data first, then fallback to NORKA provider
//         final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//           context,
//           listen: false,
//         );
//         final verifiedCustomerData = otpVerificationProvider
//             .getVerifiedCustomerData();

//         if (verifiedCustomerData != null) {
//           // Try different possible field names for NRK ID
//           employeeCode = verifiedCustomerData['norka_id'] ?? 
//                          verifiedCustomerData['nrk_id'] ?? 
//                          verifiedCustomerData['norka_id_no'] ?? 
//                          verifiedCustomerData['nrk_id_no'] ?? '';
//         }
        
//         // If still empty, try from NORKA provider
//         if (employeeCode.isEmpty) {
//           employeeCode = norkaProvider.norkaId;
//         }
//       }

//       if (employeeCode.isEmpty) {
//         Navigator.of(context).pop(); // Close loading dialog
//         // ToastMessage.failedToast('NORKA ID not found');
//         return;
//       }

//       // Call the Vidal E-Card API
//       await verificationProvider.vidalEnrollmentEcard({
//         'employee_code': employeeCode,
//       });

//       Navigator.of(context).pop(); // Close loading dialog

//       // Check if API call was successful
//       if (verificationProvider.errorMessage.isNotEmpty) {
//         // Check if it's actually an error or just a success message
//         final message = verificationProvider.errorMessage.toLowerCase();
//         if (message.contains('error') || 
//             message.contains('failed') || 
//             message.contains('invalid') ||
//             message.contains('not found') ||
//             message.contains('unauthorized')) {
//           ToastMessage.failedToast(verificationProvider.errorMessage);
//           return;
//         }
//       }

//       // Extract E-Card URL from response
//       final response = verificationProvider.response;
//       String? eCardUrl;
      
//       if (response != null) {
//         // Try multiple extraction methods
//         // Method 1: Direct extraction
//         try {
//           if (response['success'] == true && 
//               response['data'] != null && 
//               response['data']['data'] != null && 
//               response['data']['data'] is List &&
//               (response['data']['data'] as List).isNotEmpty) {
            
//             final firstCard = (response['data']['data'] as List)[0];
//             eCardUrl = firstCard['ecardUrl'];
//             debugPrint('✅ E-Card URL extracted: ${eCardUrl?.substring(0, 50)}...');
//           }
//         } catch (e) {
//           debugPrint('❌ URL extraction failed: $e');
//         }
        
//         // Method 2: Alternative extraction
//         if (eCardUrl == null || eCardUrl.isEmpty) {
//           try {
//             final data = response['data'];
//             if (data != null && data['data'] != null) {
//               final cards = data['data'];
//               if (cards is List && cards.isNotEmpty) {
//                 eCardUrl = cards[0]['ecardUrl'];
//                 debugPrint('✅ E-Card URL extracted (method 2): ${eCardUrl?.substring(0, 50)}...');
//               }
//             }
//           } catch (e) {
//             debugPrint('❌ Method 2 failed: $e');
//           }
//         }
//       }

//       if (eCardUrl != null && eCardUrl.isNotEmpty) {
//         ToastMessage.successToast('Opening E-Card...');
        
//         try {
//           final Uri uri = Uri.parse(eCardUrl);
//           final canLaunch = await canLaunchUrl(uri);
          
//           if (canLaunch) {
//             await launchUrl(uri);
//             ToastMessage.successToast('E-Card opened successfully!');
//           } else {
//             ToastMessage.failedToast('Cannot open E-Card URL');
//           }
//         } catch (e) {
//           ToastMessage.failedToast('Error opening E-Card: $e');
//         }
//       } else {
//         ToastMessage.failedToast('No E-Card URL found');
//       }
//     } catch (e) {
//       Navigator.of(context).pop(); // Close loading dialog
//       // ToastMessage.failedToast('Error: ${e.toString()}');
//     }
//   }

//   Future<void> _handleEnrollmentProcess() async {
//     setState(() {
//       _isEnrolling = true;
//     });

//     try {
//       final verificationProvider = Provider.of<VerificationProvider>(
//         context,
//         listen: false,
//       );
//       final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

//       // Clear any previous enrollment data to ensure fresh data
//       verificationProvider.clearEnrollmentData();

//       // Get email and NRK ID from providers or widget parameters
//       String emailId = widget.emailId ?? '';
//       String nrkId = widget.nrkId ?? '';

//       // Try to get verified customer data first, then fallback to NORKA provider
//       final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//         context,
//         listen: false,
//       );
//       final verifiedCustomerData = otpVerificationProvider
//           .getVerifiedCustomerData();
//       Map<String, dynamic>? customerData =
//           verifiedCustomerData ?? norkaProvider.response;

//       // If not provided in widget, try to get from providers
//       if (emailId.isEmpty && customerData != null) {
//         final emails = customerData['emails'];
//         if (emails != null && emails.isNotEmpty) {
//           emailId = emails[0]['address'] ?? '';
//         }
//       }

//       if (nrkId.isEmpty) {
//         // Try to get from verified customer data first
//         if (verifiedCustomerData != null) {
//           // Try different possible field names for NRK ID
//           nrkId = verifiedCustomerData['norka_id'] ?? 
//                   verifiedCustomerData['nrk_id'] ?? 
//                   verifiedCustomerData['norka_id_no'] ?? 
//                   verifiedCustomerData['nrk_id_no'] ?? '';
//         }
        
//         // If still empty, try from NORKA provider
//         if (nrkId.isEmpty) {
//           nrkId = norkaProvider.norkaId;
//         }
//       }

//       debugPrint('=== PAYMENT SUCCESS PAGE ENROLLMENT DEBUG ===');
//       debugPrint('Widget Email ID: ${widget.emailId ?? 'null'}');
//       debugPrint('Widget NRK ID: ${widget.nrkId ?? 'null'}');
//       debugPrint('Extracted Email ID: $emailId');
//       debugPrint('Extracted NRK ID: $nrkId');
//       debugPrint('Verified Customer Data: $verifiedCustomerData');
//       debugPrint('NORKA Provider Response: ${norkaProvider.response}');
      
//       // Debug verified customer data fields
//       if (verifiedCustomerData != null) {
//         debugPrint('=== VERIFIED CUSTOMER DATA FIELDS ===');
//         debugPrint('Available keys: ${verifiedCustomerData.keys.toList()}');
//         debugPrint('norka_id: ${verifiedCustomerData['norka_id']}');
//         debugPrint('nrk_id: ${verifiedCustomerData['nrk_id']}');
//         debugPrint('norka_id_no: ${verifiedCustomerData['norka_id_no']}');
//         debugPrint('nrk_id_no: ${verifiedCustomerData['nrk_id_no']}');
//         debugPrint('name: ${verifiedCustomerData['name']}');
//         debugPrint('emails: ${verifiedCustomerData['emails']}');
//         debugPrint('=== END VERIFIED CUSTOMER DATA FIELDS ===');
//       }
      
//       debugPrint('=== END PAYMENT SUCCESS PAGE ENROLLMENT DEBUG ===');

//       if (emailId.isEmpty || nrkId.isEmpty) {
//         ToastMessage.failedToast('Something went wrong. Please try again.');
//         return;
//       }

//       // Step 1: Call enrollment POST API
//       final enrollmentData = {'email_id': emailId, 'nrk_id_no': nrkId};
      
//       debugPrint('=== PAYMENT SUCCESS - CALLING ENROLLING API ===');
//       debugPrint('Enrollment Data: $enrollmentData');

//       await verificationProvider.Enrolling(enrollmentData);
      
//       debugPrint('=== PAYMENT SUCCESS - ENROLLING API COMPLETED ===');
//       debugPrint('Provider Error Message: ${verificationProvider.errorMessage}');
//       debugPrint('Provider Response: ${verificationProvider.response}');

//       if (verificationProvider.errorMessage.isNotEmpty) {
//         debugPrint('❌ Enrollment failed with error: ${verificationProvider.errorMessage}');
//         ToastMessage.failedToast('Enrollment failed');
//         return;
//       }

//       // Check if enrollment data is available in the POST response
//       debugPrint('=== PAYMENT SUCCESS - CHECKING POST RESPONSE ===');
//       debugPrint('Provider Response is null: ${verificationProvider.response == null}');
      
//       if (verificationProvider.response != null &&
//           verificationProvider.response!['data'] != null) {
//         final data = verificationProvider.response!['data'];
//         _enrollmentNumber = data['self_enrollment_number'] ?? 'NC1234567890';
//         debugPrint('✅ Enrollment number from POST response: $_enrollmentNumber');
//         debugPrint('✅ Full POST response data: $data');
//         setState(() {});
//         // ToastMessage.successToast('Enrollment completed successfully!');
//       } else {
//         debugPrint('⚠️ POST response data not available, trying GET API fallback');
//         // Fallback: Fetch enrollment details using GET API
//         await verificationProvider.getEnrollmentDetails(nrkId);
        
//         debugPrint('=== PAYMENT SUCCESS - GET API COMPLETED ===');
//         debugPrint('Enrollment Details: ${verificationProvider.enrollmentDetails}');

//         if (verificationProvider.enrollmentDetails.isNotEmpty) {
//           final data = verificationProvider.enrollmentDetails['data'];
//           if (data != null) {
//             _enrollmentNumber =
//                 data['self_enrollment_number'] ?? 'NC1234567890';
//             debugPrint('✅ Enrollment number from GET response: $_enrollmentNumber');
//             debugPrint('✅ Full GET response data: $data');
//             setState(() {});
//             // ToastMessage.successToast('Enrollment completed successfully!');
//           } else {
//             debugPrint('❌ GET response data is null');
//           }
//         } else {
//           debugPrint('❌ Enrollment details are empty');
//         }
//       }
      
//       debugPrint('=== PAYMENT SUCCESS - FINAL ENROLLMENT NUMBER ===');
//       debugPrint('Final Enrollment Number: $_enrollmentNumber');

//       // Step 3: Call Vidal enrollment API after successful NORKA enrollment
//       if (verificationProvider.errorMessage.isEmpty) {
//         await _handleVidalEnrollment(
//           verificationProvider,
//           norkaProvider,
//           emailId,
//           nrkId,
//         );
//       }
//     } catch (e) {
//       debugPrint('Enrollment error: $e');
//       ToastMessage.failedToast('Enrollment process failed. Please try again.');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isEnrolling = false;
//         });
//       }
//     }
//   }

//   /// Handle Vidal enrollment API call
//   Future<void> _handleVidalEnrollment(
//     VerificationProvider verificationProvider,
//     NorkaProvider norkaProvider,
//     String emailId,
//     String nrkId,
//   ) async {
//     try {
//       debugPrint('=== Starting Vidal Enrollment Process ===');
//       debugPrint('NORKA Response: ${norkaProvider.response}');
//       debugPrint(
//         'Enrollment Details: ${verificationProvider.enrollmentDetails}',
//       );
//       debugPrint(
//         'Family Members Details: ${verificationProvider.familyMembersDetails}',
//       );

//       // Get family members data for Vidal enrollment
//       await verificationProvider.getFamilyMembers(nrkId);
//       debugPrint(
//         'Family Members after fetch: ${verificationProvider.familyMembersDetails}',
//       );

//       // Get dates details for Vidal enrollment
//       await verificationProvider.getDatesDetails(nrkId);
//       debugPrint(
//         'Dates Details after fetch: ${verificationProvider.datesDetails}',
//       );

//       // Get verified customer data from OTP verification provider
//       final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
//         context,
//         listen: false,
//       );
//       final verifiedCustomerData = otpVerificationProvider
//           .getVerifiedCustomerData();

//       // Use verified customer data if available, otherwise use NORKA provider data
//       final customerData = verifiedCustomerData ?? norkaProvider.response;

//       debugPrint('=== Vidal Enrollment Data Source Debug ===');
//       debugPrint(
//         'Using verified customer data: ${verifiedCustomerData != null}',
//       );
//       debugPrint(
//         'Using NORKA provider data: ${norkaProvider.response != null}',
//       );
//       debugPrint('Final customer data: $customerData');
//       debugPrint('=== End Vidal Enrollment Data Source Debug ===');

//       // Check if we have all required data
//       if (customerData == null) {
//         debugPrint('❌ Customer data not available from any source');
//         // ToastMessage.failedToast(
//         //   'Unable to process enrollment: Missing customer data',
//         // );
//         return;
//       }

//       if (verificationProvider.enrollmentDetails.isEmpty) {
//         debugPrint('❌ Enrollment details not available');
//         // ToastMessage.failedToast(
//         //   'Unable to process enrollment: Missing enrollment data',
//         // );
//         return;
//       }

//       if (verificationProvider.familyMembersDetails.isEmpty) {
//         debugPrint('❌ Family members details not available');
//         // ToastMessage.failedToast(
//         //   'Unable to process  enrollment: Missing family data',
//         // );
//         return;
//       }

//       // Build Vidal enrollment payload
//       final vidalPayload = VidalDataMapper.buildVidalEnrollmentPayload(
//         norkaResponse: customerData,
//         enrollmentDetails: verificationProvider.enrollmentDetails,
//         familyMembersDetails: verificationProvider.familyMembersDetails,
//         emailId: emailId,
//         nrkId: nrkId,
//         requestId: verificationProvider.requestIdDetails['data']?['request_id'],
//         datesDetails: verificationProvider.datesDetails,
//       );

//       debugPrint('=== Vidal Enrollment Payload ===');
//       debugPrint(
//         'Payload Length: ${vidalPayload.toString().length} characters',
//       );

//       // Print each dependent separately for better visibility
//       final dependentInfo =
//           vidalPayload['employeeinfo']?['policyinfo']?[0]?['dependent_info']
//               as List?;
//       if (dependentInfo != null) {
//         debugPrint('Dependent Info Count: ${dependentInfo.length}');
//         for (int i = 0; i < dependentInfo.length; i++) {
//           debugPrint('Dependent $i: ${dependentInfo[i]}');
//         }
//       }

//       // Print full payload as formatted JSON
//       try {
//         final jsonString = JsonEncoder.withIndent('  ').convert(vidalPayload);
//         debugPrint('=== Full Payload as JSON ===');
//         debugPrint(jsonString);
//         debugPrint('=== End Full Payload ===');
//       } catch (e) {
//         debugPrint('Error formatting JSON: $e');
//         debugPrint('Raw payload: $vidalPayload');
//       }

//       // Validate payload before sending
//       if (vidalPayload['employeeinfo'] == null ||
//           vidalPayload['employeeinfo']['employee_no'].toString().isEmpty) {
//         debugPrint('❌ Invalid Vidal payload: Missing employee info');
//         // ToastMessage.failedToast(
//         //   'Unable to process Vidal enrollment: Invalid data format',
//         // );
//         return;
//       }

//       // Call Vidal enrollment API
//       debugPrint('=== CALLING VIDAL ENROLLMENT API ===');
//       await verificationProvider.vidalEnrollment(vidalPayload);

//       // Log the final response
//       debugPrint('=== VIDAL ENROLLMENT FINAL RESULT ===');
//       debugPrint('Error Message: ${verificationProvider.errorMessage}');
//       debugPrint('Response: ${verificationProvider.response}');
//       debugPrint('=== END VIDAL ENROLLMENT RESULT ===');

//       if (verificationProvider.errorMessage.isNotEmpty) {
//         debugPrint(
//           '❌ Vidal enrollment failed: ${verificationProvider.errorMessage}',
//         );
//         // ToastMessage.failedToast(
//         //   'Vidal enrollment failed: ${verificationProvider.errorMessage}',
//         // );
//       } else {
//         debugPrint('✅ Vidal enrollment completed successfully');
//         debugPrint('✅ Final Response: ${verificationProvider.response}');
//         // ToastMessage.successToast('Vidal enrollment completed successfully!');
//       }
//     } catch (e) {
//       debugPrint('❌ Vidal enrollment error: $e');
//       ToastMessage.failedToast('Enrollment process failed. Please try again.');
//     }
//   }

//   Future<void> _handleBackToHome() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Simulate API call or data processing
//       await Future.delayed(const Duration(seconds: 1));

//       if (mounted) {
//         // Login user before navigating to app
//         final authProvider = Provider.of<AuthProvider>(context, listen: false);
//         final norkaId = widget.nrkId ?? '';
//         await authProvider.login(norkaId);

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const AppNavigationBar()),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       // Handle error if needed
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }





// // import 'package:flutter/material.dart';
// // import 'package:norkacare_app/utils/constants.dart';
// // import 'package:norkacare_app/widgets/app_text.dart';
// // import 'package:norkacare_app/provider/verification_provider.dart';
// // import 'package:norkacare_app/provider/norka_provider.dart';
// // import 'package:norkacare_app/widgets/toast_message.dart';
// // import 'package:provider/provider.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // class Documents extends StatelessWidget {
// //   final Map<String, dynamic> customerInsuranceData;

// //   const Documents({super.key, required this.customerInsuranceData});

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           AppText(
// //             text: 'Documents',
// //             size: 18,
// //             weight: FontWeight.bold,
// //             textColor: isDarkMode
// //                 ? AppConstants.whiteColor
// //                 : AppConstants.blackColor,
// //           ),
// //           const SizedBox(height: 15),
// //           ...customerInsuranceData['documents'].map<Widget>((document) {
// //             return _buildDocumentCard(context, document);
// //           }).toList(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildDocumentCard(
// //     BuildContext context,
// //     Map<String, dynamic> document,
// //   ) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: isDarkMode
// //             ? AppConstants.boxBlackColor
// //             : AppConstants.whiteColor,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: isDarkMode
// //               ? Colors.white.withOpacity(0.1)
// //               : Colors.grey.withOpacity(0.2),
// //           width: 1,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: isDarkMode
// //                 ? Colors.black.withOpacity(0.3)
// //                 : Colors.grey.withOpacity(0.1),
// //             spreadRadius: 1,
// //             blurRadius: 5,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 40,
// //             height: 40,
// //             decoration: BoxDecoration(
// //               color: AppConstants.primaryColor.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Icon(
// //               Icons.description,
// //               color: AppConstants.primaryColor,
// //               size: 20,
// //             ),
// //           ),
// //           const SizedBox(width: 16),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 AppText(
// //                   text: "E-Card",
// //                   size: 16,
// //                   weight: FontWeight.w600,
// //                   textColor: isDarkMode
// //                       ? AppConstants.whiteColor
// //                       : AppConstants.blackColor,
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Row(
// //                   children: [
// //                     AppText(
// //                       text: "PDF",
// //                       size: 12,
// //                       weight: FontWeight.w500,
// //                       textColor: isDarkMode
// //                           ? AppConstants.greyColor.withOpacity(0.8)
// //                           : AppConstants.greyColor,
// //                     ),
// //                     const SizedBox(width: 8),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 4),
// //               ],
// //             ),
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.download, color: AppConstants.primaryColor),
// //             onPressed: () => _handleDownloadECard(context, document),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _handleDownloadECard(
// //     BuildContext context,
// //     Map<String, dynamic> document,
// //   ) async {
// //     final verificationProvider = Provider.of<VerificationProvider>(
// //       context,
// //       listen: false,
// //     );
// //     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

// //     // Show loading dialog
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           backgroundColor: Colors.transparent,
// //           child: Center(
// //             child: CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(
// //                 AppConstants.primaryColor,
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );

// //     try {
// //       // Get the NORKA ID from the provider
// //       String employeeCode = norkaProvider.norkaId;

// //       if (employeeCode.isEmpty) {
// //         Navigator.of(context).pop(); // Close loading dialog
// //         ToastMessage.failedToast('NORKA ID not found');
// //         return;
// //       }

// //       // Call the Vidal E-Card API
// //       await verificationProvider.vidalEnrollmentEcard({
// //         'employee_code': employeeCode,
// //       });

// //       Navigator.of(context).pop(); // Close loading dialog

// //       // Check if API call was successful
// //       if (verificationProvider.errorMessage.isNotEmpty) {
// //         // Check if it's actually an error or just a success message
// //         final message = verificationProvider.errorMessage.toLowerCase();
// //         if (message.contains('error') || 
// //             message.contains('failed') || 
// //             message.contains('invalid') ||
// //             message.contains('not found') ||
// //             message.contains('unauthorized')) {
// //           ToastMessage.failedToast(verificationProvider.errorMessage);
// //           return;
// //         }
// //       }

// //       final response = verificationProvider.response;
      
// //       if (response != null) {
        
// //         // Try multiple extraction methods
// //         String? eCardUrl;
        
// //         // Method 1: Direct extraction
// //         try {
// //           if (response['success'] == true && 
// //               response['data'] != null && 
// //               response['data']['data'] != null && 
// //               response['data']['data'] is List &&
// //               (response['data']['data'] as List).isNotEmpty) {
            
// //             final firstCard = (response['data']['data'] as List)[0];
// //             eCardUrl = firstCard['ecardUrl'];
// //             debugPrint('✅ E-Card URL extracted: ${eCardUrl?.substring(0, 50)}...');
// //           }
// //         } catch (e) {
// //           debugPrint('❌ URL extraction failed: $e');
// //         }
        
// //         // Method 2: Alternative extraction
// //         if (eCardUrl == null || eCardUrl.isEmpty) {
// //           try {
// //             final data = response['data'];
// //             if (data != null && data['data'] != null) {
// //               final cards = data['data'];
// //               if (cards is List && cards.isNotEmpty) {
// //                 eCardUrl = cards[0]['ecardUrl'];
// //                 debugPrint('✅ Method 2 success: $eCardUrl');
// //               }
// //             }
// //           } catch (e) {
// //             debugPrint('❌ Method 2 failed: $e');
// //           }
// //         }
        
        
// //         if (eCardUrl != null && eCardUrl.isNotEmpty) {
// //           // ToastMessage.successToast('Opening E-Card...');
          
// //           try {
// //             final Uri uri = Uri.parse(eCardUrl);
// //             final canLaunch = await canLaunchUrl(uri);
            
// //             if (canLaunch) {
// //               await launchUrl(uri);
// //               ToastMessage.successToast('E-Card opened successfully!');
// //             } else {
// //               ToastMessage.failedToast('Cannot open E-Card URL');
// //             }
// //           } catch (e) {
// //             ToastMessage.failedToast('Error opening E-Card: $e');
// //           }
// //         } else {
// //           ToastMessage.failedToast('No E-Card URL found');
// //         }
// //       } else {
// //         ToastMessage.failedToast('No response from server');
// //       }
// //     } catch (e) {
// //       Navigator.of(context).pop(); // Close loading dialog
// //       ToastMessage.failedToast('Error: ${e.toString()}');
// //     }
// //   }
// // }



// // import 'package:norkacare_app/utils/constants.dart';
// // import 'package:norkacare_app/widgets/app_text.dart';
// // import 'package:norkacare_app/widgets/custom_button.dart';
// // import 'package:norkacare_app/provider/verification_provider.dart';
// // import 'package:norkacare_app/provider/norka_provider.dart';
// // import 'package:norkacare_app/widgets/toast_message.dart';
// // import 'package:norkacare_app/widgets/shimmer_widgets.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class DocumentsPage extends StatefulWidget {
// //   const DocumentsPage({super.key});

// //   @override
// //   State<DocumentsPage> createState() => _DocumentsPageState();

// //   // Static method to reset shimmer state (call this on logout)
// //   static void resetShimmerState() {
// //     _DocumentsPageState.resetShimmerState();
// //   }

// //   // Static method to reset SharedPreferences shimmer flag (call this on logout)
// //   static Future<void> resetShimmerPreferences() async {
// //     await _DocumentsPageState.resetShimmerPreferences();
// //   }
// // }

// // class _DocumentsPageState extends State<DocumentsPage> {
// //   final List<Map<String, dynamic>> allDocuments = [
// //     {'name': 'E-Card', 'type': 'PDF'},
// //     {'name': 'Policy document', 'type': 'VIEW'},
// //   ];

// //   bool _isInitialLoading = true;

// //   // Static variable to track if shimmer has been shown for this page
// //   static bool _hasShownDocumentsShimmer = false;

// //   // Static method to reset shimmer state (call this on logout)
// //   static void resetShimmerState() {
// //     _hasShownDocumentsShimmer = false;
// //   }

// //   // Static method to reset SharedPreferences shimmer flag (call this on logout)
// //   static Future<void> resetShimmerPreferences() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove('has_shown_documents_shimmer');
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeShimmerState();
// //   }

// //   void _initializeShimmerState() {
// //     if (_hasShownDocumentsShimmer) {
// //       // Shimmer has been shown before, don't show it
// //       _isInitialLoading = false;
// //       // Load data immediately
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _loadDocumentsData();
// //       });
// //     } else {
// //       // First time visiting this page, show shimmer
// //       _startShimmerTimer();
// //     }
// //   }

// //   void _startShimmerTimer() {
// //     // Load data during shimmer phase
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _loadDocumentsData();
// //     });

// //     // Show shimmer for 2 seconds on first visit to this page
// //     Future.delayed(const Duration(milliseconds: 2000), () {
// //       if (mounted) {
// //         _hasShownDocumentsShimmer = true; // Mark shimmer as shown
// //         setState(() {
// //           _isInitialLoading = false;
// //         });
// //         // Mark that shimmer has been shown in SharedPreferences too
// //         _saveShimmerFlag();
// //       }
// //     });
// //   }

// //   Future<void> _saveShimmerFlag() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('has_shown_documents_shimmer', true);
// //   }

// //   void _loadDocumentsData() async {
// //     // Since documents are static, we don't need to load any API data
// //     // This method is here for consistency with other pages
// //     // In the future, if documents need to be loaded from API, add the logic here
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     return Scaffold(
// //       backgroundColor: isDarkMode
// //           ? AppConstants.darkBackgroundColor
// //           : AppConstants.whiteBackgroundColor,
// //       appBar: AppBar(
// //         backgroundColor: AppConstants.primaryColor,
// //         elevation: 0,
// //         scrolledUnderElevation: 0,
// //         surfaceTintColor: Colors.transparent,
// //         automaticallyImplyLeading: false,
// //         title: AppText(
// //           text: 'Documents',
// //           size: 20,
// //           weight: FontWeight.bold,
// //           textColor: AppConstants.whiteColor,
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: _isInitialLoading
// //           ? ShimmerWidgets.buildShimmerDocumentsPage(isDarkMode: isDarkMode)
// //           : SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   if (allDocuments.isNotEmpty) ...[
// //                     const SizedBox(height: 20),
// //                     ListView.builder(
// //                       shrinkWrap: true,
// //                       physics: const NeverScrollableScrollPhysics(),
// //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// //                       itemCount: allDocuments.length,
// //                       itemBuilder: (context, index) {
// //                         return _buildDocumentCard(allDocuments[index]);
// //                       },
// //                     ),
// //                     const SizedBox(height: 20),
// //                   ] else
// //                     Container(
// //                       height: MediaQuery.of(context).size.height * 0.5,
// //                       child: _buildEmptyState(),
// //                     ),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildDocumentCard(Map<String, dynamic> document) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: isDarkMode
// //             ? AppConstants.boxBlackColor
// //             : AppConstants.whiteColor,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: isDarkMode
// //               ? Colors.white.withOpacity(0.1)
// //               : Colors.grey.withOpacity(0.2),
// //           width: 1,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: isDarkMode
// //                 ? Colors.black.withOpacity(0.3)
// //                 : Colors.grey.withOpacity(0.1),
// //             spreadRadius: 1,
// //             blurRadius: 5,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           // Header
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: isDarkMode
// //                   ? AppConstants.darkBackgroundColor
// //                   : Colors.grey[50],
// //               borderRadius: const BorderRadius.only(
// //                 topLeft: Radius.circular(12),
// //                 topRight: Radius.circular(12),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: AppConstants.primaryColor.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Icon(
// //                     _getDocumentIcon(document['type']),
// //                     color: AppConstants.primaryColor,
// //                     size: 20,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       AppText(
// //                         text: document['name'],
// //                         size: 16,
// //                         weight: FontWeight.w600,
// //                         textColor: isDarkMode
// //                             ? AppConstants.whiteColor
// //                             : AppConstants.blackColor,
// //                       ),

// //                       AppText(
// //                         text: _getDocumentDescription(document['name']),
// //                         size: 13,
// //                         weight: FontWeight.w500,
// //                         textColor: isDarkMode
// //                             ? AppConstants.whiteColor
// //                             : AppConstants.blackColor,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 if (document['type'] != 'VIEW')
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.end,
// //                     children: [
// //                       const SizedBox(height: 4),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 8,
// //                           vertical: 4,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: AppConstants.secondaryColor.withOpacity(0.1),
// //                           border: Border.all(
// //                             color: AppConstants.secondaryColor.withOpacity(0.3),
// //                             width: 1,
// //                           ),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         child: AppText(
// //                           text: document['type'],
// //                           size: 12,
// //                           weight: FontWeight.w600,
// //                           textColor: AppConstants.secondaryColor,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //               ],
// //             ),
// //           ),

// //           // Action Button
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               color: isDarkMode
// //                   ? AppConstants.darkBackgroundColor
// //                   : Colors.grey[50],
// //               borderRadius: const BorderRadius.only(
// //                 bottomLeft: Radius.circular(12),
// //                 bottomRight: Radius.circular(12),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: CustomButton(
// //                     text: document['type'] == 'VIEW' ? 'View' : 'Download',
// //                     onPressed: () => _handleDocumentDownload(context, document),
// //                     color: document['type'] == 'VIEW'
// //                         ? AppConstants.primaryColor
// //                         : AppConstants.secondaryColor,
// //                     textColor: document['type'] == 'VIEW'
// //                         ? AppConstants.whiteColor
// //                         : AppConstants.blackColor,
// //                     height: 40,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(
// //             Icons.folder_outlined,
// //             size: 80,
// //             color: AppConstants.greyColor.withOpacity(0.5),
// //           ),
// //           const SizedBox(height: 16),
// //           AppText(
// //             text: 'No documents found',
// //             size: 18,
// //             weight: FontWeight.w600,
// //             textColor: isDarkMode
// //                 ? AppConstants.whiteColor
// //                 : AppConstants.greyColor,
// //           ),
// //           const SizedBox(height: 8),
// //           AppText(
// //             text: 'No documents available at the moment',
// //             size: 14,
// //             weight: FontWeight.normal,
// //             textColor: AppConstants.greyColor,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   IconData _getDocumentIcon(String type) {
// //     switch (type.toUpperCase()) {
// //       case 'PDF':
// //         return Icons.picture_as_pdf;
// //       case 'DOC':
// //       case 'DOCX':
// //         return Icons.description;
// //       case 'XLS':
// //       case 'XLSX':
// //         return Icons.table_chart;
// //       case 'JPG':
// //       case 'JPEG':
// //       case 'PNG':
// //         return Icons.image;
// //       default:
// //         return Icons.insert_drive_file;
// //     }
// //   }

// //   String _getDocumentDescription(String documentName) {
// //     switch (documentName) {
// //       case 'E-Card':
// //         return 'Document';
// //       case 'Policy document':
// //         return 'Insurance policy benefits';
// //       default:
// //         return 'Document';
// //     }
// //   }

// //   Future<void> _handleDocumentDownload(
// //     BuildContext context,
// //     Map<String, dynamic> document,
// //   ) async {
// //     switch (document['name']) {
// //       case 'E-Card':
// //         await _handleDownloadECard(context, document);
// //         break;
// //       case 'Policy document':
// //         await _handleDownloadPolicyDocument(context, document);
// //         break;
// //       default:
// //         ToastMessage.failedToast('Document download not available');
// //     }
// //   }

// //   Future<void> _handleDownloadECard(
// //     BuildContext context,
// //     Map<String, dynamic> document,
// //   ) async {
// //     final verificationProvider = Provider.of<VerificationProvider>(
// //       context,
// //       listen: false,
// //     );
// //     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

// //     // Show loading dialog
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           backgroundColor: Colors.transparent,
// //           child: Center(
// //             child: CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(
// //                 AppConstants.primaryColor,
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );

// //     try {
// //       // Get the NORKA ID from the provider
// //       String employeeCode = norkaProvider.norkaId;

// //       if (employeeCode.isEmpty) {
// //         Navigator.of(context).pop(); // Close loading dialog
// //         // ToastMessage.failedToast('NORKA ID not found');
// //         return;
// //       }

// //       // Call the Vidal E-Card API
// //       await verificationProvider.vidalEnrollmentEcard({
// //         'employee_code': employeeCode,
// //       });

// //       Navigator.of(context).pop(); // Close loading dialog

// //       // Check if API call was successful
// //       if (verificationProvider.errorMessage.isNotEmpty) {
// //         // Check if it's actually an error or just a success message
// //         final message = verificationProvider.errorMessage.toLowerCase();
// //         if (message.contains('error') || 
// //             message.contains('failed') || 
// //             message.contains('invalid') ||
// //             message.contains('not found') ||
// //             message.contains('unauthorized')) {
// //           ToastMessage.failedToast(verificationProvider.errorMessage);
// //           return;
// //         }
// //       }

// //       // Extract E-Card URL from response
// //       final response = verificationProvider.response;
// //       String? eCardUrl;
      
// //       if (response != null) {
// //         // Try multiple extraction methods
// //         // Method 1: Direct extraction
// //         try {
// //           if (response['success'] == true && 
// //               response['data'] != null && 
// //               response['data']['data'] != null && 
// //               response['data']['data'] is List &&
// //               (response['data']['data'] as List).isNotEmpty) {
            
// //             final firstCard = (response['data']['data'] as List)[0];
// //             eCardUrl = firstCard['ecardUrl'];
// //             debugPrint('✅ E-Card URL extracted: ${eCardUrl?.substring(0, 50)}...');
// //           }
// //         } catch (e) {
// //           debugPrint('❌ URL extraction failed: $e');
// //         }
        
// //         // Method 2: Alternative extraction
// //         if (eCardUrl == null || eCardUrl.isEmpty) {
// //           try {
// //             final data = response['data'];
// //             if (data != null && data['data'] != null) {
// //               final cards = data['data'];
// //               if (cards is List && cards.isNotEmpty) {
// //                 eCardUrl = cards[0]['ecardUrl'];
// //                 debugPrint('✅ E-Card URL extracted (method 2): ${eCardUrl?.substring(0, 50)}...');
// //               }
// //             }
// //           } catch (e) {
// //             debugPrint('❌ Method 2 failed: $e');
// //           }
// //         }
// //       }

// //       if (eCardUrl != null && eCardUrl.isNotEmpty) {
// //         // ToastMessage.successToast('Opening E-Card...');
        
// //         try {
// //           final Uri uri = Uri.parse(eCardUrl);
// //           final canLaunch = await canLaunchUrl(uri);
          
// //           if (canLaunch) {
// //             await launchUrl(uri);
// //             ToastMessage.successToast('E-Card opened successfully!');
// //           } else {
// //             ToastMessage.failedToast('Cannot open E-Card URL');
// //           }
// //         } catch (e) {
// //           ToastMessage.failedToast('Error opening E-Card: $e');
// //         }
// //       } else {
// //         ToastMessage.failedToast('No E-Card URL found');
// //       }
// //     } catch (e) {
// //       Navigator.of(context).pop(); // Close loading dialog
// //       ToastMessage.failedToast('Error: ${e.toString()}');
// //     }
// //   }

// //   Future<void> _handleDownloadPolicyDocument(
// //     BuildContext context,
// //     Map<String, dynamic> document,
// //   ) async {
// //     _showPolicyDocumentDialog(context);
// //   }

// //   void _showPolicyDocumentDialog(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           backgroundColor: Colors.transparent,
// //           child: Container(
// //             constraints: BoxConstraints(
// //               maxHeight: MediaQuery.of(context).size.height * 0.8,
// //               maxWidth: MediaQuery.of(context).size.width * 0.9,
// //             ),
// //             decoration: BoxDecoration(
// //               color: isDarkMode
// //                   ? AppConstants.darkBackgroundColor
// //                   : AppConstants.whiteColor,
// //               borderRadius: BorderRadius.circular(16),
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 // Header
// //                 Container(
// //                   padding: const EdgeInsets.all(20),
// //                   decoration: BoxDecoration(
// //                     color: AppConstants.primaryColor,
// //                     borderRadius: const BorderRadius.only(
// //                       topLeft: Radius.circular(16),
// //                       topRight: Radius.circular(16),
// //                     ),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(
// //                         Icons.description_outlined,
// //                         color: AppConstants.whiteColor,
// //                         size: 24,
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: AppText(
// //                           text: 'Policy document',
// //                           size: 18,
// //                           weight: FontWeight.bold,
// //                           textColor: AppConstants.whiteColor,
// //                         ),
// //                       ),
// //                       IconButton(
// //                         onPressed: () => Navigator.of(context).pop(),
// //                         icon: Icon(Icons.close, color: AppConstants.whiteColor),
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 // Content
// //                 Flexible(
// //                   child: SingleChildScrollView(
// //                     padding: const EdgeInsets.all(20),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         _buildPolicySection('Important Policy Benefits - GMC', [
// //                           'GMC Coverage - Rs 5 Lakhs per Year per Family',
// //                           'Coverage of Rs 5 Lakhs for Individuals also',
// //                           'Room Rent 5000/- Per day and ICU 10000/- per Day',
// //                           'Medical Expenses no limits upto 5 Lakhs SA',
// //                           'No Medical Check up to 70 Years and no rejections',
// //                           'Day 1 Coverage for any preexisting disease',
// //                           'Chemo, Dialysis etc. will be covered after discharge without admission as day care procedure',
// //                           'No Co-Pay for any claims',
// //                           'Ayush covered up to 50000 per year (Ayurveda, Yoga & Naturopathy, Unani, Sidha and Homeopathy) with IP',
// //                           'Cataract Covered 30000/- per eye without admission',
// //                           'Up to 25 years 2 kids can continue under Family Cover without any additional Premium. Additional kids more than 2 can be added with additional premium',
// //                           '30 days Pre and 60 days Post hospitalization medical expenses can claim up to Rs 5000 Per claim',
// //                           'No medical check up or any kind of health declaration required for enrolment from 18 - 70 years',
// //                           'No Premium Loading for policy renewals due to Claim, age band change etc. Flat premium for 18 - 70 years',
// //                           'Portability benefits available after 70 years or anybody changes their NRK status with all benefits and no medicals required for converting as an Individual Policy',
// //                           'Maternity not covered but any hospitalization except delivery covered and new born baby covered from Day One',
// //                           'Option for Family Sum Assured of 5 Lakhs or Individual SA of 5 Lakhs if NRK id is separate in the same family',
// //                           'After 25 years for kids, portability benefits available to continue the coverages or can join with Norka Care with an NRK Card is eligible',
// //                           'Organ Transplant if any covered upto the Sum Assured',
// //                           'No Premium increments due to high claims or confirmed claims like hemodialysis if any',
// //                           'No Waiting Period',
// //                           'No Premium loading',
// //                           'No Co-pay',
// //                           'up to 70 Yrs eligible',
// //                           'No Medical check up',
// //                         ], isDarkMode),
// //                         const SizedBox(height: 20),
// //                         _buildPolicySection(
// //                           'Important Policy Benefits - GPA (Only Accidents Covered)',
// //                           [
// //                             'Any Kind of Accidental Death Across the World - 10 Lakhs SA',
// //                             'Permanent Total Disability - 10 Lakhs',
// //                             'Loss of both hand or both Feets - 10 lakhs',
// //                             'Loss of One hand and one feet - 10 Lakhs',
// //                             'Loss of one eye and one hand or foot - 10 Lakhs',
// //                             'Total permanent Paralise due to accident - 10 Lakhs',
// //                             'Loss of Vision in both eyes - 10 Lakhs',
// //                             'Hearing Loss - Both ears - 7.5 Lakhs',
// //                             'Loss of One Eyes/Hand/Feet - 5 Lakhs',
// //                             'Loss of One Hand and 4 fingers - 5 Lakhs',
// //                             'Loss of 4 fingers and thump of one hand - 5 Lakhs',
// //                             'Loss of four fingers - 3.5 Lakhs',
// //                             'Loss of thump - 2.5 Lakhs',
// //                             'Body repatriation - 50000/- for outside India',
// //                             'Body repatriation - 25000/- for Inside India',
// //                           ],
// //                           isDarkMode,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 // Footer
// //                 Container(
// //                   padding: const EdgeInsets.all(20),
// //                   decoration: BoxDecoration(
// //                     color: AppConstants.primaryColor,
// //                     borderRadius: const BorderRadius.only(
// //                       bottomLeft: Radius.circular(16),
// //                       bottomRight: Radius.circular(16),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildPolicySection(
// //     String title,
// //     List<String> benefits,
// //     bool isDarkMode,
// //   ) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         AppText(
// //           text: title,
// //           size: 16,
// //           weight: FontWeight.bold,
// //           textColor: isDarkMode
// //               ? AppConstants.whiteColor
// //               : AppConstants.blackColor,
// //         ),
// //         const SizedBox(height: 12),
// //         ...benefits
// //             .map(
// //               (benefit) => Padding(
// //                 padding: const EdgeInsets.only(bottom: 8),
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Container(
// //                       margin: const EdgeInsets.only(top: 6, right: 8),
// //                       width: 4,
// //                       height: 4,
// //                       decoration: BoxDecoration(
// //                         color: AppConstants.primaryColor,
// //                         shape: BoxShape.circle,
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: AppText(
// //                         text: benefit,
// //                         size: 13,
// //                         weight: FontWeight.normal,
// //                         textColor: isDarkMode
// //                             ? AppConstants.whiteColor.withOpacity(0.9)
// //                             : AppConstants.blackColor,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             )
// //             .toList(),
// //       ],
// //     );
// //   }
// // }

