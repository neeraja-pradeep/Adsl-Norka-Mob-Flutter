import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Documents extends StatelessWidget {
  final Map<String, dynamic> customerInsuranceData;

  const Documents({super.key, required this.customerInsuranceData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Documents',
            size: 18,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          const SizedBox(height: 15),
          ...customerInsuranceData['documents'].map<Widget>((document) {
            return _buildDocumentCard(context, document);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    Map<String, dynamic> document,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.description,
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "E-Card",
                  size: 16,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    AppText(
                      text: "PDF",
                      size: 12,
                      weight: FontWeight.w500,
                      textColor: isDarkMode
                          ? AppConstants.greyColor.withOpacity(0.8)
                          : AppConstants.greyColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, color: AppConstants.primaryColor),
            onPressed: () => _handleDownloadECard(context, document),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDownloadECard(
    BuildContext context,
    Map<String, dynamic> document,
  ) async {
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
      // Get the NORKA ID from the provider
      String employeeCode = norkaProvider.norkaId;

      if (employeeCode.isEmpty) {
        Navigator.of(context).pop(); // Close loading dialog
        ToastMessage.failedToast('NORKA ID not found');
        return;
      }

      // Call the Vidal E-Card API
      await verificationProvider.vidalEnrollmentEcard({
        'employee_code': employeeCode,
        // 'employeeCode': employeeCode,
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

      final response = verificationProvider.response;
      
      if (response != null) {
        
        // Try multiple extraction methods
        String? eCardUrl;
        
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
                debugPrint('✅ Method 2 success: $eCardUrl');
              }
            }
          } catch (e) {
            debugPrint('❌ Method 2 failed: $e');
          }
        }
        
        
        if (eCardUrl != null && eCardUrl.isNotEmpty) {
          // ToastMessage.successToast('Opening E-Card...');
          
          try {
            final Uri uri = Uri.parse(eCardUrl);
            final canLaunch = await canLaunchUrl(uri);
            
            if (canLaunch) {
              await launchUrl(uri);
              // ToastMessage.successToast('E-Card opened successfully!');
            } else {
              ToastMessage.failedToast('Cannot open E-Card');
            }
          } catch (e) {
            ToastMessage.failedToast('Error opening E-Card: $e');
          }
        } else {
          ToastMessage.failedToast('No E-Card URL found');
        }
      } else {
        ToastMessage.failedToast('No response from server');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ToastMessage.failedToast('Error: ${e.toString()}');
    }
  }
}








// import 'package:flutter/material.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Documents extends StatelessWidget {
//   final Map<String, dynamic> customerInsuranceData;

//   const Documents({super.key, required this.customerInsuranceData});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText(
//             text: 'Documents',
//             size: 18,
//             weight: FontWeight.bold,
//             textColor: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//           ),
//           const SizedBox(height: 15),
//           ...customerInsuranceData['documents'].map<Widget>((document) {
//             return _buildDocumentCard(context, document);
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentCard(
//     BuildContext context,
//     Map<String, dynamic> document,
//   ) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? AppConstants.boxBlackColor
//             : AppConstants.whiteColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withOpacity(0.1)
//               : Colors.grey.withOpacity(0.2),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: isDarkMode
//                 ? Colors.black.withOpacity(0.3)
//                 : Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: AppConstants.primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               Icons.description,
//               color: AppConstants.primaryColor,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   text: "E-Card",
//                   size: 16,
//                   weight: FontWeight.w600,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     AppText(
//                       text: "PDF",
//                       size: 12,
//                       weight: FontWeight.w500,
//                       textColor: isDarkMode
//                           ? AppConstants.greyColor.withOpacity(0.8)
//                           : AppConstants.greyColor,
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.download, color: AppConstants.primaryColor),
//             onPressed: () => _handleDownloadECard(context, document),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _handleDownloadECard(
//     BuildContext context,
//     Map<String, dynamic> document,
//   ) async {
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
//       // Get the NORKA ID from the provider
//       String employeeCode = norkaProvider.norkaId;

//       if (employeeCode.isEmpty) {
//         Navigator.of(context).pop(); // Close loading dialog
//         ToastMessage.failedToast('NORKA ID not found');
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

//       final response = verificationProvider.response;
      
//       if (response != null) {
        
//         // Try multiple extraction methods
//         String? eCardUrl;
        
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
        
        
//         if (eCardUrl != null && eCardUrl.isNotEmpty) {
//           // ToastMessage.successToast('Opening E-Card...');
          
//           try {
//             final Uri uri = Uri.parse(eCardUrl);
//             final canLaunch = await canLaunchUrl(uri);
            
//             if (canLaunch) {
//               await launchUrl(uri);
//               ToastMessage.successToast('E-Card opened successfully!');
//             } else {
//               ToastMessage.failedToast('Cannot open E-Card URL');
//             }
//           } catch (e) {
//             ToastMessage.failedToast('Error opening E-Card: $e');
//           }
//         } else {
//           ToastMessage.failedToast('No E-Card URL found');
//         }
//       } else {
//         ToastMessage.failedToast('No response from server');
//       }
//     } catch (e) {
//       Navigator.of(context).pop(); // Close loading dialog
//       ToastMessage.failedToast('Error: ${e.toString()}');
//     }
//   }
// }
