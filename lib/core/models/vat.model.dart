class VatModel {
  VatModel(
      {required this.valueVat,
      required this.descriptionVat,
      required this.ratio});
  late String valueVat;
  late String descriptionVat;
  late double ratio;

  VatModel.fromJson(Map<String, dynamic> json) {
    valueVat = json['valueVat'];
    descriptionVat = json['descriptionVat'];
    ratio = json['ratio'];
  }
}

class VatDataModel {
  VatDataModel(
      {required this.institutionFiscalized, required this.vatModelList});
  late bool institutionFiscalized;
  late List<VatModel> vatModelList;

  VatDataModel.fromJson(Map<String, dynamic> json) {
    institutionFiscalized = json['institutionFiscalized'];
    vatModelList = List.from(json['vatModelList'])
        .map((e) => VatModel.fromJson(e))
        .toList();
  }
}
