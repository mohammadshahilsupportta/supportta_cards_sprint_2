import 'package:flutter/material.dart';
import 'package:taproot_admin/features/auth_screen/data/auth_service.dart';

import 'package:taproot_admin/features/side_nav_screen/view/side_drawer_nav_screen.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';
import '../widgets/login_card.dart';
import '/exporter/exporter.dart';

class AuthScreen extends StatefulWidget {
  static const String path = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obsecureText = true;
  bool isLoading = false;

  final TextEditingController emailController =
      TextEditingController()..text = 'admin@supporttacards.com';
  final TextEditingController passwordController =
      TextEditingController()..text = 'Admin@Supportta987';

  void _toggleObscureText() {
    setState(() => _obsecureText = !_obsecureText);
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      final success = await AuthService.loginAdmin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (success) {
        Navigator.of(context).pushReplacementNamed(SideDrawerNavScreen.path);
      } else {
        setState(() => isLoading = false);
        SnackbarHelper.showError(
          context,
          'Login failed: Invalid or expired token',
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      SnackbarHelper.showError(context, 'Login failed: $e');
    }
  }

  // Future<void> _handleLogin() async {
  //   if (!(_formKey.currentState?.validate() ?? false)) return;

  //   setState(() => isLoading = true);
  //   try {
  //     await AuthService.loginAdmin(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //     Navigator.of(context).pushReplacementNamed(SideDrawerNavScreen.path);
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeUtils.width;
    final screenHeight = SizeUtils.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CustomColors.borderGradient),
        child: Center(
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : LoginCard(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    formKey: _formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                    obsecureText: _obsecureText,
                    toggleObscureText: _toggleObscureText,
                    onLoginPressed: _handleLogin,
                  ),
        ),
      ),
    );
  }
}
