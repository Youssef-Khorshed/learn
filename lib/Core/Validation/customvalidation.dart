// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Spacing/spaces.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordValidation extends StatelessWidget {
  final bool hasLowerCase;
  final bool hasUpperCase;
  final bool hasSpecialCharacters;
  final bool hasNumber;
  final bool hasMinLength;
  const PasswordValidation(
      {super.key,
      required this.hasLowerCase,
      required this.hasUpperCase,
      required this.hasSpecialCharacters,
      required this.hasNumber,
      required this.hasMinLength});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildValidationRow('At least 1 lowercase letter', hasLowerCase),
      verticalSpace(2),
      buildValidationRow('At least 1 uppercase letter', hasUpperCase),
      verticalSpace(2),
      buildValidationRow('At least 1 special character', hasSpecialCharacters),
      verticalSpace(2),
      buildValidationRow('At least 1 number', hasNumber),
      verticalSpace(2),
      buildValidationRow('At least 8 characters long', hasMinLength)
    ]);
  }

  Widget buildValidationRow(String text, bool isValid) {
    return Row(
      children: [
        CircleAvatar(
          radius: 2.5.r,
          backgroundColor: getcolor(isValid),
        ),
        Text(
          text,
          style: TextStyle(
                  color: getcolor(isValid),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold)
              .copyWith(
                  decoration: isValid ? TextDecoration.lineThrough : null,
                  decorationColor: isValid ? Colors.green : Colors.red,
                  decorationThickness: 2),
        )
      ],
    );
  }

  Color getcolor(bool isValid) => (isValid ? Colors.green : Colors.red);
}
