import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChange;
  final String placeholder;

  PasswordInput({
    required this.value,
    required this.onChange,
    this.placeholder = "Password",
  });

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isShowPassword = false;

  void _toggleShowPassword() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: !_isShowPassword,
              onChanged: widget.onChange,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isShowPassword ? Icons.visibility : Icons.visibility_off,
              color: _isShowPassword ? Color(0xFF2B85FF) : Colors.grey.shade400,
            ),
            onPressed: _toggleShowPassword,
          ),
        ],
      ),
    );
  }
}
