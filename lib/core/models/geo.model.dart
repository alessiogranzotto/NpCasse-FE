class GeoCountryItemModel {
  GeoCountryItemModel(
      {required this.iso3,
      // required this.country,
      required this.countryEn,
      required this.stateVisibility,
      required this.regionVisibility,
      required this.provinceVisibility,
      required this.cityVisibility,
      required this.district1Visibility,
      required this.district2Visibility,
      required this.district3Visibility});
  late String iso3;
  // late String country;
  late String countryEn;
  late bool stateVisibility;
  late bool regionVisibility;
  late bool provinceVisibility;
  late bool cityVisibility;
  late bool district1Visibility;
  late bool district2Visibility;
  late bool district3Visibility;

  GeoCountryItemModel.empty() {
    iso3 = '';
    // country = '';
    countryEn = '';
    stateVisibility = false;
    regionVisibility = false;
    provinceVisibility = false;
    cityVisibility = false;
    district1Visibility = false;
    district2Visibility = false;
    district3Visibility = false;
  }

  GeoCountryItemModel.italy() {
    iso3 = 'ITA';
    // country = 'Italia';
    countryEn = 'Italy';
    stateVisibility = false;
    regionVisibility = true;
    provinceVisibility = true;
    cityVisibility = true;
    district1Visibility = true;
    district2Visibility = false;
    district3Visibility = false;
  }
  GeoCountryItemModel.fromJson(Map<String, dynamic> json) {
    iso3 = json['iso3'];
    countryEn = json['country_EN'];
    stateVisibility = json['stateVisibility'];
    regionVisibility = json['regionVisibility'];
    provinceVisibility = json['provinceVisibility'];
    cityVisibility = json['cityVisibility'];
    district1Visibility = json['district1Visibility'];
    district2Visibility = json['district2Visibility'];
    district3Visibility = json['district3Visibility'];
  }

  GeoCountryItemModel.fromFullAddressItem(
      GeoFullAddressItemModel geoFullAddressItemModel,
      List<GeoCountryItemModel> geoFullAddressItemModelList) {
    var cItem = geoFullAddressItemModelList
        .where((element) => element.iso3 == geoFullAddressItemModel.iso3);
    if (cItem.length == 1) {
      GeoCountryItemModel cFirstItem = cItem.first;
      iso3 = cFirstItem.iso3;
      countryEn = cFirstItem.countryEn;
      stateVisibility = cFirstItem.stateVisibility;
      regionVisibility = cFirstItem.regionVisibility;
      provinceVisibility = cFirstItem.provinceVisibility;
      cityVisibility = cFirstItem.cityVisibility;
      district1Visibility = cFirstItem.district1Visibility;
      district2Visibility = cFirstItem.district2Visibility;
      district3Visibility = cFirstItem.district3Visibility;
    } else {
      GeoCountryItemModel.empty();
    }
  }
}

class GeoFullAddressItemModel {
  GeoFullAddressItemModel({
    required this.iso3,
    required this.countryEn,
    required this.state,
    required this.region,
    required this.province,
    required this.provinceCode,
    required this.city,
    required this.district1,
    required this.district2,
    required this.district3,
    required this.zipcode,
    required this.street,
    required this.numberAndExponent,
    required this.fullAddressDesc,
  });
  late String iso3;
  late String countryEn;
  late String state;
  late String region;
  late String province;
  late String provinceCode;
  late String city;
  late String district1;
  late String district2;
  late String district3;
  late String zipcode;
  late String street;
  late String numberAndExponent;
  late String fullAddressDesc;
  GeoFullAddressItemModel.empty() {
    iso3 = '';
    countryEn = '';
    state = '';
    region = '';
    province = '';
    provinceCode = '';
    city = '';
    district1 = '';
    district2 = '';
    district3 = '';
    zipcode = '';
    street = '';
    numberAndExponent = '';
    fullAddressDesc = '';
  }
  GeoFullAddressItemModel.fromJson(Map<String, dynamic> json) {
    iso3 = json['iso3'];
    countryEn = json['country'];
    state = json['state'];
    region = json['region'];
    province = json['province'];
    provinceCode = json['province_code'];
    city = json['city'];
    district1 = json['district1'];
    district2 = json['district2'];
    district3 = json['district3'];
    zipcode = json['zipcode'];
    street = json['street'];
    numberAndExponent = json['numberAndExponent'];
    fullAddressDesc = json['fullAddressDesc'];
  }
}

class GeoCityItemModel {
  GeoCityItemModel(
      {required this.state,
      required this.region,
      required this.province,
      required this.city});
  late String state;
  late String region;
  late String province;
  late String city;

  GeoCityItemModel.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    region = json['region'];
    province = json['province'];
    city = json['city'];
  }

  GeoCityItemModel.empty() {
    state = '';
    region = '';
    province = '';
    city = '';
  }
}

class GeoStreetItemModel {
  GeoStreetItemModel(
      {required this.district1,
      required this.district2,
      required this.district3,
      required this.street,
      required this.postalCode});
  late String district1;
  late String district2;
  late String district3;
  late String street;
  late String postalCode;

  GeoStreetItemModel.fromJson(Map<String, dynamic> json) {
    district1 = json['district1'];
    district2 = json['district2'];
    district3 = json['district3'];
    street = json['street'];
    postalCode = json['postalCode'];
  }

  GeoStreetItemModel.empty() {
    district1 = '';
    district2 = '';
    district3 = '';
    street = '';
    postalCode = '';
  }
}

class GeoNormItemModel {
  GeoNormItemModel(
      {required this.type, required this.exact, required this.candidateList});
  late String type;
  late GeoNormExactModel exact;
  late List<GeoNormCandidateModel> candidateList;

  GeoNormItemModel.empty() {
    type = '';
    // country = '';
    exact = GeoNormExactModel.empty();
    candidateList = List<GeoNormCandidateModel>.empty();
  }

  GeoNormItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['exact'] != null) {
      exact = GeoNormExactModel.fromJson(json['exact']);
    }
    if (json['candidateList'] != null) {
      candidateList = List.from(json['candidateList'])
          .map((e) => GeoNormCandidateModel.fromJson(e))
          .toList();
    }
  }
}

class GeoNormExactModel {
  GeoNormExactModel(
      {required this.state,
      required this.region,
      required this.province,
      required this.provinceSigle,
      required this.city,
      required this.district1,
      required this.district2,
      required this.district3,
      required this.zipCode,
      required this.completeAddress,
      required this.houseNumberAndExponent,
      required this.co,
      required this.additionalInfo,
      required this.row4,
      required this.row5});
  late String country;
  late String state;
  late String region;
  late String province;
  late String provinceSigle;
  late String city;
  late String district1;
  late String district2;
  late String district3;
  late String zipCode;
  late String completeAddress;
  late String houseNumberAndExponent;
  late String co;
  late String additionalInfo;
  late String row4;
  late String row5;

  GeoNormExactModel.empty() {
    state = '';
    region = '';
    province = '';
    provinceSigle = '';
    city = '';
    district1 = '';
    district2 = '';
    district3 = '';
    zipCode = '';
    completeAddress = '';
    houseNumberAndExponent = '';
    co = '';
    additionalInfo = '';
    row4 = '';
    row5 = '';
  }

  GeoNormExactModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    state = json['state'];
    region = json['region'];
    province = json['province'];
    provinceSigle = json['provinceSigle'];
    city = json['city'];
    district1 = json['district1'];
    district2 = json['district2'];
    district3 = json['district3'];
    zipCode = json['zipCode'];
    completeAddress = json['completeAddress'];
    houseNumberAndExponent = json['houseNumberAndExponent'];
    co = json['co'];
    additionalInfo = json['additionalInfo'];
    row4 = json['row4'];
    row5 = json['row5'];
  }
}

class GeoNormCandidateModel {
  GeoNormCandidateModel(
      {required this.candidateType,
      required this.candidateProvince,
      required this.candidateCity,
      required this.candidateDistrict,
      required this.candidateStreet,
      required this.candidateZipcode,
      required this.candidateItemDesc});
  late int candidateType;
  late String candidateProvince;
  late String candidateCity;
  late String candidateDistrict;
  late String candidateStreet;
  late String candidateZipcode;
  late String candidateItemDesc;

  GeoNormCandidateModel.fromJson(Map<String, dynamic> json) {
    candidateType = json['candidateType'];
    candidateProvince = json['candidateProvince'];
    candidateCity = json['candidateCity'];
    candidateDistrict = json['candidateDistrict'];
    candidateStreet = json['candidateStreet'];
    candidateZipcode = json['candidateZipcode'];
    candidateItemDesc = json['candidateItemDesc'];
  }
}
