import 'package:intl/intl.dart';

class MassSendingJobModel {
  MassSendingJobModel({
    required this.idMassSendingJob,
    required this.idInstitution,
    required this.idMassSending,
    required this.dateBuilt,
    required this.dateSend,
    required this.attachSh,
    required this.nameSh,
    required this.surnameSh,
    required this.businessNameSh,
    required this.emailSh,
    required this.emailId,
    required this.stateMassSendingJob,
    required this.dateStateMassSendingJob,
  });

  late final int idMassSendingJob;
  late final int idInstitution;
  late final int idMassSending;
  late final DateTime dateBuilt;
  late final DateTime? dateSend;
  late final String attachSh;
  late final String nameSh;
  late final String surnameSh;
  late final String businessNameSh;
  late final String emailSh;
  late final String emailId;
  late final String stateMassSendingJob;
  late final DateTime? dateStateMassSendingJob;

  MassSendingJobModel.empty() {
    idMassSendingJob = 0;
    idInstitution = 0;
    idMassSending = 0;
    dateBuilt = DateTime.now();
    dateSend = null;
    attachSh = '';
    nameSh = '';
    surnameSh = '';
    businessNameSh = '';
    emailSh = '';
    emailId = '';
    stateMassSendingJob = '';
    dateStateMassSendingJob = null;
  }

  // JSON deserialization
  MassSendingJobModel.fromJson(Map<String, dynamic> json) {
    idMassSendingJob = json['idMassSendingJob'];
    idInstitution = json['idInstitution'];
    idMassSending = json['idMassSending'];
    var dateTimeB =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateBuilt'], true);
    dateBuilt = dateTimeB.toLocal();
    if (json['dateSend'] != null) {
      var dateTimeS =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateSend'], true);
      dateSend = dateTimeS.toLocal();
    } else {
      dateSend = null;
    }
    attachSh = json['attachSh'];
    nameSh = json['nameSh'];
    surnameSh = json['surnameSh'];
    businessNameSh = json['businessNameSh'];
    emailSh = json['emailSh'];
    emailId = json['emailId'];
    stateMassSendingJob = json['stateMassSendingJob'];
    if (json['dateStateMassSendingJob'] != null) {
      var dateTimeS = DateFormat("yyyy-MM-ddTHH:mm:ss")
          .parse(json['dateStateMassSendingJob'], true);
      dateStateMassSendingJob = dateTimeS.toLocal();
    } else {
      dateStateMassSendingJob = null;
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idMassSendingJob'] = idMassSendingJob;
    data['idInstitution'] = idInstitution;
    data['idMassSending'] = idMassSending;
    data['dateBuilt'] = dateBuilt;
    data['dateSend'] = dateSend;
    data['attachSh'] = attachSh;
    data['nameSh'] = nameSh;
    data['surnameSh'] = surnameSh;
    data['businessNameSh'] = businessNameSh;
    data['emailSh'] = emailSh;
    data['emailId'] = emailId;
    data['stateMassSendingJob'] = stateMassSendingJob;
    data['dateStateMassSendingJob'] = dateStateMassSendingJob;
    return data;
  }
}

class MassSendingGiveAccumulator {
  MassSendingGiveAccumulator(
      {required this.idGiveAccumulator, required this.titleGiveAccumulator});

  late final int idGiveAccumulator;
  late final String titleGiveAccumulator;

  // JSON deserialization
  MassSendingGiveAccumulator.fromJson(Map<String, dynamic> json) {
    idGiveAccumulator = json['idGiveAccumulator'];
    titleGiveAccumulator = json['titleGiveAccumulator'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idGiveAccumulator'] = idGiveAccumulator;
    data['titleGiveAccumulator'] = titleGiveAccumulator;
    return data;
  }
}
