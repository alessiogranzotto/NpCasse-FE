import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';

class ProductCategoryMappingModel {
  ProductCategoryMappingModel(
      {required this.idProductCategoryMapping,
      required this.idProduct,
      required this.idCategory,
      this.productModel,
      required this.categoryModel});

  late final int idProductCategoryMapping;
  late final int idProduct;
  late final int idCategory;
  late final ProductCatalogModel? productModel;
  late final CategoryCatalogModel categoryModel;

  ProductCategoryMappingModel.empty() {
    idProductCategoryMapping = 0;
    idProduct = 0;
    idCategory = 0;
    productModel = ProductCatalogModel.empty();
    categoryModel = CategoryCatalogModel.empty();
  }

  ProductCategoryMappingModel.fromJson(Map<String, dynamic> json) {
    idProductCategoryMapping = json['idProductCategoryMapping'];
    idProduct = json['idProduct'];
    idCategory = json['idCategory'];
    categoryModel = CategoryCatalogModel.fromJson(json['idCategoryNavigation']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProductCategoryMapping'] = idProductCategoryMapping;
    data['idProduct'] = idProduct;
    data['idCategory'] = idCategory;

    return data;
  }
}
