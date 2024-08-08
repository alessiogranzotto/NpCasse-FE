import 'package:intl/intl.dart';

class ProductAttributeDataModel {
  ProductAttributeDataModel(
      {required this.currentPage,
      required this.totalPages,
      required this.pageSize,
      required this.totalCount,
      required this.hasPrevious,
      required this.hasNext,
      required this.data});
  late final int currentPage;
  late final int totalPages;
  late final int pageSize;
  late final int totalCount;
  late final bool hasPrevious;
  late final bool hasNext;
  late final List<ProductAttributeModel> data;

  ProductAttributeDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];

    if (json['data'] != null) {
      data = List.from(json['data'])
          .map((e) => ProductAttributeModel.fromJson(e))
          .toList();
    } else {
      data = List.empty();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    data['data'] = data;
    return data;
  }
}

class ProductAttributeModel {
  ProductAttributeModel(
      {required this.idProductAttribute,
      // required this.idInstitution,
      required this.name,
      required this.description,
      required this.idUserAppInstitution,
      this.createdOnUtc,
      this.createdByUserAppInstitution,
      this.updatedOnUtc,
      this.updatedByUserAppInstitution,
      required this.predefinedProductAttributeValues});
  late final int idProductAttribute;
  // late final int idInstitution;
  late final String name;
  late final String description;
  late final int idUserAppInstitution;
  DateTime? createdOnUtc;
  int? createdByUserAppInstitution;
  DateTime? updatedOnUtc;
  int? updatedByUserAppInstitution;
  late final List<PredefinedProductAttributeValueModel>
      predefinedProductAttributeValues;

  ProductAttributeModel.empty() {
    idProductAttribute = 0;
    name = '';
    description = '';
    predefinedProductAttributeValues = List.empty();
  }

  ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    idProductAttribute = json['idProductAttribute'];
    // idInstitution = json['idInstitution'];
    name = json['name'];
    description = json['description'];

    var dateTimeC =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdOnUtc'], true);
    var dateLocalC = dateTimeC.toLocal();

    createdOnUtc = dateLocalC;
    createdByUserAppInstitution = json['createdByUserAppInstitution'];

    var dateTimeU =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedOnUtc'], true);
    var dateLocalU = dateTimeU.toLocal();
    updatedOnUtc = dateLocalU;
    updatedByUserAppInstitution = json['updatedByUserAppInstitution'];

    if (json['predefinedProductAttributeValues'] != null) {
      predefinedProductAttributeValues =
          List.from(json['predefinedProductAttributeValues'])
              .map((e) => PredefinedProductAttributeValueModel.fromJson(e))
              .toList();
    } else {
      predefinedProductAttributeValues = List.empty();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProductAttribute'] = idProductAttribute;
    data['name'] = name;
    data['description'] = description;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['predefinedProductAttributeValues'] =
        predefinedProductAttributeValues.map((e) => e.toJson()).toList();
    return data;
  }
}

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
