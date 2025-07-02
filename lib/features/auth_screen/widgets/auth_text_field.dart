import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

enum AuthFieldType { email, password }

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final AuthFieldType type;
  final bool obsecureText;
  final VoidCallback? toggleObscureText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.type,
    this.obsecureText = false,
    this.toggleObscureText,
  });

  @override
  Widget build(BuildContext context) {
    final isPassword = type == AuthFieldType.password;
    final label = isPassword ? 'Password' : 'Email';

    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obsecureText : false,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: CustomColors.textColorGrey),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obsecureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleObscureText,
                )
                : null,
      ),
      validator:
          (value) =>
              value == null || value.isEmpty ? '$label is required' : null,
    );
  }
}
