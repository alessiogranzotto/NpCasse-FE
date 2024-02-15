import 'package:np_casse/core/models/institution.model.dart';

class UserInstitutionModel {
  UserInstitutionModel(
      {required this.idUserAppInstitution,
      required this.idInstitution,
      required this.idUser,
      required this.institution});
  late final int idUserAppInstitution;
  late final int idInstitution;
  late final int idUser;
  late final InstitutionModel institution;

  UserInstitutionModel.fromJson(Map<String, dynamic> json) {
    idUserAppInstitution = json['idUserAppInstitution'];
    idInstitution = json['idInstitution'];
    idUser = json['idUser'];
    institution = InstitutionModel.fromJson(json['idInstitutionNavigation']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['idInstitution'] = idInstitution;
    data['idUser'] = idUser;
    return data;
  }
}
