import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:norkacare_app/networking/baseurl.dart';
import 'package:norkacare_app/support/dio_helper.dart';

class ClaimService {

  /// Step 1: Get signed URL for file upload
  Future<Map<String, dynamic>> getSignedUrl({
    required String fileName,
  }) async {
    try {
      debugPrint('=== STEP 1: Getting Signed URL ===');
      debugPrint('File Name: $fileName');

      // Get Dio instance with configured headers
      final dio = await DioHelper.getInstance();

      final response = await dio.post(
        '$VidalBaseURL/vidal/files/upload-url',
        data: {
          'scope': 'Claim',
          'fileName': fileName,
        },
      );

      debugPrint('=== Signed URL Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status: ${response.data['status']}');
      debugPrint('Successful: ${response.data['successful']}');
      debugPrint('Trace: ${response.data['trace']}');
      debugPrint('Signed URL: ${response.data['data']?['signedUrl']}');
      debugPrint('File ID: ${response.data['data']?['fileId']}');
      debugPrint('Expires At: ${response.data['data']?['expiresAt']}');
      debugPrint('=== FULL SIGNED URL RESPONSE ===');
      debugPrint('${response.data}');
      debugPrint('=== END FULL RESPONSE ===');

      if (response.statusCode == 200 && response.data['successful'] == true) {
        return {
          'success': true,
          'data': response.data['data'],
          'trace': response.data['trace'],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to get signed URL',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ Error getting signed URL: ${e.message}');
      return {
        'success': false,
        'error': e.response?.data?['message'] ?? e.message ?? 'Network error',
      };
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  /// Step 2: Upload file using signed URL
  Future<Map<String, dynamic>> uploadFileToSignedUrl({
    required String signedUrl,
    required PlatformFile file,
  }) async {
    try {
      debugPrint('=== STEP 2: Uploading File to Signed URL ===');
      debugPrint('Signed URL: $signedUrl');
      debugPrint('File Name: ${file.name}');
      debugPrint('File Size: ${file.size} bytes');

      // Prepare file data
      List<int> fileBytes;
      if (file.bytes != null) {
        // Web platform
        fileBytes = file.bytes!;
      } else if (file.path != null) {
        // Mobile/Desktop platform
        fileBytes = await File(file.path!).readAsBytes();
      } else {
        throw Exception('No file data available');
      }

      debugPrint('File bytes length: ${fileBytes.length}');

      // Create Dio instance for PUT request (without base URL)
      final uploadDio = Dio();
      
      // Determine content type based on file extension
      String contentType = 'application/octet-stream';
      if (file.extension?.toLowerCase() == 'pdf') {
        contentType = 'application/pdf';
      } else if (file.extension?.toLowerCase() == 'jpg' || 
                 file.extension?.toLowerCase() == 'jpeg') {
        contentType = 'image/jpeg';
      }

      final response = await uploadDio.put(
        signedUrl,
        data: fileBytes,
        options: Options(
          headers: {
            'Content-Type': contentType,
            'Content-Length': fileBytes.length.toString(),
          },
          responseType: ResponseType.json,
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).toStringAsFixed(0);
          debugPrint('Upload Progress: $progress%');
        },
      );

      debugPrint('=== File Upload Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('=== FULL FILE UPLOAD RESPONSE ===');
      debugPrint('${response.data}');
      debugPrint('Response Headers: ${response.headers}');
      debugPrint('=== END FILE UPLOAD RESPONSE ===');

      // Accept both 200 (OK) and 201 (Created) as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to upload file',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ Error uploading file: ${e.message}');
      debugPrint('❌ Status Code: ${e.response?.statusCode}');
      debugPrint('❌ Response: ${e.response?.data}');
      return {
        'success': false,
        'error': e.response?.data?['message'] ?? e.message ?? 'Upload failed',
      };
    } catch (e) {
      debugPrint('❌ Unexpected error during upload: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred during upload',
      };
    }
  }

  /// Combined method: Get signed URL and upload file
  Future<Map<String, dynamic>> uploadClaimDocument({
    required PlatformFile file,
  }) async {
    try {
      debugPrint('=== START CLAIM DOCUMENT UPLOAD ===');
      debugPrint('File: ${file.name}');
      debugPrint('Size: ${file.size} bytes');

      // Step 1: Get signed URL
      final signedUrlResponse = await getSignedUrl(fileName: file.name);

      if (!signedUrlResponse['success']) {
        return {
          'success': false,
          'error': signedUrlResponse['error'] ?? 'Failed to get signed URL',
        };
      }

      final signedUrl = signedUrlResponse['data']['signedUrl'];
      final fileId = signedUrlResponse['data']['fileId'];
      final expiresAt = signedUrlResponse['data']['expiresAt'];

      debugPrint('✅ Signed URL obtained');
      debugPrint('File ID: $fileId');

      // Step 2: Upload file to signed URL
      final uploadResponse = await uploadFileToSignedUrl(
        signedUrl: signedUrl,
        file: file,
      );

      if (!uploadResponse['success']) {
        return {
          'success': false,
          'error': uploadResponse['error'] ?? 'Failed to upload file',
        };
      }

      debugPrint('✅ File uploaded successfully');
      debugPrint('=== CLAIM DOCUMENT UPLOAD COMPLETE ===');

      return {
        'success': true,
        'fileId': fileId,
        'signedUrl': signedUrl,
        'expiresAt': expiresAt,
        'message': 'File uploaded successfully',
      };
    } catch (e) {
      debugPrint('❌ Error in uploadClaimDocument: $e');
      return {
        'success': false,
        'error': 'Failed to upload document',
      };
    }
  }

  /// Get claim and dependent information
  Future<Map<String, dynamic>> getClaimDependentInfo({
    required String norkaId,
  }) async {
    try {
      debugPrint('=== Getting Claim & Dependent Info ===');
      debugPrint('NORKA ID: $norkaId');

      // Get Dio instance with configured headers
      final dio = await DioHelper.getInstance();

      final response = await dio.post(
        '$VidalBaseURL/vidal/claims/claim-dependent-info', 
        data: {
          'empNO': norkaId,
          'tpaCardID': '',
          'claimID': '',
          'emailID': '',
          'mobileNO': '',
        },
      );

      debugPrint('=== Claim Dependent Info Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status: ${response.data['status']}');
      debugPrint('Successful: ${response.data['successful']}');
      debugPrint('Trace: ${response.data['trace']}');
      debugPrint('Dependents Count: ${response.data['data']?['dependents']?.length ?? 0}');
      debugPrint('Claims Count: ${response.data['data']?['claims']?.length ?? 0}');
      debugPrint('=== FULL RESPONSE DATA ===');
      debugPrint('${response.data}');
      debugPrint('=== Dependents Details ===');
      if (response.data['data']?['dependents'] != null) {
        for (var i = 0; i < (response.data['data']['dependents'] as List).length; i++) {
          debugPrint('Dependent $i: ${response.data['data']['dependents'][i]}');
        }
      }
      debugPrint('=== Claims Details ===');
      if (response.data['data']?['claims'] != null) {
        for (var i = 0; i < (response.data['data']['claims'] as List).length; i++) {
          debugPrint('Claim $i: ${response.data['data']['claims'][i]}');
        }
      }
      debugPrint('=== END FULL RESPONSE ===');

      if (response.statusCode == 200 && response.data['successful'] == true) {
        return {
          'success': true,
          'data': response.data['data'],
          'trace': response.data['trace'],
          'dependents': response.data['data']['dependents'] ?? [],
          'claims': response.data['data']['claims'] ?? [],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch claim information',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ Error getting claim info: ${e.message}');
      return {
        'success': false,
        'error': e.response?.data?['message'] ?? e.message ?? 'Network error',
      };
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  /// Submit claim to API
  Future<Map<String, dynamic>> submitClaim(Map<String, dynamic> requestBody) async {
    try {
      debugPrint('=== SUBMITTING CLAIM ===');
      debugPrint('Request Body: $requestBody');

      // Get Dio instance with configured headers
      final dio = await DioHelper.getInstance();

      final response = await dio.post(
        '$VidalBaseURL/vidal/claims/submit',
        data: requestBody,
      );

      debugPrint('=== CLAIM SUBMISSION RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response: ${response.data}');

      if (response.statusCode == 200 && response.data['successful'] == true) {
        return {
          'success': true,
          'data': response.data['data'],
          'trace': response.data['trace'],
        };
      } else {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Failed to submit claim',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ Error submitting claim: ${e.message}');
      return {
        'success': false,
        'error': e.response?.data?['message'] ?? e.message ?? 'Network error',
      };
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  /// Submit shortfall document (Step 3: After uploading file)
  Future<Map<String, dynamic>> submitShortfall({
    required String shortFallNo,
    required String claimNo,
    required String fileId,
  }) async {
    try {
      debugPrint('=== SUBMITTING SHORTFALL ===');
      debugPrint('ShortFall No: $shortFallNo');
      debugPrint('Claim No: $claimNo');
      debugPrint('File ID: $fileId');

      // Get Dio instance with configured headers
      final dio = await DioHelper.getInstance();

      final requestBody = {
        'shortFallNo': shortFallNo,
        'claimNo': claimNo,
        'fileId': fileId,
      };

      debugPrint('Request Body: $requestBody');

      final response = await dio.post(
        '$VidalBaseURL/vidal/claims/shortfall',
        data: requestBody,
      );

      debugPrint('=== SHORTFALL SUBMISSION RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response: ${response.data}');

      if (response.statusCode == 200 && response.data['successful'] == true) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': response.data['message'] ?? 'Shortfall document submitted successfully',
          'trace': response.data['trace'],
        };
      } else {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Failed to submit shortfall',
        };
      }
    } on DioException catch (e) {
      debugPrint('❌ Error submitting shortfall: ${e.message}');
      return {
        'success': false,
        'error': e.response?.data?['message'] ?? e.message ?? 'Network error',
      };
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }
}

