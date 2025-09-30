import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPoliciesPage extends StatefulWidget {
  const MyPoliciesPage({super.key});

  @override
  State<MyPoliciesPage> createState() => _MyPoliciesPageState();

  // Static method to reset shimmer state (call this on logout)
  static void resetShimmerState() {
    _MyPoliciesPageState.resetShimmerState();
  }

  // Static method to reset SharedPreferences shimmer flag (call this on logout)
  static Future<void> resetShimmerPreferences() async {
    await _MyPoliciesPageState.resetShimmerPreferences();
  }
}

class _MyPoliciesPageState extends State<MyPoliciesPage> {
  String selectedFilter = 'All';
  final TextEditingController searchController = TextEditingController();
  bool _isInitialLoading = true;

  // Static variable to track if shimmer has been shown for this page
  static bool _hasShownPoliciesShimmer = false;

  // Static method to reset shimmer state (call this on logout)
  static void resetShimmerState() {
    _hasShownPoliciesShimmer = false;
  }

  // Static method to reset SharedPreferences shimmer flag (call this on logout)
  static Future<void> resetShimmerPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_shown_policies_shimmer');
  }

  @override
  void initState() {
    super.initState();
    _initializeShimmerState();
  }

  void _initializeShimmerState() {
    if (_hasShownPoliciesShimmer) {
      // Shimmer has been shown before, don't show it
      _isInitialLoading = false;
      // Load data immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadEnrollmentData();
      });
    } else {
      // First time visiting this page, show shimmer
      _startShimmerTimer();
    }
  }

  void _startShimmerTimer() {
    // Load data during shimmer phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEnrollmentData();
    });

    // Show shimmer for 2 seconds on first visit to this page
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _hasShownPoliciesShimmer = true; // Mark shimmer as shown
        setState(() {
          _isInitialLoading = false;
        });
        // Mark that shimmer has been shown in SharedPreferences too
        _saveShimmerFlag();
      }
    });
  }

  Future<void> _saveShimmerFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_policies_shimmer', true);
  }

  void _loadEnrollmentData() async {
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );

    if (norkaProvider.norkaId.isNotEmpty) {
      await verificationProvider.getEnrollmentDetailsWithOfflineFallback(norkaProvider.norkaId);
      await verificationProvider.getDatesDetailsWithOfflineFallback(norkaProvider.norkaId);
      // Use payment history API like payment details page and quick overview
      if (!verificationProvider.hasPaymentHistoryLoadedOnce) {
        await verificationProvider.getPaymentHistoryWithOfflineFallback(norkaProvider.norkaId);
      }
    }
  }

  List<Map<String, dynamic>> get allPolicies {
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    // Get enrollment number from API response
    String enrollmentNumber = 'EN00000000'; // Default fallback
    if (verificationProvider.enrollmentDetails.isNotEmpty) {
      final enrollmentData = verificationProvider.enrollmentDetails['data'];
      if (enrollmentData != null &&
          enrollmentData['self_enrollment_number'] != null) {
        enrollmentNumber = enrollmentData['self_enrollment_number'].toString();
      }
    }

    // Get user name from NORKA provider
    String policyHolder = 'Customer';
    if (norkaProvider.response != null &&
        norkaProvider.response!['name'] != null) {
      policyHolder = norkaProvider.response!['name'].toString();
    }

    // Get dates from datesDetails API response
    String startDate = '01/11/2025'; // Default fallback
    String endDate = '31/10/2026'; // Default fallback

    if (verificationProvider.datesDetails.isNotEmpty) {
      startDate = _formatDateForDisplay(
        verificationProvider.datesDetails['date_of_joining'] ?? '01/11/2025',
      );
      endDate = _formatDateForDisplay(
        verificationProvider.datesDetails['date_of_exit'] ?? '31/10/2026',
      );
    }

    // Get premium amount from payment history (same as payment details page and quick overview)
    String premiumAmount = '₹0'; // Default fallback
    if (verificationProvider.paymentHistory.isNotEmpty) {
      premiumAmount = _getPremiumAmountFromPaymentHistory(
        verificationProvider.paymentHistory,
      );
    }

    return [
      {
        'policyNumber': '763300/25-26/NORKACARE/001',
        'enrollmentNumber': enrollmentNumber,
        'policyType': 'Health Insurance',
        'provider': 'Norka Care',
        'startDate': startDate,
        'endDate': endDate,
        'premium': premiumAmount,
        'coverage': '₹500,000',
        'status': 'Active',
        'nextDueDate': '15/04/2024',
        'paymentFrequency': 'Quarterly',
        'policyHolder': policyHolder,
        'beneficiaries': [policyHolder, 'Family Members'],
        'coverageDetails': {
          'Hospitalization': '₹500,000',
          'OPD': '₹10,000',
          'Pre-existing Conditions': '₹200,000',
          'Critical Illness': '₹300,000',
        },
        'exclusions': [
          'Cosmetic surgery',
          'Dental treatment',
          'Alternative medicine',
          // 763300/25-26/NORKACARE/001
        ],
      },
    ];
  }

  /// Format date from API response (MM-dd-yyyy) to display format (dd/MM/yyyy)
  String _formatDateForDisplay(String dateString) {
    try {
      if (dateString.isEmpty) {
        return "01/01/2024"; // Default fallback
      }

      // Handle MM-dd-yyyy format from API
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          final month = parts[0].padLeft(2, '0');
          final day = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$day/$month/$year'; // Convert to dd/MM/yyyy
        }
      }

      // Handle MM/dd/yyyy format
      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          final month = parts[0].padLeft(2, '0');
          final day = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$day/$month/$year'; // Convert to dd/MM/yyyy
        }
      }

      return dateString; // Return original if can't parse
    } catch (e) {
      return "01/01/2024"; // Default fallback
    }
  }

  /// Get premium amount from payment history (same as payment details page and quick overview)
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

  List<Map<String, dynamic>> get filteredPolicies {
    List<Map<String, dynamic>> filtered = allPolicies;

    if (selectedFilter != 'All') {
      filtered = filtered
          .where((policy) => policy['status'] == selectedFilter)
          .toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (policy) =>
                policy['policyType'].toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                policy['policyNumber'].toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Consumer<VerificationProvider>(
      builder: (context, verificationProvider, child) {
        // Show shimmer during initial loading
        final bool showShimmer = _isInitialLoading;

        return Scaffold(
          backgroundColor: isDarkMode
              ? AppConstants.darkBackgroundColor
              : AppConstants.whiteBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppConstants.primaryColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: AppText(
              text: 'My Policies',
              size: 20,
              weight: FontWeight.bold,
              textColor: AppConstants.whiteColor,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Show shimmer or actual content based on loading state
                if (showShimmer) ...[
                  // Shimmer loading states
                  ShimmerWidgets.buildShimmerSearchAndFilterSection(
                    isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 10),
                  ShimmerWidgets.buildShimmerPolicyCard(
                    isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  // Actual content
                  _buildSearchAndFilterSection(),
                  if (filteredPolicies.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredPolicies.length,
                      itemBuilder: (context, index) {
                        return _buildPolicyCard(filteredPolicies[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                  ] else
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _buildEmptyState(),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilterSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
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
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ['All', 'Active', 'Expired'].length,
              itemBuilder: (context, index) {
                final filter = ['All', 'Active', 'Expired'][index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: AppText(
                      text: filter,
                      size: 14,
                      weight: FontWeight.w500,
                      textColor: selectedFilter == filter
                          ? AppConstants.whiteColor
                          : (isDarkMode
                                ? AppConstants.whiteColor
                                : AppConstants.greyColor),
                    ),
                    selected: selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    backgroundColor: isDarkMode
                        ? AppConstants.darkBackgroundColor
                        : AppConstants.whiteBackgroundColor,
                    selectedColor: AppConstants.primaryColor,
                    checkmarkColor: AppConstants.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard(Map<String, dynamic> policy) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Policy Details Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                AppText(
                  text: 'Policy Details',
                  size: 20,
                  weight: FontWeight.bold,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 16),

                // Policy Details Grid
                _buildPolicyDetailsGrid(policy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyDetailsGrid(Map<String, dynamic> policy) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: _buildPolicyDetailItem(
                'Policy Number:',
                policy['policyNumber'],
                isDarkMode,
              ),
            ),
            Expanded(
              child: _buildPolicyDetailItem(
                'Start Date:',
                policy['startDate'],
                isDarkMode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Second Row
        Row(
          children: [
            Expanded(
              child: _buildPolicyDetailItem(
                'Enrollment Number:',
                policy['enrollmentNumber'],
                isDarkMode,
              ),
            ),
            Expanded(
              child: _buildPolicyDetailItem(
                'End Date:',
                policy['endDate'],
                isDarkMode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Third Row
        Row(
          children: [
            Expanded(
              child: _buildPolicyDetailItem(
                'Policy Type:',
                policy['policyType'],
                isDarkMode,
              ),
            ),
            Expanded(
              child: _buildPolicyDetailItem(
                'Total Coverage:',
                policy['coverage'],
                isDarkMode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Fourth Row
        Row(
          children: [
            Expanded(
              child: _buildPolicyDetailItem(
                'Provider:',
                policy['provider'],
                isDarkMode,
              ),
            ),
            Expanded(
              child: _buildPolicyDetailItem(
                'Enrollment Fee:',
                policy['premium'],
                isDarkMode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPolicyDetailItem(String label, String value, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          size: 14,
          weight: FontWeight.normal,
          textColor: AppConstants.greyColor,
        ),
        const SizedBox(height: 4),
        AppText(
          text: value,
          size: 14,
          weight: FontWeight.bold,
          textColor: isDarkMode
              ? AppConstants.whiteColor
              : AppConstants.blackColor,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.policy_outlined,
            size: 80,
            color: AppConstants.greyColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            text: 'No policies found',
            size: 18,
            weight: FontWeight.w600,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.greyColor,
          ),
          const SizedBox(height: 8),
          AppText(
            text: 'Try adjusting your search or filter criteria',
            size: 14,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
        ],
      ),
    );
  }
}
