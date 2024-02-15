import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/text.form.field.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/core/notifiers/home.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/pdf.invoice.screen.dart';
import 'package:np_casse/screens/cartScreen/widgets/custom.text.form.field.dart';
import 'package:np_casse/screens/cartScreen/widgets/drop.down.list.field.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ShNewEditScreen extends StatefulWidget {
  final StakeholderGiveModelSearch? cStakeholderGiveModelSearch;
  const ShNewEditScreen({
    Key? key,
    this.cStakeholderGiveModelSearch,
  }) : super(key: key);

  @override
  State<ShNewEditScreen> createState() => _ShShNewEditScreen();
}

enum TypeCharacter { personaFisica, ente }

enum GenderCharacter { male, female }

class _ShShNewEditScreen extends State<ShNewEditScreen> {
  TypeCharacter _characterType = TypeCharacter.personaFisica;
  GenderCharacter? _characterGender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController ragSocController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // TextEditingController genderController = TextEditingController();
  TextEditingController borndateController = TextEditingController();
  TextEditingController cFController = TextEditingController();
  TextEditingController addressStreetController = TextEditingController();
  TextEditingController addressNumberController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  List<String> listOfStates = ["Italia", "Francia", "Spagna", "Germania"];
  final String _valoreSimulatoState = "Italia";

  late String _selectedTypeValue;
  late String _selectedStateValue;
  late String _selectedGenderValue;
  late DateTime _selectedDate;

  late bool comCartacee;
  late bool comEmail;
  late bool consensoRingrazia;
  late bool consensoMaterialeInfo;
  late bool consensoComEspresso;
  late bool consensoMarketing;
  late bool consensoSms;
  bool editMode = false;
  late int idSh;
  @override
  void initState() {
    _selectedStateValue = _valoreSimulatoState;

    // nameController.text = "Alessio";
    // surnameController.text = "Granzotto";
    // emailController.text = "alessio.granzotto@aebsolutions.it";
    // borndateController.text = "07/07/2023";
    // cFController.text = "grnlss74l07c957y";
    // addressStreetController.text = "Via cardano";
    // addressNumberController.text = "77";
    // postalCodeController.text = "27100";
    // cityController.text = "Pavia";
    // provinceController.text = "PV";
    // phoneNumberController.text = "+393278370256";

    editMode = widget.cStakeholderGiveModelSearch != null;
    if (editMode) {
      idSh = widget.cStakeholderGiveModelSearch != null
          ? widget.cStakeholderGiveModelSearch!.id
          : 0;

      nameController.text = widget.cStakeholderGiveModelSearch!.nome;
      surnameController.text = widget.cStakeholderGiveModelSearch!.cognome;
      ragSocController.text =
          widget.cStakeholderGiveModelSearch!.ragionesociale;
      cFController.text = widget.cStakeholderGiveModelSearch!.codfisc;
      if (widget.cStakeholderGiveModelSearch!.sesso == 2) {
        _characterGender = GenderCharacter.female;
      } else if (widget.cStakeholderGiveModelSearch!.sesso == 1) {
        _characterGender = GenderCharacter.male;
      } else {
        _characterGender = null;
      }
      emailController.text = widget.cStakeholderGiveModelSearch!.email;
      phoneNumberController.text = widget.cStakeholderGiveModelSearch!.tel;
      mobileNumberController.text = widget.cStakeholderGiveModelSearch!.cell;
      addressStreetController.text =
          widget.cStakeholderGiveModelSearch!.recapitoGiveModel.indirizzo;
      addressNumberController.text =
          widget.cStakeholderGiveModelSearch!.recapitoGiveModel.nCivico;
      postalCodeController.text =
          widget.cStakeholderGiveModelSearch!.recapitoGiveModel.cap;
      cityController.text =
          widget.cStakeholderGiveModelSearch!.recapitoGiveModel.citta;
      provinceController.text =
          widget.cStakeholderGiveModelSearch!.recapitoGiveModel.prov;
      comCartacee =
          widget.cStakeholderGiveModelSearch!.comCartacee == 1 ? true : false;
      comEmail =
          widget.cStakeholderGiveModelSearch!.comEmail == 1 ? true : false;
      consensoRingrazia =
          widget.cStakeholderGiveModelSearch!.consensoRingrazia == 1
              ? true
              : false;
      consensoMaterialeInfo =
          widget.cStakeholderGiveModelSearch!.consensoMaterialeInfo == 1
              ? true
              : false;
      consensoComEspresso =
          widget.cStakeholderGiveModelSearch!.consensoComEspresso == 1
              ? true
              : false;
      consensoMarketing =
          widget.cStakeholderGiveModelSearch!.consensoMarketing == 1
              ? true
              : false;
      consensoSms =
          widget.cStakeholderGiveModelSearch!.consensoSms == 1 ? true : false;
      borndateController.text = widget.cStakeholderGiveModelSearch!.dataNascita;
      if (widget.cStakeholderGiveModelSearch!.tipoDonatore == 0) {
        _characterType = TypeCharacter.ente;
      } else if (widget.cStakeholderGiveModelSearch!.tipoDonatore == 1) {
        _characterType = TypeCharacter.personaFisica;
      }
    } else {
      comCartacee = true;
      comEmail = true;
      consensoRingrazia = true;
      consensoMaterialeInfo = true;
      consensoComEspresso = true;
      consensoMarketing = true;
      consensoSms = true;
    }

    super.initState();
  }

  Future? createSh() {
    Future? result;
    if (_formKey.currentState!.validate()) {
      GiveNotifier giveNotifier =
          Provider.of<GiveNotifier>(context, listen: false);
      AuthenticationNotifier authenticationNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authenticationNotifier.getSelectedUserAppInstitution();
      if (editMode) {
        result = giveNotifier
            .updateStakeholder(
                context: context,
                token: authenticationNotifier.token,
                idUserAppInstitution:
                    cUserAppInstitutionModel.idUserAppInstitution,
                id: idSh,
                nome: nameController.text,
                cognome: surnameController.text,
                ragSoc: ragSocController.text,
                codfisc: cFController.text,
                sesso: _characterGender == GenderCharacter.male ? 1 : 2,
                email: emailController.text,
                tel: phoneNumberController.text,
                cell: mobileNumberController.text,
                nazione_nn_norm: _selectedStateValue,
                prov_nn_norm: provinceController.text,
                cap_nn_norm: postalCodeController.text,
                citta_nn_norm: cityController.text,
                indirizzo_nn_norm: addressStreetController.text,
                n_civico_nn_norm: addressNumberController.text,
                com_cartacee: comCartacee ? 1 : 0,
                com_email: comEmail ? 1 : 0,
                consenso_ringrazia: consensoRingrazia ? 1 : 0,
                consenso_materiale_info: consensoMaterialeInfo ? 1 : 0,
                consenso_com_espresso: consensoComEspresso ? 1 : 0,
                consenso_marketing: consensoMarketing ? 1 : 0,
                consenso_sms: consensoSms ? 1 : 0,
                datanascita: borndateController.text,
                tipo_donatore:
                    _characterType == TypeCharacter.personaFisica ? "1" : "0")
            .then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackUtil.stylishSnackBar(
                text: 'Anagrafica modificata',
                context: context,
              ),
            );
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackUtil.stylishSnackBar(
                text: 'Oops Something Went Wrong',
                context: context,
              ),
            );
          }
        });
      } else {
        result = giveNotifier
            .addStakeholder(
                context: context,
                token: authenticationNotifier.token,
                idUserAppInstitution:
                    cUserAppInstitutionModel.idUserAppInstitution,
                nome: nameController.text,
                cognome: surnameController.text,
                ragSoc: ragSocController.text,
                codfisc: cFController.text,
                sesso: _characterGender == GenderCharacter.male ? 1 : 2,
                email: emailController.text,
                tel: phoneNumberController.text,
                cell: mobileNumberController.text,
                nazione_nn_norm: _selectedStateValue,
                prov_nn_norm: provinceController.text,
                cap_nn_norm: postalCodeController.text,
                citta_nn_norm: cityController.text,
                indirizzo_nn_norm: addressStreetController.text,
                n_civico_nn_norm: addressNumberController.text,
                com_cartacee: comCartacee ? 1 : 0,
                com_email: comEmail ? 1 : 0,
                consenso_ringrazia: consensoRingrazia ? 1 : 0,
                consenso_materiale_info: consensoMaterialeInfo ? 1 : 0,
                consenso_com_espresso: consensoComEspresso ? 1 : 0,
                consenso_marketing: consensoMarketing ? 1 : 0,
                consenso_sms: consensoSms ? 1 : 0,
                datanascita: borndateController.text,
                tipo_donatore:
                    _characterType == TypeCharacter.personaFisica ? "1" : "0")
            .then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackUtil.stylishSnackBar(
                text: 'Anagrafica inserita',
                context: context,
              ),
            );
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackUtil.stylishSnackBar(
                text: 'Oops Something Went Wrong',
                context: context,
              ),
            );
          }
        });
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    HomeNotifier homeNotifier = Provider.of<HomeNotifier>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.cStakeholderGiveModelSearch == null
              ? "Nuova anagrafica"
              : "Modifica anagrafica (id: ${widget.cStakeholderGiveModelSearch?.id})"),
        ),
        body: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var width = MediaQuery.of(context).size.width;
              return width > 800
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            width.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    color: Colors.blueGrey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: ListTile(
                                            title: Text(
                                              'Persona Fisica',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: Colors.blueGrey),
                                            ),
                                            leading: Radio<TypeCharacter>(
                                              fillColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              focusColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              value:
                                                  TypeCharacter.personaFisica,
                                              groupValue: _characterType,
                                              onChanged:
                                                  (TypeCharacter? value) {
                                                setState(() {
                                                  _characterType = value ??
                                                      TypeCharacter
                                                          .personaFisica;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: ListTile(
                                            title: Text(
                                              'Ente o Associazione',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: Colors.blueGrey),
                                            ),
                                            leading: Radio<TypeCharacter>(
                                              fillColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              focusColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              value: TypeCharacter.ente,
                                              groupValue: _characterType,
                                              onChanged:
                                                  (TypeCharacter? value) {
                                                setState(() {
                                                  _characterType = value ??
                                                      TypeCharacter.ente;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: _characterType ==
                                    TypeCharacter.personaFisica,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: AGTextFormField(
                                            controller: nameController,
                                            validator: (value) => value!
                                                    .toString()
                                                    .isEmpty
                                                ? "Inserisci il nome del donatore"
                                                : null,
                                            onChanged: (_) => _formKey
                                                .currentState
                                                ?.validate(),
                                            labelText: 'nome donatore',
                                            hintText: "nome del donatore"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _characterType ==
                                    TypeCharacter.personaFisica,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: AGTextFormField(
                                            controller: surnameController,
                                            validator: (value) => value!
                                                    .toString()
                                                    .isEmpty
                                                ? "Inserisci il cognome del donatore"
                                                : null,
                                            onChanged: (_) => _formKey
                                                .currentState
                                                ?.validate(),
                                            labelText: 'cognome donatore',
                                            hintText: "cognome del donatore"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _characterType == TypeCharacter.ente,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: AGTextFormField(
                                            controller: ragSocController,
                                            validator: (value) => value!
                                                    .toString()
                                                    .isEmpty
                                                ? "Inserisci la ragione sociale"
                                                : null,
                                            onChanged: (_) => _formKey
                                                .currentState
                                                ?.validate(),
                                            labelText:
                                                'ragione sociale donatore',
                                            hintText:
                                                "ragione sociale del donatore"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: borndateController,
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty &&
                                                _characterType ==
                                                    TypeCharacter
                                                        .personaFisica) {
                                              return 'inserisci la data di nascita';
                                            }
                                            return null;
                                          },
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'data di nascita',
                                          hintText:
                                              "data di nascita del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: _characterType ==
                                    TypeCharacter.personaFisica,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: ListTile(
                                              title: Text(
                                                'M',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: Colors.blueGrey),
                                              ),
                                              leading: Radio<GenderCharacter>(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                focusColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                value: GenderCharacter.male,
                                                groupValue: _characterGender,
                                                onChanged:
                                                    (GenderCharacter? value) {
                                                  setState(() {
                                                    _characterGender = value ??
                                                        GenderCharacter.male;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: ListTile(
                                              title: Text(
                                                'F',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: Colors.blueGrey),
                                              ),
                                              leading: Radio<GenderCharacter>(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                focusColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                value: GenderCharacter.female,
                                                groupValue: _characterGender,
                                                onChanged:
                                                    (GenderCharacter? value) {
                                                  setState(() {
                                                    _characterGender = value ??
                                                        GenderCharacter.female;
                                                  });
                                                },
                                              ),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: cFController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il codice fiscale del donatore"
                                              : null,
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'codice fiscale donatore',
                                          hintText:
                                              "codice fiscale del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: emailController,
                                          validator: (value) {
                                            const pattern =
                                                r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                                            final regExp = RegExp(pattern);

                                            if (value!.isEmpty) {
                                              return "inserisci l'email del donatore";
                                            } else if (!regExp
                                                .hasMatch(value)) {
                                              return 'inserisci una email valida';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'email donatore',
                                          hintText: "email del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: phoneNumberController,
                                          // validator: (value) {
                                          //   const pattern =
                                          //       r'(^(?:[+0])?[0-9]{12}$)';
                                          //   final regExp = RegExp(pattern);

                                          //   if (value!.isEmpty) {
                                          //     return "inserisci il numero di telefono del donatore";
                                          //   } else if (!regExp
                                          //       .hasMatch(value)) {
                                          //     return 'inserisci un numero di telefono valido';
                                          //   } else {
                                          //     return null;
                                          //   }
                                          // },
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText:
                                              'numero di telefono donatore',
                                          hintText:
                                              "numero di telefono del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: mobileNumberController,
                                          // validator: (value) {
                                          //   const pattern =
                                          //       r'(^(?:[+0])?[0-9]{12}$)';
                                          //   final regExp = RegExp(pattern);

                                          //   if (value!.isEmpty) {
                                          //     return "inserisci il numero di cellulare del donatore";
                                          //   } else if (!regExp
                                          //       .hasMatch(value)) {
                                          //     return 'inserisci un numero di cellulare valido';
                                          //   } else {
                                          //     return null;
                                          //   }
                                          // },
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText:
                                              'numero di cellulare donatore',
                                          hintText:
                                              "numero di cellulare del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: addressStreetController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci l'indirizzo del donatore"
                                              : null,
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'indirizzo donatore',
                                          hintText: "indirizzo del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: addressNumberController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il numero civico del donatore"
                                              : null,
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'numero civico donatore',
                                          hintText:
                                              "numero civico del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: postalCodeController,
                                          validator: (value) {
                                            const pattern = r'(^[0-9]{5}$)';
                                            final regExp = RegExp(pattern);

                                            if (value!.isEmpty) {
                                              return "inserisci il codice postale del donatore";
                                            } else if (!regExp
                                                .hasMatch(value)) {
                                              return 'inserisci una codice postale valido';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'codice postale donatore',
                                          hintText:
                                              "codice postale del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: cityController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il comune del donatore"
                                              : null,
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'comune donatore',
                                          hintText: "comune del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: AGTextFormField(
                                          controller: provinceController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il provincia del donatore"
                                              : null,
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          labelText: 'provincia donatore',
                                          hintText: "provincia del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: DropDownListField(
                                          actualValue: _selectedStateValue,
                                          listOfValue: listOfStates,
                                          labelText: 'nazione donatore',
                                          hintText: 'nazione del donatore',
                                          onItemChanged: (value) {
                                            _selectedStateValue = value;
                                          },
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "selezionare la nazione del donatore"
                                              : null,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: comCartacee,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      comCartacee = value!;
                                    });
                                  },
                                  title: const Text(
                                      'Consenso comunicazione cartacee'),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,

                                  value: comEmail,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      comEmail = value!;
                                    });
                                  },
                                  title: const Text(
                                      'Consenso comunicazioni elettroniche'),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoRingrazia,

                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoRingrazia = value!;
                                    });
                                  },
                                  title: const Text("Consenso ringraziamenti"),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoMaterialeInfo,

                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoMaterialeInfo = value!;
                                    });
                                  },
                                  title: const Text(
                                      'Consenso invio materiale informativo'),
                                  // // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoComEspresso,

                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoComEspresso = value!;
                                    });
                                  },
                                  title: const Text("Consenso espresso"),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoMarketing,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoMarketing = value!;
                                    });
                                  },
                                  title: const Text('Consenso marketing'),
                                  // subtitle: const Text(''),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoSms,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoSms = value!;
                                    });
                                  },
                                  title: const Text('Consenso SMS'),
                                  // subtitle: const Text(' '),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            width.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    color: Colors.blueGrey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: ListTile(
                                            title: Text(
                                              'Persona Fisica',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: Colors.blueGrey),
                                            ),
                                            leading: Radio<TypeCharacter>(
                                              fillColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              focusColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              value:
                                                  TypeCharacter.personaFisica,
                                              groupValue: _characterType,
                                              onChanged:
                                                  (TypeCharacter? value) {
                                                setState(() {
                                                  _characterType = value ??
                                                      TypeCharacter
                                                          .personaFisica;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: ListTile(
                                            title: Text(
                                              'Ente o Associazione',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: Colors.blueGrey),
                                            ),
                                            leading: Radio<TypeCharacter>(
                                              fillColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              focusColor: MaterialStateColor
                                                  .resolveWith((states) =>
                                                      Colors.blueAccent),
                                              value: TypeCharacter.ente,
                                              groupValue: _characterType,
                                              onChanged:
                                                  (TypeCharacter? value) {
                                                setState(() {
                                                  _characterType = value ??
                                                      TypeCharacter.ente;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: _characterType ==
                                    TypeCharacter.personaFisica,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: AGTextFormField(
                                            controller: nameController,
                                            validator: (value) => value!
                                                    .toString()
                                                    .isEmpty
                                                ? "Inserisci il nome del donatore"
                                                : null,
                                            labelText: 'nome donatore',
                                            hintText: "nome del donatore"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: _characterType ==
                                    TypeCharacter.personaFisica,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: AGTextFormField(
                                            controller: surnameController,
                                            validator: (value) => value!
                                                    .toString()
                                                    .isEmpty
                                                ? "Inserisci il cognome del donatore"
                                                : null,
                                            labelText: 'cognome donatore',
                                            hintText: "cognome del donatore"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: _characterType == TypeCharacter.ente,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: AGTextFormField(
                                            controller: ragSocController,
                                            validator: (value) => value!
                                                    .toString()
                                                    .isEmpty
                                                ? "Inserisci la ragione sociale"
                                                : null,
                                            onChanged: (_) => _formKey
                                                .currentState
                                                ?.validate(),
                                            labelText:
                                                'ragione sociale donatore',
                                            hintText:
                                                "ragione sociale del donatore"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: borndateController,
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty &&
                                                _characterType ==
                                                    TypeCharacter
                                                        .personaFisica) {
                                              return 'inserisci la data di nascita';
                                            }
                                            return null;
                                          },
                                          labelText: 'data di nascita',
                                          hintText:
                                              "data di nascita del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: _characterType ==
                                    TypeCharacter.personaFisica,
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: ListTile(
                                              title: Text(
                                                'M',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: Colors.blueGrey),
                                              ),
                                              leading: Radio<GenderCharacter>(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                focusColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                value: GenderCharacter.male,
                                                groupValue: _characterGender,
                                                onChanged:
                                                    (GenderCharacter? value) {
                                                  setState(() {
                                                    _characterGender = value ??
                                                        GenderCharacter.male;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: ListTile(
                                              title: Text(
                                                'F',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: Colors.blueGrey),
                                              ),
                                              leading: Radio<GenderCharacter>(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                focusColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blueAccent),
                                                value: GenderCharacter.female,
                                                groupValue: _characterGender,
                                                onChanged:
                                                    (GenderCharacter? value) {
                                                  setState(() {
                                                    _characterGender = value ??
                                                        GenderCharacter.female;
                                                  });
                                                },
                                              ),
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
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: cFController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il codice fiscale del donatore"
                                              : null,
                                          labelText: 'codice fiscale donatore',
                                          hintText:
                                              "codice fiscale del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: emailController,
                                          validator: (value) {
                                            const pattern =
                                                r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                                            final regExp = RegExp(pattern);

                                            if (value!.isEmpty) {
                                              return "inserisci l'email del donatore";
                                            } else if (!regExp
                                                .hasMatch(value)) {
                                              return 'inserisci una email valida';
                                            } else {
                                              return null;
                                            }
                                          },
                                          labelText: 'email donatore',
                                          hintText: "email del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: phoneNumberController,
                                          // validator: (value) {
                                          //   const pattern =
                                          //       r'(^(?:[+0])?[0-9]{12}$)';
                                          //   final regExp = RegExp(pattern);

                                          //   if (value!.isEmpty) {
                                          //     return "inserisci il numero di telefono del donatore";
                                          //   } else if (!regExp
                                          //       .hasMatch(value)) {
                                          //     return 'inserisci un numero di telefono valido';
                                          //   } else {
                                          //     return null;
                                          //   }
                                          // },
                                          labelText:
                                              'numero di telefono donatore',
                                          hintText:
                                              "numero di telefono del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: mobileNumberController,
                                          // validator: (value) {
                                          //   const pattern =
                                          //       r'(^(?:[+0])?[0-9]{12}$)';
                                          //   final regExp = RegExp(pattern);

                                          //   if (value!.isEmpty) {
                                          //     return "inserisci il numero di telefono del donatore";
                                          //   } else if (!regExp
                                          //       .hasMatch(value)) {
                                          //     return 'inserisci un numero di telefono valido';
                                          //   } else {
                                          //     return null;
                                          //   }
                                          // },
                                          labelText:
                                              'numero di cellulare donatore',
                                          hintText:
                                              "numero di cellulare del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: addressStreetController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci l'indirizzo del donatore"
                                              : null,
                                          labelText: 'indirizzo donatore',
                                          hintText: "indirizzo del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: addressNumberController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il numero civico del donatore"
                                              : null,
                                          labelText: 'numero civico donatore',
                                          hintText:
                                              "numero civico del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: postalCodeController,
                                          validator: (value) {
                                            const pattern = r'(^[0-9]{5}$)';
                                            final regExp = RegExp(pattern);

                                            if (value!.isEmpty) {
                                              return "inserisci il codice postale del donatore";
                                            } else if (!regExp
                                                .hasMatch(value)) {
                                              return 'inserisci una codice postale valido';
                                            } else {
                                              return null;
                                            }
                                          },
                                          labelText: 'codice postale donatore',
                                          hintText:
                                              "codice postale del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: cityController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il comune del donatore"
                                              : null,
                                          labelText: 'comune donatore',
                                          hintText: "comune del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: AGTextFormField(
                                          controller: provinceController,
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "Inserisci il provincia del donatore"
                                              : null,
                                          labelText: 'provincia donatore',
                                          hintText: "provincia del donatore"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: DropDownListField(
                                          actualValue: _selectedStateValue,
                                          listOfValue: listOfStates,
                                          labelText: 'nazione donatore',
                                          hintText: 'nazione del donatore',
                                          onItemChanged: (value) {
                                            _selectedStateValue = value;
                                          },
                                          validator: (value) => value!
                                                  .toString()
                                                  .isEmpty
                                              ? "selezionare la nazione del donatore"
                                              : null,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: comCartacee,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      comCartacee = value!;
                                    });
                                  },
                                  title: const Text(
                                      'Consenso comunicazione cartacee'),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,

                                  value: comEmail,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      comEmail = value!;
                                    });
                                  },
                                  title: const Text(
                                      'Consenso comunicazioni elettroniche'),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoRingrazia,

                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoRingrazia = value!;
                                    });
                                  },
                                  title: const Text("Consenso ringraziamenti"),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoMaterialeInfo,

                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoMaterialeInfo = value!;
                                    });
                                  },
                                  title: const Text(
                                      'Consenso invio materiale informativo'),
                                  // // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoComEspresso,

                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoComEspresso = value!;
                                    });
                                  },
                                  title: const Text("Consenso espresso"),
                                  // subtitle: const Text(""),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoMarketing,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoMarketing = value!;
                                    });
                                  },
                                  title: const Text('Consenso marketing'),
                                  // subtitle: const Text(''),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  side: const BorderSide(
                                      color: Colors.blueAccent),
                                  checkColor: Colors.blueAccent,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  activeColor: Colors.blueAccent,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: consensoSms,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      consensoSms = value!;
                                    });
                                  },
                                  title: const Text('Consenso SMS'),
                                  // subtitle: const Text(' '),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(eccentricity: 0.5),
          tooltip: "Salva",
          heroTag: 'Salva',
          onPressed: () {
            createSh();
          },
          backgroundColor: Colors.deepOrangeAccent,
          child: const Icon(Icons.save),
        ));
  }

  _selectDate(BuildContext context) async {
    final f = DateFormat('yyyy-MM-dd');
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.blueAccent, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.blueAccent, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newSelectedDate == null) {
      return;
    } else {
      _selectedDate = newSelectedDate;
      borndateController
        ..text = f.format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: borndateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }
}
