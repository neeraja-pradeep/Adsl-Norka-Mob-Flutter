import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:norkacare_app/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();

  // Static method to reset shimmer state (call this on logout)
  static void resetShimmerState() {
    _DocumentsPageState.resetShimmerState();
  }

  // Static method to reset SharedPreferences shimmer flag (call this on logout)
  static Future<void> resetShimmerPreferences() async {
    await _DocumentsPageState.resetShimmerPreferences();
  }
}

class _DocumentsPageState extends State<DocumentsPage> {
  final List<Map<String, dynamic>> allDocuments = [
    {'name': 'E-Card', 'type': 'PDF'},
    {'name': 'Policy document', 'type': 'VIEW'},
  ];

  bool _isInitialLoading = true;

  // Static variable to track if shimmer has been shown for this page
  static bool _hasShownDocumentsShimmer = false;

  // Static method to reset shimmer state (call this on logout)
  static void resetShimmerState() {
    _hasShownDocumentsShimmer = false;
  }

  // Static method to reset SharedPreferences shimmer flag (call this on logout)
  static Future<void> resetShimmerPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_shown_documents_shimmer');
  }

  @override
  void initState() {
    super.initState();
    _initializeShimmerState();
  }

  void _initializeShimmerState() {
    if (_hasShownDocumentsShimmer) {
      // Shimmer has been shown before, don't show it
      _isInitialLoading = false;
      // Load data immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadDocumentsData();
      });
    } else {
      // First time visiting this page, show shimmer
      _startShimmerTimer();
    }
  }

  void _startShimmerTimer() {
    // Load data during shimmer phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDocumentsData();
    });

    // Show shimmer for 2 seconds on first visit to this page
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _hasShownDocumentsShimmer = true; // Mark shimmer as shown
        setState(() {
          _isInitialLoading = false;
        });
        // Mark that shimmer has been shown in SharedPreferences too
        _saveShimmerFlag();
      }
    });
  }

  Future<void> _saveShimmerFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_documents_shimmer', true);
  }

  void _loadDocumentsData() async {
    // Since documents are static, we don't need to load any API data
    // This method is here for consistency with other pages
    // In the future, if documents need to be loaded from API, add the logic here
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: AppText(
          text: 'Documents',
          size: 20,
          weight: FontWeight.bold,
          textColor: AppConstants.whiteColor,
        ),
        centerTitle: true,
      ),
      body: _isInitialLoading
          ? ShimmerWidgets.buildShimmerDocumentsPage(isDarkMode: isDarkMode)
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (allDocuments.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: allDocuments.length,
                      itemBuilder: (context, index) {
                        return _buildDocumentCard(allDocuments[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                  ] else
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _buildEmptyState(),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getDocumentIcon(document['type']),
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: document['name'],
                        size: 16,
                        weight: FontWeight.w600,
                        textColor: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),

                      AppText(
                        text: _getDocumentDescription(document['name']),
                        size: 13,
                        weight: FontWeight.w500,
                        textColor: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),
                    ],
                  ),
                ),
                if (document['type'] != 'VIEW')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.secondaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: AppConstants.secondaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText(
                          text: document['type'],
                          size: 12,
                          weight: FontWeight.w600,
                          textColor: AppConstants.secondaryColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Action Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: document['type'] == 'VIEW' ? 'View' : 'Download',
                    onPressed: () => _handleDocumentDownload(context, document),
                    color: document['type'] == 'VIEW'
                        ? AppConstants.primaryColor
                        : AppConstants.secondaryColor,
                    textColor: document['type'] == 'VIEW'
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80,
            color: AppConstants.greyColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            text: 'No documents found',
            size: 18,
            weight: FontWeight.w600,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.greyColor,
          ),
          const SizedBox(height: 8),
          AppText(
            text: 'No documents available at the moment',
            size: 14,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'DOC':
      case 'DOCX':
        return Icons.description;
      case 'XLS':
      case 'XLSX':
        return Icons.table_chart;
      case 'JPG':
      case 'JPEG':
      case 'PNG':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getDocumentDescription(String documentName) {
    switch (documentName) {
      case 'E-Card':
        return 'Document';
      case 'Policy document':
        return 'Insurance policy benefits';
      default:
        return 'Document';
    }
  }

  Future<void> _handleDocumentDownload(
    BuildContext context,
    Map<String, dynamic> document,
  ) async {
    switch (document['name']) {
      case 'E-Card':
        await _handleDownloadECard(context, document);
        break;
      case 'Policy document':
        await _handleDownloadPolicyDocument(context, document);
        break;
      default:
        ToastMessage.failedToast('Document download not available');
    }
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
        // ToastMessage.failedToast('NORKA ID not found');
        return;
      }

      // Call the Vidal E-Card API
      await verificationProvider.vidalEnrollmentEcard({
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
        ToastMessage.failedToast('No E-Card found');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ToastMessage.failedToast('Error: ${e.toString()}');
    }
  }

  Future<void> _handleDownloadPolicyDocument(
    BuildContext context,
    Map<String, dynamic> document,
  ) async {
    _showPolicyDocumentDialog(context);
  }

  void _showPolicyDocumentDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : AppConstants.whiteColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: AppConstants.whiteColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText(
                          text: 'Policy document',
                          size: 18,
                          weight: FontWeight.bold,
                          textColor: AppConstants.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: AppConstants.whiteColor),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPolicySection('Important Policy Benefits - GMC', [
                          'GMC Coverage - Rs 5 Lakhs per Year per Family',
                          'Coverage of Rs 5 Lakhs for Individuals also',
                          'Room Rent 5000/- Per day and ICU 10000/- per Day',
                          'Medical Expenses no limits upto 5 Lakhs SA',
                          'No Medical Check up to 70 Years and no rejections',
                          'Day 1 Coverage for any preexisting disease',
                          'Chemo, Dialysis etc. will be covered after discharge without admission as day care procedure',
                          'No Co-Pay for any claims',
                          'Ayush covered up to 50000 per year (Ayurveda, Yoga & Naturopathy, Unani, Sidha and Homeopathy) with IP',
                          'Cataract Covered 30000/- per eye without admission',
                          'Up to 25 years 2 kids can continue under Family Cover without any additional Premium. Additional kids more than 2 can be added with additional premium',
                          '30 days Pre and 60 days Post hospitalization medical expenses can claim up to Rs 5000 Per claim',
                          'No medical check up or any kind of health declaration required for enrolment from 18 - 70 years',
                          'No Premium Loading for policy renewals due to Claim, age band change etc. Flat premium for 18 - 70 years',
                          'Portability benefits available after 70 years or anybody changes their NRK status with all benefits and no medicals required for converting as an Individual Policy',
                          'Maternity not covered but any hospitalization except delivery covered and new born baby covered from Day One',
                          'Option for Family Sum Assured of 5 Lakhs or Individual SA of 5 Lakhs if NRK id is separate in the same family',
                          'After 25 years for kids, portability benefits available to continue the coverages or can join with Norka Care with an NRK Card is eligible',
                          'Organ Transplant if any covered upto the Sum Assured',
                          'No Premium increments due to high claims or confirmed claims like hemodialysis if any',
                          'No Waiting Period',
                          'No Premium loading',
                          'No Co-pay',
                          'up to 70 Yrs eligible',
                          'No Medical check up',
                        ], isDarkMode),
                        const SizedBox(height: 20),
                        _buildPolicySection(
                          'Important Policy Benefits - GPA (Only Accidents Covered)',
                          [
                            'Any Kind of Accidental Death Across the World - 10 Lakhs SA',
                            'Permanent Total Disability - 10 Lakhs',
                            'Loss of both hand or both Feets - 10 lakhs',
                            'Loss of One hand and one feet - 10 Lakhs',
                            'Loss of one eye and one hand or foot - 10 Lakhs',
                            'Total permanent Paralise due to accident - 10 Lakhs',
                            'Loss of Vision in both eyes - 10 Lakhs',
                            'Hearing Loss - Both ears - 7.5 Lakhs',
                            'Loss of One Eyes/Hand/Feet - 5 Lakhs',
                            'Loss of One Hand and 4 fingers - 5 Lakhs',
                            'Loss of 4 fingers and thump of one hand - 5 Lakhs',
                            'Loss of four fingers - 3.5 Lakhs',
                            'Loss of thump - 2.5 Lakhs',
                            'Body repatriation - 50000/- for outside India',
                            'Body repatriation - 25000/- for Inside India',
                          ],
                          isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPolicySection(
    String title,
    List<String> benefits,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          size: 16,
          weight: FontWeight.bold,
          textColor: isDarkMode
              ? AppConstants.whiteColor
              : AppConstants.blackColor,
        ),
        const SizedBox(height: 12),
        ...benefits
            .map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        text: benefit,
                        size: 13,
                        weight: FontWeight.normal,
                        textColor: isDarkMode
                            ? AppConstants.whiteColor.withOpacity(0.9)
                            : AppConstants.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}





















// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:norkacare_app/widgets/shimmer_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DocumentsPage extends StatefulWidget {
//   const DocumentsPage({super.key});

//   @override
//   State<DocumentsPage> createState() => _DocumentsPageState();

//   // Static method to reset shimmer state (call this on logout)
//   static void resetShimmerState() {
//     _DocumentsPageState.resetShimmerState();
//   }

//   // Static method to reset SharedPreferences shimmer flag (call this on logout)
//   static Future<void> resetShimmerPreferences() async {
//     await _DocumentsPageState.resetShimmerPreferences();
//   }
// }

// class _DocumentsPageState extends State<DocumentsPage> {
//   final List<Map<String, dynamic>> allDocuments = [
//     {'name': 'E-Card', 'type': 'PDF'},
//     {'name': 'Policy document', 'type': 'VIEW'},
//   ];

//   bool _isInitialLoading = true;

//   // Static variable to track if shimmer has been shown for this page
//   static bool _hasShownDocumentsShimmer = false;

//   // Static method to reset shimmer state (call this on logout)
//   static void resetShimmerState() {
//     _hasShownDocumentsShimmer = false;
//   }

//   // Static method to reset SharedPreferences shimmer flag (call this on logout)
//   static Future<void> resetShimmerPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('has_shown_documents_shimmer');
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeShimmerState();
//   }

//   void _initializeShimmerState() {
//     if (_hasShownDocumentsShimmer) {
//       // Shimmer has been shown before, don't show it
//       _isInitialLoading = false;
//       // Load data immediately
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _loadDocumentsData();
//       });
//     } else {
//       // First time visiting this page, show shimmer
//       _startShimmerTimer();
//     }
//   }

//   void _startShimmerTimer() {
//     // Load data during shimmer phase
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadDocumentsData();
//     });

//     // Show shimmer for 2 seconds on first visit to this page
//     Future.delayed(const Duration(milliseconds: 2000), () {
//       if (mounted) {
//         _hasShownDocumentsShimmer = true; // Mark shimmer as shown
//         setState(() {
//           _isInitialLoading = false;
//         });
//         // Mark that shimmer has been shown in SharedPreferences too
//         _saveShimmerFlag();
//       }
//     });
//   }

//   Future<void> _saveShimmerFlag() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('has_shown_documents_shimmer', true);
//   }

//   void _loadDocumentsData() async {
//     // Since documents are static, we don't need to load any API data
//     // This method is here for consistency with other pages
//     // In the future, if documents need to be loaded from API, add the logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       backgroundColor: isDarkMode
//           ? AppConstants.darkBackgroundColor
//           : AppConstants.whiteBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppConstants.primaryColor,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         title: AppText(
//           text: 'Documents',
//           size: 20,
//           weight: FontWeight.bold,
//           textColor: AppConstants.whiteColor,
//         ),
//         centerTitle: true,
//       ),
//       body: _isInitialLoading
//           ? ShimmerWidgets.buildShimmerDocumentsPage(isDarkMode: isDarkMode)
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   if (allDocuments.isNotEmpty) ...[
//                     const SizedBox(height: 20),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       itemCount: allDocuments.length,
//                       itemBuilder: (context, index) {
//                         return _buildDocumentCard(allDocuments[index]);
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                   ] else
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.5,
//                       child: _buildEmptyState(),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildDocumentCard(Map<String, dynamic> document) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
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
//       child: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? AppConstants.darkBackgroundColor
//                   : Colors.grey[50],
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppConstants.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     _getDocumentIcon(document['type']),
//                     color: AppConstants.primaryColor,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                         text: document['name'],
//                         size: 16,
//                         weight: FontWeight.w600,
//                         textColor: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor,
//                       ),

//                       AppText(
//                         text: _getDocumentDescription(document['name']),
//                         size: 13,
//                         weight: FontWeight.w500,
//                         textColor: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor,
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (document['type'] != 'VIEW')
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppConstants.secondaryColor.withOpacity(0.1),
//                           border: Border.all(
//                             color: AppConstants.secondaryColor.withOpacity(0.3),
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: AppText(
//                           text: document['type'],
//                           size: 12,
//                           weight: FontWeight.w600,
//                           textColor: AppConstants.secondaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),

//           // Action Button
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? AppConstants.darkBackgroundColor
//                   : Colors.grey[50],
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: CustomButton(
//                     text: document['type'] == 'VIEW' ? 'View' : 'Download',
//                     onPressed: () => _handleDocumentDownload(context, document),
//                     color: document['type'] == 'VIEW'
//                         ? AppConstants.primaryColor
//                         : AppConstants.secondaryColor,
//                     textColor: document['type'] == 'VIEW'
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor,
//                     height: 40,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.folder_outlined,
//             size: 80,
//             color: AppConstants.greyColor.withOpacity(0.5),
//           ),
//           const SizedBox(height: 16),
//           AppText(
//             text: 'No documents found',
//             size: 18,
//             weight: FontWeight.w600,
//             textColor: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.greyColor,
//           ),
//           const SizedBox(height: 8),
//           AppText(
//             text: 'No documents available at the moment',
//             size: 14,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//         ],
//       ),
//     );
//   }

//   IconData _getDocumentIcon(String type) {
//     switch (type.toUpperCase()) {
//       case 'PDF':
//         return Icons.picture_as_pdf;
//       case 'DOC':
//       case 'DOCX':
//         return Icons.description;
//       case 'XLS':
//       case 'XLSX':
//         return Icons.table_chart;
//       case 'JPG':
//       case 'JPEG':
//       case 'PNG':
//         return Icons.image;
//       default:
//         return Icons.insert_drive_file;
//     }
//   }

//   String _getDocumentDescription(String documentName) {
//     switch (documentName) {
//       case 'E-Card':
//         return 'Document';
//       case 'Policy document':
//         return 'Insurance policy benefits';
//       default:
//         return 'Document';
//     }
//   }

//   Future<void> _handleDocumentDownload(
//     BuildContext context,
//     Map<String, dynamic> document,
//   ) async {
//     switch (document['name']) {
//       case 'E-Card':
//         await _handleDownloadECard(context, document);
//         break;
//       case 'Policy document':
//         await _handleDownloadPolicyDocument(context, document);
//         break;
//       default:
//         ToastMessage.failedToast('Document download not available');
//     }
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
//         // ToastMessage.successToast('Opening E-Card...');
        
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
//       ToastMessage.failedToast('Error: ${e.toString()}');
//     }
//   }

//   Future<void> _handleDownloadPolicyDocument(
//     BuildContext context,
//     Map<String, dynamic> document,
//   ) async {
//     _showPolicyDocumentDialog(context);
//   }

//   void _showPolicyDocumentDialog(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.8,
//               maxWidth: MediaQuery.of(context).size.width * 0.9,
//             ),
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? AppConstants.darkBackgroundColor
//                   : AppConstants.whiteColor,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Header
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: AppConstants.primaryColor,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       topRight: Radius.circular(16),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.description_outlined,
//                         color: AppConstants.whiteColor,
//                         size: 24,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: AppText(
//                           text: 'Policy document',
//                           size: 18,
//                           weight: FontWeight.bold,
//                           textColor: AppConstants.whiteColor,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         icon: Icon(Icons.close, color: AppConstants.whiteColor),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Content
//                 Flexible(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildPolicySection('Important Policy Benefits - GMC', [
//                           'GMC Coverage - Rs 5 Lakhs per Year per Family',
//                           'Coverage of Rs 5 Lakhs for Individuals also',
//                           'Room Rent 5000/- Per day and ICU 10000/- per Day',
//                           'Medical Expenses no limits upto 5 Lakhs SA',
//                           'No Medical Check up to 70 Years and no rejections',
//                           'Day 1 Coverage for any preexisting disease',
//                           'Chemo, Dialysis etc. will be covered after discharge without admission as day care procedure',
//                           'No Co-Pay for any claims',
//                           'Ayush covered up to 50000 per year (Ayurveda, Yoga & Naturopathy, Unani, Sidha and Homeopathy) with IP',
//                           'Cataract Covered 30000/- per eye without admission',
//                           'Up to 25 years 2 kids can continue under Family Cover without any additional Premium. Additional kids more than 2 can be added with additional premium',
//                           '30 days Pre and 60 days Post hospitalization medical expenses can claim up to Rs 5000 Per claim',
//                           'No medical check up or any kind of health declaration required for enrolment from 18 - 70 years',
//                           'No Premium Loading for policy renewals due to Claim, age band change etc. Flat premium for 18 - 70 years',
//                           'Portability benefits available after 70 years or anybody changes their NRK status with all benefits and no medicals required for converting as an Individual Policy',
//                           'Maternity not covered but any hospitalization except delivery covered and new born baby covered from Day One',
//                           'Option for Family Sum Assured of 5 Lakhs or Individual SA of 5 Lakhs if NRK id is separate in the same family',
//                           'After 25 years for kids, portability benefits available to continue the coverages or can join with Norka Care with an NRK Card is eligible',
//                           'Organ Transplant if any covered upto the Sum Assured',
//                           'No Premium increments due to high claims or confirmed claims like hemodialysis if any',
//                           'No Waiting Period',
//                           'No Premium loading',
//                           'No Co-pay',
//                           'up to 70 Yrs eligible',
//                           'No Medical check up',
//                         ], isDarkMode),
//                         const SizedBox(height: 20),
//                         _buildPolicySection(
//                           'Important Policy Benefits - GPA (Only Accidents Covered)',
//                           [
//                             'Any Kind of Accidental Death Across the World - 10 Lakhs SA',
//                             'Permanent Total Disability - 10 Lakhs',
//                             'Loss of both hand or both Feets - 10 lakhs',
//                             'Loss of One hand and one feet - 10 Lakhs',
//                             'Loss of one eye and one hand or foot - 10 Lakhs',
//                             'Total permanent Paralise due to accident - 10 Lakhs',
//                             'Loss of Vision in both eyes - 10 Lakhs',
//                             'Hearing Loss - Both ears - 7.5 Lakhs',
//                             'Loss of One Eyes/Hand/Feet - 5 Lakhs',
//                             'Loss of One Hand and 4 fingers - 5 Lakhs',
//                             'Loss of 4 fingers and thump of one hand - 5 Lakhs',
//                             'Loss of four fingers - 3.5 Lakhs',
//                             'Loss of thump - 2.5 Lakhs',
//                             'Body repatriation - 50000/- for outside India',
//                             'Body repatriation - 25000/- for Inside India',
//                           ],
//                           isDarkMode,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Footer
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: AppConstants.primaryColor,
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(16),
//                       bottomRight: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPolicySection(
//     String title,
//     List<String> benefits,
//     bool isDarkMode,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText(
//           text: title,
//           size: 16,
//           weight: FontWeight.bold,
//           textColor: isDarkMode
//               ? AppConstants.whiteColor
//               : AppConstants.blackColor,
//         ),
//         const SizedBox(height: 12),
//         ...benefits
//             .map(
//               (benefit) => Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(top: 6, right: 8),
//                       width: 4,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: AppConstants.primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     Expanded(
//                       child: AppText(
//                         text: benefit,
//                         size: 13,
//                         weight: FontWeight.normal,
//                         textColor: isDarkMode
//                             ? AppConstants.whiteColor.withOpacity(0.9)
//                             : AppConstants.blackColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//             .toList(),
//       ],
//     );
//   }
// }
