import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text.dart';
import '../../provider/verification_provider.dart';
import 'transaction_details_page.dart';

class PaymentDetailsPage extends StatefulWidget {
  final String nrkId;
  const PaymentDetailsPage({super.key, required this.nrkId});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  static const String policyNumber = '763300/25-26/NORKACARE/001';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPaymentHistory();
    });
  }

  Future<void> _loadPaymentHistory() async {
    final provider = context.read<VerificationProvider>();

    // Only show loading if we haven't loaded before
    if (!provider.hasPaymentHistoryLoadedOnce) {
      await provider.getPaymentHistoryWithOfflineFallback(widget.nrkId);
    }
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
      body: Consumer<VerificationProvider>(
        builder: (context, verificationProvider, child) {
          // Debug information
          print(
            'Payment Debug - hasLoadedOnce: ${verificationProvider.hasPaymentHistoryLoadedOnce}',
          );
          print(
            'Payment Debug - isLoading: ${verificationProvider.isPaymentHistoryLoading}',
          );
          print(
            'Payment Debug - paymentHistory: ${verificationProvider.paymentHistory}',
          );

          if (!verificationProvider.hasPaymentHistoryLoadedOnce &&
              verificationProvider.isPaymentHistoryLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppConstants.primaryColor),
                ],
              ),
            );
          }

          final paymentHistory = verificationProvider.paymentHistory;
          final transactions = paymentHistory['data'] as List<dynamic>? ?? [];

          print('Payment Debug - transactions: $transactions');

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 64, color: AppConstants.greyColor),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'No Payment History Found',
                    size: 18,
                    weight: FontWeight.w600,
                    textColor: AppConstants.greyColor,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: 'Your payment history will appear here',
                    size: 14,
                    weight: FontWeight.w400,
                    textColor: AppConstants.greyColor,
                  ),
                ],
              ),
            );
          }

          return _buildTransactionsTab(transactions);
        },
      ),
    );
  }

  Widget _buildTransactionsTab(List<dynamic> transactions) {
    // Sort transactions by date (newest first)
    final sortedTransactions = List<Map<String, dynamic>>.from(transactions);
    sortedTransactions.sort((a, b) {
      final dateA = DateTime.parse(a['created_at']);
      final dateB = DateTime.parse(b['created_at']);
      return dateB.compareTo(dateA);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedTransactions.length,
      itemBuilder: (context, index) {
        final transaction = sortedTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Parse the transaction data from API response
    final rzpPayload =
        transaction['rzp_payload'] as Map<String, dynamic>? ?? {};
    final status = rzpPayload['status'] as String? ?? 'unknown';
    final amount = transaction['amount'] as int? ?? 0;
    final method = transaction['method'] as String? ?? 'unknown';
    final createdAt = transaction['created_at'] as String? ?? '';

    // Check if this is a failed payment (no rzp_payload or status is not captured)
    final isFailedPayment = rzpPayload.isEmpty || status != 'captured';

    // Format amount to Indian currency
    final formattedAmount = '₹${(amount / 100).toStringAsFixed(0)}';

    // Format date and time in Indian timezone (IST)
    String formattedDate = '';
    if (createdAt.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(createdAt);
        // Convert to Indian timezone (UTC+5:30)
        final indianTime = dateTime.toUtc().add(
          const Duration(hours: 5, minutes: 30),
        );
        formattedDate =
            '${indianTime.day.toString().padLeft(2, '0')}/${indianTime.month.toString().padLeft(2, '0')}/${indianTime.year} ${indianTime.hour.toString().padLeft(2, '0')}:${indianTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedDate = 'Invalid Date';
      }
    }

    // Format payment method
    final formattedMethod = method.toUpperCase();

    Color statusColor;
    String statusText;

    // Handle failed payments
    if (isFailedPayment) {
      statusColor = AppConstants.redColor;
      statusText = 'Failed';
    } else {
      switch (status) {
        case 'captured':
          statusColor = AppConstants.greenColor;
          statusText = 'Successful';
          break;
        case 'pending':
          statusColor = AppConstants.orangeColor;
          statusText = 'Pending';
          break;
        case 'failed':
          statusColor = AppConstants.redColor;
          statusText = 'Failed';
          break;
        default:
          statusColor = AppConstants.greyColor;
          statusText = status.toUpperCase();
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionDetailsPage(transaction: transaction),
          ),
        );
      },
      child: Container(
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
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isFailedPayment
                    ? AppConstants.redColor.withOpacity(0.1)
                    : AppConstants.greenColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isFailedPayment ? Icons.payment : Icons.check_circle,
                color: isFailedPayment
                    ? AppConstants.redColor
                    : AppConstants.greenColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Transaction details
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
                    text: formattedDate,
                    size: 14,
                    weight: FontWeight.w400,
                    textColor: AppConstants.greyColor,
                  ),
                ],
              ),
            ),

            // Amount and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: formattedAmount,
                  size: 16,
                  weight: FontWeight.w700,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: statusText,
                  size: 12,
                  weight: FontWeight.w500,
                  textColor: statusColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Expanded(
            child: AppText(
              text: value,
              size: 14,
              weight: FontWeight.w400,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
