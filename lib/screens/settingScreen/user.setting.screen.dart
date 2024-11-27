import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class UserSettingScreen extends StatefulWidget {
  const UserSettingScreen({super.key});
  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);

  final ValueNotifier<bool> userDataFieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> passwordFieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> securityFieldValidNotifier = ValueNotifier(false);

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late TextEditingController tokenExpirationController =
      TextEditingController();
  late TextEditingController maxInactivityController = TextEditingController();
  List<DropdownMenuItem<String>> availableOtpMode = [
    DropdownMenuItem(child: Text("No"), value: "No"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];
  String valueOtpMode = '';

  List<bool> panelOpen = [false, false, false];

  void initializeControllers() {
    firstNameController = TextEditingController()
      ..addListener(userDataControllerListener);
    lastNameController = TextEditingController()
      ..addListener(userDataControllerListener);
    emailController = TextEditingController()
      ..addListener(userDataControllerListener);
    phoneController = TextEditingController()
      ..addListener(userDataControllerListener);
    passwordController = TextEditingController()
      ..addListener(passwordControllerListener);
    confirmPasswordController = TextEditingController()
      ..addListener(passwordControllerListener);
    tokenExpirationController = TextEditingController()
      ..addListener(securityControllerListener);
    maxInactivityController = TextEditingController()
      ..addListener(securityControllerListener);
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    tokenExpirationController.dispose();
    maxInactivityController.dispose();
  }

  void userDataControllerListener() {
    final email = emailController.text;

    if (email.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email)) {
      userDataFieldValidNotifier.value = true;
    } else {
      userDataFieldValidNotifier.value = false;
    }
  }

  void passwordControllerListener() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty && confirmPassword.isEmpty) return;

    if (AppRegex.passwordRegex.hasMatch(password) &&
        AppRegex.passwordRegex.hasMatch(confirmPassword) &&
        password == confirmPassword) {
      passwordFieldValidNotifier.value = true;
    } else {
      passwordFieldValidNotifier.value = false;
    }
  }

  void securityControllerListener() {
    bool result = false;
    if (int.tryParse(tokenExpirationController.text) != null) {
      if (int.tryParse(maxInactivityController.text) != null) {
        result = true;
      }
    }

    securityFieldValidNotifier.value = result;
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  updateUserData() {
    if (_formKey1.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserModel cUserModel = authNotifier.getUser();
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();
      authNotifier
          .updateUserDetails(
              context: context,
              token: authNotifier.token,
              idUser: cUserModel.idUser,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              name: firstNameController.text,
              surname: lastNameController.text,
              email: emailController.text,
              phone: phoneController.text)
          .then((value) {
        if (value) {
          authNotifier.reinitAccount(context: context);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni utente",
                    message: "Anagrafica utente aggiornata correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  changePassword() {
    if (_formKey2.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserModel cUserModel = authNotifier.getUser();

      authNotifier
          .changeUserPassword(
              context: context,
              token: authNotifier.token,
              idUser: cUserModel.idUser,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text)
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni utente",
                    message: "La password è stata modificata correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  updateSecurityData() {
    if (_formKey3.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserModel cUserModel = authNotifier.getUser();
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();
      authNotifier
          .updateUserSettingData(
              context: context,
              token: authNotifier.token,
              idUser: cUserModel.idUser,
              otpMode: valueOtpMode,
              tokenExpiration: int.parse(tokenExpirationController.text),
              maxInactivity: int.parse(maxInactivityController.text))
          .then((value) {
        if (value) {
          authNotifier.reinitAccount(context: context);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni utente",
                    message: "Criteri di sicurezza aggiornati correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserModel cUserModel = authenticationNotifier.getUser();
    firstNameController.text = cUserModel.name;
    lastNameController.text = cUserModel.surname;
    emailController.text = cUserModel.email;
    phoneController.text = cUserModel.phone;
    valueOtpMode = cUserModel.userOtpMode;
    tokenExpirationController.text = cUserModel.userTokenExpiration.toString();
    maxInactivityController.text = cUserModel.userMaxInactivity.toString();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Impostazioni utente ${cUserModel.name} ${cUserModel.surname} ',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              panelOpen[index] = isExpanded;
                            });
                          },
                          animationDuration: Duration(seconds: 2),
                          elevation: 1,
                          children: [
                            ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Anagrafica utente'),
                                  leading: const Icon(Icons.account_circle),
                                );
                              },
                              body: Form(
                                key: _formKey1,
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: firstNameController,
                                          labelText: AppStrings.firstName,
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterFirstName;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: lastNameController,
                                          labelText: AppStrings.lastName,
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterLastName;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: emailController,
                                          labelText: AppStrings.email,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isEmpty
                                                ? AppStrings
                                                    .pleaseEnterEmailAddress
                                                : AppConstants.emailRegex
                                                        .hasMatch(value)
                                                    ? null
                                                    : AppStrings
                                                        .invalidEmailAddress;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: phoneController,
                                          labelText: AppStrings.telephoneNumber,
                                          keyboardType: TextInputType.phone,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterTelephoneNumber;
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  userDataFieldValidNotifier,
                                              builder: (_, isValid, __) {
                                                return ElevatedButton(
                                                  onPressed: isValid
                                                      ? () {
                                                          updateUserData();
                                                        }
                                                      : null,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    AppStrings.update,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              isExpanded: panelOpen[0],
                            ),
                            ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Password'),
                                  leading: const Icon(Icons.password),
                                );
                              },
                              body: Form(
                                key: _formKey2,
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: passwordNotifier,
                                        builder: (_, passwordObscure, __) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: CustomTextFormField(
                                              obscureText: passwordObscure,
                                              controller: passwordController,
                                              labelText: AppStrings.password,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              onChanged: (_) => _formKey2
                                                  .currentState
                                                  ?.validate(),
                                              validator: (value) {
                                                return value!.isEmpty
                                                    ? AppStrings
                                                        .pleaseEnterPassword
                                                    : AppConstants.passwordRegex
                                                            .hasMatch(value)
                                                        ? null
                                                        : AppStrings
                                                            .invalidPassword;
                                              },
                                              suffixIcon: IconButton(
                                                onPressed: () =>
                                                    passwordNotifier.value =
                                                        !passwordObscure,
                                                style: IconButton.styleFrom(
                                                  minimumSize:
                                                      const Size.square(48),
                                                ),
                                                icon: Icon(
                                                  passwordObscure
                                                      ? Icons
                                                          .visibility_off_outlined
                                                      : Icons
                                                          .visibility_outlined,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable:
                                            confirmPasswordNotifier,
                                        builder: (_, passwordObscure, __) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: CustomTextFormField(
                                              obscureText: passwordObscure,
                                              controller:
                                                  confirmPasswordController,
                                              labelText:
                                                  AppStrings.confirmPassword,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              onChanged: (_) => _formKey2
                                                  .currentState
                                                  ?.validate(),
                                              validator: (value) {
                                                return value!.isEmpty
                                                    ? AppStrings
                                                        .pleaseReEnterPassword
                                                    : value !=
                                                            passwordController
                                                                .text
                                                        ? AppStrings
                                                            .passwordNotMatched
                                                        : null;
                                              },
                                              suffixIcon: IconButton(
                                                onPressed: () =>
                                                    confirmPasswordNotifier
                                                            .value =
                                                        !passwordObscure,
                                                style: IconButton.styleFrom(
                                                  minimumSize:
                                                      const Size.square(48),
                                                ),
                                                icon: Icon(
                                                  passwordObscure
                                                      ? Icons
                                                          .visibility_off_outlined
                                                      : Icons
                                                          .visibility_outlined,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  passwordFieldValidNotifier,
                                              builder: (_, isValid, __) {
                                                return ElevatedButton(
                                                  onPressed: isValid
                                                      ? () {
                                                          changePassword();
                                                        }
                                                      : null,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    AppStrings.changePassword,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              isExpanded: panelOpen[1],
                            ),
                            ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Sicurezza'),
                                  leading: const Icon(Icons.security),
                                );
                              },
                              body: Form(
                                key: _formKey3,
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomDropDownButtonFormField(
                                          enabled: true,
                                          actualValue: valueOtpMode,
                                          labelText: AppStrings.otpMode,
                                          listOfValue: availableOtpMode,
                                          onItemChanged: (value) {
                                            valueOtpMode = value;
                                            // onChangeNumberResult(value);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: tokenExpirationController,
                                          labelText: AppStrings.tokenExpiration,
                                          keyboardType: TextInputType.number,
                                          inputFormatter: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey3
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterTokenExpiration;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: maxInactivityController,
                                          labelText:
                                              AppStrings.userMaxInactivity,
                                          keyboardType: TextInputType.number,
                                          inputFormatter: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey3
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterUserMaxInactivity;
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  securityFieldValidNotifier,
                                              builder: (_, isValid, __) {
                                                return ElevatedButton(
                                                  onPressed: isValid
                                                      ? () {
                                                          updateSecurityData();
                                                        }
                                                      : null,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    AppStrings.update,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              isExpanded: panelOpen[2],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
