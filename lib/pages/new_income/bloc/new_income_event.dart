part of 'new_income_bloc.dart';

sealed class NewIncomeEvent {}

class NewIncomeInitialEvent extends NewIncomeEvent {}

class NewIncomeNameValueChanged extends NewIncomeEvent {
  final String value;

  NewIncomeNameValueChanged({required this.value});
}

class NewIncomeAmountValueChanged extends NewIncomeEvent {
  final String value;

  NewIncomeAmountValueChanged({required this.value});
}

class NewIncomeDateValueChanged extends NewIncomeEvent {
  final DateTime value;

  NewIncomeDateValueChanged({required this.value});
}

class NewIncomeAddIncomeTappedEvent extends NewIncomeEvent {}
