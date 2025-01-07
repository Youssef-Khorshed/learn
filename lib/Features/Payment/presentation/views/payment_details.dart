import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Widgets/cutom_app_bar.dart';
import 'package:flutter_complete_project/Features/checkout/presentation/views/widgets/payment_details_view_body.dart';

class PaymentDetailsView extends StatelessWidget {
  const PaymentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Payment Details'),
      body: const PaymentDetailsViewBody(),
    );
  }
}
