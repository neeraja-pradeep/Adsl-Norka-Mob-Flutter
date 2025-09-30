import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text.dart';
import 'profile_widgets/landbot_chat_page.dart';

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({super.key});

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final List<FAQItem> faqItems = [
    // FAQItem(
    //   question: 'What documents do I need for claim processing?',
    //   answer:
    //       'You typically need medical bills, prescriptions, discharge summary, and any other relevant medical documents. The specific requirements may vary based on your policy.',
    // ),
    // FAQItem(
    //   question: 'How long does claim processing take?',
    //   answer:
    //       'Standard claims are usually processed within 7-14 business days. Complex cases may take longer. You can track your claim status in the app.',
    // ),
    // FAQItem(
    //   question: 'How do I add family members to my policy?',
    //   answer:
    //       'Navigate to the "Family Members" section in your profile, tap "Add Family Member", and provide the required details and documents.',
    // ),
    // FAQItem(
    //   question: 'Can I change my policy details?',
    //   answer:
    //       'Policy modifications can be made through our customer support team. Contact us for assistance with any policy changes.',
    // ),
    // FAQItem(
    //   question: 'What is the premium payment due date?',
    //   answer:
    //       'Premium due dates vary by policy. You can check your payment schedule in the "My Policies" section of the app.',
    // ),
  ];

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
          text: 'Customer Support',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white,
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(isDarkMode),
            _buildContactMethodsSection(isDarkMode),
            // _buildFAQSection(isDarkMode),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isDarkMode) {
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
        children: [
          Icon(Icons.support_agent, size: 48, color: AppConstants.whiteColor),
          const SizedBox(height: 12),
          AppText(
            text: 'How can we help you?',
            size: 20,
            weight: FontWeight.bold,
            textColor: AppConstants.whiteColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AppText(
            text:
                'We\'re here to assist you with any questions or concerns about your insurance policy.',
            size: 14,
            weight: FontWeight.normal,
            textColor: AppConstants.whiteColor.withOpacity(0.9),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethodsSection(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Contact Us',
            size: 18,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            title: 'Call Support',
            subtitle: 'Speak with our experts',
            icon: Icons.phone,
            color: AppConstants.greenColor,
            onTap: () => _launchPhoneCall(),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            title: 'Email Support',
            subtitle: 'Send us an email',
            icon: Icons.email,
            color: AppConstants.blueColor,
            onTap: () => _launchEmail(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 12),
          _buildContactCard(
            title: 'WhatsApp',
            subtitle: 'Message us on WhatsApp',
            icon: Icons.message,
            color: const Color(0xFF25D366),
            onTap: () => _launchWhatsApp(),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            title: 'AI Live Chat',
            subtitle: 'Chat with AI support assistant',
            icon: Icons.smart_toy,
            color: AppConstants.orangeColor,
            onTap: () => _launchLiveChat(),
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
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
                    text: subtitle,
                    size: 12,
                    weight: FontWeight.w500,
                    textColor: AppConstants.greyColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.greyColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFAQSection(bool isDarkMode) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         AppText(
  //           text: 'Frequently Asked Questions',
  //           size: 18,
  //           weight: FontWeight.bold,
  //           textColor: isDarkMode
  //               ? AppConstants.whiteColor
  //               : AppConstants.blackColor,
  //         ),
  //         const SizedBox(height: 16),
  //         ListView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: faqItems.length,
  //           itemBuilder: (context, index) {
  //             return _buildFAQItem(faqItems[index], isDarkMode);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFAQItem(FAQItem item, bool isDarkMode) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     decoration: BoxDecoration(
  //       color: isDarkMode
  //           ? AppConstants.boxBlackColor
  //           : AppConstants.whiteColor,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: isDarkMode
  //             ? Colors.white.withOpacity(0.1)
  //             : Colors.grey.withOpacity(0.2),
  //         width: 1,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: isDarkMode
  //               ? Colors.black.withOpacity(0.3)
  //               : Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 5,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: ExpansionTile(
  //       iconColor: AppConstants.primaryColor,
  //       collapsedIconColor: AppConstants.primaryColor,
  //       title: AppText(
  //         text: item.question,
  //         size: 16,
  //         weight: FontWeight.w600,
  //         textColor: isDarkMode
  //             ? AppConstants.whiteColor
  //             : AppConstants.blackColor,
  //       ),
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //           child: AppText(
  //             text: item.answer,
  //             size: 13,
  //             weight: FontWeight.normal,
  //             textColor: AppConstants.greyColor,
  //             maxLines: 10,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _launchPhoneCall() async {
    const phoneNumber = '18002022501';
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Could not launch phone dialer')),
      // );
    }
  }

  void _launchEmail() async {
    const email = 'support.norkacare2@akshayagroup.net.in ';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Customer Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Could not launch email client')),
      // );
    }
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

  void _launchWhatsApp() async {
    const phoneNumber = '+919364084960';
    const message = 'Hello! I need help with my insurance policy.';
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Could not launch WhatsApp')),
      // );
    }
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
