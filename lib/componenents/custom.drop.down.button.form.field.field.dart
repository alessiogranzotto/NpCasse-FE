import 'package:flutter/material.dart';
import 'package:np_casse/core/utils/disable.focus.node.dart';

class CustomDropDownButtonFormField extends StatefulWidget {
  const CustomDropDownButtonFormField(
      {super.key,
      this.hintText,
      this.labelText,
      required this.onItemChanged,
      required this.listOfValue,
      this.actualValue,
      this.prefixIcon,
      this.validator});

  final List<DropdownMenuItem> listOfValue;
  final Icon? prefixIcon;
  final String? hintText;
  final String? labelText;
  final ValueChanged<String> onItemChanged;
  final String? actualValue;
  final String? Function(String?)? validator;

  @override
  State<CustomDropDownButtonFormField> createState() =>
      _CustomDropDownButtonFormField();
}

class _CustomDropDownButtonFormField
    extends State<CustomDropDownButtonFormField> {
  late String? _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.actualValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
          value: _selectedValue,
          focusNode: AlwaysDisabledFocusNode(),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.blueGrey),
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            labelStyle: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.blueGrey),
            hintText: widget.hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).hintColor.withOpacity(0.3)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide:
                  BorderSide(color: Colors.deepOrangeAccent, width: 1.0),
            ),
          ),
          // hint: Text(
          //   widget.hintText,
          // ),
          isExpanded: true,
          onChanged: (value) {
            widget.onItemChanged(value ?? '');
          },
          validator: (value) => value == null ? 'field required' : null,
          items: widget.listOfValue),
    );
  }
}
