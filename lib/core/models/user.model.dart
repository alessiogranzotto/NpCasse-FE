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
      required this.userAppInstitutionModelList,

      //PROPERTY FROM USER ATTRIBUTE

      required this.userTokenExpiration,
      required this.userOtpMode,
      required this.userMaxInactivity});
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

  //PROPERTY FROM USER ATTRIBUTE

  late String userTokenExpiration;
  late String userOtpMode;
  late String userMaxInactivity;

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
    userTokenExpiration = "";
    userOtpMode = "";
    userMaxInactivity = "";
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

    userTokenExpiration = json['userTokenExpiration'];
    userOtpMode = json['userOtpMode'];
    userMaxInactivity = json['userMaxInactivity'];
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
    data['expirationTime'] = expirationTime;
    return data;
  }
}

class UserAttributeModel {
  UserAttributeModel(
      {required this.attributeName, required this.attributeValue});
  late String attributeName;
  late String attributeValue;

  UserAttributeModel.empty() {
    attributeName = "";
    attributeValue = "";
  }

  UserAttributeModel.fromJson(Map<String, dynamic> json) {
    attributeName = json['attributeName'];
    attributeValue = json['attributeValue'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attributeName'] = attributeName;
    data['attributeValue'] = attributeValue;
    return data;
  }
}

class UserModelTeam {
  UserModelTeam(
      {required this.idUser,
      required this.name,
      required this.surname,
      required this.email,
      required this.phone,
      required this.role});
  late int idUser;
  late String name;
  late String surname;
  late String email;
  late String phone;
  late String role;

  UserModelTeam.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
  }
}
