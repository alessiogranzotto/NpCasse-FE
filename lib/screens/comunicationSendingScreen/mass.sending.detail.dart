import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:uiblock/uiblock.dart';

class MassSendingDetailScreen extends StatefulWidget {
  final MassSendingModel massSendingModel;
  const MassSendingDetailScreen({super.key, required this.massSendingModel});

  @override
  State<MassSendingDetailScreen> createState() => _MassSendingDetailState();
}

class _MassSendingDetailState extends State<MassSendingDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isLoading = true;

  //NAME MASS SENDING
  late final TextEditingController nameMassSendingController;

  //ISARCHIVED MASS SENDING
  final ValueNotifier<bool> archiviedNotifier = ValueNotifier<bool>(false);

  //DESCRIPTION MASS SENDING
  late final TextEditingController descriptionMassSendingController;

  //DESCRIPTION MASS SENDING
  late final TextEditingController senderMassSendingController;

  //EMAIL SENDER MASS SENDING
  late final TextEditingController emailSenderMassSendingController;

  //AVAILABLE SMTP2GO TEMPLATE MASS SENDING
  List<TemplateSmtp2GoModel> availableSmtp2GoTemplate = List.empty();
  List<DropdownMenuItem> availableSmtp2GoTemplateItem = List.empty();

  //SMTP2GO TEMPLATE MASS SENDING
  TemplateSmtp2GoModel? smtp2GoTemplate;

  final ValueNotifier<bool> viewTemplateValidNotifier = ValueNotifier(false);

  void initializeControllers() {
    nameMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    descriptionMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    senderMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    emailSenderMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
  }

  void disposeControllers() {
    nameMassSendingController.dispose();
    descriptionMassSendingController.dispose();
    senderMassSendingController.dispose();
    emailSenderMassSendingController.dispose();
  }

  void dataControllerListener() {}

  Future<void> getEmailTemplatesFromSmtp2Go() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    await massSendingNotifier
        .getEmailTemplatesFromSmtp2Go(
      context: context,
      token: authenticationNotifier.token,
      idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
      idInstitution:
          cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
    )
        .then((value) {
      if (value is List<TemplateSmtp2GoModel>) {
        var snapshot = value;
        availableSmtp2GoTemplate = snapshot;

        setInitialData();

        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void downloadEmailTemplateDetailFromSmtp2Go() {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context, listen: false);
    massSendingNotifier.downloadEmailTemplateDetailFromSmtp2Go(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        idtemplate: smtp2GoTemplate!.id);
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    getEmailTemplatesFromSmtp2Go();
  }

  void setInitialData() {
    isEdit = widget.massSendingModel.idMassSending != 0;

    //NAME MASS SENDING
    nameMassSendingController.text =
        widget.massSendingModel.nameMassSending.toString();

    //ISARCHIVED MASS SENDING
    archiviedNotifier.value = widget.massSendingModel.archived;

    //DESCRIPTION MASS SENDING
    descriptionMassSendingController.text =
        widget.massSendingModel.descriptionMassSending.toString();

    //SENDER MASS SENDING
    senderMassSendingController.text =
        widget.massSendingModel.senderMassSending.toString();

    //EMAIL SENDER MASS SENDING
    emailSenderMassSendingController.text =
        widget.massSendingModel.emailSenderMassSending.toString();

    //AVAILABLE SMTP2GO TEMPLATE MASS SENDING
    availableSmtp2GoTemplateItem = availableSmtp2GoTemplate
        .map<DropdownMenuItem<TemplateSmtp2GoModel>>(
            (TemplateSmtp2GoModel item) {
      return DropdownMenuItem<TemplateSmtp2GoModel>(
          value: item, child: Text(item.id + " - " + item.name));
    }).toList();

    //SMTP2GO TEMPLATE MASS SENDING
    var itemSmtp2GoTemplate = availableSmtp2GoTemplate
        .where((e) => e.id == widget.massSendingModel.idTemplateMassSending);

    smtp2GoTemplate = itemSmtp2GoTemplate.firstOrNull;
    if (smtp2GoTemplate != null) {
      viewTemplateValidNotifier.value = true;
    }
    // availableSmtp2GoTemplate = snapshot
    //     .map<DropdownMenuItem<TemplateSmtp2GoModel>>(
    //         (TemplateSmtp2GoModel item) {
    //   return DropdownMenuItem<TemplateSmtp2GoModel>(
    //       value: item, child: Text(item.id + " - " + item.name));
    // }).toList();
  }

  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Dettaglio invio massivo: ${widget.massSendingModel.nameMassSending}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.redAccent,
                    )))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CustomTextFormField(
                              enabled: true,
                              controller: nameMassSendingController,
                              labelText: AppStrings.nameComunicationSending,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              // onChanged: (_) =>
                              //     _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : AppStrings
                                        .pleaseEnterNameComunicationSending;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                              valueListenable:
                                  archiviedNotifier, // Ascolta i cambiamenti del ValueNotifier
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                    title: Text("Archiviata"),
                                    value: value,
                                    onChanged: (bool? newValue) {
                                      archiviedNotifier.value = newValue ??
                                          false; // Aggiorna il valore del ValueNotifier
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading);
                              },
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomTextFormField(
                        enabled: true,
                        controller: descriptionMassSendingController,
                        labelText: AppStrings.descriptionComunicationSending,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        // onChanged: (_) => _formKey.currentState?.validate(),
                        // validator: (value) {
                        //   return value!.isNotEmpty
                        //       ? null
                        //       : AppStrings.pleaseEnterSenderMassSending;
                        // },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomTextFormField(
                        enabled: true,
                        controller: senderMassSendingController,
                        labelText: AppStrings.senderComunicationSending,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        // onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : AppStrings.pleaseEnterSenderComunicationSending;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomTextFormField(
                        enabled: true,
                        controller: emailSenderMassSendingController,
                        labelText: AppStrings.emailSenderComunicationSending,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        // onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? AppStrings
                                  .pleaseEnterEmailSenderComunicationSending
                              : AppConstants.emailRegex.hasMatch(value)
                                  ? null
                                  : AppStrings.invalidEmailAddress;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: smtp2GoTemplate,
                              labelText: AppStrings.comunicationSendingTemplate,
                              listOfValue: availableSmtp2GoTemplateItem,
                              onItemChanged: (value) {
                                smtp2GoTemplate = value;
                                viewTemplateValidNotifier.value = true;
                                dataControllerListener();
                                // _formKey.currentState?.validate();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: viewTemplateValidNotifier,
                            builder: (_, isValid, __) {
                              return Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Scarica',
                                    iconSize: 32,
                                    icon: Icon(Icons.download),
                                    onPressed: isValid
                                        ? () {
                                            downloadEmailTemplateDetailFromSmtp2Go();
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
                  ],
                ))),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  UIBlock.block(context);
                  MassSendingModel massSendingModel = MassSendingModel(
                      idMassSending: widget.massSendingModel.idMassSending,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      idInstitution: cUserAppInstitutionModel
                          .idInstitutionNavigation.idInstitution,
                      archived: archiviedNotifier.value,
                      nameMassSending: nameMassSendingController.text,
                      descriptionMassSending:
                          descriptionMassSendingController.text,
                      senderMassSending: senderMassSendingController.text,
                      emailSenderMassSending:
                          emailSenderMassSendingController.text,
                      idTemplateMassSending:
                          smtp2GoTemplate == null ? '' : smtp2GoTemplate!.id,
                      stateMassSending: 0,
                      stateMassSendingDescription: '',
                      massSendingGiveAccumulator: List.empty());

                  massSendingNotifier
                      .addOrUpdateMassSending(
                          context: context,
                          token: authenticationNotifier.token,
                          massSendingModel: massSendingModel)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Comunicazioni",
                              message: "Informazioni aggiornate",
                              contentType: "success"));
                      UIBlock.unblock(context);
                      Navigator.of(context).pop();
                      massSendingNotifier.refresh();
                    } else {
                      UIBlock.unblock(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Comunicazioni",
                              message: "Errore di connessione",
                              contentType: "failure"));
                    }
                  });
                }
              },

              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.check),
            ),
          ),
        ]));
  }
}
