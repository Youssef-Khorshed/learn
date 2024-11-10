import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/exceptionType.dart';

class Casherrorhandler {
  static AppException handle(dynamic e) {
    if (e is CashExceptionType) {
      return handleCashException(e);
    } else {
      return CacheException(
        code: CashExceptionType.insufficientFunds.index,
        message: "Error: An unknown error occurred.",
      );
    }
  }

  static CacheException handleCashException(CashExceptionType exception) {
    switch (exception) {
      case CashExceptionType.insufficientFunds:
        return CacheException(
          code: CashExceptionType.insufficientFunds.index,
          message: "Insufficient funds available for this transaction.",
        );
      case CashExceptionType.invalidAmount:
        return CacheException(
          code: CashExceptionType.invalidAmount.index,
          message: "Insufficient funds available for this transaction.",
        );
      case CashExceptionType.currencyNotSupported:
        return CacheException(
          code: CashExceptionType.currencyNotSupported.index,
          message: "Insufficient funds available for this transaction.",
        );
      case CashExceptionType.transactionLimitExceeded:
        return CacheException(
          code: CashExceptionType.transactionLimitExceeded.index,
          message: "Insufficient funds available for this transaction.",
        );
      case CashExceptionType.cashNotAvailable:
        return CacheException(
          code: CashExceptionType.cashNotAvailable.index,
          message: "Insufficient funds available for this transaction.",
        );
      case CashExceptionType.unauthorizedAccess:
        return CacheException(
          code: CashExceptionType.insufficientFunds.index,
          message: "Insufficient funds available for this transaction.",
        );
      case CashExceptionType.sharedPreferencesError:
        return CacheException(
          code: CashExceptionType.sharedPreferencesError.index,
          message: "Insufficient funds available for this transaction.",
        );
    }
  }
}
