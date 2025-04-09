import 'package:budgetpro/models/budget_model.dart';

sealed class NewHomeEvent {}

class HomeInitialEvent extends NewHomeEvent {}

class HomeScreenRefreshedEvent extends NewHomeEvent {}

class HomeMonthYearChangedEvent extends NewHomeEvent {
  final String month;
  final String year;

  HomeMonthYearChangedEvent({required this.month, required this.year});
}

class HomeBudgetCategoryItemTappedEvent extends NewHomeEvent {
  final CategorizedBudgetModel budget;

  HomeBudgetCategoryItemTappedEvent({required this.budget});
}
