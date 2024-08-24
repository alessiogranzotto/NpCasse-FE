import 'package:np_casse/core/models/predefined.product.attribute.value.dart';

// class ProductAttributeDataModel {
//   ProductAttributeDataModel(
//       {required this.currentPage,
//       required this.totalPages,
//       required this.pageSize,
//       required this.totalCount,
//       required this.hasPrevious,
//       required this.hasNext,
//       required this.data});
//   late final int currentPage;
//   late final int totalPages;
//   late final int pageSize;
//   late final int totalCount;
//   late final bool hasPrevious;
//   late final bool hasNext;
//   late final List<ProductAttributeModel> data;

//   ProductAttributeDataModel.fromJson(Map<String, dynamic> json) {
//     currentPage = json['currentPage'];
//     totalPages = json['totalPages'];
//     pageSize = json['pageSize'];
//     totalCount = json['totalCount'];
//     hasPrevious = json['hasPrevious'];
//     hasNext = json['hasNext'];

//     if (json['data'] != null) {
//       data = List.from(json['data'])
//           .map((e) => ProductAttributeModel.fromJson(e))
//           .toList();
//     } else {
//       data = List.empty();
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['currentPage'] = currentPage;
//     data['totalPages'] = totalPages;
//     data['pageSize'] = pageSize;
//     data['totalCount'] = totalCount;
//     data['hasPrevious'] = hasPrevious;
//     data['hasNext'] = hasNext;
//     data['data'] = data;
//     return data;
//   }
// }

class ProductAttributeModel {
  ProductAttributeModel(
      {required this.idProductAttribute,
      required this.name,
      required this.description,
      required this.idUserAppInstitution,
      required this.predefinedProductAttributeValues});
  late final int idProductAttribute;
  late final String name;
  late final String description;
  late final int idUserAppInstitution;
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
    name = json['name'];
    description = json['description'];

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
