import 'package:flutter/material.dart';

class LoginTextFormField {
  static loginTextFormField(
      {
      // required bool themeFlag,
      required TextEditingController textEditingController,
      required String hintText,
      required bool obscureText,
      required Icon prefixIcon,
      String? Function(String?)? validator,
      Function(String)? onChanged,
      required ThemeData themeData}) {
    return TextFormField(
      enableInteractiveSelection: true,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: textEditingController,
      validator: validator,
      obscureText: obscureText,
      style: TextStyle(
        color: themeData.colorScheme.onPrimary,
        // fontFamily: AppFonts.contax,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          fillColor: themeData.colorScheme.primary,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: themeData.colorScheme.shadow),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: themeData.colorScheme.shadow)),
          hintText: hintText,
          hintStyle: TextStyle(color: themeData.hintColor)),
    );
  }
}
