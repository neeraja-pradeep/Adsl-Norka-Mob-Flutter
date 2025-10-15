import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/claim_provider.dart';

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
    return Consumer3<VerificationProvider, NorkaProvider, ClaimProvider>(
      builder: (context, verificationProvider, norkaProvider, claimProvider, child) {
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
                      value: _getClaimedSettledAmount(claimProvider.claims),
                      icon: Icons.receipt_long,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Balance Coverage',
                      value: _calculateBalanceCoverage(claimProvider.claims),
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
                      title: 'Total Claims',
                      value: '${claimProvider.claims.length}',
                      icon: Icons.flag_rounded,
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

  /// Get premium amount from payment history (updated for unified API)
  String _getPremiumAmountFromPaymentHistory(Map<String, dynamic> paymentData) {
    if (paymentData.isEmpty) {
      return '₹0';
    }

    // Priority 1: Check for successful bulk upload payment first
    if (paymentData.containsKey('bulk_upload_info') && 
        paymentData['bulk_upload_info'] != null &&
        paymentData.containsKey('premium_breakdown') &&
        paymentData['premium_breakdown'] != null) {
      final premiumBreakdown = paymentData['premium_breakdown'] as Map<String, dynamic>;
      
      if (premiumBreakdown.containsKey('total_amount')) {
        final totalAmount = premiumBreakdown['total_amount'] as num? ?? 0;
        return '₹${totalAmount.toStringAsFixed(0)}';
      }
    }

    // Priority 2: Check for successful Razorpay payments (unified API structure)
    if (paymentData.containsKey('payments') && paymentData['payments'] is List) {
      final transactions = paymentData['payments'] as List<dynamic>;

      if (transactions.isNotEmpty) {
        // Look for successful transactions first
        for (final transaction in transactions) {
          final transactionData = transaction as Map<String, dynamic>;
          final rzpPayload = transactionData['rzp_payload'] as Map<String, dynamic>? ?? {};
          final status = rzpPayload['status'] as String? ?? 'unknown';
          
          // If we find a successful transaction, use it
          if (status == 'captured') {
            final amount = transactionData['amount'] as int? ?? 0;
            final amountInRupees = amount / 100;
            return '₹${amountInRupees.toStringAsFixed(0)}';
          }
        }
        
        // If no successful transactions found, use the latest one (even if failed)
        final latestTransaction = transactions.first as Map<String, dynamic>;
        final amount = latestTransaction['amount'] as int? ?? 0;
        final amountInRupees = amount / 100;
        return '₹${amountInRupees.toStringAsFixed(0)}';
      }
    }

    // Priority 3: Fallback to old API response structure (data array)
    if (paymentData.containsKey('data') && paymentData['data'] is List) {
      final transactions = paymentData['data'] as List<dynamic>;

      if (transactions.isNotEmpty) {
        // Look for successful transactions first
        for (final transaction in transactions) {
          final transactionData = transaction as Map<String, dynamic>;
          final rzpPayload = transactionData['rzp_payload'] as Map<String, dynamic>? ?? {};
          final status = rzpPayload['status'] as String? ?? 'unknown';
          
          // If we find a successful transaction, use it
          if (status == 'captured') {
            final amount = transactionData['amount'] as int? ?? 0;
            final amountInRupees = amount / 100;
            return '₹${amountInRupees.toStringAsFixed(0)}';
          }
        }
        
        // If no successful transactions found, use the latest one (even if failed)
        final latestTransaction = transactions.first as Map<String, dynamic>;
        final amount = latestTransaction['amount'] as int? ?? 0;
        final amountInRupees = amount / 100;
        return '₹${amountInRupees.toStringAsFixed(0)}';
      }
    }

    return '₹0';
  }

  /// Get claimed settled amount from claims data
  String _getClaimedSettledAmount(List<dynamic> claims) {
    if (claims.isEmpty) {
      return '₹0';
    }

    double totalSettledAmount = 0.0;

    for (final claim in claims) {
      final claimData = claim as Map<String, dynamic>;
      
      // Check if claim is paid and has approved amount
      final status = claimData['status']?.toString().toLowerCase() ?? '';
      final approvedAmountStr = claimData['approvedAmount']?.toString() ?? '';
      
      // Consider claims as settled if status is 'paid' (as per API)
      if (status == 'paid' && 
          approvedAmountStr.isNotEmpty && 
          approvedAmountStr != '0') {
        
        try {
          final approvedAmount = double.parse(approvedAmountStr);
          if (approvedAmount > 0) {
            totalSettledAmount += approvedAmount;
          }
        } catch (e) {
          debugPrint('Error parsing approved amount: $approvedAmountStr');
        }
      }
    }

    return '₹${totalSettledAmount.toStringAsFixed(0)}';
  }

  /// Calculate balance coverage (Total Coverage - Claimed Amount)
  String _calculateBalanceCoverage(List<dynamic> claims) {
    // Total coverage is fixed at ₹500,000
    const double totalCoverage = 500000.0;
    
    if (claims.isEmpty) {
      return '₹${totalCoverage.toStringAsFixed(0)}';
    }

    double totalSettledAmount = 0.0;

    for (final claim in claims) {
      final claimData = claim as Map<String, dynamic>;
      
      // Check if claim is paid and has approved amount
      final status = claimData['status']?.toString().toLowerCase() ?? '';
      final approvedAmountStr = claimData['approvedAmount']?.toString() ?? '';
      
      // Consider claims as settled if status is 'paid'
      if (status == 'paid' && 
          approvedAmountStr.isNotEmpty && 
          approvedAmountStr != '0') {
        
        try {
          final approvedAmount = double.parse(approvedAmountStr);
          if (approvedAmount > 0) {
            totalSettledAmount += approvedAmount;
          }
        } catch (e) {
          debugPrint('Error parsing approved amount: $approvedAmountStr');
        }
      }
    }

    // Calculate balance: Total - Claimed
    double balanceCoverage = totalCoverage - totalSettledAmount;
    
    // Ensure balance doesn't go negative
    if (balanceCoverage < 0) {
      balanceCoverage = 0;
    }

    return '₹${balanceCoverage.toStringAsFixed(0)}';
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
