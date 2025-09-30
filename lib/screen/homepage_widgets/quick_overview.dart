import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';

class QuickOverview extends StatefulWidget {
  final Map<String, dynamic> customerInsuranceData;

  const QuickOverview({super.key, required this.customerInsuranceData});

  @override
  State<QuickOverview> createState() => _QuickOverviewState();
}

class _QuickOverviewState extends State<QuickOverview> {
  // Payment history is now preloaded during shimmer phase in homepage
  // No need for complex loading logic here

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Consumer2<VerificationProvider, NorkaProvider>(
      builder: (context, verificationProvider, norkaProvider, child) {
        // Payment history is preloaded during shimmer phase, no need for build-time loading
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Quick Overview',
                size: 18,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Claimed Amount',
                      value: '₹0',
                      icon: Icons.receipt_long,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Balance Coverage',
                      value: "₹500,000",
                      icon: Icons.security,
                      color: AppConstants.greenColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Enrollment Fee',
                      value: _getPremiumAmountFromPaymentHistory(
                        verificationProvider.paymentHistory,
                      ),
                      icon: Icons.payment,
                      color: AppConstants.orangeColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Pending Claims',
                      value:
                          '${widget.customerInsuranceData['quickStats']['pendingClaims'] ?? 0}',
                      icon: Icons.pending_actions,
                      color: AppConstants.redColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Get premium amount from payment history (same as payment details page)
  String _getPremiumAmountFromPaymentHistory(Map<String, dynamic> paymentData) {
    if (paymentData.isEmpty) {
      return '₹0';
    }

    // Check if payment history has data
    if (paymentData.containsKey('data') && paymentData['data'] is List) {
      final transactions = paymentData['data'] as List<dynamic>;

      if (transactions.isNotEmpty) {
        // Get the latest transaction (first in the list)
        final latestTransaction = transactions.first as Map<String, dynamic>;

        // Extract amount from transaction (same logic as payment details page)
        final amount = latestTransaction['amount'] as int? ?? 0;

        // Convert from paise to rupees (same as payment details page)
        final amountInRupees = amount / 100;

        return '₹${amountInRupees.toStringAsFixed(0)}';
      }
    }

    return '₹0';
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          AppText(
            text: value,
            size: 18,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text: title,
            size: 12,
            weight: FontWeight.w500,
            textColor: isDarkMode
                ? AppConstants.greyColor.withOpacity(0.8)
                : AppConstants.greyColor,
          ),
        ],
      ),
    );
  }
}
