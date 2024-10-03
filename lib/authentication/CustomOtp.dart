import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomOtpTextField extends StatefulWidget {
  final int numberOfFields;
  final double fieldWidth;
  final double fieldHeight;
  final TextStyle textStyle;
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Function(String) onCodeChanged;
  final Function(String) onSubmit;

  const CustomOtpTextField({
    Key? key,
    this.numberOfFields = 5,
    this.fieldWidth = 50.0,
    this.fieldHeight = 65.0,
    required this.textStyle,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.onCodeChanged,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CustomOtpTextFieldState createState() => _CustomOtpTextFieldState();
}

class _CustomOtpTextFieldState extends State<CustomOtpTextField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otpCode = "";

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.numberOfFields, (index) => TextEditingController());
    _focusNodes = List.generate(widget.numberOfFields, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged() {
    setState(() {
      _otpCode = _controllers.map((controller) => controller.text).join();
      widget.onCodeChanged(_otpCode);
    });
  }

  void _submitOtp() {
    widget.onSubmit(_otpCode);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.numberOfFields, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          width: widget.fieldWidth,
          height: widget.fieldHeight,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.name,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: widget.textStyle,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: widget.borderRadius,
                borderSide: BorderSide(
                  color: widget.borderColor,
                  width: widget.borderWidth,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius,
                borderSide: BorderSide(
                  color: widget.focusedBorderColor,
                  width: widget.borderWidth,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < widget.numberOfFields - 1) {
                _focusNodes[index + 1].requestFocus(); // Move to next field
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus(); // Move to previous field if empty
              }
              _onOtpChanged(); // Update the OTP code
            },
            onFieldSubmitted: (value) {
              if (index == widget.numberOfFields - 1) {
                _submitOtp(); // Submit OTP when last field is filled
              }
            },
          ),
        );
      }),
    );
  }
}
