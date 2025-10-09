import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';

class FamilyMember {
  final String name;
  final String relationship;
  final String dateOfBirth;
  final String gender;
  final String enrollmentNumber;

  FamilyMember({
    required this.name,
    required this.relationship,
    required this.dateOfBirth,
    required this.gender,
    required this.enrollmentNumber,
  });
}

class ViewFamilyMembers extends StatefulWidget {
  const ViewFamilyMembers({super.key});

  @override
  State<ViewFamilyMembers> createState() => _ViewFamilyMembersState();
}

class _ViewFamilyMembersState extends State<ViewFamilyMembers> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilyData();
    });
  }

  void _loadFamilyData() async {
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );

    if (norkaProvider.norkaId.isNotEmpty) {
      // Use unified API to get all user data (including family and enrollment)
      if (!verificationProvider.hasFamilyMembersLoadedOnce || 
          !verificationProvider.hasEnrollmentDetailsLoadedOnce) {
        await verificationProvider.getUserDetailsForDashboard(norkaProvider.norkaId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Consumer<VerificationProvider>(
      builder: (context, verificationProvider, child) {
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
              text: 'Family Members',
              size: 20,
              weight: FontWeight.w600,
              textColor: Colors.white,
            ),
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                const SizedBox(height: 15),
                _buildHeader(verificationProvider),

                // Family Members List
                _buildFamilyMembersList(verificationProvider),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(VerificationProvider verificationProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final familyCount =
        verificationProvider.familyMembersDetails['family_members_count'] ?? 0;

    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.family_restroom,
              size: 30,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            text: 'Family Members',
            size: 24,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          // const SizedBox(height: 8),
          // AppText(
          //   text: '$familyCount family members covered',
          //   size: 16,
          //   weight: FontWeight.w500,
          //   textColor: AppConstants.greyColor,
          // ),
        ],
      ),
    );
  }

  Widget _buildFamilyMembersList(VerificationProvider verificationProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if ((!verificationProvider.hasFamilyMembersLoadedOnce &&
            verificationProvider.isFamilyMembersDetailsLoading) ||
        (!verificationProvider.hasEnrollmentDetailsLoadedOnce &&
            verificationProvider.isEnrollmentDetailsLoading)) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Covered Members',
              size: 16,
              weight: FontWeight.w600,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
            const SizedBox(height: 12),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              ),
            ),
            // const SizedBox(height: 8),
            // Center(
            //   child: AppText(
            //     text: verificationProvider.isFamilyMembersDetailsLoading
            //         ? 'Loading family members...'
            //         : 'Loading enrollment details...',
            //     size: 14,
            //     weight: FontWeight.normal,
            //     textColor: AppConstants.greyColor,
            //   ),
            // ),
          ],
        ),
      );
    }

    final familyData = verificationProvider.familyMembersDetails;
    if (familyData.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Covered Members',
              size: 16,
              weight: FontWeight.w600,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
            const SizedBox(height: 12),
            AppText(
              text: 'No family members found',
              size: 14,
              weight: FontWeight.normal,
              textColor: Colors.grey,
            ),
          ],
        ),
      );
    }

    List<FamilyMember> familyMembers = _convertApiDataToFamilyMembers(
      familyData,
      verificationProvider.enrollmentDetails,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Covered Members',
            size: 16,
            weight: FontWeight.w600,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          const SizedBox(height: 12),
          ...familyMembers
              .map((member) => _buildFamilyMemberCard(member))
              .toList(),
        ],
      ),
    );
  }

  List<FamilyMember> _convertApiDataToFamilyMembers(
Map<String, dynamic> familyData,
    Map<String, dynamic> enrollmentData,
  ) {
    List<FamilyMember> members = [];

    // Extract enrollment data - handle both old and new API response structures
    Map<String, dynamic> enrollmentDetails = {};
    if (enrollmentData.isNotEmpty) {
      // Check for unified API response structure (direct enrollment data)
      if (enrollmentData.containsKey('self_enrollment_number')) {
        enrollmentDetails = enrollmentData;
      }
      // Check for old API response structure (data wrapper)
      else if (enrollmentData['data'] != null) {
        enrollmentDetails = enrollmentData['data'];
      }
    }

    // Add Self
    if (familyData['nrk_name'] != null) {
      members.add(
        FamilyMember(
          name: familyData['nrk_name'] ?? '',
          relationship: 'Self',
          dateOfBirth: _formatDOB(familyData['dob'] ?? ''),
          gender: _formatGender(familyData['gender'] ?? ''),
          enrollmentNumber:
              enrollmentDetails['self_enrollment_number'] ?? 'Not Generated',
        ),
      );
    }

    // Add Spouse
    if (familyData['spouse_name'] != null &&
        familyData['spouse_name'].toString().isNotEmpty) {
      members.add(
        FamilyMember(
          name: familyData['spouse_name'] ?? '',
          relationship: 'Spouse',
          dateOfBirth: _formatDOB(familyData['spouse_dob'] ?? ''),
          gender: _formatGender(familyData['spouse_gender'] ?? ''),
          enrollmentNumber:
              enrollmentDetails['spouse_enrollment_number'] ?? 'Not Generated',
        ),
      );
    }

    // Add Children
    for (int i = 1; i <= 5; i++) {
      String kidName = familyData['kid_${i}_name'] ?? '';
      if (kidName.isNotEmpty) {
        members.add(
          FamilyMember(
            name: kidName,
            relationship: 'Child $i',
            dateOfBirth: _formatDOB(familyData['kid_${i}_dob'] ?? ''),
            gender: _getChildGender(familyData, i),
            enrollmentNumber:
                enrollmentDetails['child${i}_enrollment_number'] ??
                'Not Generated',
          ),
        );
      }
    }

    return members;
  }

  String _formatGender(String gender) {
    if (gender.isEmpty) return '';
    return gender.substring(0, 1).toUpperCase() +
        gender.substring(1).toLowerCase();
  }

  String _getChildGender(Map<String, dynamic> familyData, int childIndex) {
    // Get the relation field (Son/Daughter) and convert to gender (Male/Female)
    String relation = familyData['kid_${childIndex}_relation'] ?? '';
    String gender = '';
    
    if (relation.toLowerCase() == 'son') {
      gender = 'Male';
    } else if (relation.toLowerCase() == 'daughter') {
      gender = 'Female';
    }
    
    return _formatGender(gender);
  }

  String _formatDOB(String dob) {
    debugPrint('=== FAMILY MEMBERS DOB FORMATTING ===');
    debugPrint('Input DOB: "$dob"');

    if (dob.isEmpty) {
      debugPrint('DOB is empty, returning empty string');
      return '';
    }

    // Check if the date is in YYYY-MM-DD format (from unified API)
    if (dob.contains('-') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('-');
        debugPrint('Split parts: $parts');
        if (parts.length == 3) {
          // Check if first part is 4 digits (year) - YYYY-MM-DD format
          if (parts[0].length == 4) {
            String year = parts[0];
            String month = parts[1].padLeft(2, '0');
            String day = parts[2].padLeft(2, '0');

            // Convert from YYYY-MM-DD to DD/MM/YYYY
            String formattedDate = '$day/$month/$year';
            debugPrint('Formatted DOB (YYYY-MM-DD): "$formattedDate"');
            return formattedDate;
          }
          // Otherwise assume MM-DD-YYYY format
          else {
            String month = parts[0].padLeft(2, '0');
            String day = parts[1].padLeft(2, '0');
            String year = parts[2];

            // Convert from MM-DD-YYYY to DD/MM/YYYY
            String formattedDate = '$day/$month/$year';
            debugPrint('Formatted DOB (MM-DD-YYYY): "$formattedDate"');
            return formattedDate;
          }
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Check if the date is in MM/DD/YYYY format (with slashes)
    if (dob.contains('/') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('/');
        debugPrint('Split parts: $parts');
        if (parts.length == 3) {
          String month = parts[0].padLeft(2, '0');
          String day = parts[1].padLeft(2, '0');
          String year = parts[2];

          // Convert from MM/DD/YYYY to DD/MM/YYYY
          String formattedDate = '$day/$month/$year';
          debugPrint('Formatted DOB (MM/DD/YYYY): "$formattedDate"');
          return formattedDate;
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Return original if not in expected format
    debugPrint('No formatting applied, returning original: "$dob"');
    return dob;
  }

  Widget _buildFamilyMemberCard(FamilyMember member) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
              : AppConstants.primaryColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getRelationshipIcon(member.relationship),
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Member Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: member.name,
                  size: 16,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.secondaryColor.withOpacity(0.1),
                        border: Border.all(
                          color: AppConstants.secondaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppText(
                        text: member.relationship,
                        size: 12,
                        weight: FontWeight.w500,
                        textColor: AppConstants.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.greenColor.withOpacity(0.1),
                        border: Border.all(
                          color: AppConstants.greenColor.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppText(
                        text: member.gender,
                        size: 12,
                        weight: FontWeight.w500,
                        textColor: AppConstants.greenColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppConstants.greyColor,
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      text: 'DOB: ${member.dateOfBirth}',
                      size: 14,
                      weight: FontWeight.normal,
                      textColor: AppConstants.greyColor,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.badge,
                      size: 16,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: AppText(
                        text: 'Enrollment: ${member.enrollmentNumber}',
                        size: 14,
                        weight: FontWeight.w500,
                        textColor: member.enrollmentNumber == 'Not Generated'
                            ? Colors.orange
                            : AppConstants.primaryColor,
                      ),
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

  IconData _getRelationshipIcon(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'spouse':
        return Icons.favorite;
      case 'child':
        return Icons.child_care;
      case 'parent':
        return Icons.family_restroom;
      case 'sibling':
        return Icons.people;
      default:
        return Icons.person;
    }
  }
}
