import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class OtpInputField extends StatefulWidget {
  final String code;
  final ValueChanged<String> onChanged;
  final bool isLoading;

  const OtpInputField({
    required this.code,
    required this.onChanged,
    required this.isLoading,
    super.key,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());

    // Initialize controllers with existing code
    for (int i = 0; i < widget.code.length && i < 6; i++) {
      _controllers[i].text = widget.code[i];
    }
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

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      // Move to next field
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      _focusNodes[index - 1].requestFocus();
    }

    // Combine all values and call onChanged
    String fullCode = _controllers.map((c) => c.text).join();
    widget.onChanged(fullCode);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 40,
          height: 50,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            enabled: !widget.isLoading,
            textAlign: TextAlign.center,
            cursorColor: AppColors.black,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54, // 🔧 unselected underline
                  width: 2,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.3), // 🔧 matches 'border'
                  width: 1.5,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.black,
                  width: 2,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) => _onChanged(value, index),
            onTap: () {
              // Select all text when tapped
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            },
          ),
        );
      }),
    );
  }
}