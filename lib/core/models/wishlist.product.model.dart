import 'package:np_casse/core/models/product.catalog.model.dart';

class WishlistProductModel {
  WishlistProductModel(
      {required this.idWishlistProduct,
      required this.idUserAppInstitution,
      required this.idProduct,
      required this.productCatalogModel});
  late int idWishlistProduct;
  late int idUserAppInstitution;
  late int idProduct;
  late final ProductCatalogModel productCatalogModel;

  // WishlistProductModel.empty() {
  //   idProduct = 0;
  //   idStore = 0;
  //   nameProduct = '';
  //   descriptionProduct = '';
  //   priceProduct = 0;
  //   imageProduct = '';
  // }

  WishlistProductModel.fromJson(Map<String, dynamic> json) {
    idWishlistProduct = json['idWishlistProduct'];
    idUserAppInstitution = json['idUserAppInstitution'];
    idProduct = json['idProduct'];
    productCatalogModel = ProductCatalogModel.fromJson(json['productModel']);
  }

  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['idProduct'] = idProduct;
  //   data['idStore'] = idStore;
  //   data['nameProduct'] = nameProduct;
  //   data['descriptionProduct'] = descriptionProduct;
  //   data['priceProduct'] = priceProduct;
  //   data['imageProduct'] = imageProduct;
  //   return data;
  // }
}
