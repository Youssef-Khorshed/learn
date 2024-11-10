import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'cubit_example_state.dart';

class CubitExampleCubit extends Cubit<CubitExampleState> {
  int counter = 0;

  // CubitExampleCubit() : super(CubitExampleState.initial()); // using freezed
  CubitExampleCubit() : super(Iinital()); // using equatable

  void incremnet() {
    counter++;
    emit(Increment());
  }
}
