import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:provider/provider.dart';
import '../../provider/norka_provider.dart';

class WelcomeSection extends StatefulWidget {
  final Map<String, dynamic> customerInsuranceData;

  const WelcomeSection({super.key, required this.customerInsuranceData});

  @override
  State<WelcomeSection> createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid setState during build (same as family members page)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() async {
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    // Only load data if we haven't loaded before (same pattern as family members)
    if (!norkaProvider.hasUserDataLoadedOnce) {
      await norkaProvider.loadUserDataIfNeeded();
    }
  }

  // String _extractName(BuildContext context) {
  //   // Get data from NORKA provider
  //   final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
  //   String name = 'Customer'; // Default fallback

  //   if (norkaProvider.response != null &&
  //       norkaProvider.response!['name'] != null) {
  //     name = norkaProvider.response!['name'];
  //   } else {
  //     // Fallback to customerInsuranceData if no API data
  //     name = widget.customerInsuranceData['customerInfo']['name'] ?? 'Customer';
  //   }

  //   // Return the name as received from NORKA API (no formatting)
  //   return name;
  // }

  String _extractCustomerId(BuildContext context) {
    // Get NORKA ID from provider
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    if (norkaProvider.norkaId.isNotEmpty) {
      return norkaProvider.norkaId;
    } else {
      // Fallback to customerInsuranceData if no stored NORKA ID
      return widget.customerInsuranceData['customerInfo']['customerId'] ??
          'Unknown ID';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NorkaProvider>(
      builder: (context, norkaProvider, child) {
        // Loading is now handled at the homepage level with shimmer effects

        // Extract customer ID from provider
        final displayCustomerId = _extractCustomerId(context);

        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.primaryColor,
                AppConstants.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Image.asset(
                      AppConstants.appLogo,
                      fit: BoxFit.contain,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AppText(
                        //   text: '$displayName',
                        //   size: 18,
                        //   weight: FontWeight.bold,
                        //   textColor: AppConstants.whiteColor,
                        // ),
                        const SizedBox(height: 4),
                        AppText(
                          text: 'Norka Care Insurance',
                          size: 18,
                          weight: FontWeight.w600,
                          textColor: AppConstants.whiteColor.withOpacity(0.9),
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          text: 'Norka ID: $displayCustomerId',
                          size: 14,
                          weight: FontWeight.w500,
                          textColor: AppConstants.whiteColor.withOpacity(0.9),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCoverageCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoverageCard() {
    // Extract coverage data from customerInsuranceData
    final totalCoverage =
        widget.customerInsuranceData['quickStats']['totalCoverage'] ??
        '₹5,00,000';
    final policyStatus =
        widget.customerInsuranceData['quickStats']['policyStatus'] ?? 'Active';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor, // Use same color as welcome section
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Total Coverage Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text: 'Total Coverage',
                  size: 13,
                  weight: FontWeight.w500,
                  textColor: AppConstants.whiteColor.withOpacity(0.8),
                ),
                const SizedBox(height: 10),
                AppText(
                  text: totalCoverage,
                  size: 20,
                  weight: FontWeight.bold,
                  textColor: AppConstants.whiteColor,
                ),
              ],
            ),
          ),
          // Vertical Divider
          Container(
            width: 1,
            height: 50,
            color: AppConstants.whiteColor.withOpacity(0.3),
          ),
          // Policy Status Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text: 'Policy Status',
                  size: 13,
                  weight: FontWeight.w500,
                  textColor: AppConstants.whiteColor.withOpacity(0.8),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: policyStatus.toLowerCase() == 'active'
                            ? AppConstants.greenColor
                            : AppConstants.redColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AppText(
                      text: policyStatus,
                      size: 20,
                      weight: FontWeight.bold,
                      textColor: AppConstants.whiteColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
