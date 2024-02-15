import 'package:flutter/material.dart';
import 'package:np_casse/core/models/product.model.dart';

class CartProductModel {
  CartProductModel(
      {required this.idCartProduct,
      required this.idCart,
      required this.idProduct,
      required this.quantityCartProduct,
      required this.freePriceCartProduct,
      required this.notesCartProduct,
      required this.productModel});
  late final int idCartProduct;
  late final int idCart;
  late final int idProduct;
  // late final int quantityCartProduct;
  late ValueNotifier<int> quantityCartProduct;
  late final ValueNotifier<double> freePriceCartProduct;
  late final String? notesCartProduct;
  late final ProductModel productModel;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return idProduct.toString();
      case 1:
        return productModel.nameProduct;
      case 2:
        return quantityCartProduct.toString();
      case 3:
        return productModel.priceProduct.toString();
      case 4:
        return (quantityCartProduct.value * productModel.priceProduct)
            .toString();
    }
    return '';
  }

  CartProductModel.fromJson(Map<String, dynamic> json) {
    idCartProduct = json['idCartProduct'];
    idCart = json['idCart'];
    idProduct = json['idProduct'];
    quantityCartProduct = ValueNotifier<int>(json['quantityCartProduct']);
    freePriceCartProduct =
        ValueNotifier<double>(json['freePriceCartProduct'] ?? 0);
    notesCartProduct = json['notesCartProduct'];
    productModel = ProductModel.fromJson(json['idProductNavigation']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idCartProduct'] = idCartProduct;
    data['idCart'] = idCart;
    data['idProduct'] = idProduct;
    data['quantityCartProduct'] = quantityCartProduct;
    data['freePriceCartProduct'] = freePriceCartProduct;
    data['notesCartProduct'] = notesCartProduct;
    data['productModel'] = productModel.toJson();
    return data;
  }
}
