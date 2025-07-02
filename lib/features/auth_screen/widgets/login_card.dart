import 'package:flutter/material.dart';
import 'package:taproot_admin/features/auth_screen/widgets/login_form.dart';

import '../../../exporter/exporter.dart';
import '../../../gen/assets.gen.dart';

class LoginCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obsecureText;
  final VoidCallback toggleObscureText;
  final VoidCallback onLoginPressed;

  const LoginCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obsecureText,
    required this.toggleObscureText,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomPadding.padding * 5),
      ),
      child: Container(
        width: screenWidth * 0.50,
        height: screenHeight * 0.7,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.2,
            center: const Alignment(-0.2, -0.25),
            colors: [const Color(0xFfFAAD4F), CustomColors.secondaryColor],
          ),
          borderRadius: BorderRadius.circular(CustomPadding.paddingLarge),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: screenHeight * 0.5,
                child: Image.asset(Assets.png.backgroundlog.path),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomPadding.paddingXL,
                ),
                child: LoginForm(
                  formKey: formKey,
                  emailController: emailController,
                  passwordController: passwordController,
                  obsecureText: obsecureText,
                  toggleObscureText: toggleObscureText,
                  onLoginPressed: onLoginPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
