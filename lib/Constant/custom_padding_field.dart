import 'package:flutter/material.dart';

class CustomPaddingField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomPaddingField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<CustomPaddingField> createState() => _CustomPaddingFieldState();
}

class _CustomPaddingFieldState extends State<CustomPaddingField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextFormField(
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        style: const TextStyle(color: Colors.white),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
