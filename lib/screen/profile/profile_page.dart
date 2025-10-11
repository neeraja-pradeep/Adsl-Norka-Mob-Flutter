// import 'package:norkacare_app/screen/profile/about_page.dart';
import 'package:norkacare_app/screen/profile/customer_support_page.dart';
import 'package:norkacare_app/screen/profile/payment_details_page.dart';
import 'package:norkacare_app/screen/profile/hospital_page.dart';
import 'package:norkacare_app/screen/profile/privacy_policy.dart';
import 'package:norkacare_app/screen/profile/terms_of_service.dart';
import 'package:norkacare_app/screen/insurence/my_policies_page.dart';
import 'package:norkacare_app/screen/insurence/documents_page.dart';
import 'package:norkacare_app/screen/insurence/my_claims_page.dart';
import 'package:norkacare_app/screen/homepage.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../auth/registration_screen.dart';
import 'view_family_members.dart';
import 'profile_details_page.dart';
import '../../main.dart';
import 'package:provider/provider.dart';
import '../../provider/norka_provider.dart';
import '../../provider/verification_provider.dart';
import '../../provider/otp_verification_provider.dart';
import '../../provider/hospital_provider.dart';
import '../../provider/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Profile image state
  File? _profileImage;
  // final ImagePicker _picker = ImagePicker();s

  @override
  void initState() {
    super.initState();
    // No need to call API here - data is already loaded in dashboard
  }

  String _extractName(BuildContext context) {
    // Get data from verification provider (unified API response)
    final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    
    String name = 'Not available'; // Default fallback

    // Try to get from unified API response first (family_info from dashboard API)
    if (verificationProvider.familyMembersDetails.isNotEmpty) {
      final familyData = verificationProvider.familyMembersDetails;
      if (familyData['nrk_name'] != null) {
        name = familyData['nrk_name'];
      }
    }
    // Fallback to NORKA provider if unified API data not available
    else if (norkaProvider.response != null &&
        norkaProvider.response!['name'] != null) {
      name = norkaProvider.response!['name'];
    }

    // Return the name as received from API (no formatting)
    return name;
  }

  String _extractCustomerId(BuildContext context) {
    // Get NORKA ID from provider
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );

    // Try to get from verified customer data first, then fallback to NORKA provider
    final verifiedCustomerData = otpVerificationProvider
        .getVerifiedCustomerData();
    if (verifiedCustomerData != null &&
        verifiedCustomerData['nrk_id'] != null) {
      return verifiedCustomerData['nrk_id'];
    } else if (norkaProvider.norkaId.isNotEmpty) {
      return norkaProvider.norkaId;
    } else {
      return 'Unknown ID';
    }
  }

  // String _getFamilyMemberCount(VerificationProvider verificationProvider) {
  //   if (!verificationProvider.hasFamilyMembersLoadedOnce &&
  //       verificationProvider.isFamilyMembersDetailsLoading) {
  //     return 'Loading...';
  //   }

  //   final familyCount =
  //       verificationProvider.familyMembersDetails['family_members_count'] ?? 0;
  //   return '$familyCount members';
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      body: Consumer2<NorkaProvider, VerificationProvider>(
        builder: (context, norkaProvider, verificationProvider, child) {
          // Extract dynamic name and customer ID from provider
          final displayName = _extractName(context);
          final displayCustomerId = _extractCustomerId(context);

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Profile Header Section
                _buildProfileHeader(displayName, displayCustomerId),

                const SizedBox(height: 20),

                // All Settings in One Container
                _buildAllSettingsContainer(verificationProvider),

                const SizedBox(height: 30),

                // Logout Button
                _buildLogoutButton(),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicy(),
                          ),
                        );
                      },
                      child: AppText(
                        text: "Privacy Policy",
                        size: 13,
                        weight: FontWeight.w500,
                        textColor: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsOfService(),
                          ),
                        );
                      },
                      child: AppText(
                        text: "Terms of Service",
                        size: 13,
                        weight: FontWeight.w500,
                        textColor: AppConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String customerId) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Profile Avatar with Edit Option
        Stack(
          children: [
            GestureDetector(
              // onTap: _showImagePickerDialog,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: AppConstants.primaryColor,
                    width: 3,
                  ),
                  image: _profileImage != null
                      ? DecorationImage(
                          image: FileImage(_profileImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profileImage == null
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppConstants.primaryColor,
                      )
                    : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Customer Name
        AppText(
          text: name,
          size: 18,
          weight: FontWeight.bold,
          textColor: isDarkMode
              ? AppConstants.whiteColor
              : AppConstants.blackColor,
        ),

        const SizedBox(height: 8),

        // Customer ID
        AppText(
          text: 'Norka ID: $customerId',
          size: 14,
          weight: FontWeight.w500,
          textColor: AppConstants.greyColor,
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAllSettingsContainer(VerificationProvider verificationProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
          // Profile
          _buildInfoTile(
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'View profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileDetailsPage(),
                ),
              );
            },
          ),
          _buildDivider(),
          // Family Members
          _buildFamilyMembersTile(
            icon: Icons.family_restroom,
            title: 'Family Members',
            subtitle: 'View family members',
            // memberCount: _getFamilyMemberCount(verificationProvider),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewFamilyMembers(),
                ),
              );
            },
          ),
          _buildDivider(),
          // Hospital List
          _buildSettingsTile(
            icon: Icons.local_hospital,
            title: 'Hospital List',
            subtitle: 'View available hospitals',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HospitalPage()),
              );
            },
          ),
          _buildDivider(),
          // Payments
          _buildPaymentTile(
            icon: Icons.wallet,
            title: 'Payments',
            subtitle: 'Transaction history',
            onTap: () {
              final norkaProvider = Provider.of<NorkaProvider>(
                context,
                listen: false,
              );
              final otpVerificationProvider =
                  Provider.of<OtpVerificationProvider>(context, listen: false);

              // Get NRK ID from verified customer data first, then fallback to NORKA provider
              String nrkId = norkaProvider.norkaId;
              final verifiedCustomerData = otpVerificationProvider
                  .getVerifiedCustomerData();
              if (verifiedCustomerData != null &&
                  verifiedCustomerData['nrk_id'] != null) {
                nrkId = verifiedCustomerData['nrk_id'];
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentDetailsPage(nrkId: nrkId),
                ),
              );
            },
          ),
          _buildDivider(),
          // Customer Support
          _buildSettingsTile(
            icon: Icons.support_agent,
            title: 'Customer Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerSupportPage(),
                ),
              );
            },
          ),
          // _buildDivider(),
          // // About
          // _buildSettingsTile(
          //   icon: Icons.info,
          //   title: 'About',
          //   subtitle: 'Company informations',
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const AboutPage()),
          //     );
          //   },
          // ),
          _buildDivider(),

          // Dark Theme Toggle
          _buildThemeToggleTile(),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.primaryColor.withOpacity(0.1),
          border: Border.all(
            color: AppConstants.primaryColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppConstants.primaryColor, size: 20),
      ),
      title: AppText(
        text: title,
        size: 16,
        weight: FontWeight.w600,
        textColor: isDarkMode
            ? AppConstants.whiteColor
            : AppConstants.blackColor,
      ),
      subtitle: AppText(
        text: subtitle,
        size: 15,
        weight: FontWeight.w500,
        textColor: AppConstants.greyColor,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppConstants.greyColor,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      color: isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.grey.withOpacity(0.2),
      indent: 70,
    );
  }

  Widget _buildPaymentTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.secondaryColor.withOpacity(0.1),
          border: Border.all(
            color: AppConstants.secondaryColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppConstants.secondaryColor, size: 20),
      ),
      title: AppText(
        text: title,
        size: 16,
        weight: FontWeight.w600,
        textColor: isDarkMode
            ? AppConstants.whiteColor
            : AppConstants.blackColor,
      ),
      subtitle: AppText(
        text: subtitle,
        size: 14,
        weight: FontWeight.normal,
        textColor: AppConstants.greyColor,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppConstants.greyColor,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildFamilyMembersTile({
    required IconData icon,
    required String title,
    required String subtitle,
    // required String memberCount,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.secondaryColor.withOpacity(0.1),
          border: Border.all(
            color: AppConstants.secondaryColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppConstants.secondaryColor, size: 20),
      ),
      title: Row(
        children: [
          Expanded(
            child: AppText(
              text: title,
              size: 16,
              weight: FontWeight.w600,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: AppConstants.secondaryColor.withOpacity(0.1),
          //     border: Border.all(
          //       color: AppConstants.secondaryColor.withOpacity(0.3),
          //       width: 1,
          //     ),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: AppText(
          //     text: memberCount,
          //     size: 12,
          //     weight: FontWeight.w500,
          //     textColor: AppConstants.secondaryColor,
          //   ),
          // ),
        ],
      ),
      subtitle: AppText(
        text: subtitle,
        size: 14,
        weight: FontWeight.normal,
        textColor: AppConstants.greyColor,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppConstants.greyColor,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.greenColor.withOpacity(0.1),
          border: Border.all(
            color: AppConstants.greenColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppConstants.greenColor, size: 20),
      ),
      title: AppText(
        text: title,
        size: 16,
        weight: FontWeight.w600,
        textColor: isDarkMode
            ? AppConstants.whiteColor
            : AppConstants.blackColor,
      ),
      subtitle: AppText(
        text: subtitle,
        size: 14,
        weight: FontWeight.normal,
        textColor: AppConstants.greyColor,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppConstants.greyColor,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeToggleTile() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ValueListenableBuilder<bool?>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.greenColor.withOpacity(0.1),
              border: Border.all(
                color: AppConstants.greenColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDark == true ? Icons.dark_mode : Icons.light_mode,
              color: AppConstants.greenColor,
              size: 20,
            ),
          ),
          title: AppText(
            text: 'Dark Mode',
            size: 16,
            weight: FontWeight.w600,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          subtitle: AppText(
            text: isDark == null
                ? 'Follow system theme'
                : (isDark ? 'Dark theme enabled' : 'Light theme enabled'),
            size: 14,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          trailing: Switch(
            value: isDark == true,
            activeColor: AppConstants.greenColor,
            inactiveThumbColor: AppConstants.blackColor,
            inactiveTrackColor: AppConstants.blackColor.withOpacity(0.3),
            onChanged: (bool value) async {
              await saveThemeMode(value);
              MyApp.themeNotifier.value = value;
            },
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomButton(
        text: 'Logout',
        onPressed: () {
          _showLogoutDialog();
        },
        color: AppConstants.redColor,
        textColor: AppConstants.whiteColor,
        height: 50,
      ),
    );
  }

  void _showLogoutDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),

          title: AppText(
            text: 'Logout',
            size: 20,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          content: AppText(
            text: 'Are you sure you want to logout?',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: AppText(
                text: 'Cancel',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.greyColor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: 'Logout',
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

  void _performLogout() async {
    try {
      // Get auth provider and perform logout
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Clear all provider data before logout
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(
        context,
        listen: false,
      );
      final hospitalProvider = Provider.of<HospitalProvider>(
        context,
        listen: false,
      );
      final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
        context,
        listen: false,
      );

      // Clear all data from providers including SharedPreferences
      debugPrint("=== CLEARING ALL PROVIDER DATA ===");
      await norkaProvider.clearAllData();
      await verificationProvider.clearAllData();
      hospitalProvider.clearData();
      otpVerificationProvider.clearData();
      debugPrint("✅ All provider data cleared successfully");

      // Reset my policies shimmer state
      MyPoliciesPage.resetShimmerState();
      await MyPoliciesPage.resetShimmerPreferences();

      // Reset documents shimmer state
      DocumentsPage.resetShimmerState();
      await DocumentsPage.resetShimmerPreferences();

      // Reset homepage shimmer state
      Homepage.resetShimmerState();
      await Homepage.resetShimmerPreferences();

      // Reset my claims shimmer state
      MyClaimsPage.resetShimmerState();
      await MyClaimsPage.resetShimmerPreferences();

      // Perform auth logout (this will clear auth-related SharedPreferences)
      await authProvider.logout();

      debugPrint("✅ All data cleared successfully during logout");

      // Navigate to registration screen after logout
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
        (route) => false, // This removes all previous routes from the stack
      );
    } catch (e) {
      debugPrint("❌ Error during logout: $e");
      // Even if there's an error, still navigate to registration screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
        (route) => false,
      );
    }
  }
}
