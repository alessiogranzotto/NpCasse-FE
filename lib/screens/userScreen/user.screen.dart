import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class UserScreeen extends StatefulWidget {
  const UserScreeen({super.key});
  @override
  State<UserScreeen> createState() => _UserScreeenState();
}

class _UserScreeenState extends State<UserScreeen> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);

  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> passwordFieldValidNotifier = ValueNotifier(false);

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  // late final String firstname, lastname, telephone, email, password;

  void initializeControllers() {
    firstNameController = TextEditingController()
      ..addListener(controllerListener);
    lastNameController = TextEditingController()
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
    lastNameController.dispose();
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
      authNotifier.updateUserDetails(
          context: context,
          token: authNotifier.token,
          idUser: cUserModel.idUser,
          idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
          name: firstNameController.text,
          surname: lastNameController.text,
          email: emailController.text,
          phone: phoneController.text).then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Utente",
              message: "Utente aggiornato correttamente",
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

      authNotifier.changeUserPassword(
          context: context,
          token: authNotifier.token,
          idUser: cUserModel.idUser,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text).then((value) {     
        if (value) {
         if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Password",
              message: "La password è stata modificata correttamente",
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

    return Scaffold(
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
                                  child: CustomTextFormField(
                                    controller: firstNameController,
                                    labelText: AppStrings.firstName,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : AppStrings.pleaseEnterFirstName;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    controller: lastNameController,
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
                        Form(
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: CustomTextFormField(
                                        obscureText: passwordObscure,
                                        controller: passwordController,
                                        labelText: AppStrings.password,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        onChanged: (_) =>
                                            _formKey2.currentState?.validate(),
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? AppStrings.pleaseEnterPassword
                                              : AppConstants.passwordRegex
                                                      .hasMatch(value)
                                                  ? null
                                                  : AppStrings.invalidPassword;
                                        },
                                        suffixIcon: IconButton(
                                          onPressed: () => passwordNotifier
                                              .value = !passwordObscure,
                                          style: IconButton.styleFrom(
                                            minimumSize: const Size.square(48),
                                          ),
                                          icon: Icon(
                                            passwordObscure
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: confirmPasswordNotifier,
                                  builder: (_, passwordObscure, __) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: CustomTextFormField(
                                        obscureText: passwordObscure,
                                        controller: confirmPasswordController,
                                        labelText: AppStrings.confirmPassword,
                                        textInputAction: TextInputAction.done,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        onChanged: (_) =>
                                            _formKey2.currentState?.validate(),
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? AppStrings.pleaseReEnterPassword
                                              : value != passwordController.text
                                                  ? AppStrings
                                                      .passwordNotMatched
                                                  : null;
                                        },
                                        suffixIcon: IconButton(
                                          onPressed: () =>
                                              confirmPasswordNotifier.value =
                                                  !passwordObscure,
                                          style: IconButton.styleFrom(
                                            minimumSize: const Size.square(48),
                                          ),
                                          icon: Icon(
                                            passwordObscure
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
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
                                            style: ElevatedButton.styleFrom(
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
