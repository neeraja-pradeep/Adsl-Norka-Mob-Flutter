import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:norkacare_app/services/claim_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ClaimProvider extends ChangeNotifier {
  final ClaimService _claimService = ClaimService();

  bool _isUploading = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _uploadedFileId = '';
  String _signedUrl = '';
  String _expiresAt = '';
  double _uploadProgress = 0.0;
  
  // Claim and dependent data
  List<dynamic> _dependents = [];
  List<dynamic> _claims = [];
  Map<String, dynamic>? _claimDependentData;

  // Getters
  bool get isUploading => _isUploading;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get uploadedFileId => _uploadedFileId;
  String get signedUrl => _signedUrl;
  String get expiresAt => _expiresAt;
  double get uploadProgress => _uploadProgress;
  List<dynamic> get dependents => _dependents;
  List<dynamic> get claims => _claims;
  Map<String, dynamic>? get claimDependentData => _claimDependentData;

  /// Upload claim document (Two-step process)
  Future<Map<String, dynamic>> uploadClaimDocument({
    required PlatformFile file,
  }) async {
    _isUploading = true;
    _errorMessage = '';
    _uploadProgress = 0.0;
    notifyListeners();

    try {
      debugPrint('=== CLAIM PROVIDER: Starting document upload ===');

      // Call the service method
      final result = await _claimService.uploadClaimDocument(file: file);

      if (result['success']) {
        _uploadedFileId = result['fileId'] ?? '';
        _signedUrl = result['signedUrl'] ?? '';
        _expiresAt = result['expiresAt'] ?? '';
        _uploadProgress = 100.0;
        _errorMessage = '';

        debugPrint('✅ CLAIM PROVIDER: Upload successful');
        debugPrint('File ID: $_uploadedFileId');

        _isUploading = false;
        notifyListeners();

        return {
          'success': true,
          'fileId': _uploadedFileId,
          'message': result['message'] ?? 'File uploaded successfully',
        };
      } else {
        _errorMessage = result['error'] ?? 'Upload failed';
        _uploadProgress = 0.0;

        debugPrint('❌ CLAIM PROVIDER: Upload failed');
        debugPrint('Error: $_errorMessage');

        _isUploading = false;
        notifyListeners();

        return {
          'success': false,
          'error': _errorMessage,
        };
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _uploadProgress = 0.0;
      _isUploading = false;

      debugPrint('❌ CLAIM PROVIDER: Exception occurred');
      debugPrint('Error: $e');

      notifyListeners();

      return {
        'success': false,
        'error': _errorMessage,
      };
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Reset upload state
  void resetUploadState() {
    _isUploading = false;
    _errorMessage = '';
    _uploadedFileId = '';
    _signedUrl = '';
    _expiresAt = '';
    _uploadProgress = 0.0;
    notifyListeners();
  }

  /// Get upload progress percentage
  int getUploadProgressPercentage() {
    return _uploadProgress.toInt();
  }

  /// Fetch claim and dependent information
  Future<Map<String, dynamic>> fetchClaimDependentInfo({
    required String norkaId,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      debugPrint('=== CLAIM PROVIDER: Fetching claim & dependent info ===');

      final result = await _claimService.getClaimDependentInfo(
        norkaId: norkaId,
      );

      if (result['success']) {
        _claimDependentData = result['data'];
        _dependents = result['dependents'] ?? [];
        _claims = result['claims'] ?? [];
        _errorMessage = '';

        debugPrint('✅ CLAIM PROVIDER: Data fetched successfully');
        debugPrint('Dependents: ${_dependents.length}');
        debugPrint('Claims: ${_claims.length}');
        debugPrint('=== CLAIM PROVIDER FULL DATA ===');
        debugPrint('Full Data: $_claimDependentData');
        debugPrint('=== Dependents List ===');
        for (var i = 0; i < _dependents.length; i++) {
          debugPrint('Dependent $i: ${_dependents[i]}');
        }
        debugPrint('=== Claims List ===');
        for (var i = 0; i < _claims.length; i++) {
          debugPrint('Claim $i: ${_claims[i]}');
        }
        debugPrint('=== END CLAIM PROVIDER DATA ===');

        // Save to SharedPreferences for offline access
        await saveClaimsDataToPrefs();

        _isLoading = false;
        notifyListeners();

        return {
          'success': true,
          'dependents': _dependents,
          'claims': _claims,
        };
      } else {
        _errorMessage = result['error'] ?? 'Failed to fetch data';

        debugPrint('❌ CLAIM PROVIDER: Fetch failed');
        debugPrint('Error: $_errorMessage');

        _isLoading = false;
        notifyListeners();

        return {
          'success': false,
          'error': _errorMessage,
        };
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;

      debugPrint('❌ CLAIM PROVIDER: Exception occurred');
      debugPrint('Error: $e');

      notifyListeners();

      return {
        'success': false,
        'error': _errorMessage,
      };
    }
  }

  /// Clear all claim data
  void clearClaimData() {
    _dependents = [];
    _claims = [];
    _claimDependentData = null;
    _errorMessage = '';
    notifyListeners();
  }

  /// Submit claim to API
  Future<Map<String, dynamic>> submitClaim(Map<String, dynamic> requestBody) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      debugPrint('=== CLAIM PROVIDER: Submitting claim ===');
      debugPrint('Request Body: $requestBody');

      final result = await _claimService.submitClaim(requestBody);

      if (result['success']) {
        _errorMessage = '';
        _isLoading = false;
        notifyListeners();

        debugPrint('✅ CLAIM PROVIDER: Claim submitted successfully');
        return {
          'success': true,
          'data': result['data'],
        };
      } else {
        _errorMessage = result['error'] ?? 'Failed to submit claim';
        _isLoading = false;
        notifyListeners();

        debugPrint('❌ CLAIM PROVIDER: Claim submission failed');
        debugPrint('Error: $_errorMessage');

        return {
          'success': false,
          'error': _errorMessage,
        };
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;

      debugPrint('❌ CLAIM PROVIDER: Exception during claim submission');
      debugPrint('Error: $e');

      notifyListeners();

      return {
        'success': false,
        'error': _errorMessage,
      };
    }
  }

  /// Save claims data to SharedPreferences for offline access
  Future<void> saveClaimsDataToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save the full claim dependent data
      if (_claimDependentData != null) {
        await prefs.setString(
          'cached_claims_data',
          jsonEncode(_claimDependentData),
        );
        debugPrint('💾 Claims data saved to SharedPreferences for offline access');
      }
      
      // Also save dependents and claims separately for easy access
      await prefs.setString('cached_dependents', jsonEncode(_dependents));
      await prefs.setString('cached_claims', jsonEncode(_claims));
      
    } catch (e) {
      debugPrint('❌ Error saving claims data to SharedPreferences: $e');
    }
  }

  /// Load claims data from SharedPreferences for offline access
  Future<void> loadClaimsDataFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load cached claims data
      final cachedClaimsData = prefs.getString('cached_claims_data');
      final cachedDependents = prefs.getString('cached_dependents');
      final cachedClaims = prefs.getString('cached_claims');
      
      if (cachedClaimsData != null) {
        _claimDependentData = jsonDecode(cachedClaimsData);
        debugPrint('📱 Loaded cached claims data from SharedPreferences');
      }
      
      if (cachedDependents != null) {
        _dependents = jsonDecode(cachedDependents);
        debugPrint('📱 Loaded ${_dependents.length} cached dependents');
      }
      
      if (cachedClaims != null) {
        _claims = jsonDecode(cachedClaims);
        debugPrint('📱 Loaded ${_claims.length} cached claims');
      }
      
      notifyListeners();
      
    } catch (e) {
      debugPrint('❌ Error loading claims data from SharedPreferences: $e');
    }
  }

  /// Clear cached claims data
  Future<void> clearCachedClaimsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_claims_data');
      await prefs.remove('cached_dependents');
      await prefs.remove('cached_claims');
      
      _claimDependentData = null;
      _dependents = [];
      _claims = [];
      
      notifyListeners();
      
      debugPrint('🗑️ Cached claims data cleared');
    } catch (e) {
      debugPrint('❌ Error clearing cached claims data: $e');
    }
  }
}

