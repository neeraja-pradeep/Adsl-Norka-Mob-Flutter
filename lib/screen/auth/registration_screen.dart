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
import 'package:intl_phone_field/intl_phone_field.dart';

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
                const SizedBox(height: 24),

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


  void _handleRegister() async {
    String inputValue = '';
    String validationMessage = '';
    String successMessage = '';

    // Validate input based on selected method
    switch (_selectedLoginMethod) {
      case LoginMethod.norkaId:
        inputValue = _uniqueIdController.text.trim();
        if (inputValue.isEmpty) {
          validationMessage = 'Please enter your NORKA ID';
        } else if (inputValue.length < 3) {
          validationMessage = 'Please enter a valid NORKA ID';
        }
        // successMessage = 'OTP sent to your mobile number and email';
        break;
      case LoginMethod.email:
        inputValue = _emailController.text.trim();
        if (inputValue.isEmpty) {
          validationMessage = 'Please enter your email address';
        } else if (!_isValidEmail(inputValue)) {
          validationMessage = 'Please enter a valid email address';
        }
        // successMessage = 'OTP sent to your email address';
        break;
      case LoginMethod.phone:
        inputValue = '$_selectedCountryCode$_selectedPhoneNumber';
        if (_selectedPhoneNumber.isEmpty) {
          validationMessage = 'Please enter your phone number';
        } else if (!_isValidPhone(_selectedPhoneNumber)) {
          validationMessage = 'Please enter a valid phone number';
        }
        // successMessage = 'OTP sent to your phone number';
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
        
        // Customize error message based on login method
        switch (_selectedLoginMethod) {
          case LoginMethod.norkaId:
            errorMessage = otpVerificationProvider.errorMessage.isNotEmpty
                ? "Invalid NORKA ID"
                : 'Failed to send OTP. Please try again.';
            break;
          case LoginMethod.email:
            errorMessage = otpVerificationProvider.errorMessage.isNotEmpty
                ? "Invalid email address"
                : 'Failed to send OTP. Please try again.';
            break;
          case LoginMethod.phone:
            errorMessage = otpVerificationProvider.errorMessage.isNotEmpty
                ? "Invalid phone number"
                : 'Failed to send OTP. Please try again.';
            break;
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
