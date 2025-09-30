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
import '../../provider/otp_verification_provider.dart';
import 'package:flutter/foundation.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  // Profile image state
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Map<String, dynamic> _extractProfileDetails(BuildContext context) {
    // Get data from OTP verification provider first, then fallback to NORKA provider
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    final otpVerificationProvider = Provider.of<OtpVerificationProvider>(
      context,
      listen: false,
    );

    // Try to get from verified customer data first, then fallback to NORKA provider
    final verifiedCustomerData = otpVerificationProvider.getVerifiedCustomerData();
    final apiData = verifiedCustomerData ?? norkaProvider.response;

    if (apiData != null) {

      // Extract email and phone from arrays
      String email = '';
      String phone = '';

      if (apiData['emails'] != null && apiData['emails'].isNotEmpty) {
        email = apiData['emails'][0]['address'] ?? '';
      }

      if (apiData['mobiles'] != null && apiData['mobiles'].isNotEmpty) {
        phone = apiData['mobiles'][0]['with_dial_code'] ?? '';
      }

      // Build full address from address object
      String fullAddress = '';
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

      return {
        'name': apiData['name'] ?? '',
        'norka_id': norkaProvider.norkaId.isNotEmpty
            ? norkaProvider.norkaId
            : '',
        'date_of_birth': apiData['date_of_birth'] ?? '',
        'gender': apiData['gender'] ?? '',
        'email': email,
        'phone': phone,
        'address': fullAddress,
      };
    } else {
      // Return empty data if no API data is available
      return {
        'name': '',
        'norka_id': '',
        'date_of_birth': '',
        'gender': '',
        'email': '',
        'phone': '',
        'address': '',
      };
    }
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

    // Check if the date is in MM-DD-YYYY format (with hyphens) - most common format from API
    if (dob.contains('-') && dob.length >= 10) {
      try {
        List<String> parts = dob.split('-');
        debugPrint('Split parts: $parts');
        if (parts.length == 3) {
          String month = parts[0].padLeft(2, '0');
          String day = parts[1].padLeft(2, '0');
          String year = parts[2];

          // Convert from MM-DD-YYYY to DD/MM/YYYY
          String formattedDate = '$day/$month/$year';
          debugPrint('Formatted DOB: "$formattedDate"');
          return formattedDate;
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
          debugPrint('Formatted DOB: "$formattedDate"');
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
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: GestureDetector(
              //     onTap: _showImagePickerDialog,
              //     child: Container(
              //       width: 24,
              //       height: 24,
              //       decoration: BoxDecoration(
              //         color: AppConstants.primaryColor,
              //         shape: BoxShape.circle,
              //         border: Border.all(
              //           color: AppConstants.whiteColor,
              //           width: 2,
              //         ),
              //       ),
              //       child: Icon(
              //         Icons.camera_alt,
              //         size: 12,
              //         color: AppConstants.whiteColor,
              //       ),
              //     ),
              //   ),
              // ),
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
          _buildSectionHeader('Contact Information'),
          _buildDetailTile(
            icon: Icons.email,
            title: 'Email Address',
            value: profileDetails['email'] ?? '',
          ),
          _buildDivider(),
          _buildDetailTile(
            icon: Icons.phone,
            title: 'Phone Number',
            value: profileDetails['phone'] ?? '',
          ),
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
