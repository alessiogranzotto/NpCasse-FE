import 'package:np_casse/core/models/institution.model.dart';

class UserAppInstitutionModel {
  UserAppInstitutionModel(
      {required this.idUserAppInstitution,
      required this.roleUserInstitution,
      required this.idInstitutionNavigation});
  late final int idUserAppInstitution;
  late final String roleUserInstitution;
  late final InstitutionModel idInstitutionNavigation;
  late bool selected = false;

  UserAppInstitutionModel.empty() {
    idUserAppInstitution = 0;
    roleUserInstitution = '';
    idInstitutionNavigation = InstitutionModel.empty();
    selected = false;
  }

  UserAppInstitutionModel.fromJson(Map<String, dynamic> json) {
    idUserAppInstitution = json['idUserAppInstitution'];
    roleUserInstitution = json['roleUserInstitution'];
    idInstitutionNavigation =
        InstitutionModel.fromJson(json['idInstitutionNavigation']);
    selected = json['selected'] ?? false;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['roleUserInstitution'] = roleUserInstitution;
    data['idInstitutionNavigation'] = idInstitutionNavigation.toJson();
    data['selected'] = selected;
    return data;
  }
}
