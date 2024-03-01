import 'package:crud/utils/colors.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool isPrefix;
  final bool isNumber;
  final bool isEnable;
  const TextFieldWidget(
      {super.key,
      this.controller,
      this.hint,
      this.isPrefix = false,
      this.isNumber = false,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnable,
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
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColor.greyColor)),
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
