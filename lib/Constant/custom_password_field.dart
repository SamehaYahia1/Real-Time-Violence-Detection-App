import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.trim().isEmpty) return '${widget.label} is required';
          if (value.length < 5) return 'Password must be at least 5 characters';
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            onPressed: _toggleVisibility,
          ),
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
