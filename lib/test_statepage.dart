// // import 'package:norkacare_app/provider/test_profile_provider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // class Statepage extends StatefulWidget {
// //   const Statepage({super.key});

// //   @override
// //   State<Statepage> createState() => _StatepageState();
// // }

// // class _StatepageState extends State<Statepage> {
// //   final TextEditingController _searchController = TextEditingController();
// //   List<Map<String, dynamic>> _filteredStates = [];
// //   late List<Map<String, dynamic>> statesList = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final provider = Provider.of<TestProfileProvider>(context, listen: false);
// //       provider.getStates();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('States'),
// //         backgroundColor: Colors.blue,
// //         foregroundColor: Colors.white,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.refresh),
// //             onPressed: () {
// //               final provider = Provider.of<TestProfileProvider>(
// //                 context,
// //                 listen: false,
// //               );
// //               provider.getStates();
// //               _searchController.clear();
// //               setState(() {
// //                 _filteredStates = [];
// //               });
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Consumer<TestProfileProvider>(
// //         builder: (context, profileProvider, child) {
// //           statesList = profileProvider.states;
// //           if (_filteredStates.isEmpty && statesList.isNotEmpty) {
// //             _filteredStates = statesList;
// //           }

// //           if (profileProvider.isStatesLoading) {
// //             return Center(child: CircularProgressIndicator());
// //           }

// //           if (statesList.isEmpty) {
// //             return Center(
// //               child: Text(
// //                 'No states available',
// //                 style: TextStyle(fontSize: 16),
// //               ),
// //             );
// //           }

// //           return Column(
// //             children: [
// //               Expanded(
// //                 child: _filteredStates.isEmpty
// //                     ? const Center(
// //                         child: Text(
// //                           'No states found',
// //                           style: TextStyle(fontSize: 16),
// //                         ),
// //                       )
// //                     : ListView.builder(
// //                         padding: const EdgeInsets.symmetric(horizontal: 16),
// //                         itemCount: _filteredStates.length,
// //                         itemBuilder: (context, index) {
// //                           final state = _filteredStates[index];
// //                           return Card(
// //                             margin: const EdgeInsets.only(bottom: 8),
// //                             elevation: 2,
// //                             child: ListTile(
// //                               leading: CircleAvatar(
// //                                 backgroundColor: Colors.blue,
// //                                 child: Text(
// //                                   state['STATE_TYPE_ID'] ?? '',
// //                                   style: const TextStyle(
// //                                     color: Colors.white,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                               title: Text(
// //                                 state['STATE_NAME'] ?? '',
// //                                 style: const TextStyle(
// //                                   fontWeight: FontWeight.w500,
// //                                   fontSize: 16,
// //                                 ),
// //                               ),
// //                               subtitle: Text(
// //                                 'State ID: ${state['STATE_TYPE_ID'] ?? ''}',
// //                                 style: const TextStyle(
// //                                   color: Colors.grey,
// //                                   fontSize: 12,
// //                                 ),
// //                               ),
// //                               onTap: () {
// //                                 // Handle state selection
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     content: Text(
// //                                       'Selected: ${state['STATE_NAME']}',
// //                                     ),
// //                                     duration: const Duration(seconds: 2),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                           );
// //                         },
// //                       ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }



// after payment success then already calling the 

//   static Future Enrolling(data) async {
//     try {
//       var dio = await DioHelper.getInstance();
//       var response = await dio.post(
//         '$FamilyBaseURL/enrollment/create-enrollment-numbers/',
//         data: data,
//       );
//       print("user logged in : ${response.data}");
//       return response.data;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   static Future getEnrollmentDetails(String nrk_Id) async {
//     try {
//       var dio = await DioHelper.getInstance();
//       var response = await dio.get(
//         '$FamilyBaseURL/enrollment/get-enrollment-numbers/?nrk_id_no=$nrk_Id',
//       );
//       print("Family members fetched: ${response.data}");
//       return response.data;
//     } catch (e) {
//       rethrow;
//     }
//   }.  this api's. thats enough




// please after this api call and befor showing the payment success page ...please call another api that is 

// static Future vidalEnrollment(data) async {
//     try {
//       var dio = await DioHelper.getInstance();
//       var response = await dio.post(
//         '$VidalBaseURL/enrollment/create',
//         data: data,
//       );
//       print("user logged in : ${response.data}");
//       return response.data;
//     } catch (e) {
//       rethrow;
//     }
//   }


//     Future<void> vidalEnrollment(Map<String, dynamic> data) async {
//     _setLoading(true);
//     _errorMessage = '';
//     try {
//       final response = await VerificationService.vidalEnrollment(data);
//       _response = response;
//       debugPrint(">>>>>>>$response");

//       // Check if response contains success indicators
//       if (response != null) {
//         // Check for success indicators in the response
//         bool hasSuccessData =
//             response.containsKey('data') &&
//             response['data'] != null &&
//             response['data'].containsKey('self_enrollment_number');

//         // Check for success message
//         bool hasSuccessMessage =
//             response.containsKey('message') &&
//             (response['message'].toString().toLowerCase().contains('success') ||
//                 response['message'].toString().toLowerCase().contains(
//                   'generated',
//                 ));

//         if (hasSuccessData || hasSuccessMessage) {
//           _errorMessage = '';
//           debugPrint("✅ Success: API call successful, clearing error message");
//         } else if (response.containsKey('message')) {
//           _errorMessage = response['message'];
//           debugPrint("⚠️ API returned message: ${response['message']}");
//         } else {
//           _errorMessage = '';
//           debugPrint("✅ Success: No specific message, treating as success");
//         }
//       } else {
//         _errorMessage = '';
//         debugPrint("✅ Success: No response, treating as success");
//       }
//     } on DioException catch (e) {
//       _handleError(e);
//     } catch (e) {
//       _errorMessage = "An unexpected error occurred.";
//       debugPrint("General Error: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }


// body:  

// {
//     "request_id": "eeer22323454334543swe-tbp-nr7ik-082",
//     "corporate_name": "NORKA ROOTS",
//     "corporate_id": "N0386",
//     "employeeinfo": {
//         "pincode": "",
//         "address": "1st Floor, Tower B, Building No 8",
//         "mobile_no": "8590316700",
//         "date_of_joining": "01/09/2025",
//         "employee_name": "partnerIntegration6",
//         "email_id": "partnerIntegration60@gmail.com",
//         "employee_no": "EN000001",
      
//         "policyinfo": [
//             {
//                 "benefit_name": "Base policy",
//                 "entity_name": "NORKA",
//                 "policy_number": "540000/48/2025/337",
//                 "si_type": "Floater",
//                 "dependent_info": [
//                     {
//                         "cardholder_name": "GANDHI",
//                         "depedent_unique_id": "EN000001",
//                         "date_of_inception": "01/05/2024",
//                         "age": 32,
//                         "date_of_exit": "",
//                         "dob": "02/01/1992",
//                         "gender": "Male",
//                         "sum_insured": "500000",
//                         "vidal_tpa_id": "",
//                         "risk_id": "",
//                         "relation": "selfs"
//                     },
//                     {
//                         "cardholder_name": "SPOUSE",
//                         "depedent_unique_id": "EN000001-S",
//                         "date_of_inception": "01/05/2024",
//                         "age": 31,
//                         "date_of_exit": "",
//                         "dob": "01/01/1991",
//                         "gender": "Male",
//                         "sum_insured": "500000",
//                         "vidal_tpa_id": "",
//                         "risk_id": "",
//                         "relation": "spouses"
//                     },
//                     {
//                         "cardholder_name": "CHILD ONE",
//                         "depedent_unique_id": "EN000001-C-1",
//                         "date_of_inception": "01/05/2024",
//                         "age": 9,
//                         "date_of_exit": "",
//                         "dob": "01/01/2016",
//                         "gender": "Male",
//                         "sum_insured": "500000",
//                         "vidal_tpa_id": "",
//                         "risk_id": "",
//                         "relation": "child1"
//                     }
//                 ]
//             }
//         ]
//     }
// }



// note: 1-  "request_id": "eeer22323454334543swe-tbp-nr7ik-082",         thi generate a random number 
// or uniqe number ,

// 2- 
// "corporate_name": "NORKA ROOTS",
//     "corporate_id": "N0386",    this bothgive static


// 3- 
//  "pincode": "",
//         "address": "1st Floor, Tower B, Building No 8",
//         "mobile_no": "8590316700",  
//  "employee_name": "partnerIntegration6",
// "email_id": "partnerIntegration60@gmail.com",
// this field use from the norka api

// 4-  "employee_no": "EN000001", is is norka id this use from norka api 

// 5- "date_of_joining": "01/09/2025",   is give today date

// 6- "benefit_name": "Base policy",
//                 "entity_name": "NORKA",
//                 "policy_number": "540000/48/2025/337",
//                 "si_type": "Floater",    this are give static

// 7-  "depedent_unique_id": "EN000001",   this is enrollment number ..this take from /enrollment/get-enrollment-numbers/?nrk_id_no=$nrk_Id.  this api 

// 8- "date_of_inception": "01/05/2024",     his give static

// 9- "date_of_exit": "",     this give optional
// 10- "sum_insured": "500000",
//                         "vidal_tpa_id": "",
//                         "risk_id": "",    static


// then integrate it



























// import 'package:norkacare_app/navigation/app_navigation_bar.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:norkacare_app/services/vidal_data_mapper.dart';
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

//       // Check if we have all required data
//       if (norkaProvider.response == null) {
//         debugPrint('❌ NORKA response data not available');
//         ToastMessage.failedToast(
//           'Unable to process Vidal enrollment: Missing NORKA data',
//         );
//         return;
//       }

//       if (verificationProvider.enrollmentDetails.isEmpty) {
//         debugPrint('❌ Enrollment details not available');
//         ToastMessage.failedToast(
//           'Unable to process Vidal enrollment: Missing enrollment data',
//         );
//         return;
//       }

//       if (verificationProvider.familyMembersDetails.isEmpty) {
//         debugPrint('❌ Family members details not available');
//         ToastMessage.failedToast(
//           'Unable to process Vidal enrollment: Missing family data',
//         );
//         return;
//       }

//       // Build Vidal enrollment payload
//       final vidalPayload = VidalDataMapper.buildVidalEnrollmentPayload(
//         norkaResponse: norkaProvider.response!,
//         enrollmentDetails: verificationProvider.enrollmentDetails,
//         familyMembersDetails: verificationProvider.familyMembersDetails,
//         emailId: emailId,
//         nrkId: nrkId,
//       );

//       debugPrint('=== Vidal Enrollment Payload ===');
//       debugPrint(vidalPayload.toString());

//       // Validate payload before sending
//       if (vidalPayload['employeeinfo'] == null ||
//           vidalPayload['employeeinfo']['employee_no'].toString().isEmpty) {
//         debugPrint('❌ Invalid Vidal payload: Missing employee info');
//         ToastMessage.failedToast(
//           'Unable to process Vidal enrollment: Invalid data format',
//         );
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
//         ToastMessage.failedToast(
//           'Vidal enrollment failed: ${verificationProvider.errorMessage}',
//         );
//       } else {
//         debugPrint('✅ Vidal enrollment completed successfully');
//         debugPrint('✅ Final Response: ${verificationProvider.response}');
//         ToastMessage.successToast('Vidal enrollment completed successfully!');
//       }
//     } catch (e) {
//       debugPrint('❌ Vidal enrollment error: $e');
//       ToastMessage.failedToast(
//         'Vidal enrollment process failed. Please try again.',
//       );
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

























// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../../utils/constants.dart';
// import '../../../widgets/app_text.dart';

// class LandBotChatPage extends StatefulWidget {
//   const LandBotChatPage({super.key});

//   @override
//   State<LandBotChatPage> createState() => _LandBotChatPageState();
// }

// class _LandBotChatPageState extends State<LandBotChatPage> {
//   late final WebViewController _controller;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isLoading) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     });
//   }

//   void _initializeWebView() {
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.transparent)
//       ..enableZoom(false)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             // Keep loading state true when page starts
//           },
//           onPageFinished: (String url) {
//             // Hide loading immediately when page finishes
//             if (mounted) {
//               setState(() {
//                 _isLoading = false;
//               });
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             if (mounted) {
//               setState(() {
//                 _isLoading = false;
//               });
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   SnackBar(
//               //     content: Text('Error loading chat: ${error.description}'),
//               //     backgroundColor: Colors.red,
//               //   ),
//               // );
//             }
//           },
//         ),
//       )
//       ..loadHtmlString(_getLandBotHtml());
//   }

//   String _getLandBotHtml() {
//     return '''
// <!DOCTYPE html>
// <html>
// <head>
//     <meta charset="UTF-8">
//     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     <title>LandBot Chat</title>
//     <style>
//         body {
//             margin: 0;
//             padding: 0;
//             height: 100vh;
//             width: 100vw;
//             overflow: hidden;
//         }
//         #landbot-container {
//             width: 100vw;
//             height: 100vh;
//             position: relative;
//         }
//     </style>
// </head>
// <body>
//     <div id="landbot-container"></div>
    
//     <script> 
//     var myLandbot;
    
//     function initLandbot() {
//       if (!myLandbot) {
//         console.log('Initializing LandBot...');
//         var s = document.createElement('script');
//         s.type = "module";
//         s.async = true;
//         s.addEventListener('load', function() {
//           try {
//             console.log('LandBot script loaded, creating instance...');
//             myLandbot = new Landbot.Livechat({
//               configUrl: 'https://storage.googleapis.com/landbot.pro/v3/H-3123424-VTUGILM9SG3VF4ID/index.json',
//             });
//             console.log('LandBot initialized successfully');
//           } catch (error) {
//             console.error('Error creating LandBot instance:', error);
//           }
//         });
        
//         s.addEventListener('error', function(error) {
//           console.error('Failed to load LandBot script:', error);
//         });
        
//         s.src = 'https://cdn.landbot.io/landbot-3/landbot-3.0.0.mjs';
//         document.head.appendChild(s);
//       }
//     }
    
//     // Initialize immediately without any delays
//     if (document.readyState === 'loading') {
//       document.addEventListener('DOMContentLoaded', initLandbot);
//     } else {
//       initLandbot();
//     }
//     </script>
// </body>
// </html>
//     ''';
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
//         foregroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         leading: IconButton(
//           icon: Icon(
//             Theme.of(context).platform == TargetPlatform.iOS
//                 ? CupertinoIcons.back
//                 : Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: AppText(
//           text: 'AI Support Chat',
//           size: 18,
//           weight: FontWeight.bold,
//           textColor: Colors.white,
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           SizedBox.expand(child: WebViewWidget(controller: _controller)),
//           if (_isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: isDarkMode
//                     ? AppConstants.darkBackgroundColor
//                     : AppConstants.whiteBackgroundColor,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           AppConstants.primaryColor,
//                         ),
//                         strokeWidth: 3.0,
//                       ),
//                       const SizedBox(height: 16),
//                       AppText(
//                         text: 'Connecting to AI Support...',
//                         size: 16,
//                         weight: FontWeight.normal,
//                         textColor: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }






















// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/services/razorpay_embedded_service.dart';
// import 'package:norkacare_app/screen/verification/payment/razorpay_checkout_page.dart';
// import 'package:provider/provider.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/services/vidal_data_mapper.dart';

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
//   bool _hasRequestIdGenerated = false;
//   bool _hasValidationCalled = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadFamilyData();
//     });
//   }

//   void _loadFamilyData() async {
//     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//     final verificationProvider = Provider.of<VerificationProvider>(
//       context,
//       listen: false,
//     );

//     if (norkaProvider.norkaId.isNotEmpty &&
//         verificationProvider.familyMembersDetails.isEmpty) {
//       await verificationProvider.getFamilyMembers(norkaProvider.norkaId);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Consumer<VerificationProvider>(
//       builder: (context, verificationProvider, child) {
//         return Scaffold(
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
//                   // Page title
//                   AppText(
//                     text: '',
//                     size: 20,
//                     weight: FontWeight.w600,
//                     textColor: Colors.white,
//                   ),
//                   const SizedBox(height: 24),

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
//                                       text: 'Premium',
//                                       size: 14,
//                                       weight: FontWeight.w500,
//                                       textColor: isDarkMode
//                                           ? AppConstants.whiteColor
//                                           : AppConstants.blackColor,
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Fluttertoast.showToast(
//                                           msg:
//                                               'Premium breakup details will be shown here',
//                                           toastLength: Toast.LENGTH_SHORT,
//                                           gravity: ToastGravity.BOTTOM,
//                                           backgroundColor: Colors.green,
//                                           textColor: Colors.white,
//                                         );
//                                       },
//                                       child: AppText(
//                                         text: 'Get the premium breakup',
//                                         size: 12,
//                                         weight: FontWeight.w500,
//                                         textColor: AppConstants.primaryColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 AppText(
//                                   text: '₹12,980',
//                                   size: 28,
//                                   weight: FontWeight.bold,
//                                   textColor: isDarkMode
//                                       ? AppConstants.whiteColor
//                                       : AppConstants.blackColor,
//                                 ),
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

//                                 verificationProvider
//                                         .isFamilyMembersDetailsLoading
//                                     ? const Center(
//                                         child: Padding(
//                                           padding: EdgeInsets.all(20.0),
//                                           child: CircularProgressIndicator(),
//                                         ),
//                                       )
//                                     : _buildFamilyMembersList(
//                                         verificationProvider
//                                             .familyMembersDetails,
//                                       ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 24),

//                           // Checkboxes
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: isDeclarationChecked,
//                                 onChanged: (value) async {
//                                   setState(() {
//                                     isDeclarationChecked = value ?? false;
//                                     // Reset subsequent checkboxes when first is unchecked
//                                     if (!isDeclarationChecked) {
//                                       isTermsChecked = false;
//                                       isPolicyTermsChecked = false;
//                                       _hasValidationCalled = false;
//                                     }
//                                   });

//                                   // Call generateRequestId API when checkbox is first checked
//                                   if (isDeclarationChecked &&
//                                       !_hasRequestIdGenerated) {
//                                     _hasRequestIdGenerated = true;
//                                     final verificationProvider =
//                                         Provider.of<VerificationProvider>(
//                                           context,
//                                           listen: false,
//                                         );
//                                     try {
//                                       await verificationProvider
//                                           .getRequestIdDetails();
//                                       debugPrint(
//                                         'Request ID generated successfully',
//                                       );
//                                     } catch (e) {
//                                       debugPrint(
//                                         'Error generating request ID: $e',
//                                       );
//                                       // Reset the flag on error so user can try again
//                                       _hasRequestIdGenerated = false;
//                                     }
//                                   }
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
//                                 onChanged: isDeclarationChecked
//                                     ? (value) {
//                                         setState(() {
//                                           isTermsChecked = value ?? false;
//                                           // Reset third checkbox when second is unchecked
//                                           if (!isTermsChecked) {
//                                             isPolicyTermsChecked = false;
//                                           }
//                                         });
//                                       }
//                                     : null,
//                                 activeColor: AppConstants.primaryColor,
//                               ),
//                               Expanded(
//                                 child: AppText(
//                                   text:
//                                       'I confirm that I have read and agree to the Terms and Policy.',
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
//                                 value: isPolicyTermsChecked,
//                                 onChanged:
//                                     (isDeclarationChecked && isTermsChecked)
//                                     ? (value) async {
//                                         setState(() {
//                                           isPolicyTermsChecked = value ?? false;
//                                         });

//                                         // Call vidalEnrollmentValidate API when checkbox is first checked
//                                         if (isPolicyTermsChecked &&
//                                             !_hasValidationCalled) {
//                                           _hasValidationCalled = true;
//                                           final verificationProvider =
//                                               Provider.of<VerificationProvider>(
//                                                 context,
//                                                 listen: false,
//                                               );
//                                           final norkaProvider =
//                                               Provider.of<NorkaProvider>(
//                                                 context,
//                                                 listen: false,
//                                               );

//                                           try {
//                                             // Check if we have the required data
//                                             if (norkaProvider.response !=
//                                                     null &&
//                                                 verificationProvider
//                                                     .familyMembersDetails
//                                                     .isNotEmpty &&
//                                                 verificationProvider
//                                                     .requestIdDetails
//                                                     .isNotEmpty) {
//                                               // Build validation payload
//                                               final validationPayload =
//                                                   VidalDataMapper.buildVidalValidationPayload(
//                                                     norkaResponse:
//                                                         norkaProvider.response!,
//                                                     familyMembersDetails:
//                                                         verificationProvider
//                                                             .familyMembersDetails,
//                                                     requestId: verificationProvider
//                                                         .requestIdDetails['data']?['request_id'],
//                                                     selfUniqueId:
//                                                         verificationProvider
//                                                             .familyMembersDetails['self_unique_id'] ??
//                                                         '',
//                                                   );

//                                               // Call validation API
//                                               await verificationProvider
//                                                   .vidalEnrollmentValidate(
//                                                     validationPayload,
//                                                   );
//                                               debugPrint(
//                                                 'Vidal validation API called successfully',
//                                               );
//                                             } else {
//                                               debugPrint(
//                                                 'Missing required data for validation API',
//                                               );
//                                               // Reset the flag so user can try again
//                                               _hasValidationCalled = false;
//                                             }
//                                           } catch (e) {
//                                             debugPrint(
//                                               'Error calling validation API: $e',
//                                             );
//                                             // Reset the flag on error so user can try again
//                                             _hasValidationCalled = false;
//                                           }
//                                         }
//                                       }
//                                     : null,
//                                 activeColor: AppConstants.primaryColor,
//                               ),
//                               Expanded(
//                                 child: AppText(
//                                   text:
//                                       'I hereby agreed and confirmed all terms and conditions as per the GMC and GPA policy by Ravikumar for the Family Health Insurance scheme.',
//                                   size: 14,
//                                   weight: FontWeight.normal,
//                                   textColor: isDarkMode
//                                       ? AppConstants.whiteColor
//                                       : AppConstants.blackColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Container(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed:
//                           _isLoading ||
//                               !isDeclarationChecked ||
//                               !isTermsChecked ||
//                               !isPolicyTermsChecked
//                           ? null
//                           : _handleConfirmAndPay,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             isDeclarationChecked &&
//                                 isTermsChecked &&
//                                 isPolicyTermsChecked
//                             ? AppConstants.primaryColor
//                             : Colors.grey,
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
//                                   'Processing...',
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
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),
//           ),
//         );
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

//     setState(() {
//       _isLoading = true;
//     });

//     const int premiumAmount = 12980;

//     try {
//       // Get user details from providers
//       final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//       String emailId = '';
//       String userName = 'Customer';
//       String contactNumber = '+919876543210';

//       // Extract email and name from NORKA provider response
//       if (norkaProvider.response != null) {
//         final emails = norkaProvider.response!['emails'];
//         if (emails != null && emails.isNotEmpty) {
//           emailId = emails[0]['address'] ?? '';
//         }

//         userName = norkaProvider.response!['name'] ?? 'Customer';
//         contactNumber = norkaProvider.response!['mobile'] ?? '+919876543210';
//       }

//       // Step 1: Create Razorpay Order
//       debugPrint('=== STEP 1: CREATING RAZORPAY ORDER ===');
//       final orderResponse = await RazorpayEmbeddedService.createOrder(
//         amount: premiumAmount,
//         currency: 'INR',
//         receipt: 'receipt_${DateTime.now().millisecondsSinceEpoch}',
//       );

//       if (orderResponse['status'] != 'created') {
//         throw Exception('Failed to create order');
//       }

//       final orderId = orderResponse['id'];
//       debugPrint('Order created successfully: $orderId');

//       // Step 2: Navigate to checkout form page
//       debugPrint('=== STEP 2: NAVIGATING TO CHECKOUT FORM PAGE ===');
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) {
//               debugPrint('Building RazorpayCheckoutPage widget');
//               return RazorpayCheckoutPage(
//                 orderId: orderId,
//                 amount: premiumAmount,
//                 currency: 'INR',
//                 name: 'Norka Care',
//                 description: 'Insurance Premium Payment - ₹12,980',
//                 image:
//                     'https://cdn.razorpay.com/logos/BUVwvgaqVByGp2_large.jpg',
//                 prefill: {
//                   'contact': contactNumber,
//                   'email': emailId.isNotEmpty
//                       ? emailId
//                       : 'customer@example.com',
//                   'name': userName,
//                 },
//                 notes: {
//                   'shipping address': 'Norka Care Insurance',
//                   'policy_type': 'Family Health Insurance',
//                   'nrk_id': norkaProvider.norkaId,
//                 },
//                 callbackUrl: 'https://example.com/payment-callback',
//                 cancelUrl: 'https://example.com/payment-cancel',
//               );
//             },
//           ),
//         );
//         debugPrint('Navigation completed');
//       }

//       // Reset loading state after navigation
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Payment initialization failed. Please try again.',
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
//     if (familyData.isEmpty) {
//       return AppText(
//         text: 'Loading family members...',
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
//             _formatGender(familyData['kid_${i}_relation'] ?? ''),
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

//   String _formatDOB(String dob) {
//     if (dob.isEmpty) return '';

//     // Check if the date is in MM-DD-YYYY format (with hyphens)
//     if (dob.contains('-') && dob.length >= 10) {
//       try {
//         List<String> parts = dob.split('-');
//         if (parts.length == 3) {
//           String month = parts[0].padLeft(2, '0');
//           String day = parts[1].padLeft(2, '0');
//           String year = parts[2];

//           // Convert from MM-DD-YYYY to DD-MM-YYYY
//           return '$day-$month-$year';
//         }
//       } catch (e) {
//         debugPrint('Error formatting DOB: $e');
//       }
//     }

//     // Check if the date is in MM/DD/YYYY format (with slashes)
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
// }






// import 'package:norkacare_app/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/screen/verification/payment/payment_success_page.dart';
// import 'package:norkacare_app/services/razorpay_embedded_service.dart';

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
//       // Prepare form data for embedded checkout
//       final formData = {
//         'key_id': 'rzp_test_R9THzwql6lKlIL', // Your Razorpay key
//         'amount': (widget.amount * 100).toString(),
//         'currency': widget.currency,
//         'order_id': widget.orderId,
//         'name': widget.name,
//         'description': widget.description,
//         'image': widget.image,
//         'prefill[name]': widget.prefill['name'] ?? '',
//         'prefill[contact]': widget.prefill['contact'] ?? '',
//         'prefill[email]': widget.prefill['email'] ?? '',
//         'callback_url': widget.callbackUrl,
//         'cancel_url': widget.cancelUrl,
//       };

//       // Add notes
//       widget.notes.forEach((key, value) {
//         formData['notes[$key]'] = value;
//       });

//       debugPrint('=== SUBMITTING TO EMBEDDED API ===');
//       debugPrint('Form data: $formData');

//       // Submit checkout form to Razorpay embedded API
//       final checkoutResponse = await RazorpayEmbeddedService.submitCheckoutForm(
//         formData: formData,
//       );

//       debugPrint('=== EMBEDDED API RESPONSE RECEIVED ===');
//       debugPrint('Response length: ${checkoutResponse.length}');
//       debugPrint('Response preview: ${checkoutResponse.substring(0, 200)}...');
//       debugPrint('=== FULL EMBEDDED API RESPONSE ===');
//       debugPrint('$checkoutResponse');
//       debugPrint('=== END EMBEDDED API RESPONSE ===');

//       // Now open Razorpay checkout with the order details
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









// import 'package:flutter/material.dart';
// import '../utils/razorpay_config.dart';
// import '../support/dio_helper.dart';

// class RazorpayEmbeddedService {
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

//   // Submit checkout form to embedded API
//   static Future<String> submitCheckoutForm({
//     required Map<String, String> formData,
//   }) async {
//     debugPrint('=== SUBMITTING CHECKOUT FORM ===');
//     debugPrint('Form Data: $formData');

//     try {
//       final dio = await DioHelper.getInstance();
//       dio.options.headers = {
//         'Content-Type': 'application/x-www-form-urlencoded',
//         'Authorization': RazorpayConfig.authorizationHeader,
//       };

//       // Convert form data to URL encoded format
//       final formBody = formData.entries
//           .map(
//             (e) =>
//                 '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
//           )
//           .join('&');

//       debugPrint('=== EMBEDDED CHECKOUT API REQUEST ===');
//       debugPrint('URL: https://api.razorpay.com/v1/checkout/embedded');
//       debugPrint('Method: POST');
//       debugPrint('Headers: ${dio.options.headers}');
//       debugPrint('Form Body: $formBody');

//       final response = await dio.post(
//         'https://api.razorpay.com/v1/checkout/embedded',
//         data: formBody,
//       );

//       debugPrint('=== EMBEDDED CHECKOUT API RESPONSE ===');
//       debugPrint('Status Code: ${response.statusCode}');
//       debugPrint('Response Data: ${response.data}');
//       debugPrint('Response Type: ${response.data.runtimeType}');

//       if (response.statusCode == 200) {
//         final responseData = response.data;

//         if (responseData is String) {
//           debugPrint('=== EMBEDDED CHECKOUT SUCCESS (HTML) ===');
//           debugPrint('HTML Response Length: ${responseData.length}');
//           return responseData;
//         } else if (responseData is Map<String, dynamic>) {
//           debugPrint('=== EMBEDDED CHECKOUT SUCCESS (JSON) ===');
//           debugPrint('JSON Response: $responseData');
//           return responseData['url'] ?? responseData.toString();
//         } else {
//           debugPrint('=== EMBEDDED CHECKOUT SUCCESS (OTHER) ===');
//           debugPrint('Response: $responseData');
//           return responseData.toString();
//         }
//       } else {
//         debugPrint('=== EMBEDDED CHECKOUT FAILED ===');
//         debugPrint('Error Status: ${response.statusCode}');
//         debugPrint('Error Data: ${response.data}');
//         throw Exception(
//           'Failed to submit checkout form: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       debugPrint('=== EMBEDDED CHECKOUT ERROR ===');
//       debugPrint('Error: $e');
//       throw Exception('Failed to submit checkout form: $e');
//     }
//   }

//   // Process embedded payment (create order + submit form)
//   static Future<String> processEmbeddedPayment({
//     required int amount,
//     required String currency,
//     required String name,
//     required String description,
//     required String receipt,
//     required String image,
//     required Map<String, String> prefill,
//     required Map<String, String> notes,
//     required String callbackUrl,
//     required String cancelUrl,
//   }) async {
//     try {
//       debugPrint('=== PROCESSING EMBEDDED PAYMENT ===');
//       debugPrint('Amount: ₹$amount (${amount * 100} paise)');
//       debugPrint('Currency: $currency');
//       debugPrint('Description: $description');

//       // Step 1: Create order
//       final orderResponse = await createOrder(
//         amount: amount,
//         currency: currency,
//         receipt: receipt,
//       );

//       if (orderResponse['status'] != 'created') {
//         throw Exception('Failed to create order');
//       }

//       final orderId = orderResponse['id'];
//       debugPrint('Order created successfully: $orderId');

//       // Step 2: Prepare form data
//       final formData = <String, String>{
//         'key_id': RazorpayConfig.keyId,
//         'amount': (amount * 100).toString(),
//         'currency': currency,
//         'order_id': orderId,
//         'name': name,
//         'description': description,
//         'image': image,
//         'prefill[name]': prefill['name'] ?? '',
//         'prefill[contact]': prefill['contact'] ?? '',
//         'prefill[email]': prefill['email'] ?? '',
//         'callback_url': callbackUrl,
//         'cancel_url': cancelUrl,
//       };

//       // Add notes
//       notes.forEach((key, value) {
//         formData['notes[$key]'] = value;
//       });

//       // Step 3: Submit checkout form
//       final checkoutResponse = await submitCheckoutForm(formData: formData);

//       debugPrint('=== EMBEDDED PAYMENT PROCESSING COMPLETE ===');
//       return checkoutResponse;
//     } catch (e) {
//       debugPrint('=== EMBEDDED PAYMENT PROCESSING ERROR ===');
//       debugPrint('Error: $e');
//       throw Exception('Failed to process embedded payment: $e');
//     }
//   }
// }















// import 'package:norkacare_app/services/razorpay_service.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/screen/verification/payment/payment_success_page.dart';
// import 'package:provider/provider.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:norkacare_app/services/vidal_data_mapper.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

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
//   bool _hasRequestIdGenerated = false;
//   late Razorpay _razorpay;

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
//     final verificationProvider = Provider.of<VerificationProvider>(
//       context,
//       listen: false,
//     );

//     if (norkaProvider.norkaId.isNotEmpty &&
//         verificationProvider.familyMembersDetails.isEmpty) {
//       await verificationProvider.getFamilyMembers(norkaProvider.norkaId);
//     }

//     if (norkaProvider.norkaId.isNotEmpty &&
//         verificationProvider.datesDetails.isEmpty) {
//       await verificationProvider.getDatesDetails(norkaProvider.norkaId);
//     }
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

//     // Check if it's a user cancellation (code 2)
//     if (response.code == 2) {
//       Fluttertoast.showToast(
//         msg: "payment Failed",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     } else {
//       Fluttertoast.showToast(
//         msg: "Payment Failed: ${response.message}",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }

//     setState(() {
//       _isLoading = false;
//       // Reset request ID flag so a new one can be generated on retry
//       _hasRequestIdGenerated = false;
//       debugPrint(
//         'Request ID flag reset - new request ID will be generated on next attempt',
//       );
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
//         return Scaffold(
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
//                   // Page title
//                   AppText(
//                     text: '',
//                     size: 20,
//                     weight: FontWeight.w600,
//                     textColor: Colors.white,
//                   ),
//                   const SizedBox(height: 24),

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
//                                       text: 'Premium',
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
//                                         text: 'Get the premium breakup',
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

//                                 verificationProvider
//                                         .isFamilyMembersDetailsLoading
//                                     ? const Center(
//                                         child: Padding(
//                                           padding: EdgeInsets.all(20.0),
//                                           child: CircularProgressIndicator(),
//                                         ),
//                                       )
//                                     : _buildFamilyMembersList(
//                                         verificationProvider
//                                             .familyMembersDetails,
//                                       ),
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
//                                     // Reset subsequent checkboxes when first is unchecked
//                                     if (!isDeclarationChecked) {
//                                       isTermsChecked = false;
//                                       isPolicyTermsChecked = false;
//                                     }
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
//                                 onChanged: isDeclarationChecked
//                                     ? (value) {
//                                         setState(() {
//                                           isTermsChecked = value ?? false;
//                                           // Reset third checkbox when second is unchecked
//                                           if (!isTermsChecked) {
//                                             isPolicyTermsChecked = false;
//                                           }
//                                         });
//                                       }
//                                     : null,
//                                 activeColor: AppConstants.primaryColor,
//                               ),
//                               Expanded(
//                                 child: AppText(
//                                   text:
//                                       'I confirm that I have read and agree to the Terms and Policy.',
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
//                                 value: isPolicyTermsChecked,
//                                 onChanged:
//                                     (isDeclarationChecked && isTermsChecked)
//                                     ? (value) async {
//                                         setState(() {
//                                           isPolicyTermsChecked = value ?? false;
//                                         });
//                                       }
//                                     : null,
//                                 activeColor: AppConstants.primaryColor,
//                               ),
//                               Expanded(
//                                 child: AppText(
//                                   text:
//                                       'I hereby agreed and confirmed all terms and conditions as per the GMC and GPA policy by Ravikumar for the Family Health Insurance scheme.',
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
//                       onPressed:
//                           _isLoading ||
//                               !isDeclarationChecked ||
//                               !isTermsChecked ||
//                               !isPolicyTermsChecked
//                           ? null
//                           : _handleConfirmAndPay,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             isDeclarationChecked &&
//                                 isTermsChecked &&
//                                 isPolicyTermsChecked
//                             ? AppConstants.primaryColor
//                             : Colors.grey,
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
//                                   'Processing...',
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
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),
//           ),
//         );
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

//     setState(() {
//       _isLoading = true;
//     });

//     // Get premium amount from API response
//     final verificationProvider = Provider.of<VerificationProvider>(
//       context,
//       listen: false,
//     );

//     int premiumAmount = 0;
//     if (verificationProvider.premiumAmount.isNotEmpty) {
//       // Try to get total_amount from premium_breakdown first
//       if (verificationProvider.premiumAmount.containsKey('premium_breakdown') &&
//           verificationProvider.premiumAmount['premium_breakdown'] is Map) {
//         final breakdown =
//             verificationProvider.premiumAmount['premium_breakdown']
//                 as Map<String, dynamic>;
//         if (breakdown.containsKey('total_amount')) {
//           premiumAmount = (breakdown['total_amount'] as num).toInt();
//         }
//       }

//       // Fallback to premium_amount
//       if (premiumAmount == 0 &&
//           verificationProvider.premiumAmount.containsKey('premium_amount')) {
//         premiumAmount =
//             (verificationProvider.premiumAmount['premium_amount'] as num)
//                 .toInt();
//       }
//     }

//     // Default fallback amount
//     if (premiumAmount == 0) {
//       premiumAmount = 12980;
//     }

//     try {
//       // Step 0: Generate Request ID first
//       debugPrint('=== STEP 0: GENERATING REQUEST ID ===');

//       if (!_hasRequestIdGenerated) {
//         try {
//           debugPrint('Generating new request ID...');
//           await verificationProvider.getRequestIdDetails();
//           _hasRequestIdGenerated = true;
//           debugPrint('Request ID generated successfully');
//         } catch (e) {
//           debugPrint('Error generating request ID: $e');
//           setState(() {
//             _isLoading = false;
//           });
//           // Fluttertoast.showToast(
//           //   msg: 'Failed to generate request ID. Please try again.',
//           //   toastLength: Toast.LENGTH_SHORT,
//           //   gravity: ToastGravity.BOTTOM,
//           //   backgroundColor: Colors.red,
//           //   textColor: Colors.white,
//           // );
//           return;
//         }
//       } else {
//         debugPrint('Request ID already generated - skipping generation');
//       }

//       // Get user details from providers
//       final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
//       String emailId = '';
//       String userName = 'Customer';
//       String contactNumber = '+919876543210';

//       // Extract email, name, and contact from NORKA provider response
//       if (norkaProvider.response != null) {
//         final emails = norkaProvider.response!['emails'];
//         if (emails != null && emails.isNotEmpty) {
//           emailId = emails[0]['address'] ?? '';
//         }

//         userName = norkaProvider.response!['name'] ?? 'Customer';

//         // Extract mobile number from NORKA API response structure
//         if (norkaProvider.response!['mobiles'] != null &&
//             norkaProvider.response!['mobiles'] is List) {
//           final mobiles = norkaProvider.response!['mobiles'] as List;
//           if (mobiles.isNotEmpty && mobiles[0] is Map) {
//             contactNumber =
//                 mobiles[0]['with_dial_code'] ??
//                 mobiles[0]['number'] ??
//                 '+919876543210';
//           }
//         }

//         debugPrint('=== EXTRACTED CONTACT INFO ===');
//         debugPrint('Contact Number: $contactNumber');
//         debugPrint('Email: $emailId');
//         debugPrint('Name: $userName');
//       }

//       // Step 1: Call Vidal validation API
//       debugPrint('=== STEP 1: CALLING VIDAL VALIDATION API ===');

//       // Check if we have the required data for validation
//       if (norkaProvider.response != null &&
//           verificationProvider.familyMembersDetails.isNotEmpty &&
//           verificationProvider.requestIdDetails.isNotEmpty) {
//         // Build validation payload
//         final validationPayload = VidalDataMapper.buildVidalValidationPayload(
//           norkaResponse: norkaProvider.response!,
//           familyMembersDetails: verificationProvider.familyMembersDetails,
//           requestId:
//               verificationProvider.requestIdDetails['data']?['request_id'],
//           selfUniqueId:
//               verificationProvider.familyMembersDetails['self_unique_id'] ?? '',
//           datesDetails: verificationProvider.datesDetails,
//         );

//         // Call validation API
//         await verificationProvider.vidalEnrollmentValidate(validationPayload);

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
//             msg: 'Validation failed. No response received.',
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
//           msg: 'Missing required data for validation. Please try again.',
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
//       );

//       if (orderResponse['status'] != 'created') {
//         throw Exception('Failed to create order');
//       }

//       final orderId = orderResponse['id'];
//       debugPrint('Order created successfully: $orderId');

//       // Step 3: Open Razorpay payment gateway directly
//       debugPrint('=== STEP 3: OPENING RAZORPAY PAYMENT GATEWAY ===');

//       // Prepare Razorpay options
//       var options = {
//         'key': 'rzp_test_R9THzwql6lKlIL',
//         'amount': premiumAmount * 100,
//         'currency': 'INR',
//         'name': 'Norka Care',
//         'description': 'Insurance Premium Payment - ₹12,980',
//         'order_id': orderId,
//         'prefill': {
//           'contact': contactNumber,
//           'email': emailId.isNotEmpty ? emailId : 'customer@example.com',
//           'name': userName,
//         },
//         'theme': {'color': '#004EA1'}, // Using app primary color
//         'timeout': 300,
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
//           setState(() {
//             _isLoading = false;
//           });
//         } catch (e) {
//           debugPrint("Error opening Razorpay: $e");
//           setState(() {
//             _isLoading = false;
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
//       Fluttertoast.showToast(
//         msg: 'Payment initialization failed. Please try again.',
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
//     if (familyData.isEmpty) {
//       return AppText(
//         text: 'Loading family members...',
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
//             _formatGender(familyData['kid_${i}_relation'] ?? ''),
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

//   String _formatDOB(String dob) {
//     if (dob.isEmpty) return '';

//     // Check if the date is in MM-DD-YYYY format (with hyphens)
//     if (dob.contains('-') && dob.length >= 10) {
//       try {
//         List<String> parts = dob.split('-');
//         if (parts.length == 3) {
//           String month = parts[0].padLeft(2, '0');
//           String day = parts[1].padLeft(2, '0');
//           String year = parts[2];

//           // Convert from MM-DD-YYYY to DD-MM-YYYY
//           return '$day-$month-$year';
//         }
//       } catch (e) {
//         debugPrint('Error formatting DOB: $e');
//       }
//     }

//     // Check if the date is in MM/DD/YYYY format (with slashes)
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
//             borderRadius: BorderRadius.circular(16),
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
//                       text: 'Premium Breakdown',
//                       size: 20,
//                       weight: FontWeight.bold,
//                       textColor: isDarkMode
//                           ? AppConstants.whiteColor
//                           : AppConstants.blackColor,
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.of(context).pop(),
//                       child: Icon(
//                         Icons.close,
//                         color: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor,
//                         size: 24,
//                       ),
//                     ),
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
//                     text: 'Premium Calculation',
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
//                     text: 'Premium Configuration',
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
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppConstants.primaryColor,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: AppText(
//                       text: 'Close',
//                       size: 16,
//                       weight: FontWeight.w600,
//                       textColor: AppConstants.whiteColor,
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




// 98172245322



// @registration_screen.dart @otp_varification.dart 


// send otp:----------
// @https://adslbackend.tqdemo.website/api/ nrk-verification/verify/

// body: {
//     "nrk_id_no": "12312312355"
// }

// response: {
//     "success": true,
//     "message": "OTP sent successfully to unnioffi0620@gmail.com",
//     "data": {
//         "verification": {
//             "id": 1,
//             "nrk_id": "12312312355",
//             "name": "Unni",
//             "date_of_birth": "02-05-1981",
//             "gender": "Male",
//             "address": {
//                 "address": "Elempurayidam, Amboori P O,\r\nVellar, ada via,\r\nThiruvananthapuram - 695 505",
//                 "local_body": "Amburi",
//                 "district": "Thiruvananthapuram",
//                 "pincode": "695505"
//             },
//             "working_country": "",
//             "mobiles": [
//                 {
//                     "dial_code": "+91",
//                     "number": "8590316565",
//                     "with_dial_code": "+918590316565",
//                     "primary": true
//                 }
//             ],
//             "emails": [
//                 {
//                     "address": "unnioffi0620@gmail.com",
//                     "primary": true
//                 }
//             ],
//             "is_active": false,
//             "valid_from": "05-18-2009",
//             "valid_to": "05-17-2012",
//             "sso_id": "",
//             "primary_email": "unnioffi0620@gmail.com",
//             "primary_mobile": "+918590316565",
//             "created_at": "2025-09-18T03:30:15.884296Z"
//         },
//         "otp_expires_at": "2025-09-18T03:41:06.310019+00:00"
//     }
// }



// verify otp:---------

// @https://adslbackend.tqdemo.website/api/
// nrk-verification/verify-otp/

// body:  {
//     "nrk_id": "12312312355",
//     "email": "unnioffi0620@gmail.com",
//     "otp": "123456"
// }

// response: {
//     "success": true,
//     "message": "OTP verified successfully",
//     "data": {
//         "verification": {
//             "id": 1,
//             "nrk_id": "12312312355",
//             "name": "Unni",
//             "date_of_birth": "02-05-1981",
//             "gender": "Male",
//             "address": {
//                 "address": "Elempurayidam, Amboori P O,\r\nVellar, ada via,\r\nThiruvananthapuram - 695 505",
//                 "local_body": "Amburi",
//                 "district": "Thiruvananthapuram",
//                 "pincode": "695505"
//             },
//             "working_country": "",
//             "mobiles": [
//                 {
//                     "dial_code": "+91",
//                     "number": "8590316565",
//                     "with_dial_code": "+918590316565",
//                     "primary": true
//                 }
//             ],
//             "emails": [
//                 {
//                     "address": "unnioffi0620@gmail.com",
//                     "primary": true
//                 }
//             ],
//             "is_active": false,
//             "valid_from": "05-18-2009",
//             "valid_to": "05-17-2012",
//             "sso_id": "",
//             "primary_email": "unnioffi0620@gmail.com",
//             "primary_mobile": "+918590316565",
//             "created_at": "2025-09-18T03:30:15.884296Z"
//         },
//         "verified_at": "2025-09-18T03:41:35.954482+00:00"
//     }
// }

// resent otp:---------

// @https://adslbackend.tqdemo.website/api/ nrk-verification/resend-otp/

// body: {
//     "nrk_id": "12312312355",
//     "email": "unnioffi0620@gmail.com"
// }

// the resent otp sent into one minute




// integrate please@customer_details.dart @registration_screen.dart @otp_varification.dart
//
//
//
//
//
//
//
//
//
//import 'package:norkacare_app/services/verification_service.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';

// class VerificationProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   String _errorMessage = '';
//   Map<String, dynamic>? _response;
//   Map<String, dynamic>? _verificationResponse;

//   bool get isLoading => _isLoading;
//   String get errorMessage => _errorMessage;
//   Map<String, dynamic>? get response => _response;
//   Map<String, dynamic>? get verificationResponse => _verificationResponse;

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void clearData() {
//     _response = null;
//     _verificationResponse = null;
//     _errorMessage = '';
//     _familyMembersDetails = {};
//     _isFamilyMembersDetailsLoading = true;
//     _hasFamilyMembersLoadedOnce = false; // Reset this flag too
//     _enrollmentDetails = {};
//     _isEnrollmentDetailsLoading = true;
//     _hasEnrollmentDetailsLoadedOnce = false; // Reset this flag too
//     _requestIdDetails = {};
//     _isRequestIdDetailsLoading = true;
//     _paymentHistory = {};
//     _isPaymentHistoryLoading = true;
//     _hasPaymentHistoryLoadedOnce = false; // Reset this flag too
//     _paymentVerification = {};
//     _isPaymentVerificationLoading = false;
//     _datesDetails = {};
//     _isDatesDetailsLoading = true;
//     _premiumAmount = {};
//     _isPremiumAmountLoading = true;
//     notifyListeners();
//   }

//   void _handleError(DioException e) {
//     _errorMessage =
//         e.response?.data['message'] ?? 'An error occurred. Please try again.';
//     if (e.response == null) {
//       _errorMessage = 'Network error. Please check your internet connection.';
//     }
//     debugPrint("Dio Error: ${e.response}");
//   }

//   Future<void> AddFamilyMembers(Map<String, dynamic> data) async {
//     _setLoading(true);
//     _errorMessage = '';
//     try {
//       final response = await VerificationService.AddFamilyMembers(data);
//       _response = response;
//       debugPrint(">>>>>>>$response");

//       // Check if response contains success indicators
//       if (response != null) {
//         // Check for success indicators in the response data
//         bool hasSuccessData =
//             response.containsKey('data') &&
//             response['data'] != null &&
//             (response['data'].containsKey('sl_no') ||
//                 response['data'].containsKey('nrk_id_no') ||
//                 response['data'].containsKey('family_members_count'));

//         // Check for success message
//         bool hasSuccessMessage =
//             response.containsKey('message') &&
//             (response['message'].toString().toLowerCase().contains('success') ||
//                 response['message'].toString().toLowerCase().contains(
//                   'created',
//                 ));

//         if (hasSuccessData || hasSuccessMessage) {
//           _errorMessage = '';
//           debugPrint("✅ Success: API call successful, clearing error message");
//         } else if (response.containsKey('message')) {
//           _errorMessage = response['message'];
//           debugPrint("⚠️ API returned message: ${response['message']}");
//         } else {
//           _errorMessage = '';
//           debugPrint("✅ Success: No specific message, treating as success");
//         }
//       } else {
//         _errorMessage = '';
//         debugPrint("✅ Success: No response, treating as success");
//       }
//     } on DioException catch (e) {
//       _handleError(e);
//     } catch (e) {
//       _errorMessage = "An unexpected error occurred.";
//       debugPrint("General Error: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Map<String, dynamic> _familyMembersDetails = {};
//   bool _isFamilyMembersDetailsLoading = true;
//   bool _hasFamilyMembersLoadedOnce = false;

//   Map<String, dynamic> get familyMembersDetails => _familyMembersDetails;
//   bool get isFamilyMembersDetailsLoading => _isFamilyMembersDetailsLoading;
//   bool get hasFamilyMembersLoadedOnce => _hasFamilyMembersLoadedOnce;

//   Future<void> getFamilyMembers(String nrkId) async {
//     try {
//       _isFamilyMembersDetailsLoading = true;
//       notifyListeners();
//       final response = await VerificationService.getFamilyMembers(nrkId);
//       print('>>>>>>>>$response');
//       _familyMembersDetails = response ?? {};
//       _hasFamilyMembersLoadedOnce = true;
//     } catch (e) {
//       debugPrint('Error fetching family members: $e');
//       // Handle 404 errors gracefully - no family data available yet
//       if (e is DioException && e.response?.statusCode == 404) {
//         debugPrint(
//           'No family information found for NRK ID: $nrkId - this is normal for new users',
//         );
//         _familyMembersDetails = {}; // Set empty data instead of showing error
//       }
//     } finally {
//       _isFamilyMembersDetailsLoading = false;
//       notifyListeners();
//     }
//   }

//   void clearFamilyMembersData() {
//     _familyMembersDetails = {};
//     _isFamilyMembersDetailsLoading = true;
//     notifyListeners();
//   }

//   void clearEnrollmentData() {
//     _enrollmentDetails = {};
//     _isEnrollmentDetailsLoading = true;
//     notifyListeners();
//   }

//   Future<void> Enrolling(Map<String, dynamic> data) async {
//     _setLoading(true);
//     _errorMessage = '';
//     try {
//       final response = await VerificationService.Enrolling(data);
//       _response = response;
//       debugPrint(">>>>>>>$response");

//       // Check if response contains success indicators
//       if (response != null) {
//         // Check for success indicators in the response
//         bool hasSuccessData =
//             response.containsKey('data') &&
//             response['data'] != null &&
//             response['data'].containsKey('self_enrollment_number');

//         // Check for success message
//         bool hasSuccessMessage =
//             response.containsKey('message') &&
//             (response['message'].toString().toLowerCase().contains('success') ||
//                 response['message'].toString().toLowerCase().contains(
//                   'generated',
//                 ));

//         if (hasSuccessData || hasSuccessMessage) {
//           _errorMessage = '';
//           debugPrint("✅ Success: API call successful, clearing error message");

//           // Store enrollment details from the response
//           if (response.containsKey('data') && response['data'] != null) {
//             _enrollmentDetails = response;
//             _isEnrollmentDetailsLoading = false;
//             debugPrint("✅ Enrollment details stored from POST response");
//           }
//         } else if (response.containsKey('message')) {
//           _errorMessage = response['message'];
//           debugPrint("⚠️ API returned message: ${response['message']}");
//         } else {
//           _errorMessage = '';
//           debugPrint("✅ Success: No specific message, treating as success");
//         }
//       } else {
//         _errorMessage = '';
//         debugPrint("✅ Success: No response, treating as success");
//       }
//     } on DioException catch (e) {
//       _handleError(e);
//     } catch (e) {
//       _errorMessage = "An unexpected error occurred.";
//       debugPrint("General Error: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Map<String, dynamic> _enrollmentDetails = {};
//   bool _isEnrollmentDetailsLoading = true;
//   bool _hasEnrollmentDetailsLoadedOnce = false;

//   Map<String, dynamic> get enrollmentDetails => _enrollmentDetails;
//   bool get isEnrollmentDetailsLoading => _isEnrollmentDetailsLoading;
//   bool get hasEnrollmentDetailsLoadedOnce => _hasEnrollmentDetailsLoadedOnce;

//   Future<void> getEnrollmentDetails(String nrkId) async {
//     try {
//       _isEnrollmentDetailsLoading = true;
//       notifyListeners();
//       final response = await VerificationService.getEnrollmentDetails(nrkId);
//       print('>>>>>>>>$response');
//       _enrollmentDetails = response ?? {};
//       _hasEnrollmentDetailsLoadedOnce = true;
//     } catch (e) {
//       debugPrint('Error fetching enrollment details: $e');
//       // Handle 404 errors gracefully - no enrollment data available yet
//       if (e is DioException && e.response?.statusCode == 404) {
//         debugPrint(
//           'No enrollment information found for NRK ID: $nrkId - this is normal for new users',
//         );
//         _enrollmentDetails = {}; // Set empty data instead of showing error
//       }
//     } finally {
//       _isEnrollmentDetailsLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> vidalEnrollment(Map<String, dynamic> data) async {
//     _setLoading(true);
//     _errorMessage = '';
//     try {
//       debugPrint("=== VIDAL ENROLLMENT API REQUEST ===");
//       debugPrint("Request Data: $data");

//       final response = await VerificationService.vidalEnrollment(data);
//       _response = response;

//       debugPrint("=== VIDAL ENROLLMENT API RESPONSE ===");
//       debugPrint("Response: $response");
//       debugPrint("=== END VIDAL API RESPONSE ===");

//       // Check if response contains success indicators
//       if (response != null) {
//         // Check for success indicators in the response
//         bool hasSuccessData =
//             response.containsKey('data') &&
//             response['data'] != null &&
//             response['data'].containsKey('self_enrollment_number');

//         // Check for success message
//         bool hasSuccessMessage =
//             response.containsKey('message') &&
//             (response['message'].toString().toLowerCase().contains('success') ||
//                 response['message'].toString().toLowerCase().contains(
//                   'generated',
//                 ));

//         if (hasSuccessData || hasSuccessMessage) {
//           _errorMessage = '';
//           debugPrint("✅ Success: API call successful, clearing error message");
//         } else if (response.containsKey('message')) {
//           _errorMessage = response['message'];
//           debugPrint("⚠️ API returned message: ${response['message']}");
//         } else {
//           _errorMessage = '';
//           debugPrint("✅ Success: No specific message, treating as success");
//         }
//       } else {
//         _errorMessage = '';
//         debugPrint("✅ Success: No response, treating as success");
//       }
//     } on DioException catch (e) {
//       _handleError(e);
//     } catch (e) {
//       _errorMessage = "An unexpected error occurred.";
//       debugPrint("General Error: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Map<String, dynamic> _requestIdDetails = {};
//   bool _isRequestIdDetailsLoading = true;

//   Map<String, dynamic> get requestIdDetails => _requestIdDetails;
//   bool get isRequestIdDetailsLoading => _isRequestIdDetailsLoading;

//   Future<void> getRequestIdDetails() async {
//     try {
//       _isRequestIdDetailsLoading = true;
//       notifyListeners();
//       final response = await VerificationService.generateRequestId();
//       print('>>>>>>>>$response');
//       _requestIdDetails = response ?? {};
//     } catch (e) {
//       debugPrint('Error fetching request id details: $e');
//     } finally {
//       _isRequestIdDetailsLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> vidalEnrollmentValidate(Map<String, dynamic> data) async {
//     _setLoading(true);
//     _errorMessage = '';
//     try {
//       debugPrint("=== VIDAL ENROLLMENT API REQUEST ===");
//       debugPrint("Request Data: $data");

//       final response = await VerificationService.vidalEnrollmentValidate(data);
//       _response = response;

//       debugPrint("=== VIDAL ENROLLMENT API RESPONSE ===");
//       debugPrint("Response: $response");
//       debugPrint("=== END VIDAL API RESPONSE ===");

//       // Check if response contains success indicators
//       if (response != null) {
//         // First check if API explicitly returned success: false
//         if (response.containsKey('success') && response['success'] == false) {
//           _errorMessage =
//               response['error']?['message'] ??
//               response['message'] ??
//               'Validation failed';
//           debugPrint("❌ Vidal validation failed: $_errorMessage");
//         }
//         // Check for error field
//         else if (response.containsKey('error')) {
//           _errorMessage =
//               response['error']?['message'] ??
//               response['message'] ??
//               'Validation failed';
//           debugPrint("❌ Vidal validation failed: $_errorMessage");
//         }
//         // Check for success indicators in the response
//         else {
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

//           if (hasSuccessData || hasSuccessMessage) {
//             _errorMessage = '';
//             debugPrint(
//               "✅ Success: API call successful, clearing error message",
//             );
//           } else if (response.containsKey('message')) {
//             _errorMessage = response['message'];
//             debugPrint("⚠️ API returned message: ${response['message']}");
//           } else {
//             _errorMessage = '';
//             debugPrint("✅ Success: No specific message, treating as success");
//           }
//         }
//       } else {
//         _errorMessage = '';
//         debugPrint("✅ Success: No response, treating as success");
//       }
//     } on DioException catch (e) {
//       _handleError(e);
//     } catch (e) {
//       _errorMessage = "An unexpected error occurred.";
//       debugPrint("General Error: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> vidalEnrollmentEcard(Map<String, dynamic> data) async {
//     _setLoading(true);
//     _errorMessage = '';
//     try {
//       debugPrint("=== VIDAL E-CARD API REQUEST ===");
//       debugPrint("Request Data: $data");

//       final response = await VerificationService.vidalEnrollmentEcard(data);
//       _response = response;

//       debugPrint("=== VIDAL E-CARD API RESPONSE ===");
//       debugPrint("Response: $response");
//       debugPrint("=== END VIDAL E-CARD API RESPONSE ===");

//       // Check if response contains success indicators
//       if (response != null) {
//         // Check for success status
//         bool hasSuccessStatus =
//             response.containsKey('status') && response['status'] == 'SUCCESS';

//         // Check for e-card data
//         bool hasEcardData =
//             response.containsKey('data') &&
//             response['data'] != null &&
//             response['data'] is List &&
//             (response['data'] as List).isNotEmpty;

//         if (hasSuccessStatus && hasEcardData) {
//           _errorMessage = '';
//           debugPrint("✅ Success: E-Card API call successful");
//         } else if (response.containsKey('message')) {
//           _errorMessage = response['message'];
//           debugPrint("⚠️ API returned message: ${response['message']}");
//         } else {
//           _errorMessage = "Failed to retrieve E-Card data";
//           debugPrint("❌ No valid E-Card data found in response");
//         }
//       } else {
//         _errorMessage = "No response received from server";
//         debugPrint("❌ No response received");
//       }
//     } on DioException catch (e) {
//       _handleError(e);
//     } catch (e) {
//       _errorMessage = "An unexpected error occurred.";
//       debugPrint("General Error: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Map<String, dynamic> _datesDetails = {};
//   bool _isDatesDetailsLoading = true;

//   Map<String, dynamic> get datesDetails => _datesDetails;
//   bool get isDatesDetailsLoading => _isDatesDetailsLoading;

//   Future<void> getDatesDetails(String nrkId) async {
//     try {
//       _isDatesDetailsLoading = true;
//       notifyListeners();
//       final response = await VerificationService.getDatesDetails(nrkId);
//       print('>>>>>>>>$response');
//       _datesDetails = response ?? {};
//     } catch (e) {
//       debugPrint('Error fetching dates details: $e');
//       // Handle 404 errors gracefully - no dates data available yet
//       if (e is DioException && e.response?.statusCode == 404) {
//         debugPrint(
//           'No dates information found for NRK ID: $nrkId - this is normal for new users',
//         );
//         _datesDetails = {}; // Set empty data instead of showing error
//       }
//     } finally {
//       _isDatesDetailsLoading = false;
//       notifyListeners();
//     }
//   }

//   Map<String, dynamic> _premiumAmount = {};
//   bool _isPremiumAmountLoading = true;

//   Map<String, dynamic> get premiumAmount => _premiumAmount;
//   bool get isPremiumAmountLoading => _isPremiumAmountLoading;

//   Future<void> getPremiumAmount(String nrkId) async {
//     try {
//       _isPremiumAmountLoading = true;
//       notifyListeners();
//       final response = await VerificationService.getPremiumAmount(nrkId);
//       print('>>>>>>>>$response');
//       _premiumAmount = response ?? {};
//     } catch (e) {
//       debugPrint('Error fetching premium amount: $e');
//       // Handle 404 errors gracefully - no premium data available yet
//       if (e is DioException && e.response?.statusCode == 404) {
//         debugPrint(
//           'No premium information found for NRK ID: $nrkId - this is normal for new users',
//         );
//         _premiumAmount = {}; // Set empty data instead of showing error
//       }
//     } finally {
//       _isPremiumAmountLoading = false;
//       notifyListeners();
//     }
//   }

//   Map<String, dynamic> _paymentVerification = {};
//   bool _isPaymentVerificationLoading = false;

//   Map<String, dynamic> get paymentVerification => _paymentVerification;
//   bool get isPaymentVerificationLoading => _isPaymentVerificationLoading;

//   Future<void> verifyPayment(Map<String, dynamic> paymentData) async {
//     try {
//       debugPrint(
//         '=== VERIFICATION PROVIDER: Starting payment verification ===',
//       );
//       debugPrint('Payment data: $paymentData');

//       _isPaymentVerificationLoading = true;
//       notifyListeners();

//       final response = await VerificationService.verifyPayment(paymentData);

//       debugPrint('=== VERIFICATION PROVIDER: Service response ===');
//       debugPrint('Response: $response');
//       debugPrint('=== END VERIFICATION PROVIDER ===');

//       _paymentVerification = response ?? {};
//     } catch (e) {
//       debugPrint('=== VERIFICATION PROVIDER ERROR ===');
//       debugPrint('Error verifying payment: $e');
//       debugPrint('Error type: ${e.runtimeType}');
//       debugPrint('=== END VERIFICATION PROVIDER ERROR ===');
//       _paymentVerification = {'error': e.toString()};
//     } finally {
//       _isPaymentVerificationLoading = false;
//       notifyListeners();
//     }
//   }

//   Map<String, dynamic> _paymentHistory = {};
//   bool _isPaymentHistoryLoading = true;
//   bool _hasPaymentHistoryLoadedOnce = false;

//   Map<String, dynamic> get paymentHistory => _paymentHistory;
//   bool get isPaymentHistoryLoading => _isPaymentHistoryLoading;
//   bool get hasPaymentHistoryLoadedOnce => _hasPaymentHistoryLoadedOnce;

//   Future<void> getPaymentHistory(String nrkId) async {
//     try {
//       debugPrint('=== PAYMENT HISTORY API REQUEST ===');
//       debugPrint('NRK ID: $nrkId');
//       _isPaymentHistoryLoading = true;
//       notifyListeners();
//       final response = await VerificationService.getPaymentHistory(nrkId);
//       debugPrint('=== PAYMENT HISTORY API RESPONSE ===');
//       debugPrint('Response: $response');
//       _paymentHistory = response ?? {};
//       _hasPaymentHistoryLoadedOnce = true;
//       debugPrint('=== PAYMENT HISTORY LOADED ONCE SET TO TRUE ===');
//     } catch (e) {
//       debugPrint('Error fetching payment history: $e');
//     } finally {
//       _isPaymentHistoryLoading = false;
//       debugPrint('=== PAYMENT HISTORY LOADING SET TO FALSE ===');
//       notifyListeners();
//     }
//   }
// }



// policy will start november 1 2025

// call - 18002022501
// whatsapp- 09364084960



// @add_family_members.dart give conditions for adding family member ages

// spouse age>=18 and age<=70,
// child age<=25


// and the self age maximum 70 ...in case self user age morethan 70 then not able to continue click...and also show all ages
 


//  payment success page/payment success page.dart

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
//                     // Download E-Card Button - Disabled during enrollment processing
//                     CustomButton(
//                       text: _isEnrolling
//                           ? 'Generating your E-card...'
//                           : 'Download E-Card',
//                       onPressed: _isEnrolling ? () {} : _handleViewECard,
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
//         // 'employeeCode': employeeCode,
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
//         // ToastMessage.successToast('Opening E-Card...');
        
//         try {
//           final Uri uri = Uri.parse(eCardUrl);
//           final canLaunch = await canLaunchUrl(uri);
          
//           if (canLaunch) {
//             await launchUrl(uri);
//             ToastMessage.successToast('E-Card opened successfully!');
//           } else {
//             ToastMessage.failedToast('Cannot open E-Card');
//           }
//         } catch (e) {
//           ToastMessage.failedToast('Error opening E-Card: $e');
//         }
//       } else {
//         ToastMessage.failedToast('No E-Card  found');
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
//         await verificationProvider.getEnrollmentDetailsWithOfflineFallback(nrkId);
        
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
//       await verificationProvider.getFamilyMembersWithOfflineFallback(nrkId);
//       debugPrint(
//         'Family Members after fetch: ${verificationProvider.familyMembersDetails}',
//       );

//       // Get dates details for Vidal enrollment
//       await verificationProvider.getDatesDetailsWithOfflineFallback(nrkId);
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


// family details confirm page



// import 'dart:convert';
// import 'package:norkacare_app/utils/vidal_utils.dart';
// import 'package:intl/intl.dart';

// class VidalDataMapper {
//   /// Build Vidal enrollment payload from available data
//   static Map<String, dynamic> buildVidalEnrollmentPayload({
//     required Map<String, dynamic> norkaResponse,
//     required Map<String, dynamic> enrollmentDetails,
//     required Map<String, dynamic> familyMembersDetails,
//     required String emailId,
//     required String nrkId,
//     String? requestId,
//     Map<String, dynamic>? datesDetails,
//   }) {
//     try {
//       print('=== Vidal Data Mapper Debug ===');
//       print('NORKA Response: $norkaResponse');
//       print('Enrollment Details: $enrollmentDetails');
//       print('Family Members Details: $familyMembersDetails');

//       // Extract data from NORKA response
//       final employeeName = norkaResponse['name'] ?? '';

//       // Mobile number extraction removed as per requirement
      
//       // Enhanced NRK ID extraction logic for Create Enroll API
//       final extractedNrkId = norkaResponse['norka_id'] ?? 
//                             norkaResponse['nrk_id'] ?? 
//                             norkaResponse['nrk_id_no'] ?? 
//                             familyMembersDetails['nrk_id_no'] ?? 
//                             nrkId; // Fallback to passed parameter
      
//       print('=== Create Enroll NRK ID Debug ===');
//       print('Passed NRK ID: $nrkId');
//       print('norkaResponse[norka_id]: ${norkaResponse['norka_id']}');
//       print('norkaResponse[nrk_id]: ${norkaResponse['nrk_id']}');
//       print('norkaResponse[nrk_id_no]: ${norkaResponse['nrk_id_no']}');
//       print('familyMembersDetails[nrk_id_no]: ${familyMembersDetails['nrk_id_no']}');
//       print('Final Extracted NRK ID: $extractedNrkId');
//       print('NORKA Response keys: ${norkaResponse.keys.toList()}');
//       print('Family Members Details keys: ${familyMembersDetails.keys.toList()}');
//       print('=== End Create Enroll NRK ID Debug ===');

//       // Extract address from address object
//       String address = '1st Floor, Tower B, Building No 8';
//       if (norkaResponse['address'] != null && norkaResponse['address'] is Map) {
//         final addressObj = norkaResponse['address'] as Map<String, dynamic>;
//         address = addressObj['address'] ?? address;
//       }

//       // Extract pincode from address object
//       String pincode = '';
//       if (norkaResponse['address'] != null && norkaResponse['address'] is Map) {
//         final addressObj = norkaResponse['address'] as Map<String, dynamic>;
//         pincode = addressObj['pincode']?.toString() ?? '';
//       }

//       // Extract enrollment data
//       final enrollmentData = enrollmentDetails['data'];
//       final selfEnrollmentNumber =
//           enrollmentData?['self_enrollment_number'] ?? '';
//       final spouseEnrollmentNumber =
//           enrollmentData?['spouse_enrollment_number'] ?? '';
//       final child1EnrollmentNumber =
//           enrollmentData?['child1_enrollment_number'] ?? '';
//       final child2EnrollmentNumber =
//           enrollmentData?['child2_enrollment_number'] ?? '';
//       final child3EnrollmentNumber =
//           enrollmentData?['child3_enrollment_number'] ?? '';
//       final child4EnrollmentNumber =
//           enrollmentData?['child4_enrollment_number'] ?? '';
//       final child5EnrollmentNumber =
//           enrollmentData?['child5_enrollment_number'] ?? '';

//       // Debug enrollment numbers
//       print('=== Enrollment Numbers Debug ===');
//       print('Self Enrollment Number: $selfEnrollmentNumber');
//       print('Spouse Enrollment Number: $spouseEnrollmentNumber');
//       print('Child1 Enrollment Number: $child1EnrollmentNumber');
//       print('Child2 Enrollment Number: $child2EnrollmentNumber');
//       print('Child3 Enrollment Number: $child3EnrollmentNumber');
//       print('Child4 Enrollment Number: $child4EnrollmentNumber');
//       print('Child5 Enrollment Number: $child5EnrollmentNumber');
//       print('=== End Enrollment Numbers Debug ===');
      
//       // Validate that we have at least self enrollment number
//       if (selfEnrollmentNumber.isEmpty) {
//         print('❌ WARNING: Self enrollment number is empty!');
//         print('❌ This may cause Vidal create enroll API to fail');
//       }

//       // Extract family members data
//       // Note: The family members API returns the data directly, not nested under 'data'
//       final familyMembers = familyMembersDetails.isNotEmpty
//           ? [familyMembersDetails]
//           : [];

//       // Debug family members structure
//       print('=== Family Members Structure Debug ===');
//       print('Family Members Details: $familyMembersDetails');
//       print('Family Members List: $familyMembers');
//       print('=== End Family Members Structure Debug ===');

//       // Extract dates from datesDetails API response
//       String dateOfJoining = "01/11/2025";
//       String dateOfInception = "01/11/2025";
//       String dateOfExit = "31/10/2026";

//       if (datesDetails != null && datesDetails.isNotEmpty) {
//         dateOfJoining = _formatDateForVidal(
//           datesDetails['date_of_joining'] ?? "01/11/2025",
//         );
//         dateOfInception = _formatDateForVidal(
//           datesDetails['date_of_inception'] ?? "01/11/2025",
//         );
//         dateOfExit = _formatDateForVidal(
//           datesDetails['date_of_exit'] ?? "31/10/2026",
//         );

//         print('=== Dates Details Debug ===');
//         print('Date of Joining: $dateOfJoining');
//         print('Date of Inception: $dateOfInception');
//         print('Date of Exit: $dateOfExit');
//         print('=== End Dates Details Debug ===');
//       }

//       // Build dependent info array
//       List<Map<String, dynamic>> dependentInfo = [];

//       // Add self
//       if (selfEnrollmentNumber.isNotEmpty) {
//         // Convert date format from MM-dd-yyyy to dd/MM/yyyy for Vidal
//         String dob = '01/01/1990';
//         String vidalDob = '01/01/1990';
//         print('=== SELF DOB DEBUG ===');
//         print('NORKA date_of_birth: ${norkaResponse['date_of_birth']}');
//         if (norkaResponse['date_of_birth'] != null) {
//           dob = norkaResponse['date_of_birth'].toString();
//           print('Original DOB: $dob');
//           // Convert from MM-dd-yyyy to dd/MM/yyyy
//           try {
//             final parts = dob.split('/');
//             print('Split parts: $parts');
//             print('Parts length: ${parts.length}');
//             if (parts.length == 3) {
//               vidalDob = '${parts[1]}/${parts[0]}/${parts[2]}';
//               print('Converted Vidal DOB: $vidalDob');
//             } else {
//               print('Parts length not 3, using original: $dob');
//             }
//           } catch (e) {
//             print('Error in DOB conversion: $e');
//             vidalDob = dob;
//           }
//         } else {
//           print('NORKA date_of_birth is null');
//         }
//         print('Final Vidal DOB: $vidalDob');
//         print('=== END SELF DOB DEBUG ===');

//         dependentInfo.add({
//           "cardholder_name": employeeName,
//           "depedent_unique_id": selfEnrollmentNumber,
//           "date_of_inception": dateOfInception,
//           "age": VidalUtils.calculateAge(vidalDob),
//           // "date_of_exit": dateOfExit,
//           "date_of_exit": "",
//           "dob": vidalDob,
//           "gender": _mapGender(norkaResponse['gender'] ?? 'Male'),
//           "sum_insured": "500000",
//           "vidal_tpa_id": "",
//           "risk_id": "",
//           "relation": "Self",
//         });
//       }

//       // Add spouse if available
//       print('=== Adding Spouse ===');
//       print('Spouse Enrollment Number: $spouseEnrollmentNumber');
//       print('Is Empty: ${spouseEnrollmentNumber.isEmpty}');

//       if (spouseEnrollmentNumber.isNotEmpty) {
//         // Extract spouse data from family members details
//         final spouseName = familyMembersDetails['spouse_name'] ?? 'SPOUSE';
//         final spouseDob = familyMembersDetails['spouse_dob'] ?? '01/01/1990';
//         final spouseGender = familyMembersDetails['spouse_gender'] ?? 'Female';

//         print('Spouse Name: $spouseName');
//         print('Spouse DOB: $spouseDob');
//         print('Spouse Gender: $spouseGender');

//         // Convert date format from MM-dd-yyyy to dd/MM/yyyy for Vidal
//         String vidalSpouseDob = spouseDob;
//         try {
//           if (spouseDob.contains('-')) {
//             final parts = spouseDob.split('-');
//             if (parts.length == 3) {
//               vidalSpouseDob = '${parts[1]}/${parts[0]}/${parts[2]}';
//             }
//           }
//         } catch (e) {
//           vidalSpouseDob = spouseDob;
//         }

//         dependentInfo.add({
//           "cardholder_name": spouseName,
//           "depedent_unique_id": spouseEnrollmentNumber,
//           "date_of_inception": dateOfInception,
//           "age": VidalUtils.calculateAge(vidalSpouseDob),
//           // "date_of_exit": dateOfExit,
//           "date_of_exit": "",
//           "dob": vidalSpouseDob,
//           "gender": _mapGender(spouseGender),
//           "sum_insured": "500000",
//           "vidal_tpa_id": "",
//           "risk_id": "",
//           "relation": "Spouse",
//         });
//         print('Added spouse to dependent info');
//       } else {
//         print('Skipping spouse - no enrollment number');
//       }
//       print('=== End Adding Spouse ===');

//       // Add children if available
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child1EnrollmentNumber,
//         'child1',
//         'Child',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child2EnrollmentNumber,
//         'child2',
//         'Child (2)',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child3EnrollmentNumber,
//         'child3',
//         'Child (3)',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child4EnrollmentNumber,
//         'child4',
//         'Child (4)',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child5EnrollmentNumber,
//         'child5',
//         'Child (5)',
//         dateOfInception,
//         dateOfExit,
//       );

//       // Build the complete payload
//       final finalRequestId = requestId ?? VidalUtils.generateRequestId();
//       print('=== Request ID Debug ===');
//       print('Using request ID: $finalRequestId');
//       print(
//         'Source: ${requestId != null ? "From checkbox API" : "Generated new"}',
//       );

//       final payload = {
//         "request_id": finalRequestId,
//         "corporate_name": "NORKA ROOTS",
//         "corporate_id": "N0626", // "N0626",
//         "employeeinfo": {
//           "pincode": pincode,
//           "address": address,
//           "date_of_joining": dateOfJoining,
//           "employee_name": employeeName,
//           "email_id": emailId,
//           "employee_no": extractedNrkId,
//           "policyinfo": [
//             {
//               "benefit_name": "Base policy",
//               "entity_name": "N0626", // "N0626",
//               "policy_number": "763300/25-26/NORKACARE/001",
//               // "policy_number": "760100/NORKA ROOTS/BASE",
//               "si_type": "Floater",
//               "dependent_info": dependentInfo,
//             },
//           ],
//         },
//       };

//       print('=== Final Vidal Payload ===');
//       print('Payload Length: ${payload.toString().length} characters');
//       print('Dependent Info Count: ${dependentInfo.length}');

//       // Print each dependent separately for better visibility
//       for (int i = 0; i < dependentInfo.length; i++) {
//         print('Dependent $i: ${dependentInfo[i]}');
//       }

//       // Print full payload as formatted JSON
//       try {
//         final jsonString = JsonEncoder.withIndent('  ').convert(payload);
//         print('=== Full Payload as JSON ===');
//         print(jsonString);
//         print('=== End Full Payload ===');
//       } catch (e) {
//         print('Error formatting JSON: $e');
//         print('Raw payload: $payload');
//       }

//       print('=== End Vidal Payload ===');

//       return payload;
//     } catch (e) {
//       // Return a minimal payload with error logging
//       print('Error building Vidal payload: $e');
      
//       // Extract NRK ID for error fallback
//       final fallbackNrkId = norkaResponse['norka_id'] ?? 
//                            norkaResponse['nrk_id'] ?? 
//                            norkaResponse['nrk_id_no'] ?? 
//                            familyMembersDetails['nrk_id_no'] ?? 
//                            nrkId;
      
//       return {
//         "request_id": VidalUtils.generateRequestId(),
//         "corporate_name": "NORKA ROOTS",
//         "corporate_id": "N0626", // "N0626",
//         "employeeinfo": {
//           "pincode": "",
//           "address": "1st Floor, Tower B, Building No 8",
//           "date_of_joining": "01/11/2025",
//           "employee_name": "",
//           "email_id": emailId,
//           "employee_no": fallbackNrkId,
//           "policyinfo": [],
//         },
//       };
//     }
//   }

//   /// Add child to dependent info if enrollment number is available
//   static void _addChildIfAvailable(
//     List<Map<String, dynamic>> dependentInfo,
//     List familyMembers,
//     String enrollmentNumber,
//     String relation,
//     String defaultName,
//     String dateOfInception,
//     String dateOfExit,
//   ) {
//     print('=== Adding $relation ===');
//     print('Enrollment Number: $enrollmentNumber');
//     print('Is Empty: ${enrollmentNumber.isEmpty}');

//     if (enrollmentNumber.isNotEmpty) {
//       // Extract child data from family members details based on relation
//       Map<String, dynamic> familyMembersDetails = familyMembers.isNotEmpty
//           ? familyMembers[0]
//           : {};

//       String childName = '';
//       String childDob = '';
//       String childGender = '';
//       String childRelation = '';

//       if (relation == 'child1') {
//         childName = familyMembersDetails['kid_1_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_1_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 1);
//         childRelation = 'Child';
//       } else if (relation == 'child2') {
//         childName = familyMembersDetails['kid_2_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_2_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 2);
//         childRelation = 'Child (2)';
//       } else if (relation == 'child3') {
//         childName = familyMembersDetails['kid_3_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_3_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 3);
//         childRelation = 'Child (3)';
//       } else if (relation == 'child4') {
//         childName = familyMembersDetails['kid_4_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_4_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 4);
//         childRelation = 'Child (4)';
//       } else if (relation == 'child5') {
//         childName = familyMembersDetails['kid_5_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_5_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 5);
//         childRelation = 'Child (5)';
//       }

//       print('Child Name: $childName');
//       print('Child DOB: $childDob');
//       print('Child Gender: $childGender');
//       print('Child Relation: $childRelation');

//       // Convert date format from MM-dd-yyyy to dd/MM/yyyy for Vidal
//       String vidalChildDob = childDob;
//       try {
//         if (childDob.contains('-')) {
//           final parts = childDob.split('-');
//           if (parts.length == 3) {
//             vidalChildDob = '${parts[1]}/${parts[0]}/${parts[2]}';
//           }
//         }
//       } catch (e) {
//         vidalChildDob = childDob;
//       }

//       dependentInfo.add({
//         "cardholder_name": childName,
//         "depedent_unique_id": enrollmentNumber,
//         "date_of_inception": dateOfInception,
//         "age": VidalUtils.calculateAge(vidalChildDob),
//         // "date_of_exit": dateOfExit,
//         "date_of_exit": "",
//         "dob": vidalChildDob,
//         "gender": _mapGender(childGender),
//         "sum_insured": "500000",
//         "vidal_tpa_id": "",
//         "risk_id": "",
//         "relation": childRelation,
//       });
//       print('Added $relation to dependent info');
//     } else {
//       print('Skipping $relation - no enrollment number');
//     }
//     print('=== End Adding $relation ===');
//   }

//   /// Map gender values to expected format
//   static String _mapGender(String gender) {
//     final lowerGender = gender.toLowerCase();
//     if (lowerGender.contains('male') || lowerGender.contains('m')) {
//       return 'Male';
//     } else if (lowerGender.contains('female') || lowerGender.contains('f')) {
//       return 'Female';
//     }
//     return 'Male'; // Default fallback
//   }

//   /// Build Vidal enrollment validation payload from available data
//   static Map<String, dynamic> buildVidalValidationPayload({
//     required Map<String, dynamic> norkaResponse,
//     required Map<String, dynamic> familyMembersDetails,
//     required String requestId,
//     required String selfUniqueId,
//     Map<String, dynamic>? datesDetails,
//   }) {
//     try {
//       print('=== Vidal Validation Data Mapper Debug ===');
//       print('NORKA Response: $norkaResponse');
//       print('Family Members Details: $familyMembersDetails');
//       print('Request ID: $requestId');
//       print('Self Unique ID: $selfUniqueId');

//       // Extract dates from datesDetails API response
//       String dateOfJoining = "01/11/2025";
//       String dateOfInception = "01/11/2025";
//       String dateOfExit = "31/10/2026";

//       if (datesDetails != null && datesDetails.isNotEmpty) {
//         dateOfJoining = _formatDateForVidal(
//           datesDetails['date_of_joining'] ?? "01/11/2025",
//         );
//         dateOfInception = _formatDateForVidal(
//           datesDetails['date_of_inception'] ?? "01/11/2025",
//         );
//         dateOfExit = _formatDateForVidal(
//           datesDetails['date_of_exit'] ?? "31/10/2026",
//         );

//         print('=== Validation Dates Details Debug ===');
//         print('Date of Joining: $dateOfJoining');
//         print('Date of Inception: $dateOfInception');
//         print('Date of Exit: $dateOfExit');
//         print('=== End Validation Dates Details Debug ===');
//       }

//       // Extract data from NORKA response
//       final employeeName = norkaResponse['name'] ?? '';
//       final emailId = norkaResponse['emails']?[0]?['address'] ?? '';
//       // Mobile number extraction removed as per requirement
//       final nrkId = norkaResponse['norka_id'] ?? 
//                    norkaResponse['nrk_id'] ?? 
//                    norkaResponse['nrk_id_no'] ?? 
//                    familyMembersDetails['nrk_id_no'] ?? '';
//       final address = norkaResponse['address']?['address'] ?? '';
//       final pincode = norkaResponse['address']?['pincode'] ?? '';

//       print('=== NRK ID Extraction Debug ===');
//       print('norkaResponse[norka_id]: ${norkaResponse['norka_id']}');
//       print('norkaResponse[nrk_id]: ${norkaResponse['nrk_id']}');
//       print('norkaResponse[nrk_id_no]: ${norkaResponse['nrk_id_no']}');
//       print('familyMembersDetails[nrk_id_no]: ${familyMembersDetails['nrk_id_no']}');
//       print('Final NRK ID: $nrkId');
//       print('=== End NRK ID Extraction Debug ===');

//       // Build dependent info list
//       List<Map<String, dynamic>> dependentInfo = [];

//       // Add Self
//       final selfDob = norkaResponse['date_of_birth'] ?? '';
//       final selfGender = norkaResponse['gender'] ?? '';
//       if (selfDob.isNotEmpty && selfUniqueId.isNotEmpty) {
//         dependentInfo.add(
//           _buildDependentInfo(
//             cardholderName: employeeName,
//             dependentUniqueId: selfUniqueId,
//             dob: selfDob,
//             gender: selfGender,
//             relation: 'Self',
//             dateOfInception: dateOfInception,
//             dateOfExit: dateOfExit,
//           ),
//         );
//       }

//       // Add Spouse
//       final spouseName = familyMembersDetails['spouse_name'] ?? '';
//       final spouseDob = familyMembersDetails['spouse_dob'] ?? '';
//       final spouseGender = familyMembersDetails['spouse_gender'] ?? '';
//       final spouseUniqueId = familyMembersDetails['spouse_unique_id'] ?? '';
//       if (spouseName.isNotEmpty &&
//           spouseDob.isNotEmpty &&
//           spouseUniqueId.isNotEmpty) {
//         dependentInfo.add(
//           _buildDependentInfo(
//             cardholderName: spouseName,
//             dependentUniqueId: spouseUniqueId,
//             dob: spouseDob,
//             gender: spouseGender,
//             relation: 'Spouse',
//             dateOfInception: dateOfInception,
//             dateOfExit: dateOfExit,
//           ),
//         );
//       }

//       // Add Children (maximum 5)
//       for (int i = 1; i <= 5; i++) {
//         final childName = familyMembersDetails['kid_${i}_name'] ?? '';
//         final childDob = familyMembersDetails['kid_${i}_dob'] ?? '';
//         final childGender = _getChildGender(familyMembersDetails, i);
//         final childUniqueId = familyMembersDetails['kid_${i}_unique_id'] ?? '';
//         if (childName.isNotEmpty &&
//             childDob.isNotEmpty &&
//             childUniqueId.isNotEmpty) {
//           // Determine child relation based on index
//           String childRelation = i == 1 ? 'Child' : 'Child ($i)';
          
//           dependentInfo.add(
//             _buildDependentInfo(
//               cardholderName: childName,
//               dependentUniqueId: childUniqueId,
//               dob: childDob,
//               gender: childGender,
//               relation: childRelation,
//               dateOfInception: dateOfInception,
//               dateOfExit: dateOfExit,
//             ),
//           );
//         }
//       }

//       // Build the complete payload
//       final payload = {
//         "request_id": requestId,
//         "corporate_name": "NORKA ROOTS",
//         "corporate_id": "N0626", // "N0386",
//         "employeeinfo": {
//           "pincode": pincode,
//           "address": address,
//           "date_of_joining": dateOfJoining,
//           "employee_name": employeeName,
//           "email_id": emailId,
//           "employee_no": nrkId,
//           "policyinfo": [
//             {
//               "benefit_name": "Base policy",
//               "entity_name": "N0626", // "N0626",
//               "policy_number": "763300/25-26/NORKACARE/001",
//               "si_type": "Floater",
//               "dependent_info": dependentInfo,
//             },
//           ],
//         },
//       };

//       print('=== Vidal Validation Payload Built ===');
//       print('Payload: $payload');
//       return payload;
//     } catch (e) {
//       print('Error building Vidal validation payload: $e');
//       rethrow;
//     }
//   }

//   /// Build dependent info for validation payload
//   static Map<String, dynamic> _buildDependentInfo({
//     required String cardholderName,
//     required String dependentUniqueId,
//     required String dob,
//     required String gender,
//     required String relation,
//     required String dateOfInception,
//     required String dateOfExit,
//   }) {
//     // Calculate age from DOB
//     int age = _calculateAge(dob);

//     // Format DOB to DD/MM/YYYY
//     String formattedDob = _formatDobForVidal(dob);

//     return {
//       "cardholder_name": cardholderName,
//       "depedent_unique_id": dependentUniqueId,
//       "date_of_inception": dateOfInception,
//       "age": age,
//       // "date_of_exit": dateOfExit,
//       "date_of_exit": "",
//       "dob": formattedDob,
//       "gender": _mapGender(gender),
//       "sum_insured": "500000",
//       "vidal_tpa_id": "",
//       "risk_id": "",
//       "relation": relation,
//     };
//   }

//   /// Calculate age from date of birth
//   static int _calculateAge(String dob) {
//     try {
//       DateTime? birthDate;

//       // Try different date formats
//       if (dob.contains('/')) {
//         List<String> parts = dob.split('/');
//         if (parts.length == 3) {
//           // Handle MM/DD/YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       } else if (dob.contains('-')) {
//         List<String> parts = dob.split('-');
//         if (parts.length == 3) {
//           // Handle MM-DD-YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       }

//       if (birthDate != null) {
//         DateTime now = DateTime.now();
//         int age = now.year - birthDate.year;
//         if (now.month < birthDate.month ||
//             (now.month == birthDate.month && now.day < birthDate.day)) {
//           age--;
//         }
//         return age;
//       }
//     } catch (e) {
//       print('Error calculating age: $e');
//     }
//     return 0; // Default age if calculation fails
//   }

//   /// Format DOB for Vidal API (DD/MM/YYYY)
//   static String _formatDobForVidal(String dob) {
//     try {
//       DateTime? birthDate;

//       // Try different date formats
//       if (dob.contains('/')) {
//         List<String> parts = dob.split('/');
//         if (parts.length == 3) {
//           // Handle MM/DD/YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       } else if (dob.contains('-')) {
//         List<String> parts = dob.split('-');
//         if (parts.length == 3) {
//           // Handle MM-DD-YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       }

//       if (birthDate != null) {
//         return DateFormat('dd/MM/yyyy').format(birthDate);
//       }
//     } catch (e) {
//       print('Error formatting DOB: $e');
//     }
//     return dob; // Return original if formatting fails
//   }

//   /// Format date from API response (MM-dd-yyyy) to Vidal format (dd/MM/yyyy)
//   static String _formatDateForVidal(String dateString) {
//     try {
//       if (dateString.isEmpty) {
//         return "01/11/2025"; // Default fallback
//       }

//       // Handle MM-dd-yyyy format from API
//       if (dateString.contains('-')) {
//         final parts = dateString.split('-');
//         if (parts.length == 3) {
//           final month = parts[0].padLeft(2, '0');
//           final day = parts[1].padLeft(2, '0');
//           final year = parts[2];
//           return '$day/$month/$year'; // Convert to dd/MM/yyyy
//         }
//       }

//       // Handle MM/dd/yyyy format
//       if (dateString.contains('/')) {
//         final parts = dateString.split('/');
//         if (parts.length == 3) {
//           final month = parts[0].padLeft(2, '0');
//           final day = parts[1].padLeft(2, '0');
//           final year = parts[2];
//           return '$day/$month/$year'; // Convert to dd/MM/yyyy
//         }
//       }

//       return dateString; // Return original if can't parse
//     } catch (e) {
//       print('Error formatting date for Vidal: $e');
//       return "01/11/2025"; // Default fallback
//     }
//   }

//   static String _getChildGender(Map<String, dynamic> familyMembersDetails, int childIndex) {
//     // Get the relation field (Son/Daughter) and convert to gender (Male/Female)
//     String relation = familyMembersDetails['kid_${childIndex}_relation'] ?? '';
//     String gender = '';
    
//     if (relation.toLowerCase() == 'son') {
//       gender = 'Male';
//     } else if (relation.toLowerCase() == 'daughter') {
//       gender = 'Female';
//     }
    
//     return gender.isEmpty ? 'Male' : gender; // Default to Male if relation is not found
//   }
// }







// import 'dart:convert';
// import 'package:norkacare_app/utils/vidal_utils.dart';
// import 'package:intl/intl.dart';

// class VidalDataMapper {
//   /// Build Vidal enrollment payload from available data
//   static Map<String, dynamic> buildVidalEnrollmentPayload({
//     required Map<String, dynamic> norkaResponse,
//     required Map<String, dynamic> enrollmentDetails,
//     required Map<String, dynamic> familyMembersDetails,
//     required String emailId,
//     required String nrkId,
//     String? requestId,
//     Map<String, dynamic>? datesDetails,
//   }) {
//     try {
//       print('=== Vidal Data Mapper Debug ===');
//       print('NORKA Response: $norkaResponse');
//       print('Enrollment Details: $enrollmentDetails');
//       print('Family Members Details: $familyMembersDetails');

//       // Extract data from Family API (primary source) and NORKA response (fallback)
//       final employeeName = familyMembersDetails['nrk_name'] ?? norkaResponse['name'] ?? '';

//       // Mobile number extraction removed as per requirement
      
//       // Enhanced NRK ID extraction logic for Create Enroll API
//       final extractedNrkId = norkaResponse['norka_id'] ?? 
//                             norkaResponse['nrk_id'] ?? 
//                             norkaResponse['nrk_id_no'] ?? 
//                             familyMembersDetails['nrk_id_no'] ?? 
//                             nrkId; // Fallback to passed parameter
      
//       print('=== Create Enroll NRK ID Debug ===');
//       print('Passed NRK ID: $nrkId');
//       print('norkaResponse[norka_id]: ${norkaResponse['norka_id']}');
//       print('norkaResponse[nrk_id]: ${norkaResponse['nrk_id']}');
//       print('norkaResponse[nrk_id_no]: ${norkaResponse['nrk_id_no']}');
//       print('familyMembersDetails[nrk_id_no]: ${familyMembersDetails['nrk_id_no']}');
//       print('Final Extracted NRK ID: $extractedNrkId');
//       print('NORKA Response keys: ${norkaResponse.keys.toList()}');
//       print('Family Members Details keys: ${familyMembersDetails.keys.toList()}');
//       print('=== End Create Enroll NRK ID Debug ===');

//       // Extract address from address object
//       String address = '1st Floor, Tower B, Building No 8';
//       if (norkaResponse['address'] != null && norkaResponse['address'] is Map) {
//         final addressObj = norkaResponse['address'] as Map<String, dynamic>;
//         address = addressObj['address'] ?? address;
//       }

//       // Extract pincode from address object
//       String pincode = '';
//       if (norkaResponse['address'] != null && norkaResponse['address'] is Map) {
//         final addressObj = norkaResponse['address'] as Map<String, dynamic>;
//         pincode = addressObj['pincode']?.toString() ?? '';
//       }

//       // Extract enrollment data
//       final enrollmentData = enrollmentDetails['data'];
//       final selfEnrollmentNumber =
//           enrollmentData?['self_enrollment_number'] ?? '';
//       final spouseEnrollmentNumber =
//           enrollmentData?['spouse_enrollment_number'] ?? '';
//       final child1EnrollmentNumber =
//           enrollmentData?['child1_enrollment_number'] ?? '';
//       final child2EnrollmentNumber =
//           enrollmentData?['child2_enrollment_number'] ?? '';
//       final child3EnrollmentNumber =
//           enrollmentData?['child3_enrollment_number'] ?? '';
//       final child4EnrollmentNumber =
//           enrollmentData?['child4_enrollment_number'] ?? '';
//       final child5EnrollmentNumber =
//           enrollmentData?['child5_enrollment_number'] ?? '';

//       // Debug enrollment numbers
//       print('=== Enrollment Numbers Debug ===');
//       print('Self Enrollment Number: $selfEnrollmentNumber');
//       print('Spouse Enrollment Number: $spouseEnrollmentNumber');
//       print('Child1 Enrollment Number: $child1EnrollmentNumber');
//       print('Child2 Enrollment Number: $child2EnrollmentNumber');
//       print('Child3 Enrollment Number: $child3EnrollmentNumber');
//       print('Child4 Enrollment Number: $child4EnrollmentNumber');
//       print('Child5 Enrollment Number: $child5EnrollmentNumber');
//       print('=== End Enrollment Numbers Debug ===');
      
//       // Validate that we have at least self enrollment number
//       if (selfEnrollmentNumber.isEmpty) {
//         print('❌ WARNING: Self enrollment number is empty!');
//         print('❌ This may cause Vidal create enroll API to fail');
//       }

//       // Extract family members data
//       // Note: The family members API returns the data directly, not nested under 'data'
//       final familyMembers = familyMembersDetails.isNotEmpty
//           ? [familyMembersDetails]
//           : [];

//       // Debug family members structure
//       print('=== Family Members Structure Debug ===');
//       print('Family Members Details: $familyMembersDetails');
//       print('Family Members List: $familyMembers');
//       print('=== End Family Members Structure Debug ===');

//       // Extract dates from datesDetails API response
//       String dateOfJoining = "01/11/2025";
//       String dateOfInception = "01/11/2025";
//       String dateOfExit = "31/10/2026";

//       if (datesDetails != null && datesDetails.isNotEmpty) {
//         dateOfJoining = _formatDateForVidal(
//           datesDetails['date_of_joining'] ?? "01/11/2025",
//         );
//         dateOfInception = _formatDateForVidal(
//           datesDetails['date_of_inception'] ?? "01/11/2025",
//         );
//         dateOfExit = _formatDateForVidal(
//           datesDetails['date_of_exit'] ?? "31/10/2026",
//         );

//         print('=== Dates Details Debug ===');
//         print('Date of Joining: $dateOfJoining');
//         print('Date of Inception: $dateOfInception');
//         print('Date of Exit: $dateOfExit');
//         print('=== End Dates Details Debug ===');
//       }

//       // Build dependent info array
//       List<Map<String, dynamic>> dependentInfo = [];

//       // Add self - Use Family API data for all self details
//       if (selfEnrollmentNumber.isNotEmpty) {
//         // Extract self data from family members details
//         final selfName = familyMembersDetails['nrk_name'] ?? employeeName;
//         final selfDob = familyMembersDetails['dob'] ?? '01/01/1990';
//         final selfGender = familyMembersDetails['gender'] ?? 'male';
        
//         print('=== Self Details from Family API ===');
//         print('Self Name: $selfName');
//         print('Self DOB (MM-DD-YYYY): $selfDob');
//         print('Self Gender: $selfGender');
        
//         // Convert date format from MM-DD-YYYY to DD/MM/YYYY for Vidal
//         String vidalSelfDob = selfDob;
//         try {
//           if (selfDob.contains('-')) {
//             final parts = selfDob.split('-');
//             if (parts.length == 3) {
//               vidalSelfDob = '${parts[1]}/${parts[0]}/${parts[2]}'; // MM-DD-YYYY → DD/MM/YYYY
//               print('Self DOB converted: $selfDob → $vidalSelfDob');
//             }
//           }
//         } catch (e) {
//           vidalSelfDob = selfDob;
//           print('Error converting self DOB: $e');
//         }
        
//         print('Mapped Self Gender: ${_mapGender(selfGender)}');
//         print('=== End Self Details from Family API ===');
        
//         dependentInfo.add({
//           "cardholder_name": selfName,
//           "depedent_unique_id": selfEnrollmentNumber,
//           "date_of_inception": dateOfInception,
//           "age": VidalUtils.calculateAge(vidalSelfDob),
//           "date_of_exit": "",
//           "dob": vidalSelfDob,
//           "gender": _mapGender(selfGender),
//           "sum_insured": "500000",
//           "vidal_tpa_id": "",
//           "risk_id": "",
//           "relation": "Self",
//         });
//       }

//       // Add spouse if available
//       print('=== Adding Spouse ===');
//       print('Spouse Enrollment Number: $spouseEnrollmentNumber');
//       print('Is Empty: ${spouseEnrollmentNumber.isEmpty}');

//       if (spouseEnrollmentNumber.isNotEmpty) {
//         // Extract spouse data from family members details
//         final spouseName = familyMembersDetails['spouse_name'] ?? 'SPOUSE';
//         final spouseDob = familyMembersDetails['spouse_dob'] ?? '01/01/1990';
//         final spouseGender = familyMembersDetails['spouse_gender'] ?? 'Female';

//         print('Spouse Name: $spouseName');
//         print('Spouse DOB: $spouseDob');
//         print('Spouse Gender: $spouseGender');
//         print('Mapped Spouse Gender: ${_mapGender(spouseGender)}');

//         // Convert date format from MM-DD-YYYY to DD/MM/YYYY for Vidal
//         String vidalSpouseDob = spouseDob;
//         try {
//           if (spouseDob.contains('-')) {
//             final parts = spouseDob.split('-');
//             if (parts.length == 3) {
//               vidalSpouseDob = '${parts[1]}/${parts[0]}/${parts[2]}'; // MM-DD-YYYY → DD/MM/YYYY
//               print('Spouse DOB converted: $spouseDob → $vidalSpouseDob');
//             }
//           }
//         } catch (e) {
//           vidalSpouseDob = spouseDob;
//           print('Error converting spouse DOB: $e');
//         }

//         dependentInfo.add({
//           "cardholder_name": spouseName,
//           "depedent_unique_id": spouseEnrollmentNumber,
//           "date_of_inception": dateOfInception,
//           "age": VidalUtils.calculateAge(vidalSpouseDob),
//           // "date_of_exit": dateOfExit,
//           "date_of_exit": "",
//           "dob": vidalSpouseDob,
//           "gender": _mapGender(spouseGender), // Map spouse gender from Family API format
//           "sum_insured": "500000",
//           "vidal_tpa_id": "",
//           "risk_id": "",
//           "relation": "Spouse",
//         });
//         print('Added spouse to dependent info');
//       } else {
//         print('Skipping spouse - no enrollment number');
//       }
//       print('=== End Adding Spouse ===');

//       // Add children if available
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child1EnrollmentNumber,
//         'child1',
//         'Child',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child2EnrollmentNumber,
//         'child2',
//         'Child (2)',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child3EnrollmentNumber,
//         'child3',
//         'Child (3)',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child4EnrollmentNumber,
//         'child4',
//         'Child (4)',
//         dateOfInception,
//         dateOfExit,
//       );
//       _addChildIfAvailable(
//         dependentInfo,
//         familyMembers,
//         child5EnrollmentNumber,
//         'child5',
//         'Child (5)',
//         dateOfInception,
//         dateOfExit,
//       );

//       // Build the complete payload
//       final finalRequestId = requestId ?? VidalUtils.generateRequestId();
//       print('=== Request ID Debug ===');
//       print('Using request ID: $finalRequestId');
//       print(
//         'Source: ${requestId != null ? "From checkbox API" : "Generated new"}',
//       );

//       final payload = {
//         "request_id": finalRequestId,
//         "corporate_name": "NORKA ROOTS",
//         "corporate_id": "N0626", // "N0626",
//         "employeeinfo": {
//           "pincode": pincode,
//           "address": address,
//           "date_of_joining": dateOfJoining,
//           "employee_name": employeeName,
//           "email_id": emailId,
//           "employee_no": extractedNrkId,
//           "policyinfo": [
//             {
//               "benefit_name": "Base policy",
//               "entity_name": "N0626", // "N0626",
//               "policy_number": "763300/25-26/NORKACARE/001",
//               // "policy_number": "760100/NORKA ROOTS/BASE",
//               "si_type": "Floater",
//               "dependent_info": dependentInfo,
//             },
//           ],
//         },
//       };

//       print('=== Final Vidal Payload ===');
//       print('Payload Length: ${payload.toString().length} characters');
//       print('Dependent Info Count: ${dependentInfo.length}');

//       // Print each dependent separately for better visibility
//       for (int i = 0; i < dependentInfo.length; i++) {
//         print('Dependent $i: ${dependentInfo[i]}');
//       }

//       // Print full payload as formatted JSON
//       try {
//         final jsonString = JsonEncoder.withIndent('  ').convert(payload);
//         print('=== Full Payload as JSON ===');
//         print(jsonString);
//         print('=== End Full Payload ===');
//       } catch (e) {
//         print('Error formatting JSON: $e');
//         print('Raw payload: $payload');
//       }

//       print('=== End Vidal Payload ===');

//       return payload;
//     } catch (e) {
//       // Return a minimal payload with error logging
//       print('Error building Vidal payload: $e');
      
//       // Extract NRK ID for error fallback
//       final fallbackNrkId = norkaResponse['norka_id'] ?? 
//                            norkaResponse['nrk_id'] ?? 
//                            norkaResponse['nrk_id_no'] ?? 
//                            familyMembersDetails['nrk_id_no'] ?? 
//                            nrkId;
      
//       return {
//         "request_id": VidalUtils.generateRequestId(),
//         "corporate_name": "NORKA ROOTS",
//         "corporate_id": "N0626", // "N0626",
//         "employeeinfo": {
//           "pincode": "",
//           "address": "1st Floor, Tower B, Building No 8",
//           "date_of_joining": "01/11/2025",
//           "employee_name": "",
//           "email_id": emailId,
//           "employee_no": fallbackNrkId,
//           "policyinfo": [],
//         },
//       };
//     }
//   }

//   /// Add child to dependent info if enrollment number is available
//   static void _addChildIfAvailable(
//     List<Map<String, dynamic>> dependentInfo,
//     List familyMembers,
//     String enrollmentNumber,
//     String relation,
//     String defaultName,
//     String dateOfInception,
//     String dateOfExit,
//   ) {
//     print('=== Adding $relation ===');
//     print('Enrollment Number: $enrollmentNumber');
//     print('Is Empty: ${enrollmentNumber.isEmpty}');

//     if (enrollmentNumber.isNotEmpty) {
//       // Extract child data from family members details based on relation
//       Map<String, dynamic> familyMembersDetails = familyMembers.isNotEmpty
//           ? familyMembers[0]
//           : {};

//       String childName = '';
//       String childDob = '';
//       String childGender = '';
//       String childRelation = '';

//       if (relation == 'child1') {
//         childName = familyMembersDetails['kid_1_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_1_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 1);
//         childRelation = 'Child';
//       } else if (relation == 'child2') {
//         childName = familyMembersDetails['kid_2_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_2_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 2);
//         childRelation = 'Child (2)';
//       } else if (relation == 'child3') {
//         childName = familyMembersDetails['kid_3_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_3_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 3);
//         childRelation = 'Child (3)';
//       } else if (relation == 'child4') {
//         childName = familyMembersDetails['kid_4_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_4_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 4);
//         childRelation = 'Child (4)';
//       } else if (relation == 'child5') {
//         childName = familyMembersDetails['kid_5_name'] ?? defaultName;
//         childDob = familyMembersDetails['kid_5_dob'] ?? '01/01/2016';
//         childGender = _getChildGender(familyMembersDetails, 5);
//         childRelation = 'Child (5)';
//       }

//       print('Child Name: $childName');
//       print('Child DOB: $childDob');
//       print('Child Gender: $childGender');
//       print('Child Relation: $childRelation');

//       // Convert date format from MM-DD-YYYY to DD/MM/YYYY for Vidal
//       String vidalChildDob = childDob;
//       try {
//         if (childDob.contains('-')) {
//           final parts = childDob.split('-');
//           if (parts.length == 3) {
//             vidalChildDob = '${parts[1]}/${parts[0]}/${parts[2]}'; // MM-DD-YYYY → DD/MM/YYYY
//             print('Child DOB converted: $childDob → $vidalChildDob');
//           }
//         }
//       } catch (e) {
//         vidalChildDob = childDob;
//         print('Error converting child DOB: $e');
//       }

//       dependentInfo.add({
//         "cardholder_name": childName,
//         "depedent_unique_id": enrollmentNumber,
//         "date_of_inception": dateOfInception,
//         "age": VidalUtils.calculateAge(vidalChildDob),
//         // "date_of_exit": dateOfExit,
//         "date_of_exit": "",
//         "dob": vidalChildDob,
//         "gender": childGender, // Use childGender directly without _mapGender
//         "sum_insured": "500000",
//         "vidal_tpa_id": "",
//         "risk_id": "",
//         "relation": childRelation,
//       });
//       print('Added $relation to dependent info');
//     } else {
//       print('Skipping $relation - no enrollment number');
//     }
//     print('=== End Adding $relation ===');
//   }

//   /// Map gender values to expected format
//   static String _mapGender(String gender) {
//     print('=== _mapGender Debug ===');
//     print('Input gender: "$gender"');
//     print('Input gender length: ${gender.length}');
//     print('Input gender bytes: ${gender.codeUnits}');
    
//     final lowerGender = gender.toLowerCase();
//     print('Lowercase gender: "$lowerGender"');
    
//     String result;
//     if (lowerGender.contains('female') || lowerGender.contains('f')) {
//       result = 'Female';
//     } else if (lowerGender.contains('male') || lowerGender.contains('m')) {
//       result = 'Male';
//     } else {
//       result = 'Male'; // Default fallback
//     }
    
//     print('Mapped result: "$result"');
//     print('=== End _mapGender Debug ===');
    
//     return result;
//   }

//   /// Build Vidal enrollment validation payload from available data
//   static Map<String, dynamic> buildVidalValidationPayload({
//     required Map<String, dynamic> norkaResponse,
//     required Map<String, dynamic> familyMembersDetails,
//     required String requestId,
//     required String selfUniqueId,
//     Map<String, dynamic>? datesDetails,
//   }) {
//     try {
//       print('=== Vidal Validation Data Mapper Debug ===');
//       print('NORKA Response: $norkaResponse');
//       print('Family Members Details: $familyMembersDetails');
//       print('Request ID: $requestId');
//       print('Self Unique ID: $selfUniqueId');

//       // Extract dates from datesDetails API response
//       String dateOfJoining = "01/11/2025";
//       String dateOfInception = "01/11/2025";
//       String dateOfExit = "31/10/2026";

//       if (datesDetails != null && datesDetails.isNotEmpty) {
//         dateOfJoining = _formatDateForVidal(
//           datesDetails['date_of_joining'] ?? "01/11/2025",
//         );
//         dateOfInception = _formatDateForVidal(
//           datesDetails['date_of_inception'] ?? "01/11/2025",
//         );
//         dateOfExit = _formatDateForVidal(
//           datesDetails['date_of_exit'] ?? "31/10/2026",
//         );

//         print('=== Validation Dates Details Debug ===');
//         print('Date of Joining: $dateOfJoining');
//         print('Date of Inception: $dateOfInception');
//         print('Date of Exit: $dateOfExit');
//         print('=== End Validation Dates Details Debug ===');
//       }

//       // Extract data from Family API (primary source) and NORKA response (fallback)
//       final employeeName = familyMembersDetails['nrk_name'] ?? norkaResponse['name'] ?? '';
//       final emailId = norkaResponse['emails']?[0]?['address'] ?? '';
//       // Mobile number extraction removed as per requirement
//       final nrkId = norkaResponse['norka_id'] ?? 
//                    norkaResponse['nrk_id'] ?? 
//                    norkaResponse['nrk_id_no'] ?? 
//                    familyMembersDetails['nrk_id_no'] ?? '';
//       final address = norkaResponse['address']?['address'] ?? '';
//       final pincode = norkaResponse['address']?['pincode'] ?? '';

//       print('=== NRK ID Extraction Debug ===');
//       print('norkaResponse[norka_id]: ${norkaResponse['norka_id']}');
//       print('norkaResponse[nrk_id]: ${norkaResponse['nrk_id']}');
//       print('norkaResponse[nrk_id_no]: ${norkaResponse['nrk_id_no']}');
//       print('familyMembersDetails[nrk_id_no]: ${familyMembersDetails['nrk_id_no']}');
//       print('Final NRK ID: $nrkId');
//       print('=== End NRK ID Extraction Debug ===');

//       // Build dependent info list
//       List<Map<String, dynamic>> dependentInfo = [];

//       // Add Self - Use Family API data for consistency with Create Enroll API
//       final selfDob = familyMembersDetails['dob'] ?? '';
//       final selfGender = familyMembersDetails['gender'] ?? '';
//       if (selfDob.isNotEmpty && selfUniqueId.isNotEmpty) {
//         print('=== Self Details from Family API (Validation) ===');
//         print('Self DOB (MM-DD-YYYY): $selfDob');
//         print('Self Gender: $selfGender');
//         print('Mapped self gender: "${_mapGender(selfGender)}"');
//         print('=== End Self Details from Family API (Validation) ===');
        
//         dependentInfo.add(
//           _buildDependentInfo(
//             cardholderName: employeeName,
//             dependentUniqueId: selfUniqueId,
//             dob: selfDob,
//             gender: _mapGender(selfGender), // Map gender before passing
//             relation: 'Self',
//             dateOfInception: dateOfInception,
//             dateOfExit: dateOfExit,
//           ),
//         );
//       }

//       // Add Spouse
//       final spouseName = familyMembersDetails['spouse_name'] ?? '';
//       final spouseDob = familyMembersDetails['spouse_dob'] ?? '';
//       final spouseGender = familyMembersDetails['spouse_gender'] ?? '';
//       final spouseUniqueId = familyMembersDetails['spouse_unique_id'] ?? '';
//       if (spouseName.isNotEmpty &&
//           spouseDob.isNotEmpty &&
//           spouseUniqueId.isNotEmpty) {
//         print('=== Spouse Gender Debug ===');
//         print('Raw spouse gender: "$spouseGender"');
//         print('Mapped spouse gender: "${_mapGender(spouseGender)}"');
//         print('=== End Spouse Gender Debug ===');
        
//         dependentInfo.add(
//           _buildDependentInfo(
//             cardholderName: spouseName,
//             dependentUniqueId: spouseUniqueId,
//             dob: spouseDob,
//             gender: _mapGender(spouseGender), // Map gender before passing
//             relation: 'Spouse',
//             dateOfInception: dateOfInception,
//             dateOfExit: dateOfExit,
//           ),
//         );
//       }

//       // Add Children (maximum 5)
//       for (int i = 1; i <= 5; i++) {
//         final childName = familyMembersDetails['kid_${i}_name'] ?? '';
//         final childDob = familyMembersDetails['kid_${i}_dob'] ?? '';
//         final childGender = _getChildGender(familyMembersDetails, i);
//         final childUniqueId = familyMembersDetails['kid_${i}_unique_id'] ?? '';
//         if (childName.isNotEmpty &&
//             childDob.isNotEmpty &&
//             childUniqueId.isNotEmpty) {
//           // Determine child relation based on index
//           String childRelation = i == 1 ? 'Child' : 'Child ($i)';
          
//           dependentInfo.add(
//             _buildDependentInfo(
//               cardholderName: childName,
//               dependentUniqueId: childUniqueId,
//               dob: childDob,
//               gender: childGender,
//               relation: childRelation,
//               dateOfInception: dateOfInception,
//               dateOfExit: dateOfExit,
//             ),
//           );
//         }
//       }

//       // Build the complete payload
//       final payload = {
//         "request_id": requestId,
//         "corporate_name": "NORKA ROOTS",
//         "corporate_id": "N0626", // "N0626",
//         "employeeinfo": {
//           "pincode": pincode,
//           "address": address,
//           "date_of_joining": dateOfJoining,
//           "employee_name": employeeName,
//           "email_id": emailId,
//           "employee_no": nrkId,
//           "policyinfo": [
//             {
//               "benefit_name": "Base policy",
//               "entity_name": "N0626", // "N0626",
//               "policy_number": "763300/25-26/NORKACARE/001",
//               "si_type": "Floater",
//               "dependent_info": dependentInfo,
//             },
//           ],
//         },
//       };

//       print('=== Vidal Validation Payload Built ===');
//       print('Payload: $payload');
//       return payload;
//     } catch (e) {
//       print('Error building Vidal validation payload: $e');
//       rethrow;
//     }
//   }

//   /// Build dependent info for validation payload
//   static Map<String, dynamic> _buildDependentInfo({
//     required String cardholderName,
//     required String dependentUniqueId,
//     required String dob,
//     required String gender,
//     required String relation,
//     required String dateOfInception,
//     required String dateOfExit,
//   }) {
//     // Calculate age from DOB
//     int age = _calculateAge(dob);

//     // Format DOB to DD/MM/YYYY
//     String formattedDob = _formatDobForVidal(dob);

//     print('=== _buildDependentInfo Gender Debug ===');
//     print('Input gender: "$gender"');
//     print('Final gender: "$gender"');
//     print('=== End _buildDependentInfo Gender Debug ===');

//     return {
//       "cardholder_name": cardholderName,
//       "depedent_unique_id": dependentUniqueId,
//       "date_of_inception": dateOfInception,
//       "age": age,
//       // "date_of_exit": dateOfExit,
//       "date_of_exit": "",
//       "dob": formattedDob,
//       "gender": gender, // Use gender directly without _mapGender
//       "sum_insured": "500000",
//       "vidal_tpa_id": "",
//       "risk_id": "",
//       "relation": relation,
//     };
//   }

//   /// Calculate age from date of birth
//   static int _calculateAge(String dob) {
//     try {
//       DateTime? birthDate;

//       // Try different date formats
//       if (dob.contains('/')) {
//         List<String> parts = dob.split('/');
//         if (parts.length == 3) {
//           // Handle MM/DD/YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       } else if (dob.contains('-')) {
//         List<String> parts = dob.split('-');
//         if (parts.length == 3) {
//           // Handle MM-DD-YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       }

//       if (birthDate != null) {
//         DateTime now = DateTime.now();
//         int age = now.year - birthDate.year;
//         if (now.month < birthDate.month ||
//             (now.month == birthDate.month && now.day < birthDate.day)) {
//           age--;
//         }
//         return age;
//       }
//     } catch (e) {
//       print('Error calculating age: $e');
//     }
//     return 0; // Default age if calculation fails
//   }

//   /// Format DOB for Vidal API (DD/MM/YYYY)
//   static String _formatDobForVidal(String dob) {
//     try {
//       DateTime? birthDate;

//       // Try different date formats
//       if (dob.contains('/')) {
//         List<String> parts = dob.split('/');
//         if (parts.length == 3) {
//           // Handle MM/DD/YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       } else if (dob.contains('-')) {
//         List<String> parts = dob.split('-');
//         if (parts.length == 3) {
//           // Handle MM-DD-YYYY format
//           birthDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[0]),
//             int.parse(parts[1]),
//           );
//         }
//       }

//       if (birthDate != null) {
//         return DateFormat('dd/MM/yyyy').format(birthDate);
//       }
//     } catch (e) {
//       print('Error formatting DOB: $e');
//     }
//     return dob; // Return original if formatting fails
//   }

//   /// Format date from API response (MM-dd-yyyy) to Vidal format (dd/MM/yyyy)
//   static String _formatDateForVidal(String dateString) {
//     try {
//       if (dateString.isEmpty) {
//         return "01/11/2025"; // Default fallback
//       }

//       // Handle MM-dd-yyyy format from API
//       if (dateString.contains('-')) {
//         final parts = dateString.split('-');
//         if (parts.length == 3) {
//           final month = parts[0].padLeft(2, '0');
//           final day = parts[1].padLeft(2, '0');
//           final year = parts[2];
//           return '$day/$month/$year'; // Convert to dd/MM/yyyy
//         }
//       }

//       // Handle MM/dd/yyyy format
//       if (dateString.contains('/')) {
//         final parts = dateString.split('/');
//         if (parts.length == 3) {
//           final month = parts[0].padLeft(2, '0');
//           final day = parts[1].padLeft(2, '0');
//           final year = parts[2];
//           return '$day/$month/$year'; // Convert to dd/MM/yyyy
//         }
//       }

//       return dateString; // Return original if can't parse
//     } catch (e) {
//       print('Error formatting date for Vidal: $e');
//       return "01/11/2025"; // Default fallback
//     }
//   }

//   static String _getChildGender(Map<String, dynamic> familyMembersDetails, int childIndex) {
//     // Get the relation field (Son/Daughter) and convert to gender (Male/Female)
//     String relation = familyMembersDetails['kid_${childIndex}_relation'] ?? '';
//     String gender = '';
    
//     print('=== Child Gender Debug ===');
//     print('Child $childIndex relation: $relation');
    
//     if (relation.toLowerCase() == 'son') {
//       gender = 'Male';
//     } else if (relation.toLowerCase() == 'daughter') {
//       gender = 'Female';
//     }
    
//     print('Child $childIndex mapped gender: $gender');
//     print('=== End Child Gender Debug ===');
    
//     return gender.isEmpty ? 'Male' : gender; // Default to Male if relation is not found
//   }
// }





// 760100/NORKA ROOTS/BASE









// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:provider/provider.dart';
// import 'package:norkacare_app/provider/verification_provider.dart';
// import 'package:norkacare_app/provider/hospital_provider.dart';
// import 'package:norkacare_app/provider/claim_provider.dart';
// import 'package:norkacare_app/provider/norka_provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:dio/dio.dart';

// class FileClaimPage extends StatefulWidget {
//   const FileClaimPage({super.key});

//   @override
//   State<FileClaimPage> createState() => _FileClaimPageState();
// }

// class _FileClaimPageState extends State<FileClaimPage> {
//   final _formKey = GlobalKey<FormState>();
  
//   // Controllers
//   final TextEditingController patientNameController = TextEditingController();
//   final TextEditingController claimAmountController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
  
//   // Bank Account Details
//   final TextEditingController accountHolderNameController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController reEnterAccountNumberController = TextEditingController();
//   final TextEditingController ifscCodeController = TextEditingController();
//   final TextEditingController bankNameController = TextEditingController();
//   final TextEditingController branchNameController = TextEditingController();
  
//   // Focus nodes for account number fields
//   final FocusNode accountNumberFocusNode = FocusNode();
//   final FocusNode reEnterAccountNumberFocusNode = FocusNode();
  
//   // State variables for account number masking
//   bool isAccountNumberFocused = false;
//   bool isReEnterAccountNumberFocused = false;
//   String actualAccountNumber = '';
//   String actualReEnterAccountNumber = '';
  
//   // State for hospital mismatch warning
//   bool showHospitalMismatchWarning = false;
//   String mainClaimHospitalName = '';
  
//   // Health Insurance Fields
//   final TextEditingController hospitalNameController = TextEditingController();
//   final TextEditingController hospitalPinCodeController = TextEditingController();
//   final TextEditingController hospitalAddressController = TextEditingController();
//   final TextEditingController hospitalMobileController = TextEditingController();
//   final TextEditingController hospitalEmailController = TextEditingController();
//   final TextEditingController doctorNameController = TextEditingController();
  
//   // Hospital Location Fields - Vidal API
//   String selectedStateId = '';
//   String selectedStateName = '';
//   String selectedCityId = '';
//   String selectedCityName = '';
//   Map<String, dynamic>? selectedHospital;
  
//   // Selected values
//   DateTime? selectedDate;
//   DateTime? admissionDate;
//   DateTime? dischargeDate;
//   String? selectedPatient;
//   String? selectedClaimType;
//   String? selectedMainHospitalizationClaim;
//   String? selectedAccountType;
  
//   // Claim logic state
//   bool isFirstTimeClaim = true; // Will be determined by API
//   List<Map<String, dynamic>> existingClaims = []; // Will be populated from API
  
//   List<String> uploadedDocuments = [];
//   String uploadedBankDocument = '';
//   Map<String, int> uploadedFilesWithSize = {}; // Track file sizes
//   PlatformFile? selectedBankFile; // Store the actual bank file
  
//   // New state for two-step upload process
//   PlatformFile? selectedFile; // Store selected file before upload
//   bool isFileUploaded = false; // Track if file is uploaded
//   String uploadedFileId = ''; // Store the file ID from upload response
  
//   // IFSC verification state
//   bool isVerifyingIfsc = false;
//   bool isIfscVerified = false;

 

//   // Get available claim types - Pre Post is always available
//   List<String> get availableClaimTypes {
//     debugPrint('=== CHECKING AVAILABLE CLAIM TYPES ===');
//     debugPrint('Selected Patient: $selectedPatient');
//     debugPrint('Total existing claims: ${existingClaims.length}');
    
//     // Always show all claim types including Pre Post Hospitalization
//     // The main hospitalization dropdown will be empty if patient has no claims
//     debugPrint('Showing all claim types including Pre Post Hospitalization');
//     return ['Hospitalization', 'Daycare', 'Pre Post Hospitalization'];
//   }


//   // Helper methods to check claim status
//   bool get hasAnyClaims => existingClaims.isNotEmpty;
  
//   bool get hasHospitalizationClaims => existingClaims.any((claim) => 
//     claim['claimType'] == 'Hospitalization' || 
//     claim['type'] == 'Hospitalization' ||
//     claim['claim_type'] == 'Hospitalization'
//   );
  
//   bool get hasDaycareClaims => existingClaims.any((claim) => 
//     claim['claimType'] == 'Daycare' || 
//     claim['type'] == 'Daycare' ||
//     claim['claim_type'] == 'Daycare'
//   );

//   // Get main hospitalization claims from existing claims for selected patient
//   List<Map<String, dynamic>> get mainHospitalizationClaims {
//     debugPrint('=== MAIN HOSPITALIZATION CLAIMS FOR SELECTED PATIENT ===');
//     debugPrint('Selected Patient: $selectedPatient');
//     debugPrint('Total existing claims: ${existingClaims.length}');
    
//     // If no patient selected, return empty list
//     if (selectedPatient == null || selectedPatient!.isEmpty) {
//       debugPrint('No patient selected - returning empty list');
//       return [];
//     }
    
//     // Filter claims for the selected patient
//     List<Map<String, dynamic>> patientClaims = existingClaims.where((claim) {
//       String claimantName = claim['claimantName'] ?? claim['name'] ?? '';
//       String claimNumber = (claim['claimNumber'] ?? claim['claimId'] ?? '').toString();
      
//       // Check if claim number is valid and claimant name matches
//       bool hasValidClaimNumber = claimNumber.isNotEmpty && claimNumber != 'null' && claimNumber != 'N/A';
//       bool nameMatches = claimantName.toLowerCase().contains(selectedPatient!.toLowerCase()) ||
//                          selectedPatient!.toLowerCase().contains(claimantName.toLowerCase());
      
//       return hasValidClaimNumber && nameMatches;
//     }).toList();
    
//     debugPrint('Patient claims found: ${patientClaims.length}');
    
//     // Format claims for display
//     List<Map<String, dynamic>> claims = patientClaims
//         .map((claim) {
//           // Try different possible field names for claim number and description
//           String claimNumber = claim['claimNumber'] ?? claim['claimId'] ?? claim['id'] ?? 'N/A';
//           String claimantName = claim['claimantName'] ?? claim['name'] ?? '';
//           String hospitalName = claim['hospName'] ?? claim['hospitalName'] ?? '';
//           String claimDate = claim['doa'] ?? claim['receivedDate'] ?? '';
          
//           // Build a descriptive display text
//           String description = '$claimantName - $hospitalName';
//           if (claimDate.isNotEmpty) {
//             description += ' ($claimDate)';
//           }
          
//           return {
//             'id': claimNumber,
//             'description': description,
//             'displayText': '$claimNumber - $description',
//           };
//         })
//         .toList();
    
//     debugPrint('Claims formatted: ${claims.length}');
//     for (var claim in claims) {
//       debugPrint('Claim: ${claim['displayText']}');
//     }
//     debugPrint('=== END MAIN HOSPITALIZATION CLAIMS ===');
    
//     return claims;
//   }


//   @override
//   void initState() {
//     super.initState();
    
//     // Add focus listeners for account number masking
//     accountNumberFocusNode.addListener(() {
//       setState(() {
//         isAccountNumberFocused = accountNumberFocusNode.hasFocus;
//         if (!accountNumberFocusNode.hasFocus && actualAccountNumber.isNotEmpty) {
//           // When focus is lost, show masked version
//           accountNumberController.text = _maskAccountNumber(actualAccountNumber);
//         } else if (accountNumberFocusNode.hasFocus && actualAccountNumber.isNotEmpty) {
//           // When focused, show actual number
//           accountNumberController.text = actualAccountNumber;
//         }
//       });
//     });
    
//     reEnterAccountNumberFocusNode.addListener(() {
//       setState(() {
//         isReEnterAccountNumberFocused = reEnterAccountNumberFocusNode.hasFocus;
//         if (!reEnterAccountNumberFocusNode.hasFocus && actualReEnterAccountNumber.isNotEmpty) {
//           // When focus is lost, show masked version
//           reEnterAccountNumberController.text = _maskAccountNumber(actualReEnterAccountNumber);
//         } else if (reEnterAccountNumberFocusNode.hasFocus && actualReEnterAccountNumber.isNotEmpty) {
//           // When focused, show actual number
//           reEnterAccountNumberController.text = actualReEnterAccountNumber;
//         }
//       });
//     });
    
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadStatesData();
//       _checkClaimHistory();
//     });
//   }

//   void _loadStatesData() async {
//     final hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
//     // Only load states if not already loaded
//     if (hospitalProvider.statesDetails.isEmpty) {
//       await hospitalProvider.getStatesDetails();
//     }
//   }

//   void _checkClaimHistory() async {
//     final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
//     final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

//     // Get NORKA ID
//     String norkaId = norkaProvider.norkaId;
//     if (norkaId.isEmpty) return;

//     try {
//       debugPrint('=== Checking claim history for NORKA ID: $norkaId ===');
      
//       // Fetch existing claims
//       final result = await claimProvider.fetchClaimDependentInfo(norkaId: norkaId);
      
//       if (result['success']) {
//         setState(() {
//           // Properly cast the claims list to List<Map<String, dynamic>>
//           List<dynamic> rawClaims = result['claims'] ?? [];
//           existingClaims = rawClaims.map((claim) => claim as Map<String, dynamic>).toList();
          
//           // Determine if user has already claimed
//           bool hasAnyClaims = existingClaims.isNotEmpty;
//           bool hasHospitalizationClaims = existingClaims.any((claim) => 
//             claim['claimType'] == 'Hospitalization' || 
//             claim['type'] == 'Hospitalization' ||
//             claim['claim_type'] == 'Hospitalization'
//           );
          
//           debugPrint('=== CLAIM HISTORY ANALYSIS ===');
//           debugPrint('Total Claims Found: ${existingClaims.length}');
//           debugPrint('Has Any Claims: $hasAnyClaims');
//           debugPrint('Has Hospitalization Claims: $hasHospitalizationClaims');
          
//           // Log each claim for debugging
//           for (int i = 0; i < existingClaims.length; i++) {
//             var claim = existingClaims[i];
//             debugPrint('Claim $i: ${claim.toString()}');
//           }
          
//           debugPrint('Available Claim Types: $availableClaimTypes');
//           debugPrint('Main Hospitalization Claims: ${mainHospitalizationClaims.length}');
//           debugPrint('=== END CLAIM HISTORY ANALYSIS ===');
//         });
//       } else {
//         debugPrint('❌ Failed to fetch claim history: ${result['error']}');
//         // Default to no claims if API fails
//         setState(() {
//           existingClaims = [];
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Exception checking claim history: $e');
//       // Default to no claims if exception occurs
//       setState(() {
//         existingClaims = [];
//       });
//     }
//   }

//   @override
//   void dispose() {
//     patientNameController.dispose();
//     accountHolderNameController.dispose();
//     accountNumberController.dispose();
//     reEnterAccountNumberController.dispose();
//     ifscCodeController.dispose();
//     bankNameController.dispose();
//     branchNameController.dispose();
//     claimAmountController.dispose();
//     descriptionController.dispose();
//     hospitalNameController.dispose();
//     hospitalPinCodeController.dispose();
//     hospitalAddressController.dispose();
//     hospitalMobileController.dispose();
//     hospitalEmailController.dispose();
//     doctorNameController.dispose();
    
//     // Dispose focus nodes
//     accountNumberFocusNode.dispose();
//     reEnterAccountNumberFocusNode.dispose();
    
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context, String type) async {
//     // Set date restrictions based on type
//     DateTime firstDate;
//     DateTime lastDate;
//     DateTime initialDate;
    
//     DateTime today = DateTime.now();

//     if (type == 'admission') {
//       firstDate = DateTime(2020);
//       lastDate = DateTime(today.year + 1, 12, 31);
//       initialDate = DateTime(today.year, today.month, today.day);
//     } else if (type == 'discharge') {
//       // For discharge: set firstDate based on admission date or default to 2020
//       if (admissionDate != null) {
//         firstDate = admissionDate!;
//         initialDate = admissionDate!;
//       } else {
//         firstDate = DateTime(2020);
//         initialDate = DateTime.now();
//       }
//       lastDate = DateTime(today.year + 1, 12, 31);
//     } else {
//       // For other dates: default behavior
//       firstDate = DateTime(2020);
//       lastDate = DateTime(today.year + 1, 12, 31);
//       initialDate = DateTime.now();
//     }
    
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: lastDate,
//       builder: (context, child) {
//         final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppConstants.primaryColor,
//               onPrimary: AppConstants.whiteColor,
//               surface: isDarkMode ? AppConstants.boxBlackColor : AppConstants.whiteColor,
//               onSurface: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
    
//     if (picked != null) {
//       setState(() {
//         if (type == 'incident') {
//           selectedDate = picked;
//         } else if (type == 'admission') {
//           admissionDate = picked;
          
//           // For Daycare, automatically set discharge date to same as admission date
//           if (selectedClaimType == 'Daycare') {
//             dischargeDate = picked;
//             ToastMessage.successToast('Discharge date is set to same as admission date');
//           }
//         } else if (type == 'discharge') {
//           // Check if admission date is selected first
//           if (admissionDate == null) {
//             ToastMessage.failedToast('Please select admission date first');
//             return;
//           }
          
//           // Validate for Daycare claims - dates must be same
//           if (selectedClaimType == 'Daycare') {
//             // Check if picked date is same as admission date
//             if (picked.year == admissionDate!.year &&
//                 picked.month == admissionDate!.month &&
//                 picked.day == admissionDate!.day) {
//               dischargeDate = picked;
//             } else {
//               ToastMessage.failedToast('For Day Care claims, discharge date must be same as admission date');
//               return; // Don't set the date
//             }
//           } else {
//             // For other claim types, discharge date must be on or after admission date
//             if (picked.isBefore(DateTime(admissionDate!.year, admissionDate!.month, admissionDate!.day))) {
//               ToastMessage.failedToast('Discharge date cannot be before admission date');
//               return;
//             }
//             dischargeDate = picked;
//           }
//         }
//       });
//     }
//   }

//   List<Map<String, String>> _getFamilyMembers() {
//     final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
//     final familyData = verificationProvider.familyMembersDetails;
//     final enrollmentData = verificationProvider.enrollmentDetails;
    
//     List<Map<String, String>> members = [];
    
//     // Extract enrollment data - handle both old and new API response structures
//     Map<String, dynamic> enrollmentDetails = {};
//     if (enrollmentData.isNotEmpty) {
//       // Check for unified API response structure (direct enrollment data)
//       if (enrollmentData.containsKey('self_enrollment_number')) {
//         enrollmentDetails = enrollmentData;
//       }
//       // Check for old API response structure (data wrapper)
//       else if (enrollmentData['data'] != null) {
//         enrollmentDetails = enrollmentData['data'];
//       }
//     }
    
//     // Add Self
//     if (familyData['nrk_name'] != null) {
//       members.add({
//         'name': familyData['nrk_name'] ?? '',
//         'relationship': 'Self',
//         'enrollmentNumber': enrollmentDetails['self_enrollment_number'] ?? 'Not Generated',
//       });
//     }
    
//     // Add Spouse
//     if (familyData['spouse_name'] != null &&
//         familyData['spouse_name'].toString().isNotEmpty) {
//       members.add({
//         'name': familyData['spouse_name'] ?? '',
//         'relationship': 'Spouse',
//         'enrollmentNumber': enrollmentDetails['spouse_enrollment_number'] ?? 'Not Generated',
//       });
//     }
    
//     // Add Children
//     for (int i = 1; i <= 5; i++) {
//       String kidName = familyData['kid_${i}_name'] ?? '';
//       if (kidName.isNotEmpty) {
//         members.add({
//           'name': kidName,
//           'relationship': 'Child $i',
//           'enrollmentNumber': enrollmentDetails['child${i}_enrollment_number'] ?? 'Not Generated',
//         });
//       }
//     }
    
//     return members;
//   }

//   Widget _buildPatientDropdown() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final familyMembers = _getFamilyMembers();
    
//     return Container(
//       height: 48, // Fixed height to match other form fields
//       margin: const EdgeInsets.symmetric(horizontal: 0), // Ensure proper margins
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withOpacity(0.2)
//               : Colors.grey.withOpacity(0.3),
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedPatient,
//           isExpanded: true,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             size: 20,
//           ),
//           hint: AppText(
//             text: 'Select patient',
//             size: 16,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//           items: [
//             // Add placeholder option
//             DropdownMenuItem<String>(
//               value: null,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: AppText(
//                   text: 'Select patient',
//                   size: 16,
//                   weight: FontWeight.normal,
//                   textColor: AppConstants.greyColor,
//                 ),
//               ),
//             ),
//             // Add family members
//             ...familyMembers.map<DropdownMenuItem<String>>((member) {
//               return DropdownMenuItem<String>(
//                 value: member['name'],
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: AppText(
//                     text: '${member['name']} (${member['relationship']})',
//                     size: 16,
//                     weight: FontWeight.normal,
//                     textColor: isDarkMode
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedPatient = newValue;
//               if (newValue != null) {
//                 patientNameController.text = newValue;
//               }
//               // Reset claim type and main hospitalization claim when patient changes
//               selectedClaimType = null;
//               selectedMainHospitalizationClaim = null;
//             });
//           },
//           dropdownColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           style: TextStyle(
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStateDropdown() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final hospitalProvider = Provider.of<HospitalProvider>(context);
    
//     // Get states from hospital provider
//     List<Map<String, dynamic>> states = [];
//     if (hospitalProvider.statesDetails['data'] != null && 
//         hospitalProvider.statesDetails['data']['data'] != null) {
//       states = List<Map<String, dynamic>>.from(hospitalProvider.statesDetails['data']['data']);
//     }
    
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withOpacity(0.2)
//               : Colors.grey.withOpacity(0.3),
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedStateName.isEmpty ? null : selectedStateName,
//           isExpanded: true,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             size: 20,
//           ),
//           hint: AppText(
//             text: 'Select state',
//             size: 16,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//           items: states.map<DropdownMenuItem<String>>((state) {
//             return DropdownMenuItem<String>(
//               value: state['STATE_NAME'],
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: AppText(
//                   text: state['STATE_NAME'] ?? '',
//                   size: 16,
//                   weight: FontWeight.normal,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: (String? newValue) async {
//             if (newValue != null) {
//               final selectedState = states.firstWhere((s) => s['STATE_NAME'] == newValue);
//             setState(() {
//                 selectedStateName = newValue;
//                 selectedStateId = selectedState['STATE_TYPE_ID'] ?? '';
//                 selectedCityName = '';
//                 selectedCityId = '';
//                 selectedHospital = null; // Reset hospital when state changes
//               });
              
//               // Fetch cities for selected state
//               if (selectedStateId.isNotEmpty) {
//                 await hospitalProvider.getCitiesDetails(selectedStateId);
//               }
//             }
//           },
//           dropdownColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           style: TextStyle(
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCityDropdown() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final hospitalProvider = Provider.of<HospitalProvider>(context);
    
//     // Get cities from hospital provider
//     List<Map<String, dynamic>> cities = [];
//     if (hospitalProvider.citiesDetails['data'] != null && 
//         hospitalProvider.citiesDetails['data']['data'] != null && 
//         selectedStateId.isNotEmpty) {
//       cities = List<Map<String, dynamic>>.from(hospitalProvider.citiesDetails['data']['data']);
//     }
    
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withOpacity(0.2)
//               : Colors.grey.withOpacity(0.3),
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedCityName.isEmpty ? null : selectedCityName,
//           isExpanded: true,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             size: 20,
//           ),
//           hint: AppText(
//             text: selectedStateId.isEmpty ? 'Select state first' : 'Select city',
//             size: 16,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//           items: cities.map<DropdownMenuItem<String>>((city) {
//             return DropdownMenuItem<String>(
//               value: city['CITY_DESCRIPTION'],
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: AppText(
//                   text: city['CITY_DESCRIPTION'] ?? '',
//                   size: 16,
//                   weight: FontWeight.normal,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: selectedStateId.isEmpty ? null : (String? newValue) {
//             if (newValue != null) {
//               final selectedCity = cities.firstWhere((c) => c['CITY_DESCRIPTION'] == newValue);
//             setState(() {
//                 selectedCityName = newValue;
//                 selectedCityId = selectedCity['CITY_TYPE_ID'] ?? '';
//                 selectedHospital = null; // Reset hospital when city changes
//               });
//             }
//           },
//           dropdownColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           style: TextStyle(
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildClaimTypeDropdown() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withOpacity(0.2)
//               : Colors.grey.withOpacity(0.3),
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedClaimType,
//           isExpanded: true,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             size: 20,
//           ),
//           hint: AppText(
//             text: 'Select claim type',
//             size: 16,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//           items: [
//             // Add placeholder option
//             DropdownMenuItem<String>(
//               value: null,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: AppText(
//                   text: 'Select claim type',
//                   size: 16,
//                   weight: FontWeight.normal,
//                   textColor: AppConstants.greyColor,
//                 ),
//               ),
//             ),
//             // Add claim types (dynamic based on claim history)
//             ...availableClaimTypes.map<DropdownMenuItem<String>>((claimType) {
//               return DropdownMenuItem<String>(
//                 value: claimType,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: AppText(
//                     text: claimType,
//                     size: 16,
//                     weight: FontWeight.normal,
//                     textColor: isDarkMode
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedClaimType = newValue;
//               // Reset main hospitalization claim when claim type changes
//               if (newValue != 'Pre Post Hospitalization') {
//                 selectedMainHospitalizationClaim = null;
//               }
//               // If switching to Daycare and admission date is selected, set discharge date to same
//               if (newValue == 'Daycare' && admissionDate != null) {
//                 dischargeDate = admissionDate;
//               }
//             });
//           },
//           dropdownColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           style: TextStyle(
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainHospitalizationClaimDropdown() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
//     return Container(
//       height: 56, // Increased height to accommodate longer text
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withOpacity(0.2)
//               : Colors.grey.withOpacity(0.3),
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedMainHospitalizationClaim,
//           isExpanded: true,
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             size: 20,
//           ),
//           hint: AppText(
//             text: 'Select main hospitalization claim',
//             size: 16,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//           items: [
//             // Add placeholder option
//             DropdownMenuItem<String>(
//               value: null,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 child: AppText(
//                   text: mainHospitalizationClaims.isEmpty 
//                       ? 'No previous hospitalization claims'
//                       : 'Select main hospitalization claim',
//                   size: 15,
//                   weight: FontWeight.normal,
//                   textColor: AppConstants.greyColor,
//                 ),
//               ),
//             ),
//             // Add main hospitalization claims (only if they exist)
//             if (mainHospitalizationClaims.isNotEmpty)
//               ...mainHospitalizationClaims.map<DropdownMenuItem<String>>((claim) {
//                 return DropdownMenuItem<String>(
//                   value: claim['displayText'],
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     child: Text(
//                       claim['displayText']!,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.normal,
//                         color: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor,
//                       ),
//                       maxLines: 2, // Allow text to wrap to 2 lines
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 );
//               }).toList(),
//           ],
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedMainHospitalizationClaim = newValue;
              
//               // Auto-fill DOA and DOD from selected main hospitalization claim
//               if (newValue != null && newValue.isNotEmpty) {
//                 // Find the selected claim from existing claims
//                 final selectedClaim = existingClaims.firstWhere(
//                   (claim) {
//                     String claimNumber = (claim['claimNumber'] ?? claim['claimId'] ?? '').toString();
//                     return newValue.startsWith(claimNumber);
//                   },
//                   orElse: () => {},
//                 );
                
//                 if (selectedClaim.isNotEmpty) {
//                   // Extract dates from the main claim
//                   String? doa = selectedClaim['doa'];
//                   String? dod = selectedClaim['dod'];
                  
//                   debugPrint('=== AUTO-FILLING DATES FROM MAIN HOSPITALIZATION ===');
//                   debugPrint('Main Claim DOA: $doa');
//                   debugPrint('Main Claim DOD: $dod');
                  
//                   // Parse and set admission date
//                   if (doa != null && doa.isNotEmpty) {
//                     try {
//                       admissionDate = _parseDateString(doa);
//                       debugPrint('Admission date set to: $admissionDate');
//                     } catch (e) {
//                       debugPrint('Error parsing admission date: $e');
//                     }
//                   }
                  
//                   // Parse and set discharge date
//                   if (dod != null && dod.isNotEmpty) {
//                     try {
//                       dischargeDate = _parseDateString(dod);
//                       debugPrint('Discharge date set to: $dischargeDate');
//                     } catch (e) {
//                       debugPrint('Error parsing discharge date: $e');
//                     }
//                   }
                  
//                   // Extract hospital name from main claim for comparison
//                   mainClaimHospitalName = (selectedClaim['hospName'] ?? selectedClaim['hospitalName'] ?? '').toString();
//                   debugPrint('Main Claim Hospital: $mainClaimHospitalName');
                  
//                   // Check if current hospital matches
//                   _checkHospitalMatch();
//                 }
//               } else {
//                 // Reset when no claim selected
//                 mainClaimHospitalName = '';
//                 showHospitalMismatchWarning = false;
//               }
//             });
//           },
//           dropdownColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           style: TextStyle(
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAccountTypeDropdown() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
//     return Container(
//       height: 56,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withOpacity(0.2)
//               : Colors.grey.withOpacity(0.3),
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedAccountType,
//           isExpanded: true,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             size: 20,
//           ),
//           hint: AppText(
//             text: 'Select account type',
//             size: 16,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//           items: ['Savings', 'Current'].map<DropdownMenuItem<String>>((String accountType) {
//             return DropdownMenuItem<String>(
//               value: accountType,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: AppText(
//                   text: accountType,
//                   size: 16,
//                   weight: FontWeight.normal,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedAccountType = newValue;
//             });
//           },
//           dropdownColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           style: TextStyle(
//             color: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   void _submitClaim() {
//     if (_formKey.currentState!.validate()) {
//       if (selectedPatient == null || selectedPatient!.isEmpty) {
//         ToastMessage.failedToast('Please select a patient');
//         return;
//       }
      
//       if (selectedClaimType == null || selectedClaimType!.isEmpty) {
//         ToastMessage.failedToast('Please select a claim type');
//         return;
//       }
      
//       // Validate main hospitalization claim for Pre Post Hospitalization
//       if (selectedClaimType == 'Pre Post Hospitalization') {
//         // Check if there are any hospitalization claims available
//         if (mainHospitalizationClaims.isEmpty) {
//           ToastMessage.failedToast('No previous hospitalization claims found. You cannot file Pre Post Hospitalization claim without a previous hospitalization claim.');
//           return;
//         }
        
//         if (selectedMainHospitalizationClaim == null || selectedMainHospitalizationClaim!.isEmpty) {
//           ToastMessage.failedToast('Please select a main hospitalization claim');
//           return;
//         }
//       }
      
//       // Validate claim amount
//       final claimAmount = double.tryParse(claimAmountController.text);
//       if (claimAmount == null || claimAmount <= 0) {
//         ToastMessage.failedToast('Please enter a valid claim amount');
//         return;
//       }
      
//       if (claimAmount > 500000) {
//         ToastMessage.failedToast('Claim amount cannot exceed ₹5,00,000');
//         return;
//       }
      
//       // Validate account numbers match (use actual stored values, not masked)
//       String accountNum = actualAccountNumber.replaceAll(' ', '');
//       String reEnterAccountNum = actualReEnterAccountNumber.replaceAll(' ', '');
      
//       if (accountNum.isEmpty || reEnterAccountNum.isEmpty) {
//         ToastMessage.failedToast('Please enter account numbers');
//         return;
//       }
      
//       if (accountNum != reEnterAccountNum) {
//         ToastMessage.failedToast('Account numbers do not match');
//         return;
//       }
      
//       // Validate account type
//       if (selectedAccountType == null || selectedAccountType!.isEmpty) {
//         ToastMessage.failedToast('Please select account type');
//         return;
//       }
      
//       // Validate discharge date
//       if (dischargeDate == null) {
//         ToastMessage.failedToast('Please select discharge date');
//         return;
//       }
      
//       // Validate admission date - cannot be in future
//       DateTime today = DateTime.now();
//       DateTime todayOnly = DateTime(today.year, today.month, today.day);
      
//       if (admissionDate!.isAfter(todayOnly)) {
//         ToastMessage.failedToast('Admission date cannot be in the future');
//         return;
//       }
      
//       // Validate dates
//       if (admissionDate != null && dischargeDate != null) {
//         // For Daycare: admission and discharge dates must be same
//         if (selectedClaimType == 'Daycare') {
//           if (admissionDate!.year != dischargeDate!.year ||
//               admissionDate!.month != dischargeDate!.month ||
//               admissionDate!.day != dischargeDate!.day) {
//             ToastMessage.failedToast('For Day Care claims, admission and discharge dates must be the same');
//             return;
//           }
//         } else {
//           // For other claim types: discharge date must be on or after admission date
//           DateTime admissionOnly = DateTime(admissionDate!.year, admissionDate!.month, admissionDate!.day);
//           DateTime dischargeOnly = DateTime(dischargeDate!.year, dischargeDate!.month, dischargeDate!.day);
          
//           if (dischargeOnly.isBefore(admissionOnly)) {
//             ToastMessage.failedToast('Discharge date cannot be before admission date');
//             return;
//           }
//         }
//       }
      
//       // Validate state and city selection
//       if (selectedStateId.isEmpty) {
//         ToastMessage.failedToast('Please select a state');
//         return;
//       }
      
//       if (selectedCityId.isEmpty) {
//         ToastMessage.failedToast('Please select a city');
//         return;
//       }
      
//       if (admissionDate == null) {
//         ToastMessage.failedToast('Please select admission date');
//         return;
//       }
      
//       // if (uploadedBankDocument.isEmpty) {
//       //   ToastMessage.failedToast('Please upload bank document');
//       //   return;
//       // }
      
//       // Check if file is selected but not uploaded
//       if (selectedFile != null && !isFileUploaded) {
//         ToastMessage.failedToast('Please Upload Document');
//         return;
//       }
      
//       // Check if no document is uploaded
//       if (!isFileUploaded || uploadedDocuments.isEmpty) {
//         ToastMessage.failedToast('Please Select Document');
//         return;
//       }
      
//       // Show confirmation dialog
//       _showConfirmationDialog();
//     }
//   }

//   void _showConfirmationDialog() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//             side: BorderSide(
//               color: isDarkMode
//                   ? Colors.white.withOpacity(0.1)
//                   : Colors.grey.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(width: 1),
//               AppText(
//                 text: 'Confirm Claim Submission ?',
//                 size: 18,
//                 weight: FontWeight.bold,
//                 textColor: isDarkMode
//                     ? AppConstants.whiteColor
//                     : AppConstants.blackColor,
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               AppText(
//                 text: 'Are you sure you want to submit this claim?',
//                 size: 16,
//                 weight: FontWeight.normal,
//                 textColor: isDarkMode
//                     ? AppConstants.whiteColor
//                     : AppConstants.blackColor,
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppConstants.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       text: 'Claim Details:',
//                       size: 14,
//                       weight: FontWeight.w600,
//                       textColor: AppConstants.primaryColor,
//                     ),
//                     const SizedBox(height: 8),
//                     AppText(
//                       text: 'Patient: ${selectedPatient ?? 'N/A'}',
//                       size: 13,
//                       weight: FontWeight.normal,
//                       textColor: isDarkMode
//                           ? AppConstants.whiteColor
//                           : AppConstants.blackColor,
//                     ),
//                     AppText(
//                       text: 'Amount: ₹${claimAmountController.text}',
//                       size: 13,
//                       weight: FontWeight.normal,
//                       textColor: isDarkMode
//                           ? AppConstants.whiteColor
//                           : AppConstants.blackColor,
//                     ),
//                     AppText(
//                       text: 'Type: ${selectedClaimType ?? 'N/A'}',
//                       size: 13,
//                       weight: FontWeight.normal,
//                       textColor: isDarkMode
//                           ? AppConstants.whiteColor
//                           : AppConstants.blackColor,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               AppText(
//                 text: 'Once submitted, you cannot modify the claim details.',
//                 size: 14,
//                 weight: FontWeight.w500,
//                 textColor: AppConstants.greyColor,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: AppText(
//                 text: 'Cancel',
//                 size: 14,
//                 weight: FontWeight.w500,
//                 textColor: AppConstants.greyColor,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close confirmation dialog
                
//                 // Show loading dialog
//                 showDialog(
//                   context: context,
//                   barrierDismissible: false,  // Prevent dismiss by tapping outside
//                   builder: (BuildContext context) {
//                     return PopScope(
//                       canPop: false,  // Prevent back button dismiss
//                       child: AlertDialog(
//                         backgroundColor: isDarkMode
//                             ? AppConstants.boxBlackColor
//                             : AppConstants.whiteColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         content: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 20),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   AppConstants.primaryColor,
//                                 ),
//                                 strokeWidth: 3,
//                               ),
//                               const SizedBox(height: 24),
//                               AppText(
//                                 text: 'Claim is processing...',
//                                 size: 16,
//                                 weight: FontWeight.w600,
//                                 textColor: isDarkMode
//                                     ? AppConstants.whiteColor
//                                     : AppConstants.blackColor,
//                               ),
//                               const SizedBox(height: 8),
//                               AppText(
//                                 text: 'Please wait',
//                                 size: 14,
//                                 weight: FontWeight.normal,
//                                 textColor: AppConstants.greyColor,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
                
//                 _submitClaimToAPI(); // Submit claim to API
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppConstants.primaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: AppText(
//                 text: 'Submit Claim',
//                 size: 14,
//                 weight: FontWeight.w600,
//                 textColor: AppConstants.whiteColor,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSuccessDialog() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//             side: BorderSide(
//               color: isDarkMode
//                   ? Colors.white.withOpacity(0.1)
//                   : Colors.grey.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppConstants.greenColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.check_circle,
//                   size: 60,
//                   color: AppConstants.greenColor,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               AppText(
//                 text: 'Claim Submitted Successfully!',
//                 size: 20,
//                 weight: FontWeight.bold,
//                 textColor: isDarkMode
//                     ? AppConstants.whiteColor
//                     : AppConstants.blackColor,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               AppText(
//                 text: 'Your claim has been submitted and is under review.',
//                 size: 14,
//                 weight: FontWeight.normal,
//                 textColor: AppConstants.greyColor,
//                 textAlign: TextAlign.center,
//               ),
              
//             ],
//           ),
//           actions: [
//             CustomButton(
//               text: 'Done',
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//                 Navigator.of(context).pop(); // Go back to claims page
//               },
//               color: AppConstants.primaryColor,
//               textColor: AppConstants.whiteColor,
//               height: 45,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Submit claim to API
//   Future<void> _submitClaimToAPI() async {
//     final claimProvider = Provider.of<ClaimProvider>(context, listen: false);

//     try {
//       debugPrint('=== SUBMITTING CLAIM TO API ===');
//       debugPrint('Claim Type: $selectedClaimType');
//       debugPrint('Selected Patient: $selectedPatient');
//       debugPrint('Claim Amount: ${claimAmountController.text}');

//       // Get enrollment number for selected patient
//       String enrollmentNumber = _getEnrollmentNumberForPatient(selectedPatient!);
//       debugPrint('Enrollment Number: $enrollmentNumber');

//       // Use the already uploaded file ID (don't call upload API again)
//       String fileId = uploadedFileId;
//       debugPrint('Using uploaded File ID: $fileId');

//       // Build request body based on claim type
//       Map<String, dynamic> requestBody;
      
//       // Clean account number and IFSC code (remove spaces) - use actual account number, not masked
//       String cleanAccountNumber = actualAccountNumber.replaceAll(' ', '');
//       String cleanIfscCode = ifscCodeController.text.replaceAll(' ', '').toUpperCase();
      
//       if (selectedClaimType == 'Pre Post Hospitalization') {
//         // Pre Post Hospitalization body
//         String mainClaimId = _getMainClaimIdFromSelection();
//         requestBody = {
//           "policyNo": "763300/25-26/NORKACARE/001",
//           "dependentUniqueId": enrollmentNumber,
//           "typeOfClaim": "Pre-post hospitalization",
//           "claimSubType": "Hospitalization",
//           "requestedAmount": claimAmountController.text,
//           "ailmentType": "Non covid",
//           "admissionDate": _formatDateForAPI(admissionDate!),
//           "dischargeDate": dischargeDate != null ? _formatDateForAPI(dischargeDate!) : _formatDateForAPI(admissionDate!),
//           "hospitalName": hospitalNameController.text,
//           "empanelmentNo": selectedHospital?['emplNo'] ?? '',
//           "documentType": "Claim",
//           "ailmentName": descriptionController.text,
//           "hospitalAddress": hospitalAddressController.text,
//           "hospitalState": selectedStateName,
//           "hospitalCity": selectedCityName,
//           "hospitalPinCode": hospitalPinCodeController.text,
//           "hospitalPhoneNo": hospitalMobileController.text,
//           "bankDetails": {
//             "accountHolderName": accountHolderNameController.text,
//             "accountType": selectedAccountType ?? "",
//             "accountNo": cleanAccountNumber,
//             "ifscCode": cleanIfscCode
//           },
//           "fileId": fileId,
//           "mainClaimNo": mainClaimId
//         };
//       } else {
//         // Hospitalization or Daycare body
//         String typeOfClaim = 'Main hospitalization claim'; // Same for both hospitalization and daycare
//         String claimSubType = selectedClaimType == 'Hospitalization' 
//             ? 'Hospitalization' 
//             : 'Day Care';
        
//         debugPrint('=== HOSPITALIZATION/DAYCARE CLAIM ===');
//         debugPrint('Selected Claim Type: $selectedClaimType');
//         debugPrint('Type of Claim: $typeOfClaim');
//         debugPrint('Claim Sub Type: $claimSubType');
            
//         requestBody = {
//           "policyNo": "763300/25-26/NORKACARE/001",
//           "dependentUniqueId": enrollmentNumber,
//           "typeOfClaim": typeOfClaim,
//           "claimSubType": claimSubType,
//           "requestedAmount": claimAmountController.text,
//           "ailmentType": "Non covid",
//           "admissionDate": _formatDateForAPI(admissionDate!),
//           "dischargeDate": dischargeDate != null ? _formatDateForAPI(dischargeDate!) : _formatDateForAPI(admissionDate!),
//           "hospitalName": hospitalNameController.text,
//           "empanelmentNo": selectedHospital?['emplNo'] ?? '',
//           "documentType": "Claim",
//           "ailmentName": descriptionController.text,
//           "hospitalAddress": hospitalAddressController.text,
//           "hospitalState": selectedStateName,
//           "hospitalCity": selectedCityName,
//           "hospitalPinCode": hospitalPinCodeController.text,
//           "hospitalPhoneNo": hospitalMobileController.text,
//           "bankDetails": {
//             "accountHolderName": accountHolderNameController.text,
//             "accountType": selectedAccountType ?? "",
//             "accountNo": cleanAccountNumber,
//             "ifscCode": cleanIfscCode
//           },
//           "fileId": fileId
//         };
//       }

//       debugPrint('=== CLAIM SUBMISSION REQUEST BODY ===');
//       debugPrint('Request Body: $requestBody');

//       // Call the submit claim API
//       final result = await claimProvider.submitClaim(requestBody);

//       // Close loading dialog
//       if (mounted) Navigator.of(context).pop();

//       if (result['success']) {
//         debugPrint('✅ Claim submitted successfully');
//         _showSuccessDialog();
//       } else {
//         debugPrint('❌ Claim submission failed: ${result['error']}');
//         ToastMessage.failedToast('Failed to submit claim');
//       }

//     } catch (e) {
//       debugPrint('❌ Exception during claim submission: $e');
      
//       // Close loading dialog
//       if (mounted) Navigator.of(context).pop();
      
//       ToastMessage.failedToast('Failed to submit claim. Please try again.');
//     }
//   }

//   // Get enrollment number for selected patient from claims data
//   String _getEnrollmentNumberForPatient(String patientName) {
//     final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
//     final dependents = claimProvider.dependents;
    
//     debugPrint('=== GETTING ENROLLMENT NUMBER FOR PATIENT ===');
//     debugPrint('Patient Name: $patientName');
//     debugPrint('Available Dependents: ${dependents.length}');
    
//     // Find the matching dependent based on patient name
//     for (var dependent in dependents) {
//       String dependentName = dependent['name'] ?? '';
//       String relationship = dependent['relationship'] ?? '';
//       String dependentUniqueId = dependent['dependentUniqueId'] ?? '';
      
//       debugPrint('Checking dependent: $dependentName, relationship: $relationship, ID: $dependentUniqueId');
      
//       // Match by relationship for Self
//       if (patientName.contains('Self') || patientName == 'Self') {
//         if (relationship.toLowerCase() == 'self') {
//           debugPrint('✅ Found Self enrollment: $dependentUniqueId');
//           return dependentUniqueId;
//         }
//       }
//       // Match by relationship for Spouse
//       else if (patientName.contains('Spouse') || patientName == 'Spouse') {
//         if (relationship.toLowerCase() == 'spouse') {
//           debugPrint('✅ Found Spouse enrollment: $dependentUniqueId');
//           return dependentUniqueId;
//         }
//       }
//       // Match by relationship for Child
//       else if (patientName.contains('Child')) {
//         if (relationship.toLowerCase().contains('child')) {
//           debugPrint('✅ Found Child enrollment: $dependentUniqueId');
//           return dependentUniqueId;
//         }
//       }
//       // Direct name match as fallback
//       else if (patientName.toLowerCase().contains(dependentName.toLowerCase())) {
//         debugPrint('✅ Found name match enrollment: $dependentUniqueId');
//         return dependentUniqueId;
//       }
//     }
    
//     // If no match found, return the first available dependent (usually Self)
//     if (dependents.isNotEmpty) {
//       String fallbackId = dependents.first['dependentUniqueId'] ?? 'EN000000186';
//       debugPrint('⚠️ No specific match found, using first dependent: $fallbackId');
//       return fallbackId;
//     }
    
//     debugPrint('❌ No dependents found, using default');
//     return 'EN000000186';
//   }

//   // Get main claim ID from selected main hospitalization claim
//   String _getMainClaimIdFromSelection() {
//     if (selectedMainHospitalizationClaim == null) return '';
    
//     // Extract claim ID from the display text (format: "CLM2024001 - Hospitalization for appendicitis")
//     final parts = selectedMainHospitalizationClaim!.split(' - ');
//     return parts.isNotEmpty ? parts[0] : '';
//   }

//   // Format date for API (DD-MM-YYYY format)
//   String _formatDateForAPI(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
//   }

//   // Parse date string from various formats to DateTime
//   DateTime? _parseDateString(String dateString) {
//     if (dateString.isEmpty) return null;
    
//     try {
//       // Handle DD/MM/YYYY format
//       if (dateString.contains('/')) {
//         List<String> parts = dateString.split('/');
//         if (parts.length == 3) {
//           int day = int.parse(parts[0]);
//           int month = int.parse(parts[1]);
//           int year = int.parse(parts[2]);
//           return DateTime(year, month, day);
//         }
//       }
      
//       // Handle DD-MM-YYYY format
//       if (dateString.contains('-') && dateString.split('-')[0].length <= 2) {
//         List<String> parts = dateString.split('-');
//         if (parts.length == 3) {
//           int day = int.parse(parts[0]);
//           int month = int.parse(parts[1]);
//           int year = int.parse(parts[2]);
//           return DateTime(year, month, day);
//         }
//       }
      
//       // Handle YYYY-MM-DD format
//       if (dateString.contains('-') && dateString.split('-')[0].length == 4) {
//         return DateTime.parse(dateString);
//       }
      
//       // Try parsing as ISO format
//       return DateTime.parse(dateString);
//     } catch (e) {
//       debugPrint('Error parsing date string: $dateString - $e');
//       return null;
//     }
//   }

//   // Mask account number to show only last 4 digits
//   String _maskAccountNumber(String accountNumber) {
//     if (accountNumber.isEmpty) return '';
    
//     // Remove spaces
//     String cleanNumber = accountNumber.replaceAll(' ', '');
    
//     if (cleanNumber.length <= 4) {
//       return cleanNumber;
//     }
    
//     // Show only last 4 digits, mask the rest with X
//     String lastFour = cleanNumber.substring(cleanNumber.length - 4);
//     String masked = 'X' * (cleanNumber.length - 4) + lastFour;
    
//     return masked;
//   }

//   // Check if current hospital matches main claim hospital (for Pre-Post Hospitalization)
//   void _checkHospitalMatch() {
//     if (selectedClaimType != 'Pre Post Hospitalization') {
//       setState(() {
//         showHospitalMismatchWarning = false;
//       });
//       return;
//     }
    
//     if (mainClaimHospitalName.isEmpty || hospitalNameController.text.isEmpty) {
//       setState(() {
//         showHospitalMismatchWarning = false;
//       });
//       return;
//     }
    
//     // Compare hospital names (case-insensitive, trimmed)
//     String currentHospital = hospitalNameController.text.trim().toLowerCase();
//     String mainHospital = mainClaimHospitalName.trim().toLowerCase();
    
//     setState(() {
//       showHospitalMismatchWarning = currentHospital != mainHospital;
//     });
    
//     if (showHospitalMismatchWarning) {
//       debugPrint('⚠️ Hospital Mismatch Warning:');
//       debugPrint('Main Claim Hospital: $mainClaimHospitalName');
//       debugPrint('Current Hospital: ${hospitalNameController.text}');
//     }
//   }

//   // void _showSavedBankAccounts() {
//   //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//   //   
//   //   // Sample saved bank accounts (in real app, fetch from database/API)
//   //   final List<Map<String, String>> savedAccounts = [
//   //     {
//   //       'name': 'John Doe - SBI',
//   //       'accountNumber': '****5678',
//   //       'bank': 'State Bank of India',
//   //       'ifsc': 'SBIN0001234',
//   //     },
//   //     {
//   //       'name': 'John Doe - HDFC',
//   //       'accountNumber': '****9012',
//   //       'bank': 'HDFC Bank',
//   //       'ifsc': 'HDFC0002345',
//   //     },
//   //   ];
//   //   
//   //   showModalBottomSheet(
//   //     context: context,
//   //     backgroundColor: Colors.transparent,
//   //     builder: (BuildContext context) {
//   //       return Container(
//   //         decoration: BoxDecoration(
//   //           color: isDarkMode
//   //               ? AppConstants.boxBlackColor
//   //               : AppConstants.whiteColor,
//   //           borderRadius: const BorderRadius.only(
//   //             topLeft: Radius.circular(20),
//   //             topRight: Radius.circular(20),
//   //           ),
//   //         ),
//   //         child: SafeArea(
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Container(
//   //                 margin: const EdgeInsets.only(top: 12),
//   //                 width: 40,
//   //                 height: 4,
//   //                 decoration: BoxDecoration(
//   //                   color: AppConstants.greyColor.withOpacity(0.3),
//   //                   borderRadius: BorderRadius.circular(2),
//   //                 ),
//   //               ),
//   //               Padding(
//   //                 padding: const EdgeInsets.all(20),
//   //                 child: AppText(
//   //                   text: 'Select Saved Account',
//   //                   size: 18,
//   //                   weight: FontWeight.bold,
//   //                   textColor: isDarkMode
//   //                       ? AppConstants.whiteColor
//   //                       : AppConstants.blackColor,
//   //                 ),
//   //               ),
//   //               Flexible(
//   //                 child: savedAccounts.isEmpty
//   //                     ? Padding(
//   //                         padding: const EdgeInsets.all(40),
//   //                         child: Column(
//   //                           mainAxisSize: MainAxisSize.min,
//   //                           children: [
//   //                             Icon(
//   //                               Icons.account_balance_outlined,
//   //                               size: 60,
//   //                               color: AppConstants.greyColor.withOpacity(0.5),
//   //                             ),
//   //                             const SizedBox(height: 12),
//   //                             AppText(
//   //                               text: 'No saved bank accounts',
//   //                               size: 16,
//   //                               weight: FontWeight.w500,
//   //                               textColor: AppConstants.greyColor,
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       )
//   //                     : ListView.builder(
//   //                         shrinkWrap: true,
//   //                         physics: const BouncingScrollPhysics(),
//   //                         itemCount: savedAccounts.length,
//   //                         itemBuilder: (context, index) {
//   //                           final account = savedAccounts[index];
//   //                           
//   //                           return Container(
//   //                             margin: const EdgeInsets.symmetric(
//   //                               horizontal: 16,
//   //                               vertical: 8,
//   //                             ),
//   //                             decoration: BoxDecoration(
//   //                               color: isDarkMode
//   //                                   ? AppConstants.darkBackgroundColor
//   //                                   : AppConstants.whiteBackgroundColor,
//   //                               borderRadius: BorderRadius.circular(12),
//   //                               border: Border.all(
//   //                                 color: isDarkMode
//   //                                     ? Colors.white.withOpacity(0.1)
//   //                                     : Colors.grey.withOpacity(0.2),
//   //                               ),
//   //                             ),
//   //                             child: ListTile(
//   //                               contentPadding: const EdgeInsets.all(12),
//   //                               leading: Container(
//   //                                 padding: const EdgeInsets.all(10),
//   //                                 decoration: BoxDecoration(
//   //                                   color: AppConstants.primaryColor
//   //                                       .withOpacity(0.1),
//   //                                   borderRadius: BorderRadius.circular(8),
//   //                                 ),
//   //                                 child: Icon(
//   //                                   Icons.account_balance,
//   //                                   color: AppConstants.primaryColor,
//   //                                   size: 24,
//   //                                 ),
//   //                               ),
//   //                               title: AppText(
//   //                                 text: account['name']!,
//   //                                 size: 16,
//   //                                 weight: FontWeight.w600,
//   //                                 textColor: isDarkMode
//   //                                     ? AppConstants.whiteColor
//   //                                     : AppConstants.blackColor,
//   //                               ),
//   //                               subtitle: Column(
//   //                                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                                 children: [
//   //                                   const SizedBox(height: 4),
//   //                                   AppText(
//   //                                     text: '${account['bank']} - ${account['accountNumber']}',
//   //                                     size: 13,
//   //                                     weight: FontWeight.normal,
//   //                                     textColor: AppConstants.greyColor,
//   //                                   ),
//   //                                   AppText(
//   //                                     text: 'IFSC: ${account['ifsc']}',
//   //                                     size: 12,
//   //                                     weight: FontWeight.normal,
//   //                                     textColor: AppConstants.greyColor,
//   //                                   ),
//   //                                 ],
//   //                               ),
//   //                               trailing: Icon(
//   //                                 Icons.arrow_forward_ios,
//   //                                 size: 16,
//   //                                 color: AppConstants.greyColor,
//   //                               ),
//   //                               onTap: () {
//   //                                 setState(() {
//   //                                   accountHolderNameController.text =
//   //                                       account['name']!.split(' - ')[0];
//   //                                   accountNumberController.text =
//   //                                       account['accountNumber']!;
//   //                                   reEnterAccountNumberController.text =
//   //                                       account['accountNumber']!;
//   //                                   bankNameController.text = account['bank']!;
//   //                                   ifscCodeController.text = account['ifsc']!;
//   //                                 });
//   //                                 Navigator.pop(context);
//   //                                 ToastMessage.successToast(
//   //                                   'Bank account details filled',
//   //                                 );
//   //                               },
//   //                             ),
//   //                           );
//   //                         },
//   //                       ),
//   //               ),
//   //               const SizedBox(height: 20),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   void _showHospitalSelectionDialog() async {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
    
//     // Fetch hospitals for selected state and city
//     final requestData = {
//       'hospital_name': '',
//       'state_id': selectedStateId,
//       'city_id': selectedCityId,
//     };
    
//     // Show loading dialog while fetching
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: CircularProgressIndicator(color: AppConstants.primaryColor),
//       ),
//     );
    
//     try {
//       await hospitalProvider.getHospitals(requestData);
//       Navigator.pop(context); // Close loading dialog
      
//       // Get hospitals from response
//       List<Map<String, dynamic>> hospitals = [];
//       if (hospitalProvider.hospitalResponse != null &&
//           hospitalProvider.hospitalResponse!['data'] != null) {
//         // Check if data is already a List (direct array) or nested in another 'data' key
//         var data = hospitalProvider.hospitalResponse!['data'];
//         if (data is List) {
//           hospitals = List<Map<String, dynamic>>.from(data);
//         } else if (data is Map && data['data'] != null && data['data'] is List) {
//           hospitals = List<Map<String, dynamic>>.from(data['data']);
//         }
//       }
      
//       if (hospitals.isEmpty) {
//         ToastMessage.failedToast('No hospitals found in this area');
//         return;
//       }
      
//       // Show hospital selection dialog with search
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (BuildContext context) {
//           return _HospitalSelectionSheet(
//             hospitals: hospitals,
//             isDarkMode: isDarkMode,
//             selectedCityName: selectedCityName,
//             selectedStateName: selectedStateName,
//             onHospitalSelected: (hospital) {
//               setState(() {
//                 selectedHospital = hospital;
//                 // Auto-fill hospital details
//                 hospitalNameController.text = hospital['hospitalName'] ?? '';
//                 hospitalPinCodeController.text = hospital['pincode']?.toString() ?? '';
//                 hospitalAddressController.text = hospital['address1'] ?? '';
//                 hospitalMobileController.text = hospital['phHosp1'] ?? '';
//                 hospitalEmailController.text = hospital['hospEmailID'] ?? '';
                
//                 // Check for hospital match with main claim (for Pre-Post Hospitalization)
//                 _checkHospitalMatch();
//               });
//               Navigator.pop(context);
//               // ToastMessage.successToast('Hospital selected successfully');
//             },
//           );
//         },
//       );
//     } catch (e) {
//       Navigator.pop(context); // Close loading dialog
//       ToastMessage.failedToast('Failed to load hospitals. Please try again.');
//     }
//   }

//   // File size validation method
//   bool _validateFileSize(int fileSizeInBytes) {
//     const int maxSizeInBytes = 2 * 1024 * 1024; // 2MB in bytes
//     return fileSizeInBytes <= maxSizeInBytes;
//   }

//   // Format file size for display
//   String _formatFileSize(int bytes) {
//     if (bytes < 1024) return '$bytes B';
//     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
//   }

//   // Step 1: Select file (not uploaded yet)
//   Future<void> _pickPDFFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'jpg', 'jpeg'],
//         allowMultiple: false, // Restrict to single file selection only
//       );

//       if (result != null && result.files.isNotEmpty) {
//         PlatformFile file = result.files.first;
        
//         // Validate file size (2MB limit)
//         if (!_validateFileSize(file.size)) {
//           ToastMessage.failedToast(
//             'File size (${_formatFileSize(file.size)}) exceeds 2MB limit'
//           );
//           return;
//         }

//         // Validate file extension
//         String extension = file.extension?.toLowerCase() ?? '';
//         if (extension != 'pdf' && extension != 'jpg' && extension != 'jpeg') {
//           ToastMessage.failedToast(
//             'Please select a PDF, JPG, or JPEG file only'
//           );
//           return;
//         }

//         // Store selected file (not uploaded yet)
//         setState(() {
//           selectedFile = file;
//           isFileUploaded = false;
//         });

//         // ToastMessage.successToast(
//         //   'File selected: ${file.name}'
//         // );
//       }
//     } catch (e) {
//       ToastMessage.failedToast(
//         'Failed to pick file: ${e.toString()}'
//       );
//     }
//   }

//   // Step 2: Upload/Confirm the selected file with API call
//   Future<void> _uploadSelectedFile() async {
//     if (selectedFile == null) return;

//     final claimProvider = Provider.of<ClaimProvider>(context, listen: false);

//     // Show loading dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? AppConstants.boxBlackColor
//                   : AppConstants.whiteColor,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     AppConstants.primaryColor,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 AppText(
//                   text: 'Uploading document...',
//                   size: 16,
//                   weight: FontWeight.w500,
//                   textColor: Theme.of(context).brightness == Brightness.dark
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     try {
//       debugPrint('=== Starting document upload ===');
//       debugPrint('File: ${selectedFile!.name}');
//       debugPrint('Size: ${selectedFile!.size} bytes');

//       // Call the API to upload the document
//       final result = await claimProvider.uploadClaimDocument(
//         file: selectedFile!,
//       );

//       // Close loading dialog
//       if (mounted) Navigator.of(context).pop();

//       if (result['success']) {
//         debugPrint('✅ Document uploaded successfully');
//         debugPrint('File ID: ${result['fileId']}');

//         setState(() {
//           uploadedDocuments.clear();
//           uploadedFilesWithSize.clear();
//           uploadedDocuments.add(selectedFile!.name);
//           uploadedFilesWithSize[selectedFile!.name] = selectedFile!.size;
//           isFileUploaded = true;
//           uploadedFileId = result['fileId'] ?? ''; // Store the file ID
//         });

//         // ToastMessage.successToast(
//         //   'Document uploaded successfully (${_formatFileSize(selectedFile!.size)})'
//         // );
//       } else {
//         debugPrint('❌ Upload failed: ${result['error']}');

//         ToastMessage.failedToast(
//           result['error'] ?? 'Failed to upload document. Please try again.'
//         );

//         // Reset file upload state on failure
//         setState(() {
//           isFileUploaded = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Exception during upload: $e');

//       // Close loading dialog
//       if (mounted) Navigator.of(context).pop();

//       ToastMessage.failedToast(
//         'Failed to upload document. Please try again.'
//       );

//       // Reset file upload state on error
//       setState(() {
//         isFileUploaded = false;
//       });
//     }
//   }

//   // Real bank document upload using file picker
//   // Future<void> _uploadBankDocument() async {
//   //   try {
//   //     FilePickerResult? result = await FilePicker.platform.pickFiles(
//   //       type: FileType.custom,
//   //       allowedExtensions: ['pdf'],
//   //       allowMultiple: false,
//   //     );
//   //
//   //     if (result != null && result.files.isNotEmpty) {
//   //       PlatformFile file = result.files.first;
//   //       
//   //       // Validate file size (2MB limit)
//   //       if (!_validateFileSize(file.size)) {
//   //         ToastMessage.failedToast(
//   //           'File size (${_formatFileSize(file.size)}) exceeds 2MB limit'
//   //         );
//   //         return;
//   //       }
//   //
//   //       // Validate file extension
//   //       String extension = file.extension?.toLowerCase() ?? '';
//   //       if (extension != 'pdf') {
//   //         ToastMessage.failedToast(
//   //           'Please select a PDF file only'
//   //         );
//   //         return;
//   //       }
//   //
//   //       // Set uploaded bank document
//   //       setState(() {
//   //         selectedBankFile = file;
//   //         uploadedBankDocument = file.name;
//   //       });
//   //
//   //       ToastMessage.successToast(
//   //         'Bank document uploaded successfully (${_formatFileSize(file.size)})'
//   //       );
//   //     }
//   //   } catch (e) {
//   //     ToastMessage.failedToast(
//   //       'Failed to pick file: ${e.toString()}'
//   //     );
//   //   }
//   // }

//   // Verify IFSC Code and auto-fetch bank details
//   Future<void> _verifyIfscCode() async {
//     final ifscCode = ifscCodeController.text.trim().toUpperCase();
    
//     // Validate IFSC format
//     if (ifscCode.isEmpty) {
//       ToastMessage.failedToast('Please enter IFSC code');
//       return;
//     }
    
//     if (ifscCode.length != 11) {
//       ToastMessage.failedToast('IFSC code must be 11 characters');
//       return;
//     }
    
//     // Validate IFSC format: First 4 letters, 5th is 0, last 6 alphanumeric
//     final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
//     if (!ifscRegex.hasMatch(ifscCode)) {
//       ToastMessage.failedToast('Invalid IFSC format.');
//       return;
//     }
    
//     setState(() {
//       isVerifyingIfsc = true;
//       isIfscVerified = false;
//     });

//     try {
//       debugPrint('=== Verifying IFSC Code: $ifscCode ===');
      
//       final dio = Dio();
//       final response = await dio.get(
//         'https://ifsc.razorpay.com/$ifscCode',
//         options: Options(
//           validateStatus: (status) => status != null && status < 500,
//         ),
//       );

//       if (response.statusCode == 200 && response.data != null) {
//         debugPrint('✅ IFSC Verification Success: ${response.data}');
        
//         final data = response.data;
        
//         setState(() {
//           // Auto-fill bank name and branch name
//           bankNameController.text = data['BANK'] ?? '';
//           branchNameController.text = data['BRANCH'] ?? '';
//           isIfscVerified = true;
//           isVerifyingIfsc = false;
//         });
        
//         // ToastMessage.successToast('IFSC verified successfully');
//       } else {
//         debugPrint('❌ IFSC Verification Failed: Invalid IFSC code');
        
//         setState(() {
//           isIfscVerified = false;
//           isVerifyingIfsc = false;
//         });
        
//         ToastMessage.failedToast('Invalid IFSC code.');
//       }
//     } catch (e) {
//       debugPrint('❌ IFSC Verification Error: $e');
      
//       setState(() {
//         isIfscVerified = false;
//         isVerifyingIfsc = false;
//       });
      
//       ToastMessage.failedToast('Invalid IFSC code. Please check and try again.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: isDarkMode
//           ? AppConstants.darkBackgroundColor
//           : AppConstants.whiteBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppConstants.primaryColor,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: Icon(
//             Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
//             color: AppConstants.whiteColor,
//           ),
//         ),
//         title: AppText(
//           text: 'File Health Claim',
//           size: 20,
//           weight: FontWeight.bold,
//           textColor: AppConstants.whiteColor,
//         ),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Info Card
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppConstants.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: AppConstants.primaryColor.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.info_outline,
//                       color: AppConstants.primaryColor,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: AppText(
//                         text: 'Please fill in all the details accurately to ensure quick processing of your claim.',
//                         size: 14,
//                         weight: FontWeight.w500,
//                         textColor: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 20),
              
//               // Policy Details Section
//               _buildSectionTitle('Policy Details'),
//               const SizedBox(height: 12),
              
//               // Policy Number
//               _buildLabel('Policy Number'),
//               const SizedBox(height: 6),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isDarkMode
//                         ? Colors.white.withOpacity(0.1)
//                         : AppConstants.primaryColor.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.badge,
//                       color: AppConstants.primaryColor,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 16),
//                     AppText(
//                       text: '763300/25-26/NORKACARE/001',
//                       size: 16,
//                       weight: FontWeight.w600,
//                       textColor: isDarkMode
//                           ? AppConstants.whiteColor
//                           : AppConstants.blackColor,
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 12),
              
//               // Enrollment ID
//               _buildLabel('Norka ID'),
//               const SizedBox(height: 6),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isDarkMode
//                         ? Colors.white.withOpacity(0.1)
//                         : AppConstants.primaryColor.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.confirmation_number,
//                       color: AppConstants.primaryColor,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 16),
//                     Consumer<VerificationProvider>(
//                       builder: (context, verificationProvider, child) {
//                         // Get NORKA ID from dashboard API response
//                         String norkaId = 'Loading...';
//                         final unifiedResponse = verificationProvider.getUnifiedApiResponse();
//                         if (unifiedResponse != null && unifiedResponse['nrk_id_no'] != null) {
//                           norkaId = unifiedResponse['nrk_id_no'].toString();
//                         }
                        
//                         return AppText(
//                           text: norkaId,
//                           size: 16,
//                           weight: FontWeight.w600,
//                           textColor: isDarkMode
//                               ? AppConstants.whiteColor
//                               : AppConstants.blackColor,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 20),
              
//               // Member Details Section
//               _buildSectionTitle('Member Details'),
//               const SizedBox(height: 12),
              
//               // Master Name
//               _buildLabel('Master Name (Policy Holder)'),
//               const SizedBox(height: 6),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isDarkMode
//                         ? Colors.white.withOpacity(0.1)
//                         : AppConstants.primaryColor.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.person,
//                       color: AppConstants.primaryColor,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Consumer<VerificationProvider>(
//                         builder: (context, verificationProvider, child) {
//                           // Get user name from dashboard API response
//                           String userName = 'Loading...';
//                           final unifiedResponse = verificationProvider.getUnifiedApiResponse();
//                           if (unifiedResponse != null && 
//                               unifiedResponse['user_details'] != null &&
//                               unifiedResponse['user_details']['nrk_user'] != null) {
//                             userName = unifiedResponse['user_details']['nrk_user']['name'] ?? 'Loading...';
//                           }
                          
//                           return Text(
//                             userName,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: isDarkMode
//                                   ? AppConstants.whiteColor
//                                   : AppConstants.blackColor,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 12),
              
//               // Patient Name
//               _buildLabel('Patient Name (Self/Family Member) *'),
//               const SizedBox(height: 6),
//               _buildPatientDropdown(),
              
//               const SizedBox(height: 20),
              
//               // Bank Account Details Section
//               _buildSectionTitle('Bank Account Details'),
//               const SizedBox(height: 12),
              
//               // Account Holder Name
//               _buildLabel('Account Holder Name *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: accountHolderNameController,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                 hintText: 'Enter account holder name',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.account_circle,
//                     color: AppConstants.primaryColor,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter account holder name';
//                   }
//                   if (value.length < 2) {
//                     return 'Name must be at least 2 characters';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               // Account Type
//               _buildLabel('Account Type *'),
//               const SizedBox(height: 6),
//               _buildAccountTypeDropdown(),
              
//               const SizedBox(height: 12),
              
//               // Account Number
//               _buildLabel('Account Number *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: accountNumberController,
//                 focusNode: accountNumberFocusNode,
//                 keyboardType: TextInputType.number,
//                 cursorColor: AppConstants.primaryColor,
//                 enableInteractiveSelection: false, // Disable copy-paste
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 onChanged: (value) {
//                   // Store actual account number when user types
//                   if (isAccountNumberFocused) {
//                     actualAccountNumber = value;
//                   }
//                 },
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: 'Enter account number',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.account_balance,
//                     color: AppConstants.primaryColor,
//                   ),
//                   suffixIcon: !isAccountNumberFocused && actualAccountNumber.isNotEmpty
//                       ? Icon(
//                           Icons.lock,
//                           color: AppConstants.greyColor,
//                           size: 18,
//                         )
//                       : null,
//                 ),
//                 validator: (value) {
//                   // Use actualAccountNumber for validation
//                   String cleanValue = actualAccountNumber.replaceAll(' ', '');
                  
//                   if (cleanValue.isEmpty) {
//                     return 'Please enter account number';
//                   }
                  
//                   // Check if contains only numbers (or X for masked)
//                   String unmaskedValue = cleanValue.replaceAll('X', '');
//                   if (!RegExp(r'^[0-9]+$').hasMatch(unmaskedValue) && cleanValue != value) {
//                     return 'Account number must contain only numbers';
//                   }
                  
//                   // For validation, use actual stored number
//                   if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
//                     return 'Account number must contain only numbers';
//                   }
                  
//                   // Check minimum length (usually 9 digits)
//                   if (cleanValue.length < 9) {
//                     return 'Account number must be at least 9 digits';
//                   }
                  
//                   // Check maximum length (usually 18 digits)
//                   if (cleanValue.length > 18) {
//                     return 'Account number cannot exceed 18 digits';
//                   }
                  
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               // Re-enter Account Number
//               _buildLabel('Re-enter Account Number *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: reEnterAccountNumberController,
//                 focusNode: reEnterAccountNumberFocusNode,
//                 keyboardType: TextInputType.number,
//                 cursorColor: AppConstants.primaryColor,
//                 enableInteractiveSelection: false, // Disable copy-paste
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 onChanged: (value) {
//                   // Store actual re-enter account number when user types
//                   if (isReEnterAccountNumberFocused) {
//                     actualReEnterAccountNumber = value;
//                   }
//                 },
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: 'Re-enter account number',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.account_balance,
//                     color: AppConstants.primaryColor,
//                   ),
//                   suffixIcon: !isReEnterAccountNumberFocused && actualReEnterAccountNumber.isNotEmpty
//                       ? Icon(
//                           Icons.lock,
//                           color: AppConstants.greyColor,
//                           size: 18,
//                         )
//                       : null,
//                 ),
//                 validator: (value) {
//                   // Use actualReEnterAccountNumber for validation
//                   String cleanValue = actualReEnterAccountNumber.replaceAll(' ', '');
                  
//                   if (cleanValue.isEmpty) {
//                     return 'Please re-enter account number';
//                   }
                  
//                   // Compare with actual account number (not masked version)
//                   String cleanAccountNumber = actualAccountNumber.replaceAll(' ', '');
                  
//                   if (cleanValue != cleanAccountNumber) {
//                     return 'Account numbers do not match';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               // IFSC Code with Verify Button
//               _buildLabel('IFSC Code *'),
//               const SizedBox(height: 6),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: ifscCodeController,
//                       textCapitalization: TextCapitalization.characters,
//                       cursorColor: AppConstants.primaryColor,
//                       maxLength: 11,
//                       onChanged: (value) {
//                         // Reset verification status when IFSC changes
//                         if (isIfscVerified) {
//                           setState(() {
//                             isIfscVerified = false;
//                           });
//                         }
//                       },
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor,
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: isDarkMode
//                             ? AppConstants.boxBlackColor
//                             : AppConstants.whiteColor,
//                         hintText: 'Enter IFSC code',
//                         hintStyle: TextStyle(color: AppConstants.greyColor),
//                         counterText: '',
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: isDarkMode
//                                 ? Colors.white.withOpacity(0.1)
//                                 : AppConstants.primaryColor.withOpacity(0.5),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: AppConstants.primaryColor,
//                             width: 1.6,
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: isIfscVerified 
//                                 ? Colors.green
//                                 : (isDarkMode
//                                     ? Colors.white.withOpacity(0.1)
//                                     : AppConstants.primaryColor.withOpacity(0.5)),
//                           ),
//                         ),
//                         prefixIcon: Icon(
//                           Icons.code,
//                           color: AppConstants.primaryColor,
//                         ),
//                         suffixIcon: isIfscVerified 
//                             ? Icon(
//                                 Icons.check_circle,
//                                 color: Colors.green,
//                                 size: 20,
//                               )
//                             : null,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter IFSC code';
//                         }
                        
//                         // Remove spaces and convert to uppercase for validation
//                         String ifsc = value.replaceAll(' ', '').toUpperCase();
                        
//                         // Check length
//                         if (ifsc.length != 11) {
//                           return 'IFSC must be 11 characters';
//                         }
                        
//                         // Validate IFSC format: First 4 letters, 5th is 0, last 6 alphanumeric
//                         // Pattern: ^[A-Z]{4}0[A-Z0-9]{6}$
//                         final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
//                         if (!ifscRegex.hasMatch(ifsc)) {
//                           return 'Invalid IFSC format';
//                         }
                        
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: 48,
//                     child: ElevatedButton(
//                       onPressed: isVerifyingIfsc ? null : _verifyIfscCode,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isIfscVerified 
//                             ? Colors.green 
//                             : AppConstants.primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       child: isVerifyingIfsc
//                           ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   AppConstants.whiteColor,
//                                 ),
//                               ),
//                             )
//                           : AppText(
//                               text: isIfscVerified ? 'Verified' : 'Verify',
//                               size: 14,
//                               weight: FontWeight.w600,
//                               textColor: AppConstants.whiteColor,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 12),
              
//               // Bank Name
//               _buildLabel('Bank Name *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: bankNameController,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: isIfscVerified ? 'Auto-filled from IFSC' : 'Enter bank name or verify IFSC',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.account_balance_wallet,
//                     color: AppConstants.primaryColor,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter bank name';
//                   }
//                   if (value.length < 2) {
//                     return 'Bank name must be at least 2 characters';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               // Branch Name
//               _buildLabel('Branch Name *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: branchNameController,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: isIfscVerified ? 'Auto-filled from IFSC' : 'Enter branch name or verify IFSC',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.location_on,
//                     color: AppConstants.primaryColor,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter branch name';
//                   }
//                   if (value.length < 2) {
//                     return 'Branch name must be at least 2 characters';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 20),
              
//               // Bank Document Upload
//               // _buildLabel('Bank Document'),
//               // AppText(text: "Cancelled cheque/Passbook/Bank statement", size: 12, weight: FontWeight.w500, textColor: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
//               // const SizedBox(height: 6),
//               // InkWell(
//               //   onTap: _uploadBankDocument,
//               //   child: Container(
//               //     padding: const EdgeInsets.all(16),
//               //     decoration: BoxDecoration(
//               //       color: isDarkMode
//               //           ? AppConstants.boxBlackColor
//               //           : AppConstants.whiteColor,
//               //       borderRadius: BorderRadius.circular(12),
//               //       border: Border.all(
//               //         color: isDarkMode
//               //             ? Colors.white.withOpacity(0.1)
//               //             : AppConstants.primaryColor.withOpacity(0.3),
//               //         width: 2,
//               //         style: BorderStyle.solid,
//               //       ),
//               //       boxShadow: [
//               //         BoxShadow(
//               //           color: isDarkMode
//               //               ? Colors.black.withOpacity(0.2)
//               //               : Colors.grey.withOpacity(0.1),
//               //           spreadRadius: 1,
//               //           blurRadius: 3,
//               //           offset: const Offset(0, 1),
//               //         ),
//               //       ],
//               //     ),
//               //     child: Row(
//               //       children: [
//               //         Icon(
//               //           Icons.account_balance,
//               //           size: 24,
//               //           color: AppConstants.primaryColor,
//               //         ),
//               //         const SizedBox(width: 12),
//               //         Expanded(
//               //           child: Column(
//               //             crossAxisAlignment: CrossAxisAlignment.start,
//               //             children: [
//               //               AppText(
//               //                 text: 'Upload Bank Document',
//               //                 size: 16,
//               //                 weight: FontWeight.w600,
//               //                 textColor: AppConstants.primaryColor,
//               //               ),
//               //               const SizedBox(height: 2),
//               //               Row(
//               //                 children: [
//               //                   if (uploadedBankDocument.isNotEmpty) ...[
//               //                     Icon(
//               //                       Icons.check_circle,
//               //                       color: Colors.green,
//               //                       size: 16,
//               //                     ),
//               //                     const SizedBox(width: 6),
//               //                   ],
//               //                   Expanded(
//               //                     child: AppText(
//               //                       text: uploadedBankDocument.isNotEmpty 
//               //                           ? uploadedBankDocument
//               //                           : 'PDF files only, max 2MB',
//               //                       size: 12,
//               //                       weight: FontWeight.normal,
//               //                       textColor: uploadedBankDocument.isNotEmpty 
//               //                           ? AppConstants.primaryColor
//               //                           : AppConstants.greyColor,
//               //                     ),
//               //                   ),
//               //                 ],
//               //               ),
//               //             ],
//               //           ),
//               //         ),
//               //         Icon(
//               //           Icons.cloud_upload_outlined,
//               //           color: AppConstants.primaryColor,
//               //           size: 20,
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
              
//               // const SizedBox(height: 20),
              
//               // Save Bank Details Button
//               // Row(
//               //   children: [
//               //     Expanded(
//               //       child: OutlinedButton.icon(
//               //         onPressed: () {
//               //           if (accountHolderNameController.text.isEmpty ||
//               //               accountNumberController.text.isEmpty ||
//               //               ifscCodeController.text.isEmpty) {
//               //             ToastMessage.failedToast(
//               //               'Please fill all required bank details',
//               //             );
//               //             return;
//               //           }
//               //           ToastMessage.successToast('Bank details saved successfully');
//               //         },
//               //         icon: Icon(
//               //           Icons.save_outlined,
//               //           color: AppConstants.primaryColor,
//               //           size: 20,
//               //         ),
//               //         label: AppText(
//               //           text: 'Save Bank Details',
//               //           size: 14,
//               //           weight: FontWeight.w600,
//               //           textColor: AppConstants.primaryColor,
//               //         ),
//               //         style: OutlinedButton.styleFrom(
//               //           padding: const EdgeInsets.symmetric(vertical: 10),
//               //           side: BorderSide(
//               //             color: AppConstants.primaryColor,
//               //             width: 1.5,
//               //           ),
//               //           shape: RoundedRectangleBorder(
//               //             borderRadius: BorderRadius.circular(10),
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //     const SizedBox(width: 12),
//               //     Expanded(
//               //       child: OutlinedButton.icon(
//               //         onPressed: () {
//               //           _showSavedBankAccounts();
//               //         },
//               //         icon: Icon(
//               //           Icons.account_balance,
//               //           color: AppConstants.secondaryColor,
//               //           size: 20,
//               //         ),
//               //         label: AppText(
//               //           text: 'Use Saved Account',
//               //           size: 14,
//               //           weight: FontWeight.w600,
//               //           textColor: isDarkMode
//               //               ? AppConstants.whiteColor
//               //               : AppConstants.blackColor,
//               //         ),
//               //         style: OutlinedButton.styleFrom(
//               //           padding: const EdgeInsets.symmetric(vertical: 10),
//               //           side: BorderSide(
//               //             color: isDarkMode
//               //                 ? Colors.white.withOpacity(0.3)
//               //                 : AppConstants.greyColor.withOpacity(0.5),
//               //             width: 1.5,
//               //           ),
//               //           shape: RoundedRectangleBorder(
//               //             borderRadius: BorderRadius.circular(10),
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // ),
              
//               // const SizedBox(height: 20),
              
//               // Claim Details Section
//               _buildSectionTitle('Claim Details'),
//               const SizedBox(height: 12),
              
//               // Claim Amount
//               _buildLabel('Claim Amount (₹) *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: claimAmountController,
//                 keyboardType: TextInputType.number,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: 'Enter claim amount',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.currency_rupee,
//                     color: AppConstants.primaryColor,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter claim amount';
//                   }
                  
//                   // Check if it's a valid number
//                   final amount = double.tryParse(value);
//                   if (amount == null) {
//                     return 'Please enter a valid amount';
//                   }
                  
//                   // Check minimum amount
//                   if (amount <= 0) {
//                     return 'Amount must be greater than ₹0';
//                   }
                  
//                   // Check maximum amount (e.g., ₹10,00,000)
//                   if (amount > 500000) {
//                     return 'Amount cannot exceed ₹5,00,000';
//                   }
                  
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               // Claim Type
//               _buildLabel('Claim Type *'),
//               const SizedBox(height: 6),
//               _buildClaimTypeDropdown(),
              
//               // Show main hospitalization claim dropdown only when "Pre Post Hospitalization" is selected
//               if (selectedClaimType == 'Pre Post Hospitalization') ...[
//                 const SizedBox(height: 12),
//                 _buildLabel('Select Main Hospitalization Claim *'),
//                 const SizedBox(height: 6),
//                 _buildMainHospitalizationClaimDropdown(),
//               ],
              
//               const SizedBox(height: 12),
              
//               // Date of Admission
//               _buildLabel('Date of Admission *'),
//               const SizedBox(height: 6),
//               _buildDatePicker(
//                 context: context,
//                 isDarkMode: isDarkMode,
//                 selectedDate: admissionDate,
//                 dateType: 'admission',
//                 placeholder: 'Select admission date',
//               ),
              
//               const SizedBox(height: 12),
              
//               // Date of Discharge
//               _buildLabel('Date of Discharge *'),
//               const SizedBox(height: 6),
//               _buildDatePicker(
//                 context: context,
//                 isDarkMode: isDarkMode,
//                 selectedDate: dischargeDate,
//                 dateType: 'discharge',
//                 placeholder: 'Select discharge date',
//               ),
              
//               // Info message for Daycare claims
//               // if (selectedClaimType == 'Daycare') ...[
//               //   const SizedBox(height: 8),
//               //   Container(
//               //     padding: const EdgeInsets.all(10),
//               //     decoration: BoxDecoration(
//               //       color: Colors.blue.withOpacity(0.1),
//               //       borderRadius: BorderRadius.circular(8),
//               //       border: Border.all(
//               //         color: Colors.blue.withOpacity(0.3),
//               //         width: 1,
//               //       ),
//               //     ),
//               //     child: Row(
//               //       children: [
//               //         Icon(
//               //           Icons.info_outline,
//               //           color: Colors.blue,
//               //           size: 18,
//               //         ),
//               //         const SizedBox(width: 8),
//               //         Expanded(
//               //           child: AppText(
//               //             text: 'For Day Care claims, discharge date is automatically set to same as admission date',
//               //             size: 12,
//               //             weight: FontWeight.w500,
//               //             textColor: Colors.blue,
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ],
              
//               const SizedBox(height: 12),
              
//               // Description
//               _buildLabel('Description *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: descriptionController,
//                 maxLines: 4,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: 'Describe the incident/treatment in detail',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter description';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 20),
              
//               // Hospital Details
//               _buildSectionTitle('Hospital Details'),
//               const SizedBox(height: 12),
              
//               // State and City in same row
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildLabel('State *'),
//                         const SizedBox(height: 6),
//                         _buildStateDropdown(),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildLabel('City *'),
//                         const SizedBox(height: 6),
//                         _buildCityDropdown(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 12),
              
//               // Select Hospital Section
//               _buildLabel('Select Hospital'),
//               const SizedBox(height: 6),
//               InkWell(
//                 onTap: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
//                     ? () => _showHospitalSelectionDialog()
//                     : null,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.boxBlackColor
//                         : AppConstants.whiteColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
//                           ? (isDarkMode
//                               ? Colors.white.withOpacity(0.1)
//                               : AppConstants.primaryColor.withOpacity(0.3))
//                           : AppConstants.greyColor.withOpacity(0.2),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.local_hospital,
//                         color: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
//                             ? AppConstants.primaryColor
//                             : AppConstants.greyColor,
//                         size: 24,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppText(
//                               text: selectedHospital != null
//                                   ? (selectedHospital!['hospitalName'] ?? 'Hospital Selected')
//                                   : 'Select Hospital',
//                               size: 16,
//                               weight: FontWeight.w600,
//                               textColor: selectedHospital != null
//                                   ? (isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor)
//                                   : (selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
//                                       ? AppConstants.primaryColor
//                                       : AppConstants.greyColor),
//                             ),
//                             const SizedBox(height: 2),
//                             AppText(
//                               text: selectedHospital != null
//                                   ? '${selectedHospital!['cityName'] ?? ''}, ${selectedHospital!['stateName'] ?? ''}'
//                                   : (selectedStateId.isEmpty || selectedCityId.isEmpty
//                                       ? 'Please select state and city first'
//                                       : 'Tap to select available hospital'),
//                               size: 12,
//                               weight: FontWeight.normal,
//                               textColor: AppConstants.greyColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         selectedHospital != null ? Icons.check_circle : Icons.arrow_forward_ios,
//                         color: selectedHospital != null
//                             ? AppConstants.greenColor
//                             : AppConstants.primaryColor,
//                         size: selectedHospital != null ? 24 : 16,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               // Hospital Mismatch Warning for Pre-Post Hospitalization
//               if (showHospitalMismatchWarning) ...[
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: Colors.orange.withOpacity(0.5),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.warning_amber_rounded,
//                         color: Colors.orange,
//                         size: 22,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppText(
//                               text: 'Hospital Mismatch Warning',
//                               size: 14,
//                               weight: FontWeight.bold,
//                               textColor: Colors.orange,
//                             ),
//                             const SizedBox(height: 4),
//                             AppText(
//                               text: 'The selected hospital does not match the hospital from your main hospitalization claim ($mainClaimHospitalName). Please ensure you are selecting the correct hospital for your Pre-Post Hospitalization claim.',
//                               size: 12,
//                               weight: FontWeight.normal,
//                               textColor: isDarkMode
//                                   ? AppConstants.whiteColor
//                                   : AppConstants.blackColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
              
//               const SizedBox(height: 12),
              
//               _buildLabel('Hospital/Clinic Name *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: hospitalNameController,
//                 onChanged: (value) {
//                   // Check hospital match whenever user types
//                   _checkHospitalMatch();
//                 },
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                 hintText: 'Enter hospital name',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.local_hospital,
//                     color: AppConstants.primaryColor,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter hospital name';
//                   }
//                   if (value.length < 2) {
//                     return 'Hospital name must be at least 2 characters';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               _buildLabel('Hospital Pin Code *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: hospitalPinCodeController,
//                 keyboardType: TextInputType.number,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: 'Enter pin code',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.location_on,
//                     color: AppConstants.primaryColor,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter pin code';
//                   }
//                   if (value.length != 6) {
//                     return 'Pin code must be 6 digits';
//                   }
                 
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               _buildLabel('Hospital Address *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: hospitalAddressController,
//                 maxLines: 3,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: 'Enter complete hospital address',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.location_city,
//                     color: AppConstants.primaryColor,
//                     size: 20,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter hospital address';
//                   }
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               _buildLabel('Hospital Mobile Number *'),
//               const SizedBox(height: 6),
//               TextFormField(
//                 controller: hospitalMobileController,
//                 keyboardType: TextInputType.phone,
//                 cursorColor: AppConstants.primaryColor,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isDarkMode
//                       ? AppConstants.boxBlackColor
//                       : AppConstants.whiteColor,
//                   hintText: 'Enter hospital mobile number',
//                   hintStyle: TextStyle(color: AppConstants.greyColor),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: AppConstants.primaryColor,
//                       width: 1.6,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.5),
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.phone,
//                     color: AppConstants.primaryColor,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter hospital mobile number';
//                   }
                  
//                   return null;
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               _buildLabel('Hospital Email (Optional)'),
//               const SizedBox(height: 6),
//               _buildCustomTextField(
//                 controller: hospitalEmailController,
//                 hintText: 'Enter hospital email',
//                 prefixIcon: Icons.email,
//                 keyboardType: TextInputType.emailAddress,
//                 isDarkMode: isDarkMode,
//               ),
              
//               const SizedBox(height: 12),
              
//               _buildLabel('Doctor Name (Optional)'),
//               const SizedBox(height: 6),
//               _buildCustomTextField(
//                 controller: doctorNameController,
//                 hintText: 'Enter doctor name',
//                 prefixIcon: Icons.person,
//                 isDarkMode: isDarkMode,
//               ),
              
//               const SizedBox(height: 20),
              
//               // Required Documents Information
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppConstants.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: AppConstants.primaryColor.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           color: AppConstants.primaryColor,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: AppText(
//                             text: 'Required Documents for Insurance Claim Process',
//                             size: 16,
//                             weight: FontWeight.bold,
//                             textColor: AppConstants.primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     AppText(
//                       text: 'To ensure smooth processing of your health insurance claim, please gather all the following documents:',
//                       size: 14,
//                       weight: FontWeight.normal,
//                       textColor: isDarkMode
//                           ? AppConstants.whiteColor
//                           : AppConstants.blackColor,
//                     ),
//                     const SizedBox(height: 12),
//                     ..._buildDocumentList(),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: AppConstants.primaryColor.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: AppConstants.primaryColor.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(
//                             Icons.info,
//                             color: AppConstants.primaryColor,
//                             size: 18,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: AppText(
//                               text: 'Important: Please combine all the above documents into a single file (PDF, JPG, or JPEG) before uploading. This helps in faster processing and reduces the chance of missing documents.',
//                               size: 13,
//                               weight: FontWeight.w500,
//                               textColor: AppConstants.primaryColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Document Upload Section
//               _buildSectionTitle('Upload Document *'),
//               const SizedBox(height: 10),
              
//               // Step 1: Select Document Button
//               InkWell(
//                 onTap: _pickPDFFile,
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.boxBlackColor
//                         : AppConstants.whiteColor,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : AppConstants.primaryColor.withOpacity(0.3),
//                       width: 1.5,
//                       style: BorderStyle.solid,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: isDarkMode
//                             ? Colors.black.withOpacity(0.1)
//                             : Colors.grey.withOpacity(0.05),
//                         spreadRadius: 1,
//                         blurRadius: 2,
//                         offset: const Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.folder_open,
//                         size: 20,
//                         color: AppConstants.primaryColor,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppText(
//                               text: 'Select Document',
//                               size: 15,
//                               weight: FontWeight.w600,
//                               textColor: AppConstants.primaryColor,
//                             ),
//                             AppText(
//                               text: 'PDF, JPG, or JPEG only, max 2MB',
//                               size: 11,
//                               weight: FontWeight.normal,
//                               textColor: AppConstants.greyColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 14,
//                         color: AppConstants.primaryColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               // Show selected file preview (before upload)
//               if (selectedFile != null && !isFileUploaded) ...[
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.boxBlackColor
//                         : Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: Colors.blue.withOpacity(0.5),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           // File Icon
//                           Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Icon(
//                               Icons.insert_drive_file,
//                               color: Colors.blue,
//                               size: 18,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           // File Info
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 AppText(
//                                   text: 'Selected File',
//                                   size: 12,
//                                   weight: FontWeight.w600,
//                                   textColor: Colors.blue,
//                                 ),
//                                 const SizedBox(height: 2),
//                                 AppText(
//                                   text: selectedFile!.name,
//                                   size: 12,
//                                   weight: FontWeight.w500,
//                                   textColor: isDarkMode
//                                       ? AppConstants.whiteColor
//                                       : AppConstants.blackColor,
//                                 ),
//                                 AppText(
//                                   text: 'Size: ${_formatFileSize(selectedFile!.size)}',
//                                   size: 10,
//                                   weight: FontWeight.normal,
//                                   textColor: AppConstants.greyColor,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Remove button
//                           IconButton(
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                             onPressed: () {
//                               setState(() {
//                                 selectedFile = null;
//                                 isFileUploaded = false;
//                               });
//                             },
//                             icon: Icon(
//                               Icons.close,
//                               color: AppConstants.greyColor,
//                               size: 18,
//                             ),
//                             tooltip: 'Remove file',
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       // Step 2: Upload Document Button
//                       CustomButton(
//                         text: 'Upload Document',
//                         onPressed: _uploadSelectedFile,
//                         color: AppConstants.primaryColor,
//                         textColor: AppConstants.whiteColor,
//                         height: 42,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
              
//               // Display uploaded file with green tick mark (after upload)
//               if (isFileUploaded && uploadedDocuments.isNotEmpty) ...[
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.boxBlackColor
//                         : Colors.green.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: Colors.green.withOpacity(0.5),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       // Success Icon
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Icon(
//                           Icons.check_circle,
//                           color: Colors.green,
//                           size: 18,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       // File Info
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppText(
//                               text: 'Document Uploaded Successfully',
//                               size: 13,
//                               weight: FontWeight.w600,
//                               textColor: Colors.green,
//                             ),
//                             const SizedBox(height: 2),
//                             AppText(
//                               text: uploadedDocuments.first,
//                               size: 12,
//                               weight: FontWeight.w500,
//                               textColor: isDarkMode
//                                   ? AppConstants.whiteColor
//                                   : AppConstants.blackColor,
//                             ),
//                             if (uploadedFilesWithSize.containsKey(uploadedDocuments.first))
//                               AppText(
//                                 text: 'Size: ${_formatFileSize(uploadedFilesWithSize[uploadedDocuments.first]!)}',
//                                 size: 10,
//                                 weight: FontWeight.normal,
//                                 textColor: AppConstants.greyColor,
//                               ),
//                           ],
//                         ),
//                       ),
//                       // Remove uploaded document button
//                       IconButton(
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                         onPressed: () {
//                           setState(() {
//                             uploadedDocuments.clear();
//                             uploadedFilesWithSize.clear();
//                             selectedFile = null;
//                             isFileUploaded = false;
//                           });
//                           // ToastMessage.successToast('Document removed successfully');
//                         },
//                         icon: Icon(
//                           Icons.delete_outline,
//                           color: Colors.red,
//                           size: 20,
//                         ),
//                         tooltip: 'Remove document',
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
              
//               const SizedBox(height: 20),
              
//               // Submit Button
//               CustomButton(
//                 text: 'Submit Claim',
//                 onPressed: _submitClaim,
//                 color: AppConstants.primaryColor,
//                 textColor: AppConstants.whiteColor,
//                 height: 55,
//               ),
              
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
//     // Check if title contains asterisk (*)
//     if (title.contains('*')) {
//       final parts = title.split('*');
//       return RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: parts[0],
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: isDarkMode
//                     ? AppConstants.whiteColor
//                     : AppConstants.blackColor,
//               ),
//             ),
//             TextSpan(
//               text: '*',
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             if (parts.length > 1 && parts[1].isNotEmpty)
//               TextSpan(
//                 text: parts[1],
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//           ],
//         ),
//       );
//     }
    
//     return AppText(
//       text: title,
//       size: 18,
//       weight: FontWeight.bold,
//       textColor: isDarkMode
//           ? AppConstants.whiteColor
//           : AppConstants.blackColor,
//     );
//   }

//   Widget _buildLabel(String label) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
//     // Check if label contains asterisk (*)
//     if (label.contains('*')) {
//       final parts = label.split('*');
//       return RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: parts[0],
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isDarkMode
//                     ? AppConstants.whiteColor
//                     : AppConstants.blackColor,
//               ),
//             ),
//             TextSpan(
//               text: '*',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.red,
//               ),
//             ),
//             if (parts.length > 1 && parts[1].isNotEmpty)
//               TextSpan(
//                 text: parts[1],
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//           ],
//         ),
//       );
//     }
    
//     // If no asterisk, return normal AppText
//     return AppText(
//       text: label,
//       size: 14,
//       weight: FontWeight.w600,
//       textColor: isDarkMode
//           ? AppConstants.whiteColor
//           : AppConstants.blackColor,
//     );
//   }

//   List<Widget> _buildDocumentList() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final documents = [
//       'Medical reports and discharge summary',
//       'Prescriptions and medication bills',
//       'Hospital bills and receipts',
//       'Doctor\'s consultation reports',
//       'Lab test results and diagnostic reports',
//       'X-ray/MRI/CT scan reports',
//       'Bank account documents (cancelled cheque/passbook/statement)',
//       'Insurance claim form (if provided separately)',
//       'Any other medical certificates or reports',
//     ];

//     return documents.map((doc) => Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 6, right: 8),
//             width: 4,
//             height: 4,
//             decoration: BoxDecoration(
//               color: AppConstants.primaryColor,
//               shape: BoxShape.circle,
//             ),
//           ),
//           Expanded(
//             child: AppText(
//               text: doc,
//               size: 14,
//               weight: FontWeight.normal,
//               textColor: isDarkMode
//                   ? AppConstants.whiteColor
//                   : AppConstants.blackColor,
//             ),
//           ),
//         ],
//       ),
//     )).toList();
//   }

//   Widget _buildDatePicker({
//     required BuildContext context,
//     required bool isDarkMode,
//     required DateTime? selectedDate,
//     required String dateType,
//     required String placeholder,
//   }) {
//     // Check if this is for pre-post hospitalization and dates are auto-filled
//     bool isReadOnly = (selectedClaimType == 'Pre Post Hospitalization' && 
//                       selectedMainHospitalizationClaim != null && 
//                       selectedMainHospitalizationClaim!.isNotEmpty &&
//                       (dateType == 'admission' || dateType == 'discharge')) ||
//                      // Also make discharge date read-only for Daycare (auto-set to admission date)
//                      (selectedClaimType == 'Daycare' && dateType == 'discharge');
    
//     return InkWell(
//       onTap: isReadOnly ? null : () => _selectDate(context, dateType),
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ),
//         decoration: BoxDecoration(
//           color: isReadOnly 
//               ? (isDarkMode 
//                   ? AppConstants.boxBlackColor.withOpacity(0.5)
//                   : Colors.grey.withOpacity(0.1))
//               : (isDarkMode
//                   ? AppConstants.boxBlackColor
//                   : AppConstants.whiteColor),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isReadOnly
//                 ? (isDarkMode
//                     ? Colors.white.withOpacity(0.05)
//                     : Colors.grey.withOpacity(0.3))
//                 : (isDarkMode
//                     ? Colors.white.withOpacity(0.1)
//                     : AppConstants.primaryColor.withOpacity(0.5)),
//             width: 1,
//           ),
//           boxShadow: isReadOnly ? null : [
//             BoxShadow(
//               color: isDarkMode
//                   ? Colors.black.withOpacity(0.2)
//                   : Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.calendar_today,
//               color: isReadOnly 
//                   ? AppConstants.greyColor.withOpacity(0.6)
//                   : AppConstants.primaryColor,
//               size: 20,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: AppText(
//                 text: selectedDate != null
//                     ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
//                     : placeholder,
//                 size: 16,
//                 weight: FontWeight.normal,
//                 textColor: isReadOnly
//                     ? AppConstants.greyColor.withOpacity(0.7)
//                     : (selectedDate != null
//                         ? (isDarkMode
//                             ? AppConstants.whiteColor
//                             : AppConstants.blackColor)
//                         : AppConstants.greyColor),
//               ),
//             ),
//             if (isReadOnly)
//               Icon(
//                 Icons.lock,
//                 color: AppConstants.greyColor.withOpacity(0.6),
//                 size: 16,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCustomTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData prefixIcon,
//     TextInputType? keyboardType,
//     bool isDarkMode = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       cursorColor: AppConstants.primaryColor,
//       style: TextStyle(
//         fontSize: 16,
//         color: isDarkMode
//             ? AppConstants.whiteColor
//             : AppConstants.blackColor,
//       ),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: isDarkMode
//             ? AppConstants.boxBlackColor
//             : AppConstants.whiteColor,
//         hintText: hintText,
//         hintStyle: TextStyle(color: AppConstants.greyColor),
//          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? Colors.white.withOpacity(0.1)
//                 : AppConstants.primaryColor.withOpacity(0.5),
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: isDarkMode
//                 ? Colors.white.withOpacity(0.1)
//                 : AppConstants.primaryColor.withOpacity(0.5),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: AppConstants.primaryColor,
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           prefixIcon,
//           color: AppConstants.primaryColor,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }

// // Hospital Selection Sheet with Search
// class _HospitalSelectionSheet extends StatefulWidget {
//   final List<Map<String, dynamic>> hospitals;
//   final bool isDarkMode;
//   final String selectedCityName;
//   final String selectedStateName;
//   final Function(Map<String, dynamic>) onHospitalSelected;

//   const _HospitalSelectionSheet({
//     required this.hospitals,
//     required this.isDarkMode,
//     required this.selectedCityName,
//     required this.selectedStateName,
//     required this.onHospitalSelected,
//   });

//   @override
//   State<_HospitalSelectionSheet> createState() => _HospitalSelectionSheetState();
// }

// class _HospitalSelectionSheetState extends State<_HospitalSelectionSheet> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> get _filteredHospitals {
//     if (_searchQuery.isEmpty) return widget.hospitals;
    
//     return widget.hospitals.where((hospital) {
//       final hospitalName = hospital['hospitalName']?.toString().toLowerCase() ?? '';
//       final address = hospital['address1']?.toString().toLowerCase() ?? '';
//       final phone = hospital['phHosp1']?.toString().toLowerCase() ?? '';
//       final pincode = hospital['pincode']?.toString().toLowerCase() ?? '';
//       final query = _searchQuery.toLowerCase();
      
//       return hospitalName.contains(query) || 
//              address.contains(query) || 
//              phone.contains(query) ||
//              pincode.contains(query);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.75,
//       decoration: BoxDecoration(
//         color: widget.isDarkMode
//             ? AppConstants.boxBlackColor
//             : AppConstants.whiteColor,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: AppConstants.primaryColor.withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.local_hospital,
//                       color: AppConstants.primaryColor,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText(
//                             text: 'Select Hospital',
//                             size: 18,
//                             weight: FontWeight.bold,
//                             textColor: AppConstants.primaryColor,
//                           ),
//                           AppText(
//                             text: '${widget.selectedCityName}, ${widget.selectedStateName}',
//                             size: 14,
//                             weight: FontWeight.normal,
//                             textColor: AppConstants.greyColor,
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close, color: AppConstants.greyColor),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 // Search Bar
//                 TextField(
//                   controller: _searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       _searchQuery = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Search hospitals...',
//                     hintStyle: TextStyle(color: AppConstants.greyColor, fontSize: 14),
//                     prefixIcon: Icon(Icons.search, color: AppConstants.greyColor, size: 20),
//                     suffixIcon: _searchQuery.isNotEmpty
//                         ? IconButton(
//                             icon: Icon(Icons.clear, color: AppConstants.greyColor, size: 20),
//                             onPressed: () {
//                               _searchController.clear();
//                               setState(() {
//                                 _searchQuery = '';
//                               });
//                             },
//                           )
//                         : null,
//                     filled: true,
//                     fillColor: widget.isDarkMode
//                         ? AppConstants.darkBackgroundColor
//                         : Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: widget.isDarkMode
//                             ? Colors.white.withOpacity(0.2)
//                             : Colors.grey.withOpacity(0.3),
//                         width: 1,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: widget.isDarkMode
//                             ? Colors.white.withOpacity(0.2)
//                             : Colors.grey.withOpacity(0.3),
//                         width: 1,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: AppConstants.primaryColor,
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                   style: TextStyle(
//                     color: widget.isDarkMode
//                         ? AppConstants.whiteColor
//                         : AppConstants.blackColor,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Hospital List
//           Expanded(
//             child: _filteredHospitals.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.search_off,
//                           size: 60,
//                           color: AppConstants.greyColor,
//                         ),
//                         const SizedBox(height: 12),
//                         AppText(
//                           text: 'No hospitals found',
//                           size: 16,
//                           weight: FontWeight.w500,
//                           textColor: AppConstants.greyColor,
//                         ),
//                         const SizedBox(height: 4),
//                         AppText(
//                           text: 'Try a different search term',
//                           size: 14,
//                           weight: FontWeight.normal,
//                           textColor: AppConstants.greyColor,
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _filteredHospitals.length,
//                     itemBuilder: (context, index) {
//                       final hospital = _filteredHospitals[index];
//                       return _buildHospitalItem(hospital);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHospitalItem(Map<String, dynamic> hospital) {
//     return InkWell(
//       onTap: () => widget.onHospitalSelected(hospital),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: widget.isDarkMode
//               ? AppConstants.darkBackgroundColor
//               : AppConstants.whiteColor,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: widget.isDarkMode
//                 ? Colors.white.withOpacity(0.1)
//                 : Colors.grey.withOpacity(0.2),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hospital Icon
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: AppConstants.primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Icon(
//                 Icons.local_hospital,
//                 color: AppConstants.primaryColor,
//                 size: 18,
//               ),
//             ),
//             const SizedBox(width: 10),
            
//             // Hospital Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Hospital Name and Preferred Badge
//                   Row(
//                     children: [
//                       Expanded(
//                         child: AppText(
//                           text: hospital['hospitalName'] ?? 'Hospital Name Not Available',
//                           size: 14,
//                           weight: FontWeight.w600,
//                           textColor: widget.isDarkMode
//                               ? AppConstants.whiteColor
//                               : AppConstants.blackColor,
//                         ),
//                       ),
//                       if (hospital['preferredYN'] == 'Y')
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: AppConstants.greenColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: AppText(
//                             text: 'Preferred',
//                             size: 9,
//                             weight: FontWeight.w500,
//                             textColor: AppConstants.greenColor,
//                           ),
//                         ),
//                     ],
//                   ),
                  
//                   // Address
//                   if (hospital['address1'] != null && hospital['address1'].toString().isNotEmpty) ...[
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, size: 12, color: AppConstants.greyColor),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: AppText(
//                             text: hospital['address1'],
//                             size: 11,
//                             weight: FontWeight.normal,
//                             textColor: AppConstants.greyColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
                  
//                   // Phone and Pincode in same row
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       if (hospital['phHosp1'] != null && hospital['phHosp1'].toString().isNotEmpty)
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Icon(Icons.phone, size: 12, color: AppConstants.greyColor),
//                               const SizedBox(width: 4),
//                               Flexible(
//                                 child: AppText(
//                                   text: hospital['phHosp1'],
//                                   size: 11,
//                                   weight: FontWeight.normal,
//                                   textColor: AppConstants.greyColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       if (hospital['pincode'] != null && hospital['pincode'].toString().isNotEmpty) ...[
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: AppConstants.primaryColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: AppText(
//                             text: 'PIN: ${hospital['pincode']}',
//                             size: 10,
//                             weight: FontWeight.w500,
//                             textColor: AppConstants.primaryColor,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             // Arrow Icon
//             const SizedBox(width: 8),
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 14,
//               color: AppConstants.primaryColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
