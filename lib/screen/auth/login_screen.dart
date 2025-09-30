// import 'package:norkacare_app/screen/auth/registration_screen.dart';
// import 'package:norkacare_app/widgets/custom_textfield.dart';
// import 'package:norkacare_app/widgets/toast_message.dart';
// import 'package:flutter/material.dart';
// import '../../utils/constants.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/app_text.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _uniqueIdController = TextEditingController(); // mobile
//   final _otpController = TextEditingController();

//   bool _isLoading = false;
//   bool _isVerifying = false;
//   bool _showOtpField = false;
//   int _resendCountdown = 0; // seconds left until resend enabled

//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

//     _fadeController.forward();
//     _slideController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _uniqueIdController.dispose();
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomRight,
//             colors: isDarkMode
//                 ? [
//                     AppConstants.primaryColor,
//                     AppConstants.darkBackgroundColor,
//                     AppConstants.darkBackgroundColor,
//                   ]
//                 : [AppConstants.primaryColor, Colors.white, Colors.white],
//             stops: const [0.0, 0.5, 1.0],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 32),
//               _buildHeader(),
//               Container(
//                 width: double.infinity,
//                 constraints: BoxConstraints(
//                   minHeight:
//                       MediaQuery.of(context).size.height -
//                       MediaQuery.of(context).padding.top -
//                       280,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? AppConstants.darkBackgroundColor
//                       : AppConstants.whiteBackgroundColor,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(32),
//                     topRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: _buildLoginForm(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(color: Colors.transparent),
//               child: Image.asset(AppConstants.appLogo, height: 100, width: 100),
//             ),
//             const SizedBox(height: 10),
//             AppText(
//               text: 'Norka Care',
//               size: 24,
//               weight: FontWeight.bold,
//               textColor: Colors.white,
//             ),
//             const SizedBox(height: 10),
//             AppText(
//               text: 'Your Trusted Insurance Partner',
//               size: 18,
//               weight: FontWeight.w600,
//               textColor: Colors.white,
//             ),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 28, right: 28, top: 10),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 AppText(
//                   text: 'Sign in',
//                   size: 18,
//                   weight: FontWeight.w600,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),

//                 const SizedBox(height: 24),

//                 // Mobile field (always visible)
//                 CustomTextfield(
//                   controller: _uniqueIdController,
//                   hintText: 'Mobile Number',
//                   labelText: 'Mobile Number',
//                   prefixIcon: Icons.phone_outlined,
//                   isPassword: false,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 20),

//                 // OTP field (animated)
//                 AnimatedSize(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   child: _showOtpField
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomTextfield(
//                               controller: _otpController,
//                               hintText: 'Enter OTP',
//                               labelText: 'OTP',
//                               prefixIcon: Icons.lock_outline,
//                               isPassword: false,
//                               keyboardType: TextInputType.number,
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 TextButton(
//                                   onPressed: _resendCountdown == 0
//                                       ? _resendOtp
//                                       : null,
//                                   child: AppText(
//                                     text: _resendCountdown == 0
//                                         ? 'Resend OTP'
//                                         : 'Resend in ${_resendCountdown}s',
//                                     size: 14,
//                                     weight: FontWeight.w600,
//                                     textColor: AppConstants.primaryColor,
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: _editMobile,
//                                   child: AppText(
//                                     text: 'Edit Mobile',
//                                     size: 14,
//                                     weight: FontWeight.w600,
//                                     textColor: AppConstants.greyColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                           ],
//                         )
//                       : const SizedBox.shrink(),
//                 ),

//                 // Continue / Verify Button
//                 CustomButton(
//                   text: _isLoading
//                       ? 'Please wait...'
//                       : (_showOtpField
//                             ? (_isVerifying ? 'Verifying...' : 'Verify')
//                             : 'Continue'),
//                   onPressed: (_isLoading || _isVerifying)
//                       ? () {}
//                       : (_showOtpField ? _verifyOtp : _handleContinue),
//                   color: AppConstants.primaryColor,
//                   textColor: Colors.white,
//                   width: double.infinity,
//                   height: 50,
//                 ),
//                 const SizedBox(height: 24),

//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       AppText(
//                         text: "Dont have an policy? ",
//                         size: 14,
//                         weight: FontWeight.normal,
//                         textColor: AppConstants.greyColor,
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) {
//                                 return const RegisterScreen();
//                               },
//                             ),
//                           );
//                         },
//                         child: AppText(
//                           text: 'Register',
//                           size: 14,
//                           weight: FontWeight.w600,
//                           textColor: AppConstants.primaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Called when user taps Continue (to send OTP)
//   void _handleContinue() async {
//     final mobile = _uniqueIdController.text.trim();
//     // Basic validation for 10-digit Indian mobile. Adjust as needed.
//     if (mobile.isEmpty || mobile.length < 10) {
//       ToastMessage.failedToast('Please enter a valid mobile number');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // TODO: Replace this simulated delay with your actual API call to send OTP.
//       await Future.delayed(const Duration(seconds: 1));

//       // On success:
//       ToastMessage.successToast('OTP sent to $mobile');

//       setState(() {
//         _showOtpField = true;
//         _isLoading = false;
//       });

//       // start resend cooldown (e.g., 30s)
//       _startResendCountdown(30);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ToastMessage.failedToast('Failed to send OTP. Try again.');
//     }
//   }

//   // Verify OTP button pressed
//   void _verifyOtp() async {
//     final otp = _otpController.text.trim();
//     if (otp.isEmpty) {
//       ToastMessage.failedToast('Please enter OTP');
//       return;
//     }

//     setState(() {
//       _isVerifying = true;
//     });

//     try {
//       // TODO: Replace this with actual verification API call.
//       await Future.delayed(const Duration(seconds: 1));

//       // Example: accept any 4-6 digit OTP in this demo:
//       if (otp.length >= 4 && otp.length <= 6) {
//         ToastMessage.successToast('OTP verified. Logged in!');
//         // TODO: Navigate to next screen or save token
//         // Navigator.pushReplacement(...);
//       } else {
//         ToastMessage.failedToast('Invalid OTP');
//       }
//     } catch (e) {
//       ToastMessage.failedToast('Verification failed. Try again.');
//     } finally {
//       setState(() {
//         _isVerifying = false;
//       });
//     }
//   }

//   // Resend OTP
//   void _resendOtp() async {
//     if (_resendCountdown > 0) return;

//     final mobile = _uniqueIdController.text.trim();
//     if (mobile.isEmpty) {
//       ToastMessage.failedToast('Enter mobile number first');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // TODO: Call resend OTP API
//       await Future.delayed(const Duration(seconds: 1));
//       ToastMessage.successToast('OTP resent to $mobile');
//       _startResendCountdown(30);
//     } catch (e) {
//       ToastMessage.failedToast('Could not resend OTP');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Edit mobile (hide OTP field and clear OTP)
//   void _editMobile() {
//     setState(() {
//       _showOtpField = false;
//       _otpController.clear();
//       _resendCountdown = 0;
//     });
//   }

//   // Countdown timer for resend button
//   void _startResendCountdown(int seconds) {
//     setState(() {
//       _resendCountdown = seconds;
//     });

//     Future.doWhile(() async {
//       if (_resendCountdown <= 0) return false;
//       await Future.delayed(const Duration(seconds: 1));
//       if (!mounted) return false;
//       setState(() {
//         _resendCountdown -= 1;
//       });
//       return _resendCountdown > 0;
//     });
//   }
// }
