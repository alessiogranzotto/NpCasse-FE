import 'package:np_casse/core/models/cart.product.model.dart';

class ProductHistoryModel {
  ProductHistoryModel({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.totalAmount,
    required this.hasPrevious,
    required this.hasNext,
    required this.productHistoryList, // Add to constructor
  });

  late final int currentPage;
  late final int totalPages;
  late final int pageSize;
  late final int totalCount;
  late final double totalAmount;
  late final bool hasPrevious;
  late final bool hasNext;
  late final List<CartProductModel> productHistoryList;

  // Empty constructor with default values
  ProductHistoryModel.empty() {
    currentPage = 0;
    totalPages = 0;
    pageSize = 0;
    totalCount = 0;
    totalAmount = 0;
    hasPrevious = false;
    hasNext = false;
    productHistoryList = List.empty();
  }

  // JSON deserialization
  ProductHistoryModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalAmount = json['totalAmount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
    productHistoryList = List.from(json['data'])
        .map((e) => CartProductModel.fromJson(e))
        .toList();
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    data['data'] = productHistoryList.map((e) => e.toJson()).toList();
    return data;
  }
}
