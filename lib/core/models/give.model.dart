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
      this.sesso,
      required this.email,
      required this.tel,
      required this.cell,
      // required this.nazioneNnNorm,
      // required this.provNnNorm,
      // required this.capNnNorm,
      // required this.cittaNnNorm,
      // required this.indirizzoNnNorm,
      // required this.nCivicoNnNorm,
      this.comCartacee,
      this.comEmail,
      this.consensoRingrazia,
      this.consensoMaterialeInfo,
      this.consensoComEspresso,
      this.consensoMarketing,
      this.consensoSms,
      required this.dataNascita,
      this.tipoDonatore,
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
  // late final String nazioneNnNorm;
  // late final String provNnNorm;
  // late final String capNnNorm;
  // late final String cittaNnNorm;
  // late final String indirizzoNnNorm;
  // late final String nCivicoNnNorm;
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
  late final List<ContattiGiveModel> contattiGiveModel;

  StakeholderGiveModelSearch.empty() {
    id = 0;
    nome = '';
    cognome = '';
    ragionesociale = '';
    codfisc = '';
    sesso = null;
    email = '';
    tel = '';
    cell = '';
    // nazioneNnNorm = '';
    // provNnNorm = '';
    // capNnNorm = '';
    // cittaNnNorm = '';
    // indirizzoNnNorm = '';
    // nCivicoNnNorm = '';
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
    contattiGiveModel = List.empty();
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
    // nazioneNnNorm = json['nazione_nn_norm'] ?? '';
    // provNnNorm = json['prov_nn_norm'] ?? '';
    // capNnNorm = json['cap_nn_norm'] ?? '';
    // cittaNnNorm = json['citta_nn_norm'] ?? '';
    // indirizzoNnNorm = json['indirizzo_nn_norm'] ?? '';
    // nCivicoNnNorm = json['n_civico_nn_norm'] ?? '';
    comCartacee = json['com_cartacee'];
    comEmail = json['com_email'];
    consensoRingrazia = json['consenso_ringrazia'];
    consensoMaterialeInfo = json['consenso_materiale_info'];
    consensoComEspresso = json['consenso_com_espresso'];
    consensoMarketing = json['consenso_marketing'];
    consensoSms = json['consenso_sms'];
    dataNascita = json['datanascita'] ?? '';
    tipoDonatore = json['tipo_donatore'];
    if (json['recapito'] != null) {
      recapitoGiveModel = RecapitoGiveModel.fromJson(json['recapito']);
    } else {
      recapitoGiveModel = RecapitoGiveModel.empty();
    }

    if (json['contatti'] != null) {
      contattiGiveModel = List.from(json['contatti'])
          .map((e) => ContattiGiveModel.fromJson(e))
          .toList();
    } else {
      contattiGiveModel = List.empty();
    }
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

class RecapitoGiveModel {
  RecapitoGiveModel({
    required this.nazione,
    required this.regione,
    required this.prov,
    required this.siglaProv,
    required this.citta,
    required this.cap,
    required this.indirizzo,
    required this.nCivico,
    required this.localita,
    required this.statoFederale,
    required this.suddivisioneComune_2,
    required this.suddivisioneComune_3,
    required this.rigaPosta3,
    required this.rigaPosta4,
    required this.rigaPosta5,
    required this.rigaPosta6,
    required this.rigaPosta7,
    required this.isNormalizzato,
    required this.righePostaliManuali,
  });
  late final String nazione;
  late final String regione;
  late final String prov;
  late final String siglaProv;
  late final String citta;
  late final String cap;
  late final String indirizzo;
  late final String nCivico;
  late final String localita;
  late final String statoFederale;
  late final String suddivisioneComune_2;
  late final String suddivisioneComune_3;
  late final String rigaPosta3;
  late final String rigaPosta4;
  late final String rigaPosta5;
  late final String rigaPosta6;
  late final String rigaPosta7;
  late final int? isNormalizzato;
  late final int? righePostaliManuali;

  RecapitoGiveModel.empty() {
    nazione = '';
    regione = '';
    prov = '';
    siglaProv = '';
    citta = '';
    cap = '';
    indirizzo = '';
    nCivico = '';
    localita = '';
    statoFederale = '';
    suddivisioneComune_2 = '';
    suddivisioneComune_3 = '';
    rigaPosta3 = '';
    rigaPosta4 = '';
    rigaPosta5 = '';
    rigaPosta6 = '';
    rigaPosta7 = '';
    isNormalizzato = 0;
    righePostaliManuali = 0;
  }

  RecapitoGiveModel.fromJson(Map<String, dynamic> json) {
    nazione = json['nazione'] ?? '';
    regione = json['regione'] ?? '';
    prov = json['prov'] ?? '';
    citta = json['citta'] ?? '';
    cap = json['cap'] ?? '';
    indirizzo = json['indirizzo'] ?? '';
    nCivico = json['nCivico'] ?? '';
    localita = json['localita'] ?? '';
    statoFederale = json['statoFederale'] ?? '';
    suddivisioneComune_2 = json['suddivisioneComune_2'] ?? '';
    suddivisioneComune_3 = json['suddivisioneComun3_2'] ?? '';
    rigaPosta3 = json['rigaPosta3'] ?? '';
    rigaPosta4 = json['rigaPosta4'] ?? '';
    rigaPosta5 = json['rigaPosta5'] ?? '';
    rigaPosta6 = json['rigaPosta6'] ?? '';
    rigaPosta7 = json['rigaPosta7'] ?? '';
    isNormalizzato = json['isNormalizzato'] ?? 0;
    righePostaliManuali = json['righePostaliManuali'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['nazione'] = nazione;
    // data['regione'] = regione;
    // data['prov'] = prov;
    // data['citta'] = citta;
    // data['cap'] = cap;
    // data['indirizzo'] = indirizzo;
    // data['nCivico'] = nCivico;
    // data['localita'] = localita;
    // data['statoFederale'] = statoFederale;
    // data['suddivisioneComune_2'] = suddivisioneComune_2;
    // data['suddivisioneComune_3'] = suddivisioneComune_3;
    // data['rigaPosta3'] = rigaPosta3;
    // data['rigaPosta4'] = rigaPosta4;
    // data['rigaPosta5'] = rigaPosta5;
    // data['rigaPosta6'] = rigaPosta6;
    // data['rigaPosta7'] = rigaPosta7;
    // data['cap'] = cap;
    // data['citta'] = citta;
    // data['prov'] = prov;
    return data;
  }
}

class ContattiGiveModel {
  ContattiGiveModel({
    required this.id,
    required this.idStakeholder,
    required this.nome,
    required this.cognome,
    required this.sesso,
    required this.email,
    required this.tel,
    required this.cell,
    // required this.fax,
    required this.codicefiscale,
    required this.dataNascita,
    // required this.comCartacee,
    // required this.comEmail,
    // required this.consensoRingrazia,
    // required this.consensoMaterialeInfo,
    // required this.consensoComEspresso,
    // required this.consensoMarketing,
    // required this.consensoSms
  });

  late int id;
  late int idStakeholder;
  late final String nome;
  late final String cognome;
  late final int? sesso;
  late final String email;
  late final String tel;
  late final String cell;
  late final String fax;
  late final String codicefiscale;
  late final String dataNascita;
  late final int? comCartacee;
  late final int? comEmail;
  late final int? consensoRingrazia;
  late final int? consensoMaterialeInfo;
  late final int? consensoComEspresso;
  late final int? consensoMarketing;
  late final int? consensoSms;

  ContattiGiveModel.empty() {
    id = 0;
    idStakeholder = 0;
    nome = '';
    cognome = '';
    sesso = null;
    email = '';
    tel = '';
    cell = '';
    fax = '';
    codicefiscale = '';
    dataNascita = '';
    comCartacee = 0;
    comEmail = 0;
    consensoRingrazia = 0;
    consensoMaterialeInfo = 0;
    consensoComEspresso = 0;
    consensoMarketing = 0;
    consensoSms = 0;
  }

  ContattiGiveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idStakeholder = json['donatore'];
    nome = json['nome'] ?? '';
    cognome = json['cognome'] ?? '';
    sesso = json['sesso'];
    tel = json['tel'] ?? '';
    cell = json['cell'] ?? '';
    fax = json['fax'] ?? '';
    email = json['email'] ?? '';
    codicefiscale = json['codicefiscale'] ?? '';
    dataNascita = json['dataNascita'] ?? '';
    // comCartacee = json['com_cartacee'];
    // comEmail = json['com_email'];
    // consensoRingrazia = json['consenso_ringrazia'];
    // consensoMaterialeInfo = json['consenso_materiale_info'];
    // consensoComEspresso = json['consenso_com_espresso'];
    // consensoMarketing = json['consenso_marketing'];
    // consensoSms = json['consenso_sms'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['id'] = id;
    // data['idStakeholder'] = idStakeholder;
    // data['nome'] = nome;
    // data['cognome'] = cognome;
    // data['sesso'] = sesso;
    // data['email'] = email;
    // data['tel'] = tel;
    // data['cell'] = cell;
    // data['fax'] = fax;
    // data['codicefiscale'] = codicefiscale;
    // data['recapitoGiveModel'] = recapitoGiveModel.toJson();
    return data;
  }
}
