import 'package:intl/intl.dart';

class TemplateSmtp2GoModel {
  TemplateSmtp2GoModel({
    required this.name,
    required this.id,
    required this.subject,
  });

  late final String name;
  late final String id;
  late final String subject;

  TemplateSmtp2GoModel.empty() {
    name = '';
    id = '';
    subject = '';
  }

  // JSON deserialization
  TemplateSmtp2GoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    subject = json['subject'];
  }

  // JSON serialization
  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['name'] = name;
  //   data['id'] = id;
  //   data['subject'] = subject;
  //   return data;
  // }
}

class TemplateDetailSmtp2GoModel {
  TemplateDetailSmtp2GoModel({
    required this.name,
    required this.id,
    required this.subject,
    required this.html_body,
    required this.text_body,
    required this.last_updated,
  });

  late final String name;
  late final String id;
  late final String subject;
  late final String html_body;
  late final String text_body;
  late final String last_updated;

  // JSON deserialization
  TemplateDetailSmtp2GoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    subject = json['subject'];
    html_body = json['html_body'];
    text_body = json['text_body'];
    last_updated = json['last_updated'];
  }

  // JSON serialization
  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['name'] = name;
  //   data['id'] = id;
  //   data['subject'] = subject;
  //   data['html_body'] = html_body;
  //   data['text_body'] = text_body;
  //   data['last_updated'] = last_updated;
  //   return data;
  // }
}

class AccumulatorGiveModel {
  AccumulatorGiveModel({
    required this.id,
    required this.titolo,
    required this.descrizione,
    required this.codice_tipo,
    required this.associazione,
    required this.quando,
    required this.attivo,
    required this.user,
    required this.selezionato,
  });

  late final int id;
  late final String titolo;
  late final String descrizione;
  late final int codice_tipo;
  late final int associazione;
  late final String quando;
  late final int attivo;
  late final int user;
  late final int selezionato;

  // JSON deserialization
  AccumulatorGiveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titolo = json['titolo'];
    descrizione = json['descrizione'];
    codice_tipo = json['codice_tipo'];
    associazione = json['associazione'];
    quando = json['quando'];
    attivo = json['attivo'];
    user = json['user'];
    selezionato = json['selezionato'];
  }

  // JSON serialization
  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['name'] = name;
  //   return data;
  // }
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

class ComunicationStatistics {
  ComunicationStatistics(
      {required this.parameterName, required this.parameterValue});

  late final String parameterName;
  late final int parameterValue;

  // JSON deserialization
  ComunicationStatistics.fromJson(Map<String, dynamic> json) {
    parameterName = json['parameterName'];
    parameterValue = json['parameterValue'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['parameterName'] = parameterName;
    data['parameterValue'] = parameterValue;
    return data;
  }
}

class MassSendingModel {
  MassSendingModel({
    required this.idMassSending,
    required this.idInstitution,
    this.dateIns,
    this.idUserAppInstitutionIns,
    this.dateMod,
    this.idUserAppInstitutionMod,
    this.idUserAppInstitution,
    required this.deleted,
    required this.nameMassSending,
    required this.descriptionMassSending,
    required this.senderMassSending,
    required this.emailSenderMassSending,
    required this.idTemplateMassSending,
    this.planningDate,
    this.stateMassSending,
    required this.frequencyTypeMassSending,
    this.executeStepMassSending,
    this.advanceHoursLoadAccumulatorMassSending,
    required this.emailDeduplicationMassSending,
    required this.onlyToNewSendMassSending,
    required this.onlyToNotOpenMassSending,
    this.lastExecutionMassSending,
    this.nextExecutionMassSending,
    this.stateMassSendingDescription,
    required this.massSendingGiveAccumulators,
  });

  late final int idMassSending;
  late final int idInstitution;
  DateTime? dateIns;
  int? idUserAppInstitutionIns;
  DateTime? dateMod;
  int? idUserAppInstitutionMod;
  int? idUserAppInstitution;
  late final bool deleted;
  late final String nameMassSending;
  late final String descriptionMassSending;
  late final String senderMassSending;
  late final String emailSenderMassSending;
  late final String idTemplateMassSending;
  DateTime? planningDate;
  int? stateMassSending;

  String? frequencyTypeMassSending;
  int? executeStepMassSending;
  int? advanceHoursLoadAccumulatorMassSending;
  late final bool emailDeduplicationMassSending;
  late final bool onlyToNewSendMassSending;
  late final bool onlyToNotOpenMassSending;
  DateTime? lastExecutionMassSending;
  DateTime? nextExecutionMassSending;

  String? stateMassSendingDescription;
  late final List<MassSendingGiveAccumulator> massSendingGiveAccumulators;

  MassSendingModel.empty() {
    idMassSending = 0;
    idInstitution = 0;
    dateIns = null;
    idUserAppInstitutionIns = null;
    dateMod = null;
    idUserAppInstitutionMod = null;
    idUserAppInstitution = null;
    deleted = false;
    nameMassSending = '';
    descriptionMassSending = '';
    senderMassSending = '';
    emailSenderMassSending = '';
    idTemplateMassSending = '';
    planningDate = null;
    stateMassSending = null;
    frequencyTypeMassSending = null;
    executeStepMassSending = null;
    advanceHoursLoadAccumulatorMassSending = null;
    emailDeduplicationMassSending = false;
    onlyToNewSendMassSending = false;
    onlyToNotOpenMassSending = false;
    lastExecutionMassSending = null;
    nextExecutionMassSending = null;
    stateMassSendingDescription = '';
    massSendingGiveAccumulators = List.empty();
  }

  // JSON deserialization
  MassSendingModel.fromJson(Map<String, dynamic> json) {
    idMassSending = json['idMassSending'];
    idInstitution = json['idInstitution'];
    var dateTimeC =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateIns'], true);
    var dateLocalC = dateTimeC.toLocal();
    dateIns = dateLocalC;
    idUserAppInstitutionIns = json['idUserAppInstitutionIns'];

    if (json['dateMod'] != null) {
      var dateTimeU =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateMod'], true);
      var dateLocalU = dateTimeU.toLocal();
      dateMod = dateLocalU;
    }
    if (json['idUserAppInstitutionMod'] != null) {
      idUserAppInstitutionMod = json['idUserAppInstitutionMod'];
    }

    deleted = json['deleted'];
    nameMassSending = json['nameMassSending'];
    descriptionMassSending = json['descriptionMassSending'];
    senderMassSending = json['senderMassSending'];
    emailSenderMassSending = json['emailSenderMassSending'];
    idTemplateMassSending = json['idTemplateMassSending'];
    var dateTimePD =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['planningDate'], true);
    planningDate = dateTimePD.toLocal();
    stateMassSending = json['stateMassSending'];
    frequencyTypeMassSending = json['frequencyTypeMassSending'];
    executeStepMassSending = json['executeStepMassSending'];
    advanceHoursLoadAccumulatorMassSending =
        json['advanceHoursLoadAccumulatorMassSending'];
    emailDeduplicationMassSending = json['emailDeduplicationMassSending'];
    onlyToNewSendMassSending = json['onlyToNewSendMassSending'];
    onlyToNotOpenMassSending = json['onlyToNotOpenMassSending'];
    if (json['lastExecutionMassSending'] != null) {
      var dateTimeLE = DateFormat("yyyy-MM-ddTHH:mm:ss")
          .parse(json['lastExecutionMassSending'], true);
      var dateLocalLE = dateTimeLE.toLocal();
      lastExecutionMassSending = dateLocalLE;
    }
    if (json['nextExecutionMassSending'] != null) {
      var dateTimeNE = DateFormat("yyyy-MM-ddTHH:mm:ss")
          .parse(json['nextExecutionMassSending'], true);
      var dateLocalNE = dateTimeNE.toLocal();
      nextExecutionMassSending = dateLocalNE;
    }
    stateMassSendingDescription = json['stateMassSendingDescription'] ?? null;
    massSendingGiveAccumulators = List.from(json['massSendingGiveAccumulators'])
        .map((e) => MassSendingGiveAccumulator.fromJson(e))
        .toList();
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idMassSending'] = idMassSending;
    data['idInstitution'] = idInstitution;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['deleted'] = deleted;
    data['nameMassSending'] = nameMassSending;
    data['descriptionMassSending'] = descriptionMassSending;
    data['senderMassSending'] = senderMassSending;
    data['emailSenderMassSending'] = emailSenderMassSending;
    data['idTemplateMassSending'] = idTemplateMassSending;
    data['planningDate'] = planningDate?.toIso8601String();
    data['frequencyTypeMassSending'] = frequencyTypeMassSending;
    data['executeStepMassSending'] = executeStepMassSending;
    data['advanceHoursLoadAccumulatorMassSending'] =
        advanceHoursLoadAccumulatorMassSending;
    data['emailDeduplicationMassSending'] = emailDeduplicationMassSending;
    data['onlyToNewSendMassSending'] = onlyToNewSendMassSending;
    data['onlyToNotOpenMassSending'] = onlyToNotOpenMassSending;
    data['massSendingGiveAccumulators'] =
        massSendingGiveAccumulators.map((e) => e.toJson()).toList();
    return data;
  }
}

class TransactionalSendingModel {
  TransactionalSendingModel(
      {required this.idTransactionalSending,
      required this.idInstitution,
      required this.idUserAppInstitution,
      required this.archived,
      required this.nameTransactionalSending,
      required this.descriptionTransactionalSending,
      required this.senderTransactionalSending,
      required this.emailSenderTransactionalSending,
      required this.idTemplateTransactionalSending,
      required this.idAttachTransactionalSending,
      required this.actionTransactionalSending});

  late final int idTransactionalSending;
  late final int idInstitution;
  late final int idUserAppInstitution;
  late final bool archived;
  late final String nameTransactionalSending;
  late final String descriptionTransactionalSending;
  late final String senderTransactionalSending;
  late final String emailSenderTransactionalSending;
  late final String? idTemplateTransactionalSending;
  late final String? idAttachTransactionalSending;
  late final String actionTransactionalSending;

  TransactionalSendingModel.empty() {
    idTransactionalSending = 0;
    idInstitution = 0;
    archived = false;
    nameTransactionalSending = '';
    descriptionTransactionalSending = '';
    senderTransactionalSending = '';
    emailSenderTransactionalSending = '';
    actionTransactionalSending = '';
    idTemplateTransactionalSending = '';
    idAttachTransactionalSending = '';
  }

  // JSON deserialization
  TransactionalSendingModel.fromJson(Map<String, dynamic> json) {
    idTransactionalSending = json['idTransactionalSending'];
    idInstitution = json['idInstitution'];
    archived = json['archived'];
    nameTransactionalSending = json['nameTransactionalSending'];
    descriptionTransactionalSending = json['descriptionTransactionalSending'];
    senderTransactionalSending = json['senderTransactionalSending'];
    emailSenderTransactionalSending = json['emailSenderTransactionalSending'];
    actionTransactionalSending = json['actionTransactionalSending'];
    idTemplateTransactionalSending = json['idTemplateTransactionalSending'];
    idAttachTransactionalSending = json['idAttachTransactionalSending'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idTransactionalSending'] = idTransactionalSending;
    data['idInstitution'] = idInstitution;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['archived'] = archived;
    data['nameTransactionalSending'] = nameTransactionalSending;
    data['descriptionTransactionalSending'] = descriptionTransactionalSending;
    data['senderTransactionalSending'] = senderTransactionalSending;
    data['emailSenderTransactionalSending'] = emailSenderTransactionalSending;
    data['actionTransactionalSending'] = actionTransactionalSending;
    data['idTemplateTransactionalSending'] = idTemplateTransactionalSending;
    data['idAttachTransactionalSending'] = idAttachTransactionalSending;

    return data;
  }
}
