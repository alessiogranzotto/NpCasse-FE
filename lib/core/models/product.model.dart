// import 'package:flutter/material.dart';
// import 'package:np_casse/core/models/give.id.flat.structure.model.dart';

// class ProductModel {
//   ProductModel(
//       {required this.idProduct,
//       required this.idStore,
//       required this.nameProduct,
//       required this.descriptionProduct,
//       required this.priceProduct,
//       required this.imageProduct,
//       required this.isWishlisted,
//       required this.isFreePriceProduct,
//       required this.isDeleted,
//       required this.isOutOfAssortment,
//       required this.giveIdsFlatStructureModel});
//   late int idProduct;
//   late int idStore;
//   late String nameProduct;
//   late String descriptionProduct;
//   late double priceProduct;
//   late String imageProduct;
//   late ValueNotifier<bool> isWishlisted;
//   late bool isFreePriceProduct;
//   late bool isDeleted;
//   late bool isOutOfAssortment;
//   late final GiveIdsFlatStructureModel giveIdsFlatStructureModel;

//   ProductModel.empty() {
//     idProduct = 0;
//     idStore = 0;
//     nameProduct = '';
//     descriptionProduct = '';
//     priceProduct = 0;
//     imageProduct = '';
//     isWishlisted = ValueNotifier<bool>(false);
//     isFreePriceProduct = false;
//     isDeleted = false;
//     isOutOfAssortment = false;
//     giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
//   }

//   ProductModel.fromJson(Map<String, dynamic> json) {
//     idProduct = json['idProduct'];
//     idStore = json['idStore'];
//     nameProduct = json['nameProduct'];
//     descriptionProduct = json['descriptionProduct'];
//     priceProduct = json['priceProduct'];
//     imageProduct = json['imageProduct'] ?? '';
//     isWishlisted = ValueNotifier<bool>(json['isWishlisted']);
//     isFreePriceProduct = json['isFreePriceProduct'];
//     isDeleted = json['isDeleted'];
//     isOutOfAssortment = json['isOutOfAssortment'];
//     if (json['giveIdsFlatStructure'] != null) {
//       giveIdsFlatStructureModel =
//           GiveIdsFlatStructureModel.fromJson(json['giveIdsFlatStructure']);
//     } else {
//       giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['idProduct'] = idProduct;
//     data['idStore'] = idStore;
//     data['nameProduct'] = nameProduct;
//     data['descriptionProduct'] = descriptionProduct;
//     data['priceProduct'] = priceProduct;
//     data['imageProduct'] = imageProduct;
//     data['isFreePriceProduct'] = isFreePriceProduct;
//     data['isDeleted'] = isDeleted;
//     data['isOutOfAssortment'] = isOutOfAssortment;
//     data['giveIdsFlatStructure'] = giveIdsFlatStructureModel.toJson();
//     return data;
//   }
// }
