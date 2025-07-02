import 'package:flutter/material.dart';
import 'package:taproot_admin/features/auth_screen/widgets/auth_text_field.dart';

import '../../../constants/constants.dart';
import '../../../widgets/loading_button.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obsecureText;
  final VoidCallback toggleObscureText;
  final VoidCallback onLoginPressed;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obsecureText,
    required this.toggleObscureText,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('LOGO'),
          AuthTextField(controller: emailController, type: AuthFieldType.email),
          CustomGap.gapLarge,
          AuthTextField(
            controller: passwordController,
            type: AuthFieldType.password,
            obsecureText: obsecureText,
            toggleObscureText: toggleObscureText,
          ),
          CustomGap.gapLarge,
          LoadingButton(
            backgroundColor: Colors.black,
            buttonLoading: false,
            text: "Login",
            onPressed: onLoginPressed,
          ),
        ],
      ),
    );
  }
}
