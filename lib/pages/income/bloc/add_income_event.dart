part of 'add_income_bloc.dart';

sealed class AddIncomeEvent {}

class AddIncomeInitialEvent extends AddIncomeEvent {}

class AddIncomeSourceValueChanged extends AddIncomeEvent {
  final String value;

  AddIncomeSourceValueChanged({required this.value});
}

class AddIncomeAmountValueChanged extends AddIncomeEvent {
  final String value;

  AddIncomeAmountValueChanged({required this.value});
}

class AddIncomeDateValueChanged extends AddIncomeEvent {
  final DateTime value;

  AddIncomeDateValueChanged({required this.value});
}

class AddIncomeAddIncomeTappedEvent extends AddIncomeEvent {}
