part of 'cubit_example_cubit.dart';

///  A way to intialize the state of the cubit using Freezed package
/// by using tihs code -> flutter pub run build_runner build --delete-conflicting-outputs

// @freezed
// class CubitExampleState with _$CubitExampleState {
//   const factory CubitExampleState.initial() = _Initial;
// }

///  A way to intialize the state of the cubit using Equatable package
abstract class CubitExampleState extends Equatable {
  const CubitExampleState();
  @override
  List<Object> get props => [];
}

class Increment extends CubitExampleState {}

class Decrement extends CubitExampleState {}

class Iinital extends CubitExampleState {}
