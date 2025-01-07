import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Core/Error/failure.dart';
import 'package:flutter_complete_project/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:flutter_complete_project/Features/checkout/data/repos/checkout_repo.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutRepoImpl extends CheckoutRepo {
  final StripeService stripeService = StripeService();
  @override
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await stripeService.makePayment(
          paymentIntentInputModel: paymentIntentInputModel);

      return right(unit);
    } on StripeException catch (e) {
      return left(ServerFailure(
          errMessage: e.error.message ?? 'Oops there was an error'));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
