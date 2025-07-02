import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';

class TextFormContainer extends StatefulWidget {
  final bool autofocus;
  final String? suffixText;
  final String? initialValue;
  final Widget? countryCodeWidget;
  final int maxline;
  final bool readonly;
  final String labelText;
  final User? user;
  final bool isDatePicker;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final bool isNumberField;

  const TextFormContainer({
    super.key,
    this.initialValue,

    this.countryCodeWidget,
    this.autofocus = false,
    this.suffixText,
    required this.labelText,
    this.user,
    this.readonly = false,
    this.maxline = 1,
    this.isDatePicker = false,
    this.onChanged,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.isNumberField = false,
  });

  @override
  State<TextFormContainer> createState() => _TextFormContainerState();
}

class _TextFormContainerState extends State<TextFormContainer> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formatted =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        _internalController.text = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: CustomPadding.paddingLarge.v,
        vertical: CustomPadding.padding.v,
      ),
      child: TextFormField(
        // scrollPhysics: const BouncingScrollPhysics(),
        autofocus: widget.autofocus,
        validator: widget.validator,
        onChanged: widget.onChanged,
        controller: _internalController,
        maxLines: widget.maxline,
        readOnly: widget.readonly || widget.isDatePicker,
        onTap: widget.isDatePicker ? _pickDate : null,
        decoration: InputDecoration(
          suffixText: widget.suffixText,
          prefix: widget.isNumberField ? widget.countryCodeWidget : null,
          // prefix: widget.isNumberField ? Text('+91 ') : null,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text(widget.labelText),
          labelStyle: TextStyle(color: CustomColors.textColorDarkGrey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.textColorLightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.textColorLightGrey),
          ),
        ),
        inputFormatters: widget.inputFormatters,
      ),
    );
  }
}


// class TextFormContainer extends StatelessWidget {
//   final String initialValue;
//   final int maxline;
//   final bool readonly;
//   final String labelText;
//   final User? user;
//   final bool isDatePicker;
//   const TextFormContainer({
//     super.key,
//     required this.initialValue,
//     required this.labelText,
//     this.user,
//     this.readonly = false,
//     this.maxline = 1,
//     this.isDatePicker=false
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: CustomPadding.paddingLarge.v,
//         vertical: CustomPadding.padding.v,
//       ),
//       child: TextFormField(
//         maxLines: maxline,
//         readOnly: readonly,
//         initialValue: initialValue,
//            onTap:
//             isDatePicker
//                 ? () async {
//                   final selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime(2100),
//                   );

//                   if (selectedDate != null) {
//                     // show selected date as snackbar or save via callback
//                     print('Selected date: $selectedDate');
//                     // You can use a controller or notify parent through a callback
//                   }
//                 }
//                 : null,
//         decoration: InputDecoration(
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           label: Text(labelText),
//           labelStyle: TextStyle(color: CustomColors.textColorDarkGrey),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: CustomColors.textColorLightGrey),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: CustomColors.textColorLightGrey),
//           ),
//         ),
//       ),
//     );
//   }
// }


// class TextFormContainer extends StatelessWidget {
//   final String? initialValue;
//   final bool readonly;
//   final String? labelText;
//   final User? user;

//   const TextFormContainer({
//     super.key,
//     this.initialValue,
//     this.labelText,
//     this.user,
//     this.readonly = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: CustomPadding.paddingLarge.v,
//         vertical: CustomPadding.padding.v,
//       ),
//       child: TextFormField(
//         readOnly: readonly,
//         initialValue: initialValue,
//         decoration: InputDecoration(
//           label: labelText != null ? Text(labelText!) : null,
//           labelStyle: TextStyle(color: CustomColors.textColorDarkGrey),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: CustomColors.textColorLightGrey),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: CustomColors.textColorLightGrey),
//           ),
//         ),
//       ),
//     );
//   }
// }
