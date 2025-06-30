class StakeholderGiveProDataModel {
  StakeholderGiveProDataModel({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.totalAmount,
    required this.hasPrevious,
    required this.hasNext,
    required this.stakeholderGiveproModel, // Add to constructor
  });

  late final int currentPage;
  late final int totalPages;
  late final int pageSize;
  late final int totalCount;
  late final double totalAmount;
  late final double totatotalAmountlCount;
  late final bool hasPrevious;
  late final bool hasNext;
  late final List<StakeholderGiveproModel> stakeholderGiveproModel;

  // Empty constructor with default values
  StakeholderGiveProDataModel.empty() {
    currentPage = 0;
    totalPages = 0;
    pageSize = 0;
    totalCount = 0;
    totalAmount = 0;
    hasPrevious = false;
    hasNext = false;
    stakeholderGiveproModel = List.empty();
  }

  // JSON deserialization
  StakeholderGiveProDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalAmount = json['totalAmount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
    stakeholderGiveproModel = List.from(json['data'])
        .map((e) => StakeholderGiveproModel.fromJson(e))
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
    data['data'] = stakeholderGiveproModel.map((e) => e.toJson()).toList();
    return data;
  }
}

class StakeholderGiveproModel {
  StakeholderGiveproModel(
      {required this.id,
      required this.nome,
      required this.cognome,
      required this.ragionesociale,
      required this.codfisc,
      required this.sesso,
      required this.email,
      required this.tel,
      required this.cell,
      required this.comCartacee,
      required this.comEmail,
      required this.consensoRingrazia,
      required this.consensoMaterialeInfo,
      required this.consensoComEspresso,
      required this.consensoMarketing,
      required this.consensoSms,
      required this.dataNascita,
      required this.tipoDonatore});
  late int id;
  late final String nome;
  late final String cognome;
  late final String ragionesociale;
  late final String codfisc;
  late final int? sesso;
  late final String email;
  late final String tel;
  late final String cell;
  late final int? comCartacee;
  late final int? comEmail;
  late final int? consensoRingrazia;
  late final int? consensoMaterialeInfo;
  late final int? consensoComEspresso;
  late final int? consensoMarketing;
  late final int? consensoSms;
  late final String dataNascita;
  late final int? tipoDonatore;

  StakeholderGiveproModel.fromJson(Map<String, dynamic> json) {
    id = json['shId'];
    nome = json['shNome'] ?? '';
    cognome = json['shCognome'] ?? '';
    ragionesociale = json['shRagionesociale'] ?? '';
    // codfisc = json['codfisc'] ?? '';
    // sesso = json['sesso'];
    // email = json['email'] ?? '';
    // tel = json['tel'] ?? '';
    // cell = json['cell'] ?? '';
    // comCartacee = json['com_cartacee'];
    // comEmail = json['com_email'];
    // consensoRingrazia = json['consenso_ringrazia'];
    // consensoMaterialeInfo = json['consenso_materiale_info'];
    // consensoComEspresso = json['consenso_com_espresso'];
    // consensoMarketing = json['consenso_marketing'];
    // consensoSms = json['consenso_sms'];
    // dataNascita = json['datanascita'] ?? '';
    // tipoDonatore = json['tipo_donatore'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['id'] = id;
    // data['nome'] = nome;
    // data['cognome'] = cognome;
    // data['ragionesociale'] = ragionesociale;
    // data['codfisc'] = codfisc;
    // data['email'] = email;
    // data['tel'] = tel;
    // data['cell'] = cell;
    // data['recapitoGiveModel'] = recapitoGiveModel.toJson();
    return data;
  }
}
