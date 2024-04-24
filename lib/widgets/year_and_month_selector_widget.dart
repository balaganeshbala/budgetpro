import 'package:budgetpro/pages/home/bloc/home_bloc.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';

class YearAndMonthSelectorWidget extends StatefulWidget {
  const YearAndMonthSelectorWidget({
    super.key,
    required this.yearsList,
    required this.monthsList,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onYearChanged,
    required this.onMonthChanged,
  });

  final List<String> yearsList;
  final List<String> monthsList;
  final String selectedYear;
  final String selectedMonth;
  final ValueChanged<String> onYearChanged;
  final ValueChanged<String> onMonthChanged;

  @override
  State<YearAndMonthSelectorWidget> createState() =>
      _YearAndMonthSelectorWidgetState();
}

class _YearAndMonthSelectorWidgetState
    extends State<YearAndMonthSelectorWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        DropdownWidget(
            items: widget.yearsList,
            selectedItem: widget.selectedYear,
            onChanged: (value) {
              if (value != null) {
                widget.onYearChanged(value);
              }
            }),
        const Spacer(),
        DropdownWidget(
            items: widget.monthsList,
            selectedItem: widget.selectedMonth,
            onChanged: (value) {
              if (value != null) {
                widget.onMonthChanged(value);
              }
            })
      ]),
    );
  }
}
