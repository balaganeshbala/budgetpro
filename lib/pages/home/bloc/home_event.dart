part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeScreenRefreshedEvent extends HomeEvent {}

class HomeMonthYearChangedEvent extends HomeEvent {
  final String month;
  final String year;

  HomeMonthYearChangedEvent({required this.month, required this.year});
}

class HomeBudgetCategoryItemTappedEvent extends HomeEvent {
  final BudgetModel budget;

  HomeBudgetCategoryItemTappedEvent({required this.budget});
}
