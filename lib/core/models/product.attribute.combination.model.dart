import 'package:np_casse/core/models/product.attribute.mapping.model.dart';

class ProductAttributeJson {
  late int idProductAttribute;
  late String value;
  ProductAttributeJson({
    required this.idProductAttribute,
    required this.value,
  });
  ProductAttributeJson.fromJson(Map<String, dynamic> json) {
    idProductAttribute = json['idProductAttribute'];
    value = json['value'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProductAttribute'] = idProductAttribute;
    data['value'] = value;
    return data;
  }
}

class SmartProductAttributeJson {
  late int idProductAttribute;
  late String nameProductAttribute;
  late List<SmartProductAttributeJsonValue> value;
  SmartProductAttributeJson(
      {required this.idProductAttribute,
      required this.nameProductAttribute,
      required this.value});
  SmartProductAttributeJson.fromJson(Map<String, dynamic> json) {
    idProductAttribute = json['idProductAttribute'];
    nameProductAttribute = json['nameProductAttribute'];
    value = List.from(json['value'])
        .map((e) => SmartProductAttributeJsonValue.fromJson(e))
        .toList();
  }
}

class SmartProductAttributeJsonValue {
  late String? value;
  late bool selectable;
  late bool selectedFromBarcode;
  late String? descPrice;
  SmartProductAttributeJsonValue(
      {required this.value, required this.selectable, this.descPrice});
  SmartProductAttributeJsonValue.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    selectable = json['selectable'];
    selectedFromBarcode = json['selectedFromBarcode'];
    descPrice = '';
  }
}

class ProductAttributeCombinationModel {
  late List<ProductAttributeMappingModel> productAttributeMappingModelList;
  late int idProductAttributeCombination;
  late String barcode;
  late String sku;
  late int idProduct;
  late double? overriddenPrice;
  // late List<String> customStringInserted;
  late List<ProductAttributeJson> productAttributeJson;
  ProductAttributeCombinationModel({
    required this.productAttributeMappingModelList,
    required this.idProductAttributeCombination,
    required this.barcode,
    required this.sku,
    required this.idProduct,
    this.overriddenPrice,
    // required this.customStringInserted,
    required this.productAttributeJson,
  });

  ProductAttributeCombinationModel.fromJson(Map<String, dynamic> json) {
    idProductAttributeCombination = json['idProductAttributeCombination'];
    barcode = json['barcode'];
    sku = json['sku'];
    idProduct = json['idProduct'];
    overriddenPrice = json['overriddenPrice'];
    // customStringInserted = json['customStringInserted'];
    productAttributeJson = List.from(json['productAttributeJsonList'])
        .map((e) => ProductAttributeJson.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProductAttributeCombination'] = idProductAttributeCombination;

    data['barcode'] = barcode;
    data['sku'] = sku;
    data['idProduct'] = idProduct;
    data['overriddenPrice'] = overriddenPrice;
    // data['customStringInserted'] = customStringInserted.map((e) => e).toList();
    data['productAttributeJson'] =
        productAttributeJson.map((e) => e.toJson()).toList();
    return data;
  }
}
