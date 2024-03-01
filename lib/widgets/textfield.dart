import 'package:crud/utils/colors.dart';
import 'package:crud/utils/strings.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool isPrefix;
  final bool isNumber;
  const TextFieldWidget(
      {super.key,
      this.controller,
      this.hint,
      this.isPrefix = false,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: hint,
        floatingLabelStyle: const TextStyle(
            color: MyColor.secondaryColor, fontWeight: FontWeight.w600),
        prefixIcon: isPrefix
            ? const Icon(Icons.phone_outlined, color: MyColor.greyColor)
            : null,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColor.greyColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColor.greyColor)),
      ),
    );
  }
}
