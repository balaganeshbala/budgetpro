import 'package:bloc/bloc.dart';
import 'package:budgetpro/utits/utils.dart';

part 'month_selector_event.dart';
part 'month_selector_state.dart';

class MonthSelectorBloc
    extends Bloc<MonthSelectorChangedEvent, MonthSelectorState> {
  MonthSelectorBloc(
      String initialMonth, String initialYear, DateTime initialDateTime)
      : super(MonthSelectorState(
            selectedMonth: initialMonth,
            selectedYear: initialYear,
            selectedValue: initialDateTime)) {
    on<MonthSelectorChangedEvent>((event, emit) {
      final month = Utils.getMonthAsShortText(event.selectedValue);
      final year = '${event.selectedValue.year}';

      emit(MonthSelectorState(
          selectedMonth: month,
          selectedYear: year,
          selectedValue: event.selectedValue));
    });
  }
}
