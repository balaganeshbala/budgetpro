import 'package:budgetpro/pages/home/bloc/home_bloc.dart';
import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';

Widget _budgetListItem(BudgetModel budget, GestureTapCallback onTap) {
  final percentageSpent = (budget.spentAmount / budget.budgetAmount);
  final isEnabled = budget.budgetAmount > 0 || budget.spentAmount > 0;
  final amountToShow = budget.budgetAmount >= budget.spentAmount
      ? budget.budgetAmount.round()
      : (-(budget.spentAmount - budget.budgetAmount)).toStringAsFixed(2);

  return ListTile(
    enabled: isEnabled,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    onTap: () {
      onTap();
    },
    dense: true,
    leading: Container(
      decoration: BoxDecoration(
          color: isEnabled
              ? UIUtils.colorForCategory(budget.category).withAlpha(40)
              : AppColors.iconColor.withAlpha(10),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.all(5),
      child: Icon(
        UIUtils.iconForCategory(budget.category),
        color: isEnabled
            ? UIUtils.colorForCategory(budget.category)
            : AppColors.iconColor.withAlpha(50),
      ),
    ),
    title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              Text(budget.category,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer()
            ],
          ),
          Row(children: [const Spacer(), Text('$amountToShow')]),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(5),
            value: (budget.spentAmount / budget.budgetAmount).clamp(0.0, 1.0),
            minHeight: 10.0,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(percentageSpent > 1
                ? AppColors.dangerColor
                : isEnabled
                    ? AppColors.primaryColor
                    : Colors.transparent),
          ),
        ])),
    trailing: const Icon(Icons.keyboard_arrow_right),
  );
}

class BudgetListWidget extends StatelessWidget {
  final List<BudgetModel> budget;
  final HomeBloc homeBloc;

  const BudgetListWidget(
      {super.key, required this.budget, required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: budget.length,
          itemBuilder: (context, index) {
            return Column(children: [
              _budgetListItem(budget[index], () {
                homeBloc.add(
                    HomeBudgetCategoryItemTappedEvent(budget: budget[index]));
              }),
              Container(
                height: 1,
                color: Colors.grey.shade300,
              )
            ]);
          },
        ),
      ),
    );
  }
}
