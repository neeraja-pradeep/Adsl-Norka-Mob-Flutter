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
import '../../provider/notification_provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:marquee/marquee.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum LoginMethod { norkaId, email, phone }

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _uniqueIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  LoginMethod _selectedLoginMethod = LoginMethod.norkaId;
  String _selectedCountryCode = '+91';
  String _selectedPhoneNumber = '';
  bool _isNoticeExpanded = false;

  /// Check if the notification text is long enough to need expansion
  bool _shouldShowNoticeExpandButton(String message) {
    // Count newlines in the message
    final newlineCount = '\n'.allMatches(message).length;
    
    // Estimate characters per line (approximately 35-40 chars per line at font size 13)
    // With line height 1.5 and padding, roughly 38 characters fit per line
    const int approximateCharsPerLine = 38;
    const int maxLinesBeforeExpand = 3;
    
    // Show button if:
    // 1. There are 3 or more newlines (meaning 4+ lines)
    // 2. OR the total length suggests it would exceed 3 lines
    return newlineCount >= maxLinesBeforeExpand || 
           message.length > (approximateCharsPerLine * maxLinesBeforeExpand);
  }

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
      _ensureNotificationLoaded();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _uniqueIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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

  void _ensureNotificationLoaded() async {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    
    // Always fetch fresh notification when landing on registration screen
    // This ensures latest notification is shown after logout or app restart
    await notificationProvider.fetchNotification();
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

  Widget _buildLoginForm() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
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
                  text: 'Sign in to your account',
                  size: 18,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),

                const SizedBox(height: 24),

                // Login Method Selection
                _buildLoginMethodSelector(),

                const SizedBox(height: 20),

                // Input Field based on selected method
                _buildInputField(),
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
                const SizedBox(height: 14),

                // Only show NORKA ID link for NORKA ID login method
                if (_selectedLoginMethod == LoginMethod.norkaId)
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
                
                // Notice/Alert Message - Show for all login methods if notification message is not empty
                if (notificationProvider.notificationMessage.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  // Show red scrolling banner if is_important is true, otherwise show normal notice
                  notificationProvider.isImportant
                    ? _buildScrollingNotice(notificationProvider.notificationMessage)
                    : _buildNoticeMessage(notificationProvider.notificationMessage),
                ],
                
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginMethodSelector() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? AppConstants.primaryColor.withOpacity(0.1)
            : AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppConstants.primaryColor.withOpacity(0.3)
              : AppConstants.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMethodOption(
              LoginMethod.norkaId,
              'NORKA ID',
              Icons.person_outline,
            ),
          ),
          Expanded(
            child: _buildMethodOption(
              LoginMethod.email,
              'Email',
              Icons.email_outlined,
            ),
          ),
          Expanded(
            child: _buildMethodOption(
              LoginMethod.phone,
              'Phone',
              Icons.phone_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodOption(LoginMethod method, String label, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedLoginMethod == method;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLoginMethod = method;
          // Clear all controllers when switching methods
          _uniqueIdController.clear();
          _emailController.clear();
          _phoneController.clear();
          _selectedPhoneNumber = '';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    switch (_selectedLoginMethod) {
      case LoginMethod.norkaId:
        return CustomTextfield(
          controller: _uniqueIdController,
          hintText: 'Enter your Norka ID',
          labelText: 'NORKA ID',
          prefixIcon: Icons.person_outline,
          isPassword: false,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
        );
      case LoginMethod.email:
        return CustomTextfield(
          controller: _emailController,
          hintText: 'Enter your email address',
          labelText: 'Email Address',
          prefixIcon: Icons.email_outlined,
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
        );
      case LoginMethod.phone:
        return _buildPhoneInputField();
    }
  }

  Widget _buildPhoneInputField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return IntlPhoneField(
      controller: _phoneController,
      initialCountryCode: 'IN',
      cursorColor: AppConstants.primaryColor,
      style: TextStyle(
        color: isDarkMode
            ? AppConstants.whiteColor
            : AppConstants.blackColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Enter phone number',
        hintStyle: TextStyle(
          color: isDarkMode ? AppConstants.greyColor : Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppConstants.primaryColor.withOpacity(0.5)
                : AppConstants.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppConstants.primaryColor.withOpacity(0.5)
                : AppConstants.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: isDarkMode ? AppConstants.darkBackgroundColor : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: (phone) {
        setState(() {
          _selectedCountryCode = phone.countryCode;
          _selectedPhoneNumber = phone.number;
        });
      },
      onCountryChanged: (country) {
        setState(() {
          _selectedCountryCode = '+${country.dialCode}';
        });
      },
    );
  }

  Widget _buildScrollingNotice(String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.red.shade900, Colors.red.shade800]
              : [Colors.red.shade600, Colors.red.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Marquee scrolling text
            Marquee(
              text: '   •   ${message.toUpperCase()}   ',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              blankSpace: 100.0,
              velocity: 80.0, // Adjust speed here (pixels per second)
              pauseAfterRound: Duration.zero,
              startPadding: 0.0,
              accelerationDuration: Duration.zero,
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration.zero,
              decelerationCurve: Curves.linear,
            ),
            // Warning icon on the left
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.red.shade900, Colors.red.shade900.withOpacity(0)]
                        : [Colors.red.shade600, Colors.red.shade600.withOpacity(0)],
                    stops: const [0.8, 1.0],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeMessage(String notificationMessage) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.greyColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.red,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Notification',
                  size: 14,
                  weight: FontWeight.bold,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: notificationMessage,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: isDarkMode
                              ? AppConstants.greyColor
                              : Colors.grey[700]!,
                          height: 1.5,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      maxLines: _isNoticeExpanded ? null : 3,
                      overflow: _isNoticeExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    // Show More/Less button - only show if text exceeds 3 lines
                    if (_shouldShowNoticeExpandButton(notificationMessage))
                      ...[
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isNoticeExpanded = !_isNoticeExpanded;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isNoticeExpanded ? 'Show Less' : 'Show More',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppConstants.primaryColor,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _isNoticeExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppConstants.primaryColor,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _handleRegister() async {
    String inputValue = '';
    String validationMessage = '';

    // Validate input based on selected method
    switch (_selectedLoginMethod) {
      case LoginMethod.norkaId:
        inputValue = _uniqueIdController.text.trim().toUpperCase();
        if (inputValue.isEmpty) {
          validationMessage = 'Please enter your NORKA ID';
        } else if (!_isValidNorkaId(inputValue)) {
          validationMessage = 'Please enter a valid NORKA ID';
        }
        break;
      case LoginMethod.email:
        inputValue = _emailController.text.trim();
        if (inputValue.isEmpty) {
          validationMessage = 'Please enter your email address';
        } else if (!_isValidEmail(inputValue)) {
          validationMessage = 'Please enter a valid email address';
        }
        break;
      case LoginMethod.phone:
        inputValue = '$_selectedCountryCode$_selectedPhoneNumber';
        if (_selectedPhoneNumber.isEmpty) {
          validationMessage = 'Please enter your phone number';
        } else if (!_isValidPhone(_selectedPhoneNumber)) {
          validationMessage = 'Please enter a valid phone number';
        }
        break;
    }

    if (validationMessage.isNotEmpty) {
      ToastMessage.failedToast(validationMessage);
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

      // Send OTP based on login method
      final otpSent = await otpVerificationProvider.sendOtp(inputValue);

      if (otpSent) {
        // Show success toast message
        // ToastMessage.successToast(successMessage);

        // Navigate to OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVarification(customerId: inputValue),
          ),
        );
      } else {
        String errorMessage = 'Failed to send OTP. Please try again.';
        
        // Check if the error message is from external service verification failure
        if (otpVerificationProvider.errorMessage.isNotEmpty) {
          final providerError = otpVerificationProvider.errorMessage;
          final normalizedError = providerError.toLowerCase();

          // If error is about unable to verify credentials with external service, show generic invalid message
          if (normalizedError.contains('unable to verify credentials with external service')) {
            // Show generic invalid message based on login method
            switch (_selectedLoginMethod) {
              case LoginMethod.norkaId:
                errorMessage = 'Invalid NORKA ID';
                break;
              case LoginMethod.email:
                errorMessage = 'Invalid email address';
                break;
              case LoginMethod.phone:
                errorMessage = 'Invalid phone number';
                break;
            }
          }
          // If error is about enrollment closed, show simplified message
          else if (normalizedError.contains('enrollment is closed') ||
              normalizedError.contains('enrollment is currently closed')) {
            errorMessage = 'Enrollment is closed.';
          } 
          else {
            // For any other errors, show invalid message based on login method
            switch (_selectedLoginMethod) {
              case LoginMethod.norkaId:
                errorMessage = 'Invalid NORKA ID';
                break;
              case LoginMethod.email:
                errorMessage = 'Invalid email address';
                break;
              case LoginMethod.phone:
                errorMessage = 'Invalid phone number';
                break;
            }
          }
        } else {
          // Fallback generic messages if no specific error from server
          switch (_selectedLoginMethod) {
            case LoginMethod.norkaId:
              errorMessage = 'Invalid NORKA ID';
              break;
            case LoginMethod.email:
              errorMessage = 'Invalid email address';
              break;
            case LoginMethod.phone:
              errorMessage = 'Invalid phone number';
              break;
          }
        }
        
        ToastMessage.failedToast(errorMessage);
      }
    } catch (e) {
      ToastMessage.failedToast('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidNorkaId(String id) {
    final trimmed = id.trim().toUpperCase();

    if (trimmed.contains('@')) {
      return false;
    }

    if (trimmed.startsWith('+')) {
      return false;
    }

    if (trimmed.length < 3) {
      return false;
    }

    // Allow uppercase letters, digits, and separators like / or -
    final pattern = RegExp(r'^[A-Z0-9][A-Z0-9\-/]{2,}$');
    return pattern.hasMatch(trimmed);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Remove any non-digit characters for validation
    String digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    // Check if it's a valid phone number (7-15 digits for international)
    return digitsOnly.length >= 7 && digitsOnly.length <= 15;
  }
}
