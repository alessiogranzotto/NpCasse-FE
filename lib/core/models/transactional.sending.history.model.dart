import 'package:np_casse/core/models/transactional.sending.email.model.dart';

class TransactionalSendingHistoryModel {
  TransactionalSendingHistoryModel({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.hasPrevious,
    required this.hasNext,
    required this.TransactionalSendingHistoryList, // Add to constructor
  });

  late final int currentPage;
  late final int totalPages;
  late final int pageSize;
  late final int totalCount;
  late final bool hasPrevious;
  late final bool hasNext;
  late final List<TransactionalSendingEmailModel>
      TransactionalSendingHistoryList;

  // Empty constructor with default values
  TransactionalSendingHistoryModel.empty() {
    currentPage = 0;
    totalPages = 0;
    pageSize = 0;
    totalCount = 0;
    hasPrevious = false;
    hasNext = false;
    TransactionalSendingHistoryList = List.empty();
  }

  // JSON deserialization
  TransactionalSendingHistoryModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
    TransactionalSendingHistoryList = List.from(json['data'])
        .map((e) => TransactionalSendingEmailModel.fromJson(e))
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
    data['data'] =
        TransactionalSendingHistoryList.map((e) => e.toJson()).toList();
    return data;
  }
}
