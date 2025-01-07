import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Core/Error/failure.dart';
import 'package:flutter_complete_project/Features/Payment/data/models/payment_intent_input_model.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel});
}
