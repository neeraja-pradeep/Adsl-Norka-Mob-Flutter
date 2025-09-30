import 'dart:convert';
import 'package:norkacare_app/utils/vidal_utils.dart';
import 'package:intl/intl.dart';

class VidalDataMapper {
  /// Build Vidal enrollment payload from available data
  static Map<String, dynamic> buildVidalEnrollmentPayload({
    required Map<String, dynamic> norkaResponse,
    required Map<String, dynamic> enrollmentDetails,
    required Map<String, dynamic> familyMembersDetails,
    required String emailId,
    required String nrkId,
    String? requestId,
    Map<String, dynamic>? datesDetails,
  }) {
    try {
      print('=== Vidal Data Mapper Debug ===');
      print('NORKA Response: $norkaResponse');
      print('Enrollment Details: $enrollmentDetails');
      print('Family Members Details: $familyMembersDetails');

      // Extract data from NORKA response
      final employeeName = norkaResponse['name'] ?? '';

      // Mobile number extraction removed as per requirement
      
      // Enhanced NRK ID extraction logic for Create Enroll API
      final extractedNrkId = norkaResponse['norka_id'] ?? 
                            norkaResponse['nrk_id'] ?? 
                            norkaResponse['nrk_id_no'] ?? 
                            familyMembersDetails['nrk_id_no'] ?? 
                            nrkId; // Fallback to passed parameter
      
      print('=== Create Enroll NRK ID Debug ===');
      print('Passed NRK ID: $nrkId');
      print('norkaResponse[norka_id]: ${norkaResponse['norka_id']}');
      print('norkaResponse[nrk_id]: ${norkaResponse['nrk_id']}');
      print('norkaResponse[nrk_id_no]: ${norkaResponse['nrk_id_no']}');
      print('familyMembersDetails[nrk_id_no]: ${familyMembersDetails['nrk_id_no']}');
      print('Final Extracted NRK ID: $extractedNrkId');
      print('NORKA Response keys: ${norkaResponse.keys.toList()}');
      print('Family Members Details keys: ${familyMembersDetails.keys.toList()}');
      print('=== End Create Enroll NRK ID Debug ===');

      // Extract address from address object
      String address = '1st Floor, Tower B, Building No 8';
      if (norkaResponse['address'] != null && norkaResponse['address'] is Map) {
        final addressObj = norkaResponse['address'] as Map<String, dynamic>;
        address = addressObj['address'] ?? address;
      }

      // Extract pincode from address object
      String pincode = '';
      if (norkaResponse['address'] != null && norkaResponse['address'] is Map) {
        final addressObj = norkaResponse['address'] as Map<String, dynamic>;
        pincode = addressObj['pincode']?.toString() ?? '';
      }

      // Extract enrollment data
      final enrollmentData = enrollmentDetails['data'];
      final selfEnrollmentNumber =
          enrollmentData?['self_enrollment_number'] ?? '';
      final spouseEnrollmentNumber =
          enrollmentData?['spouse_enrollment_number'] ?? '';
      final child1EnrollmentNumber =
          enrollmentData?['child1_enrollment_number'] ?? '';
      final child2EnrollmentNumber =
          enrollmentData?['child2_enrollment_number'] ?? '';
      final child3EnrollmentNumber =
          enrollmentData?['child3_enrollment_number'] ?? '';
      final child4EnrollmentNumber =
          enrollmentData?['child4_enrollment_number'] ?? '';
      final child5EnrollmentNumber =
          enrollmentData?['child5_enrollment_number'] ?? '';

      // Debug enrollment numbers
      print('=== Enrollment Numbers Debug ===');
      print('Self Enrollment Number: $selfEnrollmentNumber');
      print('Spouse Enrollment Number: $spouseEnrollmentNumber');
      print('Child1 Enrollment Number: $child1EnrollmentNumber');
      print('Child2 Enrollment Number: $child2EnrollmentNumber');
      print('Child3 Enrollment Number: $child3EnrollmentNumber');
      print('Child4 Enrollment Number: $child4EnrollmentNumber');
      print('Child5 Enrollment Number: $child5EnrollmentNumber');
      print('=== End Enrollment Numbers Debug ===');
      
      // Validate that we have at least self enrollment number
      if (selfEnrollmentNumber.isEmpty) {
        print('❌ WARNING: Self enrollment number is empty!');
        print('❌ This may cause Vidal create enroll API to fail');
      }

      // Extract family members data
      // Note: The family members API returns the data directly, not nested under 'data'
      final familyMembers = familyMembersDetails.isNotEmpty
          ? [familyMembersDetails]
          : [];

      // Debug family members structure
      print('=== Family Members Structure Debug ===');
      print('Family Members Details: $familyMembersDetails');
      print('Family Members List: $familyMembers');
      print('=== End Family Members Structure Debug ===');

      // Extract dates from datesDetails API response
      String dateOfJoining = "01/11/2025";
      String dateOfInception = "01/11/2025";
      String dateOfExit = "31/10/2026";

      if (datesDetails != null && datesDetails.isNotEmpty) {
        dateOfJoining = _formatDateForVidal(
          datesDetails['date_of_joining'] ?? "01/11/2025",
        );
        dateOfInception = _formatDateForVidal(
          datesDetails['date_of_inception'] ?? "01/11/2025",
        );
        dateOfExit = _formatDateForVidal(
          datesDetails['date_of_exit'] ?? "31/10/2026",
        );

        print('=== Dates Details Debug ===');
        print('Date of Joining: $dateOfJoining');
        print('Date of Inception: $dateOfInception');
        print('Date of Exit: $dateOfExit');
        print('=== End Dates Details Debug ===');
      }

      // Build dependent info array
      List<Map<String, dynamic>> dependentInfo = [];

      // Add self
      if (selfEnrollmentNumber.isNotEmpty) {
        // Convert date format from MM/dd/yyyy to dd/MM/yyyy for Vidal
        String dob = '01/01/1990';
        String vidalDob = '01/01/1990';
        if (norkaResponse['date_of_birth'] != null) {
          dob = norkaResponse['date_of_birth'].toString();
          // Convert from MM/dd/yyyy to dd/MM/yyyy
          try {
            final parts = dob.split('/');
            if (parts.length == 3) {
              vidalDob = '${parts[1]}/${parts[0]}/${parts[2]}';
            }
          } catch (e) {
            vidalDob = dob;
          }
        }

        dependentInfo.add({
          "cardholder_name": employeeName,
          "depedent_unique_id": selfEnrollmentNumber,
          "date_of_inception": dateOfInception,
          "age": VidalUtils.calculateAge(vidalDob),
          // "date_of_exit": dateOfExit,
          "date_of_exit": "",
          "dob": vidalDob,
          "gender": _mapGender(norkaResponse['gender'] ?? 'Male'),
          "sum_insured": "500000",
          "vidal_tpa_id": "",
          "risk_id": "",
          "relation": "Self",
        });
      }

      // Add spouse if available
      print('=== Adding Spouse ===');
      print('Spouse Enrollment Number: $spouseEnrollmentNumber');
      print('Is Empty: ${spouseEnrollmentNumber.isEmpty}');

      if (spouseEnrollmentNumber.isNotEmpty) {
        // Extract spouse data from family members details
        final spouseName = familyMembersDetails['spouse_name'] ?? 'SPOUSE';
        final spouseDob = familyMembersDetails['spouse_dob'] ?? '01/01/1990';
        final spouseGender = familyMembersDetails['spouse_gender'] ?? 'Female';

        print('Spouse Name: $spouseName');
        print('Spouse DOB: $spouseDob');
        print('Spouse Gender: $spouseGender');

        // Convert date format from MM-dd-yyyy to dd/MM/yyyy for Vidal
        String vidalSpouseDob = spouseDob;
        try {
          if (spouseDob.contains('-')) {
            final parts = spouseDob.split('-');
            if (parts.length == 3) {
              vidalSpouseDob = '${parts[1]}/${parts[0]}/${parts[2]}';
            }
          }
        } catch (e) {
          vidalSpouseDob = spouseDob;
        }

        dependentInfo.add({
          "cardholder_name": spouseName,
          "depedent_unique_id": spouseEnrollmentNumber,
          "date_of_inception": dateOfInception,
          "age": VidalUtils.calculateAge(vidalSpouseDob),
          // "date_of_exit": dateOfExit,
          "date_of_exit": "",
          "dob": vidalSpouseDob,
          "gender": _mapGender(spouseGender),
          "sum_insured": "500000",
          "vidal_tpa_id": "",
          "risk_id": "",
          "relation": "Spouse",
        });
        print('Added spouse to dependent info');
      } else {
        print('Skipping spouse - no enrollment number');
      }
      print('=== End Adding Spouse ===');

      // Add children if available
      _addChildIfAvailable(
        dependentInfo,
        familyMembers,
        child1EnrollmentNumber,
        'child1',
        'Child',
        dateOfInception,
        dateOfExit,
      );
      _addChildIfAvailable(
        dependentInfo,
        familyMembers,
        child2EnrollmentNumber,
        'child2',
        'Child (2)',
        dateOfInception,
        dateOfExit,
      );
      _addChildIfAvailable(
        dependentInfo,
        familyMembers,
        child3EnrollmentNumber,
        'child3',
        'Child (3)',
        dateOfInception,
        dateOfExit,
      );
      _addChildIfAvailable(
        dependentInfo,
        familyMembers,
        child4EnrollmentNumber,
        'child4',
        'Child (4)',
        dateOfInception,
        dateOfExit,
      );
      _addChildIfAvailable(
        dependentInfo,
        familyMembers,
        child5EnrollmentNumber,
        'child5',
        'Child (5)',
        dateOfInception,
        dateOfExit,
      );

      // Build the complete payload
      final finalRequestId = requestId ?? VidalUtils.generateRequestId();
      print('=== Request ID Debug ===');
      print('Using request ID: $finalRequestId');
      print(
        'Source: ${requestId != null ? "From checkbox API" : "Generated new"}',
      );

      final payload = {
        "request_id": finalRequestId,
        "corporate_name": "NORKA ROOTS",
        "corporate_id": "N0626", // "N0626",
        "employeeinfo": {
          "pincode": pincode,
          "address": address,
          "date_of_joining": dateOfJoining,
          "employee_name": employeeName,
          "email_id": emailId,
          "employee_no": extractedNrkId,
          "policyinfo": [
            {
              "benefit_name": "Base policy",
              "entity_name": "N0626", // "N0626",
              "policy_number": "763300/25-26/NORKACARE/001",
              // "policy_number": "760100/NORKA ROOTS/BASE",
              "si_type": "Floater",
              "dependent_info": dependentInfo,
            },
          ],
        },
      };

      print('=== Final Vidal Payload ===');
      print('Payload Length: ${payload.toString().length} characters');
      print('Dependent Info Count: ${dependentInfo.length}');

      // Print each dependent separately for better visibility
      for (int i = 0; i < dependentInfo.length; i++) {
        print('Dependent $i: ${dependentInfo[i]}');
      }

      // Print full payload as formatted JSON
      try {
        final jsonString = JsonEncoder.withIndent('  ').convert(payload);
        print('=== Full Payload as JSON ===');
        print(jsonString);
        print('=== End Full Payload ===');
      } catch (e) {
        print('Error formatting JSON: $e');
        print('Raw payload: $payload');
      }

      print('=== End Vidal Payload ===');

      return payload;
    } catch (e) {
      // Return a minimal payload with error logging
      print('Error building Vidal payload: $e');
      
      // Extract NRK ID for error fallback
      final fallbackNrkId = norkaResponse['norka_id'] ?? 
                           norkaResponse['nrk_id'] ?? 
                           norkaResponse['nrk_id_no'] ?? 
                           familyMembersDetails['nrk_id_no'] ?? 
                           nrkId;
      
      return {
        "request_id": VidalUtils.generateRequestId(),
        "corporate_name": "NORKA ROOTS",
        "corporate_id": "N0626", // "N0626",
        "employeeinfo": {
          "pincode": "",
          "address": "1st Floor, Tower B, Building No 8",
          "date_of_joining": "01/11/2025",
          "employee_name": "",
          "email_id": emailId,
          "employee_no": fallbackNrkId,
          "policyinfo": [],
        },
      };
    }
  }

  /// Add child to dependent info if enrollment number is available
  static void _addChildIfAvailable(
    List<Map<String, dynamic>> dependentInfo,
    List familyMembers,
    String enrollmentNumber,
    String relation,
    String defaultName,
    String dateOfInception,
    String dateOfExit,
  ) {
    print('=== Adding $relation ===');
    print('Enrollment Number: $enrollmentNumber');
    print('Is Empty: ${enrollmentNumber.isEmpty}');

    if (enrollmentNumber.isNotEmpty) {
      // Extract child data from family members details based on relation
      Map<String, dynamic> familyMembersDetails = familyMembers.isNotEmpty
          ? familyMembers[0]
          : {};

      String childName = '';
      String childDob = '';
      String childGender = '';
      String childRelation = '';

      if (relation == 'child1') {
        childName = familyMembersDetails['kid_1_name'] ?? defaultName;
        childDob = familyMembersDetails['kid_1_dob'] ?? '01/01/2016';
        childGender = _getChildGender(familyMembersDetails, 1);
        childRelation = 'Child';
      } else if (relation == 'child2') {
        childName = familyMembersDetails['kid_2_name'] ?? defaultName;
        childDob = familyMembersDetails['kid_2_dob'] ?? '01/01/2016';
        childGender = _getChildGender(familyMembersDetails, 2);
        childRelation = 'Child (2)';
      } else if (relation == 'child3') {
        childName = familyMembersDetails['kid_3_name'] ?? defaultName;
        childDob = familyMembersDetails['kid_3_dob'] ?? '01/01/2016';
        childGender = _getChildGender(familyMembersDetails, 3);
        childRelation = 'Child (3)';
      } else if (relation == 'child4') {
        childName = familyMembersDetails['kid_4_name'] ?? defaultName;
        childDob = familyMembersDetails['kid_4_dob'] ?? '01/01/2016';
        childGender = _getChildGender(familyMembersDetails, 4);
        childRelation = 'Child (4)';
      } else if (relation == 'child5') {
        childName = familyMembersDetails['kid_5_name'] ?? defaultName;
        childDob = familyMembersDetails['kid_5_dob'] ?? '01/01/2016';
        childGender = _getChildGender(familyMembersDetails, 5);
        childRelation = 'Child (5)';
      }

      print('Child Name: $childName');
      print('Child DOB: $childDob');
      print('Child Gender: $childGender');
      print('Child Relation: $childRelation');

      // Convert date format from MM-dd-yyyy to dd/MM/yyyy for Vidal
      String vidalChildDob = childDob;
      try {
        if (childDob.contains('-')) {
          final parts = childDob.split('-');
          if (parts.length == 3) {
            vidalChildDob = '${parts[1]}/${parts[0]}/${parts[2]}';
          }
        }
      } catch (e) {
        vidalChildDob = childDob;
      }

      dependentInfo.add({
        "cardholder_name": childName,
        "depedent_unique_id": enrollmentNumber,
        "date_of_inception": dateOfInception,
        "age": VidalUtils.calculateAge(vidalChildDob),
        // "date_of_exit": dateOfExit,
        "date_of_exit": "",
        "dob": vidalChildDob,
        "gender": _mapGender(childGender),
        "sum_insured": "500000",
        "vidal_tpa_id": "",
        "risk_id": "",
        "relation": childRelation,
      });
      print('Added $relation to dependent info');
    } else {
      print('Skipping $relation - no enrollment number');
    }
    print('=== End Adding $relation ===');
  }

  /// Map gender values to expected format
  static String _mapGender(String gender) {
    final lowerGender = gender.toLowerCase();
    if (lowerGender.contains('male') || lowerGender.contains('m')) {
      return 'Male';
    } else if (lowerGender.contains('female') || lowerGender.contains('f')) {
      return 'Female';
    }
    return 'Male'; // Default fallback
  }

  /// Build Vidal enrollment validation payload from available data
  static Map<String, dynamic> buildVidalValidationPayload({
    required Map<String, dynamic> norkaResponse,
    required Map<String, dynamic> familyMembersDetails,
    required String requestId,
    required String selfUniqueId,
    Map<String, dynamic>? datesDetails,
  }) {
    try {
      print('=== Vidal Validation Data Mapper Debug ===');
      print('NORKA Response: $norkaResponse');
      print('Family Members Details: $familyMembersDetails');
      print('Request ID: $requestId');
      print('Self Unique ID: $selfUniqueId');

      // Extract dates from datesDetails API response
      String dateOfJoining = "01/11/2025";
      String dateOfInception = "01/11/2025";
      String dateOfExit = "31/10/2026";

      if (datesDetails != null && datesDetails.isNotEmpty) {
        dateOfJoining = _formatDateForVidal(
          datesDetails['date_of_joining'] ?? "01/11/2025",
        );
        dateOfInception = _formatDateForVidal(
          datesDetails['date_of_inception'] ?? "01/11/2025",
        );
        dateOfExit = _formatDateForVidal(
          datesDetails['date_of_exit'] ?? "31/10/2026",
        );

        print('=== Validation Dates Details Debug ===');
        print('Date of Joining: $dateOfJoining');
        print('Date of Inception: $dateOfInception');
        print('Date of Exit: $dateOfExit');
        print('=== End Validation Dates Details Debug ===');
      }

      // Extract data from NORKA response
      final employeeName = norkaResponse['name'] ?? '';
      final emailId = norkaResponse['emails']?[0]?['address'] ?? '';
      // Mobile number extraction removed as per requirement
      final nrkId = norkaResponse['norka_id'] ?? 
                   norkaResponse['nrk_id'] ?? 
                   norkaResponse['nrk_id_no'] ?? 
                   familyMembersDetails['nrk_id_no'] ?? '';
      final address = norkaResponse['address']?['address'] ?? '';
      final pincode = norkaResponse['address']?['pincode'] ?? '';

      print('=== NRK ID Extraction Debug ===');
      print('norkaResponse[norka_id]: ${norkaResponse['norka_id']}');
      print('norkaResponse[nrk_id]: ${norkaResponse['nrk_id']}');
      print('norkaResponse[nrk_id_no]: ${norkaResponse['nrk_id_no']}');
      print('familyMembersDetails[nrk_id_no]: ${familyMembersDetails['nrk_id_no']}');
      print('Final NRK ID: $nrkId');
      print('=== End NRK ID Extraction Debug ===');

      // Build dependent info list
      List<Map<String, dynamic>> dependentInfo = [];

      // Add Self
      final selfDob = norkaResponse['date_of_birth'] ?? '';
      final selfGender = norkaResponse['gender'] ?? '';
      if (selfDob.isNotEmpty && selfUniqueId.isNotEmpty) {
        dependentInfo.add(
          _buildDependentInfo(
            cardholderName: employeeName,
            dependentUniqueId: selfUniqueId,
            dob: selfDob,
            gender: selfGender,
            relation: 'Self',
            dateOfInception: dateOfInception,
            dateOfExit: dateOfExit,
          ),
        );
      }

      // Add Spouse
      final spouseName = familyMembersDetails['spouse_name'] ?? '';
      final spouseDob = familyMembersDetails['spouse_dob'] ?? '';
      final spouseGender = familyMembersDetails['spouse_gender'] ?? '';
      final spouseUniqueId = familyMembersDetails['spouse_unique_id'] ?? '';
      if (spouseName.isNotEmpty &&
          spouseDob.isNotEmpty &&
          spouseUniqueId.isNotEmpty) {
        dependentInfo.add(
          _buildDependentInfo(
            cardholderName: spouseName,
            dependentUniqueId: spouseUniqueId,
            dob: spouseDob,
            gender: spouseGender,
            relation: 'Spouse',
            dateOfInception: dateOfInception,
            dateOfExit: dateOfExit,
          ),
        );
      }

      // Add Children (maximum 5)
      for (int i = 1; i <= 5; i++) {
        final childName = familyMembersDetails['kid_${i}_name'] ?? '';
        final childDob = familyMembersDetails['kid_${i}_dob'] ?? '';
        final childGender = _getChildGender(familyMembersDetails, i);
        final childUniqueId = familyMembersDetails['kid_${i}_unique_id'] ?? '';
        if (childName.isNotEmpty &&
            childDob.isNotEmpty &&
            childUniqueId.isNotEmpty) {
          // Determine child relation based on index
          String childRelation = i == 1 ? 'Child' : 'Child ($i)';
          
          dependentInfo.add(
            _buildDependentInfo(
              cardholderName: childName,
              dependentUniqueId: childUniqueId,
              dob: childDob,
              gender: childGender,
              relation: childRelation,
              dateOfInception: dateOfInception,
              dateOfExit: dateOfExit,
            ),
          );
        }
      }

      // Build the complete payload
      final payload = {
        "request_id": requestId,
        "corporate_name": "NORKA ROOTS",
        "corporate_id": "N0626", // "N0626",
        "employeeinfo": {
          "pincode": pincode,
          "address": address,
          "date_of_joining": dateOfJoining,
          "employee_name": employeeName,
          "email_id": emailId,
          "employee_no": nrkId,
          "policyinfo": [
            {
              "benefit_name": "Base policy",
              "entity_name": "N0626", // "N0626",
              "policy_number": "763300/25-26/NORKACARE/001",
              "si_type": "Floater",
              "dependent_info": dependentInfo,
            },
          ],
        },
      };

      print('=== Vidal Validation Payload Built ===');
      print('Payload: $payload');
      return payload;
    } catch (e) {
      print('Error building Vidal validation payload: $e');
      rethrow;
    }
  }

  /// Build dependent info for validation payload
  static Map<String, dynamic> _buildDependentInfo({
    required String cardholderName,
    required String dependentUniqueId,
    required String dob,
    required String gender,
    required String relation,
    required String dateOfInception,
    required String dateOfExit,
  }) {
    // Calculate age from DOB
    int age = _calculateAge(dob);

    // Format DOB to DD/MM/YYYY
    String formattedDob = _formatDobForVidal(dob);

    return {
      "cardholder_name": cardholderName,
      "depedent_unique_id": dependentUniqueId,
      "date_of_inception": dateOfInception,
      "age": age,
      // "date_of_exit": dateOfExit,
      "date_of_exit": "",
      "dob": formattedDob,
      "gender": _mapGender(gender),
      "sum_insured": "500000",
      "vidal_tpa_id": "",
      "risk_id": "",
      "relation": relation,
    };
  }

  /// Calculate age from date of birth
  static int _calculateAge(String dob) {
    try {
      DateTime? birthDate;

      // Try different date formats
      if (dob.contains('/')) {
        List<String> parts = dob.split('/');
        if (parts.length == 3) {
          // Handle MM/DD/YYYY format
          birthDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      } else if (dob.contains('-')) {
        List<String> parts = dob.split('-');
        if (parts.length == 3) {
          // Handle MM-DD-YYYY format
          birthDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      }

      if (birthDate != null) {
        DateTime now = DateTime.now();
        int age = now.year - birthDate.year;
        if (now.month < birthDate.month ||
            (now.month == birthDate.month && now.day < birthDate.day)) {
          age--;
        }
        return age;
      }
    } catch (e) {
      print('Error calculating age: $e');
    }
    return 0; // Default age if calculation fails
  }

  /// Format DOB for Vidal API (DD/MM/YYYY)
  static String _formatDobForVidal(String dob) {
    try {
      DateTime? birthDate;

      // Try different date formats
      if (dob.contains('/')) {
        List<String> parts = dob.split('/');
        if (parts.length == 3) {
          // Handle MM/DD/YYYY format
          birthDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      } else if (dob.contains('-')) {
        List<String> parts = dob.split('-');
        if (parts.length == 3) {
          // Handle MM-DD-YYYY format
          birthDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      }

      if (birthDate != null) {
        return DateFormat('dd/MM/yyyy').format(birthDate);
      }
    } catch (e) {
      print('Error formatting DOB: $e');
    }
    return dob; // Return original if formatting fails
  }

  /// Format date from API response (MM-dd-yyyy) to Vidal format (dd/MM/yyyy)
  static String _formatDateForVidal(String dateString) {
    try {
      if (dateString.isEmpty) {
        return "01/11/2025"; // Default fallback
      }

      // Handle MM-dd-yyyy format from API
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          final month = parts[0].padLeft(2, '0');
          final day = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$day/$month/$year'; // Convert to dd/MM/yyyy
        }
      }

      // Handle MM/dd/yyyy format
      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          final month = parts[0].padLeft(2, '0');
          final day = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$day/$month/$year'; // Convert to dd/MM/yyyy
        }
      }

      return dateString; // Return original if can't parse
    } catch (e) {
      print('Error formatting date for Vidal: $e');
      return "01/11/2025"; // Default fallback
    }
  }

  static String _getChildGender(Map<String, dynamic> familyMembersDetails, int childIndex) {
    // Get the relation field (Son/Daughter) and convert to gender (Male/Female)
    String relation = familyMembersDetails['kid_${childIndex}_relation'] ?? '';
    String gender = '';
    
    if (relation.toLowerCase() == 'son') {
      gender = 'Male';
    } else if (relation.toLowerCase() == 'daughter') {
      gender = 'Female';
    }
    
    return gender.isEmpty ? 'Male' : gender; // Default to Male if relation is not found
  }
}
