import 'package:flutter/material.dart';

class ShSearchTextfield extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Icon prefixIcon;
  final String? Function(String?)? validator;
  final ThemeData themeData;

  const ShSearchTextfield(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      required this.prefixIcon,
      required this.validator,
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
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: hintText,
          hintStyle: TextStyle(color: themeData.hintColor, fontSize: 12)),
    );
  }
}
