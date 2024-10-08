import 'dart:convert';

import 'package:np_casse/core/models/user.app.institution.model.dart';

class UserModel {
  UserModel(
      {required this.idUser,
      // required this.idUserAppInstitution,
      required this.name,
      required this.surname,
      required this.email,
      required this.phone,
      required this.token,
      required this.refreshToken,
      // required this.role,
      required this.expirationTime,
      required this.userAppInstitutionModelList});
  late int idUser;
  // late int idUserAppInstitution;
  late String name;
  late String surname;
  late String email;
  late String phone;
  late String token;
  late String refreshToken;
  // late final String role;
  late DateTime expirationTime;
  late List<UserAppInstitutionModel> userAppInstitutionModelList;

  UserModel.empty() {
    idUser = 0;
    // idUserAppInstitution = 0;
    email = "";
    phone = "";
    token = "";
    refreshToken = "";
    // role = "";
    expirationTime = DateTime.now();
    userAppInstitutionModelList = List.empty();
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    // idUserAppInstitution = json['idUserAppInstitution'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    phone = json['phone'];
    token = json['token'];
    refreshToken = json['refreshToken'];
    // role = json['role'];
    expirationTime = DateTime.parse(json['expirationTime']);

    if (json.containsKey('userAppInstitutionModelList') &
        json['userAppInstitutionModelList'].toString().isNotEmpty) {
      userAppInstitutionModelList =
          List.from(jsonDecode(json['userAppInstitutionModelList']))
              .map((e) => UserAppInstitutionModel.fromJson(e))
              .toList();
    } else {
      userAppInstitutionModelList = List.empty();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUser'] = idUser;
    // data['idUserAppInstitution'] = idUserAppInstitution;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    data['phone'] = phone;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    // data['role'] = role;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
