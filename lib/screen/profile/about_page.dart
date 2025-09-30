import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
          text: 'About Us',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white,
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Header Section with Logo
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      AppConstants.appLogo,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const AppText(
                    text: 'Norka Care',
                    size: 24,
                    weight: FontWeight.bold,
                    textColor: AppConstants.whiteColor,
                  ),
                  const SizedBox(height: 5),
                  const AppText(
                    text: 'Version 1.0.0',
                    size: 14,
                    weight: FontWeight.w400,
                    textColor: AppConstants.whiteColor,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Company Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About Norka Care'),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    'Norka Care is a leading insurance and financial services company committed to providing comprehensive protection and peace of mind to our customers. With years of experience in the industry, we offer innovative insurance solutions tailored to meet the diverse needs of individuals and families.',
                    isDarkMode,
                  ),

                  const SizedBox(height: 25),

                  _buildSectionTitle('Our Mission'),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    'To empower individuals and families with reliable insurance solutions that protect their future and provide financial security through innovative technology and exceptional customer service.',
                    isDarkMode,
                  ),

                  const SizedBox(height: 25),

                  _buildSectionTitle('Our Vision'),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    'To be the most trusted and preferred insurance partner, known for our commitment to customer satisfaction, technological innovation, and comprehensive coverage solutions.',
                    isDarkMode,
                  ),

                  const SizedBox(height: 25),

                  // Features Section
                  _buildSectionTitle('App Features'),
                  const SizedBox(height: 15),
                  _buildFeatureItem(
                    Icons.policy,
                    'Policy Management',
                    'View and manage all your insurance policies in one place',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    Icons.description,
                    'Document Storage',
                    'Secure storage for all your insurance documents',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    Icons.report_problem,
                    'Claims Processing',
                    'Easy and quick claims submission and tracking',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    Icons.family_restroom,
                    'Family Coverage',
                    'Manage family members and their insurance needs',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    Icons.payment,
                    'Secure Payments',
                    'Safe and convenient payment options',
                    isDarkMode,
                  ),
                  _buildFeatureItem(
                    Icons.support_agent,
                    '24/7 Support',
                    'Round-the-clock customer support',
                    isDarkMode,
                  ),

                  const SizedBox(height: 25),

                  // Contact Information
                  _buildSectionTitle('Contact Information'),
                  const SizedBox(height: 15),
                  _buildContactItem(
                    Icons.location_on,
                    'Address',
                    'Norka Care\nInsurance Division\nChennai, Tamil Nadu, India',
                    () {},
                    isDarkMode,
                  ),
                  _buildContactItem(
                    Icons.phone,
                    'Phone',
                    '+91 1800-XXX-XXXX',
                    () => _launchUrl('tel:+911800XXXXXXX'),
                    isDarkMode,
                  ),
                  _buildContactItem(
                    Icons.email,
                    'Email',
                    'support@norkacare.com',
                    () => _launchUrl('mailto:support@norkacare.com'),
                    isDarkMode,
                  ),
                  _buildContactItem(
                    Icons.language,
                    'Website',
                    'www.norkacare.com',
                    () => _launchUrl('https://www.norkacare.com'),
                    isDarkMode,
                  ),

                  const SizedBox(height: 25),

                  // Legal Information
                  _buildSectionTitle('Legal Information'),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    'This app is developed and maintained by Norka Care. All rights reserved. The information provided in this app is for general informational purposes only and should not be considered as professional advice.',
                    isDarkMode,
                  ),

                  const SizedBox(height: 15),

                  _buildInfoCard(
                    'Privacy Policy and Terms of Service apply. For detailed information, please visit our website or contact our customer support team.',
                    isDarkMode,
                  ),

                  const SizedBox(height: 30),

                  // Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppConstants.greyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const AppText(
                          text: '© 2025 Norka Care',
                          size: 14,
                          weight: FontWeight.w500,
                          textColor: AppConstants.greyColor,
                        ),
                        const SizedBox(height: 5),
                        const AppText(
                          text: 'All rights reserved',
                          size: 12,
                          weight: FontWeight.w400,
                          textColor: AppConstants.greyColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      size: 18,
      weight: FontWeight.bold,
      textColor: AppConstants.primaryColor,
    );
  }

  Widget _buildInfoCard(String content, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : AppConstants.greyColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppText(
        text: content,
        size: 14,
        weight: FontWeight.w400,
        textColor: isDarkMode
            ? AppConstants.whiteColor
            : AppConstants.blackColor,
        maxLines: 10,
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String description,
    bool isDarkMode,
  ) {
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
              : AppConstants.greyColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppConstants.primaryColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: title,
                  size: 16,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  text: description,
                  size: 13,
                  weight: FontWeight.w400,
                  textColor: AppConstants.greyColor,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String content,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                : AppConstants.greyColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppConstants.secondaryColor, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    size: 14,
                    weight: FontWeight.w600,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: content,
                    size: 13,
                    weight: FontWeight.w400,
                    textColor: AppConstants.greyColor,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.greyColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
