import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/myosotis.donation.model.dart';

class MyosotisDonationHistoryModel {
  MyosotisDonationHistoryModel({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.hasPrevious,
    required this.hasNext,
    required this.myosotisDonationHistoryList, // Add to constructor
  });

  late final int currentPage;
  late final int totalPages;
  late final int pageSize;
  late final int totalCount;
  late final bool hasPrevious;
  late final bool hasNext;
  late final List<MyosotisDonationModel> myosotisDonationHistoryList;

  // Empty constructor with default values
  MyosotisDonationHistoryModel.empty() {
    currentPage = 0;
    totalPages = 0;
    pageSize = 0;
    totalCount = 0;
    hasPrevious = false;
    hasNext = false;
    myosotisDonationHistoryList = List.empty();
  }

  // JSON deserialization
  MyosotisDonationHistoryModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
    myosotisDonationHistoryList = List.from(json['data'])
        .map((e) => MyosotisDonationModel.fromJson(e))
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
    data['data'] = myosotisDonationHistoryList.map((e) => e.toJson()).toList();
    return data;
  }
}
