import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class UserSettingScreeen extends StatefulWidget {
  const UserSettingScreeen({super.key});
  @override
  State<UserSettingScreeen> createState() => _UserSettingScreeenState();
}

class _UserSettingScreeenState extends State<UserSettingScreeen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);

  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> passwordFieldValidNotifier = ValueNotifier(false);

  late final TextEditingController firstNameController;
  late final TextEditingController tokenExpirationController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  // late final String firstname, lastname, telephone, email, password;

  List<DropdownMenuItem<String>> availableOtpMode = [
    DropdownMenuItem(child: Text("No"), value: "No"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];
  String valueOtpMode = '';

  void initializeControllers() {
    firstNameController = TextEditingController()
      ..addListener(controllerListener);
    tokenExpirationController = TextEditingController()
      ..addListener(controllerListener);
    emailController = TextEditingController()..addListener(controllerListener);
    phoneController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(passwordControllerListener);
    confirmPasswordController = TextEditingController()
      ..addListener(passwordControllerListener);
  }

  void disposeControllers() {
    firstNameController.dispose();
    tokenExpirationController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;

    if (email.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
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
    if (_formKey.currentState!.validate()) {
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
              surname: tokenExpirationController.text,
              email: emailController.text,
              phone: phoneController.text)
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Utente",
                    message: "Utente aggiornato correttamente",
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
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    UserModel cUserModel = authenticationNotifier.getUser();

    var itemUserOtpMode = cUserModel.userAttributeModelList
        .where((element) => element.attributeName == 'User.OtpMode')
        .firstOrNull;

    if (itemUserOtpMode != null) {
      valueOtpMode = itemUserOtpMode.attributeValue;
    } else {
      valueOtpMode = 'No';
    }

    firstNameController.text = cUserModel.name;
    tokenExpirationController.text = cUserModel.surname;
    emailController.text = cUserModel.email;
    phoneController.text = cUserModel.phone;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Utente ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 21),
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // First Form
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomDropDownButtonFormField(
                                    enabled: true,
                                    actualValue: valueOtpMode,
                                    labelText: 'Mostra risultati',
                                    listOfValue: availableOtpMode,
                                    onItemChanged: (value) {
                                      valueOtpMode = value;
                                      // onChangeNumberResult(value);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    controller: tokenExpirationController,
                                    labelText: AppStrings.lastName,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : AppStrings.pleaseEnterLastName;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    controller: emailController,
                                    labelText: AppStrings.email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? AppStrings.pleaseEnterEmailAddress
                                          : AppConstants.emailRegex
                                                  .hasMatch(value)
                                              ? null
                                              : AppStrings.invalidEmailAddress;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    controller: phoneController,
                                    labelText: AppStrings.telephoneNumber,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
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
                                        valueListenable: fieldValidNotifier,
                                        builder: (_, isValid, __) {
                                          return ElevatedButton(
                                            onPressed: isValid
                                                ? () {
                                                    updateUserData();
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
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
                        const SizedBox(height: 40), // Space between forms
                        // Second Form
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
