import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  Failure({required this.message});

  List<Object?> get props => [message];
}

/// server Error
class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message: message);
}

/// Local Error
class LocalFailure extends Failure {
  LocalFailure({required String message}) : super(message: message);
}

/// connection Error
class InternetConnectionFailure extends Failure {
  InternetConnectionFailure({required String message})
      : super(message: message);
}

/// Unexpected Error
class UnExpectedFailure extends Failure {
  UnExpectedFailure({required String message}) : super(message: message);
}
