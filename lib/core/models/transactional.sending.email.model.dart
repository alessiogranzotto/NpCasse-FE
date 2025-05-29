import 'package:intl/intl.dart';
import 'package:np_casse/core/models/comunication.model.dart';

class TransactionalSendingEmailModel {
  TransactionalSendingEmailModel({
    required this.idTransactionalSendingEmail,
    required this.idInstitution,
    required this.idTransactionalSending,
    required this.dateSend,
    required this.idStakeholder,
    required this.denominationStakeholder,
    required this.emailStakeholder,
    required this.emailId,
    required this.webhooksEvent,
    required this.dateLastUpdate,
    required this.transactionSendingModelNameComunication,
  });

  late final String idTransactionalSendingEmail;
  late final int idInstitution;
  late final int idTransactionalSending;
  late final DateTime dateSend;
  late final int idStakeholder;
  late final String denominationStakeholder;
  late final String emailStakeholder;
  late final String emailId;
  late final List<WebhooksEvent>? webhooksEvent;
  late final DateTime? dateLastUpdate;
  late final String transactionSendingModelNameComunication;

  TransactionalSendingEmailModel.empty() {
    idTransactionalSendingEmail = '';
    idInstitution = 0;
    idTransactionalSending = 0;
    dateSend = DateTime.now();
    idStakeholder = 0;
    denominationStakeholder = '';
    emailStakeholder = '';
    emailId = '';
    webhooksEvent = List.empty();
    dateLastUpdate = DateTime.now();
    transactionSendingModelNameComunication = '';
  }

  // JSON deserialization
  TransactionalSendingEmailModel.fromJson(Map<String, dynamic> json) {
    idTransactionalSendingEmail = json['idTransactionalSendingEmail'];
    idInstitution = json['idInstitution'];
    idTransactionalSending = json['idTransactionalSending'];
    var dateTimeS =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateSend'], true);
    dateSend = dateTimeS.toLocal();

    idStakeholder = json['idStakeholder'];
    denominationStakeholder = json['denominationStakeholder'];
    emailStakeholder = json['emailStakeholder'];
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

    if (json['transactionalSendingName'] != null) {
      transactionSendingModelNameComunication =
          json['transactionalSendingName'];
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idTransactionalSendingEmail'] = idTransactionalSendingEmail;
    data['idInstitution'] = idInstitution;
    data['idTransactionalSending'] = idTransactionalSending;
    data['dateSend'] = dateSend;
    data['idStakeholder'] = idStakeholder;
    data['denominationStakeholder'] = denominationStakeholder;
    data['emailStakeholder'] = emailStakeholder;
    data['emailId'] = emailId;
    data['webhooksEvent'] = webhooksEvent;
    data['dateLastUpdate'] = dateLastUpdate;
    data['transactionSendingModelNameComunication'] =
        transactionSendingModelNameComunication;
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
