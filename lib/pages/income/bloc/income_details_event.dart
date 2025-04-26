part of 'income_details_bloc.dart';

// Events
sealed class IncomeDetailsEvent {}

class IncomeDetailsInitialEvent extends IncomeDetailsEvent {
  final IncomeModel income;

  IncomeDetailsInitialEvent({required this.income});
}

class IncomeDetailsSourceChanged extends IncomeDetailsEvent {
  final String value;

  IncomeDetailsSourceChanged({required this.value});
}

class IncomeDetailsAmountChanged extends IncomeDetailsEvent {
  final String value;

  IncomeDetailsAmountChanged({required this.value});
}

class IncomeDetailsCategoryChanged extends IncomeDetailsEvent {
  final IncomeCategory value;

  IncomeDetailsCategoryChanged({required this.value});
}

class IncomeDetailsDateChanged extends IncomeDetailsEvent {
  final DateTime value;

  IncomeDetailsDateChanged({required this.value});
}

class IncomeDetailsUpdateEvent extends IncomeDetailsEvent {}

class IncomeDetailsDeleteEvent extends IncomeDetailsEvent {}
