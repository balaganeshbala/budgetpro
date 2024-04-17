part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeYearChangedEvent extends HomeEvent {
  final String year;

  HomeYearChangedEvent({required this.year});
}

class HomeMonthChangedEvent extends HomeEvent {
  final String year;
  final String month;

  HomeMonthChangedEvent({required this.year, required this.month});
}

class HomeBudgetCategoryItemTappedEvent extends HomeEvent {
  final BudgetModel budget;

  HomeBudgetCategoryItemTappedEvent({required this.budget});
}
