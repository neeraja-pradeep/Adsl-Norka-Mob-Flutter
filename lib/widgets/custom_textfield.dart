import 'package:norkacare_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool enabled;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

  const CustomTextfield({
    this.labelText,
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
      ),
      cursorColor: AppConstants.primaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? AppConstants.darkBackgroundColor : Colors.white,
        labelText: widget.hintText,
        labelStyle: TextStyle(
          color: isDarkMode ? AppConstants.whiteColor : AppConstants.blackColor,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: AppConstants.greyColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppConstants.primaryColor.withOpacity(0.5)
                : AppConstants.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppConstants.primaryColor, width: 1.6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode
                ? AppConstants.primaryColor.withOpacity(0.5)
                : AppConstants.primaryColor,
          ),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppConstants.primaryColor)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppConstants.primaryColor,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              )
            : (widget.suffixIcon != null
                  ? Icon(
                      widget.suffixIcon,
                      color: isDarkMode
                          ? AppConstants.greyColor
                          : Colors.grey[700],
                    )
                  : null),
      ),
    );
  }
}
