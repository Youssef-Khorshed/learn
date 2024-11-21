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

/// connec Error
class Connection extends Failure {
  Connection({required String message}) : super(message: message);
}
