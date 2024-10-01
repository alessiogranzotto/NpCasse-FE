import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {this.textInputAction,
      this.labelText,
      this.textAlign,
      this.keyboardType,
      required this.controller,
      super.key,
      this.hintText,
      this.onChanged,
      this.onFieldSubmitted,
      this.validator,
      this.obscureText,
      this.suffixIcon,
      this.onEditingComplete,
      this.autofocus,
      this.focusNode,
      this.onTap,
      this.enabled,
      this.maxLength,
      this.inputFormatter});

  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String? labelText;
  final TextAlign? textAlign;
  final bool? autofocus;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final bool? enabled;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.inversePrimary,
      controller: controller,
      enabled: enabled ?? true,
      maxLength: maxLength ?? maxLength,
      inputFormatters:
          inputFormatter ?? [LengthLimitingTextInputFormatter(500)],
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType ?? TextInputType.text,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      autofocus: autofocus ?? false,
      validator: validator,
      obscureText: obscureText ?? false,
      obscuringCharacter: '*',
      onEditingComplete: onEditingComplete,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: Theme.of(context).textTheme.labelLarge!
        // .copyWith(color: Colors.blueGrey)
        ,
        hintStyle: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: Theme.of(context).hintColor.withOpacity(0.3)),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
              // color: Colors.grey,
              width: 1.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
              // color: Colors.grey,
              width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary,
              // color: Colors.blue,
              width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide:
              BorderSide(color: Colors.red.withOpacity(0.5), width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      // style: const TextStyle(
      //   fontWeight: FontWeight.w500,
      // color: Colors.black,
      //),
    );
  }
}
