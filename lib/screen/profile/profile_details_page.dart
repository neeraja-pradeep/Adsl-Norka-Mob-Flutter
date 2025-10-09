import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../provider/norka_provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  // Profile image state
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  
  // Text controllers for editing
  final TextEditingController _primaryEmailController = TextEditingController();
  final TextEditingController _secondaryEmailController = TextEditingController();
  final TextEditingController _primaryPhoneController = TextEditingController();
  final TextEditingController _secondaryPhoneController = TextEditingController();
  
  // Phone field controllers for intl_phone_field
  final TextEditingController _primaryIntlPhoneController = TextEditingController();
  final TextEditingController _secondaryIntlPhoneController = TextEditingController();
  
  // Country code selection
  String _selectedPrimaryCountryCode = '+91';
  String _selectedSecondaryCountryCode = '+91';
  String _selectedPrimaryPhoneNumber = '';
  String _selectedSecondaryPhoneNumber = '';
  
  // Edit mode states
  bool _isEditingPrimaryEmail = false;
  bool _isEditingSecondaryEmail = false;
  bool _isEditingPrimaryPhone = false;
  bool _isEditingSecondaryPhone = false;
  bool _isAddingSecondaryEmail = false;
  bool _isAddingSecondaryPhone = false;

  Map<String, dynamic> _extractProfileDetails(BuildContext context) {
    // Get data from verification provider (unified API response) first, then fallback to NORKA provider
    final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    // Try to get from unified API response first
    Map<String, dynamic>? apiData;
    Map<String, dynamic>? userData;
    bool isUnifiedApiData = false;
    
    if (verificationProvider.familyMembersDetails.isNotEmpty) {
      // Use family_info data from unified API for basic info
      apiData = verificationProvider.familyMembersDetails;
      isUnifiedApiData = true;
      
      // Get nrk_user data from the unified API response stored in verification provider
      // The unified API response should be stored in the provider
      final unifiedResponse = verificationProvider.getUnifiedApiResponse();
      debugPrint('=== PROFILE DETAILS: Unified API Response Check ===');
      debugPrint('Unified response exists: ${unifiedResponse != null}');
      if (unifiedResponse != null) {
        debugPrint('User details exists: ${unifiedResponse['user_details'] != null}');
        if (unifiedResponse['user_details'] != null) {
          debugPrint('NRK user exists: ${unifiedResponse['user_details']['nrk_user'] != null}');
        }
      }
      
      if (unifiedResponse != null && unifiedResponse['user_details'] != null) {
        userData = unifiedResponse['user_details']['nrk_user'];
        debugPrint('Using nrk_user data from unified API response');
      } else {
        // Fallback to NORKA provider
        userData = norkaProvider.response;
        debugPrint('Using NORKA provider data as fallback');
      }
    } else {
      // Fallback to NORKA provider
      apiData = norkaProvider.response;
      userData = norkaProvider.response;
    }

    if (apiData != null) {
      // Check if this is unified API data (family_info) or NORKA provider data
      
      String primaryEmail = '';
      String secondaryEmail = '';
      String primaryPhone = '';
      String secondaryPhone = '';
      String fullAddress = '';

      if (isUnifiedApiData) {
        // Extract from unified API - use nrk_user data with direct fields
        if (userData != null) {
          // Primary email and phone from nrk_user direct fields
          primaryEmail = userData['primary_email'] ?? '';
          primaryPhone = userData['primary_mobile'] ?? '';
          
          // Secondary email and phone from nrk_user direct fields
          secondaryEmail = userData['secondary_email'] ?? '';
          secondaryPhone = userData['secondary_mobile'] ?? '';
          
          // Debug logging
          debugPrint('=== PROFILE DETAILS DATA EXTRACTION ===');
          debugPrint('Primary Email: $primaryEmail');
          debugPrint('Primary Phone: $primaryPhone');
          debugPrint('Secondary Email: $secondaryEmail');
          debugPrint('Secondary Phone: $secondaryPhone');
          
          // Handle null values - convert to empty string
          if (secondaryEmail.isEmpty) secondaryEmail = '';
          if (secondaryPhone.isEmpty) secondaryPhone = '';
          
          // Fallback to arrays if direct fields are empty
          if (primaryEmail.isEmpty && userData['emails'] != null && userData['emails'].isNotEmpty) {
            primaryEmail = userData['emails'][0]['address'] ?? '';
          }
          if (primaryPhone.isEmpty && userData['mobiles'] != null && userData['mobiles'].isNotEmpty) {
            primaryPhone = userData['mobiles'][0]['with_dial_code'] ?? '';
          }
        } else {
          // Fallback to family_info if nrk_user not available
          primaryEmail = apiData['mail_id'] ?? '';
          primaryPhone = apiData['mob_no'] ?? '';
        }
        
        // Get address from user data (NORKA provider response from OTP verification)
        if (userData != null && userData['address'] != null) {
          // Address is stored as a string in the API response
          final addressString = userData['address'].toString();
          if (addressString.isNotEmpty) {
            fullAddress = addressString;
          } else {
            fullAddress = 'Address not available';
          }
        } else {
          fullAddress = 'Address not available';
        }
      } else {
        // Extract from NORKA provider data (original structure)
        if (apiData['emails'] != null && apiData['emails'].isNotEmpty) {
          primaryEmail = apiData['emails'][0]['address'] ?? '';
          if (apiData['emails'].length > 1) {
            secondaryEmail = apiData['emails'][1]['address'] ?? '';
          }
        }

        if (apiData['mobiles'] != null && apiData['mobiles'].isNotEmpty) {
          primaryPhone = apiData['mobiles'][0]['with_dial_code'] ?? '';
          if (apiData['mobiles'].length > 1) {
            secondaryPhone = apiData['mobiles'][1]['with_dial_code'] ?? '';
          }
        }

        // Build full address from address object
        if (apiData['address'] != null) {
          final addressObj = apiData['address'];
          List<String> addressParts = [];

          if (addressObj['address'] != null &&
              addressObj['address'].toString().isNotEmpty) {
            addressParts.add(addressObj['address'].toString());
          }
          if (addressObj['local_body'] != null &&
              addressObj['local_body'].toString().isNotEmpty) {
            addressParts.add(addressObj['local_body'].toString());
          }
          if (addressObj['district'] != null &&
              addressObj['district'].toString().isNotEmpty) {
            addressParts.add(addressObj['district'].toString());
          }
          if (addressObj['pincode'] != null &&
              addressObj['pincode'].toString().isNotEmpty) {
            addressParts.add(addressObj['pincode'].toString());
          }

          fullAddress = addressParts.join(', ');
        }
      }

      return {
        'name': isUnifiedApiData ? (apiData['nrk_name'] ?? '') : (apiData['name'] ?? ''),
        'norka_id': norkaProvider.norkaId.isNotEmpty
            ? norkaProvider.norkaId
            : '',
        'date_of_birth': apiData['dob'] ?? apiData['date_of_birth'] ?? '',
        'gender': apiData['gender'] ?? '',
        'primary_email': primaryEmail,
        'secondary_email': secondaryEmail,
        'primary_phone': primaryPhone,
        'secondary_phone': secondaryPhone,
        'address': fullAddress,
      };
    } else {
      // Return empty data if no API data is available
      return {
        'name': '',
        'norka_id': '',
        'date_of_birth': '',
        'gender': '',
        'primary_email': '',
        'secondary_email': '',
        'primary_phone': '',
        'secondary_phone': '',
        'address': '',
      };
    }
  }

  @override
  void dispose() {
    _primaryEmailController.dispose();
    _secondaryEmailController.dispose();
    _primaryPhoneController.dispose();
    _secondaryPhoneController.dispose();
    _primaryIntlPhoneController.dispose();
    _secondaryIntlPhoneController.dispose();
    super.dispose();
  }

  // Helper methods for editing
  void _startEditingPrimaryEmail() {
    setState(() {
      // Close all other editing states
      _isEditingSecondaryEmail = false;
      _isEditingPrimaryPhone = false;
      _isEditingSecondaryPhone = false;
      _isAddingSecondaryEmail = false;
      _isAddingSecondaryPhone = false;
      
      // Start editing primary email
      _isEditingPrimaryEmail = true;
      _primaryEmailController.text = _extractProfileDetails(context)['primary_email'] ?? '';
    });
  }

  void _startEditingSecondaryEmail() {
    setState(() {
      // Close all other editing states
      _isEditingPrimaryEmail = false;
      _isEditingPrimaryPhone = false;
      _isEditingSecondaryPhone = false;
      _isAddingSecondaryEmail = false;
      _isAddingSecondaryPhone = false;
      
      // Start editing secondary email
      _isEditingSecondaryEmail = true;
      _secondaryEmailController.text = _extractProfileDetails(context)['secondary_email'] ?? '';
    });
  }

  void _startEditingPrimaryPhone() {
    final phoneNumber = _extractProfileDetails(context)['primary_phone'] ?? '';
    final phoneData = _extractPhoneNumberAndCountryCode(phoneNumber);
    
    setState(() {
      // Close all other editing states
      _isEditingPrimaryEmail = false;
      _isEditingSecondaryEmail = false;
      _isEditingSecondaryPhone = false;
      _isAddingSecondaryEmail = false;
      _isAddingSecondaryPhone = false;
      
      // Start editing primary phone
      _isEditingPrimaryPhone = true;
      _selectedPrimaryCountryCode = phoneData['countryCode'] ?? '+91';
      _primaryPhoneController.text = phoneData['number'] ?? '';
      _primaryIntlPhoneController.text = phoneData['number'] ?? '';
      _selectedPrimaryPhoneNumber = phoneData['number'] ?? '';
    });
  }

  void _startEditingSecondaryPhone() {
    final phoneNumber = _extractProfileDetails(context)['secondary_phone'] ?? '';
    final phoneData = _extractPhoneNumberAndCountryCode(phoneNumber);
    
    setState(() {
      // Close all other editing states
      _isEditingPrimaryEmail = false;
      _isEditingSecondaryEmail = false;
      _isEditingPrimaryPhone = false;
      _isAddingSecondaryEmail = false;
      _isAddingSecondaryPhone = false;
      
      // Start editing secondary phone
      _isEditingSecondaryPhone = true;
      _selectedSecondaryCountryCode = phoneData['countryCode'] ?? '+91';
      _secondaryPhoneController.text = phoneData['number'] ?? '';
      _secondaryIntlPhoneController.text = phoneData['number'] ?? '';
      _selectedSecondaryPhoneNumber = phoneData['number'] ?? '';
    });
  }

  void _startAddingSecondaryEmail() {
    setState(() {
      // Close all other editing states
      _isEditingPrimaryEmail = false;
      _isEditingSecondaryEmail = false;
      _isEditingPrimaryPhone = false;
      _isEditingSecondaryPhone = false;
      _isAddingSecondaryPhone = false;
      
      // Start adding secondary email
      _isAddingSecondaryEmail = true;
      _secondaryEmailController.clear();
    });
  }

  void _startAddingSecondaryPhone() {
    setState(() {
      // Close all other editing states
      _isEditingPrimaryEmail = false;
      _isEditingSecondaryEmail = false;
      _isEditingPrimaryPhone = false;
      _isEditingSecondaryPhone = false;
      _isAddingSecondaryEmail = false;
      
      // Start adding secondary phone
      _isAddingSecondaryPhone = true;
      _secondaryPhoneController.clear();
      _secondaryIntlPhoneController.clear();
      _selectedSecondaryPhoneNumber = '';
    });
  }

  void _savePrimaryEmail() async {
    final email = _primaryEmailController.text.trim();
    if (email.isEmpty) {
      ToastMessage.failedToast('Please enter a valid email address');
      return;
    }
    
    if (!_isValidEmail(email)) {
      ToastMessage.failedToast('Please enter a valid email format');
      return;
    }

    try {
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
      
      final response = await verificationProvider.updatePrimaryEmail(
        norkaProvider.norkaId,
        email,
      );
      
      if (response['success'] == true) {
        setState(() {
          _isEditingPrimaryEmail = false;
        });
        ToastMessage.successToast('Primary email updated successfully!');
      } else {
        ToastMessage.failedToast('Failed to update primary email');
      }
    } catch (e) {
      ToastMessage.failedToast('Error updating primary email: $e');
    }
  }

  void _saveSecondaryEmail() async {
    final email = _secondaryEmailController.text.trim();
    if (email.isEmpty) {
      ToastMessage.failedToast('Please enter a valid email address');
      return;
    }
    
    if (!_isValidEmail(email)) {
      ToastMessage.failedToast('Please enter a valid email format');
      return;
    }

    try {
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
      
      final response = await verificationProvider.updateSecondaryEmail(
        norkaProvider.norkaId,
        email,
      );
      
      if (response['success'] == true) {
        setState(() {
          _isEditingSecondaryEmail = false;
          _isAddingSecondaryEmail = false;
        });
        ToastMessage.successToast('Secondary email updated successfully!');
      } else {
        ToastMessage.failedToast('Failed to update secondary email');
      }
    } catch (e) {
      ToastMessage.failedToast('Error updating secondary email: $e');
    }
  }

  void _savePrimaryPhone() async {
    final phoneNumber = _selectedPrimaryPhoneNumber.trim();
    if (phoneNumber.isEmpty) {
      ToastMessage.failedToast('Please enter a valid phone number');
      return;
    }
    
    final fullPhoneNumber = '$_selectedPrimaryCountryCode$phoneNumber';
    
    if (!_isValidPhone(phoneNumber)) {
      ToastMessage.failedToast('Please enter a valid phone number');
      return;
    }

    try {
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
      
      final response = await verificationProvider.updatePrimaryMobile(
        norkaProvider.norkaId,
        fullPhoneNumber,
      );
      
      if (response['success'] == true) {
        setState(() {
          _isEditingPrimaryPhone = false;
        });
        ToastMessage.successToast('Primary phone updated successfully!');
        debugPrint('Primary phone saved: $fullPhoneNumber');
      } else {
        ToastMessage.failedToast('Failed to update primary phone');
      }
    } catch (e) {
      ToastMessage.failedToast('Error updating primary phone: $e');
    }
  }

  void _saveSecondaryPhone() async {
    final phoneNumber = _selectedSecondaryPhoneNumber.trim();
    if (phoneNumber.isEmpty) {
      ToastMessage.failedToast('Please enter a valid phone number');
      return;
    }
    
    final fullPhoneNumber = '$_selectedSecondaryCountryCode$phoneNumber';
    
    if (!_isValidPhone(phoneNumber)) {
      ToastMessage.failedToast('Please enter a valid phone number');
      return;
    }

    try {
      final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
      final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
      
      final response = await verificationProvider.updateSecondaryMobile(
        norkaProvider.norkaId,
        fullPhoneNumber,
      );
      
      if (response['success'] == true) {
        setState(() {
          _isEditingSecondaryPhone = false;
          _isAddingSecondaryPhone = false;
        });
        ToastMessage.successToast('Secondary phone updated successfully!');
        debugPrint('Secondary phone saved: $fullPhoneNumber');
      } else {
        ToastMessage.failedToast('Failed to update secondary phone');
      }
    } catch (e) {
      ToastMessage.failedToast('Error updating secondary phone: $e');
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditingPrimaryEmail = false;
      _isEditingSecondaryEmail = false;
      _isEditingPrimaryPhone = false;
      _isEditingSecondaryPhone = false;
      _isAddingSecondaryEmail = false;
      _isAddingSecondaryPhone = false;
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^[0-9]{7,15}$').hasMatch(phone);
  }


  Map<String, String> _extractPhoneNumberAndCountryCode(String fullPhoneNumber) {
    if (fullPhoneNumber.isEmpty) {
      return {'countryCode': '+91', 'number': ''};
    }

    // Simple extraction - if it starts with +, extract country code
    if (fullPhoneNumber.startsWith('+')) {
      // Find the first space or end of country code
      int spaceIndex = fullPhoneNumber.indexOf(' ');
      if (spaceIndex > 0) {
        String countryCode = fullPhoneNumber.substring(0, spaceIndex);
        String number = fullPhoneNumber.substring(spaceIndex + 1);
        return {'countryCode': countryCode, 'number': number};
      } else {
        // No space found, try to extract common country codes
        if (fullPhoneNumber.length > 3) {
          String countryCode = fullPhoneNumber.substring(0, 3);
          String number = fullPhoneNumber.substring(3);
          return {'countryCode': countryCode, 'number': number};
        }
      }
    }

    // If no country code found, assume it's just the number with default country code
    return {'countryCode': '+91', 'number': fullPhoneNumber};
  }



  Widget _buildPhoneInputField({
    required TextEditingController controller,
    required String title,
    required bool isPrimary,
    bool isAdding = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final intlController = isPrimary ? _primaryIntlPhoneController : _secondaryIntlPhoneController;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: IntlPhoneField(
        controller: intlController,
        initialCountryCode: 'IN', // Default to India, same as registration page
        cursorColor: AppConstants.primaryColor,
        style: TextStyle(
          color: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: isAdding 
              ? 'Add phone number'
              : 'Enter phone number',
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
            if (isPrimary) {
              _selectedPrimaryCountryCode = phone.countryCode;
              _selectedPrimaryPhoneNumber = phone.number;
            } else {
              _selectedSecondaryCountryCode = phone.countryCode;
              _selectedSecondaryPhoneNumber = phone.number;
            }
          });
        },
        onCountryChanged: (country) {
          setState(() {
            if (isPrimary) {
              _selectedPrimaryCountryCode = '+${country.dialCode}';
            } else {
              _selectedSecondaryCountryCode = '+${country.dialCode}';
            }
          });
        },
      ),
    );
  }

  // Image picker methods remain the same...
  void _showImagePickerDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppConstants.boxBlackColor
                : AppConstants.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              AppText(
                text: 'Choose Profile Picture',
                size: 18,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: AppConstants.primaryColor,
                ),
                title: AppText(
                  text: 'Take Photo',
                  size: 16,
                  weight: FontWeight.w500,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppConstants.primaryColor,
                ),
                title: AppText(
                  text: 'Choose from Gallery',
                  size: 16,
                  weight: FontWeight.w500,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImage != null) ...[
                ListTile(
                  leading: Icon(Icons.delete, color: AppConstants.redColor),
                  title: AppText(
                    text: 'Remove Photo',
                    size: 16,
                    weight: FontWeight.w500,
                    textColor: AppConstants.redColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfileImage();
                  },
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          _profileImage = File(image.path);
        });

        // Show success message
        ToastMessage.successToast('Profile picture updated successfully!');
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ToastMessage.failedToast('Failed to pick image. Please try again.');
      }
    }
  }

  void _removeProfileImage() {
    setState(() {
      _profileImage = null;
    });

    // Show success message
    ToastMessage.successToast('Profile picture removed successfully!');
  }

  String _formatDOB(String dob) {
    debugPrint('=== PROFILE DETAILS DOB FORMATTING ===');
    debugPrint('Input DOB: "$dob"');

    if (dob.isEmpty) {
      debugPrint('DOB is empty, returning empty string');
      return '';
    }

    // Check if the date is in YYYY-MM-DD format (from unified API)
    if (dob.contains('-') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('-');
        debugPrint('Split parts: $parts');
        if (parts.length == 3) {
          // Check if first part is 4 digits (year) - YYYY-MM-DD format
          if (parts[0].length == 4) {
            String year = parts[0];
            String month = parts[1].padLeft(2, '0');
            String day = parts[2].padLeft(2, '0');

            // Convert from YYYY-MM-DD to DD/MM/YYYY
            String formattedDate = '$day/$month/$year';
            debugPrint('Formatted DOB (YYYY-MM-DD): "$formattedDate"');
            return formattedDate;
          }
          // Otherwise assume MM-DD-YYYY format
          else {
            String month = parts[0].padLeft(2, '0');
            String day = parts[1].padLeft(2, '0');
            String year = parts[2];

            // Convert from MM-DD-YYYY to DD/MM/YYYY
            String formattedDate = '$day/$month/$year';
            debugPrint('Formatted DOB (MM-DD-YYYY): "$formattedDate"');
            return formattedDate;
          }
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Check if the date is in MM/DD/YYYY format (with slashes)
    if (dob.contains('/') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('/');
        debugPrint('Split parts: $parts');
        if (parts.length == 3) {
          String month = parts[0].padLeft(2, '0');
          String day = parts[1].padLeft(2, '0');
          String year = parts[2];

          // Convert from MM/DD/YYYY to DD/MM/YYYY
          String formattedDate = '$day/$month/$year';
          debugPrint('Formatted DOB (MM/DD/YYYY): "$formattedDate"');
          return formattedDate;
        }
      } catch (e) {
        debugPrint('Error formatting DOB: $e');
      }
    }

    // Return original if not in expected format
    debugPrint('No formatting applied, returning original: "$dob"');
    return dob;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoIcons.back
                : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppText(
          text: 'My Profile',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white,
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Consumer<NorkaProvider>(
        builder: (context, norkaProvider, child) {
          // Extract dynamic profile details from provider
          final profileDetails = _extractProfileDetails(context);

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Header
                _buildProfileHeader(
                  profileDetails['name'],
                  profileDetails['norka_id'],
                ),

                const SizedBox(height: 20),

                // Personal Information
                _buildPersonalInfoSection(profileDetails),

                const SizedBox(height: 20),

                // Contact Information
                _buildContactInfoSection(profileDetails),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String customerId) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              GestureDetector(
                // onTap: _showImagePickerDialog,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    border: Border.all(
                      color: AppConstants.primaryColor,
                      width: 3,
                    ),
                    image: _profileImage != null
                        ? DecorationImage(
                            image: FileImage(_profileImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _profileImage == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: AppConstants.primaryColor,
                        )
                      : null,
                ),
              ),
              // Edit Icon
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImagePickerDialog,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppConstants.whiteColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 12,
                      color: AppConstants.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: name.isEmpty ? 'Not Available' : name,
                  size: 18,
                  weight: FontWeight.bold,
                  textColor: name.isEmpty
                      ? AppConstants.greyColor
                      : (isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor),
                ),
                const SizedBox(height: 4),
                AppText(
                  text: customerId.isEmpty
                      ? 'Norka ID: Not Available'
                      : 'Norka ID: $customerId',
                  size: 14,
                  weight: FontWeight.w500,
                  textColor: customerId.isEmpty
                      ? AppConstants.greyColor
                      : AppConstants.greyColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(Map<String, dynamic> profileDetails) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSectionHeader('Personal Information'),
          _buildDetailTile(
            icon: Icons.cake,
            title: 'Date of Birth',
            value: _formatDOB(profileDetails['date_of_birth'] ?? ''),
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.person_outline,
            title: 'Gender',
            value: profileDetails['gender'] ?? '',
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.location_on,
            title: 'Address',
            value: profileDetails['address'] ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(Map<String, dynamic> profileDetails) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernSectionHeader('Contact Information', Icons.contact_phone),
          
          // Email Section
          _buildContactSubSection(
            title: 'Email Addresses',
            icon: Icons.email_outlined,
            children: [
              _buildModernEditableTile(
                icon: Icons.email,
                title: 'Primary Email',
                value: profileDetails['primary_email'] ?? '',
                isEditing: _isEditingPrimaryEmail,
                controller: _primaryEmailController,
                onEdit: _startEditingPrimaryEmail,
                onSave: _savePrimaryEmail,
                onCancel: _cancelEditing,
                isPrimary: true,
              ),
              _buildModernSecondaryTile(
                icon: Icons.email_outlined,
                title: 'Secondary Email',
                value: profileDetails['secondary_email'] ?? '',
                isEditing: _isEditingSecondaryEmail,
                isAdding: _isAddingSecondaryEmail,
                controller: _secondaryEmailController,
                onEdit: _startEditingSecondaryEmail,
                onAdd: _startAddingSecondaryEmail,
                onSave: _saveSecondaryEmail,
                onCancel: _cancelEditing,
              ),
            ],
          ),
          
          _buildSectionDivider(),
          
          // Phone Section
          _buildContactSubSection(
            title: 'Phone Numbers',
            icon: Icons.phone_outlined,
            children: [
              _buildModernEditableTile(
                icon: Icons.phone,
                title: 'Primary Phone',
                value: profileDetails['primary_phone'] ?? '',
                isEditing: _isEditingPrimaryPhone,
                controller: _primaryPhoneController,
                onEdit: _startEditingPrimaryPhone,
                onSave: _savePrimaryPhone,
                onCancel: _cancelEditing,
                isPrimary: true,
                isPhone: true,
              ),
              _buildModernSecondaryTile(
                icon: Icons.phone_outlined,
                title: 'Secondary Phone',
                value: profileDetails['secondary_phone'] ?? '',
                isEditing: _isEditingSecondaryPhone,
                isAdding: _isAddingSecondaryPhone,
                controller: _secondaryPhoneController,
                onEdit: _startEditingSecondaryPhone,
                onAdd: _startAddingSecondaryPhone,
                onSave: _saveSecondaryPhone,
                onCancel: _cancelEditing,
                isPhone: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Modern UI helper methods
  Widget _buildModernSectionHeader(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withOpacity(0.1),
            AppConstants.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          AppText(
            text: title,
            size: 18,
            weight: FontWeight.bold,
            textColor: AppConstants.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSubSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.grey.withOpacity(0.05)
            : Colors.grey.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppConstants.primaryColor.withOpacity(0.7),
                size: 18,
              ),
              const SizedBox(width: 8),
              AppText(
                text: title,
                size: 14,
                weight: FontWeight.w600,
                textColor: AppConstants.primaryColor.withOpacity(0.8),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            isDarkMode 
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildModernEditableTile({
    required IconData icon,
    required String title,
    required String value,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    required bool isPrimary,
    bool isPhone = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.grey.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary 
              ? AppConstants.primaryColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPrimary 
                      ? AppConstants.primaryColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isPrimary 
                      ? AppConstants.primaryColor
                      : Colors.grey[600],
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  text: title,
                  size: 14,
                  weight: FontWeight.w600,
                  textColor: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
                ),
              ),
              if (!isEditing)
                Container(
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: AppConstants.primaryColor, size: 16),
                    onPressed: onEdit,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (isEditing)
            isPhone 
                ? _buildPhoneInputField(
                    controller: controller,
                    title: title,
                    isPrimary: isPrimary,
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? AppConstants.boxBlackColor.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      style: TextStyle(
                        color: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter ${title.toLowerCase()}',
                        hintStyle: TextStyle(
                          color: AppConstants.greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      autofocus: true,
                    ),
                  )
          else
            AppText(
              text: value.isEmpty ? '' : value,
              size: 15,
              weight: FontWeight.w500,
              textColor: value.isEmpty
                  ? AppConstants.greyColor
                  : (isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
            ),
          if (isEditing) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppConstants.redColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: AppConstants.redColor, size: 16),
                    onPressed: onCancel,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppConstants.greenColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.check, color: AppConstants.greenColor, size: 16),
                    onPressed: onSave,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernSecondaryTile({
    required IconData icon,
    required String title,
    required String value,
    required bool isEditing,
    required bool isAdding,
    required TextEditingController controller,
    required VoidCallback onEdit,
    required VoidCallback onAdd,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    bool isPhone = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.grey.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.grey[600],
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  text: title,
                  size: 14,
                  weight: FontWeight.w600,
                  textColor: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
                ),
              ),
              if (!isEditing && !isAdding) ...[
                if (value.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: AppConstants.primaryColor, size: 16),
                      onPressed: onEdit,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
                // Only show Add button if no secondary contact exists
                if (value.isEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: AppConstants.greenColor, size: 16),
                      onPressed: onAdd,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          if (isEditing || isAdding)
            isPhone 
                ? _buildPhoneInputField(
                    controller: controller,
                    title: title,
                    isPrimary: false,
                    isAdding: isAdding,
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? AppConstants.boxBlackColor.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      style: TextStyle(
                        color: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: isAdding 
                            ? 'Add ${title.toLowerCase()}'
                            : 'Enter ${title.toLowerCase()}',
                        hintStyle: TextStyle(
                          color: AppConstants.greyColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      autofocus: true,
                    ),
                  )
          else
            AppText(
              text: value.isEmpty ? '' : value,
              size: 15,
              weight: FontWeight.w500,
              textColor: value.isEmpty
                  ? AppConstants.greyColor
                  : (isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
            ),
          if (isEditing || isAdding) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppConstants.redColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: AppConstants.redColor, size: 16),
                    onPressed: onCancel,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppConstants.greenColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.check, color: AppConstants.greenColor, size: 16),
                    onPressed: onSave,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Existing helper methods _buildSectionHeader, _buildDetailTile, _buildDivider remain the same
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: AppText(
        text: title,
        size: 18,
        weight: FontWeight.bold,
        textColor: AppConstants.primaryColor,
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.primaryColor.withOpacity(0.1),
          border: Border.all(
            color: AppConstants.primaryColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppConstants.primaryColor, size: 20),
      ),
      title: AppText(
        text: title,
        size: 14,
        weight: FontWeight.w500,
        textColor: AppConstants.greyColor,
      ),
      subtitle: AppText(
        text: value.isEmpty ? 'Not Available' : value,
        size: 15,
        weight: FontWeight.w600,
        textColor: value.isEmpty
            ? AppConstants.greyColor
            : (isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
      ),
    );
  }

  Widget _buildDivider() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      color: isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.grey.withOpacity(0.2),
      indent: 70,
    );
  }


}
