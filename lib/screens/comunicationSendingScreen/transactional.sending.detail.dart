import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.notifier.dart';
import 'package:np_casse/core/notifiers/transactional.sending.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:uiblock/uiblock.dart';

class TransactionalSendingDetailScreen extends StatefulWidget {
  final TransactionalSendingModel transactionalSendingModel;
  const TransactionalSendingDetailScreen(
      {super.key, required this.transactionalSendingModel});

  @override
  State<TransactionalSendingDetailScreen> createState() =>
      _TransactionalSendingDetailScreen();
}

class _TransactionalSendingDetailScreen
    extends State<TransactionalSendingDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isLoadingEmailTemplatesFromSmtp2Go = true;
  bool isLoadingInstitutionEmail = true;
  bool isLoadingAction = true;

  late final TextEditingController nameTransactionalSendingController;

  //ISARCHIVED TRANSACTIONAL SENDING
  final ValueNotifier<bool> archiviedNotifier = ValueNotifier<bool>(false);

  //DESCRIPTION TRANSACTIONAL SENDING
  late final TextEditingController descriptionTransactionalSendingController;

  //DESCRIPTION TRANSACTIONAL SENDING
  late final TextEditingController senderTransactionalSendingController;

  //EMAIL SENDER TRANSACTIONAL SENDING
  late final TextEditingController emailSenderTransactionalSendingController;

  //AVAILABLE ACTION TRANSACTIONAL SENDING
  List<String> availableActionTransactionalSending = List.empty();
  List<DropdownMenuItem> availableActionTransactionalSendingItem = List.empty();

  //ACTION TRANSACTIONAL SENDING
  String? actionTransactionalSending;

  //AVAILABLE SMTP2GO TEMPLATE TRANSACTIONAL SENDING
  List<TemplateSmtp2GoModel> availableSmtp2GoTemplate = List.empty();
  List<DropdownMenuItem> availableSmtp2GoTemplateItem = List.empty();

  //SMTP2GO TEMPLATE TRANSACTIONAL SENDING
  TemplateSmtp2GoModel? smtp2GoTemplate;

  //AVAILABLE ATTTACH TEMPLATE TRANSACTIONAL SENDING
  //SINGLE
  List<InvoiceTypeModel> availableInvoiceTypeModel = List.empty();
  List<DropdownMenuItem> availableInvoiceTypeModelItemSingle = List.empty();

  //INVOICE TYPE MODEL MULTIPLE
  List<DropdownItem<InvoiceTypeModel>> availableInvoiceTypeModelItemMultiple =
      [];
  final availableInvoiceTypeModelController =
      MultiSelectController<InvoiceTypeModel>();

  //INVOICE TYPE MODEL SINGLE
  InvoiceTypeModel? invoiceTypeModelMyosotis;

  final ValueNotifier<bool> viewTemplateValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> viewAttachValidNotifier = ValueNotifier(false);

  bool checkIsLoadingGeneral() {
    return isLoadingEmailTemplatesFromSmtp2Go ||
        isLoadingInstitutionEmail ||
        isLoadingAction;
  }

  void initializeControllers() {
    nameTransactionalSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    descriptionTransactionalSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    senderTransactionalSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    emailSenderTransactionalSendingController = TextEditingController()
      ..addListener(dataControllerListener);
  }

  void disposeControllers() {
    nameTransactionalSendingController.dispose();
    descriptionTransactionalSendingController.dispose();
    senderTransactionalSendingController.dispose();
    emailSenderTransactionalSendingController.dispose();
    availableInvoiceTypeModelController.dispose();
  }

  void dataControllerListener() {}

  Future<void> getEmailTemplatesFromSmtp2Go() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    TransactionalSendingNotifier transactionalSendingNotifier =
        Provider.of<TransactionalSendingNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    await transactionalSendingNotifier
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

        setEmailTemplatesFromSmtp2GoData();

        setState(() {
          isLoadingEmailTemplatesFromSmtp2Go = false;
        });
      }
    });
  }

  Future<void> getInstitutionEmail() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    InstitutionAttributeNotifier institutionAttributeNotifier =
        Provider.of<InstitutionAttributeNotifier>(context, listen: false);
    await institutionAttributeNotifier
        .getInstitutionEmail(
      context: context,
      token: authenticationNotifier.token,
      idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
    )
        .then((value) {
      if (value is List<InvoiceTypeModel>) {
        var snapshot = value;
        availableInvoiceTypeModel = snapshot;

        setInstitutionInvoiceData();

        setState(() {
          isLoadingInstitutionEmail = false;
        });
      }
    });
  }

  Future<void> getAvailableAction() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    TransactionalSendingNotifier transactionalSendingNotifier =
        Provider.of<TransactionalSendingNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    await transactionalSendingNotifier
        .getAvailableAction(
      context: context,
      token: authenticationNotifier.token,
      idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
    )
        .then((value) {
      if (value is List<String>) {
        var snapshot = value;
        availableActionTransactionalSending = snapshot;

        setAvailableAction();

        setState(() {
          isLoadingAction = false;
        });
      }
    });
  }

  Future<void> downloadEmailTemplateDetailFromSmtp2Go() async {
    viewTemplateValidNotifier.value = false;
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    TransactionalSendingNotifier transactionalSendingNotifier =
        Provider.of<TransactionalSendingNotifier>(context, listen: false);
    await transactionalSendingNotifier.downloadEmailTemplateDetailFromSmtp2Go(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        idtemplate: smtp2GoTemplate!.id);

    viewTemplateValidNotifier.value = true;
    return null;
  }

  Future<void> downloadInvoiceTypeModel() async {
    viewAttachValidNotifier.value = false;
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    InstitutionAttributeNotifier institutionAttributeNotifier =
        Provider.of<InstitutionAttributeNotifier>(context, listen: false);
    await institutionAttributeNotifier.downloadInstitutionEmail(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        emailName: invoiceTypeModelMyosotis!.emailName);

    viewAttachValidNotifier.value = true;
    return null;
  }

  void setInitialData() {
    isEdit = widget.transactionalSendingModel.idTransactionalSending != 0;

    //NAME TRANSACTIONAL SENDING
    nameTransactionalSendingController.text =
        widget.transactionalSendingModel.nameTransactionalSending.toString();

    //ISARCHIVED TRANSACTIONAL SENDING
    archiviedNotifier.value = widget.transactionalSendingModel.archived;

    //DESCRIPTION TRANSACTIONAL SENDING
    descriptionTransactionalSendingController.text = widget
        .transactionalSendingModel.descriptionTransactionalSending
        .toString();

    //SENDER TRANSACTIONAL SENDING
    senderTransactionalSendingController.text =
        widget.transactionalSendingModel.senderTransactionalSending.toString();

    //EMAIL SENDER TRANSACTIONAL SENDING
    emailSenderTransactionalSendingController.text = widget
        .transactionalSendingModel.emailSenderTransactionalSending
        .toString();
  }

  void setAvailableAction() {
    //AVAILABLE ACTION TRANSACTIONAL SENDING
    availableActionTransactionalSendingItem =
        availableActionTransactionalSending
            .map<DropdownMenuItem<String>>((String item) {
      return DropdownMenuItem<String>(value: item, child: Text(item));
    }).toList();

    //ACTION TRANSACTIONAL SENDING
    var itemActionTransactionalSending =
        availableActionTransactionalSending.where((e) =>
            e == widget.transactionalSendingModel.actionTransactionalSending);

    actionTransactionalSending = itemActionTransactionalSending.firstOrNull;
  }

  void setEmailTemplatesFromSmtp2GoData() {
    //AVAILABLE SMTP2GO TEMPLATE TRANSACTIONAL SENDING
    availableSmtp2GoTemplateItem = availableSmtp2GoTemplate
        .map<DropdownMenuItem<TemplateSmtp2GoModel>>(
            (TemplateSmtp2GoModel item) {
      var text = item.name;
      return DropdownMenuItem<TemplateSmtp2GoModel>(
          value: item, child: Text(text));
    }).toList();

    //SMTP2GO TEMPLATE TRANSACTIONAL SENDING
    var itemSmtp2GoTemplate = availableSmtp2GoTemplate.where((e) =>
        e.id ==
        widget.transactionalSendingModel.idTemplateTransactionalSending);

    smtp2GoTemplate = itemSmtp2GoTemplate.firstOrNull;
    if (smtp2GoTemplate != null && smtp2GoTemplate!.id.isNotEmpty) {
      viewTemplateValidNotifier.value = true;
    }
  }

  void setInstitutionInvoiceData() {
    //AVAILABLE INSTITUTION EMAIL TRANSACTIONAL SENDING
    availableInvoiceTypeModel.add(InvoiceTypeModel.empty());
    availableInvoiceTypeModelItemSingle = availableInvoiceTypeModel
        .map<DropdownMenuItem<InvoiceTypeModel>>((InvoiceTypeModel item) {
      var text = item.emailName;
      if (text.isEmpty) {
        text = "Nessun allegato";
      }
      return DropdownMenuItem<InvoiceTypeModel>(value: item, child: Text(text));
    }).toList();

    //INSTITUTION EMAIL TRANSACTIONAL SENDING - SINGLE
    var itemInvoiceTypeModel = availableInvoiceTypeModel.where((e) =>
        e.emailName ==
        widget.transactionalSendingModel.idAttachTransactionalSending);

    invoiceTypeModelMyosotis = itemInvoiceTypeModel.firstOrNull;
    if (invoiceTypeModelMyosotis != null &&
        invoiceTypeModelMyosotis!.emailName.isNotEmpty) {
      viewAttachValidNotifier.value = true;
    } else {}

    //INSTITUTION EMAIL TRANSACTIONAL SENDING - MULTIPLE
    for (int i = 0; i < availableInvoiceTypeModel.length; i++) {
      if (availableInvoiceTypeModel[i].emailName.isNotEmpty) {
        bool isPresent = false;
        if (widget.transactionalSendingModel.idAttachTransactionalSending !=
            null) {
          isPresent = widget
              .transactionalSendingModel.idAttachTransactionalSending!
              .split("*;*")
              .contains(availableInvoiceTypeModel[i].emailName);
        }
        availableInvoiceTypeModelItemMultiple.add(DropdownItem(
            selected: isPresent,
            label: availableInvoiceTypeModel[i].emailName,
            value: availableInvoiceTypeModel[i]));
      }

      // print(isPresent);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    setInitialData();
    getEmailTemplatesFromSmtp2Go();
    getInstitutionEmail();
    getAvailableAction();
  }

  @override
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
    TransactionalSendingNotifier transactionalSendingNotifier =
        Provider.of<TransactionalSendingNotifier>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Dettaglio transazionale: ${widget.transactionalSendingModel.nameTransactionalSending}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: checkIsLoadingGeneral()
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
                              controller: nameTransactionalSendingController,
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
                        controller: descriptionTransactionalSendingController,
                        labelText: AppStrings.descriptionComunicationSending,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        // onChanged: (_) => _formKey.currentState?.validate(),
                        // validator: (value) {
                        //   return value!.isNotEmpty
                        //       ? null
                        //       : AppStrings.pleaseEnterSenderTransactionalSending;
                        // },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomTextFormField(
                        enabled: true,
                        controller: senderTransactionalSendingController,
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
                        controller: emailSenderTransactionalSendingController,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomDropDownButtonFormField(
                        enabled: true,
                        actualValue: actionTransactionalSending,
                        labelText: AppStrings.actionComunicationSendingTemplate,
                        listOfValue: availableActionTransactionalSendingItem,
                        onItemChanged: (value) {
                          actionTransactionalSending = value;
                          smtp2GoTemplate = null;
                          invoiceTypeModelMyosotis = null;
                          // availableInvoiceTypeModelController.items
                          //     .forEach((item) => item.selected = false);
                          availableInvoiceTypeModelItemMultiple
                              .forEach((item) => item.selected = false);
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
                                print(smtp2GoTemplate);
                                if (smtp2GoTemplate != null &&
                                    smtp2GoTemplate!.name.isNotEmpty) {
                                  viewTemplateValidNotifier.value = true;
                                } else {
                                  viewTemplateValidNotifier.value = false;
                                }
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
                    Visibility(
                      visible: actionTransactionalSending ==
                          "Ringraziamento myosotis",
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomDropDownButtonFormField(
                                enabled: true,
                                actualValue: invoiceTypeModelMyosotis,
                                labelText: AppStrings
                                    .comunicationAttachSendingTemplate,
                                listOfValue:
                                    availableInvoiceTypeModelItemSingle,
                                onItemChanged: (value) {
                                  invoiceTypeModelMyosotis = value;
                                  print(invoiceTypeModelMyosotis);
                                  if (invoiceTypeModelMyosotis != null &&
                                      invoiceTypeModelMyosotis!
                                          .emailName.isNotEmpty) {
                                    viewAttachValidNotifier.value = true;
                                  } else {
                                    viewAttachValidNotifier.value = false;
                                  }
                                  dataControllerListener();
                                  // _formKey.currentState?.validate();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: viewAttachValidNotifier,
                              builder: (_, isValid, __) {
                                return Row(
                                  children: [
                                    IconButton(
                                      tooltip: 'Scarica',
                                      iconSize: 32,
                                      icon: Icon(Icons.download),
                                      onPressed: isValid
                                          ? () {
                                              downloadInvoiceTypeModel();
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
                    ),
                    Visibility(
                      visible: actionTransactionalSending ==
                          "Ringraziamento carrello",
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MultiDropdown<InvoiceTypeModel>(
                                items: availableInvoiceTypeModelItemMultiple,
                                controller: availableInvoiceTypeModelController,
                                enabled: true,
                                searchEnabled: false,
                                chipDecoration: ChipDecoration(
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(width: 1.5),
                                  backgroundColor: Colors.transparent,
                                  wrap: true,
                                  runSpacing: 2,
                                  spacing: 10,
                                ),
                                fieldDecoration: FieldDecoration(
                                  hintText: 'Template allegato comunicazione',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.3)),
                                  prefixIcon:
                                      const Icon(Icons.article_outlined),
                                  showClearIcon: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                dropdownItemDecoration: DropdownItemDecoration(
                                  selectedIcon: const Icon(Icons.check_box,
                                      color: CustomColors.darkBlue),
                                  disabledIcon: Icon(Icons.lock,
                                      color: Colors.grey.shade300),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Selezione obbligatoria';
                                  }
                                  return null;
                                },
                                onSelectionChange: (selectedItems) {},
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    )
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
                  String? idAttachTransactionalSending;
                  if (actionTransactionalSending == "Ringraziamento carrello") {
                    idAttachTransactionalSending =
                        availableInvoiceTypeModelController.selectedItems
                            .map((item) => item.label)
                            .toList()
                            .join("*;*");
                  } else if (actionTransactionalSending ==
                      "Ringraziamento myosotis") {
                    idAttachTransactionalSending =
                        invoiceTypeModelMyosotis != null
                            ? invoiceTypeModelMyosotis!.emailName
                            : null;
                  }

                  TransactionalSendingModel transactionalSendingModel =
                      TransactionalSendingModel(
                    idTransactionalSending:
                        widget.transactionalSendingModel.idTransactionalSending,
                    idUserAppInstitution:
                        cUserAppInstitutionModel.idUserAppInstitution,
                    idInstitution: cUserAppInstitutionModel
                        .idInstitutionNavigation.idInstitution,
                    archived: archiviedNotifier.value,
                    nameTransactionalSending:
                        nameTransactionalSendingController.text,
                    descriptionTransactionalSending:
                        descriptionTransactionalSendingController.text,
                    senderTransactionalSending:
                        senderTransactionalSendingController.text,
                    emailSenderTransactionalSending:
                        emailSenderTransactionalSendingController.text,
                    actionTransactionalSending: actionTransactionalSending!,
                    idTemplateTransactionalSending: smtp2GoTemplate!.id,
                    idAttachTransactionalSending: idAttachTransactionalSending,
                  );

                  transactionalSendingNotifier
                      .addOrUpdateTransactionalSending(
                          context: context,
                          token: authenticationNotifier.token,
                          transactionalSendingModel: transactionalSendingModel)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Comunicazioni",
                              message: "Informazioni aggiornate",
                              contentType: "success"));
                      UIBlock.unblock(context);
                      Navigator.of(context).pop();
                      transactionalSendingNotifier.refresh();
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
