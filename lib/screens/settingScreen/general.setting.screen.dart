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

class GeneralSettingScreen extends StatefulWidget {
  const GeneralSettingScreen({super.key});
  @override
  State<GeneralSettingScreen> createState() => _GeneralSettingScreenState();
}

class _GeneralSettingScreenState extends State<GeneralSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController tokenExpirationController =
      TextEditingController();
  List<DropdownMenuItem<String>> availableOtpMode = [
    DropdownMenuItem(child: Text("No"), value: "No"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];
  String valueOtpMode = '';

  void disposeControllers() {
    tokenExpirationController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  // updateGeneralSettingData() {
  //   if (_formKey.currentState!.validate()) {
  //     var authNotifier =
  //         Provider.of<AuthenticationNotifier>(context, listen: false);
  //     UserModel cUserModel = authNotifier.getUser();
  //     UserAppInstitutionModel cUserAppInstitutionModel =
  //         authNotifier.getSelectedUserAppInstitution();
  //     authNotifier
  //         .updateUserDetails(
  //             context: context,
  //             token: authNotifier.token,
  //             idUser: cUserModel.idUser,
  //             idUserAppInstitution:
  //                 cUserAppInstitutionModel.idUserAppInstitution,
  //             name: firstNameController.text,
  //             surname: tokenExpirationController.text,
  //             email: emailController.text,
  //             phone: phoneController.text)
  //         .then((value) {
  //       if (value) {
  //         if (context.mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               SnackUtil.stylishSnackBar(
  //                   title: "Utente",
  //                   message: "Utente aggiornato correttamente",
  //                   contentType: "success"));
  //         }
  //       }
  //     });
  //   }
  // }

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

    tokenExpirationController.text = cUserModel.surname;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Impostazioni generali ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
                                    labelText: AppStrings.otpMode,
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
                                    labelText: AppStrings.tokenExpiration,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : AppStrings
                                              .pleaseEnterTokenExpiration;
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
                                                    // updateGeneralSettingData();
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
