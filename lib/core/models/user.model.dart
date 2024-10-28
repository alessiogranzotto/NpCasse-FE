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
      required this.userAttributeModelList});
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
  late List<UserAttributeModel> userAttributeModelList;

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
    userAttributeModelList = List.empty();
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

    //COMES FROM INIT STRING - START
    if (json.containsKey('userAppInstitutionModelList') &
        json['userAppInstitutionModelList'].toString().isNotEmpty) {
      userAppInstitutionModelList =
          List.from(jsonDecode(json['userAppInstitutionModelList']))
              .map((e) => UserAppInstitutionModel.fromJson(e))
              .toList();
    } else {
      userAppInstitutionModelList = List.empty();
    }

    if (json.containsKey('userAttributeModelList') &
        json['userAttributeModelList'].toString().isNotEmpty) {
      userAttributeModelList =
          List.from(jsonDecode(json['userAttributeModelList']))
              .map((e) => UserAttributeModel.fromJson(e))
              .toList();
    } else {
      userAttributeModelList = List.empty();
    }
    //COMES FROM INIT STRING - END

    //COME FROM LOGIN - START
    if (json.containsKey('userAttribute')) {
      userAttributeModelList = List.from(json['userAttribute'])
          .map((e) => UserAttributeModel.fromJson(e))
          .toList();
    } else {
      userAttributeModelList = List.empty();
    }
    //COME FROM LOGIN - END
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
