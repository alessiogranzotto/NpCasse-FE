import 'package:np_casse/core/models/product.attribute.mapping.model.dart';

class ProductAttributeValueModel {
  ProductAttributeValueModel(
      {required this.idProductAttributeValue,
      required this.name,
      required this.idProductAttributeMapping,
      required this.associatedProductId,
      required this.priceAdjustment,
      required this.cost,
      required this.quantity,
      required this.displayOrder,
      required this.deleted,
      required this.idUserAppInstitution,
      required this.productAttributeMapping});
  late final int idProductAttributeValue;
  late final String name;
  late final int idProductAttributeMapping;
  late final int associatedProductId;
  late final double priceAdjustment;
  late final double cost;
  late final int quantity;
  late final double displayOrder;

  late final bool deleted;
  late final int idUserAppInstitution;

  DateTime? createdOnUtc;
  int? createdByUserAppInstitution;
  DateTime? updatedOnUtc;
  int? updatedByUserAppInstitution;
  late final ProductAttributeMappingModel productAttributeMapping;

  ProductAttributeValueModel.empty() {
    idProductAttributeValue = 0;
    name = '';
  }

  ProductAttributeValueModel.fromJson(Map<String, dynamic> json) {
    idProductAttributeValue = json['idProductAttributeValue'];
    name = json['name'];
    idProductAttributeMapping = json['idProductAttributeMapping'];
    associatedProductId = json['associatedProductId'];
    priceAdjustment = json['priceAdjustment'];
    cost = json['cost'];
    quantity = json['quantity'];
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    return data;
  }
}
