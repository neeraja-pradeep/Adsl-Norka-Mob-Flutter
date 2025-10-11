import 'package:norkacare_app/navigation/app_navigation_bar.dart';
import 'package:norkacare_app/screen/auth/dont_recieve_otp.dart';
import 'package:norkacare_app/screen/profile/profile_details_page.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/app_text.dart';
import 'package:provider/provider.dart';
import '../../provider/otp_verification_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/norka_provider.dart';
import '../verification/customer_details.dart';

class OtpVarification extends StatefulWidget {
  final String customerId;
  final Map<String, dynamic>? otpData;

  const OtpVarification({super.key, required this.customerId, this.otpData});

  @override
  State<OtpVarification> createState() => _OtpVarificationState();
}

class _OtpVarificationState extends State<OtpVarification>
    with TickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  String _enteredOtp = '';
  bool _canResendOtp = false;
  bool _isResendingOtp = false;
  int _resendCountdown = 60;
  String? _autoFillOtp;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _resendTimer;

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

    // Start the initial countdown
    _startResendCountdown();

    // Auto-fill OTP if available
    _autoFillOtpIfAvailable();
  }

  void _autoFillOtpIfAvailable() {
    if (widget.otpData != null && widget.otpData!['otp'] != null) {
      _autoFillOtp = widget.otpData!['otp'].toString();

      // Auto-fill the OTP fields after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _autoFillOtp != null && _autoFillOtp!.length == 6) {
          // Fill all 6 digits for 6-digit OTP
          String otpToFill = _autoFillOtp!;
          for (int i = 0; i < 6 && i < otpToFill.length; i++) {
            _otpControllers[i].text = otpToFill[i];
          }
          _updateOtpString();
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _resendTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    _resendCountdown = 60; // 1 minute countdown as per API requirement
    _canResendOtp = false;
    _isResendingOtp = false; // Reset resending state

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResendOtp = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatCountdown() {
    int minutes = _resendCountdown ~/ 60;
    int seconds = _resendCountdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getIdentifierLabel() {
    final identifier = widget.customerId;
    
    // Check if it's an email
    if (identifier.contains('@')) {
      return 'Email: $identifier';
    }
    
    // Check if it starts with + (definitely a phone number with country code)
    if (identifier.startsWith('+')) {
      return 'Phone: $identifier';
    }
    
    // Check if it contains letters (definitely a NORKA ID)
    if (identifier.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Norka ID: $identifier';
    }
    
    // Remove any non-digit characters for digit count
    String digitsOnly = identifier.replaceAll(RegExp(r'\D'), '');
    
    // If it's exactly 10 digits, it's likely a phone number
    if (digitsOnly.length == 10 && digitsOnly == identifier) {
      return 'Phone: $identifier';
    }
    
    // Otherwise, it's a Norka ID
    return 'Norka ID: $identifier';
  }

  Widget _buildHelpItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppText(
            text: text,
            size: 13,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
        ),
      ],
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _updateOtpString();
    setState(() {
      // Trigger UI rebuild to update border colors
    });
  }

  void _updateOtpString() {
    _enteredOtp = _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != 6) {
      ToastMessage.failedToast('Please enter a valid 6-digit OTP');
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

      // Verify OTP using API
      final otpVerified = await otpVerificationProvider.verifyOtp(_enteredOtp);

      if (otpVerified) {
        // ToastMessage.successToast('OTP verified successfully!');

        // Update NORKA provider with OTP verification response data
        final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
        final userData = otpVerificationProvider.getVerifiedCustomerData();
        
        // Debug logging
        debugPrint("=== OTP VERIFICATION DEBUG ===");
        debugPrint("Input (widget.customerId): ${widget.customerId}");
        debugPrint("User data from OTP verification: $userData");
        debugPrint("NORKA user details: ${otpVerificationProvider.norkaUserDetails}");
        debugPrint("Verification response: ${otpVerificationProvider.verificationResponse}");
        debugPrint("=================================");
        
        if (userData != null) {
          // Use the actual NORKA ID from the response for the provider
          final norkaId = userData['norka_id'] ?? widget.customerId;
          norkaProvider.setResponseDataFromOtpVerification(userData, norkaId);
          
          // Check enrollment status using the actual NORKA ID from the response
          if (mounted) {
            final hasEnrollment = await otpVerificationProvider.checkEnrollmentStatus(
              norkaId,
            );

            if (hasEnrollment) {
              // If enrollment exists, login user and go directly to AppNavigationBar
              debugPrint(
                "Enrollment found - logging in user and navigating to AppNavigationBar",
              );

              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.login(norkaId);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AppNavigationBar()),
              );
            } else {
              // If no enrollment found, follow normal flow to CustomerDetails
              debugPrint(
                "No enrollment found - following normal flow to CustomerDetails",
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDetails(
                    customerId: norkaId,
                    customerData: otpVerificationProvider
                        .getVerifiedCustomerData(),
                  ),
                ),
              );
            }
          }
        } else {
          // If no user data available, show error
          debugPrint("No user data available from OTP verification");
          ToastMessage.failedToast('Failed to get user data. Please try again.');
        }
      } else {
        ToastMessage.failedToast(
          otpVerificationProvider.errorMessage.isNotEmpty
              ? otpVerificationProvider.errorMessage
              : 'Invalid OTP. Please try again.',
        );
      }
    } catch (e) {
      ToastMessage.failedToast('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResendOtp || _isResendingOtp) return;

    // Immediately disable the button and show loading state
    setState(() {
      _isResendingOtp = true;
    });

    try {
      final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
        context,
        listen: false,
      );

      // Resend OTP using API
      final otpResent = await otpVerificationProvider.resendOtp();

      if (otpResent) {
        ToastMessage.successToast('OTP sent successfully!');
        // Restart the countdown
        _startResendCountdown();
      } else {
        ToastMessage.failedToast(
          otpVerificationProvider.errorMessage.isNotEmpty
              ? "Failed to resend OTP. Please try again."
              : 'Failed to resend OTP. Please try again.',
        );
        // Re-enable resend button if failed
        setState(() {
          _isResendingOtp = false;
        });
      }
    } catch (e) {
      ToastMessage.failedToast('An error occurred. Please try again.');
      // Re-enable resend button if error
      setState(() {
        _isResendingOtp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                  child: _buildOtpForm(),
                ),
              ],
            ),
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
              text: 'For Non-Resident Keralites (NRKs)',
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

  Widget _buildOtpForm() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              AppText(
                text: 'Enter OTP',
                size: 18,
                weight: FontWeight.w600,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text: _getIdentifierLabel(),
                size: 14,
                weight: FontWeight.w600,
                textColor: AppConstants.greyColor,
              ),
              const SizedBox(height: 32),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: 50,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppConstants.darkBackgroundColor
                          : Colors.white,
                      border: Border.all(
                        color: _otpControllers[index].text.isNotEmpty
                            ? AppConstants.primaryColor
                            : (isDarkMode
                                  ? AppConstants.greyColor
                                  : AppConstants.greyColor),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      cursorColor: AppConstants.primaryColor,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      onChanged: (value) => _onOtpChanged(value, index),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Verify Button
              CustomButton(
                text: _isLoading ? 'Verifying...' : 'Verify OTP',
                onPressed: _isLoading ? () {} : () => _verifyOtp(),
                color: AppConstants.primaryColor,
                textColor: AppConstants.whiteColor,
                height: 56,
              ),
              const SizedBox(height: 24),

              // Resend OTP
              Center(
                child: _canResendOtp && !_isResendingOtp
                    ? TextButton(
                        onPressed: _resendOtp,
                        child: AppText(
                          text: 'Resend OTP',
                          size: 16,
                          weight: FontWeight.w600,
                          textColor: AppConstants.primaryColor,
                        ),
                      )
                    : _isResendingOtp
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            text: 'Sending OTP...',
                            size: 16,
                            weight: FontWeight.w500,
                            textColor: AppConstants.primaryColor,
                          ),
                        ],
                      )
                    : AppText(
                        text: 'Resend OTP in ${_formatCountdown()}',
                        size: 16,
                        weight: FontWeight.w500,
                        textColor: AppConstants.greyColor,
                      ),
              ),

              const SizedBox(height: 20),
              
              // Update Profile Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    final otpProvider = Provider.of<OtpVerificationProvider>(context, listen: false);
                    final otpResponse = otpProvider.otpResponse;
                    
                    // Extract user data from OTP response
                    String? userName = otpResponse?['user_name'];
                    String? nrkId = otpResponse?['nrk_id'];
                    
                    print("=== DIALOG DATA DEBUG ===");
                    print("Full OTP Response: $otpResponse");
                    print("Extracted userName: $userName");
                    print("Extracted nrkId: $nrkId");
                    print("========================");
                    
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return DontReceiveOtpDialog(
                          userName: userName,
                          nrkId: nrkId,
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: AppConstants.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          text: "Don't receive OTP? Update your profile",
                          size: 14,
                          weight: FontWeight.w500,
                          textColor: AppConstants.primaryColor,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppConstants.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Help Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.primaryColor.withOpacity(0.1)
                      : AppConstants.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? AppConstants.primaryColor.withOpacity(0.2)
                        : AppConstants.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: AppConstants.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          text: 'Need Help?',
                          size: 16,
                          weight: FontWeight.w600,
                          textColor: AppConstants.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildHelpItem(
                      'Check your SMS inbox and email for the OTP',
                    ),
                    const SizedBox(height: 4),
                    _buildHelpItem(
                      'Make sure you\'re using the mobile number and email associated with your account',
                    ),

                    const SizedBox(height: 4),
                    _buildHelpItem(
                      'Email us at support.norkacare2@akshayagroup.net.in for assistance',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
