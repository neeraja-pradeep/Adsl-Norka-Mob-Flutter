import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Comingsoon extends StatefulWidget {
  const Comingsoon({super.key});

  @override
  State<Comingsoon> createState() => _ComingsoonState();
}

class _ComingsoonState extends State<Comingsoon> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    AppConstants.primaryColor.withOpacity(0.1),
                    AppConstants.darkBackgroundColor,
                    AppConstants.primaryColor.withOpacity(0.05),
                  ]
                : [
                    AppConstants.primaryColor.withOpacity(0.1),
                    Colors.white,
                    AppConstants.primaryColor.withOpacity(0.05),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated background circles
              _buildAnimatedBackground(isDarkMode, screenSize),

              const SizedBox(height: 40),

              // Main content
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        // App Logo/Icon with rotation animation
                        AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotateAnimation.value * 2 * 3.14159,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppConstants.primaryColor,
                                      AppConstants.primaryColor.withOpacity(
                                        0.7,
                                      ),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.primaryColor
                                          .withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.rocket_launch,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Coming Soon Text with pulse animation
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: AppText(
                                text: 'Coming Soon',
                                size: 36,
                                weight: FontWeight.bold,
                                textColor: AppConstants.primaryColor,
                              ),
                            );
                          },
                        ),

                        // const SizedBox(height: 16),

                        // Subtitle
                        // AppText(
                        //   text: 'claims management tools coming soon',
                        //   size: 18,
                        //   weight: FontWeight.w500,
                        //   textColor: isDarkMode
                        //       ? AppConstants.whiteColor.withOpacity(0.8)
                        //       : AppConstants.blackColor.withOpacity(0.7),
                        // ),
                        const SizedBox(height: 8),

                        AppText(
                          text: 'claims management tools coming soon',
                          size: 16,
                          weight: FontWeight.w400,
                          textColor: isDarkMode
                              ? AppConstants.greyColor
                              : AppConstants.greyColor,
                        ),
                        const SizedBox(height: 40),

                        // Progress indicator
                        _buildProgressIndicator(isDarkMode),

                        const SizedBox(height: 40),

                        // Features preview
                        // _buildFeaturesPreview(isDarkMode),
                        const SizedBox(height: 40),

                        // Contact info
                        // _buildContactInfo(isDarkMode),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDarkMode, Size screenSize) {
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height * 0.3,
      child: Stack(
        children: [
          // Floating circles
          for (int i = 0; i < 5; i++)
            Positioned(
              left: (screenSize.width * 0.1) + (i * 60.0),
              top: (screenSize.height * 0.05) + (i * 30.0),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * _pulseAnimation.value),
                    child: Container(
                      width: 20 + (i * 5.0),
                      height: 20 + (i * 5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.primaryColor.withOpacity(0.1),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppConstants.boxBlackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AppText(
            text: 'Development Progress',
            size: 16,
            weight: FontWeight.w600,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
            ),
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          AppText(
            text: '75% Complete',
            size: 14,
            weight: FontWeight.w500,
            textColor: AppConstants.primaryColor,
          ),
        ],
      ),
    );
  }

  // Widget _buildFeaturesPreview(bool isDarkMode) {
  //   final features = [
  //     {
  //       'icon': Icons.speed,
  //       'title': 'Lightning Fast',
  //       'desc': 'Optimized performance',
  //     },
  //     {
  //       'icon': Icons.security,
  //       'title': 'Secure',
  //       'desc': 'Bank-level security',
  //     },
  //     {'icon': Icons.palette, 'title': 'Beautiful UI', 'desc': 'Modern design'},
  //   ];

  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: isDarkMode ? AppConstants.boxBlackColor : Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: isDarkMode
  //             ? Colors.white.withOpacity(0.1)
  //             : Colors.grey.withOpacity(0.2),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: isDarkMode
  //               ? Colors.black.withOpacity(0.3)
  //               : Colors.grey.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         AppText(
  //           text: 'What to Expect',
  //           size: 18,
  //           weight: FontWeight.w600,
  //           textColor: isDarkMode
  //               ? AppConstants.whiteColor
  //               : AppConstants.blackColor,
  //         ),
  //         const SizedBox(height: 20),
  //         ...features
  //             .map(
  //               (feature) => _buildFeatureItem(
  //                 feature['icon'] as IconData,
  //                 feature['title'] as String,
  //                 feature['desc'] as String,
  //                 isDarkMode,
  //               ),
  //             )
  //             .toList(),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFeatureItem(
  //   IconData icon,
  //   String title,
  //   String description,
  //   bool isDarkMode,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 50,
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: AppConstants.primaryColor.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Icon(icon, color: AppConstants.primaryColor, size: 24),
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               AppText(
  //                 text: title,
  //                 size: 16,
  //                 weight: FontWeight.w600,
  //                 textColor: isDarkMode
  //                     ? AppConstants.whiteColor
  //                     : AppConstants.blackColor,
  //               ),
  //               const SizedBox(height: 4),
  //               AppText(
  //                 text: description,
  //                 size: 14,
  //                 weight: FontWeight.w400,
  //                 textColor: isDarkMode
  //                     ? AppConstants.greyColor
  //                     : AppConstants.greyColor,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContactInfo(bool isDarkMode) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: AppConstants.primaryColor.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
  //     ),
  //     child: Column(
  //       children: [
  //         Icon(
  //           Icons.email_outlined,
  //           color: AppConstants.primaryColor,
  //           size: 32,
  //         ),
  //         const SizedBox(height: 12),
  //         AppText(
  //           text: 'Get Notified',
  //           size: 18,
  //           weight: FontWeight.w600,
  //           textColor: AppConstants.primaryColor,
  //         ),
  //         const SizedBox(height: 8),
  //         AppText(
  //           text: 'Be the first to know when we launch',
  //           size: 14,
  //           weight: FontWeight.w400,
  //           textColor: isDarkMode
  //               ? AppConstants.whiteColor.withOpacity(0.8)
  //               : AppConstants.blackColor.withOpacity(0.7),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
