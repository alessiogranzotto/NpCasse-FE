import 'package:intl/intl.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';

class CategoryCatalogDataModel {
  CategoryCatalogDataModel(
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
  late final List<CategoryCatalogModel> data;

  CategoryCatalogDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];

    if (json['data'] != null) {
      data = List.from(json['data'])
          .map((e) => CategoryCatalogModel.fromJson(e))
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

class CategoryCatalogModel {
  CategoryCatalogModel({
    required this.idCategory,
    required this.nameCategory,
    required this.descriptionCategory,
    required this.parentIdCategory,
    required this.displayOrder,
    required this.deleted,
    required this.idUserAppInstitution,
    this.createdOnUtc,
    this.createdByUserAppInstitution,
    this.updatedOnUtc,
    this.updatedByUserAppInstitution,
    required this.imageData,
    this.parentCategoryName,
    required this.giveIdsFlatStructureModel,

    //CUSTOM
    this.isSelected,
  });
  late final int idCategory;
  late final String nameCategory;
  late final String descriptionCategory;
  late final int parentIdCategory;
  late final int displayOrder;
  late final bool deleted;
  late final int idUserAppInstitution;
  DateTime? createdOnUtc;
  int? createdByUserAppInstitution;
  DateTime? updatedOnUtc;
  int? updatedByUserAppInstitution;
  late final String imageData;
  late String? parentCategoryName;
  late final GiveIdsFlatStructureModel giveIdsFlatStructureModel;
  //CUSTOM
  late bool? isSelected = false;

  CategoryCatalogModel.empty() {
    idCategory = 0;
    nameCategory = '';
    descriptionCategory = '';
    parentIdCategory = 0;
    displayOrder = 0;
    deleted = false;
    imageData = '';
    giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
    isSelected = false;
  }

  CategoryCatalogModel.fromJson(Map<String, dynamic> json) {
    idCategory = json['idCategory'];
    nameCategory = json['nameCategory'];
    descriptionCategory = json['descriptionCategory'];
    parentIdCategory = json['parentIdCategory'];
    displayOrder = json['displayOrder'];
    deleted = json['deleted'];
    if (json['parentCategoryName'] != null) {
      parentCategoryName = json['parentCategoryName'];
    } else {
      parentCategoryName = '';
    }
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
    imageData = json['imageData'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idCategory'] = idCategory;
    data['nameCategory'] = nameCategory;
    data['descriptionCategory'] = descriptionCategory;
    data['parentIdCategory'] = parentIdCategory;
    data['displayOrder'] = displayOrder;
    data['deleted'] = deleted;
    data['idUserAppInstitution'] = idUserAppInstitution;
    return data;
  }
}
