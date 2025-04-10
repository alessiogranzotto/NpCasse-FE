import 'package:flutter/material.dart';

class ShSearchTextfield extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Icon prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final ThemeData themeData;

  const ShSearchTextfield(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      required this.prefixIcon,
      this.validator,
      this.onFieldSubmitted,
      required this.themeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: textEditingController,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: themeData.colorScheme.onPrimary,
        // fontFamily: AppFonts.contax,
      ),
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          fillColor: themeData.colorScheme.primary,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
                color: themeData.colorScheme.inversePrimary, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide:
                  BorderSide(color: themeData.colorScheme.inversePrimary)),
          hintText: hintText,
          hintStyle: TextStyle(color: themeData.hintColor, fontSize: 12)),
    );
  }
}
