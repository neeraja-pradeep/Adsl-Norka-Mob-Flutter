import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/services/document_service.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/widgets/toast_message.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class DocumentsUpload extends StatefulWidget {
  const DocumentsUpload({super.key});

  @override
  State<DocumentsUpload> createState() => _DocumentsUploadState();
}

class _DocumentsUploadState extends State<DocumentsUpload> {
  final TextEditingController _labelController = TextEditingController();
  File? _selectedFile;
  String? _selectedFileName;
  bool _isUploading = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _documents = [];

  @override
  void initState() {
    super.initState();
    _loadCachedDocuments();
    _fetchDocuments();
  }

  // Load cached documents from SharedPreferences
  Future<void> _loadCachedDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nrkId = _getNrkId();
      final cachedDocuments = prefs.getString('documents_$nrkId');
      
      if (cachedDocuments != null) {
        final List<dynamic> decodedDocs = jsonDecode(cachedDocuments);
        setState(() {
          _documents = List<Map<String, dynamic>>.from(decodedDocs);
        });
        debugPrint('📱 Loaded ${_documents.length} cached documents from offline storage');
      }
    } catch (e) {
      debugPrint('Error loading cached documents: $e');
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  String _getNrkId() {
    final norkaProvider = Provider.of<NorkaProvider>(context, listen: false);
    return norkaProvider.norkaId;
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final fileSizeInBytes = await file.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        
        // Check if file size exceeds 3 MB
        if (fileSizeInMB > 3) {
          ToastMessage.failedToast('File size must be less than 3 MB');
          return;
        }
        
        setState(() {
          _selectedFile = file;
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      ToastMessage.failedToast('Error selecting file');
    }
  }

  Future<void> _uploadDocument() async {
    if (_selectedFile == null) {
      ToastMessage.failedToast('Please select a file');
      return;
    }

    if (_labelController.text.trim().isEmpty) {
      ToastMessage.failedToast('Please enter the Type');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final nrkId = _getNrkId();
      final response = await DocumentService.uploadDocument(
        nrkId: nrkId,
        label: _labelController.text.trim(),
        filePath: _selectedFile!.path,
      );

      if (response['status'] == 'success') {
        ToastMessage.successToast(response['message'] ?? 'Document uploaded successfully');
        
        // Clear form
        _labelController.clear();
        setState(() {
          _selectedFile = null;
          _selectedFileName = null;
        });

        // Refresh documents list
        await _fetchDocuments();
      } else {
        ToastMessage.failedToast(response['message'] ?? 'Upload failed');
      }
    } catch (e) {
      debugPrint('Error uploading document: $e');
      ToastMessage.failedToast('Failed to upload document');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _fetchDocuments() async {
    setState(() => _isLoading = true);

    try {
      final nrkId = _getNrkId();
      final response = await DocumentService.fetchDocuments(nrkId);

      if (response['status'] == 'success') {
        setState(() {
          _documents = List<Map<String, dynamic>>.from(response['data'] ?? []);
        });
      }
    } catch (e) {
      debugPrint('Error fetching documents: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDocument(int documentId, String label) async {
    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode
              ? AppConstants.boxBlackColor
              : AppConstants.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: AppText(
            text: 'Delete Document',
            size: 20,
            weight: FontWeight.bold,
            textColor: isDarkMode
                ? AppConstants.whiteColor
                : AppConstants.blackColor,
          ),
          content: AppText(
            text: 'Are you sure you want to delete "$label"?',
            size: 16,
            weight: FontWeight.normal,
            textColor: AppConstants.greyColor,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: AppText(
                text: 'Cancel',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.greyColor,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText(
                text: 'Delete',
                size: 16,
                weight: FontWeight.w500,
                textColor: AppConstants.whiteColor,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final response = await DocumentService.deleteDocument(documentId);

      if (response['status'] == 'success') {
        ToastMessage.successToast(response['message'] ?? 'Document deleted successfully');
        await _fetchDocuments();
      } else {
        ToastMessage.failedToast(response['message'] ?? 'Delete failed');
      }
    } catch (e) {
      debugPrint('Error deleting document: $e');
      ToastMessage.failedToast('Failed to delete document');
    }
  }

  Future<void> _openDocument(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ToastMessage.failedToast('Could not open document');
    }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppText(
          text: 'My Documents',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Section
              _buildUploadSection(isDarkMode),
              
              const SizedBox(height: 30),
              
              // Documents List Section
              _buildDocumentsListSection(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(bool isDarkMode) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cloud_upload,
                color: AppConstants.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              AppText(
                text: 'Upload Document',
                size: 18,
                weight: FontWeight.bold,
                textColor: isDarkMode
                    ? AppConstants.whiteColor
                    : AppConstants.blackColor,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Document Label Input
          AppText(
            text: 'Document Type',
            size: 14,
            weight: FontWeight.w500,
            textColor: AppConstants.greyColor,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _labelController,
            style: TextStyle(
              color: isDarkMode 
                  ? AppConstants.whiteColor 
                  : AppConstants.blackColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Bank Passbook, etc.',
              hintStyle: TextStyle(
                color: AppConstants.greyColor.withOpacity(0.5),
                fontSize: 14,
              ),
              filled: true,
              fillColor: isDarkMode 
                  ? AppConstants.darkBackgroundColor 
                  : AppConstants.whiteColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppConstants.primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppConstants.primaryColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppConstants.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // File Selection
          AppText(
            text: 'Select File',
            size: 14,
            weight: FontWeight.w500,
            textColor: AppConstants.greyColor,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickFile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? AppConstants.darkBackgroundColor 
                    : AppConstants.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppConstants.primaryColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedFile != null
                        ? Icons.check_circle
                        : Icons.attach_file,
                    size: 20,
                    color: _selectedFile != null
                        ? AppConstants.greenColor
                        : AppConstants.greyColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      text: _selectedFileName ?? 'Choose file - Max 3 MB',
                      size: 14,
                      weight: FontWeight.normal,
                      textColor: _selectedFile != null
                          ? (isDarkMode 
                              ? AppConstants.whiteColor 
                              : AppConstants.blackColor)
                          : AppConstants.greyColor,
                    ),
                  ),
                  if (_selectedFile != null)
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close,
                        color: AppConstants.redColor,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedFile = null;
                          _selectedFileName = null;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Upload Button
          CustomButton(
            text: _isUploading ? 'Uploading...' : 'Upload Document',
            onPressed: _isUploading ? () {} : _uploadDocument,
            color: AppConstants.primaryColor,
            textColor: AppConstants.whiteColor,
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsListSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.folder_open,
              color: AppConstants.secondaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            AppText(
              text: 'Uploaded Documents',
              size: 18,
              weight: FontWeight.bold,
              textColor: isDarkMode
                  ? AppConstants.whiteColor
                  : AppConstants.blackColor,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryColor,
            ),
          )
        else if (_documents.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
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
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.folder_off,
                    size: 60,
                    color: AppConstants.greyColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'No documents uploaded yet',
                    size: 16,
                    weight: FontWeight.normal,
                    textColor: AppConstants.greyColor,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _documents.length,
            itemBuilder: (context, index) {
              final doc = _documents[index];
              return _buildDocumentCard(doc, isDarkMode);
            },
          ),
      ],
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> doc, bool isDarkMode) {
    final String label = doc['label'] ?? 'Untitled';
    final String fileName = doc['filename'] ?? '';
    final String documentUrl = doc['document_url'] ?? '';
    final int documentId = doc['documentId'] ?? 0;
    final String uploadedAt = doc['uploaded_at'] ?? '';

    // Parse date
    String formattedDate = '';
    if (uploadedAt.isNotEmpty) {
      try {
        final date = DateTime.parse(uploadedAt);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        formattedDate = '';
      }
    }

    // Get file extension
    String fileExtension = '';
    if (fileName.isNotEmpty) {
      final parts = fileName.split('.');
      if (parts.length > 1) {
        fileExtension = parts.last.toUpperCase();
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // File Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: fileExtension == 'PDF'
                  ? Icon(Icons.picture_as_pdf, color: AppConstants.redColor, size: 28)
                  : fileExtension == 'JPG' || fileExtension == 'JPEG' || fileExtension == 'PNG'
                      ? Icon(Icons.image, color: AppConstants.primaryColor, size: 28)
                      : Icon(Icons.description, color: AppConstants.primaryColor, size: 28),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Document Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: label,
                  size: 16,
                  weight: FontWeight.w600,
                  textColor: isDarkMode
                      ? AppConstants.whiteColor
                      : AppConstants.blackColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  text: fileName,
                  size: 12,
                  weight: FontWeight.normal,
                  textColor: AppConstants.greyColor,
                ),
                if (formattedDate.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  AppText(
                    text: 'Uploaded: $formattedDate',
                    size: 11,
                    weight: FontWeight.normal,
                    textColor: AppConstants.greyColor,
                  ),
                ],
              ],
            ),
          ),
          
          // Actions
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: AppConstants.primaryColor,
                ),
                onPressed: () => _openDocument(documentUrl),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: AppConstants.redColor,
                ),
                onPressed: () => _deleteDocument(documentId, label),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
