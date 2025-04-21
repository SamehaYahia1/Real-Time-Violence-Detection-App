import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    Key? key,
    this.validator,
    required this.controller,
    required this.label,
    this.errorText,
    this.onChanged,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onChanged: widget.onChanged,
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 12),
              child: Text(
                widget.errorText!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
