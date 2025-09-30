import 'package:norkacare_app/screen/verification/payment/family_details_confirm_page.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/otp_verification_provider.dart';

class FamilyMember {
  final String name;
  final String relationship;
  final String dateOfBirth;
  final String gender;

  FamilyMember({
    required this.name,
    required this.relationship,
    required this.dateOfBirth,
    required this.gender,
  });
}

class AddFamilyMembers extends StatefulWidget {
  final String customerId;

  const AddFamilyMembers({super.key, required this.customerId});

  @override
  State<AddFamilyMembers> createState() => _AddFamilyMembersState();
}

class _AddFamilyMembersState extends State<AddFamilyMembers>
    with TickerProviderStateMixin {
  final List<FamilyMember> _familyMembers = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();

  // Customer details controllers
  final _customerNameController = TextEditingController();
  final _customerDateOfBirthController = TextEditingController();
  final _customerGenderController = TextEditingController();

  bool _isLoading = false;
  bool _showAddForm = false;

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

    // Set default relationship to empty for the first family member
    _relationshipController.text = '';

    // Pre-fill customer details with static data
    _loadCustomerDetails();
  }

  void _loadCustomerDetails() {
    // Get customer data from OTP verification provider first, then fallback to NORKA provider
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    // Use verified customer data from OTP verification if available
    final verifiedCustomerData = otpVerificationProvider
        .getVerifiedCustomerData();
    if (verifiedCustomerData != null) {
      _populateCustomerData(verifiedCustomerData);
    } else {
      // Fallback to NORKA provider data
      _populateCustomerData(norkaProvider.response);
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

  void _populateCustomerData(Map<String, dynamic>? apiData) {
    try {
      if (apiData != null) {
        // Use API response data
        _customerNameController.text = apiData['name'] ?? '';
        _customerDateOfBirthController.text = _formatDOB(
          apiData['date_of_birth'] ?? '',
        );
        _customerGenderController.text = apiData['gender'] ?? '';
      } else {
        // Fallback to empty values if no API data
        _customerNameController.text = '';
        _customerDateOfBirthController.text = '';
        _customerGenderController.text = '';
      }
    } catch (e) {
      print('Error populating customer data: $e');
      // Set empty values if there's an error
      _customerNameController.text = '';
      _customerDateOfBirthController.text = '';
      _customerGenderController.text = '';
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _relationshipController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _customerNameController.dispose();
    _customerDateOfBirthController.dispose();
    _customerGenderController.dispose();
    super.dispose();
  }

  void _showAddFamilyMemberForm() {
    setState(() {
      _showAddForm = true;
      _clearForm();

      // Set default relationship to empty
      _relationshipController.text = '';
    });

    // Clear any previous error messages
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );
    verificationProvider.clearData();
  }

  void _hideAddFamilyMemberForm() {
    setState(() {
      _showAddForm = false;
      _clearForm();
    });
  }

  void _clearForm() {
    _nameController.clear();
    _dateOfBirthController.clear();
    _genderController.clear();
    // Don't clear relationship controller as it will be set to empty by default
  }

  void _addFamilyMember() {
    // Clear any previous error messages
    final verificationProvider = Provider.of<VerificationProvider>(
      context,
      listen: false,
    );
    verificationProvider.clearData();

    // Validate required fields
    if (_nameController.text.trim().isEmpty) {
      ToastMessage.failedToast('Please enter the family member name');
      return;
    }

    if (_relationshipController.text.isEmpty) {
      ToastMessage.failedToast('Please select a relationship');
      return;
    }

    if (_dateOfBirthController.text.isEmpty) {
      ToastMessage.failedToast('Please select date of birth');
      return;
    }

    if (_genderController.text.isEmpty) {
      ToastMessage.failedToast('Please select gender');
      return;
    }

    String relationship = _relationshipController.text;

    // If it's a spouse, check if already exists
    if (relationship == 'Spouse') {
      bool spouseExists = _familyMembers.any(
        (member) => member.relationship == 'Spouse',
      );

      if (spouseExists) {
        ToastMessage.failedToast('Only one spouse allowed');
        return;
      }
    }

    // If it's a child, automatically number it
    if (relationship == 'Child') {
      int childCount = _familyMembers
          .where((member) => member.relationship.startsWith('Child'))
          .length;

      // Check if maximum children limit reached
      if (childCount >= 5) {
        ToastMessage.failedToast('Maximum 5 children allowed');
        return;
      }

      relationship = 'Child ${childCount + 1}';
    }

    final newMember = FamilyMember(
      name: _nameController.text.trim(),
      relationship: relationship,
      dateOfBirth: _dateOfBirthController.text,
      gender: _genderController.text,
    );

    setState(() {
      _familyMembers.add(newMember);
      _hideAddFamilyMemberForm();
    });

    // ToastMessage.successToast('${newMember.name} added successfully!');
  }

  void _removeFamilyMember(int index) {
    setState(() {
      _familyMembers.removeAt(index);
      _renumberChildren();
    });
  }

  void _renumberChildren() {
    // Get all children and renumber them
    List<FamilyMember> children = _familyMembers
        .where((member) => member.relationship.startsWith('Child'))
        .toList();

    // Remove all children from the main list
    _familyMembers.removeWhere(
      (member) => member.relationship.startsWith('Child'),
    );

    // Renumber and add back children
    for (int i = 0; i < children.length; i++) {
      children[i] = FamilyMember(
        name: children[i].name,
        relationship: 'Child ${i + 1}',
        dateOfBirth: children[i].dateOfBirth,
        gender: children[i].gender,
      );
      _familyMembers.add(children[i]);
    }
  }

  Map<String, dynamic> _prepareApiData(Map<String, dynamic>? norkaData) {
    // Get verified customer data from OTP verification provider first
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );
    final verifiedCustomerData = otpVerificationProvider
        .getVerifiedCustomerData();

    // Use verified data if available, otherwise use norkaData
    final customerData = verifiedCustomerData ?? norkaData;
    // Convert date to MM-DD-YYYY format for API
    // Handles DD/MM/YYYY format (form input) and MM/DD/YYYY format (NORKA API)
    String _convertDateFormat(String dateStr) {
      if (dateStr.isEmpty) return '';
      try {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final firstPart = int.parse(parts[0]);
          final secondPart = int.parse(parts[1]);

          // If first part > 12, it's definitely DD/MM/YYYY format (day > 12)
          if (firstPart > 12) {
            // Convert from DD/MM/YYYY to MM-DD-YYYY for API
            return '${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}-${parts[2]}';
          }
          // If second part > 12, it's definitely MM/DD/YYYY format (month > 12)
          else if (secondPart > 12) {
            // Already in MM/DD/YYYY format, convert to MM-DD-YYYY
            return '${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}-${parts[2]}';
          }
          // If both parts are <= 12, assume DD/MM/YYYY format (form input)
          else {
            // Convert from DD/MM/YYYY to MM-DD-YYYY for API
            return '${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}-${parts[2]}';
          }
        }
      } catch (e) {
        print('Error converting date: $e');
      }
      return dateStr;
    }

    // Convert gender to lowercase
    String _convertGender(String gender) {
      return gender.toLowerCase();
    }

    // Get customer data from verified data or use form data
    final customerName = customerData?['name'] ?? _customerNameController.text;
    final customerDob = _customerDateOfBirthController.text.isNotEmpty
        ? _customerDateOfBirthController.text
        : (customerData?['date_of_birth'] ?? '');
    final customerGender =
        customerData?['gender'] ?? _customerGenderController.text;
    final nrkId = customerData?['nrk_id'] ?? widget.customerId;
    // Extract mobile number from mobiles array
    String mobileNo = '';
    if (customerData?['mobiles'] != null && customerData!['mobiles'] is List) {
      final mobiles = customerData['mobiles'] as List;
      if (mobiles.isNotEmpty) {
        final primaryMobile = mobiles.firstWhere(
          (mobile) => mobile['primary'] == true,
          orElse: () => mobiles.first,
        );
        mobileNo =
            primaryMobile['with_dial_code'] ?? primaryMobile['number'] ?? '';
      }
    }

    // Extract email from emails array
    String email = '';
    if (customerData?['emails'] != null && customerData!['emails'] is List) {
      final emails = customerData['emails'] as List;
      if (emails.isNotEmpty) {
        final primaryEmail = emails.firstWhere(
          (emailItem) => emailItem['primary'] == true,
          orElse: () => emails.first,
        );
        email = primaryEmail['address'] ?? '';
      }
    }

    // Extract country from working_country
    final country = customerData?['working_country'] ?? '';

    // Debug: Print extracted values
    print('Extracted mobile: $mobileNo');
    print('Extracted email: $email');
    print('Extracted country: $country');
    print('Original customer DOB: $customerDob');
    print('Converted customer DOB: ${_convertDateFormat(customerDob)}');

    // Prepare base data
    Map<String, dynamic> apiData = {
      "nrk_id_no": nrkId,
      "nrk_name": customerName,
      "mob_no": mobileNo,
      "mail_id": email,
      "relation": "Self",
      "dob": _convertDateFormat(customerDob),
      "gender": _convertGender(customerGender),
      "country": country,
    };

    // Find spouse
    final spouse = _familyMembers.firstWhere(
      (member) => member.relationship == 'Spouse',
      orElse: () =>
          FamilyMember(name: '', relationship: '', dateOfBirth: '', gender: ''),
    );

    if (spouse.name.isNotEmpty) {
      print('Original spouse DOB: ${spouse.dateOfBirth}');
      print('Converted spouse DOB: ${_convertDateFormat(spouse.dateOfBirth)}');
      apiData.addAll({
        "spouse_name": spouse.name,
        "spouse_relation":
            "Wife", // Assuming spouse is wife, you can modify this logic
        "spouse_dob": _convertDateFormat(spouse.dateOfBirth),
        "spouse_gender": _convertGender(spouse.gender),
      });
    }

    // Add children (up to 5)
    final children = _familyMembers
        .where((member) => member.relationship.startsWith('Child'))
        .toList();
    for (int i = 0; i < children.length && i < 5; i++) {
      final child = children[i];
      final childNumber = i + 1;
      apiData.addAll({
        "kid_${childNumber}_name": child.name,
        "kid_${childNumber}_relation": child.gender.toLowerCase() == 'male'
            ? 'Son'
            : 'Daughter',
        "kid_${childNumber}_dob": _convertDateFormat(child.dateOfBirth),
      });
    }

    return apiData;
  }

  Future<void> _proceedToApp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get providers
      final verificationProvider = Provider.of<VerificationProvider>(
        context,
        listen: false,
      );
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

      // Debug: Print NORKA data
      print('NORKA Provider Response: ${norkaProvider.response}');

      // Prepare API data
      final apiData = _prepareApiData(norkaProvider.response);

      // Debug: Print the API data being sent
      print('API Data being sent: $apiData');

      // Validate required fields
      if (apiData['mob_no'].toString().isEmpty) {
        ToastMessage.failedToast(
          'Mobile number is required. Please check your NORKA data.',
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (apiData['mail_id'].toString().isEmpty) {
        ToastMessage.failedToast(
          'Email is required. Please check your NORKA data.',
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Call API
      await verificationProvider.AddFamilyMembers(apiData);

      // Debug: Print verification provider state
      print('Verification Provider State:');
      print('  - errorMessage: "${verificationProvider.errorMessage}"');
      print('  - response: ${verificationProvider.response}');
      print('  - isLoading: ${verificationProvider.isLoading}');

      // Check if API call was successful
      if (verificationProvider.errorMessage.isEmpty &&
          verificationProvider.response != null) {
        print('✅ Success condition met - fetching premium amount');

        // Get the NRK ID from the response or use the customer ID
        String nrkId =
            verificationProvider.response?['nrk_id_no'] ?? widget.customerId;

        // Clear family members data to force refetch with updated data
        verificationProvider.clearFamilyMembersData();
        print('✅ Cleared family members data to force refetch');

        // Refetch family members data after successful creation
        try {
          await verificationProvider.getFamilyMembersWithOfflineFallback(nrkId);
          print('✅ Family members data refetched successfully');
        } catch (e) {
          print('⚠️ Error refetching family members: $e');
        }

        // Call premium amount API after successful family creation
        try {
          await verificationProvider.getPremiumAmount(nrkId);
          print('✅ Premium amount fetched successfully');
        } catch (e) {
          print('⚠️ Error fetching premium amount: $e');
          // Continue to next page even if premium amount fetch fails
        }

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FamilyDetailsConfirmPage(),
            ),
          );
        }
      } else {
        print('❌ Error condition met - showing error');
        print(
          '  - errorMessage.isEmpty: ${verificationProvider.errorMessage.isEmpty}',
        );
        print('  - response != null: ${verificationProvider.response != null}');
        ToastMessage.failedToast(
          verificationProvider.errorMessage.isEmpty
              ? 'An unexpected error occurred'
              : verificationProvider.errorMessage,
        );
      }
    } catch (e) {
      ToastMessage.failedToast('Something went wrong. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildDialogOption(String text, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // For Child option, show the next available number
    String displayText = text;
    bool isDisabled = false;
    bool isSelected = _relationshipController.text == text;

    if (text == 'Child') {
      int childCount = _familyMembers
          .where((member) => member.relationship.startsWith('Child'))
          .length;

      if (childCount >= 5) {
        displayText = 'Child (Max 5 reached)';
        isDisabled = true;
      } else {
        displayText = 'Child ${childCount + 1}';
      }
    }

    // For Spouse option, check if already exists
    if (text == 'Spouse') {
      bool spouseExists = _familyMembers.any(
        (member) => member.relationship == 'Spouse',
      );

      if (spouseExists) {
        displayText = 'Spouse';
        isDisabled = true;
      }
    }

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                _relationshipController.text = text;
              });
              Navigator.pop(context);
            },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDisabled
              ? (isDarkMode ? Colors.grey[800] : Colors.grey[300])
              : isSelected
              ? AppConstants.primaryColor.withOpacity(0.1)
              : (isDarkMode ? AppConstants.boxBlackColor : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDisabled
                ? (isDarkMode ? Colors.grey[600]! : Colors.grey[400]!)
                : isSelected
                ? AppConstants.primaryColor
                : (isDarkMode
                      ? AppConstants.primaryColor.withOpacity(0.1)
                      : AppConstants.primaryColor.withOpacity(0.2)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDisabled
                  ? (isDarkMode ? Colors.grey[600] : Colors.grey[500])
                  : isSelected
                  ? AppConstants.primaryColor
                  : AppConstants.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              displayText,
              style: TextStyle(
                fontSize: 16,
                color: isDisabled
                    ? (isDarkMode ? Colors.grey[600] : Colors.grey[500])
                    : isSelected
                    ? AppConstants.primaryColor
                    : (isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDialogOption(String text, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _genderController.text = text;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDarkMode ? AppConstants.boxBlackColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDarkMode
                ? AppConstants.primaryColor.withOpacity(0.1)
                : AppConstants.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Consumer<VerificationProvider>(
      builder: (context, verificationProvider, child) {
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
                    child: _buildFamilyMembersContent(verificationProvider),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        );
      },
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

  Widget _buildFamilyMembersContent(VerificationProvider verificationProvider) {
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
              const SizedBox(height: 32),

              // Customer Details Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.primaryColor.withOpacity(0.05)
                      : AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? AppConstants.primaryColor.withOpacity(0.1)
                        : AppConstants.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppConstants.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          text: 'Self Details',
                          size: 18,
                          weight: FontWeight.w600,
                          textColor: AppConstants.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Customer Name Field (Read-only)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppConstants.darkBackgroundColor
                            : Colors.white,
                        border: Border.all(
                          color: isDarkMode
                              ? AppConstants.primaryColor.withOpacity(0.5)
                              : AppConstants.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? AppConstants.whiteColor
                                            : AppConstants.blackColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppConstants.primaryColor
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: AppText(
                                        text: 'Self',
                                        size: 11,
                                        weight: FontWeight.w600,
                                        textColor: AppConstants.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 0),
                                Text(
                                  _customerNameController.text.isNotEmpty
                                      ? _customerNameController.text
                                      : 'Name not available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _customerNameController.text.isNotEmpty
                                        ? (isDarkMode
                                              ? AppConstants.whiteColor
                                              : AppConstants.blackColor)
                                        : AppConstants.greyColor,
                                    fontWeight: FontWeight.w500,
                                    fontStyle:
                                        _customerNameController.text.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Customer Date of Birth Field (Read-only)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppConstants.darkBackgroundColor
                            : Colors.white,
                        border: Border.all(
                          color: isDarkMode
                              ? AppConstants.primaryColor.withOpacity(0.5)
                              : AppConstants.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? AppConstants.whiteColor
                                        : AppConstants.blackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _customerDateOfBirthController.text.isNotEmpty
                                      ? _customerDateOfBirthController.text
                                      : 'Date of Birth not available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _customerDateOfBirthController
                                            .text
                                            .isNotEmpty
                                        ? (isDarkMode
                                              ? AppConstants.whiteColor
                                              : AppConstants.blackColor)
                                        : AppConstants.greyColor,
                                    fontWeight: FontWeight.w500,
                                    fontStyle:
                                        _customerDateOfBirthController
                                            .text
                                            .isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Customer Gender Field (Read-only)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppConstants.darkBackgroundColor
                            : Colors.white,
                        border: Border.all(
                          color: isDarkMode
                              ? AppConstants.primaryColor.withOpacity(0.5)
                              : AppConstants.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: AppConstants.primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? AppConstants.whiteColor
                                        : AppConstants.blackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _customerGenderController.text.isNotEmpty
                                      ? _customerGenderController.text
                                      : 'Gender not available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _customerGenderController
                                            .text
                                            .isNotEmpty
                                        ? (isDarkMode
                                              ? AppConstants.whiteColor
                                              : AppConstants.blackColor)
                                        : AppConstants.greyColor,
                                    fontWeight: FontWeight.w500,
                                    fontStyle:
                                        _customerGenderController.text.isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Family Members List
              if (_familyMembers.isNotEmpty) ...[
                AppText(
                  text: 'Family Members (${_familyMembers.length})',
                  size: 18,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 16),
                ..._familyMembers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final member = entry.value;
                  return _buildFamilyMemberCard(member, index);
                }).toList(),
                const SizedBox(height: 24),
              ],

              // Add Family Member Button
              if (!_showAddForm)
                CustomButton(
                  text: 'Add Family Member',
                  onPressed: _showAddFamilyMemberForm,
                  color: AppConstants.secondaryColor,
                  textColor: AppConstants.blackColor,
                  height: 56,
                ),

              // Add Family Member Form
              if (_showAddForm) ...[
                _buildAddFamilyMemberForm(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: _hideAddFamilyMemberForm,
                        color: AppConstants.greyColor,
                        textColor: AppConstants.whiteColor,
                        height: 56,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Add Member',
                        onPressed: _addFamilyMember,
                        color: AppConstants.primaryColor,
                        textColor: AppConstants.whiteColor,
                        height: 56,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 22),

              // Proceed Button
              if (_familyMembers.isNotEmpty || !_showAddForm)
                CustomButton(
                  text: (_isLoading || verificationProvider.isLoading)
                      ? 'Processing...'
                      : 'Continue',
                  onPressed: (_isLoading || verificationProvider.isLoading)
                      ? () {}
                      : _proceedToApp,
                  color: AppConstants.primaryColor,
                  textColor: AppConstants.whiteColor,
                  height: 56,
                ),

              const SizedBox(height: 25),

              // Error Message Display
              // if (verificationProvider.errorMessage.isNotEmpty)
              //   Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.all(16),
              //     margin: const EdgeInsets.only(bottom: 16),
              //     decoration: BoxDecoration(
              //       color: AppConstants.redColor.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(
              //         color: AppConstants.redColor.withOpacity(0.3),
              //       ),
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.error_outline,
              //           color: AppConstants.redColor,
              //           size: 20,
              //         ),
              //         const SizedBox(width: 12),
              //         Expanded(
              //           child: AppText(
              //             text: verificationProvider.errorMessage,
              //             size: 14,
              //             weight: FontWeight.w500,
              //             textColor: AppConstants.redColor,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),

              // Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.primaryColor.withOpacity(0.1)
                      : AppConstants.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? AppConstants.primaryColor.withOpacity(0.2)
                        : AppConstants.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppConstants.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          text: 'Information',
                          size: 16,
                          weight: FontWeight.w600,
                          textColor: AppConstants.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text:
                          'You can add family members like spouse, children, etc. This will help in providing comprehensive insurance coverage for your entire family.',
                      size: 13,
                      weight: FontWeight.normal,
                      textColor: AppConstants.greyColor,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyMemberCard(FamilyMember member, int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppConstants.boxBlackColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppConstants.primaryColor.withOpacity(0.1)
              : AppConstants.primaryColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppConstants.primaryColor,
            child: Icon(Icons.person, color: AppConstants.whiteColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: member.name,
                  size: 16,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  text:
                      '${member.relationship} • ${member.gender} • ${member.dateOfBirth}',
                  size: 14,
                  weight: FontWeight.normal,
                  textColor: AppConstants.greyColor,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeFamilyMember(index),
            icon: Icon(Icons.delete_outline, color: AppConstants.redColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAddFamilyMemberForm() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.primaryColor.withOpacity(0.02)
            : AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppConstants.primaryColor.withOpacity(0.1)
              : AppConstants.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Add New Family Member',
              size: 18,
              weight: FontWeight.w600,
              textColor: AppConstants.primaryColor,
            ),
            const SizedBox(height: 16),

            // Name Field
            TextFormField(
              controller: _nameController,
              style: TextStyle(
                color: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: isDarkMode
                    ? AppConstants.darkBackgroundColor
                    : Colors.white,
                labelText: 'Full Name',
                labelStyle: TextStyle(
                  color: isDarkMode ? AppConstants.greyColor : Colors.grey[600],
                ),
                hintText: 'Enter family member name',
                hintStyle: TextStyle(color: AppConstants.greyColor),
                prefixIcon: Icon(
                  Icons.person,
                  color: AppConstants.primaryColor,
                ),
                border: OutlineInputBorder(
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Relationship Field
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: isDarkMode
                        ? AppConstants.boxBlackColor
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    title: Text(
                      'Select Relationship',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppConstants.boxBlackColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDialogOption('Spouse', Icons.favorite),
                          _buildDialogOption('Child', Icons.child_care),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : Colors.white,
                  border: Border.all(
                    color: isDarkMode
                        ? AppConstants.primaryColor.withOpacity(0.5)
                        : AppConstants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.family_restroom,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Relationship',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _relationshipController.text.isEmpty
                                ? 'Select relationship'
                                : _relationshipController.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: _relationshipController.text.isEmpty
                                  ? (isDarkMode
                                        ? AppConstants.greyColor
                                        : Colors.grey[600])
                                  : (isDarkMode
                                        ? AppConstants.whiteColor
                                        : Colors.black87),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date of Birth Field
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(
                    const Duration(days: 6570),
                  ),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogTheme: DialogThemeData(
                          backgroundColor: isDarkMode
                              ? AppConstants.boxBlackColor
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: AppConstants.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        colorScheme: isDarkMode
                            ? ColorScheme.dark(
                                primary: AppConstants.primaryColor,
                                onPrimary: Colors.white,
                                surface: AppConstants.boxBlackColor,
                                onSurface: AppConstants.whiteColor,
                              )
                            : ColorScheme.light(
                                primary: AppConstants.primaryColor,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: AppConstants.blackColor,
                              ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _dateOfBirthController.text =
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : Colors.white,
                  border: Border.all(
                    color: isDarkMode
                        ? AppConstants.primaryColor.withOpacity(0.5)
                        : AppConstants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Date of Birth',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dateOfBirthController.text.isEmpty
                                ? 'DD/MM/YYYY'
                                : _dateOfBirthController.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: _dateOfBirthController.text.isEmpty
                                  ? (isDarkMode
                                        ? AppConstants.greyColor
                                        : Colors.grey[600])
                                  : (isDarkMode
                                        ? AppConstants.whiteColor
                                        : Colors.black87),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: AppConstants.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender Field
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: isDarkMode
                        ? AppConstants.boxBlackColor
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    title: Text(
                      'Select Gender',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppConstants.boxBlackColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildGenderDialogOption('Male', Icons.male),
                          _buildGenderDialogOption('Female', Icons.female),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.darkBackgroundColor
                      : Colors.white,
                  border: Border.all(
                    color: isDarkMode
                        ? AppConstants.primaryColor.withOpacity(0.5)
                        : AppConstants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _genderController.text.isEmpty
                                ? 'Select gender'
                                : _genderController.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: _genderController.text.isEmpty
                                  ? (isDarkMode
                                        ? AppConstants.greyColor
                                        : Colors.grey[600])
                                  : (isDarkMode
                                        ? AppConstants.whiteColor
                                        : Colors.black87),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
