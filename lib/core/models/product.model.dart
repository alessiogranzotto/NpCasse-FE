// class ProductModel {
//   ProductModel({
//     required this.filled,
//     required this.received,
//     required this.data,
//   });
//   late final bool filled;
//   late final bool received;
//   late final List<ProductData>? data;

//   ProductModel.fromJson(Map<String, dynamic> json) {
//     filled = json['filled'];
//     received = json['received'];
//     data = List.from(json['data']).map((e) => ProductData.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['filled'] = filled;
//     _data['received'] = received;
//     _data['data'] = data?.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class ProductData {
//   ProductData({
//     required this.productId,
//     required this.productName,
//     required this.productDescription,
//     required this.productPrice,
//     required this.productCategory,
//     required this.productImage,
//   });
//   late final int productId;
//   late final String productName;
//   late final String productDescription;
//   late final String productPrice;
//   late final String productCategory;
//   late final String productImage;

//   ProductData.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     productName = json['product_name'];
//     productDescription = json['product_description'];
//     productPrice = json['product_price'];
//     productCategory = json['product_category'];
//     productImage = json['product_image'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['product_id'] = productId;
//     _data['product_name'] = productName;
//     _data['product_description'] = productDescription;
//     _data['product_price'] = productPrice;
//     _data['product_category'] = productCategory;
//     _data['product_image'] = productImage;
//     return _data;
//   }
// }

import 'package:flutter/material.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';

class ProductModel {
  ProductModel(
      {required this.idProduct,
      required this.idStore,
      required this.nameProduct,
      required this.descriptionProduct,
      required this.priceProduct,
      required this.imageProduct,
      required this.isWishlisted,
      required this.isFreePriceProduct,
      required this.isDeleted,
      required this.isOutOfAssortment,
      required this.giveIdsFlatStructureModel});
  late int idProduct;
  late int idStore;
  late String nameProduct;
  late String descriptionProduct;
  late double priceProduct;
  late String imageProduct;
  late ValueNotifier<bool> isWishlisted;
  late bool isFreePriceProduct;
  late bool isDeleted;
  late bool isOutOfAssortment;
  late final GiveIdsFlatStructureModel giveIdsFlatStructureModel;

  ProductModel.empty() {
    idProduct = 0;
    idStore = 0;
    nameProduct = '';
    descriptionProduct = '';
    priceProduct = 0;
    imageProduct = '';
    isWishlisted = ValueNotifier<bool>(false);
    isFreePriceProduct = false;
    isDeleted = false;
    isOutOfAssortment = false;
    giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    idStore = json['idStore'];
    nameProduct = json['nameProduct'];
    descriptionProduct = json['descriptionProduct'];
    priceProduct = json['priceProduct'];
    imageProduct = json['imageProduct'] ?? '';
    isWishlisted = ValueNotifier<bool>(json['isWishlisted']);
    isFreePriceProduct = json['isFreePriceProduct'];
    isDeleted = json['isDeleted'];
    isOutOfAssortment = json['isOutOfAssortment'];
    if (json['giveIdsFlatStructure'] != null) {
      giveIdsFlatStructureModel =
          GiveIdsFlatStructureModel.fromJson(json['giveIdsFlatStructure']);
    } else {
      giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProduct'] = idProduct;
    data['idStore'] = idStore;
    data['nameProduct'] = nameProduct;
    data['descriptionProduct'] = descriptionProduct;
    data['priceProduct'] = priceProduct;
    data['imageProduct'] = imageProduct;
    data['isFreePriceProduct'] = isFreePriceProduct;
    data['isDeleted'] = isDeleted;
    data['isOutOfAssortment'] = isOutOfAssortment;
    data['giveIdsFlatStructure'] = giveIdsFlatStructureModel.toJson();
    return data;
  }
}
