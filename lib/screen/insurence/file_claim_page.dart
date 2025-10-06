import 'dart:io';
import 'package:flutter/material.dart';
import 'package:norkacare_app/utils/constants.dart';
import 'package:norkacare_app/widgets/app_text.dart';
import 'package:norkacare_app/widgets/custom_button.dart';
import 'package:norkacare_app/widgets/custom_textfield.dart';
import 'package:norkacare_app/widgets/toast_message.dart';

class FileClaimPage extends StatefulWidget {
  const FileClaimPage({super.key});

  @override
  State<FileClaimPage> createState() => _FileClaimPageState();
}

class _FileClaimPageState extends State<FileClaimPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController policyNumberController = TextEditingController();
  final TextEditingController enrollmentIdController = TextEditingController();
  final TextEditingController masterNameController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController claimAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  // Bank Account Details
  final TextEditingController accountHolderNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  
  // Health Insurance Fields
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  
  // Selected values
  DateTime? selectedDate;
  DateTime? admissionDate;
  DateTime? dischargeDate;
  
  List<String> uploadedDocuments = [];
  
  final List<String> documentTypes = [
    'Hospital Bill',
    'Medical Certificate',
    'Prescription',
    'Discharge Summary',
    'X-Ray Reports',
    'Lab Reports',
    'Identity Proof',
    'E Card',
  ];

  @override
  void dispose() {
    policyNumberController.dispose();
    enrollmentIdController.dispose();
    masterNameController.dispose();
    patientNameController.dispose();
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    claimAmountController.dispose();
    descriptionController.dispose();
    hospitalNameController.dispose();
    doctorNameController.dispose();
    remarksController.dispose();
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

  void _submitClaim() {
    if (_formKey.currentState!.validate()) {
      if (admissionDate == null) {
        ToastMessage.failedToast('Please select admission date');
        return;
      }
      
      if (uploadedDocuments.isEmpty) {
        ToastMessage.failedToast('Please upload at least one document');
        return;
      }
      
      // Show success dialog
      _showSuccessDialog();
    }
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
              const SizedBox(height: 8),
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
                              const SizedBox(height: 16),
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

  void _showDocumentPicker() {
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
                    text: 'Upload Document',
                    size: 18,
                    weight: FontWeight.bold,
                    textColor: isDarkMode
                        ? AppConstants.whiteColor
                        : AppConstants.blackColor,
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: documentTypes.length,
                    itemBuilder: (context, index) {
                      final docType = documentTypes[index];
                      final isUploaded = uploadedDocuments.contains(docType);
                      
                      return ListTile(
                        leading: Icon(
                          isUploaded ? Icons.check_circle : Icons.description,
                          color: isUploaded
                              ? AppConstants.greenColor
                              : AppConstants.primaryColor,
                        ),
                        title: AppText(
                          text: docType,
                          size: 16,
                          weight: FontWeight.w500,
                          textColor: isDarkMode
                              ? AppConstants.whiteColor
                              : AppConstants.blackColor,
                        ),
                        trailing: isUploaded
                            ? Icon(Icons.check, color: AppConstants.greenColor)
                            : null,
                        onTap: () {
                          setState(() {
                            if (!uploadedDocuments.contains(docType)) {
                              uploadedDocuments.add(docType);
                            }
                          });
                          Navigator.pop(context);
                          ToastMessage.successToast('$docType added');
                        },
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
              
              const SizedBox(height: 24),
              
              // Policy Details Section
              _buildSectionTitle('Policy Details'),
              const SizedBox(height: 16),
              
              // Policy Number
              _buildLabel('Policy Number'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: policyNumberController,
                hintText: 'Enter policy number',
                prefixIcon: Icons.badge,
                keyboardType: TextInputType.text,
              ),
              
              const SizedBox(height: 16),
              
              // Enrollment ID
              _buildLabel('Enrollment ID'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: enrollmentIdController,
                hintText: 'Enter enrollment ID',
                prefixIcon: Icons.confirmation_number,
                keyboardType: TextInputType.text,
              ),
              
              const SizedBox(height: 24),
              
              // Member Details Section
              _buildSectionTitle('Member Details'),
              const SizedBox(height: 16),
              
              // Master Name
              _buildLabel('Master Name (Policy Holder)'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: masterNameController,
                hintText: 'Enter master name',
                prefixIcon: Icons.person,
              ),
              
              const SizedBox(height: 16),
              
              // Patient Name
              _buildLabel('Patient Name (Self/Family Member)'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: patientNameController,
                hintText: 'Enter patient name',
                prefixIcon: Icons.local_hospital_outlined,
              ),
              
              const SizedBox(height: 24),
              
              // Bank Account Details Section
              _buildSectionTitle('Bank Account Details'),
              const SizedBox(height: 16),
              
              // Account Holder Name
              _buildLabel('Account Holder Name'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: accountHolderNameController,
                hintText: 'Enter account holder name',
                prefixIcon: Icons.account_circle,
              ),
              
              const SizedBox(height: 16),
              
              // Account Number
              _buildLabel('Account Number'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: accountNumberController,
                hintText: 'Enter account number',
                prefixIcon: Icons.account_balance,
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 16),
              
              // IFSC Code
              _buildLabel('IFSC Code'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: ifscCodeController,
                hintText: 'Enter IFSC code',
                prefixIcon: Icons.code,
                textCapitalization: TextCapitalization.characters,
              ),
              
              const SizedBox(height: 16),
              
              // Bank Name
              _buildLabel('Bank Name'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: bankNameController,
                hintText: 'Enter bank name',
                prefixIcon: Icons.account_balance_wallet,
              ),
              
              const SizedBox(height: 16),
              
              // Branch Name
              _buildLabel('Branch Name'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: branchNameController,
                hintText: 'Enter branch name',
                prefixIcon: Icons.location_on,
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
              
              const SizedBox(height: 24),
              
              // Claim Details Section
              _buildSectionTitle('Claim Details'),
              const SizedBox(height: 16),
              
              // Claim Amount
              _buildLabel('Claim Amount (₹)'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: claimAmountController,
                hintText: 'Enter claim amount',
                prefixIcon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 16),
              
              // Description
              _buildLabel('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
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
                  contentPadding: const EdgeInsets.all(16),
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
              
              const SizedBox(height: 24),
              
              // Hospital Details
              _buildSectionTitle('Hospital Details'),
              const SizedBox(height: 16),
              
              _buildLabel('Hospital/Clinic Name'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: hospitalNameController,
                hintText: 'Enter hospital name',
                prefixIcon: Icons.local_hospital,
              ),
              
              const SizedBox(height: 16),
              
              _buildLabel('Doctor Name'),
              const SizedBox(height: 8),
              CustomTextfield(
                controller: doctorNameController,
                hintText: 'Enter doctor name',
                prefixIcon: Icons.person,
              ),
              
              const SizedBox(height: 16),
              
              _buildLabel('Admission Date'),
              const SizedBox(height: 8),
              _buildDatePicker(
                context: context,
                isDarkMode: isDarkMode,
                selectedDate: admissionDate,
                dateType: 'admission',
                placeholder: 'Select admission date',
              ),
              
              const SizedBox(height: 16),
              
              _buildLabel('Discharge Date (if applicable)'),
              const SizedBox(height: 8),
              _buildDatePicker(
                context: context,
                isDarkMode: isDarkMode,
                selectedDate: dischargeDate,
                dateType: 'discharge',
                placeholder: 'Select discharge date',
              ),
              
              const SizedBox(height: 24),
              
              // Documents Section
              _buildSectionTitle('Upload Documents'),
              const SizedBox(height: 16),
              
              // Upload Button
              InkWell(
                onTap: _showDocumentPicker,
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(height: 12),
                      AppText(
                        text: 'Upload Documents',
                        size: 16,
                        weight: FontWeight.w600,
                        textColor: AppConstants.primaryColor,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        text: 'Tap to select documents',
                        size: 14,
                        weight: FontWeight.normal,
                        textColor: AppConstants.greyColor,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Uploaded Documents List
              if (uploadedDocuments.isNotEmpty) ...[
                AppText(
                  text: 'Uploaded Documents (${uploadedDocuments.length})',
                  size: 14,
                  weight: FontWeight.w600,
                  textColor: AppConstants.greyColor,
                ),
                const SizedBox(height: 12),
                ...uploadedDocuments.map((doc) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppConstants.boxBlackColor
                          : AppConstants.whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: AppConstants.greenColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppText(
                            text: doc,
                            size: 14,
                            weight: FontWeight.w500,
                            textColor: isDarkMode
                                ? AppConstants.whiteColor
                                : AppConstants.blackColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppConstants.redColor,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              uploadedDocuments.remove(doc);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
              
              // Additional Remarks
              const SizedBox(height: 8),
              _buildLabel('Additional Remarks (Optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: remarksController,
                maxLines: 3,
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
                  hintText: 'Any additional information...',
                  hintStyle: TextStyle(color: AppConstants.greyColor),
                  contentPadding: const EdgeInsets.all(16),
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
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              CustomButton(
                text: 'Submit Claim',
                onPressed: _submitClaim,
                color: AppConstants.primaryColor,
                textColor: AppConstants.whiteColor,
                height: 55,
              ),
              
              const SizedBox(height: 20),
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
          vertical: 18,
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
}
