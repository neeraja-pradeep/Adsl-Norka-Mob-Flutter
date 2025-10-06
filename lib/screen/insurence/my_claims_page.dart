import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:norkacare_app/screen/insurence/file_claim_page.dart';

class MyClaimsPage extends StatefulWidget {
  const MyClaimsPage({super.key});

  @override
  State<MyClaimsPage> createState() => _MyClaimsPageState();
}

class _MyClaimsPageState extends State<MyClaimsPage> {
  String selectedFilter = 'All';
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> allClaims = [
    {
      'claimNumber': 'CLM-2024-001',
      'policyType': 'Health Insurance',
      'policyNumber': 'POL-2024-001',
      'claimAmount': '₹45,000',
      'approvedAmount': '₹42,000',
      'status': 'Approved',
      'date': '15/02/2024',
      'description': 'Hospitalization for appendicitis',
      'hospital': 'City Hospital, Calicut',
      'doctor': 'Dr. Sarah Johnson',
      'admissionDate': '10/02/2024',
      'dischargeDate': '15/02/2024',
      'documents': [
        'Hospital Bill',
        'Medical Certificate',
        'Prescription',
        'Discharge Summary',
      ],
      'timeline': [
        {
          'date': '15/02/2024',
          'status': 'Claim Filed',
          'description': 'Claim submitted successfully',
        },
        {
          'date': '18/02/2024',
          'status': 'Under Review',
          'description': 'Documents verified',
        },
        {
          'date': '22/02/2024',
          'status': 'Approved',
          'description': 'Claim approved for ₹42,000',
        },
        {
          'date': '25/02/2024',
          'status': 'Processing',
          'description': 'Claim is being processed',
        },
      ],
    },
    // {
    //   'claimNumber': 'CLM-2023-004',
    //   'policyType': 'Health Insurance',
    //   'policyNumber': 'POL-2023-001',
    //   'claimAmount': '₹25,000',
    //   'approvedAmount': '₹25,000',
    //   'status': 'Completed',
    //   'date': '15/12/2023',
    //   'description': 'Dental treatment',
    //   'hospital': 'Dental Care Clinic, Calicut',
    //   'doctor': 'Dr. Michael Chen',
    //   'treatmentDate': '12/12/2023',
    //   'documents': ['Dental Bill', 'Treatment Certificate', 'X-Ray Reports'],
    //   'timeline': [
    //     {
    //       'date': '15/12/2023',
    //       'status': 'Claim Filed',
    //       'description': 'Claim submitted successfully',
    //     },
    //     {
    //       'date': '18/12/2023',
    //       'status': 'Under Review',
    //       'description': 'Documents verified',
    //     },
    //     {
    //       'date': '20/12/2023',
    //       'status': 'Approved',
    //       'description': 'Claim approved for ₹25,000',
    //     },
    //     {
    //       'date': '22/12/2023',
    //       'status': 'Claim Settled',
    //       'description': 'Claim settled successfully',
    //     },
    //   ],
    // },
  ];

  List<Map<String, dynamic>> get filteredClaims {
    List<Map<String, dynamic>> filtered = allClaims;

    if (selectedFilter != 'All') {
      filtered = filtered
          .where((claim) => claim['status'] == selectedFilter)
          .toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (claim) =>
                claim['policyType'].toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                claim['claimNumber'].toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                claim['description'].toLowerCase().contains(
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
              );
            },
            icon: const Icon(Icons.add, color: AppConstants.whiteColor,size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
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
                    Icon(
                      Icons.swap_vert,
                      color: AppConstants.greyColor,
                      size: 20,
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
                'Pending',
                'Completed',
              ].length,
              itemBuilder: (context, index) {
                final filter = [
                  'All',
                  'Approved',
                  'Under Review',
                  'Pending',
                  'Completed',
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
                    _getClaimIcon(claim['policyType']),
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
                        text: claim['policyType'],
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
                      text: claim['status'],
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
                _buildDetailRow('Description', claim['description']),
                if (claim['approvedAmount'] != null)
                  _buildDetailRow('Approved Amount', claim['approvedAmount']),
                _buildDetailRow('Date', claim['date']),
                _buildDetailRow('Policy Number', claim['policyNumber']),
              ],
            ),
          ),

          // Action Button
          Container(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Track Status',
                    onPressed: () => _showClaimTimeline(claim),
                    color: AppConstants.secondaryColor,
                    textColor: AppConstants.blackColor,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return AppConstants.greenColor;
      case 'Under Review':
        return AppConstants.orangeColor;
      case 'Pending':
        return AppConstants.redColor;
      case 'Completed':
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
                _getClaimIcon(claim['policyType']),
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
                _buildDetailRow('Claim Number', claim['claimNumber']),
                _buildDetailRow('Policy Type', claim['policyType']),
                _buildDetailRow('Policy Number', claim['policyNumber']),
                _buildDetailRow('Description', claim['description']),
                _buildDetailRow('Claim Amount', claim['claimAmount']),
                if (claim['approvedAmount'] != null)
                  _buildDetailRow('Approved Amount', claim['approvedAmount']),
                _buildDetailRow('Status', claim['status']),
                _buildDetailRow('Date', claim['date']),

                if (claim['hospital'] != null) ...[
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
                  _buildDetailRow('Hospital', claim['hospital']),
                  if (claim['doctor'] != null)
                    _buildDetailRow('Doctor', claim['doctor']),
                  if (claim['admissionDate'] != null)
                    _buildDetailRow('Admission Date', claim['admissionDate']),
                  if (claim['dischargeDate'] != null)
                    _buildDetailRow('Discharge Date', claim['dischargeDate']),
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
                    _buildDetailRow('Accident Date', claim['accidentDate']),
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
                Navigator.of(context).pop();
                _showClaimTimeline(claim);
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
            text: 'Claim Timeline',
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
                  text: claim['claimNumber'],
                  size: 16,
                  weight: FontWeight.w600,
                  textColor: AppConstants.greyColor,
                ),
                const SizedBox(height: 16),
                ...claim['timeline'].asMap().entries.map<Widget>((entry) {
                  final index = entry.key;
                  final timeline = entry.value;
                  final isLast = index == claim['timeline'].length - 1;
                  final isProcessing = timeline['status'] == 'Processing';
                  final isCompleted =
                      timeline['status'] == 'Claim Settled' ||
                      timeline['status'] == 'Approved' ||
                      timeline['status'] == 'Under Review' ||
                      timeline['status'] == 'Claim Filed';

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
          ],
        );
      },
    );
  }
}
