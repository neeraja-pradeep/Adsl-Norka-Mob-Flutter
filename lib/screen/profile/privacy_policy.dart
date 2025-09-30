import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      appBar: AppBar(
        title: AppText(
          text: 'Privacy Policy',
          size: 18,
          weight: FontWeight.bold,
          textColor: Colors.white,
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  AppText(
                    text: '22/09/2025',
                    size: 13,
                    weight: FontWeight.normal,
                    textColor: isDarkMode
                        ? Colors.grey[400]!
                        : Colors.grey[600]!,
                    textAlign: TextAlign.center,
                    maxLines: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Introduction
            AppText(
              text:
                  'This Privacy Policy explains how Norka Care, operated by Akshaya Dynamic Solutions Pvt. Ltd. ("Company", "we", "our", "us"), collects, uses, stores, and protects your personal information when you use our mobile application ("App").',
              size: 14,
              weight: FontWeight.normal,
              textColor: isDarkMode ? Colors.white : Colors.black87,
              maxLines: 20,
            ),
            const SizedBox(height: 24),

            // Section 1
            _buildSection(
              '1. Information We Collect',
              'When you use the Norka Care App, we may collect:\n\n'
                  '• Personal Information: Name, date of birth, gender, contact number, email, address, ID documents, family details for insurance coverage.\n\n'
                  '• Insurance-related Information: Policy details, nominee details, claim information.\n\n'
                  '• Payment Information: Premium transaction details through HDFC Bank Payment Gateway.\n\n'
                  '• Device Information: IP address, device type, operating system, and usage logs.',
              isDarkMode,
            ),

            // Section 2
            _buildSection(
              '2. How We Use Your Information',
              'Your information is collected and processed for the following purposes:\n\n'
                  '• To facilitate enrollment, renewal, and management of your Norka Care insurance policy.\n\n'
                  '• To process premium payments securely.\n\n'
                  '• To share information with insurance partners (New India Assurance Co. Ltd.) and the appointed TPA (Vidal Health TPA Pvt. Ltd.) for policy servicing and claims settlement.\n\n'
                  '• To provide customer support and notify you about policy updates, renewals, and reminders.\n\n'
                  '• To maintain security, improve services, and prevent fraud.',
              isDarkMode,
            ),

            // Section 3
            _buildSection(
              '3. Information Sharing & Disclosure',
              'We may share your information with:\n\n'
                  '• New India Assurance Co. Ltd. (Insurer) – for issuing policies and settling claims.\n\n'
                  '• Vidal Health TPA Pvt. Ltd. (TPA) – for claims processing and health services.\n\n'
                  '• HDFC Bank (Payment Gateway) – for secure premium transactions.\n\n'
                  '• Government authority (NORKA ROOTS) – when legally required.\n\n'
                  '• Service providers engaged for IT, hosting, and support functions, under strict confidentiality obligations.\n\n'
                  'We do not sell or rent your personal information to any third party.',
              isDarkMode,
            ),

            // Section 4
            _buildSection(
              '4. Data Storage & Security',
              '• Data is stored on secure servers with encryption and restricted access.\n\n'
                  '• We follow reasonable security practices to protect your data.\n\n'
                  '• While we take all precautions, we cannot guarantee complete security of information transmitted online.\n\n'
                  '• Users must keep OTPs, passwords, and login details confidential.',
              isDarkMode,
            ),

            // Section 5
            _buildSection(
              '5. Your Rights',
              'As a user, you have the right to:\n\n'
                  '• Access and update your personal information.\n\n'
                  '• Request deletion of your account (subject to insurance policy requirements).\n\n'
                  '• Opt out of non-essential communications.',
              isDarkMode,
            ),

            // Section 6
            _buildSection(
              '6. Cookies & Tracking',
              'The App may use cookies or similar tools for functionality and analytics. You can manage these through device settings, but disabling them may affect performance.',
              isDarkMode,
            ),

            // Section 7
            _buildSection(
              '7. Data Retention',
              'We retain personal and insurance-related information for as long as required to provide services or as mandated by Indian law.',
              isDarkMode,
            ),

            // Section 8
            _buildSection(
              '8. Children\'s Privacy',
              'This App is not intended for individuals under the age of 18.',
              isDarkMode,
            ),

            // Section 9
            _buildSection(
              '9. Updates to Privacy Policy',
              'We may update this Privacy Policy from time to time. Updated versions will be posted within the App and will take effect from the date of publication.',
              isDarkMode,
            ),

            // Section 10
            _buildSection(
              '10. Contact Us',
              'For any queries or concerns, please contact our support team:\n\n'
                  '📧 Email: support.norkacare2@akshayagroup.net.in\n\n'
                  '🏢 Company: Akshaya Dynamic Solutions Pvt. Ltd.',
              isDarkMode,
            ),

            const SizedBox(height: 20),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppConstants.boxBlackColor
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                text:
                    'By using the Norka Care App, you acknowledge that you have read and understood this Privacy Policy.',
                size: 12,
                weight: FontWeight.normal,
                textColor: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
                textAlign: TextAlign.center,
                maxLines: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            size: 16,
            weight: FontWeight.bold,
            textColor: isDarkMode ? Colors.white : AppConstants.primaryColor,
            maxLines: 10,
          ),
          const SizedBox(height: 8),
          AppText(
            text: content,
            size: 13,
            weight: FontWeight.normal,
            textColor: isDarkMode ? Colors.white : Colors.black87,
            maxLines: 50,
          ),
        ],
      ),
    );
  }
}
