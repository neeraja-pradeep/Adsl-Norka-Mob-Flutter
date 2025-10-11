// import 'package:norkacare_app/navigation/app_navigation_bar.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

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
//   Map<String, dynamic> _enrollmentDetails = {};

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
//                   text: 'Payment Successful',
//                   size: 28,
//                   weight: FontWeight.bold,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Confirmation Message
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: AppText(
//                   text: 'You have successfully enrolled',
//                   size: 18,
//                   weight: FontWeight.w500,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 24),

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
//                     Container(
//                       width: double.infinity,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.primaryColor,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: AppConstants.primaryColor,
//                           width: 1,
//                         ),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: _handleViewECard,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: AppText(
//                           text: 'Download E-Card',
//                           size: 16,
//                           weight: FontWeight.w600,
//                           textColor: isDarkMode
//                               ? AppConstants.primaryColor
//                               : AppConstants.whiteColor,
//                         ),
//                       ),
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
//               const SizedBox(height: 30),
//               // Policy Information Message
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.primaryColor.withOpacity(0.1)
//                         : AppConstants.primaryColor.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: isDarkMode
//                           ? AppConstants.primaryColor.withOpacity(0.2)
//                           : AppConstants.primaryColor.withOpacity(0.2),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             color: AppConstants.primaryColor,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           AppText(
//                             text: 'Next Steps',
//                             size: 16,
//                             weight: FontWeight.w600,
//                             textColor: AppConstants.primaryColor,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       AppText(
//                         text:
//                             'Check your "My Policy" to track your E-Card. You can also track E-Card and download your E-Card and Policy conditions.',
//                         size: 14,
//                         weight: FontWeight.normal,
//                         textColor: AppConstants.greyColor,
//                         textAlign: TextAlign.left,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleViewECard() async {
//     // Show E-Card as a physical card-like design
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: double.infinity,
//             height: 220,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   AppConstants.primaryColor,
//                   AppConstants.primaryColor.withOpacity(0.8),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Stack(
//               children: [
//                 // Card content
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(
//                             text: 'NORKA CARE',
//                             size: 16,
//                             weight: FontWeight.bold,
//                             textColor: Colors.white,
//                           ),
//                           AppText(
//                             text: 'E-CARD',
//                             size: 12,
//                             weight: FontWeight.w500,
//                             textColor: Colors.white.withOpacity(0.9),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

//                       // Member name
//                       AppText(
//                         text: _enrollmentDetails['nrk_name'] ?? 'AMALNATH C K',
//                         size: 18,
//                         weight: FontWeight.bold,
//                         textColor: Colors.white,
//                       ),
//                       const SizedBox(height: 8),

//                       // Policy number
//                       AppText(
//                         text:
//                             'Policy: ${_enrollmentDetails['self_enrollment_number'] ?? _enrollmentNumber}',
//                         size: 12,
//                         weight: FontWeight.w500,
//                         textColor: Colors.white.withOpacity(0.9),
//                       ),
//                       const SizedBox(height: 4),

//                       // Sum insured
//                       AppText(
//                         text: 'Sum Insured: ₹5,00,000',
//                         size: 12,
//                         weight: FontWeight.w500,
//                         textColor: Colors.white.withOpacity(0.9),
//                       ),
//                       const Spacer(),

//                       // Validity
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppText(
//                                 text: 'VALID FROM',
//                                 size: 8,
//                                 weight: FontWeight.w500,
//                                 textColor: Colors.white.withOpacity(0.7),
//                               ),
//                               AppText(
//                                 text: '08/09/2025',
//                                 size: 10,
//                                 weight: FontWeight.bold,
//                                 textColor: Colors.white,
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               AppText(
//                                 text: 'VALID UNTIL',
//                                 size: 8,
//                                 weight: FontWeight.w500,
//                                 textColor: Colors.white.withOpacity(0.7),
//                               ),
//                               AppText(
//                                 text: '07/09/2026',
//                                 size: 10,
//                                 weight: FontWeight.bold,
//                                 textColor: Colors.white,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
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

//       // If not provided in widget, try to get from providers
//       if (emailId.isEmpty && norkaProvider.response != null) {
//         final emails = norkaProvider.response!['emails'];
//         if (emails != null && emails.isNotEmpty) {
//           emailId = emails[0]['address'] ?? '';
//         }
//       }

//       if (nrkId.isEmpty) {
//         nrkId = norkaProvider.norkaId;
//       }

//       if (emailId.isEmpty || nrkId.isEmpty) {
//         ToastMessage.failedToast(
//           'Unable to process enrollment: Missing user data',
//         );
//         return;
//       }

//       // Step 1: Call enrollment POST API
//       final enrollmentData = {'email_id': emailId, 'nrk_id_no': nrkId};

//       await verificationProvider.Enrolling(enrollmentData);

//       if (verificationProvider.errorMessage.isNotEmpty) {
//         ToastMessage.failedToast(
//           'Enrollment failed: ${verificationProvider.errorMessage}',
//         );
//         return;
//       }

//       // Check if enrollment data is available in the POST response
//       if (verificationProvider.response != null &&
//           verificationProvider.response!['data'] != null) {
//         final data = verificationProvider.response!['data'];
//         _enrollmentDetails = data;
//         _enrollmentNumber = data['self_enrollment_number'] ?? 'NC1234567890';
//         setState(() {});
//         ToastMessage.successToast('Enrollment completed successfully!');
//       } else {
//         // Fallback: Fetch enrollment details using GET API
//         await verificationProvider.getEnrollmentDetails(nrkId);

//         if (verificationProvider.enrollmentDetails.isNotEmpty) {
//           final data = verificationProvider.enrollmentDetails['data'];
//           if (data != null) {
//             _enrollmentDetails = data;
//             _enrollmentNumber =
//                 data['self_enrollment_number'] ?? 'NC1234567890';
//             setState(() {});
//             ToastMessage.successToast('Enrollment completed successfully!');
//           }
//         }
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

//   Future<void> _handleBackToHome() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Simulate API call or data processing
//       await Future.delayed(const Duration(seconds: 1));

//       if (mounted) {
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

import 'dart:convert';
import 'package:norkacare_app/navigation/app_navigation_bar.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/otp_verification_provider.dart';
import 'package:norkacare_app/provider/auth_provider.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:norkacare_app/services/vidal_data_mapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String? emailId;
  final String? nrkId;

  const PaymentSuccessPage({super.key, this.emailId, this.nrkId});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  bool _isEnrolling = false;
  String _enrollmentNumber = 'NC1234567890'; // Default fallback

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleController.forward();
    _fadeController.forward();

    // Call enrollment APIs after payment success
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleEnrollmentProcess();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Success Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.primaryColor
                        : AppConstants.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDarkMode
                                    ? AppConstants.primaryColor
                                    : AppConstants.primaryColor)
                                .withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),

              // Success Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: AppText(
                  text: 'Policy Enrolled Successfully',
                  size: 20,
                  weight: FontWeight.bold,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
              const SizedBox(height: 16),

              // Confirmation Message
              // FadeTransition(
              //   opacity: _fadeAnimation,
              //   child: AppText(
              //     text: 'You have successfully enrolled',
              //     size: 18,
              //     weight: FontWeight.w500,
              //     textColor: isDarkMode
              //         ? AppConstants.whiteColor
              //         : AppConstants.blackColor,
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // const SizedBox(height: 24),
              FadeTransition(
                opacity: _fadeAnimation,
                child: AppText(
                  text: 'Enrollment number: $_enrollmentNumber',
                  size: 16,
                  weight: FontWeight.w500,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              const Spacer(),

              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Download E-Card Button - Disabled during enrollment processing
                    CustomButton(
                      text: _isEnrolling
                          ? 'Generating your E-card...'
                          : 'Download E-Card',
                      onPressed: _isEnrolling ? () {} : _handleViewECard,
                      color: AppConstants.secondaryColor,
                      textColor: AppConstants.blackColor,
                      height: 50,
                    ),
                    const SizedBox(height: 12),

                    // Back to Home Button
                    CustomButton(
                      text: _isLoading || _isEnrolling
                          ? 'Processing...'
                          : 'Back to Home',
                      onPressed: (_isLoading || _isEnrolling)
                          ? () {}
                          : _handleBackToHome,
                      color: AppConstants.primaryColor,
                      textColor: AppConstants.whiteColor,
                      height: 50,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Policy Information Message
              //   FadeTransition(
              //     opacity: _fadeAnimation,
              //     child: Container(
              //       padding: const EdgeInsets.all(16),
              //       decoration: BoxDecoration(
              //         color: isDarkMode
              //             ? AppConstants.primaryColor.withOpacity(0.1)
              //             : AppConstants.primaryColor.withOpacity(0.05),
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(
              //           color: isDarkMode
              //               ? AppConstants.primaryColor.withOpacity(0.2)
              //               : AppConstants.primaryColor.withOpacity(0.2),
              //         ),
              //       ),
              //       child: Column(
              //         children: [
              //           Row(
              //             children: [
              //               Icon(
              //                 Icons.info_outline,
              //                 color: AppConstants.primaryColor,
              //                 size: 20,
              //               ),
              //               const SizedBox(width: 8),
              //               AppText(
              //                 text: 'Next Steps',
              //                 size: 16,
              //                 weight: FontWeight.w600,
              //                 textColor: AppConstants.primaryColor,
              //               ),
              //             ],
              //           ),
              //           const SizedBox(height: 8),
              //           AppText(
              //             text:
              //                 'Check your "My Policy" to track your E-Card. You can also track E-Card and download your E-Card and Policy conditions.',
              //             size: 14,
              //             weight: FontWeight.normal,
              //             textColor: AppConstants.greyColor,
              //             textAlign: TextAlign.left,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleViewECard() async {
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
            ),
          ),
        );
      },
    );

    try {
      // Get the NORKA ID from provider or widget
      String employeeCode = '';

      // Try to get from widget first
      if (widget.nrkId != null && widget.nrkId!.isNotEmpty) {
        employeeCode = widget.nrkId!;
      } else {
        // Try to get from verified customer data first, then fallback to NORKA provider
        final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
          context,
          listen: false,
        );
        final verifiedCustomerData = otpVerificationProvider
            .getVerifiedCustomerData();

        if (verifiedCustomerData != null) {
          // Try different possible field names for NRK ID
          employeeCode = verifiedCustomerData['norka_id'] ?? 
                         verifiedCustomerData['nrk_id'] ?? 
                         verifiedCustomerData['norka_id_no'] ?? 
                         verifiedCustomerData['nrk_id_no'] ?? '';
        }
        
        // If still empty, try from NORKA provider
        if (employeeCode.isEmpty) {
          employeeCode = norkaProvider.norkaId;
        }
      }

      if (employeeCode.isEmpty) {
        Navigator.of(context).pop(); // Close loading dialog
        // ToastMessage.failedToast('NORKA ID not found');
        return;
      }

      // Call the Vidal E-Card API
      await verificationProvider.vidalEnrollmentEcard({
        // 'employeeCode': employeeCode,
        'employee_code': employeeCode,
      });

      Navigator.of(context).pop(); // Close loading dialog

      // Check if API call was successful
      if (verificationProvider.errorMessage.isNotEmpty) {
        // Check if it's actually an error or just a success message
        final message = verificationProvider.errorMessage.toLowerCase();
        if (message.contains('error') || 
            message.contains('failed') || 
            message.contains('invalid') ||
            message.contains('not found') ||
            message.contains('unauthorized')) {
          ToastMessage.failedToast(verificationProvider.errorMessage);
          return;
        }
      }

      // Extract E-Card URL from response
      final response = verificationProvider.response;
      String? eCardUrl;
      
      if (response != null) {
        // Try multiple extraction methods
        // Method 1: Direct extraction
        try {
          if (response['success'] == true && 
              response['data'] != null && 
              response['data']['data'] != null && 
              response['data']['data'] is List &&
              (response['data']['data'] as List).isNotEmpty) {
            
            final firstCard = (response['data']['data'] as List)[0];
            eCardUrl = firstCard['ecardUrl'];
            debugPrint('✅ E-Card URL extracted: ${eCardUrl?.substring(0, 50)}...');
          }
        } catch (e) {
          debugPrint('❌ URL extraction failed: $e');
        }
        
        // Method 2: Alternative extraction
        if (eCardUrl == null || eCardUrl.isEmpty) {
          try {
            final data = response['data'];
            if (data != null && data['data'] != null) {
              final cards = data['data'];
              if (cards is List && cards.isNotEmpty) {
                eCardUrl = cards[0]['ecardUrl'];
                debugPrint('✅ E-Card URL extracted (method 2): ${eCardUrl?.substring(0, 50)}...');
              }
            }
          } catch (e) {
            debugPrint('❌ Method 2 failed: $e');
          }
        }
      }

      if (eCardUrl != null && eCardUrl.isNotEmpty) {
        // ToastMessage.successToast('Opening E-Card...');
        
        try {
          final Uri uri = Uri.parse(eCardUrl);
          final canLaunch = await canLaunchUrl(uri);
          
          if (canLaunch) {
            await launchUrl(uri);
            ToastMessage.successToast('E-Card opened successfully!');
          } else {
            ToastMessage.failedToast('Cannot open E-Card');
          }
        } catch (e) {
          ToastMessage.failedToast('Error opening E-Card: $e');
        }
      } else {
        ToastMessage.failedToast('No E-Card  found');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      // ToastMessage.failedToast('Error: ${e.toString()}');
    }
  }

  Future<void> _handleEnrollmentProcess() async {
    setState(() {
      _isEnrolling = true;
    });

    try {
      final verificationProvider = Provider.of<VerificationProvider>(
        context,
        listen: false,
      );
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

      // Clear any previous enrollment data to ensure fresh data
      verificationProvider.clearEnrollmentData();

      // Get email and NRK ID from providers or widget parameters
      String emailId = widget.emailId ?? '';
      String nrkId = widget.nrkId ?? '';

      // Try to get verified customer data first, then fallback to NORKA provider
      final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
        context,
        listen: false,
      );
      final verifiedCustomerData = otpVerificationProvider
          .getVerifiedCustomerData();
      Map<String, dynamic>? customerData =
          verifiedCustomerData ?? norkaProvider.response;

      // If not provided in widget, try to get from providers
      if (emailId.isEmpty && customerData != null) {
        final emails = customerData['emails'];
        if (emails != null && emails.isNotEmpty) {
          emailId = emails[0]['address'] ?? '';
        }
      }

      if (nrkId.isEmpty) {
        // Try to get from verified customer data first
        if (verifiedCustomerData != null) {
          // Try different possible field names for NRK ID
          nrkId = verifiedCustomerData['norka_id'] ?? 
                  verifiedCustomerData['nrk_id'] ?? 
                  verifiedCustomerData['norka_id_no'] ?? 
                  verifiedCustomerData['nrk_id_no'] ?? '';
        }
        
        // If still empty, try from NORKA provider
        if (nrkId.isEmpty) {
          nrkId = norkaProvider.norkaId;
        }
      }

      debugPrint('=== PAYMENT SUCCESS PAGE ENROLLMENT DEBUG ===');
      debugPrint('Widget Email ID: ${widget.emailId ?? 'null'}');
      debugPrint('Widget NRK ID: ${widget.nrkId ?? 'null'}');
      debugPrint('Extracted Email ID: $emailId');
      debugPrint('Extracted NRK ID: $nrkId');
      debugPrint('Verified Customer Data: $verifiedCustomerData');
      debugPrint('NORKA Provider Response: ${norkaProvider.response}');
      
      // Debug verified customer data fields
      if (verifiedCustomerData != null) {
        debugPrint('=== VERIFIED CUSTOMER DATA FIELDS ===');
        debugPrint('Available keys: ${verifiedCustomerData.keys.toList()}');
        debugPrint('norka_id: ${verifiedCustomerData['norka_id']}');
        debugPrint('nrk_id: ${verifiedCustomerData['nrk_id']}');
        debugPrint('norka_id_no: ${verifiedCustomerData['norka_id_no']}');
        debugPrint('nrk_id_no: ${verifiedCustomerData['nrk_id_no']}');
        debugPrint('name: ${verifiedCustomerData['name']}');
        debugPrint('emails: ${verifiedCustomerData['emails']}');
        debugPrint('=== END VERIFIED CUSTOMER DATA FIELDS ===');
      }
      
      debugPrint('=== END PAYMENT SUCCESS PAGE ENROLLMENT DEBUG ===');

      if (emailId.isEmpty || nrkId.isEmpty) {
        ToastMessage.failedToast('Something went wrong. Please try again.');
        return;
      }

      // Step 1: Call enrollment POST API
      final enrollmentData = {'email_id': emailId, 'nrk_id_no': nrkId};
      
      debugPrint('=== PAYMENT SUCCESS - CALLING ENROLLING API ===');
      debugPrint('Enrollment Data: $enrollmentData');

      await verificationProvider.Enrolling(enrollmentData);
      
      debugPrint('=== PAYMENT SUCCESS - ENROLLING API COMPLETED ===');
      debugPrint('Provider Error Message: ${verificationProvider.errorMessage}');
      debugPrint('Provider Response: ${verificationProvider.response}');

      if (verificationProvider.errorMessage.isNotEmpty) {
        debugPrint('❌ Enrollment failed with error: ${verificationProvider.errorMessage}');
        ToastMessage.failedToast('Enrollment failed');
        return;
      }

      // Check if enrollment data is available in the POST response
      debugPrint('=== PAYMENT SUCCESS - CHECKING POST RESPONSE ===');
      debugPrint('Provider Response is null: ${verificationProvider.response == null}');
      
      if (verificationProvider.response != null &&
          verificationProvider.response!['data'] != null) {
        final data = verificationProvider.response!['data'];
        _enrollmentNumber = data['self_enrollment_number'] ?? 'NC1234567890';
        debugPrint('✅ Enrollment number from POST response: $_enrollmentNumber');
        debugPrint('✅ Full POST response data: $data');
        setState(() {});
        // ToastMessage.successToast('Enrollment completed successfully!');
      } else {
        debugPrint('⚠️ POST response data not available, trying GET API fallback');
        // Fallback: Fetch enrollment details using GET API
        await verificationProvider.getEnrollmentDetailsWithOfflineFallback(nrkId);
        
        debugPrint('=== PAYMENT SUCCESS - GET API COMPLETED ===');
        debugPrint('Enrollment Details: ${verificationProvider.enrollmentDetails}');

        if (verificationProvider.enrollmentDetails.isNotEmpty) {
          final data = verificationProvider.enrollmentDetails['data'];
          if (data != null) {
            _enrollmentNumber =
                data['self_enrollment_number'] ?? 'NC1234567890';
            debugPrint('✅ Enrollment number from GET response: $_enrollmentNumber');
            debugPrint('✅ Full GET response data: $data');
            setState(() {});
            // ToastMessage.successToast('Enrollment completed successfully!');
          } else {
            debugPrint('❌ GET response data is null');
          }
        } else {
          debugPrint('❌ Enrollment details are empty');
        }
      }
      
      debugPrint('=== PAYMENT SUCCESS - FINAL ENROLLMENT NUMBER ===');
      debugPrint('Final Enrollment Number: $_enrollmentNumber');

      // Step 3: Call Vidal enrollment API after successful NORKA enrollment
      if (verificationProvider.errorMessage.isEmpty) {
        await _handleVidalEnrollment(
          verificationProvider,
          norkaProvider,
          emailId,
          nrkId,
        );
      }
    } catch (e) {
      debugPrint('Enrollment error: $e');
      ToastMessage.failedToast('Enrollment process failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isEnrolling = false;
        });
      }
    }
  }

  /// Handle Vidal enrollment API call
  Future<void> _handleVidalEnrollment(
    VerificationProvider verificationProvider,
    NorkaProvider norkaProvider,
    String emailId,
    String nrkId,
  ) async {
    try {
      debugPrint('=== Starting Vidal Enrollment Process ===');
      debugPrint('NORKA Response: ${norkaProvider.response}');
      debugPrint(
        'Enrollment Details: ${verificationProvider.enrollmentDetails}',
      );
      debugPrint(
        'Family Members Details: ${verificationProvider.familyMembersDetails}',
      );

      // Get family members data for Vidal enrollment
      await verificationProvider.getFamilyMembersWithOfflineFallback(nrkId);
      debugPrint(
        'Family Members after fetch: ${verificationProvider.familyMembersDetails}',
      );

      // Get dates details for Vidal enrollment
      await verificationProvider.getDatesDetailsWithOfflineFallback(nrkId);
      debugPrint(
        'Dates Details after fetch: ${verificationProvider.datesDetails}',
      );

      // Get verified customer data from OTP verification provider
      final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
        context,
        listen: false,
      );
      final verifiedCustomerData = otpVerificationProvider
          .getVerifiedCustomerData();

      // Use verified customer data if available, otherwise use NORKA provider data
      final customerData = verifiedCustomerData ?? norkaProvider.response;

      debugPrint('=== Vidal Enrollment Data Source Debug ===');
      debugPrint(
        'Using verified customer data: ${verifiedCustomerData != null}',
      );
      debugPrint(
        'Using NORKA provider data: ${norkaProvider.response != null}',
      );
      debugPrint('Final customer data: $customerData');
      debugPrint('=== End Vidal Enrollment Data Source Debug ===');

      // Check if we have all required data
      if (customerData == null) {
        debugPrint('❌ Customer data not available from any source');
        // ToastMessage.failedToast(
        //   'Unable to process enrollment: Missing customer data',
        // );
        return;
      }

      if (verificationProvider.enrollmentDetails.isEmpty) {
        debugPrint('❌ Enrollment details not available');
        // ToastMessage.failedToast(
        //   'Unable to process enrollment: Missing enrollment data',
        // );
        return;
      }

      if (verificationProvider.familyMembersDetails.isEmpty) {
        debugPrint('❌ Family members details not available');
        // ToastMessage.failedToast(
        //   'Unable to process  enrollment: Missing family data',
        // );
        return;
      }

      // Build Vidal enrollment payload
      final vidalPayload = VidalDataMapper.buildVidalEnrollmentPayload(
        norkaResponse: customerData,
        enrollmentDetails: verificationProvider.enrollmentDetails,
        familyMembersDetails: verificationProvider.familyMembersDetails,
        emailId: emailId,
        nrkId: nrkId,
        requestId: verificationProvider.requestIdDetails['data']?['request_id'],
        datesDetails: verificationProvider.datesDetails,
      );

      debugPrint('=== Vidal Enrollment Payload ===');
      debugPrint(
        'Payload Length: ${vidalPayload.toString().length} characters',
      );

      // Print each dependent separately for better visibility
      final dependentInfo =
          vidalPayload['employeeinfo']?['policyinfo']?[0]?['dependent_info']
              as List?;
      if (dependentInfo != null) {
        debugPrint('Dependent Info Count: ${dependentInfo.length}');
        for (int i = 0; i < dependentInfo.length; i++) {
          debugPrint('Dependent $i: ${dependentInfo[i]}');
        }
      }

      // Print full payload as formatted JSON
      try {
        final jsonString = JsonEncoder.withIndent('  ').convert(vidalPayload);
        debugPrint('=== Full Payload as JSON ===');
        debugPrint(jsonString);
        debugPrint('=== End Full Payload ===');
      } catch (e) {
        debugPrint('Error formatting JSON: $e');
        debugPrint('Raw payload: $vidalPayload');
      }

      // Validate payload before sending
      if (vidalPayload['employeeinfo'] == null ||
          vidalPayload['employeeinfo']['employee_no'].toString().isEmpty) {
        debugPrint('❌ Invalid Vidal payload: Missing employee info');
        // ToastMessage.failedToast(
        //   'Unable to process Vidal enrollment: Invalid data format',
        // );
        return;
      }

      // Call Vidal enrollment API
      debugPrint('=== CALLING VIDAL ENROLLMENT API ===');
      await verificationProvider.vidalEnrollment(vidalPayload);

      // Log the final response
      debugPrint('=== VIDAL ENROLLMENT FINAL RESULT ===');
      debugPrint('Error Message: ${verificationProvider.errorMessage}');
      debugPrint('Response: ${verificationProvider.response}');
      debugPrint('=== END VIDAL ENROLLMENT RESULT ===');

      if (verificationProvider.errorMessage.isNotEmpty) {
        debugPrint(
          '❌ Vidal enrollment failed: ${verificationProvider.errorMessage}',
        );
        // ToastMessage.failedToast(
        //   'Vidal enrollment failed: ${verificationProvider.errorMessage}',
        // );
      } else {
        debugPrint('✅ Vidal enrollment completed successfully');
        debugPrint('✅ Final Response: ${verificationProvider.response}');
        // ToastMessage.successToast('Vidal enrollment completed successfully!');
      }
    } catch (e) {
      debugPrint('❌ Vidal enrollment error: $e');
      ToastMessage.failedToast('Enrollment process failed. Please try again.');
    }
  }

  Future<void> _handleBackToHome() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call or data processing
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Login user before navigating to app
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final norkaId = widget.nrkId ?? '';
        await authProvider.login(norkaId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppNavigationBar()),
          (route) => false,
        );
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

















// import 'package:norkacare_app/navigation/app_navigation_bar.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

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
//   Map<String, dynamic> _enrollmentDetails = {};

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
//                   text: 'Payment Successful',
//                   size: 28,
//                   weight: FontWeight.bold,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Confirmation Message
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: AppText(
//                   text: 'You have successfully enrolled',
//                   size: 18,
//                   weight: FontWeight.w500,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 24),

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
//                     Container(
//                       width: double.infinity,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.primaryColor,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: AppConstants.primaryColor,
//                           width: 1,
//                         ),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: _handleViewECard,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: AppText(
//                           text: 'Download E-Card',
//                           size: 16,
//                           weight: FontWeight.w600,
//                           textColor: isDarkMode
//                               ? AppConstants.primaryColor
//                               : AppConstants.whiteColor,
//                         ),
//                       ),
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
//               const SizedBox(height: 30),
//               // Policy Information Message
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.primaryColor.withOpacity(0.1)
//                         : AppConstants.primaryColor.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: isDarkMode
//                           ? AppConstants.primaryColor.withOpacity(0.2)
//                           : AppConstants.primaryColor.withOpacity(0.2),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             color: AppConstants.primaryColor,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           AppText(
//                             text: 'Next Steps',
//                             size: 16,
//                             weight: FontWeight.w600,
//                             textColor: AppConstants.primaryColor,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       AppText(
//                         text:
//                             'Check your "My Policy" to track your E-Card. You can also track E-Card and download your E-Card and Policy conditions.',
//                         size: 14,
//                         weight: FontWeight.normal,
//                         textColor: AppConstants.greyColor,
//                         textAlign: TextAlign.left,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleViewECard() async {
//     // Show E-Card as a physical card-like design
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: double.infinity,
//             height: 220,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   AppConstants.primaryColor,
//                   AppConstants.primaryColor.withOpacity(0.8),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Stack(
//               children: [
//                 // Card content
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(
//                             text: 'NORKA CARE',
//                             size: 16,
//                             weight: FontWeight.bold,
//                             textColor: Colors.white,
//                           ),
//                           AppText(
//                             text: 'E-CARD',
//                             size: 12,
//                             weight: FontWeight.w500,
//                             textColor: Colors.white.withOpacity(0.9),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

//                       // Member name
//                       AppText(
//                         text: _enrollmentDetails['nrk_name'] ?? 'AMALNATH C K',
//                         size: 18,
//                         weight: FontWeight.bold,
//                         textColor: Colors.white,
//                       ),
//                       const SizedBox(height: 8),

//                       // Policy number
//                       AppText(
//                         text:
//                             'Policy: ${_enrollmentDetails['self_enrollment_number'] ?? _enrollmentNumber}',
//                         size: 12,
//                         weight: FontWeight.w500,
//                         textColor: Colors.white.withOpacity(0.9),
//                       ),
//                       const SizedBox(height: 4),

//                       // Sum insured
//                       AppText(
//                         text: 'Sum Insured: ₹5,00,000',
//                         size: 12,
//                         weight: FontWeight.w500,
//                         textColor: Colors.white.withOpacity(0.9),
//                       ),
//                       const Spacer(),

//                       // Validity
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppText(
//                                 text: 'VALID FROM',
//                                 size: 8,
//                                 weight: FontWeight.w500,
//                                 textColor: Colors.white.withOpacity(0.7),
//                               ),
//                               AppText(
//                                 text: '08/09/2025',
//                                 size: 10,
//                                 weight: FontWeight.bold,
//                                 textColor: Colors.white,
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               AppText(
//                                 text: 'VALID UNTIL',
//                                 size: 8,
//                                 weight: FontWeight.w500,
//                                 textColor: Colors.white.withOpacity(0.7),
//                               ),
//                               AppText(
//                                 text: '07/09/2026',
//                                 size: 10,
//                                 weight: FontWeight.bold,
//                                 textColor: Colors.white,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
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

//       // If not provided in widget, try to get from providers
//       if (emailId.isEmpty && norkaProvider.response != null) {
//         final emails = norkaProvider.response!['emails'];
//         if (emails != null && emails.isNotEmpty) {
//           emailId = emails[0]['address'] ?? '';
//         }
//       }

//       if (nrkId.isEmpty) {
//         nrkId = norkaProvider.norkaId;
//       }

//       if (emailId.isEmpty || nrkId.isEmpty) {
//         ToastMessage.failedToast(
//           'Unable to process enrollment: Missing user data',
//         );
//         return;
//       }

//       // Step 1: Call enrollment POST API
//       final enrollmentData = {'email_id': emailId, 'nrk_id_no': nrkId};

//       await verificationProvider.Enrolling(enrollmentData);

//       if (verificationProvider.errorMessage.isNotEmpty) {
//         ToastMessage.failedToast(
//           'Enrollment failed: ${verificationProvider.errorMessage}',
//         );
//         return;
//       }

//       // Check if enrollment data is available in the POST response
//       if (verificationProvider.response != null &&
//           verificationProvider.response!['data'] != null) {
//         final data = verificationProvider.response!['data'];
//         _enrollmentDetails = data;
//         _enrollmentNumber = data['self_enrollment_number'] ?? 'NC1234567890';
//         setState(() {});
//         ToastMessage.successToast('Enrollment completed successfully!');
//       } else {
//         // Fallback: Fetch enrollment details using GET API
//         await verificationProvider.getEnrollmentDetails(nrkId);

//         if (verificationProvider.enrollmentDetails.isNotEmpty) {
//           final data = verificationProvider.enrollmentDetails['data'];
//           if (data != null) {
//             _enrollmentDetails = data;
//             _enrollmentNumber =
//                 data['self_enrollment_number'] ?? 'NC1234567890';
//             setState(() {});
//             ToastMessage.successToast('Enrollment completed successfully!');
//           }
//         }
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

//   Future<void> _handleBackToHome() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Simulate API call or data processing
//       await Future.delayed(const Duration(seconds: 1));

//       if (mounted) {
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
//         'employeeCode': employeeCode,
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
//          // Extract E-Card URL from response
//          try {
//            if (response['successful'] == true && 
//                response['data'] != null && 
//                response['data'] is List &&
//                (response['data'] as List).isNotEmpty) {
            
//              final firstCard = (response['data'] as List)[0];
//              eCardUrl = firstCard['ecardUrl'];
//              debugPrint('✅ E-Card URL extracted: ${eCardUrl?.substring(0, 50)}...');
//            }
//          } catch (e) {
//            debugPrint('❌ URL extraction failed: $e');
//          }
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
