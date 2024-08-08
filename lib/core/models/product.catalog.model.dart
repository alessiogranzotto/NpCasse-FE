import 'package:intl/intl.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';

class ProductCatalogDataModel {
  ProductCatalogDataModel(
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
  late final List<ProductCatalogModel> data;

  ProductCatalogDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];

    if (json['data'] != null) {
      data = List.from(json['data'])
          .map((e) => ProductCatalogModel.fromJson(e))
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

class ProductCatalogModel {
  ProductCatalogModel(
      {required this.idProduct,
      required this.idCategory,
      required this.nameProduct,
      required this.descriptionProduct,
      required this.priceProduct,
      required this.freePriceProduct,
      required this.outOfAssortment,
      required this.barcode,
      // required this.idWarehouse,
      // required this.stockQuantity,
      // required this.minStockQuantity,
      required this.deleted,
      required this.idUserAppInstitution,
      this.createdOnUtc,
      this.createdByUserAppInstitution,
      this.updatedOnUtc,
      this.updatedByUserAppInstitution,
      required this.imageData,
      required this.giveIdsFlatStructureModel,

      //CUSTOM
      this.isSelected});

  late final int idProduct;
  late final int idCategory;
  late final String nameProduct;
  late final String descriptionProduct;
  late final double priceProduct;
  late final bool freePriceProduct;
  late final bool outOfAssortment;
  late final bool wishlisted;
  late final String barcode;
  // late final int idWarehouse;
  // late final double stockQuantity;
  // late final double minStockQuantity;
  late final bool deleted;
  late final int idUserAppInstitution;
  DateTime? createdOnUtc;
  int? createdByUserAppInstitution;
  DateTime? updatedOnUtc;
  int? updatedByUserAppInstitution;
  late final String imageData;
  late final GiveIdsFlatStructureModel giveIdsFlatStructureModel;

  //CUSTOM
  late bool? isSelected = false;

  ProductCatalogModel.empty() {
    idProduct = 0;
    idCategory = 0;
    nameProduct = '';
    descriptionProduct = '';
    priceProduct = 0;
    freePriceProduct = false;
    outOfAssortment = false;
    barcode = '';
    // idWarehouse = 0;
    // stockQuantity = 0;
    // minStockQuantity = 0;
    deleted = false;
    imageData = '';
    giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
    isSelected = false;
  }

  ProductCatalogModel.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    idCategory = json['idCategory'];
    nameProduct = json['nameProduct'];
    descriptionProduct = json['descriptionProduct'];
    priceProduct = json['priceProduct'];
    freePriceProduct = json['freePriceProduct'];
    outOfAssortment = json['outOfAssortment'];
    barcode = json['barcode'];
    // idWarehouse = json['idWarehouse'];
    // stockQuantity = json['stockQuantity'];
    // minStockQuantity = json['minStockQuantity'];
    deleted = json['deleted'];

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
    data['idProduct'] = idProduct;
    data['idCategory'] = idCategory;
    data['nameProduct'] = nameProduct;
    data['descriptionProduct'] = descriptionProduct;
    data['priceProduct'] = priceProduct;
    data['freePriceProduct'] = freePriceProduct;
    data['outOfAssortment'] = outOfAssortment;
    data['barcode'] = barcode;
    // data['idWarehouse'] = idWarehouse;
    // data['stockQuantity'] = stockQuantity;
    // data['minStockQuantity'] = minStockQuantity;
    data['deleted'] = deleted;
    data['createdByUserAppInstitution'] = createdByUserAppInstitution;
    data['imageData'] = imageData;
    return data;
  }
}
