import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/comunication.model.dart';
import 'package:np_casse/core/models/institution.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/comunication.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.admin.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class PrepareComunicationScreen extends StatefulWidget {
  const PrepareComunicationScreen({super.key});

  @override
  State<PrepareComunicationScreen> createState() =>
      _PrepareComunicationScreenState();
}

class _PrepareComunicationScreenState extends State<PrepareComunicationScreen> {
  final _formKey = GlobalKey<FormState>();

  TemplateComunicationModel? smtp2GoTemplate;

  final ValueNotifier<bool> viewTemplateValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> createComunicationValidNotifier =
      ValueNotifier(false);

  late final TextEditingController nameComunicationController;
  late final TextEditingController senderComunicationController;
  late final TextEditingController emailSenderComunicationController;
  late final TextEditingController subjectEmailComunicationController;

  void initializeControllers() {
    nameComunicationController = TextEditingController()
      ..addListener(dataControllerListener);
    senderComunicationController = TextEditingController()
      ..addListener(dataControllerListener);
    emailSenderComunicationController = TextEditingController()
      ..addListener(dataControllerListener);
    subjectEmailComunicationController = TextEditingController()
      ..addListener(dataControllerListener);
  }

  void disposeControllers() {
    nameComunicationController.dispose();
    senderComunicationController.dispose();
    emailSenderComunicationController.dispose();
    subjectEmailComunicationController.dispose();
  }

  void dataControllerListener() {
    createComunicationValidNotifier.value = false;
    if (nameComunicationController.text.isEmpty) return;
    if (senderComunicationController.text.isEmpty) return;
    if (emailSenderComunicationController.text.isEmpty) return;
    if (subjectEmailComunicationController.text.isEmpty) return;
    if (smtp2GoTemplate != null) {
      createComunicationValidNotifier.value = true;
    }
  }
  // Future<void> getTemplateComunication() async {
  //   AuthenticationNotifier authenticationNotifier =
  //       Provider.of<AuthenticationNotifier>(context, listen: false);
  //   ComunicationNotifier comunicationNotifier =
  //       Provider.of<ComunicationNotifier>(context, listen: false);
  //   UserAppInstitutionModel cUserAppInstitutionModel =
  //       authenticationNotifier.getSelectedUserAppInstitution();

  //   await comunicationNotifier
  //       .getTemplateComunication(
  //     context: context,
  //     token: authenticationNotifier.token,
  //     idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
  //     idInstitution:
  //         cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
  //   )
  //       .then((value) {
  //     List<TemplateComunicationModel> cValue =
  //         value as List<TemplateComunicationModel>;
  //     availableSmtp2GoTemplate = cValue
  //         .map<DropdownMenuItem<TemplateComunicationModel>>(
  //             (TemplateComunicationModel item) {
  //       return DropdownMenuItem<TemplateComunicationModel>(
  //           value: item, child: Text(item.id));
  //     }).toList();
  //   });
  // }

  void initState() {
    initializeControllers();
    super.initState();
  }

  void downloadTemplateComunication() {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    ComunicationNotifier comunicationNotifier =
        Provider.of<ComunicationNotifier>(context, listen: false);
    comunicationNotifier.downloadEmailTemplateDetail(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        idtemplate: smtp2GoTemplate!.id);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   ComunicationNotifier comunicationNotifier =
  //       Provider.of<ComunicationNotifier>(context);
  //   // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
  //   if (comunicationNotifier.isUpdated) {
  //     // Post-frame callback to avoid infinite loop during build phase
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       comunicationNotifier.setUpdate(false); // Reset the update flag
  //       getTemplateComunication();
  //     });
  //   }
  // }
  void prepareComunication() {
    if (_formKey.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserModel cUserModel = authNotifier.getUser();
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      ComunicationNotifier comunicationNotifier =
          Provider.of<ComunicationNotifier>(context, listen: false);
      ComunicationModel cComunicationModel = ComunicationModel(
          idComunication: 0,
          nameComunication: nameComunicationController.text,
          senderComunication: senderComunicationController.text,
          emailSenderComunication: emailSenderComunicationController.text,
          subjectComunication: subjectEmailComunicationController.text,
          idTemplateComunication: smtp2GoTemplate!.id,
          idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
          idInstitution:
              cUserAppInstitutionModel.idInstitutionNavigation.idInstitution);
      comunicationNotifier
          .addComunication(
              context: context,
              token: authNotifier.token,
              comunicationModel: cComunicationModel)
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Comunicazioni",
                    message: "Comunicazione predisposta correttamente",
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

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        //drawer: const CustomDrawerWidget(),
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text("Predisposizione comunicazione",
              style: Theme.of(context).textTheme.headlineMedium),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Consumer<ComunicationNotifier>(
                builder: (context, comunicationNotifier, _) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: comunicationNotifier.getEmailTemplates(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        idInstitution: cUserAppInstitutionModel
                            .idInstitutionNavigation.idInstitution,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          color: Colors.redAccent,
                                        ))),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                              'No data...',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          );
                        } else {
                          List<DropdownMenuItem<TemplateComunicationModel>>
                              tAvailableComunicationTemplate = [];
                          var tSnapshot =
                              snapshot.data as List<TemplateComunicationModel>;

                          tAvailableComunicationTemplate = tSnapshot
                              .map<DropdownMenuItem<TemplateComunicationModel>>(
                                  (TemplateComunicationModel item) {
                            return DropdownMenuItem<TemplateComunicationModel>(
                                value: item, child: Text(item.id));
                          }).toList();

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: CustomTextFormField(
                                  enabled: true,
                                  controller: nameComunicationController,
                                  labelText: AppStrings.nameComunication,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) =>
                                      _formKey.currentState?.validate(),
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : AppStrings
                                            .pleaseEnterNameComunication;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: CustomTextFormField(
                                  enabled: true,
                                  controller: senderComunicationController,
                                  labelText: AppStrings.senderComunication,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) =>
                                      _formKey.currentState?.validate(),
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : AppStrings
                                            .pleaseEnterSenderComunication;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: CustomTextFormField(
                                  enabled: true,
                                  controller: emailSenderComunicationController,
                                  labelText: AppStrings.emailSenderComunication,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) =>
                                      _formKey.currentState?.validate(),
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? AppStrings
                                            .pleaseEnterEmailSenderComunication
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
                                  enabled: true,
                                  controller:
                                      subjectEmailComunicationController,
                                  labelText:
                                      AppStrings.subjectEmailComunication,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) =>
                                      _formKey.currentState?.validate(),
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : AppStrings
                                            .pleaseEnterSubjectEmailComunication;
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropDownButtonFormField(
                                      enabled: true,
                                      actualValue: null,
                                      labelText:
                                          AppStrings.comunicationTemplate,
                                      listOfValue:
                                          tAvailableComunicationTemplate,
                                      onItemChanged: (value) {
                                        smtp2GoTemplate = value;
                                        viewTemplateValidNotifier.value = true;
                                        dataControllerListener();
                                        _formKey.currentState?.validate();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ValueListenableBuilder(
                                      valueListenable:
                                          viewTemplateValidNotifier,
                                      builder: (_, isValid, __) {
                                        return Row(
                                          children: [
                                            IconButton(
                                              tooltip: 'Visualizza',
                                              iconSize: 32,
                                              icon: Icon(Icons.zoom_in_map),
                                              onPressed: isValid
                                                  ? () {
                                                      Navigator.of(context).pushNamed(
                                                          AppRouter
                                                              .templateComunicationHtml,
                                                          arguments:
                                                              smtp2GoTemplate);
                                                    }
                                                  : null,
                                            ),
                                            IconButton(
                                              tooltip: 'Scarica',
                                              iconSize: 32,
                                              icon: Icon(Icons.download),
                                              onPressed: isValid
                                                  ? () {
                                                      downloadTemplateComunication();
                                                    }
                                                  : null,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ValueListenableBuilder(
                                      valueListenable:
                                          createComunicationValidNotifier,
                                      builder: (_, isValid, __) {
                                        return Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: isValid
                                                  ? () {
                                                      prepareComunication();
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                side: BorderSide(
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: const Text(
                                                AppStrings.generate,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
