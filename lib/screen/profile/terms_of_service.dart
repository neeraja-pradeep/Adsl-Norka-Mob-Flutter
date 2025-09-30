import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({super.key});

  @override
  State<TermsOfService> createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      appBar: AppBar(
        title: AppText(
          text: 'Terms of Service',
          size: 18,
          weight: FontWeight.bold,
          textColor: Colors.white,
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
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
                    size: 12,
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

            // Basic Conditions
            _buildSection(
              'Basic Conditions',
              'Definitions\n\n'
                  '"App" refers to the Norka Care Insurance mobile application.\n\n'
                  '"User" / "You" refers to any individual accessing or using the App.\n\n'
                  '"Norka Care" refers to the insurance scheme facilitated by [NORKA Roots / Government of Kerala], insured by New India Assurance Co. Ltd., and administered by Vidal Health TPA Pvt. Ltd. Authorised company to proceeds the project is Akshayadynamic Solution Pvt Limited\n\n'
                  '"Service Providers" refers to insurers, TPAs, banks, and other third parties integrated with the App.',
              isDarkMode,
            ),

            // Eligibility
            _buildSection(
              '2. Eligibility',
              'The App is intended for Non-Resident Keralites (NRKs), who have NRK Id care (18 to 70 age band) and their family members eligible under the Norka Care Insurance Scheme.\n\n'
                  'Master Users must be at least 18 years old to register and purchase insurance.',
              isDarkMode,
            ),

            // Use of the App
            _buildSection(
              '3. Use of the App',
              'The App is to be used only for applying, renewing, managing, and accessing Norka Care Insurance and policies.\n\n'
                  'Users agree to provide accurate, complete, and updated information during registration and policy enrollment.\n\n'
                  'Misuse, unauthorized access, or fraudulent use of the App is strictly prohibited.',
              isDarkMode,
            ),

            // Insurance Policy
            _buildSection(
              '4. Insurance Policy',
              'All insurance coverage, benefits, exclusions, and conditions are governed by the official policy terms issued by New India Assurance Co. Ltd.\n\n'
                  'The App only facilitates enrollment, payment, and e-card generation and service for further\n\n'
                  'Norka Roots, Vidal Health TPA, and other service providers shall not be held liable for claims beyond the scope of the insurance policy.',
              isDarkMode,
            ),

            // Important Policy Benefits - GMC
            _buildSection(
              '4.1 Important Policy Benefits - GMC (Group Medical Coverage)',
              '• GMC Coverage: Rs 5 Lakhs per Year per Family\n\n'
                  '• Coverage of Rs 5 Lakhs for Individuals also\n\n'
                  '• Room Rent: Rs 5,000/- Per day and ICU Rs 10,000/- per Day\n\n'
                  '• Medical Expenses: No limits up to 5 Lakhs Sum Assured\n\n'
                  '• No Medical Check up to 70 Years and no rejections\n\n'
                  '• Day 1 Coverage for any pre-existing disease\n\n'
                  '• Chemo, Dialysis etc. will be covered after discharge without admission as day care procedure\n\n'
                  '• No Co-Pay for any claims\n\n'
                  '• Ayush covered up to Rs 50,000 per year (Ayurveda, Yoga & Naturopathy, Unani, Sidha and Homeopathy) with IP\n\n'
                  '• Cataract Covered Rs 30,000/- per eye without admission\n\n'
                  '• Up to 25 years: 2 kids can continue under Family Cover without any additional Premium. Additional kids more than 2 can be added with additional premium\n\n'
                  '• 30 days Pre and 60 days Post hospitalization medical expenses can claim up to Rs 5,000 Per claim\n\n'
                  '• No medical check up or any kind of health declaration required for enrolment from 18 - 70 years\n\n'
                  '• No Premium Loading for policy renewals due to Claim, age band change etc. Flat premium for 18 - 70 years\n\n'
                  '• Portability benefits available after 70 years or anybody changes their NRK status with all benefits and no medicals required for converting as an Individual Policy\n\n'
                  '• Maternity not covered but any hospitalization except delivery covered and new born baby covered from Day One\n\n'
                  '• Option for Family Sum Assured of 5 Lakhs or Individual SA of 5 Lakhs if NRK id is separate in the same family\n\n'
                  '• After 25 years for kids, portability benefits available to continue the coverages or can join with Norka Care with an NRK Card is eligible\n\n'
                  '• Organ Transplant if any covered up to the Sum Assured\n\n'
                  '• No Premium increments due to high claims or confirmed claims like hemodialysis if any\n\n'
                  '• No waiting Period\n\n'
                  '• No Premium loading\n\n'
                  '• No Co-pay\n\n'
                  '• Up to 70 Years eligible\n\n'
                  '• No Medical check up',
              isDarkMode,
            ),

            // Important Policy Benefits - GPA
            _buildSection(
              '4.2 Important Policy Benefits - GPA (Group Personal Accident)',
              '• Any Kind of Accidental Death Across the World: Rs 10 Lakhs Sum Assured\n\n'
                  '• Permanent Total Disability: Rs 10 Lakhs\n\n'
                  '• Loss of both hands or both feet: Rs 10 Lakhs\n\n'
                  '• Loss of One hand and one foot: Rs 10 Lakhs\n\n'
                  '• Loss of one eye and one hand or foot: Rs 10 Lakhs\n\n'
                  '• Total permanent Paralysis due to accident: Rs 10 Lakhs\n\n'
                  '• Loss of Vision in both eyes: Rs 10 Lakhs\n\n'
                  '• Hearing Loss - Both ears: Rs 7.5 Lakhs\n\n'
                  '• Loss of One Eye/Hand/Foot: Rs 5 Lakhs\n\n'
                  '• Loss of One Hand and 4 fingers: Rs 5 Lakhs\n\n'
                  '• Loss of 4 fingers and thumb of one hand: Rs 5 Lakhs\n\n'
                  '• Loss of four fingers: Rs 3.5 Lakhs\n\n'
                  '• Loss of thumb: Rs 2.5 Lakhs\n\n'
                  '• Body repatriation: Rs 50,000/- for outside India\n\n'
                  '• Body repatriation: Rs 25,000/- for Inside India',
              isDarkMode,
            ),

            // Payments
            _buildSection(
              '6. Payments',
              'Premiums are payable online through secure payment gateways integrated in the App (e.g., HDFC Bank).\n\n'
                  'Users are responsible for ensuring correct payment details.\n\n'
                  'Once paid, premiums are non-refundable except as per insurer\'s refund/cancellation rules.',
              isDarkMode,
            ),

            // Data Privacy & Security
            _buildSection(
              '7. Data Privacy & Security',
              'User data (including personal details, medical information, and payment details) will be collected and processed solely for the purpose of insurance enrollment and administration.\n\n'
                  'Data may be shared with insurers, TPAs, banks, and authorized government agencies.\n\n'
                  'The App follows reasonable security practices, but Norka Care shall not be liable for unauthorized access due to user negligence (e.g., sharing OTP, passwords).',
              isDarkMode,
            ),

            // User Responsibilities
            _buildSection(
              '8. User Responsibilities',
              'Maintain confidentiality of login credentials, OTPs, and policy information.\n\n'
                  'Update profile details promptly in case of changes (address, contact, family members, etc.).\n\n'
                  'Ensure compliance with local laws of the country of residence.',
              isDarkMode,
            ),

            // Limitation of Liability
            _buildSection(
              '9. Limitation of Liability',
              'Norka Roots and service providers will not be responsible for any:\n\n'
                  '• Technical errors, downtime, or network issues.\n\n'
                  '• Delays in OTP delivery, payment processing, or policy issuance.\n\n'
                  '• Indirect, incidental, or consequential damages arising from App usage.',
              isDarkMode,
            ),

            // Intellectual Property
            _buildSection(
              '10. Intellectual Property',
              'All content, logos, designs, and features of the App are owned by Norka Roots or its partners.\n\n'
                  'Users may not copy, reproduce, or misuse any content without prior written permission.',
              isDarkMode,
            ),

            // Amendments
            _buildSection(
              '11. Amendments',
              'Norka Roots reserves the right to update, modify, or replace these Terms at any time.\n\n'
                  'Continued use of the App after changes constitutes acceptance of the revised Terms.',
              isDarkMode,
            ),

            // Governing Law & Jurisdiction
            _buildSection(
              '12. Governing Law & Jurisdiction',
              'These Terms shall be governed by the laws of India.\n\n'
                  'Any disputes shall be subject to the jurisdiction of the courts in Thiruvananthapuram, Kerala.',
              isDarkMode,
            ),

            // Contact Information
            _buildSection(
              '13. Contact Information',
              'For queries, complaints, or support, please contact:\n\n'
                  'Toll-Free Number: 1800 2022 501, 502\n\n'
                  'Email: support.norkacare2@akshayagroup.net.in',
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
                    'By using the Norka Care App, you acknowledge that you have read and understood these Terms of Service.',
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
