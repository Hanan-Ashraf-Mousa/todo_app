import 'package:flutter/material.dart';
import 'package:todo_app/my_theme.dart';

typedef ValidationType = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  String? label;
  TextEditingController controller;
  TextInputType keyboardType;
  ValidationType validate;
  bool obscureText;

  CustomTextFormField(
      {super.key,
      this.label = '',
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      required this.validate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validate,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(label ?? ''),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: MyTheme.primaryColor,
                width: 1.5,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: MyTheme.primaryColor,
                width: 1.5,
              )),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: MyTheme.redColor,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: MyTheme.redColor,
                width: 1.5,
              )),
        ),
      ),
    );
  }
}
