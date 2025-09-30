import 'package:norkacare_app/comingsoon_claim.dart';
import 'package:norkacare_app/screen/insurence/documents_page.dart';
import 'package:norkacare_app/screen/homepage.dart';
import 'package:norkacare_app/screen/insurence/my_claims_page.dart';
import 'package:norkacare_app/screen/insurence/my_policies_page.dart';
import 'package:norkacare_app/screen/profile/profile_page.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/norka_provider.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  bool _isInitialized = false;

  final List<Widget> _pages = [
    Homepage(),
    MyPoliciesPage(),
    MyClaimsPage(),
    // ComingsoonClaim(),
    DocumentsPage(),
    ProfilePage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      color: AppConstants.primaryColor,
    ),
    NavigationItem(
      icon: Icons.policy_rounded,
      activeIcon: Icons.policy_rounded,
      label: 'My Policy',
      color: AppConstants.primaryColor,
    ),
    NavigationItem(
      icon: Icons.flag_rounded,
      activeIcon: Icons.flag_rounded,
      label: 'My Claim',
      color: AppConstants.primaryColor,
    ),
    NavigationItem(
      icon: Icons.description_rounded,
      activeIcon: Icons.description_rounded,
      label: 'Document',
      color: AppConstants.primaryColor,
    ),
    NavigationItem(
      icon: Icons.person_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      color: AppConstants.primaryColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Initialize NORKA provider with stored data
    _initializeNorkaProvider();
  }

  Future<void> _initializeNorkaProvider() async {
    try {
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      await norkaProvider.initializeFromPrefs();

      // Mark as initialized and trigger a rebuild
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing NORKA provider: $e");
      if (mounted) {
        setState(() {
          _isInitialized =
              true; // Still mark as initialized to avoid infinite loading
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _isInitialized
            ? _pages[_selectedIndex]
            : const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppConstants.darkBackgroundColor
                : AppConstants.whiteColor,
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 85,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _navigationItems.length,
                  (index) =>
                      Expanded(child: _buildNavigationItem(index, isDarkMode)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(int index, bool isDarkMode) {
    final item = _navigationItems[index];
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? item.color : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 25,
                  color: isSelected
                      ? AppConstants.whiteColor
                      : isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 15 : 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? item.color
                    : isDarkMode
                    ? Colors.grey.shade400
                    : Colors.grey.shade600,
              ),
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
