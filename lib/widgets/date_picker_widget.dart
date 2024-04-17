import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final ValueChanged<DateTime> onChanged;

  const DatePickerWidget({super.key, required this.onChanged});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(context),
      child: Text(_selectedDate == null
          ? 'Select Date'
          : _selectedDate!.toString().substring(0, 10)),
    );
  }
}
