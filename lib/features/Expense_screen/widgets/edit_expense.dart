import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Expense_screen/data/expense_model.dart';
import 'package:taproot_admin/features/Expense_screen/data/expense_service.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/common_product_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class EditExpense extends StatefulWidget {
  final Expense expense;

  const EditExpense({super.key, required this.expense});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final _formKey = GlobalKey<FormState>();
  String? category;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    category = widget.expense.category;
    _nameController.text = widget.expense.name;
    _amountController.text = '₹${widget.expense.amount}';
    _dateController.text = DateFormat('dd/MM/yyyy').format(widget.expense.date);
    _descriptionController.text = widget.expense.description;
  }

  Future<void> _handleEditExpense() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool hasChanges = false;
        setState(() => _isLoading = true);

        final double parsedAmount =
            double.tryParse(
              _amountController.text.replaceAll('₹', '').trim(),
            ) ??
            0.0;

        final dateParts = _dateController.text.split('/');
        if (dateParts.length != 3) {
          throw Exception('Invalid date format');
        }

        final date = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
        );
        if (category != widget.expense.category) hasChanges = true;
        if (_nameController.text != widget.expense.name) hasChanges = true;
        if (parsedAmount != widget.expense.amount) hasChanges = true;
        if (DateFormat('dd/MM/yyyy').format(date) !=
            DateFormat('dd/MM/yyyy').format(widget.expense.date)) {
          hasChanges = true;
        }
        if (_descriptionController.text != widget.expense.description) {
          hasChanges = true;
        }
        if (!hasChanges) {
          if (mounted) {
            SnackbarHelper.showInfo(context, 'No changes were made');
            Navigator.pop(context, false);
          }
          return;
        }
        await ExpenseService.editExpense(
          expense: widget.expense,
          category: category,
          name: _nameController.text,
          amount: parsedAmount,
          date: date,
          description: _descriptionController.text,
        );

        if (mounted) {
          SnackbarHelper.showSuccess(context, 'Expense updated successfully');
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          SnackbarHelper.showError(context, 'Failed to update expense: $e');
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
                  text: 'Update', // Changed from 'Add' to 'Update'
                  onPressed: _handleEditExpense,
                  isLoading: _isLoading,
                  useGradient: true,
                  gradientColors: CustomColors.borderGradient.colors,
                ),
                Gap(CustomPadding.paddingXL.v),
              ],
            ),
            Gap(CustomPadding.paddingLarge.v),
            CommonProductContainer(
              title:
                  'Edit Expense', // Changed from 'Add Expense' to 'Edit Expense'
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
                          value: category, // Set initial value
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
