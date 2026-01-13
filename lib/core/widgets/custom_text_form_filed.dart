import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatelessWidget {
  const CustomTextFormFiled({
    super.key,
    required this.controller,
    this.maxLines,
    required this.hintText,
    this.validator,
    required this.title,
  });

  final TextEditingController controller;
  final int? maxLines;
  final String hintText;
  final String title;
  final Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16)
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator != null ? (value) => validator!(value) : null,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hintText),
          style: Theme.of(context).textTheme.labelMedium
        ),
      ],
    );
  }
}
