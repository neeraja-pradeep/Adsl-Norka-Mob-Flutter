import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ComingsoonClaim extends StatelessWidget {
  const ComingsoonClaim({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AppText(
              text: 'Policy will start',
              size: 22,
              weight: FontWeight.w600,
              textColor: AppConstants.primaryColor,
            ),
          ),
          Center(
            child: AppText(
              text: 'on November 1st 2025',
              size: 22,
              weight: FontWeight.w600,
              textColor: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
