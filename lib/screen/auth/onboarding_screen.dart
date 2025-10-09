
import 'package:norkacare_app/screen/auth/registration_screen.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import '../../utils/constants.dart';
import '../../widgets/app_text.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

enum UserType { employee, posp, customer }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _autoPlayTimer;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Secure Your Future',
      description:
          'Get comprehensive insurance coverage to protect what matters most to you and your family.',
      lottieAsset:
          'https://assets2.lottiefiles.com/packages/lf20_5tl1xxnz.json',
      icon: Icons.shield,
      color: Colors.blue,
    ),
    OnboardingSlide(
      title: 'Easy Claims Process',
      description:
          'File claims quickly and easily with our streamlined digital process and 24/7 support.',
      lottieAsset:
          'https://assets5.lottiefiles.com/packages/lf20_5tl1xxnz.json',
      icon: Icons.assignment_turned_in,
      color: Colors.blue,
    ),
    OnboardingSlide(
      title: 'Expert Guidance',
      description:
          'Get personalized advice from our insurance experts to find the perfect coverage for your needs.',
      lottieAsset:
          'https://assets9.lottiefiles.com/packages/lf20_xyadoh9h.json',
      icon: Icons.support_agent,
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < _slides.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        // Stop auto-play when reaching the last slide
        _stopAutoPlay();
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  void _restartAutoPlay() {
    _stopAutoPlay();
    _startAutoPlay();
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
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.darkBackgroundColor
                        : AppConstants.whiteBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: _buildContent(),
                ),
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

  Widget _buildContent() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          // PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                // Restart auto-play timer when user manually changes page
                _restartAutoPlay();
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return _buildSlide(_slides[index]);
              },
            ),
          ),

          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _slides.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? AppConstants.primaryColor
                      : (isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade300),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Navigation Buttons
          Row(
            children: [
              // Skip Button
              // if (_currentIndex < _slides.length - 1)
              //   Expanded(
              //     child: TextButton(
              //       onPressed: () {
              //         _pageController.animateToPage(
              //           _slides.length - 1,
              //           duration: const Duration(milliseconds: 300),
              //           curve: Curves.easeInOut,
              //         );
              //         _restartAutoPlay();
              //       },
              //       child: AppText(
              //         text: 'Skip',
              //         size: 16,
              //         weight: FontWeight.w600,
              //         textColor: AppConstants.greyColor,
              //       ),
              //     ),
              //   ),

              // Next/Get Started Button
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: _currentIndex == _slides.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: () {
                    if (_currentIndex == _slides.length - 1) {
                      _navigateToLogin();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      _restartAutoPlay();
                    }
                  },
                  color: AppConstants.primaryColor,
                  textColor: Colors.white,
                  height: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Lottie Animation
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? slide.color.withOpacity(0.05)
                    : slide.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDarkMode
                      ? slide.color.withOpacity(0.1)
                      : slide.color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Lottie.network(
                  slide.lottieAsset,
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if Lottie fails to load
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? slide.color.withOpacity(0.1)
                            : slide.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode
                              ? slide.color.withOpacity(0.2)
                              : slide.color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(slide.icon, size: 80, color: slide.color),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Title
            AppText(
              text: slide.title,
              size: 24,
              weight: FontWeight.bold,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            AppText(
              text: slide.description,
              size: 16,
              weight: FontWeight.normal,
              textColor: isDarkMode
                  ? AppConstants.greyColor.withOpacity(0.8)
                  : AppConstants.greyColor,
              textAlign: TextAlign.center,
              maxLines: 10,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin() async {
    // Mark onboarding as completed
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.markOnboardingCompleted();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginScreen()),
    // );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final String lottieAsset;
  final IconData icon;
  final Color color;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.icon,
    required this.color,
  });
}
