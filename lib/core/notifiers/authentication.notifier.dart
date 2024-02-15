import 'dart:convert';
import 'dart:io';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/initial_context.dart';
import 'package:np_casse/core/api/authentication.api.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationNotifier with ChangeNotifier {
  final AuthenticationAPI userAPI = AuthenticationAPI();

  UserModel currentUserModel = UserModel.empty();

  setUser(UserModel userModel) {
    currentUserModel = userModel;
  }

  bool get isAuth => currentUserModel.token.isNotEmpty;
  String? get token => currentUserModel.token;

  String? _passwordLevel = "";
  String? get passwordLevel => _passwordLevel;

  String? _passwordEmoji = "";
  String? get passwordEmoji => _passwordEmoji;

  double? _passwordStrength = 0;
  double? get passwordStrength => _passwordStrength;

  late final SharedPreferences _preferences;
  String _actualState = 'NoState';
  String get getactualState => _actualState;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      String savedUserData = _preferences.getString(AppKeys.userData) ?? '';
      if (savedUserData.isNotEmpty) {
        final Map<String, dynamic> parseData = await jsonDecode(savedUserData);
        UserModel userModel = UserModel.fromJson(parseData);
        setUser(userModel);
      }
    } catch (e) {
      print(e);
    }
  }

  Future userAuthenticate({
    required BuildContext context,
    required String email,
    required String password,
    required String appName,
    // required int idUserAppInstitution
  }) async {
    try {
      _actualState = 'LoadingState';
      _isLoading = true;
      notifyListeners();
      UserModel userModel = UserModel.empty();

      await Future.delayed(const Duration(seconds: 1));
      var response1 = await userAPI.userAuthenticate(
        email: email,
        password: password,
        // appName: appName,
        // idUserAppInstitution: idUserAppInstitution
      );

      final Map<String, dynamic> parseData1 = await jsonDecode(response1);
      bool isOk = parseData1['isOk'];
      if (!isOk) {
        String errorDescription = parseData1['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              text: errorDescription, context: context));
          _actualState = 'ErrorState';
          _isLoading = false;
          await Future.delayed(const Duration(seconds: 1));
          notifyListeners();
          // Navigator.pop(context);
        }
      } else {
        userModel = UserModel.fromJson(parseData1['okResult']);

        var response2 = await userAPI.getUserAppInstitution(
            token: userModel.token, idUser: userModel.idUser, appName: appName);
        final Map<String, dynamic> parseData2 = await jsonDecode(response2);
        bool isOk = parseData2['isOk'];
        if (!isOk) {
          String errorDescription = parseData2['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            _actualState = 'ErrorState';
            _isLoading = false;
            await Future.delayed(const Duration(seconds: 1));
            notifyListeners();
            // Navigator.pop(context);
          }
        } else {
          List<UserAppInstitutionModel> userAppInstitutionModelList =
              List.from(parseData2['okResult'])
                  .map((e) => UserAppInstitutionModel.fromJson(e))
                  .toList();

          userModel.userAppInstitutionModelList = userAppInstitutionModelList;
          if (userAppInstitutionModelList.length == 1) {
            userModel.userAppInstitutionModelList.first.selected = true;
          } else if (userAppInstitutionModelList.length > 1) {
            userModel.userAppInstitutionModelList.last.selected = true;
          } else {
            String errorDescription =
                'Nessuna associazione configurata per l' 'utente';
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      text: errorDescription, context: context));
              _actualState = 'ErrorState';
              _isLoading = false;
              await Future.delayed(const Duration(seconds: 1));
              notifyListeners();
            }
          }

          setUser(userModel);
          //CHIAMO API PER GRANT
          var response3 = await userAPI.getUserAppInstitutionGrant(
              token: userModel.token,
              idUser: userModel.idUser,
              idUserAppInstitution:
                  getSelectedUserAppInstitution().idUserAppInstitution);
          final Map<String, dynamic> parseData3 = await jsonDecode(response3);
          if (!isOk) {
            String errorDescription = parseData3['errorDescription'];
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      text: errorDescription, context: context));
              _actualState = 'ErrorState';
              _isLoading = false;
              await Future.delayed(const Duration(seconds: 1));
              notifyListeners();
              // Navigator.pop(context);
            }
          } else {
            userModel.token = parseData3['okResult']['token'];
            userModel.refreshToken = parseData3['okResult']['refreshToken'];
            userModel.expirationTime =
                DateTime.parse(parseData3['okResult']['expirationTime']);
          }

          bool isAuthenticated = userModel.token.isNotEmpty;
          if (isAuthenticated) {
            _actualState = 'LoadedState';
            _isLoading = false;
            await Future.delayed(const Duration(seconds: 1));
            notifyListeners();

            WriteCache.setString(
                key: AppKeys.userData,
                value: json.encode({
                  'idUser': userModel.idUser,
                  'idUserAppInstitution': userModel.idUserAppInstitution,
                  'email': userModel.email,
                  'token': userModel.token,
                  'refreshToken': userModel.refreshToken,
                  // 'role': userModel.role,
                  'expirationTime': userModel.expirationTime.toString(),
                  'userAppInstitutionModelList': jsonEncode(userModel
                      .userAppInstitutionModelList
                      .map((e) => e.toJson())
                      .toList())
                })).whenComplete(
              () => Navigator.of(context)
                  .pushReplacementNamed(AppRouter.homeRoute),
            );
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      text: 'Errore di connessione', context: context));
              await Future.delayed(const Duration(seconds: 1));
              _actualState = 'ErrorState';
              _isLoading = false;
              notifyListeners();
            }
          }
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            text: 'Errore di connessione', context: context));
        _actualState = 'ErrorState';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Errore di connessione', context: context));
      _actualState = 'ErrorState';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future userRegister(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      var userData =
          await userAPI.userRegister(email: email, password: password);
      print(userData);

      final Map<String, dynamic> parseData = await jsonDecode(userData);
      bool isAuthenticated = parseData['authentication'];
      dynamic authData = parseData['data'];

      if (isAuthenticated) {
        WriteCache.setString(key: AppKeys.userData, value: authData)
            .whenComplete(
          () => Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackUtil.stylishSnackBar(text: authData, context: context));
        }
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      print(e);
    }
  }

  int getNumberUserAppInstitution() {
    return currentUserModel.userAppInstitutionModelList.length;
  }

  Future getUserAppInstitution() async {
    return currentUserModel.userAppInstitutionModelList;
  }

  void setSelectedUserAppInstitution(UserAppInstitutionModel? val) {
    for (var element in currentUserModel.userAppInstitutionModelList) {
      element.selected = false;
    }
    var s = currentUserModel.userAppInstitutionModelList.where(
        (element) => element.idUserAppInstitution == val?.idUserAppInstitution);
    if (s.length == 1) {
      s.first.selected = true;
    }
    notifyListeners();
  }

  UserAppInstitutionModel getSelectedUserAppInstitution() {
    var s = currentUserModel.userAppInstitutionModelList
        .where((element) => element.selected == true);
    if (s.length == 1) {
      return s.first;
    } else {
      return UserAppInstitutionModel.empty();
    }
  }

  void checkPasswordStrength({required String password}) {
    String mediumPattern = r'^(?=.*?[!@#\$&*~]).{8,}';
    String strongPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    if (password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '🚀';
      _passwordLevel = 'Strong';
      notifyListeners();
    } else if (password.contains(RegExp(mediumPattern))) {
      _passwordEmoji = '🔥';
      _passwordLevel = 'Medium';
      notifyListeners();
    } else if (!password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '😢';
      _passwordLevel = 'Weak';
      notifyListeners();
    }
  }

  void getPasswordStrength({required String password}) {
    String weakPattern = r'^(?=.*?[!@#\$&*~]).{4,}';
    String mediumPattern = r'^(?=.*?[!@#\$&*~]).{8,}';
    String strongPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    _passwordStrength = 0;

    if (password.contains(RegExp(strongPattern))) {
      _passwordStrength = 3;
      notifyListeners();
    } else if (password.contains(RegExp(mediumPattern))) {
      _passwordStrength = 2;
      notifyListeners();
    } else if (password.contains(RegExp(weakPattern))) {
      _passwordStrength = 1;
      notifyListeners();
    }
  }

  Future userLogout() async {
    _actualState = 'LogoutState';
    notifyListeners();

    Navigator.pushNamedAndRemoveUntil(
        ContextKeeper.buildContext, AppRouter.loginRoute, (_) => true);

    // _idUser = 0;
    // _token = null;

    DeleteCache.deleteKey(AppKeys.userData).whenComplete(() async {
      await Future.delayed(const Duration(seconds: 1));
      _actualState = 'LoginState';
      notifyListeners();
    });
  }
}
