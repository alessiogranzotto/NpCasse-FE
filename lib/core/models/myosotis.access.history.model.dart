import 'package:np_casse/core/models/myosotis.access.model.dart';

class MyosotisAccessHistoryModel {
  MyosotisAccessHistoryModel({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.totalAmount,
    required this.hasPrevious,
    required this.hasNext,
    required this.myosotisAccessHistoryList, // Add to constructor
  });

  late final int currentPage;
  late final int totalPages;
  late final int pageSize;
  late final int totalCount;
  late final double totalAmount;
  late final bool hasPrevious;
  late final bool hasNext;
  late final List<MyosotisAccessModel> myosotisAccessHistoryList;

  // Empty constructor with default values
  MyosotisAccessHistoryModel.empty() {
    currentPage = 0;
    totalPages = 0;
    pageSize = 0;
    totalCount = 0;
    totalAmount = 0;
    hasPrevious = false;
    hasNext = false;
    myosotisAccessHistoryList = List.empty();
  }

  // JSON deserialization
  MyosotisAccessHistoryModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalAmount = json['totalAmount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
    myosotisAccessHistoryList = List.from(json['data'])
        .map((e) => MyosotisAccessModel.fromJson(e))
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
    data['data'] = myosotisAccessHistoryList.map((e) => e.toJson()).toList();
    return data;
  }
}
