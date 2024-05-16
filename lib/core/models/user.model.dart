import 'dart:convert';

import 'package:np_casse/core/models/user.app.institution.model.dart';

class UserModel {
  UserModel(
      {required this.idUser,
      // required this.idUserAppInstitution,
      required this.name,
      required this.surname,
      required this.email,
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
  late String token;
  late String refreshToken;
  // late final String role;
  late DateTime expirationTime;
  late List<UserAppInstitutionModel> userAppInstitutionModelList;

  UserModel.empty() {
    idUser = 0;
    // idUserAppInstitution = 0;
    email = "";
    token = "";
    refreshToken = "";
    // role = "";
    expirationTime = DateTime.now();
    userAppInstitutionModelList = List.empty();
  }

  // UserModel.fromMap(Map<String, dynamic> mappa) {
  //     idUser = mappa['id'];
  //     emailUser = mappa['email'];
  //     token = mappa['token'];
  //     refreshToken = mappa['refreshToken'];
  //     role = mappa['role'];
  //     expirationTime = mappa['expirationTime'];

  // }
  UserModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    // idUserAppInstitution = json['idUserAppInstitution'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
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
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    // data['role'] = role;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
// class UserModel {
//   UserModel({
//     required this.received,
//     required this.data,
//   });
//   late final bool received;
//   late final UserData data;

//   UserModel.fromJson(Map<String, dynamic> json) {
//     received = json['received'];
//     data = UserData.fromJson(json['data']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['received'] = received;
//     _data['data'] = data.toJson();
//     return _data;
//   }
// }

// class UserData {
//   UserData({
//     required this.email,
//     required this.username,
//     required this.iat,
//     required this.exp,
//   });
//   late final String email;
//   late final String username;
//   late final int iat;
//   late final int exp;

//   UserData.fromJson(Map<String, dynamic> json) {
//     email = json['email'];
//     username = json['username'];
//     iat = json['iat'];
//     exp = json['exp'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['email'] = email;
//     _data['username'] = username;
//     _data['iat'] = iat;
//     _data['exp'] = exp;
//     return _data;
//   }
// }
