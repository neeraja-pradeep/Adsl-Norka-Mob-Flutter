import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/screen/insurence/file_claim_page.dart';
import 'package:norkacare_app/provider/claim_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:norkacare_app/services/claim_service.dart';

class MyClaimsPage extends StatefulWidget {
  const MyClaimsPage({super.key});

  @override
  State<MyClaimsPage> createState() => _MyClaimsPageState();

  // Static method to reset shimmer state (call this on logout)
  static void resetShimmerState() {
    _MyClaimsPageState.resetShimmerState();
  }

  // Static method to reset SharedPreferences shimmer flag (call this on logout)
  static Future<void> resetShimmerPreferences() async {
    await _MyClaimsPageState.resetShimmerPreferences();
  }
}

class _MyClaimsPageState extends State<MyClaimsPage> {
  String selectedFilter = 'All';
  final TextEditingController searchController = TextEditingController();
  bool _isInitialLoading = true;
  String _sortBy = 'date'; // 'date', 'amount', 'status', 'name'
  bool _isAscending = false;

  // Static variable to track if shimmer has been shown for this page
  static bool _hasShownClaimsShimmer = false;

  // Static method to reset shimmer state (call this on logout)
  static void resetShimmerState() {
    _hasShownClaimsShimmer = false;
  }

  // Static method to reset SharedPreferences shimmer flag (call this on logout)
  // 🔧 FOR TESTING: To see the shimmer again during development:
  //    1. Call MyClaimsPage.resetShimmerPreferences() from anywhere
  //    2. OR uninstall and reinstall the app
  //    3. OR clear app data from device settings
  static Future<void> resetShimmerPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_shown_claims_shimmer');
    _hasShownClaimsShimmer = false; // Reset static variable too
    debugPrint('🔄 Shimmer preferences reset - shimmer will show on next visit');
  }

  @override
  void initState() {
    super.initState();
    _initializeShimmerState();
  }

  void _initializeShimmerState() {
    if (_hasShownClaimsShimmer) {
      // Shimmer has been shown before, don't show it
      _isInitialLoading = false;
      // Load data immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchClaimData();
      });
    } else {
      // First time visiting this page, show shimmer
      _startShimmerTimer();
    }
  }

  void _startShimmerTimer() {
    // Load data during shimmer phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchClaimData();
    });

    // Show shimmer for 2 seconds on first visit to this page
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _hasShownClaimsShimmer = true; // Mark shimmer as shown
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
    await prefs.setBool('has_shown_claims_shimmer', true);
  }

  Future<void> _fetchClaimData() async {
    final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    // Get NORKA ID
    String norkaId = norkaProvider.norkaId;
    
    if (norkaId.isEmpty) {
      debugPrint('⚠️ NORKA ID not available');
      return;
    }

    debugPrint('=== Fetching claim data for NORKA ID: $norkaId ===');

    // First try to load cached data for offline support
    await claimProvider.loadClaimsDataFromPrefs();

    // Then try to fetch fresh data from API
    try {
      await claimProvider.fetchClaimDependentInfo(norkaId: norkaId);
    } catch (e) {
      debugPrint('=== MY CLAIMS: API call failed, using cached data ===');
      // API call failed, but we might have cached data from loadClaimsDataFromPrefs
    }
  }

  List<Map<String, dynamic>> get filteredClaims {
    // Use only API data from provider (no dummy data)
    final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
    List<Map<String, dynamic>> apiClaims = claimProvider.claims.isNotEmpty
        ? List<Map<String, dynamic>>.from(claimProvider.claims)
        : [];

    List<Map<String, dynamic>> filtered = apiClaims;

    if (selectedFilter != 'All') {
      filtered = filtered
          .where((claim) {
            // Map the display filter to API status
            String apiStatus = claim['status'] ?? '';
            String displayStatus = _getDisplayStatus(apiStatus);
            return displayStatus == selectedFilter;
          })
          .toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (claim) =>
                (claim['claimType']?.toLowerCase() ?? '').contains(
                  searchController.text.toLowerCase(),
                ) ||
                (claim['claimNumber']?.toLowerCase() ?? '').contains(
                  searchController.text.toLowerCase(),
                ) ||
                (claim['claimantName']?.toLowerCase() ?? '').contains(
                  searchController.text.toLowerCase(),
                ) ||
                (claim['hospName']?.toLowerCase() ?? '').contains(
                  searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    // Apply sorting
    filtered = _sortClaims(filtered);

    return filtered;
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
        automaticallyImplyLeading: false,
        title: AppText(
          text: 'My Claims',
          size: 20,
          weight: FontWeight.bold,
          textColor: AppConstants.whiteColor,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FileClaimPage(),
                ),
              ).then((_) {
                // Refresh claims data when returning from file claim page
                _fetchClaimData();
              });
            },
            icon: const Icon(Icons.add, color: AppConstants.whiteColor, size: 30),
          ),
        ],
      ),
      body: Consumer<ClaimProvider>(
        builder: (context, claimProvider, child) {
          // Show shimmer during initial loading
          final bool showShimmer = _isInitialLoading;

          return showShimmer
              ? ShimmerWidgets.buildShimmerClaimsPage(
                  isDarkMode: isDarkMode,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSearchAndFilterSection(),
                      if (filteredClaims.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              AppText(
                                text:
                                    '${filteredClaims.length} claim${filteredClaims.length == 1 ? '' : 's'} found',
                                size: 16,
                                weight: FontWeight.w600,
                                textColor: AppConstants.primaryColor,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => _showSortOptions(),
                                child: Icon(
                                  Icons.swap_vert,
                                  color: AppConstants.greyColor,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredClaims.length,
                          itemBuilder: (context, index) {
                            return _buildClaimCard(filteredClaims[index]);
                          },
                        ),
                        const SizedBox(height: 20),
                      ] else
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: _buildEmptyState(),
                        ),
                    ],
                  ),
                );
        },
      ),
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
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() {}),
            style: TextStyle(
              color: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
            decoration: InputDecoration(
              hintText: 'Search claims...',
              hintStyle: TextStyle(color: AppConstants.greyColor),
              prefixIcon: Icon(Icons.search, color: AppConstants.greyColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : AppConstants.greyColor.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : AppConstants.greyColor.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppConstants.primaryColor),
              ),
              filled: true,
              fillColor: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : AppConstants.whiteBackgroundColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: [
                'All',
                'Approved',
                'Under Review',
                'Required Information',
                'Rejected',
                'Settled',
              ].length,
              itemBuilder: (context, index) {
                final filter = [
                  'All',
                  'Approved',
                  'Under Review',
                  'Required Information',
                  'Rejected',
                  'Settled',
                ][index];
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

  Widget _buildClaimCard(Map<String, dynamic> claim) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color statusColor = _getStatusColor(claim['status']);

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
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getClaimIcon(claim['policyType'] ?? 'Health Insurance'),
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
                        text: claim['policyType'] ?? claim['coverageType'] ?? 'Health Insurance',
                        size: 16,
                        weight: FontWeight.w600,
                        textColor: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        text: 'ID: ${claim['claimNumber']}',
                        size: 12,
                        weight: FontWeight.w400,
                        textColor: AppConstants.greyColor,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      text: claim['claimAmount'],
                      size: 18,
                      weight: FontWeight.w700,
                      textColor: AppConstants.primaryColor,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: _getDisplayStatus(claim['status']),
                      size: 12,
                      weight: FontWeight.w500,
                      textColor: statusColor,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Patient Name', claim['claimantName'] ?? 'N/A'),
                if (claim['approvedAmount'] != null && claim['approvedAmount'].toString().isNotEmpty)
                  _buildDetailRow('Approved Amount', claim['approvedAmount']),
                _buildDetailRow('Date of Admission', _formatDateWithoutTime(claim['doa'])),
                _buildDetailRow('Hospital', claim['hospName'] ?? 'N/A'),
              ],
            ),
          ),



                  Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                 if (_getDisplayStatus(claim['status']) == 'Required Information')
                  Expanded(
                    child: CustomButton(
                      text: 'Upload Document',
                      onPressed: () => _showUploadDocumentDialog(claim),
                      color: AppConstants.redColor,
                      textColor: AppConstants.whiteColor,
                      height: 40,
                    ),
                  )
                else
                //   Expanded(
                //     child: CustomButton(
                //       text: 'Upload Doc',
                //       onPressed: () => null,
                //       color: AppConstants.greyColor,
                //       textColor: AppConstants.blackColor.withOpacity(0.5),
                //       height: 40,
                //     ),
                //   ),
               SizedBox(width: 0),
                
              ],
            ),
          ),

          // Action Button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppConstants.darkBackgroundColor
                  : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'View Details',
                    onPressed: () => 
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File Claim'))),
                    _showClaimDetails(claim),
                    color: AppConstants.primaryColor,
                    textColor: AppConstants.whiteColor,
                    height: 40,
                  ),
                ),
        
              
                 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
              weight: FontWeight.w600,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppConstants.greyColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            text: 'No claims found',
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

  String _getDisplayStatus(String? status) {
    if (status == null) return 'N/A';
    
    // Map API status to display status
    switch (status) {
      case 'In-Progress':
        return 'Under Review';
      case 'Paid':
        return 'Settled';
      case 'Required Information':
        return 'Required Information';
      case 'Approved':
        return 'Approved';
      case 'Rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    
    try {
      // Parse the date string (assuming format like "2025-10-10 14:25:32" or "11/11/2025")
      DateTime date;
      
      // Handle different date formats
      if (dateString.contains('/')) {
        // Handle DD/MM/YYYY or MM/DD/YYYY format
        List<String> parts = dateString.split('/');
        if (parts.length == 3) {
          // Assume DD/MM/YYYY format
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          date = DateTime(year, month, day);
        } else {
          date = DateTime.parse(dateString);
        }
      } else {
        // Handle ISO format like "2025-10-10 14:25:32"
        date = DateTime.parse(dateString);
      }
      
      // Format to DD/MM/YYYY HH:MM
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      String year = date.year.toString();
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      
      return '$day/$month/$year $hour:$minute';
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return dateString; // Return original string if parsing fails
    }
  }

  String _formatDateWithoutTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    
    try {
      // Parse the date string (assuming format like "2025-10-10 14:25:32" or "11/11/2025")
      DateTime date;
      
      // Handle different date formats
      if (dateString.contains('/')) {
        // Handle DD/MM/YYYY or MM/DD/YYYY format
        List<String> parts = dateString.split('/');
        if (parts.length == 3) {
          // Assume DD/MM/YYYY format
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          date = DateTime(year, month, day);
        } else {
          date = DateTime.parse(dateString);
        }
      } else {
        // Handle ISO format like "2025-10-10 14:25:32"
        date = DateTime.parse(dateString);
      }
      
      // Format to DD/MM/YYYY only (no time)
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      String year = date.year.toString();
      
      return '$day/$month/$year';
    } catch (e) {
      debugPrint('Error formatting date without time: $e');
      return dateString; // Return original string if parsing fails
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppConstants.greyColor;
    
    // Use the mapped display status for color determination
    String displayStatus = _getDisplayStatus(status);
    
    switch (displayStatus) {
      case 'Approved':
        return AppConstants.greenColor;
      case 'Under Review':
        return AppConstants.orangeColor;
      case 'Required Information':
        return AppConstants.orangeColor;
      case 'Rejected':
        return AppConstants.redColor;
      case 'Settled':
        return AppConstants.primaryColor;
      default:
        return AppConstants.greyColor;
    }
  }

  IconData _getClaimIcon(String policyType) {
    switch (policyType) {
      case 'Health Insurance':
        return Icons.health_and_safety;
      default:
        return Icons.receipt_long;
    }
  }

  void _showClaimDetails(Map<String, dynamic> claim) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: Column(
            children: [
              Icon(
                _getClaimIcon(claim['policyType'] ?? 'Health Insurance'),
                size: 40,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text: 'Claim Details',
                size: 20,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Claim Number', claim['claimNumber'] ?? 'N/A'),
                _buildDetailRow('Claim Type', claim['claimType'] ?? 'N/A'),
                _buildDetailRow('Patient Name', claim['claimantName'] ?? 'N/A'),
                _buildDetailRow('Claim Amount', claim['claimAmount']?.toString() ?? 'N/A'),
                if (claim['approvedAmount'] != null && claim['approvedAmount'].toString().isNotEmpty)
                  _buildDetailRow('Approved Amount', claim['approvedAmount'].toString()),
                if (claim['rejectedAmount'] != null && claim['rejectedAmount'].toString().isNotEmpty)
                  _buildDetailRow('Rejected Amount', claim['rejectedAmount'].toString()),
                _buildDetailRow('Status', _getDisplayStatus(claim['status'])),
                _buildDetailRow('Submitted Date', _formatDate(claim['receivedDate'])),

                if (claim['hospName'] != null && claim['hospName'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Hospital Details',
                    size: 16,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Hospital', claim['hospName']),
                  if (claim['doa'] != null && claim['doa'].toString().isNotEmpty)
                    _buildDetailRow('Date of Admission', _formatDateWithoutTime(claim['doa'])),
                  if (claim['dod'] != null && claim['dod'].toString().isNotEmpty)
                    _buildDetailRow('Date of Discharge', _formatDateWithoutTime(claim['dod'])),
                ],

                if (claim['garage'] != null) ...[
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Vehicle Details',
                    size: 16,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Garage', claim['garage']),
                  if (claim['vehicleNumber'] != null)
                    _buildDetailRow('Vehicle Number', claim['vehicleNumber']),
                  if (claim['accidentDate'] != null)
                    _buildDetailRow('Accident Date', _formatDate(claim['accidentDate'])),
                  if (claim['accidentLocation'] != null)
                    _buildDetailRow(
                      'Accident Location',
                      claim['accidentLocation'],
                    ),
                ],

                if (claim['documents'] != null) ...[
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Documents Submitted',
                    size: 16,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  const SizedBox(height: 8),
                  ...claim['documents']
                      .map<Widget>(
                        (document) => Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description,
                                size: 16,
                                color: AppConstants.greyColor,
                              ),
                              const SizedBox(width: 8),
                              AppText(
                                text: document,
                                size: 14,
                                weight: FontWeight.w500,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor
                                    : AppConstants.blackColor,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: 'Close',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.greyColor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close current dialog
                _showClaimTimeline(claim); // Open Track Status dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: 'Track Status',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClaimTimeline(Map<String, dynamic> claim) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Check if timeline data exists
    bool hasTimeline = claim['timeline'] != null && claim['timeline'] is List && (claim['timeline'] as List).isNotEmpty;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: AppText(
            text: 'Claim Status',
            size: 20,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: claim['claimNumber'] ?? 'N/A',
                  size: 16,
                  weight: FontWeight.w600,
                  textColor: AppConstants.greyColor,
                ),
                const SizedBox(height: 16),
                if (hasTimeline)
                  ...claim['timeline'].asMap().entries.map<Widget>((entry) {
                  final index = entry.key;
                  final timeline = entry.value;
                  final isLast = index == claim['timeline'].length - 1;
                  final isProcessing = timeline['status'] == 'Processing';
                  final isCompleted =
                      timeline['status'] == 'Settled' ||
                      timeline['status'] == 'Approved' ||
                      timeline['status'] == 'Under Review' ||
                      timeline['status'] == 'Claim Filed' ||
                      timeline['status'] == 'Required Information' ||
                      timeline['status'] == 'Rejected';

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isProcessing
                                  ? AppConstants.secondaryColor
                                  : (isCompleted
                                        ? AppConstants.greenColor
                                        : AppConstants.greyColor),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isProcessing ? Icons.schedule : Icons.check,
                              size: 12,
                              color: AppConstants.whiteColor,
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 40,
                              color: AppConstants.greyColor.withOpacity(0.3),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: timeline['status'],
                              size: 16,
                              weight: FontWeight.w600,
                              textColor: isDarkMode
                                  ? AppConstants.whiteColor
                                  : AppConstants.blackColor,
                            ),
                            if (!isProcessing) ...[
                              const SizedBox(height: 4),
                              AppText(
                                text: timeline['date'],
                                size: 14,
                                weight: FontWeight.w500,
                                textColor: AppConstants.greyColor,
                              ),
                              const SizedBox(height: 4),
                            ],
                            AppText(
                              text: timeline['description'],
                              size: 14,
                              weight: FontWeight.normal,
                              textColor: isDarkMode
                                  ? AppConstants.whiteColor
                                  : AppConstants.blackColor,
                            ),
                            if (!isLast) const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
                if (!hasTimeline)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppConstants.primaryColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppText(
                                    text: 'Current Status',
                                    size: 18,
                                    weight: FontWeight.bold,
                                    textColor: isDarkMode
                                        ? AppConstants.whiteColor
                                        : AppConstants.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow('Status', _getDisplayStatus(claim['status'])),
                            const SizedBox(height: 8),
                            _buildDetailRow('Claim Type', claim['claimType'] ?? 'N/A'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Patient Name', claim['claimantName'] ?? 'N/A'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Hospital', claim['hospName'] ?? 'N/A'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Claim Amount', claim['claimAmount']?.toString() ?? 'N/A'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Submitted Date', _formatDate(claim['receivedDate'])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.orangeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppConstants.orangeColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppConstants.orangeColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppText(
                                text: 'Your claim is being processed. Detailed timeline will be available soon.',
                                size: 13,
                                weight: FontWeight.normal,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor.withOpacity(0.8)
                                    : AppConstants.blackColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
               Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: 'Close',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  // Upload Document Dialog for Required Information status
  void _showUploadDocumentDialog(Map<String, dynamic> claim) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: Column(
            children: [
              Icon(
                Icons.upload_file,
                size: 40,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text: 'Upload Document',
                size: 20,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: 'Please upload the required document for this claim.',
                size: 14,
                weight: FontWeight.normal,
                textColor: AppConstants.greyColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppText(
                text: 'Claim Number: ${claim['claimNumber'] ?? 'N/A'}',
                size: 14,
                weight: FontWeight.w600,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text: 'Accepted formats: PDF, JPG, JPEG (Max 2MB)',
                size: 12,
                weight: FontWeight.normal,
                textColor: AppConstants.greyColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Required Information Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.orangeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.orangeColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppConstants.orangeColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          text: 'Required Information',
                          size: 14,
                          weight: FontWeight.bold,
                          textColor: AppConstants.orangeColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (claim['shortfallCategory'] != null && claim['shortfallCategory'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Category: ',
                              size: 12,
                              weight: FontWeight.w600,
                              textColor: isDarkMode
                                  ? AppConstants.whiteColor
                                  : AppConstants.blackColor,
                            ),
                            Expanded(
                              child: AppText(
                                text: claim['shortfallCategory'].toString(),
                                size: 12,
                                weight: FontWeight.normal,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor.withOpacity(0.8)
                                    : AppConstants.blackColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (claim['shortfallRemarks'] != null && claim['shortfallRemarks'].toString().isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Remarks: ',
                            size: 12,
                            weight: FontWeight.w600,
                            textColor: isDarkMode
                                ? AppConstants.whiteColor
                                : AppConstants.blackColor,
                          ),
                          Expanded(
                            child: AppText(
                              text: claim['shortfallRemarks'].toString(),
                              size: 12,
                              weight: FontWeight.normal,
                              textColor: isDarkMode
                                  ? AppConstants.whiteColor.withOpacity(0.8)
                                  : AppConstants.blackColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: AppConstants.primaryColor.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(
              //       color: AppConstants.primaryColor.withOpacity(0.3),
              //       width: 1,
              //     ),
              //   ),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Icon(
              //         Icons.info_outline,
              //         color: AppConstants.primaryColor,
              //         size: 20,
              //       ),
              //       const SizedBox(width: 8),
              //       Expanded(
              //         child: AppText(
              //           text: 'Required documents for insurance claim process include bank account details.',
              //           size: 12,
              //           weight: FontWeight.normal,
              //           textColor: isDarkMode
              //               ? AppConstants.whiteColor.withOpacity(0.8)
              //               : AppConstants.blackColor.withOpacity(0.7),
              //           textAlign: TextAlign.left,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: 'Cancel',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.greyColor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickAndUploadDocument(claim);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: 'Select Document',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  // Pick document and upload
  Future<void> _pickAndUploadDocument(Map<String, dynamic> claim) async {
    try {
      // Step 1: Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      PlatformFile file = result.files.first;

      // Validate file size (2MB limit)
      if (file.size > 2 * 1024 * 1024) {
        ToastMessage.failedToast(
          'File size exceeds 2MB limit'
        );
        return;
      }

      // Validate file extension
      String extension = file.extension?.toLowerCase() ?? '';
      if (extension != 'pdf' && extension != 'jpg' && extension != 'jpeg') {
        ToastMessage.failedToast(
          'Please select a PDF, JPG, or JPEG file only'
        );
        return;
      }

      // Show confirmation dialog with upload button
      _showUploadConfirmationDialog(claim, file);
    } catch (e) {
      ToastMessage.failedToast(
        'Failed to pick file: ${e.toString()}'
      );
    }
  }

  // Show confirmation dialog with upload button
  void _showUploadConfirmationDialog(Map<String, dynamic> claim, PlatformFile file) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 40,
                color: AppConstants.greenColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text: 'Document Selected',
                size: 20,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('File Name', file.name),
              _buildDetailRow('File Size', _formatFileSize(file.size)),
              _buildDetailRow('File Type', file.extension?.toUpperCase() ?? 'Unknown'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: 'Cancel',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.greyColor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadDocument(claim, file);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: 'Upload Document',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  // Upload document and submit shortfall
  Future<void> _uploadDocument(Map<String, dynamic> claim, PlatformFile file) async {
    final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
    final claimService = ClaimService();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.boxBlackColor
                  : AppConstants.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                AppText(
                  text: 'Uploading document...',
                  size: 16,
                  weight: FontWeight.w500,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      debugPrint('=== Starting shortfall document upload ===');
      debugPrint('File: ${file.name}');
      debugPrint('Claim Number: ${claim['claimNumber']}');

      // Step 1 & 2: Upload document using claim provider (calls 2 APIs)
      final uploadResult = await claimProvider.uploadClaimDocument(file: file);

      if (!uploadResult['success']) {
        // Close loading dialog
        if (mounted) Navigator.of(context).pop();
        
        ToastMessage.failedToast(
          'Failed to upload document'
        );
        return;
      }

      String fileId = uploadResult['fileId'] ?? '';
      debugPrint('✅ Document uploaded successfully. File ID: $fileId');

      // Step 3: Submit shortfall with fileId, shortfallNo, and claimNo
      String shortFallNo = claim['shortfallNo'] ?? claim['claimNumber'] ?? '';
      String claimNo = claim['claimNumber'] ?? '';
      
      if (shortFallNo.isEmpty) {
        // Close loading dialog
        if (mounted) Navigator.of(context).pop();
        
        ToastMessage.failedToast('Shortfall number not found');
        return;
      }

      if (claimNo.isEmpty) {
        // Close loading dialog
        if (mounted) Navigator.of(context).pop();
        
        ToastMessage.failedToast('Claim number not found');
        return;
      }

      debugPrint('=== Submitting shortfall ===');
      debugPrint('ShortFall No: $shortFallNo');
      debugPrint('Claim No: $claimNo');
      
      final shortfallResult = await claimService.submitShortfall(
        shortFallNo: shortFallNo,
        claimNo: claimNo,
        fileId: fileId,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (shortfallResult['success']) {
        // ToastMessage.successToast(
        //   shortfallResult['message'] ?? 'Document uploaded successfully'
        // );
        
        // Refresh claims data
        _fetchClaimData();
      } else {
        ToastMessage.failedToast(
          'Failed to submit document'
        );
      }
    } catch (e) {
      debugPrint('❌ Error uploading document: $e');
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      ToastMessage.failedToast(
        'Failed to upload document: ${e.toString()}'
      );
    }
  }

  // Format file size helper method
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Sort claims based on selected criteria
  List<Map<String, dynamic>> _sortClaims(List<Map<String, dynamic>> claims) {
    List<Map<String, dynamic>> sortedClaims = List.from(claims);
    
    sortedClaims.sort((a, b) {
      int comparison = 0;
      
      switch (_sortBy) {
        case 'date':
          comparison = _compareDates(a['receivedDate'], b['receivedDate']);
          break;
        case 'amount':
          comparison = _compareAmounts(a['claimAmount'], b['claimAmount']);
          break;
        case 'status':
          comparison = _getDisplayStatus(a['status']).compareTo(_getDisplayStatus(b['status']));
          break;
        case 'name':
          comparison = (a['claimantName'] ?? '').compareTo(b['claimantName'] ?? '');
          break;
        default:
          comparison = 0;
      }
      
      return _isAscending ? comparison : -comparison;
    });
    
    return sortedClaims;
  }

  // Compare dates
  int _compareDates(String? dateA, String? dateB) {
    if (dateA == null || dateB == null) return 0;
    
    try {
      DateTime date1 = DateTime.parse(dateA);
      DateTime date2 = DateTime.parse(dateB);
      return date1.compareTo(date2);
    } catch (e) {
      return 0;
    }
  }

  // Compare amounts
  int _compareAmounts(String? amountA, String? amountB) {
    if (amountA == null || amountB == null) return 0;
    
    try {
      // Remove currency symbols and commas
      String cleanAmountA = amountA.replaceAll(RegExp(r'[₹,\s]'), '');
      String cleanAmountB = amountB.replaceAll(RegExp(r'[₹,\s]'), '');
      
      double amount1 = double.parse(cleanAmountA);
      double amount2 = double.parse(cleanAmountB);
      
      return amount1.compareTo(amount2);
    } catch (e) {
      return 0;
    }
  }

  // Show sort options dialog
  void _showSortOptions() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: AppText(
            text: 'Sort Claims',
            size: 18,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption('Date', 'date', Icons.calendar_today),
              _buildSortOption('Amount', 'amount', Icons.attach_money),
              _buildSortOption('Status', 'status', Icons.info_outline),
              _buildSortOption('Patient Name', 'name', Icons.person),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isAscending = !_isAscending;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        text: _isAscending ? 'Ascending' : 'Descending',
                        size: 14,
                        weight: FontWeight.w500,
                        textColor: AppConstants.primaryColor,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: AppText(
                    text: 'Close',
                    size: 16,
                    weight: FontWeight.w500,
                    textColor: AppConstants.greyColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Build sort option widget
  Widget _buildSortOption(String title, String value, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _sortBy == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppConstants.primaryColor
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppConstants.primaryColor
                  : AppConstants.greyColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                text: title,
                size: 16,
                weight: isSelected ? FontWeight.w600 : FontWeight.normal,
                textColor: isSelected
                    ? AppConstants.primaryColor
                    : (isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 20,
                color: AppConstants.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
