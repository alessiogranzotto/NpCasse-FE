class InstitutionModel {
  InstitutionModel(
      {required this.idInstitution,
      required this.keyInstitution,
      required this.nameInstitution});
  late final int idInstitution;
  late final String keyInstitution;
  late final String nameInstitution;

  InstitutionModel.empty() {
    idInstitution = 0;
    keyInstitution = '';
    nameInstitution = '';
  }
  InstitutionModel.fromJson(Map<String, dynamic> json) {
    idInstitution = json['idInstitution'];
    keyInstitution = json['keyInstitution'];
    nameInstitution = json['nameInstitution'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idInstitution'] = idInstitution;
    data['keyInstitution'] = keyInstitution;
    data['nameInstitution'] = nameInstitution;
    return data;
  }
}
