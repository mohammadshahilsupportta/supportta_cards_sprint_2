import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_service.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class AddUserDialog extends StatefulWidget {
  final VoidCallback onCallFunction;
  const AddUserDialog({super.key, required this.onCallFunction});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  Future<void> addUser(BuildContext currentContext) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await UserService.createUser(
        userData: {'name': nameController.text, 'email': emailController.text},
      );

      if (!mounted) return;

      Navigator.pop(currentContext);

      widget.onCallFunction();
      SnackbarHelper.showSuccess(currentContext, 'User added successfully!');
      // ScaffoldMessenger.of(
      //   currentContext,
      // ).showSnackBar(const SnackBar(content: Text('User added successfully!')));
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Dialog(
        child: SizedBox(
          width: 600.v,
          height: 370.v,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 70.v,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(CustomPadding.paddingLarge.v),
                    topRight: Radius.circular(CustomPadding.paddingLarge.v),
                  ),
                  color: CustomColors.buttonColor1,
                ),
                child: Row(
                  children: [
                    Spacer(),

                    Text(
                      'Add User',
                      style: context.inter60014.copyWith(
                        color: CustomColors.backgroundColor,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: CustomColors.backgroundColor,
                      ),
                    ),
                    Gap(CustomPadding.paddingLarge.v),
                  ],
                ),
              ),

              Gap(CustomPadding.paddingXL.v),

              TextFormContainer(
                labelText: 'Full Name',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              Gap(CustomPadding.paddingLarge.v),
              TextFormContainer(
                labelText: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }

                  if (RegExp(r'^\d').hasMatch(value)) {
                    return 'Email should not start with a number';
                  }

                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),
              Gap(CustomPadding.paddingLarge.v),

              MiniLoadingButton(
                needRow: false,
                text: 'Add',
                isLoading: isLoading,
                enabled: !isLoading,
                onPressed: () => addUser(context),
                useGradient: true,
                gradientColors: CustomColors.borderGradient.colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
