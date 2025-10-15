import 'package:fluttertoast/fluttertoast.dart';
import 'package:norkacare_app/screen/homepage_widgets/welcome_section.dart';
import 'package:norkacare_app/screen/homepage_widgets/quick_overview.dart';
import 'package:norkacare_app/screen/homepage_widgets/documents.dart';
import 'package:norkacare_app/screen/profile/customer_support_page.dart';
import 'package:norkacare_app/screen/profile/profile_widgets/landbot_chat_page.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/claim_provider.dart';
import 'package:norkacare_app/services/document_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();

  // Static method to reset shimmer state (call logout)
  static void resetShimmerState() {
    _HomepageState.resetShimmerState();
  }

  // Static method to reset SharedPreferences shimmer flag
  static Future<void> resetShimmerPreferences() async {
    await _HomepageState.resetShimmerPreferences();
  }
}

class _HomepageState extends State<Homepage> {
  bool _isInitialLoading = true;

  // Static variable to track if shimmer has been shown for this page
  static bool _hasShownHomepageShimmer = false;

  // Static method to reset shimmer state (call this on logout)
  static void resetShimmerState() {
    _hasShownHomepageShimmer = false;
  }

  // Static method to reset SharedPreferences shimmer flag (call this on logout)
  static Future<void> resetShimmerPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_shown_homepage_shimmer');
  }

  Map<String, dynamic> customerInsuranceData = {
    'customerInfo': {
      'name': 'Not available',
      'customerId': 'Unknown ID',
      'email': 'Not available',
      'phone': 'Not available',
      'address': 'Not available',
      'memberSince': 'Not available',
    },
    'recentClaims': [
      {
        'claimNumber': 'CLM-2024-001',
        'policyType': 'Health Insurance',
        'claimAmount': '₹45,000',
        'status': 'Approved',
        'date': '15/02/2024',
        'description': 'Hospitalization for appendicitis',
      },
    ],
    'documents': [
      {
        'name': 'Health Policy Document',
        'type': 'PDF',
        'size': '2.5 MB',
        'date': '01/01/2024',
      },
    ],
    'quickStats': {
      'totalPolicies': 1,
      'activePolicies': 1,
      'totalCoverage': '₹500,000',
      'totalPremium': '₹12,000',
      'pendingClaims': 0,
      'approvedClaims': 1,
      'claimedAmount': '₹45,000',
    },
  };

  Future<void> _handleRefresh() async {
    debugPrint('=== DASHBOARD: Pull-to-refresh triggered ===');
    
    try {
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
      final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
      
      // Get NORKA ID
      String norkaId = norkaProvider.norkaId;
      if (norkaId.isEmpty) {
        norkaId = await norkaProvider.getNorkaIdFromPrefs();
      }
      
      if (norkaId.isNotEmpty) {
        // Make fresh API call to get updated data
        debugPrint('=== DASHBOARD: Pull-to-refresh making fresh API call ===');
        await verificationProvider.getUserDetailsForDashboard(norkaId);
        
        // Also refresh claims data
        debugPrint('=== DASHBOARD: Pull-to-refresh fetching claims data ===');
        await claimProvider.fetchClaimDependentInfo(norkaId: norkaId);
        
        // Refresh documents data
        debugPrint('=== DASHBOARD: Pull-to-refresh fetching documents data ===');
        await _fetchAndCacheDocuments(norkaId);
        
        debugPrint('=== DASHBOARD: Pull-to-refresh completed successfully ===');
      }
    } catch (e) {
      debugPrint('=== DASHBOARD: Pull-to-refresh failed: $e ===');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeShimmerState();
  }

  void _initializeShimmerState() {
    if (_hasShownHomepageShimmer) {
      // Shimmer has been shown before, don't show it
      _isInitialLoading = false;
      // Still need to preload payment history for subsequent launches
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _preloadPaymentHistory();
      });
    } else {
      // First time visiting homepage, show shimmer
      _startShimmerTimer();
    }
  }

  void _startShimmerTimer() {
    // Preload payment history data after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadPaymentHistory();
    });

    // Show shimmer for 2 seconds on first app launch
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _hasShownHomepageShimmer = true; // Mark shimmer as shown
        setState(() {
          _isInitialLoading = false;
        });
        // Mark that shimmer has been shown
        _saveShimmerFlag();
      }
    });
  }

  void _preloadPaymentHistory() async {
    try {
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(
        context,
        listen: false,
      );
      final claimProvider = Provider.of<ClaimProvider>(context, listen: false);

      // Get NORKA ID from SharedPreferences if not available in provider
      String norkaId = norkaProvider.norkaId;
      if (norkaId.isEmpty) {
        norkaId = await norkaProvider.getNorkaIdFromPrefs();
      }

      if (norkaId.isNotEmpty) {
        // Always make API call to get fresh data every time user lands in dashboard
        // This ensures we have the latest data, especially after payments
        debugPrint('=== DASHBOARD: Making API call for fresh data ===');
        try {
          await verificationProvider.getUserDetailsForDashboard(norkaId);
          debugPrint('=== DASHBOARD: Fresh data loaded successfully ===');
        } catch (e) {
          debugPrint('=== DASHBOARD: API call failed, loading cached data ===');
          // If API call fails, try to load cached data for offline support
          await verificationProvider.loadUnifiedApiResponseFromPrefs();
          if (verificationProvider.getUnifiedApiResponse() != null) {
            debugPrint('=== DASHBOARD: Using cached data as fallback ===');
          } else {
            debugPrint('=== DASHBOARD: No cached data available ===');
          }
        }

        // Also fetch claims data in the background
        debugPrint('=== DASHBOARD: Fetching claims data ===');
        try {
          // First load cached claims data
          await claimProvider.loadClaimsDataFromPrefs();
          
          // Then fetch fresh claims data
          await claimProvider.fetchClaimDependentInfo(norkaId: norkaId);
          debugPrint('=== DASHBOARD: Claims data loaded successfully ===');
        } catch (e) {
          debugPrint('=== DASHBOARD: Claims API call failed, using cached data: $e ===');
          // Cached data already loaded above
        }

        // Fetch and cache documents for offline access
        debugPrint('=== DASHBOARD: Fetching documents data ===');
        try {
          await _fetchAndCacheDocuments(norkaId);
          debugPrint('=== DASHBOARD: Documents data loaded successfully ===');
        } catch (e) {
          debugPrint('=== DASHBOARD: Documents API call failed: $e ===');
        }
      }
    } catch (e) {
      debugPrint('Error preloading user data with unified API: $e');
    }
  }

  Future<void> _fetchAndCacheDocuments(String norkaId) async {
    try {
      final response = await DocumentService.fetchDocuments(norkaId);
      
      if (response['status'] == 'success') {
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final encodedDocs = jsonEncode(response['data'] ?? []);
        await prefs.setString('documents_$norkaId', encodedDocs);
        debugPrint('💾 Cached ${response['count'] ?? 0} documents for offline access');
      }
    } catch (e) {
      debugPrint('Error fetching and caching documents: $e');
    }
  }

  Future<void> _saveShimmerFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_homepage_shimmer', true);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppConstants.darkBackgroundColor
              : AppConstants.whiteBackgroundColor,
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomRight,
          //   colors: isDarkMode
          //       ? [
          //           AppConstants.primaryColor,
          //           AppConstants.darkBackgroundColor,
          //           AppConstants.darkBackgroundColor,
          //         ]
          //       : [AppConstants.primaryColor, Colors.white, Colors.white],
          //   stops: const [0.0, 0.5, 1.0],
          // ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Consumer2<NorkaProvider, VerificationProvider>(
            builder: (context, norkaProvider, verificationProvider, child) {
              // Only show shimmer during initial loading (first time only)
              final bool showShimmer = _isInitialLoading;

              return LiquidPullToRefresh(
                onRefresh: _handleRefresh,
                color: AppConstants.primaryColor,
                backgroundColor: Colors.white,
                animSpeedFactor: 2.0,
                showChildOpacityTransition: false,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // Show shimmer or actual content based on loading state
                      if (showShimmer) ...[
                        // Shimmer loading states
                        const SizedBox(height: 4),
                        ShimmerWidgets.buildShimmerWelcomeSection(),
                        const SizedBox(height: 16),
                        ShimmerWidgets.buildShimmerQuickOverview(),
                        const SizedBox(height: 16),
                        ShimmerWidgets.buildShimmerDocumentsSection(
                          isDarkMode:
                              Theme.of(context).brightness == Brightness.dark,
                        ),
                        const SizedBox(height: 16),
                        ShimmerWidgets.buildShimmerQuickActionsSection(),
                      ] else ...[
                        // Actual content
                        const SizedBox(height: 4),
                        WelcomeSection(
                          customerInsuranceData: customerInsuranceData,
                        ),
                        const SizedBox(height: 16),
                        QuickOverview(
                          customerInsuranceData: customerInsuranceData,
                        ),
                        const SizedBox(height: 16),
                        Documents(customerInsuranceData: customerInsuranceData),
                        const SizedBox(height: 16),
                        _buildQuickActionsSection(),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Quick Actions',
            size: 18,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              
              Expanded(
                child: _buildActionCard(
                  title: 'Contact Support',
                  icon: Icons.support_agent,
                  color: AppConstants.greenColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerSupportPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  title: 'AI chat',
                  icon: Icons.smart_toy,
                  color: AppConstants.orangeColor,
                    onTap: () {
                    _launchLiveChat();
                    },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            const SizedBox(height: 8),
            AppText(
              text: title,
              size: 12,
              weight: FontWeight.w600,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
    void _launchLiveChat() async {
    // Check internet connectivity first
    bool hasInternet = await _checkInternetConnection();
    
    if (!hasInternet) {
      Fluttertoast.showToast(
        msg: "No internet connection. Please check your network and try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    
    // If internet is available, launch the chat
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LandBotChatPage()),
    );
  }

   // Method to check internet connectivity
  Future<bool> _checkInternetConnection() async {
    try {
      final dio = Dio();
      // Set timeout for the request
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 5);
      
      // Try to make a simple request to a reliable endpoint
      final response = await dio.get('https://www.google.com');
      return response.statusCode == 200;
    } catch (e) {
      // If any error occurs, assume no internet
      return false;
    }
  }

}
