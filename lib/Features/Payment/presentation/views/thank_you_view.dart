import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Widgets/cutom_app_bar.dart';
import 'package:flutter_complete_project/Features/checkout/presentation/views/widgets/thank_you_view_body.dart';

class ThankYouView extends StatelessWidget {
  const ThankYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Transform.translate(
          offset: const Offset(0, -16), child: const ThankYouViewBody()),
    );
  }
}
