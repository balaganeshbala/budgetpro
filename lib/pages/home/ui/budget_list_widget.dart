import 'package:budgetpro/pages/home/bloc/home_bloc.dart';
import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:flutter/material.dart';

Icon _iconForCategory(String category) {
  const iconColor = Colors.black54;
  switch (category) {
    case "Loan":
      return const Icon(Icons.account_balance_outlined, color: iconColor);
    case "Holiday/Trip":
      return const Icon(Icons.beach_access, color: iconColor);
    case "Housing":
      return const Icon(Icons.house_outlined, color: iconColor);
    case "Shopping":
      return const Icon(Icons.shopping_bag_outlined, color: iconColor);
    case "Travel":
      return const Icon(Icons.directions_car_outlined, color: iconColor);
    case "Vehicle":
      return const Icon(Icons.directions_bike_outlined, color: iconColor);
    case "Food":
      return const Icon(Icons.restaurant_rounded, color: iconColor);
    case "Home":
      return const Icon(Icons.people_outline, color: iconColor);
    case "Charges/Fees":
      return const Icon(Icons.attach_money, color: iconColor);
    case "Groceries":
      return const Icon(Icons.local_grocery_store_outlined, color: iconColor);
    case "Health/Beauty":
      return const Icon(Icons.spa_outlined, color: iconColor);
    case "Entertainment":
      return const Icon(Icons.theaters_outlined, color: iconColor);
    case "Charity/Gift":
      return const Icon(Icons.card_giftcard, color: iconColor);
    case "Education":
      return const Icon(Icons.school_outlined, color: iconColor);
    default:
      return const Icon(Icons.note_outlined, color: iconColor);
  }
}

Widget _budgetListItem(BudgetModel budget, GestureTapCallback onTap) {
  final percentageSpent = (budget.spentAmount / budget.budgetAmount);
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    onTap: () {
      onTap();
    },
    dense: true,
    leading: _iconForCategory(budget.category),
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
          Row(children: [
            const Spacer(),
            Text('${budget.budgetAmount.round()}')
          ]),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(5),
            value: (budget.spentAmount / budget.budgetAmount).clamp(0.0, 1.0),
            minHeight: 10.0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(percentageSpent > 1
                ? Colors.red.shade300
                : const Color.fromARGB(255, 66, 143, 125)),
          ),
        ])),
    trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
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
