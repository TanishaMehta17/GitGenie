import 'package:flutter/material.dart';
import 'package:gitgenie/common/colors.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: black10),
        hintText: hintText,
        hintStyle: const TextStyle(color: black10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black10),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.transparent,
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: black10),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
