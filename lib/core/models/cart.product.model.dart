import 'package:flutter/material.dart';

class CartProductModel {
  CartProductModel(
      {required this.idCartProduct,
      required this.idCart,
      required this.idProduct,
      required this.nameProduct,
      required this.descriptionProduct,
      required this.freePriceProduct,
      required this.productAttributeJson,
      required this.productAttributeExplicit,
      required this.quantityCartProduct,
      required this.priceCartProduct,
      required this.imageData,
      required this.notesCartProduct});
  late final int idCartProduct;
  late final int idCart;
  late final int idProduct;
  late final String nameProduct;
  late final String descriptionProduct;
  late final bool freePriceProduct;
  late final String productAttributeJson;
  late final String productAttributeExplicit;
  // late final int quantityCartProduct;
  late ValueNotifier<int> quantityCartProduct;
  late final double priceCartProduct;
  late final String imageData;
  late final String notesCartProduct;

  CartProductModel.fromJson(Map<String, dynamic> json) {
    idCartProduct = json['idCartProduct'];
    idCart = json['idCart'];
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    descriptionProduct = json['descriptionProduct'];
    freePriceProduct = json['freePriceProduct'];
    productAttributeJson = json['productAttributeJson'];
    productAttributeExplicit = json['productAttributeExplicit'];
    quantityCartProduct = ValueNotifier<int>(json['quantityCartProduct']);
    priceCartProduct = json['priceCartProduct'];
    imageData = json['imageData'];
    notesCartProduct = json['notesCartProduct'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idCartProduct'] = idCartProduct;
    data['idCart'] = idCart;
    data['idProduct'] = idProduct;
    data['quantityCartProduct'] = quantityCartProduct;
    data['priceCartProduct'] = priceCartProduct;
    data['notesCartProduct'] = notesCartProduct;
    return data;
  }
}

class CartProductVariants {
  CartProductVariants(
      {required this.idProductAttribute,
      required this.nameProductAttribute,
      required this.valueVariant});
  late final int idProductAttribute;
  late final String nameProductAttribute;
  late final String valueVariant;

  CartProductVariants.fromJson(Map<String, dynamic> json) {
    idProductAttribute = json['idProductAttribute'];
    nameProductAttribute = json['nameProductAttribute'];
    valueVariant = json['valueVariant'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProductAttribute'] = idProductAttribute;
    data['nameProductAttribute'] = nameProductAttribute;
    data['valueVariant'] = valueVariant;
    return data;
  }
}
