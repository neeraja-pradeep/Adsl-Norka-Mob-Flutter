import 'dart:io';
import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:file_picker/file_picker.dart';

class FileClaimPage extends StatefulWidget {
  const FileClaimPage({super.key});

  @override
  State<FileClaimPage> createState() => _FileClaimPageState();
}

class _FileClaimPageState extends State<FileClaimPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController claimAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  // Bank Account Details
  final TextEditingController accountHolderNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController reEnterAccountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  
  // Health Insurance Fields
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController hospitalPinCodeController = TextEditingController();
  final TextEditingController hospitalAddressController = TextEditingController();
  final TextEditingController hospitalMobileController = TextEditingController();
  final TextEditingController hospitalEmailController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  
  // Hospital Location Fields
  String? selectedState;
  String? selectedCity;
  
  // Selected values
  DateTime? selectedDate;
  DateTime? admissionDate;
  DateTime? dischargeDate;
  String? selectedPatient;
  String? selectedClaimType;
  
  List<String> uploadedDocuments = [];
  String uploadedBankDocument = '';
  Map<String, int> uploadedFilesWithSize = {}; // Track file sizes
  PlatformFile? selectedBankFile; // Store the actual bank file
  

  final List<String> bankDocumentTypes = [
    'Cancelled Cheque',
    'Passbook',
    'Bank Statement',
  ];

  final List<String> claimTypes = [
    'Medical Treatment',
    'Hospitalization',
    'Surgery',
    'Emergency Treatment',
    'Outpatient Treatment',
    'Prescription Medicine',
    'Diagnostic Tests',
    'Other',
  ];

  // State and City Data
  final Map<String, List<String>> stateCityMap = {
    'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur', 'Kollam', 'Palakkad', 'Malappuram', 'Kannur', 'Kasaragod', 'Alappuzha', 'Pathanamthitta', 'Kottayam', 'Idukki', 'Wayanad'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Tirunelveli', 'Tiruppur', 'Erode', 'Vellore', 'Thoothukkudi', 'Dindigul', 'Thanjavur', 'Ranipet', 'Sivaganga'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli', 'Mangalore', 'Belgaum', 'Gulbarga', 'Davanagere', 'Bellary', 'Bijapur', 'Shimoga', 'Tumkur', 'Raichur', 'Bidar', 'Hassan'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad', 'Solapur', 'Amravati', 'Kolhapur', 'Sangli', 'Malegaon', 'Jalgaon', 'Akola', 'Latur', 'Dhule'],
    'Delhi': ['New Delhi', 'Central Delhi', 'North Delhi', 'South Delhi', 'East Delhi', 'West Delhi', 'North East Delhi', 'North West Delhi', 'South East Delhi', 'South West Delhi'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar', 'Jamnagar', 'Junagadh', 'Gandhinagar', 'Anand', 'Navsari', 'Morbi', 'Nadiad', 'Surendranagar', 'Bharuch'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Bikaner', 'Ajmer', 'Bharatpur', 'Bhilwara', 'Alwar', 'Ganganagar', 'Sikar', 'Pali', 'Sri Ganganagar', 'Kishangarh'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Agra', 'Varanasi', 'Meerut', 'Allahabad', 'Bareilly', 'Ghaziabad', 'Moradabad', 'Aligarh', 'Saharanpur', 'Noida', 'Firozabad', 'Jhansi'],
    'West Bengal': ['Kolkata', 'Asansol', 'Siliguri', 'Durgapur', 'Bardhaman', 'Malda', 'Baharampur', 'Habra', 'Kharagpur', 'Shantipur', 'Dankuni', 'Dhulian', 'Ranaghat', 'Haldia'],
    'Andhra Pradesh': ['Hyderabad', 'Visakhapatnam', 'Vijayawada', 'Guntur', 'Nellore', 'Kurnool', 'Rajahmundry', 'Tirupati', 'Kadapa', 'Anantapur', 'Chittoor', 'Eluru', 'Ongole', 'Nandyal'],
  };

  @override
  void dispose() {
    patientNameController.dispose();
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    reEnterAccountNumberController.dispose();
    ifscCodeController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    claimAmountController.dispose();
    descriptionController.dispose();
    hospitalNameController.dispose();
    hospitalPinCodeController.dispose();
    hospitalAddressController.dispose();
    hospitalMobileController.dispose();
    hospitalEmailController.dispose();
    doctorNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryColor,
              onPrimary: AppConstants.whiteColor,
              surface: isDarkMode ? AppConstants.boxBlackColor : AppConstants.whiteColor,
              onSurface: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (type == 'incident') {
          selectedDate = picked;
        } else if (type == 'admission') {
          admissionDate = picked;
        } else if (type == 'discharge') {
          dischargeDate = picked;
        }
      });
    }
  }

  List<Map<String, String>> _getFamilyMembers() {
    final verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
    final familyData = verificationProvider.familyMembersDetails;
    final enrollmentData = verificationProvider.enrollmentDetails;
    
    List<Map<String, String>> members = [];
    
    // Extract enrollment data - handle both old and new API response structures
    Map<String, dynamic> enrollmentDetails = {};
    if (enrollmentData.isNotEmpty) {
      // Check for unified API response structure (direct enrollment data)
      if (enrollmentData.containsKey('self_enrollment_number')) {
        enrollmentDetails = enrollmentData;
      }
      // Check for old API response structure (data wrapper)
      else if (enrollmentData['data'] != null) {
        enrollmentDetails = enrollmentData['data'];
      }
    }
    
    // Add Self
    if (familyData['nrk_name'] != null) {
      members.add({
        'name': familyData['nrk_name'] ?? '',
        'relationship': 'Self',
        'enrollmentNumber': enrollmentDetails['self_enrollment_number'] ?? 'Not Generated',
      });
    }
    
    // Add Spouse
    if (familyData['spouse_name'] != null &&
        familyData['spouse_name'].toString().isNotEmpty) {
      members.add({
        'name': familyData['spouse_name'] ?? '',
        'relationship': 'Spouse',
        'enrollmentNumber': enrollmentDetails['spouse_enrollment_number'] ?? 'Not Generated',
      });
    }
    
    // Add Children
    for (int i = 1; i <= 5; i++) {
      String kidName = familyData['kid_${i}_name'] ?? '';
      if (kidName.isNotEmpty) {
        members.add({
          'name': kidName,
          'relationship': 'Child $i',
          'enrollmentNumber': enrollmentDetails['child${i}_enrollment_number'] ?? 'Not Generated',
        });
      }
    }
    
    return members;
  }

  Widget _buildPatientDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final familyMembers = _getFamilyMembers();
    
    return Container(
      height: 48, // Fixed height to match other form fields
      margin: const EdgeInsets.symmetric(horizontal: 0), // Ensure proper margins
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPatient,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            size: 20,
          ),
          hint: AppText(
            text: 'Select patient',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          items: [
            // Add placeholder option
            DropdownMenuItem<String>(
              value: null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: 'Select patient',
                  size: 16,
                  weight: FontWeight.normal,
                  textColor: AppConstants.greyColor,
                ),
              ),
            ),
            // Add family members
            ...familyMembers.map<DropdownMenuItem<String>>((member) {
              return DropdownMenuItem<String>(
                value: member['name'],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppText(
                    text: '${member['name']} (${member['relationship']})',
                    size: 16,
                    weight: FontWeight.normal,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ),
              );
            }).toList(),
          ],
          onChanged: (String? newValue) {
            setState(() {
              selectedPatient = newValue;
              if (newValue != null) {
                patientNameController.text = newValue;
              }
            });
          },
          dropdownColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          style: TextStyle(
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStateDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final states = stateCityMap.keys.toList();
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedState,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            size: 20,
          ),
          hint: AppText(
            text: 'Select state',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          items: states.map<DropdownMenuItem<String>>((state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: state,
                  size: 16,
                  weight: FontWeight.normal,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedState = newValue;
              selectedCity = null; // Reset city when state changes
            });
          },
          dropdownColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          style: TextStyle(
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cities = selectedState != null ? stateCityMap[selectedState] ?? [] : [];
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCity,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            size: 20,
          ),
          hint: AppText(
            text: selectedState == null ? 'Select state first' : 'Select city',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          items: cities.map<DropdownMenuItem<String>>((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: city,
                  size: 16,
                  weight: FontWeight.normal,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
            );
          }).toList(),
          onChanged: selectedState == null ? null : (String? newValue) {
            setState(() {
              selectedCity = newValue;
            });
          },
          dropdownColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          style: TextStyle(
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildClaimTypeDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedClaimType,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            size: 20,
          ),
          hint: AppText(
            text: 'Select claim type',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          items: [
            // Add placeholder option
            DropdownMenuItem<String>(
              value: null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: 'Select claim type',
                  size: 16,
                  weight: FontWeight.normal,
                  textColor: AppConstants.greyColor,
                ),
              ),
            ),
            // Add claim types
            ...claimTypes.map<DropdownMenuItem<String>>((claimType) {
              return DropdownMenuItem<String>(
                value: claimType,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppText(
                    text: claimType,
                    size: 16,
                    weight: FontWeight.normal,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ),
              );
            }).toList(),
          ],
          onChanged: (String? newValue) {
            setState(() {
              selectedClaimType = newValue;
            });
          },
          dropdownColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          style: TextStyle(
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _submitClaim() {
    if (_formKey.currentState!.validate()) {
      if (selectedPatient == null || selectedPatient!.isEmpty) {
        ToastMessage.failedToast('Please select a patient');
        return;
      }
      
      if (selectedClaimType == null || selectedClaimType!.isEmpty) {
        ToastMessage.failedToast('Please select a claim type');
        return;
      }
      
      // Validate claim amount
      final claimAmount = double.tryParse(claimAmountController.text);
      if (claimAmount == null || claimAmount <= 0) {
        ToastMessage.failedToast('Please enter a valid claim amount');
        return;
      }
      
      if (claimAmount > 1000000) {
        ToastMessage.failedToast('Claim amount cannot exceed ₹10,00,000');
        return;
      }
      
      // Validate account numbers match
      if (accountNumberController.text != reEnterAccountNumberController.text) {
        ToastMessage.failedToast('Account numbers do not match');
        return;
      }
      
      // Validate state and city selection
      if (selectedState == null || selectedState!.isEmpty) {
        ToastMessage.failedToast('Please select a state');
        return;
      }
      
      if (selectedCity == null || selectedCity!.isEmpty) {
        ToastMessage.failedToast('Please select a city');
        return;
      }
      
      if (admissionDate == null) {
        ToastMessage.failedToast('Please select admission date');
        return;
      }
      
      if (uploadedBankDocument.isEmpty) {
        ToastMessage.failedToast('Please upload bank document');
        return;
      }
      
      if (uploadedDocuments.isEmpty) {
        ToastMessage.failedToast('Please upload claim documents');
        return;
      }
      
      // Show confirmation dialog
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.help_outline,
                color: AppConstants.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              AppText(
                text: 'Confirm Claim Submission',
                size: 18,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: 'Are you sure you want to submit this claim?',
                size: 16,
                weight: FontWeight.normal,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'Claim Details:',
                      size: 14,
                      weight: FontWeight.w600,
                      textColor: AppConstants.primaryColor,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text: 'Patient: ${selectedPatient ?? 'N/A'}',
                      size: 13,
                      weight: FontWeight.normal,
                      textColor: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                    ),
                    AppText(
                      text: 'Amount: ₹${claimAmountController.text}',
                      size: 13,
                      weight: FontWeight.normal,
                      textColor: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                    ),
                    AppText(
                      text: 'Type: ${selectedClaimType ?? 'N/A'}',
                      size: 13,
                      weight: FontWeight.normal,
                      textColor: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppText(
                text: 'Once submitted, you cannot modify the claim details.',
                size: 14,
                weight: FontWeight.w500,
                textColor: AppConstants.greyColor,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: 'Cancel',
                size: 14,
                weight: FontWeight.w500,
                textColor: AppConstants.greyColor,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
                _showSuccessDialog(); // Show success dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: 'Submit Claim',
                size: 14,
                weight: FontWeight.w600,
                textColor: AppConstants.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.greenColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: AppConstants.greenColor,
                ),
              ),
              const SizedBox(height: 20),
              AppText(
                text: 'Claim Submitted Successfully!',
                size: 20,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppText(
                text: 'Your claim has been submitted and is under review. You will receive updates on your registered email and phone number.',
                size: 14,
                weight: FontWeight.normal,
                textColor: AppConstants.greyColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    AppText(
                      text: 'Claim Reference Number',
                      size: 12,
                      weight: FontWeight.w500,
                      textColor: AppConstants.greyColor,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: 'CLM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      size: 18,
                      weight: FontWeight.bold,
                      textColor: AppConstants.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to claims page
              },
              color: AppConstants.primaryColor,
              textColor: AppConstants.whiteColor,
              height: 45,
            ),
          ],
        );
      },
    );
  }

  void _showSavedBankAccounts() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Sample saved bank accounts (in real app, fetch from database/API)
    final List<Map<String, String>> savedAccounts = [
      {
        'name': 'John Doe - SBI',
        'accountNumber': '****5678',
        'bank': 'State Bank of India',
        'ifsc': 'SBIN0001234',
      },
      {
        'name': 'John Doe - HDFC',
        'accountNumber': '****9012',
        'bank': 'HDFC Bank',
        'ifsc': 'HDFC0002345',
      },
    ];
    
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
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppConstants.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppText(
                    text: 'Select Saved Account',
                    size: 18,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ),
                Flexible(
                  child: savedAccounts.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance_outlined,
                                size: 60,
                                color: AppConstants.greyColor.withOpacity(0.5),
                              ),
                              const SizedBox(height: 12),
                              AppText(
                                text: 'No saved bank accounts',
                                size: 16,
                                weight: FontWeight.w500,
                                textColor: AppConstants.greyColor,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: savedAccounts.length,
                          itemBuilder: (context, index) {
                            final account = savedAccounts[index];
                            
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppConstants.darkBackgroundColor
                                    : AppConstants.whiteBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.account_balance,
                                    color: AppConstants.primaryColor,
                                    size: 24,
                                  ),
                                ),
                                title: AppText(
                                  text: account['name']!,
                                  size: 16,
                                  weight: FontWeight.w600,
                                  textColor: isDarkMode
                                      ? AppConstants.whiteColor
                                      : AppConstants.blackColor,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    AppText(
                                      text: '${account['bank']} - ${account['accountNumber']}',
                                      size: 13,
                                      weight: FontWeight.normal,
                                      textColor: AppConstants.greyColor,
                                    ),
                                    AppText(
                                      text: 'IFSC: ${account['ifsc']}',
                                      size: 12,
                                      weight: FontWeight.normal,
                                      textColor: AppConstants.greyColor,
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppConstants.greyColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    accountHolderNameController.text =
                                        account['name']!.split(' - ')[0];
                                    accountNumberController.text =
                                        account['accountNumber']!;
                                    reEnterAccountNumberController.text =
                                        account['accountNumber']!;
                                    bankNameController.text = account['bank']!;
                                    ifscCodeController.text = account['ifsc']!;
                                  });
                                  Navigator.pop(context);
                                  ToastMessage.successToast(
                                    'Bank account details filled',
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }



  // File size validation method
  bool _validateFileSize(int fileSizeInBytes) {
    const int maxSizeInBytes = 2 * 1024 * 1024; // 2MB in bytes
    return fileSizeInBytes <= maxSizeInBytes;
  }

  // Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Real PDF file upload using file picker
  Future<void> _pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        
        // Validate file size (2MB limit)
        if (!_validateFileSize(file.size)) {
          ToastMessage.failedToast(
            'File size (${_formatFileSize(file.size)}) exceeds 2MB limit'
          );
          return;
        }

        // Validate file extension
        String extension = file.extension?.toLowerCase() ?? '';
        if (extension != 'pdf') {
          ToastMessage.failedToast(
            'Please select a PDF file only'
          );
          return;
        }

        // Add valid file to uploaded documents
        setState(() {
          uploadedDocuments.clear(); // Clear previous files
          uploadedFilesWithSize.clear();
          uploadedDocuments.add(file.name);
          uploadedFilesWithSize[file.name] = file.size;
        });

        ToastMessage.successToast(
          'Document uploaded successfully (${_formatFileSize(file.size)})'
        );
      }
    } catch (e) {
      ToastMessage.failedToast(
        'Failed to pick files: ${e.toString()}'
      );
    }
  }

  // Real bank document upload using file picker
  Future<void> _uploadBankDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        
        // Validate file size (2MB limit)
        if (!_validateFileSize(file.size)) {
          ToastMessage.failedToast(
            'File size (${_formatFileSize(file.size)}) exceeds 2MB limit'
          );
          return;
        }

        // Validate file extension
        String extension = file.extension?.toLowerCase() ?? '';
        if (extension != 'pdf') {
          ToastMessage.failedToast(
            'Please select a PDF file only'
          );
          return;
        }

        // Set uploaded bank document
        setState(() {
          selectedBankFile = file;
          uploadedBankDocument = file.name;
        });

        ToastMessage.successToast(
          'Bank document uploaded successfully (${_formatFileSize(file.size)})'
        );
      }
    } catch (e) {
      ToastMessage.failedToast(
        'Failed to pick file: ${e.toString()}'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDarkMode
          ? AppConstants.darkBackgroundColor
          : AppConstants.whiteBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: AppConstants.whiteColor,
          ),
        ),
        title: AppText(
          text: 'File Health Claim',
          size: 20,
          weight: FontWeight.bold,
          textColor: AppConstants.whiteColor,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppConstants.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        text: 'Please fill in all the details accurately to ensure quick processing of your claim.',
                        size: 14,
                        weight: FontWeight.w500,
                        textColor: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Policy Details Section
              _buildSectionTitle('Policy Details'),
              const SizedBox(height: 12),
              
              // Policy Number
              _buildLabel('Policy Number'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : AppConstants.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.badge,
                      color: AppConstants.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    AppText(
                      text: '763300/25-26/NORKACARE/001',
                      size: 16,
                      weight: FontWeight.w600,
                      textColor: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Enrollment ID
              _buildLabel('Enrollment ID'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : AppConstants.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      color: AppConstants.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    Consumer<VerificationProvider>(
                      builder: (context, verificationProvider, child) {
                        // Get NORKA ID from dashboard API response
                        String norkaId = 'Loading...';
                        final unifiedResponse = verificationProvider.getUnifiedApiResponse();
                        if (unifiedResponse != null && unifiedResponse['nrk_id_no'] != null) {
                          norkaId = unifiedResponse['nrk_id_no'].toString();
                        }
                        
                        return AppText(
                          text: norkaId,
                          size: 16,
                          weight: FontWeight.w600,
                          textColor: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Member Details Section
              _buildSectionTitle('Member Details'),
              const SizedBox(height: 12),
              
              // Master Name
              _buildLabel('Master Name (Policy Holder)'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : AppConstants.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: AppConstants.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    Consumer<VerificationProvider>(
                      builder: (context, verificationProvider, child) {
                        // Get user name from dashboard API response
                        String userName = 'Loading...';
                        final unifiedResponse = verificationProvider.getUnifiedApiResponse();
                        if (unifiedResponse != null && 
                            unifiedResponse['user_details'] != null &&
                            unifiedResponse['user_details']['nrk_user'] != null) {
                          userName = unifiedResponse['user_details']['nrk_user']['name'] ?? 'Loading...';
                        }
                        
                        return AppText(
                          text: userName,
                          size: 16,
                          weight: FontWeight.w600,
                          textColor: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Patient Name
              _buildLabel('Patient Name (Self/Family Member)'),
              const SizedBox(height: 6),
              _buildPatientDropdown(),
              
              const SizedBox(height: 20),
              
              // Bank Account Details Section
              _buildSectionTitle('Bank Account Details'),
              const SizedBox(height: 12),
              
              // Account Holder Name
              _buildLabel('Account Holder Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: accountHolderNameController,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter account holder name',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account holder name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // Account Number
              _buildLabel('Account Number'),
              const SizedBox(height: 6),
              TextFormField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter account number',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.account_balance,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  if (value.length < 9) {
                    return 'Account number must be at least 9 digits';
                  }
                  if (value.length > 18) {
                    return 'Account number cannot exceed 18 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Account number must contain only numbers';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // Re-enter Account Number
              _buildLabel('Re-enter Account Number'),
              const SizedBox(height: 6),
              TextFormField(
                controller: reEnterAccountNumberController,
                keyboardType: TextInputType.number,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Re-enter account number',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.account_balance,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter account number';
                  }
                  if (value != accountNumberController.text) {
                    return 'Account numbers do not match';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // IFSC Code
              _buildLabel('IFSC Code'),
              const SizedBox(height: 6),
              TextFormField(
                controller: ifscCodeController,
                textCapitalization: TextCapitalization.characters,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter IFSC code',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.code,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IFSC code';
                  }
                  
                 
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // Bank Name
              _buildLabel('Bank Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: bankNameController,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter bank name',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.account_balance_wallet,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bank name';
                  }
                  if (value.length < 2) {
                    return 'Bank name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // Branch Name
              _buildLabel('Branch Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: branchNameController,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter branch name',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter branch name';
                  }
                  if (value.length < 2) {
                    return 'Branch name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // Bank Document Upload
              _buildLabel('Bank Document'),
              AppText(text: "Cancelled cheque/Passbook/Bank statement", size: 12, weight: FontWeight.w500, textColor: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
              const SizedBox(height: 6),
              InkWell(
                onTap: _uploadBankDocument,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.boxBlackColor
                        : AppConstants.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        size: 24,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Upload Bank Document',
                              size: 16,
                              weight: FontWeight.w600,
                              textColor: AppConstants.primaryColor,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                if (uploadedBankDocument.isNotEmpty) ...[
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Expanded(
                                  child: AppText(
                                    text: uploadedBankDocument.isNotEmpty 
                                        ? uploadedBankDocument
                                        : 'PDF files only, max 2MB',
                                    size: 12,
                                    weight: FontWeight.normal,
                                    textColor: uploadedBankDocument.isNotEmpty 
                                        ? AppConstants.primaryColor
                                        : AppConstants.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: AppConstants.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Save Bank Details Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (accountHolderNameController.text.isEmpty ||
                            accountNumberController.text.isEmpty ||
                            ifscCodeController.text.isEmpty) {
                          ToastMessage.failedToast(
                            'Please fill all required bank details',
                          );
                          return;
                        }
                        ToastMessage.successToast('Bank details saved successfully');
                      },
                      icon: Icon(
                        Icons.save_outlined,
                        color: AppConstants.primaryColor,
                        size: 20,
                      ),
                      label: AppText(
                        text: 'Save Bank Details',
                        size: 14,
                        weight: FontWeight.w600,
                        textColor: AppConstants.primaryColor,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: BorderSide(
                          color: AppConstants.primaryColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showSavedBankAccounts();
                      },
                      icon: Icon(
                        Icons.account_balance,
                        color: AppConstants.secondaryColor,
                        size: 20,
                      ),
                      label: AppText(
                        text: 'Use Saved Account',
                        size: 14,
                        weight: FontWeight.w600,
                        textColor: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.3)
                              : AppConstants.greyColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Claim Details Section
              _buildSectionTitle('Claim Details'),
              const SizedBox(height: 12),
              
              // Claim Amount
              _buildLabel('Claim Amount (₹)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: claimAmountController,
                keyboardType: TextInputType.number,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter claim amount',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter claim amount';
                  }
                  
                  // Check if it's a valid number
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Please enter a valid amount';
                  }
                  
                  // Check minimum amount
                  if (amount <= 0) {
                    return 'Amount must be greater than ₹0';
                  }
                  
                  // Check maximum amount (e.g., ₹10,00,000)
                  if (amount > 500000) {
                    return 'Amount cannot exceed ₹5,00,000';
                  }
                  
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // Claim Type
              _buildLabel('Claim Type'),
              const SizedBox(height: 6),
              _buildClaimTypeDropdown(),
              
              const SizedBox(height: 12),
              
              // Date of Admission
              _buildLabel('Date of Admission'),
              const SizedBox(height: 6),
              _buildDatePicker(
                context: context,
                isDarkMode: isDarkMode,
                selectedDate: admissionDate,
                dateType: 'admission',
                placeholder: 'Select admission date',
              ),
              
              const SizedBox(height: 12),
              
              // Date of Discharge
              _buildLabel('Date of Discharge (Optional)'),
              const SizedBox(height: 6),
              _buildDatePicker(
                context: context,
                isDarkMode: isDarkMode,
                selectedDate: dischargeDate,
                dateType: 'discharge',
                placeholder: 'Select discharge date',
              ),
              
              const SizedBox(height: 12),
              
              // Description
              _buildLabel('Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Describe the incident/treatment in detail',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Hospital Details
              _buildSectionTitle('Hospital Details'),
              const SizedBox(height: 12),
              
              // State and City in same row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('State'),
                        const SizedBox(height: 6),
                        _buildStateDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('City'),
                        const SizedBox(height: 6),
                        _buildCityDropdown(),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              _buildLabel('Hospital/Clinic Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: hospitalNameController,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter hospital name',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.local_hospital,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hospital name';
                  }
                  if (value.length < 2) {
                    return 'Hospital name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildLabel('Hospital Pin Code'),
              const SizedBox(height: 6),
              TextFormField(
                controller: hospitalPinCodeController,
                keyboardType: TextInputType.number,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter pin code',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pin code';
                  }
                  if (value.length != 6) {
                    return 'Pin code must be 6 digits';
                  }
                 
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildLabel('Hospital Address'),
              const SizedBox(height: 6),
              TextFormField(
                controller: hospitalAddressController,
                maxLines: 3,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter complete hospital address',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hospital address';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildLabel('Hospital Mobile Number'),
              const SizedBox(height: 6),
              TextFormField(
                controller: hospitalMobileController,
                keyboardType: TextInputType.phone,
                cursorColor: AppConstants.primaryColor,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? AppConstants.boxBlackColor
                      : AppConstants.whiteColor,
                  hintText: 'Enter hospital mobile number',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
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
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.5),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: AppConstants.primaryColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hospital mobile number';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Mobile number must contain only numbers';
                  }
                  if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildLabel('Hospital Email (Optional)'),
              const SizedBox(height: 6),
              _buildCustomTextField(
                controller: hospitalEmailController,
                hintText: 'Enter hospital email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                isDarkMode: isDarkMode,
              ),
              
              const SizedBox(height: 12),
              
              _buildLabel('Doctor Name (Optional)'),
              const SizedBox(height: 6),
              _buildCustomTextField(
                controller: doctorNameController,
                hintText: 'Enter doctor name',
                prefixIcon: Icons.person,
                isDarkMode: isDarkMode,
              ),
              
              const SizedBox(height: 20),
              
              // Required Documents Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    width: 1,
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
                        Expanded(
                          child: AppText(
                            text: 'Required Documents for Insurance Claim Process',
                            size: 16,
                            weight: FontWeight.bold,
                            textColor: AppConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      text: 'To ensure smooth processing of your health insurance claim, please gather all the following documents:',
                      size: 14,
                      weight: FontWeight.normal,
                      textColor: isDarkMode
                          ? AppConstants.whiteColor
                          : AppConstants.blackColor,
                    ),
                    const SizedBox(height: 12),
                    ..._buildDocumentList(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppConstants.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info,
                            color: AppConstants.primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppText(
                              text: 'Important: Please combine all the above documents into a single PDF file before uploading. This helps in faster processing and reduces the chance of missing documents.',
                              size: 13,
                              weight: FontWeight.w500,
                              textColor: AppConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
             
              
        
              
              // Document Upload Section
              _buildSectionTitle('Upload Documents'),
              const SizedBox(height: 12),
              
              // Document Upload Button
              InkWell(
                onTap: _pickPDFFile,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.boxBlackColor
                        : AppConstants.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : AppConstants.primaryColor.withOpacity(0.3),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 24,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Upload Claim Documents',
                              size: 16,
                              weight: FontWeight.w600,
                              textColor: AppConstants.primaryColor,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              text: uploadedDocuments.isNotEmpty 
                                  ? 'Selected: ${uploadedDocuments.first}'
                                  : 'PDF files only, max 2MB',
                              size: 12,
                              weight: FontWeight.normal,
                              textColor: uploadedDocuments.isNotEmpty 
                                  ? AppConstants.primaryColor
                                  : AppConstants.greyColor,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppConstants.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Display uploaded file with green tick mark
              if (uploadedDocuments.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.boxBlackColor
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          text: uploadedDocuments.first,
                          size: 12,
                          weight: FontWeight.normal,
                          textColor: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        ),
                      ),
                      if (uploadedFilesWithSize.containsKey(uploadedDocuments.first))
                        AppText(
                          text: _formatFileSize(uploadedFilesWithSize[uploadedDocuments.first]!),
                          size: 10,
                          weight: FontWeight.normal,
                          textColor: AppConstants.greyColor,
                        ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Submit Button
              CustomButton(
                text: 'Submit Claim',
                onPressed: _submitClaim,
                color: AppConstants.primaryColor,
                textColor: AppConstants.whiteColor,
                height: 55,
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppText(
      text: title,
      size: 18,
      weight: FontWeight.bold,
      textColor: isDarkMode
          ? AppConstants.whiteColor
          : AppConstants.blackColor,
    );
  }

  Widget _buildLabel(String label) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppText(
      text: label,
      size: 14,
      weight: FontWeight.w600,
      textColor: isDarkMode
          ? AppConstants.whiteColor
          : AppConstants.blackColor,
    );
  }

  List<Widget> _buildDocumentList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final documents = [
      'Medical reports and discharge summary',
      'Prescriptions and medication bills',
      'Hospital bills and receipts',
      'Doctor\'s consultation reports',
      'Lab test results and diagnostic reports',
      'X-ray/MRI/CT scan reports',
      'Insurance claim form (if provided separately)',
      'Any other medical certificates or reports',
    ];

    return documents.map((doc) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: AppText(
              text: doc,
              size: 14,
              weight: FontWeight.normal,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required bool isDarkMode,
    required DateTime? selectedDate,
    required String dateType,
    required String placeholder,
  }) {
    return InkWell(
      onTap: () => _selectDate(context, dateType),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppConstants.primaryColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppConstants.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 16),
            AppText(
              text: selectedDate != null
                  ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                  : placeholder,
              size: 16,
              weight: FontWeight.normal,
              textColor: selectedDate != null
                  ? (isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor)
                  : AppConstants.greyColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool isDarkMode = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: AppConstants.primaryColor,
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode
            ? AppConstants.whiteColor
            : AppConstants.blackColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        hintText: hintText,
        hintStyle: TextStyle(color: AppConstants.greyColor),
         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppConstants.primaryColor.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppConstants.primaryColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: AppConstants.primaryColor,
          size: 20,
        ),
      ),
    );
  }
}
