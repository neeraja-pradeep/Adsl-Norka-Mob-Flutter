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
 