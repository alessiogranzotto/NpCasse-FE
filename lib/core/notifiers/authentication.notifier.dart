import 'dart:convert';
import 'dart:io';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/core/api/authentication.api.dart';
import 'package:np_casse/core/api/user.api.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/loginScreen/login.view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationNotifier with ChangeNotifier {
  final AuthenticationAPI userAPI = AuthenticationAPI();
  final UserAPI userDetailAPI = UserAPI();

  UserModel currentUserModel = UserModel.empty();

  late final SharedPreferences _preferences;

  setUser(UserModel userModel) {
    currentUserModel = userModel;
  }

  UserModel getUser() {
    return currentUserModel;
  }

  bool canUserAddItem() {
    return (getSelectedUserAppInstitution().roleUserAppInstitution == "Admin" ||
        getSelectedUserAppInstitution().roleUserAppInstitution ==
            "InstitutionAdmin");
  }

  Future getUserAppInstitution() async {
    return currentUserModel.userAppInstitutionModelList;
  }

  bool get isAuth => currentUserModel.token.isNotEmpty;
  String? get token => currentUserModel.token;

  String? _passwordLevel = "";
  String? get passwordLevel => _passwordLevel;

  String? _passwordEmoji = "";
  String? get passwordEmoji => _passwordEmoji;

  double? _passwordStrength = 0;
  double? get passwordStrength => _passwordStrength;

  // String _actualState = 'NoState';
  // String get getactualState => _actualState;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _stepLoading = "user";
  String get stepLoading => _stepLoading;

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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void backFromOtp() {
    _isLoading = false;
    _stepLoading = "user";
    notifyListeners();
  }

  Future authenticateAccount({
    required BuildContext context,
    required String email,
    required String password,
    required String appName,
    // required int idUserAppInstitution
  }) async {
    try {
      // _actualState = 'LoadingState';
      _isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      UserModel userModel = UserModel.empty();

      //await Future.delayed(const Duration(seconds: 3));
      var response = await userAPI.authenticateAccount(
        email: email,
        password: password,
      );

      final Map<String, dynamic> parseData = await jsonDecode(response);
      bool isOk = parseData['isOk'];
      if (!isOk) {
        String errorDescription = parseData['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Autenticazione",
              message: errorDescription,
              contentType: "failure"));
          _isLoading = false;
          notifyListeners();
        }
      } else {
        userModel = UserModel.fromJson(parseData['okResult']);
        _stepLoading = "otp";
        _isLoading = false;
        setUser(userModel);
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Autenticazione",
            message: "Errore di connessione",
            contentType: "failure"));

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Autenticazione",
            message: "Errore di connessione",
            contentType: "failure"));
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future checkOtp({
    required BuildContext context,
    required String email,
    required String otpCode,
    // required int idUserAppInstitution
  }) async {
    bool result = false;
    try {
      _isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      UserModel userModel = getUser();

      var response = await userAPI.checkOtp(
          token: userModel.token, email: email, otpCode: otpCode);

      final Map<String, dynamic> parseData = await jsonDecode(response);
      bool isOk = parseData['isOk'];
      if (!isOk) {
        String errorDescription = parseData['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Autenticazione",
              message: errorDescription,
              contentType: "failure"));
          _isLoading = false;
          notifyListeners();
        }
      } else {}
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Autenticazione",
            message: "Errore di connessione",
            contentType: "failure"));

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Autenticazione",
            message: "Errore di connessione",
            contentType: "failure"));
        _isLoading = false;
        notifyListeners();
      }
    }
    return result;
  }

  Future initAccount(
      {required BuildContext context,
      required String email,
      required String password,
      required String appName}) async {
    try {
      // _actualState = 'LoadingState';
      _isLoading = true;
      notifyListeners();
      UserModel userModel = getUser();

      var response1 = await userAPI.getUserAppInstitution(
          token: userModel.token, idUser: userModel.idUser, appName: appName);
      final Map<String, dynamic> parseData1 = await jsonDecode(response1);
      bool isOk = parseData1['isOk'];
      if (!isOk) {
        String errorDescription = parseData1['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Autenticazione",
              message: errorDescription,
              contentType: "failure"));

          _isLoading = false;
          notifyListeners();
        }
      } else {
        List<UserAppInstitutionModel> userAppInstitutionModelList =
            List.from(parseData1['okResult'])
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
                    title: "Autenticazione",
                    message: errorDescription,
                    contentType: "failure"));
            // _actualState = 'ErrorState';
            _isLoading = false;
            notifyListeners();
          }
        }

        setUser(userModel);
        //CHIAMO API PER GRANT
        var response2 = await userAPI.getUserAppInstitutionGrant(
            token: userModel.token,
            idUser: userModel.idUser,
            idUserAppInstitution:
                getSelectedUserAppInstitution().idUserAppInstitution);
        final Map<String, dynamic> parseData2 = await jsonDecode(response2);
        if (!isOk) {
          String errorDescription = parseData2['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Autenticazione",
                    message: errorDescription,
                    contentType: "failure"));
            // _actualState = 'ErrorState';

            _isLoading = false;
            notifyListeners();
            // Navigator.pop(context);
          }
        } else {
          userModel.token = parseData2['okResult']['token'];
          userModel.refreshToken = parseData2['okResult']['refreshToken'];
          userModel.expirationTime =
              DateTime.parse(parseData2['okResult']['expirationTime']);
        }

        bool isAuthenticated = userModel.token.isNotEmpty;
        if (isAuthenticated) {
          WriteCache.setString(
              key: AppKeys.userData,
              value: json.encode({
                'idUser': userModel.idUser,
                // 'idUserAppInstitution': userModel.idUserAppInstitution,
                'name': userModel.name,
                'surname': userModel.surname,
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
            () {
              _isLoading = false;
              _stepLoading = "user";
              // notifyListeners();
              Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
            },
          );
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Autenticazione",
                    message: "Errore di connessione",
                    contentType: "failure"));
            // await Future.delayed(const Duration(seconds: 1));
            // _actualState = 'ErrorState';

            _isLoading = false;
            notifyListeners();
          }
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Autenticazione",
            message: "Errore di connessione",
            contentType: "failure"));

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Autenticazione",
            message: "Errore di connessione",
            contentType: "failure"));

        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // Future userRegister(
  //     {required BuildContext context,
  //     required String email,
  //     required String password}) async {
  //   try {
  //     var userData =
  //         await userAPI.userRegister(email: email, password: password);
  //     if (kDebugMode) {
  //       print(userData);
  //     }

  //     final Map<String, dynamic> parseData = await jsonDecode(userData);
  //     bool isAuthenticated = parseData['authentication'];
  //     dynamic authData = parseData['data'];

  //     if (isAuthenticated) {
  //       WriteCache.setString(key: AppKeys.userData, value: authData)
  //           .whenComplete(
  //         () => Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute),
  //       );
  //     } else {
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
  //             title: "Autenticazione",
  //             message: "Errore di connessione",
  //             contentType: "failure"));

  //         _isLoading = false;
  //         notifyListeners();
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
  //           title: "Autenticazione",
  //           message: "Errore di connessione",
  //           contentType: "failure"));

  //       _isLoading = false;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  int getNumberUserAppInstitution() {
    return currentUserModel.userAppInstitutionModelList.length;
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

  Future userLogout(BuildContext context) async {
    DeleteCache.deleteKey(AppKeys.userData).whenComplete(() async {
      await Future.delayed(const Duration(seconds: 3));

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const LoginScreen(),
          ),
          (_) => false,
        );
      }
    });
  }

  Future exit(BuildContext context) async {
    DeleteCache.deleteKey(AppKeys.userData).whenComplete(() async {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const LoginScreen(),
          ),
          (_) => false,
        );
      }
    });
  }

  Future updateUserDetails({
    required BuildContext context,
    required String? token,
    required int idUser,
    required int idUserAppInstitution,
    required String name,
    required String surname,
    required String email,
    required String phone,
  }) async {
    try {
      var response = await userDetailAPI.updateUserDetails(
        token: token,
        idUser: idUser,
        idUserAppInstitution: idUserAppInstitution,
        userName: name,
        userSurname: surname,
        userEmail: email,
        userPhoneNo: phone,
      );

      final Map<String, dynamic> parseData = await jsonDecode(response);
      bool isOk = parseData['isOk'];
      if (!isOk) {
        String errorDescription = parseData['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Update user detail",
              message: errorDescription,
              contentType: "failure"));
          _isLoading = false;
          notifyListeners();
        }
      } else {
        UserModel userModel = getUser();
        userModel.name = name;
        userModel.surname = surname;
        userModel.email = email;
        userModel.phone = phone;
        setUser(userModel);
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Update user detail",
            message: "Errore di connessione",
            contentType: "failure"));

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Update user detail",
            message: "Errore di connessione",
            contentType: "failure"));
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future changeUserPassword(
      {required BuildContext context,
      required String? token,
      required int idUser,
      required String password,
      required String confirmPassword}) async {
    try {
      // _actualState = 'LoadingState';
      _isLoading = true;
      notifyListeners();
      UserModel userModel = UserModel.empty();

      //await Future.delayed(const Duration(seconds: 3));
      var response = await userDetailAPI.changePassword(
          token: token,
          idUser: idUser,
          password: password,
          confirmPassword: confirmPassword);

      final Map<String, dynamic> parseData = await jsonDecode(response);
      bool isOk = parseData['isOk'];
      if (!isOk) {
        String errorDescription = parseData['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Change password",
              message: errorDescription,
              contentType: "failure"));
          _isLoading = false;
          notifyListeners();
        }
      } else {
        userModel = UserModel.fromJson(parseData['okResult']);
        _stepLoading = "otp";
        _isLoading = false;
        setUser(userModel);
        notifyListeners();
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Change password",
            message: "Errore di connessione",
            contentType: "failure"));

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Change password",
            message: "Errore di connessione",
            contentType: "failure"));
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
