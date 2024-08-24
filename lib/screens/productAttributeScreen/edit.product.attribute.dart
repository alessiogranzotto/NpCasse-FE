// import 'package:expandable_datatable/expandable_datatable.dart';
// import 'package:flutter/material.dart';
// import 'package:np_casse/componenents/text.form.field.dart';
// import 'package:np_casse/core/models/product.attribute.model.dart';

// class EditProductAttribute extends StatefulWidget {
//   final ExpandableRow ProductAttributeModel;
//   const EditProductAttribute({
//     super.key,
//     required this.ProductAttributeModel,
//   });

//   @override
//   State<EditProductAttribute> createState() => _EditProductAttributeState();
// }

// class _EditProductAttributeState extends State<EditProductAttribute> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController nameProductAttributeController =
//       TextEditingController();
//   TextEditingController descriptionProductAttributeController =
//       TextEditingController();
//   List<ProductAttributeModel> cProductAttributeModel = List.empty();

//   @override
//   void initState() {
//     super.initState();
//     nameProductAttributeController.text =
//         widget.ProductAttributeModel.cells[2].value;
//     descriptionProductAttributeController.text =
//         widget.ProductAttributeModel.cells[3].value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 10, right: 10, top: 10, bottom: 10),
//                                 child: AGTextFormField(
//                                     controller: nameProductAttributeController,
//                                     // validator: (value) => value!
//                                     //         .toString()
//                                     //         .isEmpty
//                                     //     ? "Inserire il codice fiscale"
//                                     //     : null,
//                                     // onChanged: (_) => onChangeField(),
//                                     labelText: 'Nome attributo prodotto',
//                                     hintText: "Nome attributo prodotto"),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 10, right: 10, top: 10, bottom: 10),
//                                 child: AGTextFormField(
//                                     controller:
//                                         descriptionProductAttributeController,
//                                     // validator: (value) => value!
//                                     //         .toString()
//                                     //         .isEmpty
//                                     //     ? "Inserire il codice fiscale"
//                                     //     : null,
//                                     // onChanged: (_) => onChangeField(),
//                                     labelText: 'Descrizione attributo prodotto',
//                                     hintText: "Descrizione attributo prodotto"),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 10, right: 10, top: 10, bottom: 10),
//                                 child: AGTextFormField(
//                                     controller: nameProductAttributeController,
//                                     // validator: (value) => value!
//                                     //         .toString()
//                                     //         .isEmpty
//                                     //     ? "Inserire il codice fiscale"
//                                     //     : null,
//                                     // onChanged: (_) => onChangeField(),
//                                     labelText: 'Nome attributo prodotto',
//                                     hintText: "Nome attributo prodotto"),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 10, right: 10, top: 10, bottom: 10),
//                                 child: AGTextFormField(
//                                     controller:
//                                         descriptionProductAttributeController,
//                                     // validator: (value) => value!
//                                     //         .toString()
//                                     //         .isEmpty
//                                     //     ? "Inserire il codice fiscale"
//                                     //     : null,
//                                     // onChanged: (_) => onChangeField(),
//                                     labelText: 'Descrizione attributo prodotto',
//                                     hintText: "Descrizione attributo prodotto"),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
