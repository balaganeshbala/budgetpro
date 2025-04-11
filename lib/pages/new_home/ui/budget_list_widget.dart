import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_bloc.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

Widget _budgetListItem(
    CategorizedBudgetModel budget, GestureTapCallback onTap) {
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
              ? budget.category.color.withAlpha(40)
              : AppColors.iconColor.withAlpha(10),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.all(5),
      child: Icon(
        budget.category.icon,
        color: isEnabled
            ? budget.category.color
            : AppColors.iconColor.withAlpha(50),
      ),
    ),
    title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              Text(budget.category.displayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: "Sora")),
              const Spacer()
            ],
          ),
          Row(children: [
            const Spacer(),
            Text('$amountToShow', style: const TextStyle(fontFamily: "Sora"))
          ]),
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
  final List<CategorizedBudgetModel> budget;
  final NewHomeBloc homeBloc;

  const BudgetListWidget(
      {super.key, required this.budget, required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ], borderRadius: BorderRadius.circular(16), color: Colors.white),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: budget.length,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFDDDDDD),
            );
          },
          itemBuilder: (context, index) {
            return Column(children: [
              _budgetListItem(budget[index], () {
                homeBloc.add(
                    HomeBudgetCategoryItemTappedEvent(budget: budget[index]));
              })
            ]);
          },
        ),
      ),
    );
  }
}
