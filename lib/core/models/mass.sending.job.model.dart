import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/core/models/mass.sending.model.dart';

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
    required this.webhooksEvent,
    required this.dateLastUpdate,
    required this.massSendingModel,
    required this.massSendingModelNameComunication,
  });

  late final String idMassSendingJob;
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
  late final List<WebhooksEvent>? webhooksEvent;
  late final DateTime? dateLastUpdate;
  late final MassSendingModel massSendingModel;
  late final String massSendingModelNameComunication;

  MassSendingJobModel.empty() {
    idMassSendingJob = '';
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
    webhooksEvent = List.empty();
    dateLastUpdate = DateTime.now();
    massSendingModel = MassSendingModel.empty();
    massSendingModelNameComunication = '';
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

    webhooksEvent = List.from(json['webhooksEvent'])
        .map((e) => WebhooksEvent.fromJson(e))
        .toList();

    if (json['dateLastUpdate'] != null) {
      var dateTimeU =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateLastUpdate'], true);
      dateLastUpdate = dateTimeU.toLocal();
    } else {
      dateLastUpdate = null;
    }
    if (json['idMassSendingNavigation'] != null) {
      massSendingModel =
          MassSendingModel.fromJson(json['idMassSendingNavigation']);
    } else {
      massSendingModel = MassSendingModel.empty();
    }

    if (json['massSendingName'] != null) {
      massSendingModelNameComunication = json['massSendingName'];
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
    data['webhooksEvent'] = webhooksEvent;
    data['dateLastUpdate'] = dateLastUpdate;
    data['idMassSendingNavigation'] = massSendingModel;
    data['massSendingModelNameComunication'] = massSendingModelNameComunication;
    return data;
  }
}

class MassSendingJobModelForEventDetail {
  MassSendingJobModelForEventDetail({
    required this.emailSh,
    required this.emailId,
    required this.webhooksEvent,
    required this.dateLastUpdate,
  });

  late final String emailSh;
  late final String emailId;
  late final List<WebhooksEvent>? webhooksEvent;
  late final DateTime? dateLastUpdate;
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

class WebhooksEvent {
  WebhooksEvent({
    required this.event,
    required this.dateUpdate,
  });

  late final String event;
  late final DateTime dateUpdate;

  // Empty constructor with default values
  WebhooksEvent.empty() {
    event = '';
    dateUpdate = DateTime.now();
  }
  // JSON deserialization
  WebhooksEvent.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    var dateTimeU =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateUpdate'], true);
    dateUpdate = dateTimeU.toLocal();
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['event'] = event;
    data['dateUpdate'] = dateUpdate;
    return data;
  }
}
