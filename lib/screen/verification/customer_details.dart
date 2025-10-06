import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/screen/verification/add_family_members.dart';
import 'package:norkacare_app/navigation/app_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';

class CustomerDetails extends StatefulWidget {
  final String customerId;
  final Map<String, dynamic>? customerData;

  const CustomerDetails({
    super.key,
    required this.customerId,
    this.customerData,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _alternateEmailController = TextEditingController();
  final _customerIdController = TextEditingController();

  bool _isLoading = false;
  bool _isDataLoaded = false;

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

    // Load customer data
    _loadCustomerData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _alternatePhoneController.dispose();
    _alternateEmailController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomerData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Set customer ID from widget parameter
      _customerIdController.text = widget.customerId;

      if (widget.customerData != null) {
        // Use API response data
        final data = widget.customerData!;

        _nameController.text = data['name'] ?? '';
        _dateOfBirthController.text = _formatDOB(data['date_of_birth'] ?? '');
        _genderController.text = data['gender'] ?? '';

        // Handle emails array
        if (data['emails'] != null && data['emails'].isNotEmpty) {
          _emailController.text = data['emails'][0]['address'] ?? '';
          if (data['emails'].length > 1) {
            _alternateEmailController.text = data['emails'][1]['address'] ?? '';
          }
        }

        // Handle mobiles array
        if (data['mobiles'] != null && data['mobiles'].isNotEmpty) {
          _phoneController.text = data['mobiles'][0]['with_dial_code'] ?? '';
          if (data['mobiles'].length > 1) {
            _alternatePhoneController.text =
                data['mobiles'][1]['with_dial_code'] ?? '';
          }
        }
      } else {
        // Fallback to static dummy data if no API data
        _nameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
        _dateOfBirthController.text = '';
        _genderController.text = '';
        _alternatePhoneController.text = '';
        _alternateEmailController.text = '';
      }

      setState(() {
        _isDataLoaded = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _loadCustomerData: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDOB(String dob) {
    if (dob.isEmpty) return '';

    // Check if the date is in MM-DD-YYYY format (with hyphens)
    if (dob.contains('-') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('-');
        if (parts.length == 3) {
          String month = parts[0].padLeft(2, '0');
          String day = parts[1].padLeft(2, '0');
          String year = parts[2];

          // Convert from MM-DD-YYYY to DD-MM-YYYY
          return '$day-$month-$year';
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Check if the date is in MM/DD/YYYY format (with slashes)
    if (dob.contains('/') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('/');
        if (parts.length == 3) {
          String month = parts[0].padLeft(2, '0');
          String day = parts[1].padLeft(2, '0');
          String year = parts[2];

          // Convert from MM/DD/YYYY to DD/MM/YYYY
          return '$day/$month/$year';
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Return original if not in expected format
    return dob;
  }

  Future<void> _continueToFamilyMembers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call to save customer details
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Get the stored NORKA ID from the provider
        final norkaProvider = Provider.of<NorkaProvider>(
          context,
          listen: false,
        );
        String norkaId = norkaProvider.norkaId.isNotEmpty
            ? norkaProvider.norkaId
            : widget
                  .customerId; // Fallback to widget customerId if provider doesn't have it

        // Check if this is the test Norka ID for Google Play Store
        if (norkaId == "M12345678") {
          // Navigate directly to dashboard for test account
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AppNavigationBar(),
            ),
          );
        } else {
          // Normal flow - go to family members for real accounts
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFamilyMembers(customerId: norkaId),
            ),
          );
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
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
                child: _buildCustomerForm(),
              ),
              const SizedBox(height: 25),
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

  Widget _buildCustomerForm() {
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
              // Show loading indicator at top if loading
              if (_isLoading && !_isDataLoaded)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),

              const SizedBox(height: 20),
              AppText(
                text: 'Self Details',
                size: 24,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
              const SizedBox(height: 8),
              AppText(
                text: 'Please review your information',
                size: 14,
                weight: FontWeight.normal,
                textColor: AppConstants.greyColor,
              ),
              const SizedBox(height: 32),

              // Customer ID Field
              TextFormField(
                controller: _customerIdController,
                readOnly: true,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Customer ID',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  prefixIcon: Icon(
                    Icons.badge,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 16),

              // Customer Information Fields
              TextFormField(
                controller: _nameController,
                readOnly: true,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Full Name',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  hintText: 'Enter your full name',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Email Address',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  hintText: 'Enter your email address',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  prefixIcon: Icon(
                    Icons.email,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                readOnly: true,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _alternatePhoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                cursorColor: AppConstants.primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Alternate Phone Number (Optional)',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  hintText: 'Enter alternate phone number',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _alternateEmailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                cursorColor: AppConstants.primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Alternate Email Address (Optional)',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  hintText: 'Enter alternate email address',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  prefixIcon: Icon(
                    Icons.email,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dateOfBirthController,
                readOnly: true,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  hintText: 'DD/MM/YYYY',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _genderController,
                readOnly: true,
                style: TextStyle(
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : AppConstants.whiteBackgroundColor,
                  labelText: 'Gender',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                  hintText: 'Select your gender',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppConstants.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                      width: 1.6,
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
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: _isLoading ? 'Processing...' : 'Save & Proceed',
                onPressed: _isLoading ? () {} : _continueToFamilyMembers,
                color: AppConstants.primaryColor,
                textColor: AppConstants.whiteColor,
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
