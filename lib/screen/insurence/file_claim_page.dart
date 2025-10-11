import 'dart:io';
import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/hospital_provider.dart';
import 'package:norkacare_app/provider/claim_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
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
  
  // Hospital Location Fields - Vidal API
  String selectedStateId = '';
  String selectedStateName = '';
  String selectedCityId = '';
  String selectedCityName = '';
  Map<String, dynamic>? selectedHospital;
  
  // Selected values
  DateTime? selectedDate;
  DateTime? admissionDate;
  DateTime? dischargeDate;
  String? selectedPatient;
  String? selectedClaimType;
  String? selectedMainHospitalizationClaim;
  String? selectedAccountType;
  
  // Claim logic state
  bool isFirstTimeClaim = true; // Will be determined by API
  List<Map<String, dynamic>> existingClaims = []; // Will be populated from API
  
  List<String> uploadedDocuments = [];
  String uploadedBankDocument = '';
  Map<String, int> uploadedFilesWithSize = {}; // Track file sizes
  PlatformFile? selectedBankFile; // Store the actual bank file
  
  // New state for two-step upload process
  PlatformFile? selectedFile; // Store selected file before upload
  bool isFileUploaded = false; // Track if file is uploaded
  String uploadedFileId = ''; // Store the file ID from upload response

 

  // Get available claim types - Pre Post is always available
  List<String> get availableClaimTypes {
    debugPrint('=== CHECKING AVAILABLE CLAIM TYPES ===');
    debugPrint('Selected Patient: $selectedPatient');
    debugPrint('Total existing claims: ${existingClaims.length}');
    
    // Always show all claim types including Pre Post Hospitalization
    // The main hospitalization dropdown will be empty if patient has no claims
    debugPrint('Showing all claim types including Pre Post Hospitalization');
    return ['Hospitalization', 'Daycare', 'Pre Post Hospitalization'];
  }


  // Helper methods to check claim status
  bool get hasAnyClaims => existingClaims.isNotEmpty;
  
  bool get hasHospitalizationClaims => existingClaims.any((claim) => 
    claim['claimType'] == 'Hospitalization' || 
    claim['type'] == 'Hospitalization' ||
    claim['claim_type'] == 'Hospitalization'
  );
  
  bool get hasDaycareClaims => existingClaims.any((claim) => 
    claim['claimType'] == 'Daycare' || 
    claim['type'] == 'Daycare' ||
    claim['claim_type'] == 'Daycare'
  );

  // Get main hospitalization claims from existing claims for selected patient
  List<Map<String, dynamic>> get mainHospitalizationClaims {
    debugPrint('=== MAIN HOSPITALIZATION CLAIMS FOR SELECTED PATIENT ===');
    debugPrint('Selected Patient: $selectedPatient');
    debugPrint('Total existing claims: ${existingClaims.length}');
    
    // If no patient selected, return empty list
    if (selectedPatient == null || selectedPatient!.isEmpty) {
      debugPrint('No patient selected - returning empty list');
      return [];
    }
    
    // Filter claims for the selected patient
    List<Map<String, dynamic>> patientClaims = existingClaims.where((claim) {
      String claimantName = claim['claimantName'] ?? claim['name'] ?? '';
      String claimNumber = (claim['claimNumber'] ?? claim['claimId'] ?? '').toString();
      
      // Check if claim number is valid and claimant name matches
      bool hasValidClaimNumber = claimNumber.isNotEmpty && claimNumber != 'null' && claimNumber != 'N/A';
      bool nameMatches = claimantName.toLowerCase().contains(selectedPatient!.toLowerCase()) ||
                         selectedPatient!.toLowerCase().contains(claimantName.toLowerCase());
      
      return hasValidClaimNumber && nameMatches;
    }).toList();
    
    debugPrint('Patient claims found: ${patientClaims.length}');
    
    // Format claims for display
    List<Map<String, dynamic>> claims = patientClaims
        .map((claim) {
          // Try different possible field names for claim number and description
          String claimNumber = claim['claimNumber'] ?? claim['claimId'] ?? claim['id'] ?? 'N/A';
          String claimantName = claim['claimantName'] ?? claim['name'] ?? '';
          String hospitalName = claim['hospName'] ?? claim['hospitalName'] ?? '';
          String claimDate = claim['doa'] ?? claim['receivedDate'] ?? '';
          
          // Build a descriptive display text
          String description = '$claimantName - $hospitalName';
          if (claimDate.isNotEmpty) {
            description += ' ($claimDate)';
          }
          
          return {
            'id': claimNumber,
            'description': description,
            'displayText': '$claimNumber - $description',
          };
        })
        .toList();
    
    debugPrint('Claims formatted: ${claims.length}');
    for (var claim in claims) {
      debugPrint('Claim: ${claim['displayText']}');
    }
    debugPrint('=== END MAIN HOSPITALIZATION CLAIMS ===');
    
    return claims;
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStatesData();
      _checkClaimHistory();
    });
  }

  void _loadStatesData() async {
    final hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
    // Only load states if not already loaded
    if (hospitalProvider.statesDetails.isEmpty) {
      await hospitalProvider.getStatesDetails();
    }
  }

  void _checkClaimHistory() async {
    final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);

    // Get NORKA ID
    String norkaId = norkaProvider.norkaId;
    if (norkaId.isEmpty) return;

    try {
      debugPrint('=== Checking claim history for NORKA ID: $norkaId ===');
      
      // Fetch existing claims
      final result = await claimProvider.fetchClaimDependentInfo(norkaId: norkaId);
      
      if (result['success']) {
        setState(() {
          // Properly cast the claims list to List<Map<String, dynamic>>
          List<dynamic> rawClaims = result['claims'] ?? [];
          existingClaims = rawClaims.map((claim) => claim as Map<String, dynamic>).toList();
          
          // Determine if user has already claimed
          bool hasAnyClaims = existingClaims.isNotEmpty;
          bool hasHospitalizationClaims = existingClaims.any((claim) => 
            claim['claimType'] == 'Hospitalization' || 
            claim['type'] == 'Hospitalization' ||
            claim['claim_type'] == 'Hospitalization'
          );
          
          debugPrint('=== CLAIM HISTORY ANALYSIS ===');
          debugPrint('Total Claims Found: ${existingClaims.length}');
          debugPrint('Has Any Claims: $hasAnyClaims');
          debugPrint('Has Hospitalization Claims: $hasHospitalizationClaims');
          
          // Log each claim for debugging
          for (int i = 0; i < existingClaims.length; i++) {
            var claim = existingClaims[i];
            debugPrint('Claim $i: ${claim.toString()}');
          }
          
          debugPrint('Available Claim Types: $availableClaimTypes');
          debugPrint('Main Hospitalization Claims: ${mainHospitalizationClaims.length}');
          debugPrint('=== END CLAIM HISTORY ANALYSIS ===');
        });
      } else {
        debugPrint('❌ Failed to fetch claim history: ${result['error']}');
        // Default to no claims if API fails
        setState(() {
          existingClaims = [];
        });
      }
    } catch (e) {
      debugPrint('❌ Exception checking claim history: $e');
      // Default to no claims if exception occurs
      setState(() {
        existingClaims = [];
      });
    }
  }

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
            // lastDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Allow future dates up to 1 year
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
              // Reset claim type and main hospitalization claim when patient changes
              selectedClaimType = null;
              selectedMainHospitalizationClaim = null;
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
    final hospitalProvider = Provider.of<HospitalProvider>(context);
    
    // Get states from hospital provider
    List<Map<String, dynamic>> states = [];
    if (hospitalProvider.statesDetails['data'] != null) {
      states = List<Map<String, dynamic>>.from(hospitalProvider.statesDetails['data']);
    }
    
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
          value: selectedStateName.isEmpty ? null : selectedStateName,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
              value: state['STATE_NAME'],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: state['STATE_NAME'] ?? '',
                  size: 16,
                  weight: FontWeight.normal,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              final selectedState = states.firstWhere((s) => s['STATE_NAME'] == newValue);
            setState(() {
                selectedStateName = newValue;
                selectedStateId = selectedState['STATE_TYPE_ID'] ?? '';
                selectedCityName = '';
                selectedCityId = '';
                selectedHospital = null; // Reset hospital when state changes
              });
              
              // Fetch cities for selected state
              if (selectedStateId.isNotEmpty) {
                await hospitalProvider.getCitiesDetails(selectedStateId);
              }
            }
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
    final hospitalProvider = Provider.of<HospitalProvider>(context);
    
    // Get cities from hospital provider
    List<Map<String, dynamic>> cities = [];
    if (hospitalProvider.citiesDetails['data'] != null && selectedStateId.isNotEmpty) {
      cities = List<Map<String, dynamic>>.from(hospitalProvider.citiesDetails['data']);
    }
    
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
          value: selectedCityName.isEmpty ? null : selectedCityName,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            size: 20,
          ),
          hint: AppText(
            text: selectedStateId.isEmpty ? 'Select state first' : 'Select city',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          items: cities.map<DropdownMenuItem<String>>((city) {
            return DropdownMenuItem<String>(
              value: city['CITY_DESCRIPTION'],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: city['CITY_DESCRIPTION'] ?? '',
                  size: 16,
                  weight: FontWeight.normal,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
            );
          }).toList(),
          onChanged: selectedStateId.isEmpty ? null : (String? newValue) {
            if (newValue != null) {
              final selectedCity = cities.firstWhere((c) => c['CITY_DESCRIPTION'] == newValue);
            setState(() {
                selectedCityName = newValue;
                selectedCityId = selectedCity['CITY_TYPE_ID'] ?? '';
                selectedHospital = null; // Reset hospital when city changes
              });
            }
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
            // Add claim types (dynamic based on claim history)
            ...availableClaimTypes.map<DropdownMenuItem<String>>((claimType) {
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
              // Reset main hospitalization claim when claim type changes
              if (newValue != 'Pre Post Hospitalization') {
                selectedMainHospitalizationClaim = null;
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

  Widget _buildMainHospitalizationClaimDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 56, // Increased height to accommodate longer text
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
          value: selectedMainHospitalizationClaim,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            size: 20,
          ),
          hint: AppText(
            text: 'Select main hospitalization claim',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          items: [
            // Add placeholder option
            DropdownMenuItem<String>(
              value: null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: AppText(
                  text: mainHospitalizationClaims.isEmpty 
                      ? 'No previous hospitalization claims'
                      : 'Select main hospitalization claim',
                  size: 15,
                  weight: FontWeight.normal,
                  textColor: AppConstants.greyColor,
                ),
              ),
            ),
            // Add main hospitalization claims (only if they exist)
            if (mainHospitalizationClaims.isNotEmpty)
              ...mainHospitalizationClaims.map<DropdownMenuItem<String>>((claim) {
                return DropdownMenuItem<String>(
                  value: claim['displayText'],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      claim['displayText']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: isDarkMode
                            ? AppConstants.whiteColor
                            : AppConstants.blackColor,
                      ),
                      maxLines: 2, // Allow text to wrap to 2 lines
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
          ],
          onChanged: (String? newValue) {
            setState(() {
              selectedMainHospitalizationClaim = newValue;
            });
          },
          dropdownColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          style: TextStyle(
            color: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedAccountType,
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
            text: 'Select account type',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          items: ['Savings', 'Current'].map<DropdownMenuItem<String>>((String accountType) {
            return DropdownMenuItem<String>(
              value: accountType,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  text: accountType,
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
              selectedAccountType = newValue;
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
      
      // Validate main hospitalization claim for Pre Post Hospitalization
      if (selectedClaimType == 'Pre Post Hospitalization') {
        // Check if there are any hospitalization claims available
        if (mainHospitalizationClaims.isEmpty) {
          ToastMessage.failedToast('No previous hospitalization claims found. You cannot file Pre Post Hospitalization claim without a previous hospitalization claim.');
          return;
        }
        
        if (selectedMainHospitalizationClaim == null || selectedMainHospitalizationClaim!.isEmpty) {
          ToastMessage.failedToast('Please select a main hospitalization claim');
          return;
        }
      }
      
      // Validate claim amount
      final claimAmount = double.tryParse(claimAmountController.text);
      if (claimAmount == null || claimAmount <= 0) {
        ToastMessage.failedToast('Please enter a valid claim amount');
        return;
      }
      
      if (claimAmount > 500000) {
        ToastMessage.failedToast('Claim amount cannot exceed ₹5,00,000');
        return;
      }
      
      // Validate account numbers match
      if (accountNumberController.text != reEnterAccountNumberController.text) {
        ToastMessage.failedToast('Account numbers do not match');
        return;
      }
      
      // Validate account type
      if (selectedAccountType == null || selectedAccountType!.isEmpty) {
        ToastMessage.failedToast('Please select account type');
        return;
      }
      
      // Validate discharge date
      if (dischargeDate == null) {
        ToastMessage.failedToast('Please select discharge date');
        return;
      }
      
      // Validate state and city selection
      if (selectedStateId.isEmpty) {
        ToastMessage.failedToast('Please select a state');
        return;
      }
      
      if (selectedCityId.isEmpty) {
        ToastMessage.failedToast('Please select a city');
        return;
      }
      
      if (admissionDate == null) {
        ToastMessage.failedToast('Please select admission date');
        return;
      }
      
      // if (uploadedBankDocument.isEmpty) {
      //   ToastMessage.failedToast('Please upload bank document');
      //   return;
      // }
      
      // Check if file is selected but not uploaded
      if (selectedFile != null && !isFileUploaded) {
        ToastMessage.failedToast('Please Upload Document');
        return;
      }
      
      // Check if no document is uploaded
      if (!isFileUploaded || uploadedDocuments.isEmpty) {
        ToastMessage.failedToast('Please Select Document');
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 1),
              AppText(
                text: 'Confirm Claim Submission ?',
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
                
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,  // Prevent dismiss by tapping outside
                  builder: (BuildContext context) {
                    return PopScope(
                      canPop: false,  // Prevent back button dismiss
                      child: AlertDialog(
                        backgroundColor: isDarkMode
                            ? AppConstants.boxBlackColor
                            : AppConstants.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppConstants.primaryColor,
                                ),
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 24),
                              AppText(
                                text: 'Claim is processing...',
                                size: 16,
                                weight: FontWeight.w600,
                                textColor: isDarkMode
                                    ? AppConstants.whiteColor
                                    : AppConstants.blackColor,
                              ),
                              const SizedBox(height: 8),
                              AppText(
                                text: 'Please wait',
                                size: 14,
                                weight: FontWeight.normal,
                                textColor: AppConstants.greyColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                
                _submitClaimToAPI(); // Submit claim to API
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
                text: 'Your claim has been submitted and is under review.',
                size: 14,
                weight: FontWeight.normal,
                textColor: AppConstants.greyColor,
                textAlign: TextAlign.center,
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

  // Submit claim to API
  Future<void> _submitClaimToAPI() async {
    final claimProvider = Provider.of<ClaimProvider>(context, listen: false);

    try {
      debugPrint('=== SUBMITTING CLAIM TO API ===');
      debugPrint('Claim Type: $selectedClaimType');
      debugPrint('Selected Patient: $selectedPatient');
      debugPrint('Claim Amount: ${claimAmountController.text}');

      // Get enrollment number for selected patient
      String enrollmentNumber = _getEnrollmentNumberForPatient(selectedPatient!);
      debugPrint('Enrollment Number: $enrollmentNumber');

      // Use the already uploaded file ID (don't call upload API again)
      String fileId = uploadedFileId;
      debugPrint('Using uploaded File ID: $fileId');

      // Build request body based on claim type
      Map<String, dynamic> requestBody;
      
      if (selectedClaimType == 'Pre Post Hospitalization') {
        // Pre Post Hospitalization body
        String mainClaimId = _getMainClaimIdFromSelection();
        requestBody = {
          "policyNo": "760100/NORKA ROOTS/BASE",
          "dependentUniqueId": enrollmentNumber,
          "typeOfClaim": "Pre-post hospitalization",
          "claimSubType": "Hospitalization",
          "requestedAmount": claimAmountController.text,
          "ailmentType": "Non covid",
          "admissionDate": _formatDateForAPI(admissionDate!),
          "dischargeDate": dischargeDate != null ? _formatDateForAPI(dischargeDate!) : _formatDateForAPI(admissionDate!),
          "hospitalName": hospitalNameController.text,
          "empanelmentNo": selectedHospital?['emplNo'] ?? '',
          "documentType": "Claim",
          "ailmentName": descriptionController.text,
          "hospitalAddress": hospitalAddressController.text,
          "hospitalState": selectedStateName,
          "hospitalCity": selectedCityName,
          "hospitalPinCode": hospitalPinCodeController.text,
          "hospitalPhoneNo": hospitalMobileController.text,
          "bankDetails": {
            "accountHolderName": accountHolderNameController.text,
            "accountType": selectedAccountType ?? "",
            "accountNo": accountNumberController.text,
            "ifscCode": ifscCodeController.text
          },
          "fileId": fileId,
          "mainClaimNo": mainClaimId
        };
      } else {
        // Hospitalization or Daycare body
        String typeOfClaim = selectedClaimType == 'Hospitalization' 
            ? 'Main hospitalization claim' 
            : 'Main daycare claim';
        
        debugPrint('=== HOSPITALIZATION/DAYCARE CLAIM ===');
        debugPrint('Selected Claim Type: $selectedClaimType');
        debugPrint('Type of Claim: $typeOfClaim');
            
        requestBody = {
          "policyNo": "760100/NORKA ROOTS/BASE",
          "dependentUniqueId": enrollmentNumber,
          "typeOfClaim": typeOfClaim,
          "claimSubType": "Hospitalization",  // Always "Hospitalization" for both Hospitalization and Daycare
          "requestedAmount": claimAmountController.text,
          "ailmentType": "Non covid",
          "admissionDate": _formatDateForAPI(admissionDate!),
          "dischargeDate": dischargeDate != null ? _formatDateForAPI(dischargeDate!) : _formatDateForAPI(admissionDate!),
          "hospitalName": hospitalNameController.text,
          "empanelmentNo": selectedHospital?['emplNo'] ?? '',
          "documentType": "Claim",
          "ailmentName": descriptionController.text,
          "hospitalAddress": hospitalAddressController.text,
          "hospitalState": selectedStateName,
          "hospitalCity": selectedCityName,
          "hospitalPinCode": hospitalPinCodeController.text,
          "hospitalPhoneNo": hospitalMobileController.text,
          "bankDetails": {
            "accountHolderName": accountHolderNameController.text,
            "accountType": selectedAccountType ?? "",
            "accountNo": accountNumberController.text,
            "ifscCode": ifscCodeController.text
          },
          "fileId": fileId
        };
      }

      debugPrint('=== CLAIM SUBMISSION REQUEST BODY ===');
      debugPrint('Request Body: $requestBody');

      // Call the submit claim API
      final result = await claimProvider.submitClaim(requestBody);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (result['success']) {
        debugPrint('✅ Claim submitted successfully');
        _showSuccessDialog();
      } else {
        debugPrint('❌ Claim submission failed: ${result['error']}');
        ToastMessage.failedToast('Failed to submit claim');
      }

    } catch (e) {
      debugPrint('❌ Exception during claim submission: $e');
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      ToastMessage.failedToast('Failed to submit claim. Please try again.');
    }
  }

  // Get enrollment number for selected patient from claims data
  String _getEnrollmentNumberForPatient(String patientName) {
    final claimProvider = Provider.of<ClaimProvider>(context, listen: false);
    final dependents = claimProvider.dependents;
    
    debugPrint('=== GETTING ENROLLMENT NUMBER FOR PATIENT ===');
    debugPrint('Patient Name: $patientName');
    debugPrint('Available Dependents: ${dependents.length}');
    
    // Find the matching dependent based on patient name
    for (var dependent in dependents) {
      String dependentName = dependent['name'] ?? '';
      String relationship = dependent['relationship'] ?? '';
      String dependentUniqueId = dependent['dependentUniqueId'] ?? '';
      
      debugPrint('Checking dependent: $dependentName, relationship: $relationship, ID: $dependentUniqueId');
      
      // Match by relationship for Self
      if (patientName.contains('Self') || patientName == 'Self') {
        if (relationship.toLowerCase() == 'self') {
          debugPrint('✅ Found Self enrollment: $dependentUniqueId');
          return dependentUniqueId;
        }
      }
      // Match by relationship for Spouse
      else if (patientName.contains('Spouse') || patientName == 'Spouse') {
        if (relationship.toLowerCase() == 'spouse') {
          debugPrint('✅ Found Spouse enrollment: $dependentUniqueId');
          return dependentUniqueId;
        }
      }
      // Match by relationship for Child
      else if (patientName.contains('Child')) {
        if (relationship.toLowerCase().contains('child')) {
          debugPrint('✅ Found Child enrollment: $dependentUniqueId');
          return dependentUniqueId;
        }
      }
      // Direct name match as fallback
      else if (patientName.toLowerCase().contains(dependentName.toLowerCase())) {
        debugPrint('✅ Found name match enrollment: $dependentUniqueId');
        return dependentUniqueId;
      }
    }
    
    // If no match found, return the first available dependent (usually Self)
    if (dependents.isNotEmpty) {
      String fallbackId = dependents.first['dependentUniqueId'] ?? 'EN000000186';
      debugPrint('⚠️ No specific match found, using first dependent: $fallbackId');
      return fallbackId;
    }
    
    debugPrint('❌ No dependents found, using default');
    return 'EN000000186';
  }

  // Get main claim ID from selected main hospitalization claim
  String _getMainClaimIdFromSelection() {
    if (selectedMainHospitalizationClaim == null) return '';
    
    // Extract claim ID from the display text (format: "CLM2024001 - Hospitalization for appendicitis")
    final parts = selectedMainHospitalizationClaim!.split(' - ');
    return parts.isNotEmpty ? parts[0] : '';
  }

  // Format date for API (DD-MM-YYYY format)
  String _formatDateForAPI(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  // void _showSavedBankAccounts() {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //   
  //   // Sample saved bank accounts (in real app, fetch from database/API)
  //   final List<Map<String, String>> savedAccounts = [
  //     {
  //       'name': 'John Doe - SBI',
  //       'accountNumber': '****5678',
  //       'bank': 'State Bank of India',
  //       'ifsc': 'SBIN0001234',
  //     },
  //     {
  //       'name': 'John Doe - HDFC',
  //       'accountNumber': '****9012',
  //       'bank': 'HDFC Bank',
  //       'ifsc': 'HDFC0002345',
  //     },
  //   ];
  //   
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: isDarkMode
  //               ? AppConstants.boxBlackColor
  //               : AppConstants.whiteColor,
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(20),
  //             topRight: Radius.circular(20),
  //           ),
  //         ),
  //         child: SafeArea(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 margin: const EdgeInsets.only(top: 12),
  //                 width: 40,
  //                 height: 4,
  //                 decoration: BoxDecoration(
  //                   color: AppConstants.greyColor.withOpacity(0.3),
  //                   borderRadius: BorderRadius.circular(2),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(20),
  //                 child: AppText(
  //                   text: 'Select Saved Account',
  //                   size: 18,
  //                   weight: FontWeight.bold,
  //                   textColor: isDarkMode
  //                       ? AppConstants.whiteColor
  //                       : AppConstants.blackColor,
  //                 ),
  //               ),
  //               Flexible(
  //                 child: savedAccounts.isEmpty
  //                     ? Padding(
  //                         padding: const EdgeInsets.all(40),
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Icon(
  //                               Icons.account_balance_outlined,
  //                               size: 60,
  //                               color: AppConstants.greyColor.withOpacity(0.5),
  //                             ),
  //                             const SizedBox(height: 12),
  //                             AppText(
  //                               text: 'No saved bank accounts',
  //                               size: 16,
  //                               weight: FontWeight.w500,
  //                               textColor: AppConstants.greyColor,
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : ListView.builder(
  //                         shrinkWrap: true,
  //                         physics: const BouncingScrollPhysics(),
  //                         itemCount: savedAccounts.length,
  //                         itemBuilder: (context, index) {
  //                           final account = savedAccounts[index];
  //                           
  //                           return Container(
  //                             margin: const EdgeInsets.symmetric(
  //                               horizontal: 16,
  //                               vertical: 8,
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: isDarkMode
  //                                   ? AppConstants.darkBackgroundColor
  //                                   : AppConstants.whiteBackgroundColor,
  //                               borderRadius: BorderRadius.circular(12),
  //                               border: Border.all(
  //                                 color: isDarkMode
  //                                     ? Colors.white.withOpacity(0.1)
  //                                     : Colors.grey.withOpacity(0.2),
  //                               ),
  //                             ),
  //                             child: ListTile(
  //                               contentPadding: const EdgeInsets.all(12),
  //                               leading: Container(
  //                                 padding: const EdgeInsets.all(10),
  //                                 decoration: BoxDecoration(
  //                                   color: AppConstants.primaryColor
  //                                       .withOpacity(0.1),
  //                                   borderRadius: BorderRadius.circular(8),
  //                                 ),
  //                                 child: Icon(
  //                                   Icons.account_balance,
  //                                   color: AppConstants.primaryColor,
  //                                   size: 24,
  //                                 ),
  //                               ),
  //                               title: AppText(
  //                                 text: account['name']!,
  //                                 size: 16,
  //                                 weight: FontWeight.w600,
  //                                 textColor: isDarkMode
  //                                     ? AppConstants.whiteColor
  //                                     : AppConstants.blackColor,
  //                               ),
  //                               subtitle: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   const SizedBox(height: 4),
  //                                   AppText(
  //                                     text: '${account['bank']} - ${account['accountNumber']}',
  //                                     size: 13,
  //                                     weight: FontWeight.normal,
  //                                     textColor: AppConstants.greyColor,
  //                                   ),
  //                                   AppText(
  //                                     text: 'IFSC: ${account['ifsc']}',
  //                                     size: 12,
  //                                     weight: FontWeight.normal,
  //                                     textColor: AppConstants.greyColor,
  //                                   ),
  //                                 ],
  //                               ),
  //                               trailing: Icon(
  //                                 Icons.arrow_forward_ios,
  //                                 size: 16,
  //                                 color: AppConstants.greyColor,
  //                               ),
  //                               onTap: () {
  //                                 setState(() {
  //                                   accountHolderNameController.text =
  //                                       account['name']!.split(' - ')[0];
  //                                   accountNumberController.text =
  //                                       account['accountNumber']!;
  //                                   reEnterAccountNumberController.text =
  //                                       account['accountNumber']!;
  //                                   bankNameController.text = account['bank']!;
  //                                   ifscCodeController.text = account['ifsc']!;
  //                                 });
  //                                 Navigator.pop(context);
  //                                 ToastMessage.successToast(
  //                                   'Bank account details filled',
  //                                 );
  //                               },
  //                             ),
  //                           );
  //                         },
  //                       ),
  //               ),
  //               const SizedBox(height: 20),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showHospitalSelectionDialog() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hospitalProvider = Provider.of<HospitalProvider>(context, listen: false);
    
    // Fetch hospitals for selected state and city
    final requestData = {
      'stateId': selectedStateId,
      'cityID': selectedCityId,
    };
    
    // Show loading dialog while fetching
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      ),
    );
    
    try {
      await hospitalProvider.getHospitals(requestData);
      Navigator.pop(context); // Close loading dialog
      
      // Get hospitals from response
      List<Map<String, dynamic>> hospitals = [];
      if (hospitalProvider.hospitalResponse != null &&
          hospitalProvider.hospitalResponse!['data'] != null) {
        hospitals = List<Map<String, dynamic>>.from(
          hospitalProvider.hospitalResponse!['data'],
        );
      }
      
      if (hospitals.isEmpty) {
        ToastMessage.failedToast('No hospitals found in this area');
        return;
      }
      
      // Show hospital selection dialog with search
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return _HospitalSelectionSheet(
            hospitals: hospitals,
            isDarkMode: isDarkMode,
            selectedCityName: selectedCityName,
            selectedStateName: selectedStateName,
            onHospitalSelected: (hospital) {
              setState(() {
                selectedHospital = hospital;
                // Auto-fill hospital details
                hospitalNameController.text = hospital['hospitalName'] ?? '';
                hospitalPinCodeController.text = hospital['pincode']?.toString() ?? '';
                hospitalAddressController.text = hospital['address1'] ?? '';
                hospitalMobileController.text = hospital['phHosp1'] ?? '';
                hospitalEmailController.text = hospital['hospEmailID'] ?? '';
              });
              Navigator.pop(context);
              // ToastMessage.successToast('Hospital selected successfully');
            },
          );
        },
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ToastMessage.failedToast('Failed to load hospitals. Please try again.');
    }
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

  // Step 1: Select file (not uploaded yet)
  Future<void> _pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg'],
        allowMultiple: false, // Restrict to single file selection only
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
        if (extension != 'pdf' && extension != 'jpg' && extension != 'jpeg') {
          ToastMessage.failedToast(
            'Please select a PDF, JPG, or JPEG file only'
          );
          return;
        }

        // Store selected file (not uploaded yet)
        setState(() {
          selectedFile = file;
          isFileUploaded = false;
        });

        // ToastMessage.successToast(
        //   'File selected: ${file.name}'
        // );
      }
    } catch (e) {
      ToastMessage.failedToast(
        'Failed to pick file: ${e.toString()}'
      );
    }
  }

  // Step 2: Upload/Confirm the selected file with API call
  Future<void> _uploadSelectedFile() async {
    if (selectedFile == null) return;

    final claimProvider = Provider.of<ClaimProvider>(context, listen: false);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.boxBlackColor
                  : AppConstants.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                AppText(
                  text: 'Uploading document...',
                  size: 16,
                  weight: FontWeight.w500,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      debugPrint('=== Starting document upload ===');
      debugPrint('File: ${selectedFile!.name}');
      debugPrint('Size: ${selectedFile!.size} bytes');

      // Call the API to upload the document
      final result = await claimProvider.uploadClaimDocument(
        file: selectedFile!,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (result['success']) {
        debugPrint('✅ Document uploaded successfully');
        debugPrint('File ID: ${result['fileId']}');

        setState(() {
          uploadedDocuments.clear();
          uploadedFilesWithSize.clear();
          uploadedDocuments.add(selectedFile!.name);
          uploadedFilesWithSize[selectedFile!.name] = selectedFile!.size;
          isFileUploaded = true;
          uploadedFileId = result['fileId'] ?? ''; // Store the file ID
        });

        // ToastMessage.successToast(
        //   'Document uploaded successfully (${_formatFileSize(selectedFile!.size)})'
        // );
      } else {
        debugPrint('❌ Upload failed: ${result['error']}');

        ToastMessage.failedToast(
          result['error'] ?? 'Failed to upload document. Please try again.'
        );

        // Reset file upload state on failure
        setState(() {
          isFileUploaded = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Exception during upload: $e');

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      ToastMessage.failedToast(
        'Failed to upload document. Please try again.'
      );

      // Reset file upload state on error
      setState(() {
        isFileUploaded = false;
      });
    }
  }

  // Real bank document upload using file picker
  // Future<void> _uploadBankDocument() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //       allowMultiple: false,
  //     );
  //
  //     if (result != null && result.files.isNotEmpty) {
  //       PlatformFile file = result.files.first;
  //       
  //       // Validate file size (2MB limit)
  //       if (!_validateFileSize(file.size)) {
  //         ToastMessage.failedToast(
  //           'File size (${_formatFileSize(file.size)}) exceeds 2MB limit'
  //         );
  //         return;
  //       }
  //
  //       // Validate file extension
  //       String extension = file.extension?.toLowerCase() ?? '';
  //       if (extension != 'pdf') {
  //         ToastMessage.failedToast(
  //           'Please select a PDF file only'
  //         );
  //         return;
  //       }
  //
  //       // Set uploaded bank document
  //       setState(() {
  //         selectedBankFile = file;
  //         uploadedBankDocument = file.name;
  //       });
  //
  //       ToastMessage.successToast(
  //         'Bank document uploaded successfully (${_formatFileSize(file.size)})'
  //       );
  //     }
  //   } catch (e) {
  //     ToastMessage.failedToast(
  //       'Failed to pick file: ${e.toString()}'
  //     );
  //   }
  // }

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
              _buildLabel('Patient Name (Self/Family Member) *'),
              const SizedBox(height: 6),
              _buildPatientDropdown(),
              
              const SizedBox(height: 20),
              
              // Bank Account Details Section
              _buildSectionTitle('Bank Account Details'),
              const SizedBox(height: 12),
              
              // Account Holder Name
              _buildLabel('Account Holder Name *'),
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
              
              // Account Type
              _buildLabel('Account Type *'),
              const SizedBox(height: 6),
              _buildAccountTypeDropdown(),
              
              const SizedBox(height: 12),
              
              // Account Number
              _buildLabel('Account Number *'),
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
                  
                 
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Account number must contain only numbers';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 12),
              
              // Re-enter Account Number
              _buildLabel('Re-enter Account Number *'),
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
              _buildLabel('IFSC Code *'),
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
              _buildLabel('Bank Name *'),
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
              _buildLabel('Branch Name *'),
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
              
              const SizedBox(height: 20),
              
              // Bank Document Upload
              // _buildLabel('Bank Document'),
              // AppText(text: "Cancelled cheque/Passbook/Bank statement", size: 12, weight: FontWeight.w500, textColor: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor),
              // const SizedBox(height: 6),
              // InkWell(
              //   onTap: _uploadBankDocument,
              //   child: Container(
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: isDarkMode
              //           ? AppConstants.boxBlackColor
              //           : AppConstants.whiteColor,
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(
              //         color: isDarkMode
              //             ? Colors.white.withOpacity(0.1)
              //             : AppConstants.primaryColor.withOpacity(0.3),
              //         width: 2,
              //         style: BorderStyle.solid,
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: isDarkMode
              //               ? Colors.black.withOpacity(0.2)
              //               : Colors.grey.withOpacity(0.1),
              //           spreadRadius: 1,
              //           blurRadius: 3,
              //           offset: const Offset(0, 1),
              //         ),
              //       ],
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.account_balance,
              //           size: 24,
              //           color: AppConstants.primaryColor,
              //         ),
              //         const SizedBox(width: 12),
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               AppText(
              //                 text: 'Upload Bank Document',
              //                 size: 16,
              //                 weight: FontWeight.w600,
              //                 textColor: AppConstants.primaryColor,
              //               ),
              //               const SizedBox(height: 2),
              //               Row(
              //                 children: [
              //                   if (uploadedBankDocument.isNotEmpty) ...[
              //                     Icon(
              //                       Icons.check_circle,
              //                       color: Colors.green,
              //                       size: 16,
              //                     ),
              //                     const SizedBox(width: 6),
              //                   ],
              //                   Expanded(
              //                     child: AppText(
              //                       text: uploadedBankDocument.isNotEmpty 
              //                           ? uploadedBankDocument
              //                           : 'PDF files only, max 2MB',
              //                       size: 12,
              //                       weight: FontWeight.normal,
              //                       textColor: uploadedBankDocument.isNotEmpty 
              //                           ? AppConstants.primaryColor
              //                           : AppConstants.greyColor,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //         Icon(
              //           Icons.cloud_upload_outlined,
              //           color: AppConstants.primaryColor,
              //           size: 20,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              
              // const SizedBox(height: 20),
              
              // Save Bank Details Button
              // Row(
              //   children: [
              //     Expanded(
              //       child: OutlinedButton.icon(
              //         onPressed: () {
              //           if (accountHolderNameController.text.isEmpty ||
              //               accountNumberController.text.isEmpty ||
              //               ifscCodeController.text.isEmpty) {
              //             ToastMessage.failedToast(
              //               'Please fill all required bank details',
              //             );
              //             return;
              //           }
              //           ToastMessage.successToast('Bank details saved successfully');
              //         },
              //         icon: Icon(
              //           Icons.save_outlined,
              //           color: AppConstants.primaryColor,
              //           size: 20,
              //         ),
              //         label: AppText(
              //           text: 'Save Bank Details',
              //           size: 14,
              //           weight: FontWeight.w600,
              //           textColor: AppConstants.primaryColor,
              //         ),
              //         style: OutlinedButton.styleFrom(
              //           padding: const EdgeInsets.symmetric(vertical: 10),
              //           side: BorderSide(
              //             color: AppConstants.primaryColor,
              //             width: 1.5,
              //           ),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: OutlinedButton.icon(
              //         onPressed: () {
              //           _showSavedBankAccounts();
              //         },
              //         icon: Icon(
              //           Icons.account_balance,
              //           color: AppConstants.secondaryColor,
              //           size: 20,
              //         ),
              //         label: AppText(
              //           text: 'Use Saved Account',
              //           size: 14,
              //           weight: FontWeight.w600,
              //           textColor: isDarkMode
              //               ? AppConstants.whiteColor
              //               : AppConstants.blackColor,
              //         ),
              //         style: OutlinedButton.styleFrom(
              //           padding: const EdgeInsets.symmetric(vertical: 10),
              //           side: BorderSide(
              //             color: isDarkMode
              //                 ? Colors.white.withOpacity(0.3)
              //                 : AppConstants.greyColor.withOpacity(0.5),
              //             width: 1.5,
              //           ),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              
              // const SizedBox(height: 20),
              
              // Claim Details Section
              _buildSectionTitle('Claim Details'),
              const SizedBox(height: 12),
              
              // Claim Amount
              _buildLabel('Claim Amount (₹) *'),
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
              _buildLabel('Claim Type *'),
              const SizedBox(height: 6),
              _buildClaimTypeDropdown(),
              
              // Show main hospitalization claim dropdown only when "Pre Post Hospitalization" is selected
              if (selectedClaimType == 'Pre Post Hospitalization') ...[
                const SizedBox(height: 12),
                _buildLabel('Select Main Hospitalization Claim *'),
                const SizedBox(height: 6),
                _buildMainHospitalizationClaimDropdown(),
              ],
              
              const SizedBox(height: 12),
              
              // Date of Admission
              _buildLabel('Date of Admission *'),
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
              _buildLabel('Date of Discharge *'),
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
              _buildLabel('Description *'),
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
                        _buildLabel('State *'),
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
                        _buildLabel('City *'),
                        const SizedBox(height: 6),
                        _buildCityDropdown(),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Select Hospital Section
              _buildLabel('Select Hospital'),
              const SizedBox(height: 6),
              InkWell(
                onTap: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
                    ? () => _showHospitalSelectionDialog()
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.boxBlackColor
                        : AppConstants.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
                          ? (isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : AppConstants.primaryColor.withOpacity(0.3))
                          : AppConstants.greyColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        color: selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
                            ? AppConstants.primaryColor
                            : AppConstants.greyColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: selectedHospital != null
                                  ? (selectedHospital!['hospitalName'] ?? 'Hospital Selected')
                                  : 'Select Hospital',
                              size: 16,
                              weight: FontWeight.w600,
                              textColor: selectedHospital != null
                                  ? (isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor)
                                  : (selectedStateId.isNotEmpty && selectedCityId.isNotEmpty
                                      ? AppConstants.primaryColor
                                      : AppConstants.greyColor),
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              text: selectedHospital != null
                                  ? '${selectedHospital!['cityName'] ?? ''}, ${selectedHospital!['stateName'] ?? ''}'
                                  : (selectedStateId.isEmpty || selectedCityId.isEmpty
                                      ? 'Please select state and city first'
                                      : 'Tap to select available hospital'),
                              size: 12,
                              weight: FontWeight.normal,
                              textColor: AppConstants.greyColor,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        selectedHospital != null ? Icons.check_circle : Icons.arrow_forward_ios,
                        color: selectedHospital != null
                            ? AppConstants.greenColor
                            : AppConstants.primaryColor,
                        size: selectedHospital != null ? 24 : 16,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              _buildLabel('Hospital/Clinic Name *'),
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
              
              _buildLabel('Hospital Pin Code *'),
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
              
              _buildLabel('Hospital Address *'),
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
              
              _buildLabel('Hospital Mobile Number *'),
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
                              text: 'Important: Please combine all the above documents into a single file (PDF, JPG, or JPEG) before uploading. This helps in faster processing and reduces the chance of missing documents.',
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
              
              const SizedBox(height: 16),
              
              // Document Upload Section
              _buildSectionTitle('Upload Document *'),
              const SizedBox(height: 10),
              
              // Step 1: Select Document Button
              InkWell(
                onTap: _pickPDFFile,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.boxBlackColor
                        : AppConstants.whiteColor,
                    borderRadius: BorderRadius.circular(10),
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
                        Icons.folder_open,
                        size: 20,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Select Document',
                              size: 15,
                              weight: FontWeight.w600,
                              textColor: AppConstants.primaryColor,
                            ),
                            AppText(
                              text: 'PDF, JPG, or JPEG only, max 2MB',
                              size: 11,
                              weight: FontWeight.normal,
                              textColor: AppConstants.greyColor,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppConstants.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Show selected file preview (before upload)
              if (selectedFile != null && !isFileUploaded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.boxBlackColor
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // File Icon
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.insert_drive_file,
                              color: Colors.blue,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // File Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'Selected File',
                                  size: 12,
                                  weight: FontWeight.w600,
                                  textColor: Colors.blue,
                                ),
                                const SizedBox(height: 2),
                                AppText(
                                  text: selectedFile!.name,
                                  size: 12,
                                  weight: FontWeight.w500,
                                  textColor: isDarkMode
                                      ? AppConstants.whiteColor
                                      : AppConstants.blackColor,
                                ),
                                AppText(
                                  text: 'Size: ${_formatFileSize(selectedFile!.size)}',
                                  size: 10,
                                  weight: FontWeight.normal,
                                  textColor: AppConstants.greyColor,
                                ),
                              ],
                            ),
                          ),
                          // Remove button
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                selectedFile = null;
                                isFileUploaded = false;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: AppConstants.greyColor,
                              size: 18,
                            ),
                            tooltip: 'Remove file',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Step 2: Upload Document Button
                      CustomButton(
                        text: 'Upload Document',
                        onPressed: _uploadSelectedFile,
                        color: AppConstants.primaryColor,
                        textColor: AppConstants.whiteColor,
                        height: 42,
                      ),
                    ],
                  ),
                ),
              ],
              
              // Display uploaded file with green tick mark (after upload)
              if (isFileUploaded && uploadedDocuments.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppConstants.boxBlackColor
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Success Icon
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // File Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Document Uploaded Successfully',
                              size: 13,
                              weight: FontWeight.w600,
                              textColor: Colors.green,
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              text: uploadedDocuments.first,
                              size: 12,
                              weight: FontWeight.w500,
                              textColor: isDarkMode
                                  ? AppConstants.whiteColor
                                  : AppConstants.blackColor,
                            ),
                            if (uploadedFilesWithSize.containsKey(uploadedDocuments.first))
                              AppText(
                                text: 'Size: ${_formatFileSize(uploadedFilesWithSize[uploadedDocuments.first]!)}',
                                size: 10,
                                weight: FontWeight.normal,
                                textColor: AppConstants.greyColor,
                              ),
                          ],
                        ),
                      ),
                      // Remove uploaded document button
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            uploadedDocuments.clear();
                            uploadedFilesWithSize.clear();
                            selectedFile = null;
                            isFileUploaded = false;
                          });
                          // ToastMessage.successToast('Document removed successfully');
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        tooltip: 'Remove document',
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 20),
              
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
    
    // Check if title contains asterisk (*)
    if (title.contains('*')) {
      final parts = title.split('*');
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: parts[0],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
            ),
            TextSpan(
              text: '*',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            if (parts.length > 1 && parts[1].isNotEmpty)
              TextSpan(
                text: parts[1],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
          ],
        ),
      );
    }
    
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
    
    // Check if label contains asterisk (*)
    if (label.contains('*')) {
      final parts = label.split('*');
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: parts[0],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
            ),
            TextSpan(
              text: '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            if (parts.length > 1 && parts[1].isNotEmpty)
              TextSpan(
                text: parts[1],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
              ),
          ],
        ),
      );
    }
    
    // If no asterisk, return normal AppText
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
      'Bank account documents (cancelled cheque/passbook/statement)',
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

// Hospital Selection Sheet with Search
class _HospitalSelectionSheet extends StatefulWidget {
  final List<Map<String, dynamic>> hospitals;
  final bool isDarkMode;
  final String selectedCityName;
  final String selectedStateName;
  final Function(Map<String, dynamic>) onHospitalSelected;

  const _HospitalSelectionSheet({
    required this.hospitals,
    required this.isDarkMode,
    required this.selectedCityName,
    required this.selectedStateName,
    required this.onHospitalSelected,
  });

  @override
  State<_HospitalSelectionSheet> createState() => _HospitalSelectionSheetState();
}

class _HospitalSelectionSheetState extends State<_HospitalSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredHospitals {
    if (_searchQuery.isEmpty) return widget.hospitals;
    
    return widget.hospitals.where((hospital) {
      final hospitalName = hospital['hospitalName']?.toString().toLowerCase() ?? '';
      final address = hospital['address1']?.toString().toLowerCase() ?? '';
      final phone = hospital['phHosp1']?.toString().toLowerCase() ?? '';
      final pincode = hospital['pincode']?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      
      return hospitalName.contains(query) || 
             address.contains(query) || 
             phone.contains(query) ||
             pincode.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppConstants.boxBlackColor
            : AppConstants.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital,
                      color: AppConstants.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Select Hospital',
                            size: 18,
                            weight: FontWeight.bold,
                            textColor: AppConstants.primaryColor,
                          ),
                          AppText(
                            text: '${widget.selectedCityName}, ${widget.selectedStateName}',
                            size: 14,
                            weight: FontWeight.normal,
                            textColor: AppConstants.greyColor,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppConstants.greyColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search hospitals...',
                    hintStyle: TextStyle(color: AppConstants.greyColor, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: AppConstants.greyColor, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: AppConstants.greyColor, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: widget.isDarkMode
                        ? AppConstants.darkBackgroundColor
                        : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppConstants.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: widget.isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Hospital List
          Expanded(
            child: _filteredHospitals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: AppConstants.greyColor,
                        ),
                        const SizedBox(height: 12),
                        AppText(
                          text: 'No hospitals found',
                          size: 16,
                          weight: FontWeight.w500,
                          textColor: AppConstants.greyColor,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          text: 'Try a different search term',
                          size: 14,
                          weight: FontWeight.normal,
                          textColor: AppConstants.greyColor,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = _filteredHospitals[index];
                      return _buildHospitalItem(hospital);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalItem(Map<String, dynamic> hospital) {
    return InkWell(
      onTap: () => widget.onHospitalSelected(hospital),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppConstants.darkBackgroundColor
              : AppConstants.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hospital Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.local_hospital,
                color: AppConstants.primaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            
            // Hospital Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital Name and Preferred Badge
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: hospital['hospitalName'] ?? 'Hospital Name Not Available',
                          size: 14,
                          weight: FontWeight.w600,
                          textColor: widget.isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        ),
                      ),
                      if (hospital['preferredYN'] == 'Y')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.greenColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppText(
                            text: 'Preferred',
                            size: 9,
                            weight: FontWeight.w500,
                            textColor: AppConstants.greenColor,
                          ),
                        ),
                    ],
                  ),
                  
                  // Address
                  if (hospital['address1'] != null && hospital['address1'].toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: AppConstants.greyColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: AppText(
                            text: hospital['address1'],
                            size: 11,
                            weight: FontWeight.normal,
                            textColor: AppConstants.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  // Phone and Pincode in same row
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (hospital['phHosp1'] != null && hospital['phHosp1'].toString().isNotEmpty)
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.phone, size: 12, color: AppConstants.greyColor),
                              const SizedBox(width: 4),
                              Flexible(
                                child: AppText(
                                  text: hospital['phHosp1'],
                                  size: 11,
                                  weight: FontWeight.normal,
                                  textColor: AppConstants.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hospital['pincode'] != null && hospital['pincode'].toString().isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AppText(
                            text: 'PIN: ${hospital['pincode']}',
                            size: 10,
                            weight: FontWeight.w500,
                            textColor: AppConstants.primaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow Icon
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppConstants.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
