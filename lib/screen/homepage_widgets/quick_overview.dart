import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/claim_provider.dart';
import 'package:norkacare_app/provider/notification_provider.dart';

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
  void initState() {
    super.initState();
    // Fetch notification when widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotification();
    });
  }

  void _fetchNotification() async {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    await notificationProvider.fetchNotification();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Consumer4<VerificationProvider, NorkaProvider, ClaimProvider, NotificationProvider>(
      builder: (context, verificationProvider, norkaProvider, claimProvider, notificationProvider, child) {
        // Payment history is preloaded during shimmer phase, no need for build-time loading
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Quick Overview',
                    size: 18,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          color: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.primaryColor,
                          size: 26,
                        ),
                        // Red dot indicator when notification is not empty
                        if (notificationProvider.notificationMessage.trim().isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode
                                      ? AppConstants.darkBackgroundColor
                                      : Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      _showNotificationDialog(
                        context,
                        isDarkMode,
                        notificationProvider.notificationMessage,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
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

  void _showNotificationDialog(BuildContext context, bool isDarkMode, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotificationDialog(
          isDarkMode: isDarkMode,
          message: message,
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
      constraints: const BoxConstraints(
        minHeight: 140,
        maxHeight: 140,
      ),
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
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
          Flexible(
            child: AppText(
              text: value,
              size: 16,
              weight: FontWeight.bold,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            text: title,
            size: 12,
            weight: FontWeight.w500,
            textColor: isDarkMode
                ? AppConstants.greyColor.withOpacity(0.8)
                : AppConstants.greyColor,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

// Notification Dialog Widget
class NotificationDialog extends StatefulWidget {
  final bool isDarkMode;
  final String message;

  const NotificationDialog({
    super.key,
    required this.isDarkMode,
    required this.message,
  });

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  bool _isExpanded = false;

  /// Check if the notification text is long enough to need expansion
  bool _shouldShowExpandButton() {
    // Count newlines in the message
    final newlineCount = '\n'.allMatches(widget.message).length;
    
    // Estimate characters per line (approximately 40-50 chars per line at font size 14)
    // With line height 1.5 and dialog width, roughly 45 characters fit per line
    const int approximateCharsPerLine = 45;
    const int maxLinesBeforeExpand = 5;
    
    // Show button if:
    // 1. There are 5 or more newlines (meaning 6+ lines)
    // 2. OR the total length suggests it would exceed 5 lines
    return newlineCount >= maxLinesBeforeExpand || 
           widget.message.length > (approximateCharsPerLine * maxLinesBeforeExpand);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: widget.isDarkMode
          ? AppConstants.darkBackgroundColor
          : Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppConstants.darkBackgroundColor
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppConstants.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    text: 'Notifications',
                    size: 20,
                    weight: FontWeight.bold,
                    textColor: widget.isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: widget.isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            
            // Notification Content - Only show if message is not empty
            if (widget.message.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification text
                    Text.rich(
                      TextSpan(
                        text: widget.message,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: widget.isDarkMode
                              ? AppConstants.greyColor
                              : Colors.grey[700]!,
                          height: 1.5,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      maxLines: _isExpanded ? null : 5,
                      overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    
                    // Show More/Less button - only show if text exceeds 5 lines
                    if (_shouldShowExpandButton())
                      ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isExpanded ? 'Show Less' : 'Show More',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppConstants.primaryColor,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppConstants.primaryColor,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                  ],
                ),
              ),
            ],
            
            // Show message when no notifications
            if (widget.message.isEmpty) ...[
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 60,
                      color: AppConstants.greyColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      text: 'No notifications',
                      size: 16,
                      weight: FontWeight.w500,
                      textColor: AppConstants.greyColor,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
