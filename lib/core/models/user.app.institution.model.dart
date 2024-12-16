import 'package:np_casse/core/models/institution.model.dart';

class UserAppInstitutionModel {
  UserAppInstitutionModel(
      {required this.idUserAppInstitution,
      required this.roleUserInstitution,
      required this.idInstitutionNavigation});
  late final int idUserAppInstitution;
  late final String roleUserInstitution;
  late final InstitutionModel idInstitutionNavigation;
  // late final List<UserTeamModel> userTeamModel;
  late bool selected = false;

  UserAppInstitutionModel.empty() {
    idUserAppInstitution = 0;
    roleUserInstitution = '';
    idInstitutionNavigation = InstitutionModel.empty();
    // userTeamModel = List.empty();
    selected = false;
  }

  UserAppInstitutionModel.fromJson(Map<String, dynamic> json) {
    idUserAppInstitution = json['idUserAppInstitution'];
    roleUserInstitution = json['roleUserInstitution'];
    idInstitutionNavigation =
        InstitutionModel.fromJson(json['idInstitutionNavigation']);

    // if (json['userModelOther'] != null) {
    //   userTeamModel = List.from(json['userModelOther'])
    //       .map((e) => UserTeamModel.fromJson(e))
    //       .toList();
    // }

    selected = json['selected'] ?? false;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['roleUserInstitution'] = roleUserInstitution;
    data['idInstitutionNavigation'] = idInstitutionNavigation.toJson();
    // data['userModelOther'] = userTeamModel;
    data['selected'] = selected;
    return data;
  }
}

class UserTeamModel {
  UserTeamModel({
    required this.idUser,
    required this.email,
    required this.name,
    required this.surname,
  });
  late final int idUser;
  late final String email;
  late final String name;
  late final String surname;

  UserTeamModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    email = json['email'];
    name = json['name'];
    surname = json['surname'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['email'] = email;
    data['name'] = name;
    data['surname'] = surname;
    return data;
  }
}
