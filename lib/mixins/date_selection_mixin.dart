import 'package:flutter/material.dart';
// import '../exporter.dart';

import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String get dateFormat => DateFormat('yyyy-MM-dd').format(this);
}

class DateSelectionField extends StatefulWidget {
  final String? title;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onChanged;
  final String? Function(String?)? validator;
  final DateTime? initialDate;

  const DateSelectionField({
    super.key,
    this.title,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.validator,
    this.initialDate,
  });

  @override
  State<DateSelectionField> createState() => _DateSelectionFieldState();
}

class _DateSelectionFieldState extends State<DateSelectionField> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      firstDate: widget.firstDate ?? now,
      lastDate: widget.lastDate ?? now.add(const Duration(days: 365)),
      initialDate: selectedDate ?? now,
    );
    if (result != null) {
      setState(() => selectedDate = result);
      widget.onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      validator: widget.validator,
      onTap: _pickDate,
      controller: TextEditingController(
        text: selectedDate?.dateFormat ?? "",
      ),
      decoration: InputDecoration(
        label: Text(widget.title ?? "Date"),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }
}

  // DateTime? secondaryDate;
  // pickDateSecondary({
  //   required DateTime firstDate,
  //   required DateTime lastDate,
  // }) async {
  //   var result = await showDatePicker(
  //     context: context,
  //     firstDate: now,
  //     lastDate: now.add(
  //       const Duration(
  //         days: 60,
  //       ),
  //     ),
  //   );
  //   if (result == null) return;
  //   secondaryDate = result;
  //   setState(() {});
  // }

  // Widget dateSelectionFieldSecondary({String? title}) => TextFormField(
  //       onTap: pickDateSecondary,
  //       readOnly: true,
  //       controller: TextEditingController(
  //         text: secondaryDate == null
  //             ? ""
  //             : dateFormat.format(
  //                 secondaryDate!,
  //               ),
  //       ),
  //       decoration: InputDecoration(
  //         label: Text(title ?? "Date"),
  //       ),
  //     );
  // DateTime? thirdDate;
  // pickDatethirdDate({
  //   required DateTime firstDate,
  //   required DateTime lastDate,
  // }) async {
  //   var result = await showDatePicker(
  //     context: context,
  //     firstDate: now,
  //     lastDate: now.add(
  //       const Duration(
  //         days: 60,
  //       ),
  //     ),
  //   );
  //   if (result == null) return;
  //   thirdDate = result;
  //   setState(() {});
  // }

  // Widget dateSelectionFieldthirdDate({String? title}) => TextFormField(
  //       onTap: pickDatethirdDate,
  //       readOnly: true,
  //       controller: TextEditingController(
  //         text: thirdDate == null
  //             ? ""
  //             : dateFormat.format(
  //                 thirdDate!,
  //               ),
  //       ),
  //       decoration: InputDecoration(
  //         label: Text(title ?? "Date"),
  //       ),
  //     );

