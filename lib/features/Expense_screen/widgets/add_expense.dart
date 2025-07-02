import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Expense_screen/data/expense_service.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/common_product_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();
  String? category;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(
    text: '₹',
  );
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleAddExpense() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        final double parsedAmount =
            double.tryParse(
              _amountController.text.replaceAll('₹', '').trim(),
            ) ??
            0.0;

        // Parse date from dd/mm/yyyy to DateTime
        final dateParts = _dateController.text.split('/');
        if (dateParts.length != 3) {
          throw Exception('Invalid date format');
        }

        final date = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
        );

         await ExpenseService.addExpense(
          category: category ?? '',
          name: _nameController.text,
          amount: parsedAmount,
          date: date,
          description: _descriptionController.text,
        );

        if (mounted) {
          SnackbarHelper.showSuccess(context, 'Expense added successfully');

          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          SnackbarHelper.showError(context, 'Failed to add expense: $e');
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Gap(CustomPadding.paddingLarge.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MiniGradientBorderButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  gradient: LinearGradient(
                    colors: CustomColors.borderGradient.colors,
                  ),
                ),
                Gap(CustomPadding.paddingLarge.v),
                MiniLoadingButton(
                  needRow: false,
                  text: 'Add',
                  onPressed: _handleAddExpense,
                  isLoading: _isLoading,
                  useGradient: true,
                  gradientColors: CustomColors.borderGradient.colors,
                ),
                Gap(CustomPadding.paddingXL.v),
              ],
            ),
            Gap(CustomPadding.paddingLarge.v),
            CommonProductContainer(
              title: 'Add Expense',
              children: [
                Gap(CustomPadding.paddingXL.v),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: CustomPadding.paddingLarge.v,
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: context.inter40016,
                            border: OutlineInputBorder(),
                          ),
                          items:
                              ['Order', 'Shop', 'Other'].map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() => category = value);
                            logInfo('Selected: $value');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormContainer(
                        controller: _nameController,
                        labelText:
                            category == 'Order' ? 'Order ID' : 'Expense Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }

                          if (category != 'Order') {
                            // If it's an expense name (not Order ID)
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return 'Only alphabets are allowed';
                            }
                          }

                          return null;
                        },
                      ),
                    ),

                    // Expanded(
                    //   child: TextFormContainer(
                    //     controller: _nameController,
                    //     labelText:
                    //         category == 'Order' ? 'Order ID' : 'Expense Name',
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please enter name';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                Gap(CustomPadding.paddingLarge.v),
                Row(
                  children: [
                    Expanded(
                      child: TextFormContainer(
                        controller: _amountController,
                        labelText: 'Amount',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[₹0-9.]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '₹') {
                            return 'Please enter amount';
                          }
                          final amount = double.tryParse(
                            value.replaceAll('₹', '').trim(),
                          );
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormContainer(
                        controller: _dateController,
                        isDatePicker: true,
                        labelText: 'Date',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Gap(CustomPadding.paddingLarge.v),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormContainer(
                        controller: _descriptionController,
                        maxline: 6,
                        labelText: 'Description',
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                Gap(CustomPadding.paddingXL.v),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class _AddExpenseState extends State<AddExpense> {
//   final _formKey = GlobalKey<FormState>();
//   String? category;
//   String expenseName = '';
//   String amount = '';
//   String date = '';
//   String description = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Gap(CustomPadding.paddingLarge.v),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 MiniGradientBorderButton(
//                   text: 'Cancel',
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },

//                   gradient: LinearGradient(
//                     colors: CustomColors.borderGradient.colors,
//                   ),
//                 ),
//                 Gap(CustomPadding.paddingLarge.v),
//                 MiniLoadingButton(
//                   needRow: false,

//                   text: 'Add',
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       final newExpense = {
//                         'category': category ?? '',
//                         'name': expenseName,
//                         'amount': amount,
//                         'date': date,
//                         'description': description,
//                       };

//                       Navigator.pop(context, newExpense);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Please fill in all fields')),
//                       );
//                     }
//                   },
//                   useGradient: true,
//                   gradientColors: CustomColors.borderGradient.colors,
//                 ),
//                 Gap(CustomPadding.paddingXL.v),
//               ],
//             ),
//             Gap(CustomPadding.paddingLarge.v),
//             CommonProductContainer(
//               title: 'Add Expense',
//               children: [
//                 Gap(CustomPadding.paddingXL.v),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: CustomPadding.paddingLarge.v,
//                         ),
//                         child: DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             labelText: 'Category',
//                             labelStyle: context.inter40016,
//                             border: OutlineInputBorder(),
//                           ),
//                           items:
//                               ['order', 'shop', 'other'].map((String category) {
//                                 return DropdownMenuItem<String>(
//                                   value: category,
//                                   child: Text(category),
//                                 );
//                               }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               category = value;
//                             });
//                             logInfo('Selected: $value');
//                           },
//                           validator: (value) {
//                             value == null ? 'Please select a category' : null;
//                             return null;
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextFormContainer(
//                         initialValue: '',
//                         labelText:
//                             category == 'order' ? 'Order ID' : 'Expense Name',
//                         onChanged: (value) {
//                           setState(() {
//                             expenseName = value;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 Gap(CustomPadding.paddingLarge.v),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormContainer(
//                         initialValue: '₹',
//                         labelText: 'Amount',
//                         onChanged: (value) {
//                           setState(() {
//                             amount = value;
//                           });
//                         },
//                         validator: (value) {
//                           value == null || value.isEmpty
//                               ? 'Please enter Amount'
//                               : null;
//                           return null;
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: TextFormContainer(
//                         isDatePicker: true,

//                         initialValue: 'Select Date',
//                         labelText: 'Date',
//                         onChanged: (value) {
//                           setState(() {
//                             date = value;
//                           });
//                         },
//                         validator: (value) {
//                           value == null || value.isEmpty
//                               ? 'Please enter name'
//                               : null;
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 Gap(CustomPadding.paddingLarge.v),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: TextFormContainer(
//                         maxline: 6,
//                         initialValue: '',
//                         labelText: 'Description',
//                         onChanged: (value) {
//                           description = value;
//                         },
//                         validator: (value) {
//                           value == null || value.isEmpty
//                               ? 'Please enter name'
//                               : null;
//                           return null;
//                         },
//                       ),
//                     ),
//                     Expanded(child: SizedBox()),
//                   ],
//                 ),
//                 Gap(CustomPadding.paddingXL.v),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
