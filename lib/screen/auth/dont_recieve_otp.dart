import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/otp_verification_provider.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/screen/auth/registration_screen.dart';

class DontReceiveOtpDialog extends StatefulWidget {
  final String? userName;
  final String? nrkId;
  
  const DontReceiveOtpDialog({
    super.key,
    this.userName,
    this.nrkId,
  });

  @override
  State<DontReceiveOtpDialog> createState() => _DontReceiveOtpDialogState();
}

class _DontReceiveOtpDialogState extends State<DontReceiveOtpDialog> {
  final _formKey = GlobalKey<FormState>();
  final _norkaIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate fields with data from OTP response
    _norkaIdController.text = widget.nrkId ?? '';
    _nameController.text = widget.userName ?? '';
  }

  @override
  void dispose() {
    _norkaIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppConstants.whiteColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      text: 'Update Phone Number',
                      size: 18,
                      weight: FontWeight.bold,
                      textColor: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                    ),
                  ),
                  
                ],
              ),
            ),
            
            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NORKA ID Field (Read-only)
                      _buildReadOnlyField(
                        controller: _norkaIdController,
                        label: 'NORKA ID',
                        icon: Icons.badge,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Name Field (Read-only)
                      _buildReadOnlyField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Phone Number Field with Country Code
                      _buildPhoneField(),
                      
                      const SizedBox(height: 16),
                      
                      // Info Box
                      
                    ],
                  ),
                ),
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppConstants.darkBackgroundColor
                    : Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppConstants.greyColor,
                      textColor: AppConstants.whiteColor,
                      height: 45,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Send OTP',
                      onPressed: _sendOtp,
                      color: AppConstants.primaryColor,
                      textColor: AppConstants.whiteColor,
                      height: 45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          size: 13,
          weight: FontWeight.w600,
          textColor: isDarkMode
              ? AppConstants.whiteColor
              : AppConstants.blackColor,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppConstants.darkBackgroundColor
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppConstants.greyColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppConstants.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppText(
                  text: controller.text.isEmpty ? 'Not available' : controller.text,
                  size: 14,
                  weight: FontWeight.w500,
                  textColor: controller.text.isEmpty
                      ? AppConstants.greyColor
                      : (isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Phone Number',
          size: 13,
          weight: FontWeight.w600,
          textColor: isDarkMode
              ? AppConstants.whiteColor
              : AppConstants.blackColor,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: TextStyle(
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Enter 10 digit mobile number',
            hintStyle: TextStyle(color: AppConstants.greyColor, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+91',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 20,
                    width: 1,
                    color: AppConstants.greyColor.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            filled: true,
            fillColor: isDarkMode
                ? AppConstants.darkBackgroundColor
                : AppConstants.whiteBackgroundColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppConstants.greyColor.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppConstants.greyColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppConstants.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppConstants.redColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppConstants.redColor,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length != 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneController.text.trim();
      
      // Check if phone number is filled
      if (phoneNumber.isEmpty) {
        ToastMessage.failedToast('Please enter your phone number');
        return;
      }
      
      // Construct complete phone number with country code
      final completePhoneNumber = '+91$phoneNumber';
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppConstants.boxBlackColor
                    : AppConstants.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Sending OTP...',
                    size: 16,
                    weight: FontWeight.w500,
                    textColor: Theme.of(context).brightness == Brightness.dark
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ],
              ),
            ),
          );
        },
      );

      try {
        final otpProvider = Provider.of<OtpVerificationProvider>(context, listen: false);
        
        print("=== SEND OTP DEBUG ===");
        print("Phone Number: $completePhoneNumber");
        print("======================");
        
        // Send OTP to the new phone number
        final otpSent = await otpProvider.sendOtp(completePhoneNumber);
        
        // Close loading dialog
        Navigator.of(context).pop();
        
        if (otpSent) {
          // ToastMessage.successToast('OTP sent successfully!');
          
          // Show OTP verification dialog
          _showOtpVerificationDialog(completePhoneNumber);
        } else {
          ToastMessage.failedToast('Failed to send OTP. Please try again.');
        }
        
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();
        
        ToastMessage.failedToast('Failed to send OTP');
        debugPrint('Error sending OTP: $e');
      }
    }
  }

  void _showOtpVerificationDialog(String phoneNumber) {
    final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDarkMode ? AppConstants.boxBlackColor : AppConstants.whiteColor,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: isDarkMode ? AppConstants.boxBlackColor : AppConstants.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppConstants.greyColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'OTP Verification',
                              size: 18,
                              weight: FontWeight.bold,
                              textColor: isDarkMode
                                  ? AppConstants.whiteColor
                                  : AppConstants.blackColor,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              text: 'Enter the code sent to $phoneNumber',
                              size: 14,
                              weight: FontWeight.normal,
                              textColor: AppConstants.greyColor,
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
                
                // Content
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Icon with gradient background
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.primaryColor.withOpacity(0.2),
                                AppConstants.primaryColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            size: 32,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 40,
                              child: TextField(
                                controller: otpControllers[index],
                                focusNode: focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? AppConstants.darkBackgroundColor
                                      : AppConstants.whiteBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppConstants.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppConstants.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppConstants.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Cancel',
                                onPressed: () {
                                  for (var controller in otpControllers) {
                                    controller.dispose();
                                  }
                                  for (var node in focusNodes) {
                                    node.dispose();
                                  }
                                  Navigator.of(dialogContext).pop();
                                },
                                color: AppConstants.greyColor,
                                textColor: AppConstants.whiteColor,
                                height: 45,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: 'Verify OTP',
                                onPressed: () {
                                  final otp = otpControllers.map((c) => c.text).join();
                                  _verifyOtpAndUpdatePhone(dialogContext, otp, phoneNumber, otpControllers, focusNodes);
                                },
                                color: AppConstants.primaryColor,
                                textColor: AppConstants.whiteColor,
                                height: 45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _verifyOtpAndUpdatePhone(
    BuildContext dialogContext,
    String otp,
    String phoneNumber,
    List<TextEditingController> otpControllers,
    List<FocusNode> focusNodes,
  ) async {
    if (otp.length != 6) {
      ToastMessage.failedToast('Please enter a valid 6-digit OTP');
      return;
    }

    // Show loading
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.boxBlackColor
                  : AppConstants.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                ),
                const SizedBox(height: 16),
                AppText(
                  text: 'Verifying OTP...',
                  size: 16,
                  weight: FontWeight.w500,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final otpProvider = Provider.of<OtpVerificationProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
      
      // Verify OTP
      final otpVerified = await otpProvider.verifyOtp(otp);
      
      if (otpVerified) {
        // OTP verified, now update the primary phone
        final nrkId = widget.nrkId ?? _norkaIdController.text.trim();
        
        final response = await verificationProvider.updatePrimaryMobile(nrkId, phoneNumber);
        
        // Close loading dialog
        Navigator.of(dialogContext).pop();
        
        if (response['success'] == true) {
          // Close OTP dialog
          for (var controller in otpControllers) {
            controller.dispose();
          }
          for (var node in focusNodes) {
            node.dispose();
          }
          Navigator.of(dialogContext).pop();
          
          // Close profile update dialog
          Navigator.of(context).pop();
          
          ToastMessage.successToast('Phone number updated successfully!');
          
          // Navigate to registration page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            ),
          );
        } else {
          ToastMessage.failedToast('Failed to update phone number');
        }
      } else {
        // Close loading dialog
        Navigator.of(dialogContext).pop();
        ToastMessage.failedToast('Invalid OTP. Please try again.');
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(dialogContext).pop();
      ToastMessage.failedToast('Error: $e');
      debugPrint('Error verifying OTP: $e');
    }
  }
}
