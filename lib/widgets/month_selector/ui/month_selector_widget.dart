import 'package:budgetpro/utits/colors.dart';
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
        return ElevatedButton.icon(
          icon: const Icon(Icons.calendar_month, color: AppColors.accentColor),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: AppColors.accentColor,
            textStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "Sora"),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
          onPressed: () async {
            final selected = await showMonthPicker(
              context: context,
              initialDate: state.selectedValue,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primaryColor,
                    ),
                    primaryTextTheme: const TextTheme(
                      titleMedium: TextStyle(
                          fontFamily: "Sora", fontWeight: FontWeight.bold),
                      headlineSmall: TextStyle(
                          fontFamily: "Sora", fontWeight: FontWeight.w400),
                    ),
                    textTheme: const TextTheme(
                      labelLarge: TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors
                            .accentColor, // Set OK & Cancel button color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selected != null) {
              if (context.mounted) {
                context
                    .read<MonthSelectorBloc>()
                    .add(MonthSelectorChangedEvent(selectedValue: selected));
              }
            }
          },
          label: Text('${state.selectedMonth} - ${state.selectedYear}'),
        );
      },
    );
  }
}
