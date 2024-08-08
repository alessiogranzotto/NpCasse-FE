// import 'package:flutter/material.dart';
// import 'package:np_casse/core/models/category.catalog.model.dart';

// // DropdownMenuEntry labels and values for the first dropdown menu.
// enum ColorLabel {
//   blue('Blue', Colors.blue),
//   pink('Pink', Colors.pink),
//   green('Green', Colors.green),
//   yellow('Orange', Colors.orange),
//   grey('Grey', Colors.grey);

//   const ColorLabel(this.label, this.color);
//   final String label;
//   final Color color;
// }

// // DropdownMenuEntry labels and values for the second dropdown menu.
// enum IconLabel {
//   smile('Smile', Icons.sentiment_satisfied_outlined),
//   cloud(
//     'Cloud',
//     Icons.cloud_outlined,
//   ),
//   brush('Brush', Icons.brush_outlined),
//   heart('Heart', Icons.favorite);

//   const IconLabel(this.label, this.icon);
//   final String label;
//   final IconData icon;
// }

// class AgCategoryDropDownMenu extends StatefulWidget {
//   const AgCategoryDropDownMenu({
//     super.key,
//     required this.categoryModelList,
//     this.prefixIcon,
//     this.hintText,
//     this.labelText,
//     required this.onItemChanged,
//     required this.actualValue,
//     this.validator,
//   });

//   final List<CategoryModel> categoryModelList;
//   final Icon? prefixIcon;
//   final String? hintText;
//   final String? labelText;
//   final ValueChanged<CategoryModel> onItemChanged;
//   final String? actualValue;
//   final String? Function(String?)? validator;

//   @override
//   State<AgCategoryDropDownMenu> createState() => _AgCategoryDropDownMenuState();
// }

// class _AgCategoryDropDownMenuState extends State<AgCategoryDropDownMenu> {
//   CategoryModel? selectedCategory;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<CategoryModel>(
//       initialSelection: null,
//       // requestFocusOnTap is enabled/disabled by platforms when it is null.
//       // On mobile platforms, this is false by default. Setting this to true will
//       // trigger focus request on the text field and virtual keyboard will appear
//       // afterward. On desktop platforms however, this defaults to true.
//       requestFocusOnTap: true,
//       label: Text(widget.labelText ?? ''),
//       onSelected: (CategoryModel? category) {
//         setState(() {
//           selectedCategory = category;
//           widget.onItemChanged(category!);
//         });
//       },
//       dropdownMenuEntries: widget.categoryModelList
//           .map<DropdownMenuEntry<CategoryModel>>((CategoryModel category) {
//         return DropdownMenuEntry<CategoryModel>(
//           value: category,
//           label: category.nameCategory,
//           enabled: true,
//           // style: MenuItemButton.styleFrom(
//           //   foregroundColor: color.color,
//           // ),
//         );
//       }).toList(),
//     );
//   }
// }
