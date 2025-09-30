import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';

class RecentClaims extends StatelessWidget {
  final Map<String, dynamic> customerInsuranceData;

  const RecentClaims({super.key, required this.customerInsuranceData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Recent Claims',
            size: 18,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          const SizedBox(height: 15),
          ...customerInsuranceData['recentClaims'].map<Widget>((claim) {
            return _buildClaimCard(context, claim);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildClaimCard(BuildContext context, Map<String, dynamic> claim) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color statusColor = claim['status'] == 'Approved'
        ? AppConstants.greenColor
        : AppConstants.orangeColor;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  text: claim['policyType'],
                  size: 16,
                  weight: FontWeight.bold,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  text: claim['status'],
                  size: 12,
                  weight: FontWeight.w600,
                  textColor: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            text: 'Claim: ${claim['claimNumber']}',
            size: 14,
            weight: FontWeight.w500,
            textColor: isDarkMode
                ? AppConstants.greyColor.withOpacity(0.8)
                : AppConstants.greyColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text: claim['description'],
            size: 14,
            weight: FontWeight.w500,
            textColor: isDarkMode
                ? AppConstants.greyColor.withOpacity(0.8)
                : AppConstants.greyColor,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Amount',
                    size: 12,
                    weight: FontWeight.w500,
                    textColor: isDarkMode
                        ? AppConstants.greyColor.withOpacity(0.8)
                        : AppConstants.greyColor,
                  ),
                  AppText(
                    text: claim['claimAmount'],
                    size: 16,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    text: 'Date',
                    size: 12,
                    weight: FontWeight.w500,
                    textColor: isDarkMode
                        ? AppConstants.greyColor.withOpacity(0.8)
                        : AppConstants.greyColor,
                  ),
                  AppText(
                    text: claim['date'],
                    size: 14,
                    weight: FontWeight.w600,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
