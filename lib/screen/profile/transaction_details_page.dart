import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text.dart';
import 'customer_support_page.dart';

class TransactionDetailsPage extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsPage({super.key, required this.transaction});

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  static const String policyNumber = '763300/25-26/NORKACARE/001';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Check if this is a bulk upload payment
    final isBulkUpload = widget.transaction['is_bulk_upload'] == true;

    // Parse the transaction data
    final rzpPayload =
        widget.transaction['rzp_payload'] as Map<String, dynamic>? ?? {};
    
    // Get payment type (federal or razorpay)
    final paymentType = widget.transaction['payment_type'] as String? ?? '';
    
    // Get status - check transaction level first (for Federal Bank), then rzp_payload (for Razorpay)
    String status = widget.transaction['status'] as String? ?? 
                    rzpPayload['status'] as String? ?? 
                    'unknown';
    
    final amount = widget.transaction['amount'] as int? ?? 0;
    final createdAt = widget.transaction['created_at'] as String? ?? '';
    final transactionId = widget.transaction['payment_id']?.toString() ?? '';
    final orderId = widget.transaction['order']?.toString() ?? '';

    // Check if this is a failed payment
    // For Federal Bank: check transaction-level status
    // For Razorpay: check rzp_payload status
    // But don't mark bulk uploads as failed
    final isFailedPayment = !isBulkUpload && (
      (paymentType == 'federal' && status != 'captured') ||
      (paymentType == 'razorpay' && (rzpPayload.isEmpty || rzpPayload['status'] != 'captured')) ||
      (paymentType.isEmpty && (rzpPayload.isEmpty || status != 'captured'))
    );

    // Format amount to Indian currency
    final formattedAmount = '₹${(amount / 100).toStringAsFixed(2)}';

    // Format date and time in Indian timezone (IST)
    String formattedDate = '';
    if (createdAt.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(createdAt);
        // For bulk uploads, show only date
        if (isBulkUpload) {
          formattedDate =
              '${dateTime.day.toString().padLeft(2, '0')} ${_getMonthName(dateTime.month)} ${dateTime.year}';
        } else {
          final indianTime = dateTime.toUtc().add(
            const Duration(hours: 5, minutes: 30),
          );
          formattedDate =
              '${indianTime.day.toString().padLeft(2, '0')} ${_getMonthName(indianTime.month)}, ${indianTime.hour.toString().padLeft(2, '0')}:${indianTime.minute.toString().padLeft(2, '0')} ${indianTime.hour >= 12 ? 'PM' : 'AM'}';
        }
      } catch (e) {
        formattedDate = 'Invalid Date';
      }
    }

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
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
          onPressed: () => Navigator.of(context).pop(),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppConstants.boxBlackColor
                : AppConstants.whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Amount Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'Total Amount',
                        size: 14,
                        weight: FontWeight.w500,
                        textColor: AppConstants.greyColor,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        text: formattedAmount,
                        size: 24,
                        weight: FontWeight.w700,
                        textColor: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isBulkUpload
                          ? AppConstants.primaryColor
                          : (isFailedPayment
                              ? AppConstants.redColor
                              : AppConstants.greenColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: AppText(
                      text: isBulkUpload
                          ? 'Payment Successful'
                          : (isFailedPayment
                              ? 'Payment Failed'
                              : 'Payment Successful'),
                      size: 10,
                      weight: FontWeight.w500,
                      textColor: AppConstants.whiteColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Service Details Section
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.payment,
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
                          text: 'Enrollment Fee',
                          size: 16,
                          weight: FontWeight.w600,
                          textColor: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: 'Norka Care Enrollment Payment',
                          size: 14,
                          weight: FontWeight.w400,
                          textColor: AppConstants.greyColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Payment Status Section
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isBulkUpload
                          ? AppConstants.primaryColor
                          : (isFailedPayment
                              ? AppConstants.redColor
                              : AppConstants.greenColor),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isBulkUpload
                          ? Icons.payments
                          : (isFailedPayment ? Icons.close : Icons.check),
                      color: AppConstants.whiteColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: isBulkUpload
                              ? 'Enrollment Fee Payment'
                              : (isFailedPayment
                                  ? 'Payment To Norka Care Failed'
                                  : 'Payment To Norka Care Successful'),
                          size: 16,
                          weight: FontWeight.w600,
                          textColor: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          text: formattedDate,
                          size: 14,
                          weight: FontWeight.w400,
                          textColor: AppConstants.greyColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Transaction IDs Section
              // For Federal Bank: show only Order ID (Payment ID might be missing)
              // For Razorpay: show both Payment ID and Order ID
              if (paymentType == 'federal') ...[
                // Federal Bank - show Order ID only
                if (orderId.isNotEmpty && orderId != 'null') ...[
                  _buildTransactionIdRow('Order ID', orderId, isDarkMode),
                ] else if (transactionId.isNotEmpty && transactionId != 'null') ...[
                  // Fallback to transaction ID if order ID is not available
                  _buildTransactionIdRow('Transaction ID', transactionId, isDarkMode),
                ],
              ] else ...[
                // Razorpay or other - show Payment ID and Order ID
                if (transactionId.isNotEmpty && transactionId != 'null') ...[
              _buildTransactionIdRow('Payment ID', transactionId, isDarkMode),
                ],
                if (orderId.isNotEmpty && orderId != 'null') ...[
                  const SizedBox(height: 16),
                  _buildTransactionIdRow('Order ID', orderId, isDarkMode),
                ],
              ],

              const SizedBox(height: 16),

              _buildTransactionIdRow('Policy Number', policyNumber, isDarkMode),

              // // Show bulk upload details if available
              // if (isBulkUpload && bulkUploadDetails != null) ...[
              //   const SizedBox(height: 24),
              //   AppText(
              //     text: 'Bulk Upload Information',
              //     size: 16,
              //     weight: FontWeight.w600,
              //     textColor: isDarkMode
              //         ? AppConstants.whiteColor
              //         : AppConstants.blackColor,
              //   ),
              //   const SizedBox(height: 12),
              //   _buildTransactionIdRow(
              //     'Association',
              //     bulkUploadDetails['association']?.toString() ?? 'N/A',
              //     isDarkMode,
              //   ),
              //   const SizedBox(height: 12),
              //   _buildTransactionIdRow(
              //     'Location',
              //     bulkUploadDetails['association_location']?.toString() ?? 'N/A',
              //     isDarkMode,
              //   ),
              //   const SizedBox(height: 12),
              //   _buildTransactionIdRow(
              //     'Country',
              //     bulkUploadDetails['country']?.toString() ?? 'N/A',
              //     isDarkMode,
              //   ),
              //   const SizedBox(height: 12),
              //   _buildTransactionIdRow(
              //     'City',
              //     bulkUploadDetails['city']?.toString() ?? 'N/A',
              //     isDarkMode,
              //   ),
              // ],

              const SizedBox(height: 32),

              // Contact Support Section
              GestureDetector(
                onTap: () {
                  // Navigate to customer support
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerSupportPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: AppConstants.whiteColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Contact Customer Support',
                              size: 16,
                              weight: FontWeight.w600,
                              textColor: isDarkMode
                                  ? AppConstants.whiteColor
                                  : AppConstants.blackColor,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                AppText(
                                  text: '24X7',
                                  size: 14,
                                  weight: FontWeight.w500,
                                  textColor: AppConstants.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                AppText(
                                  text: 'Available',
                                  size: 14,
                                  weight: FontWeight.w400,
                                  textColor: AppConstants.primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppConstants.greyColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionIdRow(String label, String value, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: AppText(
            text: label,
            size: 14,
            weight: FontWeight.w500,
            textColor: AppConstants.greyColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AppText(
                  text: value,
                  size: 14,
                  weight: FontWeight.w400,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
              if (value != 'N/A' && value != policyNumber) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.copy,
                      color: AppConstants.greyColor,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
