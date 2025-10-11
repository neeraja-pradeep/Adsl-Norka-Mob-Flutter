import 'package:norkacare_app/screen/auth/onboarding_screen.dart';
import 'package:norkacare_app/navigation/app_navigation_bar.dart';
import 'package:norkacare_app/provider/auth_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    // Start animations
    _startAnimations();

    // Initialize auth and navigate after animations
    Future.delayed(const Duration(seconds: 3), () {
      _initializeAndNavigate();
    });
  }

  void _startAnimations() async {
    // Start fade animation
    await _fadeController.forward();

    // Start scale animation
    _scaleController.forward();

    // Start slide animation
    _slideController.forward();

    // Start pulsing animation after scale completes
    Future.delayed(const Duration(milliseconds: 1200), () {
      _pulseController.repeat(reverse: true);
    });
  }

  Future<void> _initializeAndNavigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);

    // Initialize authentication state
    await authProvider.initializeAuth();

    // If user is logged in, initialize data from SharedPreferences
    if (authProvider.isLoggedIn) {
      // Initialize NORKA data from SharedPreferences
      await norkaProvider.initializeFromPrefs();
      
      // Initialize family data from SharedPreferences
      await verificationProvider.initializeFamilyDataFromPrefs();
      
      // Initialize enrollment data from SharedPreferences
      await verificationProvider.initializeEnrollmentDataFromPrefs();
      
      // Initialize payment history from SharedPreferences
      await verificationProvider.initializePaymentHistoryFromPrefs();
      
      // Initialize dates details from SharedPreferences
      await verificationProvider.initializeDatesDetailsFromPrefs();
    }

    // Navigate based on authentication status
    Widget nextScreen;

    if (authProvider.isLoggedIn) {
      // User is logged in, go directly to app navigation
      nextScreen = const AppNavigationBar();
    } else if (authProvider.shouldShowOnboarding()) {
      // User is not logged in and it's first time, show onboarding
      nextScreen = const OnboardingScreen();
    } else {
      // User has seen onboarding but not logged in, show onboarding again
      // (This could be changed to a login screen if you have one)
      nextScreen = const OnboardingScreen();
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: isDarkMode
          //       ? [
          //           AppConstants.primaryColor.withOpacity(0.8),

          //           AppConstants.primaryColor.withOpacity(0.6),
          //           AppConstants.darkBackgroundColor,
          //         ]
          //       : [
          //           AppConstants.primaryColor,
          //           AppConstants.primaryColor.withOpacity(0.8),
          //           AppConstants.whiteBackgroundColor,
          //         ],
          //   stops: const [0.0, 0.6, 1.0],
          // ),
          color: AppConstants.primaryColor,
        ),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: screenHeight * 0.1,
              right: -screenWidth * 0.2,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.3,
                    child: Container(
                      width: screenWidth * 0.6,
                      height: screenWidth * 0.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.whiteColor.withOpacity(0.1),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.2,
              left: -screenWidth * 0.15,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.2,
                    child: Container(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.secondaryColor.withOpacity(0.1),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animations
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _fadeAnimation,
                      _scaleAnimation,
                      _pulseAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value * _pulseAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppConstants.whiteColor.withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              AppConstants.appLogo,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // App name with slide animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'NORKA CARE INSURANCE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.whiteColor,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: AppConstants.blackColor.withOpacity(0.3),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tagline
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'For Non-Resident Keralites (NRKs)',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppConstants.whiteColor.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
