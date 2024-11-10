import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  int counter = 0;
  CounterBloc() : super(CounterInitial()) {
    on<IncrementEvent>(
      increment,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(seconds: 1)).asyncExpand(mapper),
    );
  }

  FutureOr<void> increment(IncrementEvent event, Emitter<CounterState> emit) {
    emit(CounterIcrement(value: counter++));
  }
}
