class StakeholderGiveModelWithRulesSearch {
  StakeholderGiveModelWithRulesSearch(
      {required this.operationResult,
      required this.donatoriOk,
      required this.donatoriWithRulesDeduplica});
  String operationResult = "";
  StakeholderGiveModelSearch? donatoriOk;
  List<StakeholderDeduplicaResult>? donatoriWithRulesDeduplica;

  StakeholderGiveModelWithRulesSearch.fromJson(Map<String, dynamic> json) {
    if (json['donatoriOk'] != null) {
      donatoriOk = StakeholderGiveModelSearch.fromJson(json['donatoriOk']);
    }
    if (json['donatoriWithRulesDeduplica'] != null) {
      donatoriWithRulesDeduplica = List.from(json['donatoriWithRulesDeduplica'])
          .map((e) => StakeholderDeduplicaResult.fromJson(e))
          .toList();
    }
  }
  StakeholderGiveModelWithRulesSearch.empty() {
    operationResult = '';
    donatoriOk = null;
    donatoriWithRulesDeduplica = null;
  }
}

class StakeholderDeduplicaResult {
  StakeholderDeduplicaResult(
      {required this.rules, required this.stakeholderGiveModelSearch});
  late String rules;
  late StakeholderGiveModelSearch stakeholderGiveModelSearch;

  StakeholderDeduplicaResult.fromJson(Map<String, dynamic> json) {
    rules = json['rules'];
    stakeholderGiveModelSearch =
        StakeholderGiveModelSearch.fromJson(json['donatori']);
  }
}

class StakeholderGiveModelSearch {
  StakeholderGiveModelSearch(
      {required this.id,
      required this.nome,
      required this.cognome,
      required this.ragionesociale,
      required this.codfisc,
      required this.sesso,
      required this.email,
      required this.tel,
      required this.cell,
      required this.nazioneNnNorm,
      required this.provNnNorm,
      required this.capNnNorm,
      required this.cittaNnNorm,
      required this.indirizzoNnNorm,
      required this.nCivicoNnNorm,
      required this.comCartacee,
      required this.comEmail,
      required this.consensoRingrazia,
      required this.consensoMaterialeInfo,
      required this.consensoComEspresso,
      required this.consensoMarketing,
      required this.consensoSms,
      required this.dataNascita,
      required this.tipoDonatore,
      required this.recapitoGiveModel});
  late int id;
  late final String nome;
  late final String cognome;
  late final String ragionesociale;
  late final String codfisc;
  late final int? sesso;
  late final String email;
  late final String tel;
  late final String cell;
  late final String nazioneNnNorm;
  late final String provNnNorm;
  late final String capNnNorm;
  late final String cittaNnNorm;
  late final String indirizzoNnNorm;
  late final String nCivicoNnNorm;
  late final int? comCartacee;
  late final int? comEmail;
  late final int? consensoRingrazia;
  late final int? consensoMaterialeInfo;
  late final int? consensoComEspresso;
  late final int? consensoMarketing;
  late final int? consensoSms;
  late final String dataNascita;
  late final int? tipoDonatore;
  late final RecapitoGiveModel recapitoGiveModel;

  StakeholderGiveModelSearch.empty() {
    id = 0;
    nome = '';
    cognome = '';
    ragionesociale = '';
    codfisc = '';
    sesso = 0;
    email = '';
    tel = '';
    cell = '';
    nazioneNnNorm = '';
    provNnNorm = '';
    capNnNorm = '';
    cittaNnNorm = '';
    indirizzoNnNorm = '';
    nCivicoNnNorm = '';
    comCartacee = 0;
    comEmail = 0;
    consensoRingrazia = 0;
    consensoMaterialeInfo = 0;
    consensoComEspresso = 0;
    consensoMarketing = 0;
    consensoSms = 0;
    dataNascita = '';
    tipoDonatore = 0;
    recapitoGiveModel = RecapitoGiveModel.empty();
  }
  StakeholderGiveModelSearch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'] ?? '';
    cognome = json['cognome'] ?? '';
    ragionesociale = json['ragionesociale'] ?? '';
    codfisc = json['codfisc'] ?? '';
    sesso = json['sesso'];
    email = json['email'] ?? '';
    tel = json['tel'] ?? '';
    cell = json['cell'] ?? '';
    nazioneNnNorm = json['nazione_nn_norm'] ?? '';
    provNnNorm = json['prov_nn_norm'] ?? '';
    capNnNorm = json['cap_nn_norm'] ?? '';
    cittaNnNorm = json['citta_nn_norm'] ?? '';
    indirizzoNnNorm = json['indirizzo_nn_norm'] ?? '';
    nCivicoNnNorm = json['n_civico_nn_norm'] ?? '';
    comCartacee = json['com_cartacee'];
    comEmail = json['com_email'];
    consensoRingrazia = json['consenso_ringrazia'];
    consensoMaterialeInfo = json['consenso_materiale_info'];
    consensoComEspresso = json['consenso_com_espresso'];
    consensoMarketing = json['consenso_marketing'];
    consensoSms = json['consenso_sms'];
    dataNascita = json['datanascita'] ?? '';
    tipoDonatore = json['tipo_donatore'];
    recapitoGiveModel = RecapitoGiveModel.fromJson(json['recapito']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['cognome'] = cognome;
    data['ragionesociale'] = ragionesociale;
    data['codfisc'] = codfisc;
    data['email'] = email;
    data['tel'] = tel;
    data['cell'] = cell;
    data['recapitoGiveModel'] = recapitoGiveModel.toJson();
    return data;
  }
}

class RecapitoGiveModel {
  RecapitoGiveModel(
      {required this.indirizzo,
      required this.nCivico,
      required this.cap,
      required this.citta});
  late final String indirizzo;
  late final String nCivico;
  late final String cap;
  late final String citta;
  late final String prov;

  RecapitoGiveModel.empty() {
    indirizzo = '';
    nCivico = '';
    cap = '';
    citta = '';
    prov = '';
  }
  RecapitoGiveModel.fromJson(Map<String, dynamic> json) {
    indirizzo = json['indirizzo'] ?? '';
    nCivico = json['n_civico'] ?? '';
    cap = json['cap'] ?? '';
    citta = json['citta'] ?? '';
    prov = json['prov'] ?? '';
  }

  // factory RecapitoGiveModel.fromMap(Map<String, dynamic> json) {
  //   return RecapitoGiveModel(indirizzo: "", nCivico: "", cap: "", citta: "");
  // }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['indirizzo'] = indirizzo;
    data['n_civico'] = nCivico;
    data['cap'] = cap;
    data['citta'] = citta;
    data['prov'] = prov;
    return data;
  }
}
