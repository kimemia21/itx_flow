import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final Function(String?) onSaved;
  final String? Function(String?) validator;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final double width;

  CustomTextFormField({
    required this.labelText,
    required this.hintText,
    required this.onSaved,
    required this.validator,
    this.isPassword = false,
    this.controller,
    this.obscureText = false,
    this.toggleVisibility,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0), // Space between label and input field
        SizedBox(
          width: width, // Set width of the TextFormField here
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.brown, // Hint text color
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
               horizontal: 12.0,
                vertical: 16.0,
              ), // Padding inside the text field
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded edges
                borderSide: BorderSide(
                  color: Colors.brown.withOpacity(0.3), // Border color
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded edges on focus
                borderSide: const BorderSide(
                  color: Colors.brown, // Change color when the field is focused
                  width: 2.0,
                ),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: toggleVisibility,
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    )
                  : null,
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}
