part of 'counter_bloc.dart';

// @freezed
// class CounterState with _$CounterState {
//   const factory CounterState.initial() = _Initial;
// }

abstract class CounterState {}

class CounterInitial extends CounterState {}

class CounterIcrement extends CounterState {
  final int value;
  CounterIcrement({required this.value});
}
