import 'package:np_casse/core/models/product.attribute.model.dart';
import 'package:np_casse/core/models/product.attribute.value.model.dart';

class ProductAttributeMappingModel {
  ProductAttributeMappingModel(
      {required this.idProductAttributeMapping,
      required this.idProductAttribute,
      required this.idProduct,
      required this.isRequired,
      required this.displayOrder,
      required this.productAttributeModel,
      required this.productAttributeValueModelList});

  late final int idProductAttributeMapping;
  late final int idProductAttribute;
  late final int idProduct;
  late final bool isRequired;
  late final int displayOrder;
  late final ProductAttributeModel productAttributeModel;
  late final List<ProductAttributeValueModel> productAttributeValueModelList;

  ProductAttributeMappingModel.fromJson(Map<String, dynamic> json) {
    idProductAttributeMapping = json['idProductAttributeMapping'];
    idProductAttribute = json['idProductAttribute'];
    idProduct = json['idProduct'];
    isRequired = json['isRequired'];
    displayOrder = json['displayOrder'];

    productAttributeModel =
        ProductAttributeModel.fromJson(json['idProductAttributeNavigation']);
    productAttributeValueModelList =
        List.from(json['productAttributeValuesModel'])
            .map((e) => ProductAttributeValueModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProductAttributeMapping'] = idProductAttributeMapping;
    data['idProductAttribute'] = idProductAttribute;
    data['idProduct'] = idProduct;
    data['isRequired'] = isRequired;
    data['displayOrder'] = displayOrder;
    return data;
  }
}
