import 'package:budgetpro/widgets/month_selector/bloc/month_selector_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

class MonthSelectorWidget extends StatefulWidget {
  const MonthSelectorWidget({super.key});

  @override
  State<MonthSelectorWidget> createState() => _MonthSelectorWidgetState();
}

class _MonthSelectorWidgetState extends State<MonthSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonthSelectorBloc, MonthSelectorState>(
      builder: (context, state) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              // backgroundColor: AppColors.primaryColor,
              // foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            onPressed: () async {
              final selected = await showMonthPicker(
                  context: context,
                  initialDate: state.selectedValue,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now());
              if (selected != null) {
                if (context.mounted) {
                  context
                      .read<MonthSelectorBloc>()
                      .add(MonthSelectorChangedEvent(selectedValue: selected));
                }
              }
            },
            child: Text('${state.selectedMonth} - ${state.selectedYear}',
                style: const TextStyle(fontWeight: FontWeight.bold)));
      },
    );
  }
}
