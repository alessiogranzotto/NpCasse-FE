import 'package:intl/intl.dart';

class MyosotisDonationModel {
  MyosotisDonationModel({
    required this.idMyosotisFormData,
    required this.idInstitution,
    required this.idMyosotisConfiguration, // Include this in the constructor
    this.name,
    this.surname,
    this.businessName,
    this.codDest,
    this.cf,
    this.piva,
    this.birthDate,
    this.sex,
    this.email,
    this.phone,
    this.mobile,
    this.iso3Geo,
    this.countryGeo,
    this.stateGeo,
    this.regionGeo,
    this.provinceGeo,
    this.provinceCodeGeo,
    this.cityGeo,
    this.district1Geo,
    this.district2Geo,
    this.district3Geo,
    this.zipcodeGeo,
    this.streetGeo,
    this.numberAndExponentGeo,
    this.consentNewletter,
    this.consentPrivacy,
    required this.dateDonation,
    this.idProduct,
    this.idSubCategory,
    required this.amountDonation,
    required this.paymentType,
    required this.externalIdPayment1,
    this.externalIdPayment2,
    required this.idGive,
    required this.state,
    required this.typeDonation,
    required this.frequency,
    required this.currency,
    required this.optionalField,
    required this.stateDescription,
    required this.nameMyosotisConfiguration,
  });

  late final int idMyosotisFormData;
  late final int idInstitution;
  late final int idMyosotisConfiguration;
  late final String? name;
  late final String? surname;
  late final String? businessName;
  late final String? codDest;
  late final String? cf;
  late final String? piva;
  late final String? birthDate;
  late final bool? sex;
  late final String? email;
  late final String? phone;
  late final String? mobile;
  late final String? iso3Geo;
  late final String? countryGeo;
  late final String? stateGeo;
  late final String? regionGeo;
  late final String? provinceGeo;
  late final String? provinceCodeGeo;
  late final String? cityGeo;
  late final String? district1Geo;
  late final String? district2Geo;
  late final String? district3Geo;
  late final String? zipcodeGeo;
  late final String? streetGeo;
  late final String? numberAndExponentGeo;
  late final bool? consentNewletter;
  late final bool? consentPrivacy;
  late final DateTime dateDonation;
  late final int? idProduct;
  late final int? idSubCategory;
  late final double amountDonation;
  late final String paymentType;
  late final String? externalIdPayment1;
  late final String? externalIdPayment2;
  late final String idGive;
  late final int state;

  late final String typeDonation;
  late final String frequency;
  late final String currency;
  late final String? optionalField;

  late final String stateDescription;
  late final String nameMyosotisConfiguration;

  MyosotisDonationModel.fromJson(Map<String, dynamic> json) {
    idMyosotisFormData = json['idMyosotisFormData'];
    idInstitution = json['idInstitution'];
    idMyosotisConfiguration = json['idMyosotisConfiguration'];
    name = json['name'] ?? '';
    surname = json['surname'] ?? '';
    businessName = json['businessName'] ?? '';
    codDest = json['codDest'] ?? '';
    cf = json['cf'] ?? '';
    piva = json['piva'] ?? '';
    birthDate = json['birthDate'] ?? '';
    sex = json['sex'];
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    mobile = json['mobile'] ?? '';
    iso3Geo = json['iso3Geo'] ?? '';
    countryGeo = json['countryGeo'] ?? '';
    stateGeo = json['stateGeo'] ?? '';
    regionGeo = json['regionGeo'] ?? '';
    provinceGeo = json['provinceGeo'] ?? '';
    provinceCodeGeo = json['provinceCodeGeo'] ?? '';
    cityGeo = json['cityGeo'] ?? '';
    district1Geo = json['district1Geo'] ?? '';
    district2Geo = json['district2Geo'] ?? '';
    district3Geo = json['district3Geo'] ?? '';
    zipcodeGeo = json['zipcodeGeo'] ?? '';
    streetGeo = json['streetGeo'] ?? '';
    numberAndExponentGeo = json['numberAndExponentGeo'] ?? '';
    consentNewletter = json['consentNewletter'] ?? 0;
    consentPrivacy = json['consentPrivacy'] ?? 0;

    // var dateTimeC =
    //     DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateDonation'], true);
    // var dateLocalC = dateTimeC.toLocal();

    var rawDate = json['dateDonation'];

    if (rawDate is String) {
      dateDonation = DateTime.parse(rawDate).toLocal();
    } else if (rawDate is DateTime) {
      dateDonation = rawDate.toLocal();
    } else {
      dateDonation = DateTime.now(); // fallback di sicurezza
    }

    idProduct = json['idProduct'];
    idSubCategory = json['idSubCategory'];
    amountDonation = json['amountDonation'];
    paymentType = json['paymentType'];
    externalIdPayment1 = json['externalIdPayment1'];
    externalIdPayment2 = json['externalIdPayment2'] ?? '';
    idGive = json['idGive'];
    state = json['state'];
    typeDonation = json['typeDonation'];
    frequency = json['frequency'];
    currency = json['currency'];
    optionalField = json['optionalField'] ?? '';
    stateDescription = json['stateDescription'];

    nameMyosotisConfiguration = json['nameMyosotisConfiguration'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idMyosotisFormData'] = idMyosotisFormData;
    data['idInstitution'] = idInstitution;
    data['idMyosotisConfiguration'] = idMyosotisConfiguration;
    data['name'] = name;
    data['surname'] = surname;
    data['businessName'] = businessName;
    data['codDest'] = codDest;
    data['cf'] = cf;
    data['piva'] = piva;
    data['birthDate'] = birthDate;
    data['sex'] = sex;
    data['email'] = email;
    data['phone'] = phone;
    data['mobile'] = mobile;
    data['iso3Geo'] = iso3Geo;
    data['countryGeo'] = countryGeo;
    data['stateGeo'] = stateGeo;
    data['regionGeo'] = regionGeo;
    data['provinceGeo'] = provinceGeo;
    data['provinceCodeGeo'] = provinceCodeGeo;
    data['cityGeo'] = cityGeo;
    data['district1Geo'] = district1Geo;
    data['district2Geo'] = district2Geo;
    data['district3Geo'] = district3Geo;
    data['zipcodeGeo'] = zipcodeGeo;
    data['streetGeo'] = streetGeo;
    data['numberAndExponentGeo'] = numberAndExponentGeo;
    data['consentNewletter'] = consentNewletter;
    data['consentPrivacy'] = consentPrivacy;
    data['dateDonation'] = dateDonation;
    data['idProduct'] = idProduct;
    data['idSubCategory'] = idSubCategory;
    data['amountDonation'] = amountDonation;
    data['paymentType'] = paymentType;
    data['externalIdPayment1'] = externalIdPayment1;
    data['externalIdPayment2'] = externalIdPayment2;
    data['idGive'] = idGive;
    data['state'] = state;
    data['typeDonation'] = typeDonation;
    data['frequency'] = frequency;
    data['currency'] = currency;
    data['optionalField'] = optionalField;
    data['stateDescription'] = stateDescription;
    data['nameMyosotisConfiguration'] = nameMyosotisConfiguration;
    return data;
  }
}
