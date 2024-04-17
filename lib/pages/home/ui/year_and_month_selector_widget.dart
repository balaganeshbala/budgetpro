import 'package:budgetpro/pages/home/bloc/home_bloc.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';

class YearAndMonthSelectorWidget extends StatelessWidget {
  final List<String> yearsList;
  final List<String> monthsList;
  final String selectedYear;
  final String selectedMonth;
  final HomeBloc homeBloc;

  const YearAndMonthSelectorWidget({
    super.key,
    required this.yearsList,
    required this.monthsList,
    required this.selectedYear,
    required this.selectedMonth,
    required this.homeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        DropdownWidget(
            items: yearsList,
            selectedItem: selectedYear,
            onChanged: (value) {
              if (value != null) {
                homeBloc.add(HomeYearChangedEvent(year: value));
              }
            }),
        const Spacer(),
        DropdownWidget(
            items: monthsList,
            selectedItem: selectedMonth,
            onChanged: (value) {
              if (value != null) {
                homeBloc.add(
                    HomeMonthChangedEvent(year: selectedYear, month: value));
              }
            })
      ]),
    );
  }
}
