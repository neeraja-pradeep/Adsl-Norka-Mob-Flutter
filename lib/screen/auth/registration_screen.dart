import 'package:norkacare_app/screen/auth/otp_varification.dart';
// import 'package:norkacare_app/navigation/app_navigation_bar.dart';
import 'package:norkacare_app/widgets/custom_textfield.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/app_text.dart';
import 'package:provider/provider.dart';
import '../../provider/norka_provider.dart';
import '../../provider/verification_provider.dart';
import '../../provider/otp_verification_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _uniqueIdController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();

    // Clear any previous user data when registration screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearPreviousUserData();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _uniqueIdController.dispose();
    super.dispose();
  }

  void _clearPreviousUserData() {
    // Clear all provider data when registration screen loads
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );

    norkaProvider.clearData();
    verificationProvider.clearData();
    otpVerificationProvider.clearData();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    AppConstants.primaryColor,
                    AppConstants.darkBackgroundColor,
                    AppConstants.darkBackgroundColor,
                  ]
                : [AppConstants.primaryColor, Colors.white, Colors.white],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildHeader(),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      280,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: _buildLoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Image.asset(AppConstants.appLogo, height: 100, width: 100),
            ),
            const SizedBox(height: 10),
            AppText(
              text: 'Norka Care',
              size: 24,
              weight: FontWeight.bold,
              textColor: Colors.white,
            ),
            const SizedBox(height: 10),

            // App Subtitle
            AppText(
              text: 'Your Trusted Insurance Partner',
              size: 18,
              weight: FontWeight.w600,
              textColor: Colors.white,
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 28, right: 28, top: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                AppText(
                  text: 'Enroll now using your Norka ID',
                  size: 18,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),

                const SizedBox(height: 24),

                CustomTextfield(
                  controller: _uniqueIdController,
                  hintText: 'Norka ID',
                  labelText: 'Norka ID',
                  prefixIcon: Icons.person_outline,
                  isPassword: false,
                ),
                const SizedBox(height: 20),

                // Continue Button
                CustomButton(
                  text: _isLoading ? 'Please wait...' : 'Continue',
                  onPressed: _isLoading ? () {} : _handleRegister,
                  color: AppConstants.primaryColor,
                  textColor: Colors.white,
                  width: double.infinity,
                  height: 50,
                ),
                const SizedBox(height: 24),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: "Don't have a Norka ID? ",
                        size: 14,
                        weight: FontWeight.normal,
                        textColor: AppConstants.greyColor,
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            final Uri url = Uri.parse(
                              'https://id.norkaroots.kerala.gov.in',
                            );
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            ToastMessage.failedToast(
                              'Could not open the website',
                            );
                          }
                        },
                        child: AppText(
                          text: 'Click Here',
                          size: 14,
                          weight: FontWeight.w600,
                          textColor: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_uniqueIdController.text.isEmpty) {
      ToastMessage.failedToast('Please enter your Norka ID');
      return;
    }

    // Validate Norka ID format (you can customize this validation)
    if (_uniqueIdController.text.length < 3) {
      ToastMessage.failedToast('Please enter a valid Norka ID');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
        context,
        listen: false,
      );

      // Send OTP to user's email
      final otpSent = await otpVerificationProvider.sendOtp(
        _uniqueIdController.text.trim(),
      );

      if (otpSent) {
        // Show success toast message
        ToastMessage.successToast('OTP sent to your mobile number and email');

        // Navigate to OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpVarification(customerId: _uniqueIdController.text.trim()),
          ),
        );
      } else {
        ToastMessage.failedToast(
          otpVerificationProvider.errorMessage.isNotEmpty
              ? "Invalid Norka ID"
              : 'Failed to send OTP. Please try again.',
        );
      }
    } catch (e) {
      ToastMessage.failedToast('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
