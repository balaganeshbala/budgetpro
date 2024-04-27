import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime? defaultDate;
  final ValueChanged<DateTime> onChanged;

  const DatePickerWidget(
      {super.key, required this.defaultDate, required this.onChanged});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.defaultDate;
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.primaryColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
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
    return SizedBox(
      height: 45,
      child: TextButton(
        style: ButtonStyle(
            foregroundColor:
                const WidgetStatePropertyAll<Color>(AppColors.primaryColor),
            backgroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Set corner radius here
              ),
            )),
        onPressed: () => _selectDate(context),
        child: Text(_selectedDate == null
            ? 'Select Date'
            : _selectedDate!.toString().substring(0, 10)),
      ),
    );
  }
}
