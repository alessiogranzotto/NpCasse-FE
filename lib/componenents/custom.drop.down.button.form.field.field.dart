import 'package:flutter/material.dart';
import 'package:np_casse/core/utils/disable.focus.node.dart';

class CustomDropDownButtonFormField extends StatefulWidget {
  const CustomDropDownButtonFormField({
    super.key,
    required this.enabled,
    this.hintText,
    this.labelText,
    required this.onItemChanged,
    required this.listOfValue,
    this.actualValue,
    this.prefixIcon,
    this.validator,
    this.selectedItemBuilder,
  });
  final bool enabled;
  final List<DropdownMenuItem> listOfValue;
  final Icon? prefixIcon;
  final String? hintText;
  final String? labelText;
  final ValueChanged<dynamic> onItemChanged;
  final dynamic actualValue;
  final String? Function(String?)? validator;
  final DropdownButtonBuilder? selectedItemBuilder;
  @override
  State<CustomDropDownButtonFormField> createState() =>
      _CustomDropDownButtonFormField();
}

class _CustomDropDownButtonFormField
    extends State<CustomDropDownButtonFormField> {
  late dynamic _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.actualValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedValue = widget.actualValue;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
          value: _selectedValue,
          selectedItemBuilder: widget.selectedItemBuilder,
          focusNode: AlwaysDisabledFocusNode(),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.blueGrey),
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            // suffixIcon: (widget.actualValue == null || !widget.haveClearButton)
            //     ? null
            //     : IconButton(
            //         icon: const Icon(Icons.clear_rounded),
            //         onPressed: () => setState(() {
            //               _selectedValue = null;
            //               widget.onItemChanged('0');
            //             })),

            labelStyle: Theme.of(context).textTheme.labelLarge!,

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
              borderSide: BorderSide(color: Colors.black, width: 1.0),
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
          // onChanged: widget.enabled
          //     ? (dynamic value) => {_selectedValue = widget.actualValue;
          //     widget.onItemChanged(value ?? '');}
          //     : null,
          onChanged:
              // (value) {
              //   widget.enabled
              //       ?
              //       // _selectedValue = widget.actualValue;
              //       widget.onItemChanged(value ?? '')
              //       : null;
              // },
              widget.enabled
                  ? (dynamic value) => widget.onItemChanged(value ?? '')
                  : null,
          // onChanged: (value) {
          //   if (widget.enabled) {
          //     _selectedValue = widget.actualValue;
          //     widget.onItemChanged(value ?? '');
          //   } else {
          //     null;
          //   }
          // },
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value.toString());
            } else {
              if (value == null || value.toString().isEmpty) {
                return 'Selezione obbligatoria';
              } else {
                return null;
              }
            }

            // (value == null || value.toString().isEmpty)
            //     ? return 'Selezione obbligatoria'
            //     : return null
          },
          items: widget.listOfValue),
    );
  }
}
