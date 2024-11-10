part of 'counter_bloc.dart';

// @freezed
// class CounterEvent with _$CounterEvent {
//   const factory CounterEvent.started() = _Started;
// }

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}
