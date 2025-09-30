// import 'package:flutter/material.dart';
// import 'package:norkacare_app/utils/constants.dart';
// import 'package:norkacare_app/widgets/app_text.dart';
// import 'package:norkacare_app/widgets/custom_button.dart';

// class ActivePolicies extends StatelessWidget {
//   final Map<String, dynamic> customerInsuranceData;

//   const ActivePolicies({super.key, required this.customerInsuranceData});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AppText(
//             text: 'Active Policies',
//             size: 18,
//             weight: FontWeight.bold,
//             textColor: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//           ),
//           const SizedBox(height: 15),
//           ...customerInsuranceData['activePolicies'].map<Widget>((policy) {
//             return _buildPolicyCard(context, policy);
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPolicyCard(BuildContext context, Map<String, dynamic> policy) {
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: AppText(
//                   text: policy['policyType'],
//                   size: 16,
//                   weight: FontWeight.bold,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: AppConstants.greenColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: AppText(
//                   text: policy['status'],
//                   size: 12,
//                   weight: FontWeight.w600,
//                   textColor: AppConstants.greenColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           AppText(
//             text: 'Policy: ${policy['policyNumber']}',
//             size: 14,
//             weight: FontWeight.w500,
//             textColor: isDarkMode
//                 ? AppConstants.greyColor.withOpacity(0.8)
//                 : AppConstants.greyColor,
//           ),
//           const SizedBox(height: 4),
//           AppText(
//             text: policy['insuranceCompany'],
//             size: 14,
//             weight: FontWeight.w500,
//             textColor: isDarkMode
//                 ? AppConstants.greyColor.withOpacity(0.8)
//                 : AppConstants.greyColor,
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildPolicyInfo(
//                   context,
//                   label: 'Coverage',
//                   value: policy['coverage'],
//                   icon: Icons.security,
//                 ),
//               ),
//               Expanded(
//                 child: _buildPolicyInfo(
//                   context,
//                   label: 'Premium',
//                   value: policy['premium'],
//                   icon: Icons.payment,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildPolicyInfo(
//                   context,
//                   label: 'Start Date',
//                   value: policy['startDate'],
//                   icon: Icons.calendar_today,
//                 ),
//               ),
//               Expanded(
//                 child: _buildPolicyInfo(
//                   context,
//                   label: 'Next Due',
//                   value: policy['nextDueDate'],
//                   icon: Icons.schedule,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: CustomButton(
//                   text: 'View Details',
//                   onPressed: () {
//                     _showPolicyDetails(context, policy);
//                   },
//                   color: AppConstants.primaryColor,
//                   textColor: AppConstants.whiteColor,
//                   height: 40,
//                 ),
//               ),
//               // const SizedBox(width: 12),
//               // Expanded(
//               //   child: CustomButton(
//               //     text: 'File Claim',
//               //     onPressed: () {
//               //       ScaffoldMessenger.of(
//               //         context,
//               //       ).showSnackBar(const SnackBar(content: Text('File Claim')));
//               //     },
//               //     color: AppConstants.secondaryColor,
//               //     textColor: AppConstants.blackColor,
//               //     height: 40,
//               //   ),
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPolicyInfo(
//     BuildContext context, {
//     required String label,
//     required String value,
//     required IconData icon,
//   }) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: isDarkMode
//               ? AppConstants.greyColor.withOpacity(0.8)
//               : AppConstants.greyColor,
//         ),
//         const SizedBox(width: 4),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 text: label,
//                 size: 12,
//                 weight: FontWeight.w500,
//                 textColor: isDarkMode
//                     ? AppConstants.greyColor.withOpacity(0.8)
//                     : AppConstants.greyColor,
//               ),
//               AppText(
//                 text: value,
//                 size: 14,
//                 weight: FontWeight.w600,
//                 textColor: isDarkMode
//                     ? AppConstants.whiteColor
//                     : AppConstants.blackColor,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _showPolicyDetails(BuildContext context, Map<String, dynamic> policy) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: AppText(
//             text: policy['policyType'],
//             size: 20,
//             weight: FontWeight.bold,
//             textColor: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildDetailRow(
//                   context,
//                   'Policy Number',
//                   policy['policyNumber'],
//                 ),
//                 _buildDetailRow(
//                   context,
//                   'Insurance Company',
//                   policy['insuranceCompany'],
//                 ),
//                 _buildDetailRow(context, 'Start Date', policy['startDate']),
//                 _buildDetailRow(context, 'End Date', policy['endDate']),
//                 _buildDetailRow(context, 'Coverage Amount', policy['coverage']),
//                 _buildDetailRow(context, 'Premium Amount', policy['premium']),
//                 _buildDetailRow(
//                   context,
//                   'Next Due Date',
//                   policy['nextDueDate'],
//                 ),
//                 _buildDetailRow(context, 'Status', policy['status']),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: AppText(
//                 text: 'Close',
//                 size: 16,
//                 weight: FontWeight.w500,
//                 textColor: AppConstants.greyColor,
//               ),
//             ),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.of(context).pop();
//             //     ScaffoldMessenger.of(
//             //       context,
//             //     ).showSnackBar(const SnackBar(content: Text('File Claim')));
//             //   },
//             //   style: ElevatedButton.styleFrom(
//             //     backgroundColor: AppConstants.primaryColor,
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(8),
//             //     ),
//             //   ),
//             //   child: AppText(
//             //     text: 'File Claim',
//             //     size: 16,
//             //     weight: FontWeight.w500,
//             //     textColor: AppConstants.whiteColor,
//             //   ),
//             // ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildDetailRow(BuildContext context, String label, String value) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: AppText(
//               text: label,
//               size: 14,
//               weight: FontWeight.w600,
//               textColor: isDarkMode
//                   ? AppConstants.greyColor.withOpacity(0.8)
//                   : AppConstants.greyColor,
//             ),
//           ),
//           Expanded(
//             child: AppText(
//               text: value,
//               size: 14,
//               weight: FontWeight.w500,
//               textColor: isDarkMode
//                   ? AppConstants.whiteColor
//                   : AppConstants.blackColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
