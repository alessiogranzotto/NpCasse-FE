class TemplateComunicationModel {
  TemplateComunicationModel({
    required this.name,
    required this.id,
    required this.subject,
  });

  late final String name;
  late final String id;
  late final String subject;

  TemplateComunicationModel.empty() {
    name = '';
    id = '';
    subject = '';
  }

  // JSON deserialization
  TemplateComunicationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    subject = json['subject'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['subject'] = subject;
    return data;
  }
}

class TemplateDetailComunicationModel {
  TemplateDetailComunicationModel({
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
  TemplateDetailComunicationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    subject = json['subject'];
    html_body = json['html_body'];
    text_body = json['text_body'];
    last_updated = json['last_updated'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['subject'] = subject;
    data['html_body'] = html_body;
    data['text_body'] = text_body;
    data['last_updated'] = last_updated;
    return data;
  }
}

class ComunicationModel {
  ComunicationModel({
    required this.idComunication,
    required this.nameComunication,
    required this.senderComunication,
    required this.emailSenderComunication,
    required this.subjectComunication,
    required this.idTemplateComunication,
    required this.idUserAppInstitution,
    required this.idInstitution,
  });

  late final int idComunication;
  late final String nameComunication;
  late final String senderComunication;
  late final String emailSenderComunication;
  late final String subjectComunication;
  late final String idTemplateComunication;
  late final int idUserAppInstitution;
  late final int idInstitution;

  // JSON deserialization
  ComunicationModel.fromJson(Map<String, dynamic> json) {
    idComunication = json['idComunication'];
    nameComunication = json['nameComunication'];
    senderComunication = json['senderComunication'];
    emailSenderComunication = json['emailSenderComunication'];
    subjectComunication = json['subjectComunication'];
    idTemplateComunication = json['idTemplateComunication'];
    idUserAppInstitution = json['idUserAppInstitution'];
    idInstitution = json['idInstitution'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idComunication'] = idComunication;
    data['nameComunication'] = nameComunication;
    data['senderComunication'] = senderComunication;
    data['emailSenderComunication'] = emailSenderComunication;
    data['subjectComunication'] = subjectComunication;
    data['idTemplateComunication'] = idTemplateComunication;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['idInstitution'] = idInstitution;
    return data;
  }
}
