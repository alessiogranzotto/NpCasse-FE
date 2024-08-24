class PredefinedProductAttributeValueModel {
  PredefinedProductAttributeValueModel({
    required this.idPredefinedProductAttributeValue,
    required this.name,
    //required this.idProductAttribute,
    required this.priceAdjustment,
    // required this.priceAdjustmentUsePercentage,
    // required this.weightAdjustment,
    // required this.cost,
    // required this.isPreSelected,
    required this.displayOrder,
    //required this.deleted,
  });
  late int idPredefinedProductAttributeValue;
  late String name;
  //late int idProductAttribute;
  late final double priceAdjustment;
  // late final bool priceAdjustmentUsePercentage;
  // late final double weightAdjustment;
  // late final double cost;
  // late final bool isPreSelected;
  late int displayOrder;
  //late bool deleted;

  PredefinedProductAttributeValueModel.empty() {}
  PredefinedProductAttributeValueModel.fromJson(Map<String, dynamic> json) {
    idPredefinedProductAttributeValue =
        json['idPredefinedProductAttributeValue'];
    name = json['name'];
    //idProductAttribute = json['idProductAttribute'];
    priceAdjustment = json['priceAdjustment'];
    // priceAdjustmentUsePercentage = json['priceAdjustmentUsePercentage'];
    // weightAdjustment = json['weightAdjustment'];
    // cost = json['cost'];
    // isPreSelected = json['isPreSelected'];
    displayOrder = json['displayOrder'];
    //deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idPredefinedProductAttributeValue'] =
        idPredefinedProductAttributeValue;
    data['name'] = name;
    data['priceAdjustment'] = priceAdjustment;
    data['displayOrder'] = displayOrder;
    //data['deleted'] = deleted;
    return data;
  }
}
