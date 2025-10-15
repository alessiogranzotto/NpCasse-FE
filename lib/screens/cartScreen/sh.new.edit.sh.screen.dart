import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/api/geo.autocomplete.api.dart';
import 'package:np_casse/core/models/geo.model.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/widgets/geo/city.autocomplete.dart';
import 'package:np_casse/screens/cartScreen/widgets/geo/country.autocomplete.dart';
import 'package:np_casse/screens/cartScreen/widgets/geo/full.address.autocomplete.dart';
import 'package:np_casse/screens/cartScreen/widgets/geo/street.autocomplete.dart';
import 'package:np_casse/screens/cartScreen/widgets/show.give.sh.data.table.dart';
import 'package:provider/provider.dart';

class ShNewEditScreen extends StatefulWidget {
  final StakeholderGiveModelSearch? editStakeholderGiveModelSearch;
  final int idCart;
  const ShNewEditScreen({
    Key? key,
    required this.idCart,
    this.editStakeholderGiveModelSearch,
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
  TextEditingController borndateController = TextEditingController();
  TextEditingController cFController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  TextEditingController fullAddressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController provinceCodeController = TextEditingController();
  TextEditingController district1Controller = TextEditingController();
  TextEditingController district2Controller = TextEditingController();
  TextEditingController district3Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController streetNumberController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  // List<String> listOfStates = ["Italia", "Francia", "Spagna", "Germania"];
  // final String _valoreSimulatoState = "Italia";
  late List<GeoCountryItemModel> geoFullAddressItemModelList = [];

  late GeoCountryItemModel cGeoCountryItemModel;
  late GeoFullAddressItemModel cGeoFullAddressItemModel;
  late GeoCityItemModel cGeoCityItemModel;
  late GeoStreetItemModel cGeoStreetItemModel;

  late DateTime _selectedDate;
  late bool comCartacee;
  late bool comEmail;
  late bool consensoRingrazia;
  late bool consensoMaterialeInfo;
  late bool consensoComEspresso;
  late bool consensoMarketing;
  late bool consensoSms;

  bool editMode = false;
  int idSh = 0;
  bool isDeduplica = false;
  bool enableNormalization = false;

  ValueNotifier<bool> visibilityDeduplicationButton =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> visibilityForceSaveButton = ValueNotifier<bool>(false);
  ValueNotifier<bool> visibilitySaveButton = ValueNotifier<bool>(true);
  ValueNotifier<bool> _isSavingNotifier = ValueNotifier<bool>(false);

  ValueNotifier<bool> visibilityDeduplicationScreen =
      ValueNotifier<bool>(false);
  List<StakeholderDeduplicaResult> stakeholderDeduplicaResult = List.empty();
  StakeholderGiveModelSearch? onDeduplicaSelectedStakeholderGiveModelSearch;
  Timer? _timer;

  int stepValidation = 0;

  GeoNormItemModel cGeoNormItemModel = GeoNormItemModel.empty();
  bool geoNormItemModelVisible = false;
  initGeoCountryItemModel() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    cGeoCountryItemModel = GeoCountryItemModel.empty();
    var response = await GeoAutocompleteAPI.getAllCountrySuggestion(
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution);

    if (response != null) {
      final Map<String, dynamic> parseData =
          await jsonDecode(response as String);
      bool isOk = parseData['isOk'];
      if (isOk) {
        final List<GeoCountryItemModel> suggestions =
            List.from(parseData['okResult'])
                .map((e) => GeoCountryItemModel.fromJson(e))
                .toList();
        setState(() {
          geoFullAddressItemModelList = suggestions;
          cGeoCountryItemModel = GeoCountryItemModel.italy();
        });
      }
    }
    countryController.text = cGeoCountryItemModel.countryEn;
  }

  @override
  void initState() {
    super.initState();

    initGeoCountryItemModel();
    editMode = widget.editStakeholderGiveModelSearch != null &&
        widget.editStakeholderGiveModelSearch!.id != 0;
    if (editMode) {
      idSh = widget.editStakeholderGiveModelSearch != null
          ? widget.editStakeholderGiveModelSearch!.id
          : 0;

      nameController.text = widget.editStakeholderGiveModelSearch!.nome;
      surnameController.text = widget.editStakeholderGiveModelSearch!.cognome;
      ragSocController.text =
          widget.editStakeholderGiveModelSearch!.ragionesociale;
      cFController.text = widget.editStakeholderGiveModelSearch!.codfisc;
      if (widget.editStakeholderGiveModelSearch!.sesso == 2) {
        _characterGender = GenderCharacter.female;
      } else if (widget.editStakeholderGiveModelSearch!.sesso == 1) {
        _characterGender = GenderCharacter.male;
      } else {
        _characterGender = null;
      }
      emailController.text = widget.editStakeholderGiveModelSearch!.email;
      phoneNumberController.text = widget.editStakeholderGiveModelSearch!.tel;
      mobileNumberController.text = widget.editStakeholderGiveModelSearch!.cell;

      streetController.text =
          widget.editStakeholderGiveModelSearch!.recapitoGiveModel.indirizzo;
      streetNumberController.text =
          widget.editStakeholderGiveModelSearch!.recapitoGiveModel.nCivico;
      zipCodeController.text =
          widget.editStakeholderGiveModelSearch!.recapitoGiveModel.cap;
      cityController.text =
          widget.editStakeholderGiveModelSearch!.recapitoGiveModel.citta;

      provinceCodeController.text =
          widget.editStakeholderGiveModelSearch!.recapitoGiveModel.prov;
      regionController.text =
          widget.editStakeholderGiveModelSearch!.recapitoGiveModel.regione;

      comCartacee = widget.editStakeholderGiveModelSearch!.comCartacee == 1
          ? true
          : false;
      comEmail =
          widget.editStakeholderGiveModelSearch!.comEmail == 1 ? true : false;
      consensoRingrazia =
          widget.editStakeholderGiveModelSearch!.consensoRingrazia == 1
              ? true
              : false;
      consensoMaterialeInfo =
          widget.editStakeholderGiveModelSearch!.consensoMaterialeInfo == 1
              ? true
              : false;
      consensoComEspresso =
          widget.editStakeholderGiveModelSearch!.consensoComEspresso == 1
              ? true
              : false;
      consensoMarketing =
          widget.editStakeholderGiveModelSearch!.consensoMarketing == 1
              ? true
              : false;
      consensoSms = widget.editStakeholderGiveModelSearch!.consensoSms == 1
          ? true
          : false;
      borndateController.text =
          widget.editStakeholderGiveModelSearch!.dataNascita;
      if (widget.editStakeholderGiveModelSearch!.tipoDonatore == 0) {
        _characterType = TypeCharacter.ente;
      } else if (widget.editStakeholderGiveModelSearch!.tipoDonatore == 1) {
        _characterType = TypeCharacter.personaFisica;
      }
    } else {
      nameController.text = widget.editStakeholderGiveModelSearch!.nome;
      surnameController.text = widget.editStakeholderGiveModelSearch!.cognome;
      ragSocController.text =
          widget.editStakeholderGiveModelSearch!.ragionesociale;
      cFController.text = widget.editStakeholderGiveModelSearch!.codfisc;
      comCartacee = true;
      comEmail = true;
      consensoRingrazia = true;
      consensoMaterialeInfo = true;
      consensoComEspresso = true;
      consensoMarketing = true;
      consensoSms = true;

      geoNormItemModelVisible = false;
    }
  }

  Future? createSh(int forcingId, bool mustForce) {
    Future? result;
    if (_formKey.currentState!.validate()) {
      //visibilityDeduplicationButton.value = false;
      //visibilityForceSaveButton.value = false;
      // visibilitySaveButton.value = false;

      GiveNotifier giveNotifier =
          Provider.of<GiveNotifier>(context, listen: false);
      AuthenticationNotifier authenticationNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authenticationNotifier.getSelectedUserAppInstitution();
      geoNormItemModelVisible = false;
      if (enableNormalization) {
        //PERFORM NORMALIZATION
        GeoAutocompleteAPI.executeNormalization(
                token: authenticationNotifier.token,
                idUserAppInstitution:
                    cUserAppInstitutionModel.idUserAppInstitution,
                iso3: cGeoCountryItemModel.iso3,
                country: countryController.text,
                state: stateController.text,
                region: regionController.text,
                province: provinceCodeController.text,
                city: cityController.text,
                district1: district1Controller.text,
                district2: district2Controller.text,
                district3: district3Controller.text,
                postalCode: zipCodeController.text,
                streetName: streetController.text,
                streetNumber: streetNumberController.text)
            .then((value) {
          final Map<String, dynamic> parseData = jsonDecode(value as String);
          bool isOk = parseData['isOk'];
          if (isOk) {
            final GeoNormItemModel geoNormItemModel =
                GeoNormItemModel.fromJson(parseData['okResult']);
            if (geoNormItemModel.type == "C") {
              setState(() {
                cGeoNormItemModel = geoNormItemModel;
                geoNormItemModelVisible = true;
              });
            } else if (geoNormItemModel.type == "E") {
              onGeoNormExactModel(geoNormItemModel.exact);
              if (editMode) {
                result = giveNotifier
                    .updateStakeholder(
                        context: context,
                        token: authenticationNotifier.token,
                        mustForce: mustForce,
                        forcingId: forcingId,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        id: idSh,
                        nome: nameController.text,
                        cognome: surnameController.text,
                        ragSoc: ragSocController.text,
                        codfisc: cFController.text,
                        sesso: _characterGender != null
                            ? (_characterGender == GenderCharacter.male ? 1 : 2)
                            : null,
                        email: emailController.text,
                        tel: phoneNumberController.text,
                        cell: mobileNumberController.text,
                        nazione_nn_norm: countryController.text,
                        regione_nn_norm: regionController.text,
                        prov_nn_norm: provinceCodeController.text,
                        statoFederale_nn_norm: stateController.text,
                        cap_nn_norm: zipCodeController.text,
                        citta_nn_norm: cityController.text,
                        suddivisioneComune_2_nn_norm: district2Controller.text,
                        suddivisioneComune_3_nn_norm: district3Controller.text,
                        indirizzo_nn_norm: streetController.text,
                        localita_nn_norm: district1Controller.text,
                        n_civico_nn_norm: streetNumberController.text,
                        row4: geoNormItemModel.exact.row4,
                        row5: geoNormItemModel.exact.row5,
                        cdxcnl: geoNormItemModel.exact.cdxcnl,
                        x: geoNormItemModel.exact.x,
                        y: geoNormItemModel.exact.y,
                        com_cartacee: comCartacee ? 1 : 0,
                        com_email: comEmail ? 1 : 0,
                        consenso_ringrazia: consensoRingrazia ? 1 : 0,
                        consenso_materiale_info: consensoMaterialeInfo ? 1 : 0,
                        consenso_com_espresso: consensoComEspresso ? 1 : 0,
                        consenso_marketing: consensoMarketing ? 1 : 0,
                        consenso_sms: consensoSms ? 1 : 0,
                        datanascita: borndateController.text,
                        tipo_donatore:
                            _characterType == TypeCharacter.personaFisica
                                ? "1"
                                : "0")
                    .then((value) {
                  if (value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackUtil.stylishSnackBar(
                            title: "Anagrafiche",
                            message: "Errore di connessione",
                            contentType: "failure"));
                  } else {
                    var typedValue = value;
                    if (typedValue.operationResult == "Ok") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Anagrafiche",
                              message: "Informazioni aggiornate",
                              contentType: "success"));

                      GiveNotifier giveNotifier =
                          Provider.of<GiveNotifier>(context, listen: false);
                      giveNotifier.setStakeholder(typedValue.donatoriOk ??
                          StakeholderGiveModelSearch.empty());
                      Navigator.pop(context);
                    } else if (typedValue.operationResult ==
                        "Errore deduplica") {
                      if (forcingId > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackUtil.stylishSnackBar(
                                title: "Anagrafiche",
                                message: "Errore di connessione",
                                contentType: "failure"));
                      } else {
                        stakeholderDeduplicaResult =
                            typedValue.donatoriWithRulesDeduplica ??
                                List<StakeholderDeduplicaResult>.empty();
                        if (stakeholderDeduplicaResult.isNotEmpty) {
                          visibilityDeduplicationButton.value = true;
                          visibilityForceSaveButton.value = true;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackUtil.stylishSnackBar(
                                title: "Anagrafiche",
                                message:
                                    "Alcuni dati risultano già presenti. Azione necessaria",
                                contentType: "warning"));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Anagrafiche",
                              message:
                                  "Errore di connessione ${typedValue.operationResult.isNotEmpty ? "(${typedValue.operationResult})" : ""}",
                              contentType: "failure"));
                    }
                  }
                });
              } else {
                result = giveNotifier
                    .addStakeholder(
                  context: context,
                  token: authenticationNotifier.token,
                  mustForce: mustForce,
                  idUserAppInstitution:
                      cUserAppInstitutionModel.idUserAppInstitution,
                  nome: nameController.text,
                  cognome: surnameController.text,
                  ragSoc: ragSocController.text,
                  codfisc: cFController.text,
                  sesso: _characterGender != null
                      ? (_characterGender == GenderCharacter.male ? 1 : 2)
                      : null,
                  email: emailController.text,
                  tel: phoneNumberController.text,
                  cell: mobileNumberController.text,
                  nazione_nn_norm: countryController.text,
                  regione_nn_norm: regionController.text,
                  statoFederale_nn_norm: stateController.text,
                  prov_nn_norm: provinceCodeController.text,
                  cap_nn_norm: zipCodeController.text,
                  citta_nn_norm: cityController.text,
                  suddivisioneComune_2_nn_norm: district2Controller.text,
                  suddivisioneComune_3_nn_norm: district3Controller.text,
                  indirizzo_nn_norm: streetController.text,
                  localita_nn_norm: district1Controller.text,
                  n_civico_nn_norm: streetNumberController.text,
                  row4: geoNormItemModel.exact.row4,
                  row5: geoNormItemModel.exact.row5,
                  cdxcnl: geoNormItemModel.exact.cdxcnl,
                  x: geoNormItemModel.exact.x,
                  y: geoNormItemModel.exact.y,
                  com_cartacee: comCartacee ? 1 : 0,
                  com_email: comEmail ? 1 : 0,
                  consenso_ringrazia: consensoRingrazia ? 1 : 0,
                  consenso_materiale_info: consensoMaterialeInfo ? 1 : 0,
                  consenso_com_espresso: consensoComEspresso ? 1 : 0,
                  consenso_marketing: consensoMarketing ? 1 : 0,
                  consenso_sms: consensoSms ? 1 : 0,
                  datanascita: borndateController.text,
                  tipo_donatore: _characterGender != null
                      ? (_characterGender == TypeCharacter.personaFisica
                          ? 1
                          : 2)
                      : null,
                )
                    .then((value) {
                  if (value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackUtil.stylishSnackBar(
                            title: "Anagrafiche",
                            message: "Errore di connessione",
                            contentType: "failure"));
                  } else {
                    var typedValue = value;
                    if (typedValue.operationResult == "Ok") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Anagrafiche",
                              message: "Informazioni aggiornate",
                              contentType: "success"));

                      GiveNotifier giveNotifier =
                          Provider.of<GiveNotifier>(context, listen: false);
                      giveNotifier.setStakeholder(typedValue.donatoriOk ??
                          StakeholderGiveModelSearch.empty());
                      Navigator.pop(context);
                      // PersistentNavBarNavigator.pushNewScreen(
                      //   context,
                      //   screen: const ShManageScreen(),
                      //   withNavBar: true,
                      //   pageTransitionAnimation: PageTransitionAnimation.fade,
                      // );
                    } else if (typedValue.operationResult ==
                        "Errore deduplica") {
                      if (forcingId > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackUtil.stylishSnackBar(
                                title: "Anagrafiche",
                                message: "Errore di connessione",
                                contentType: "failure"));
                      } else {
                        stakeholderDeduplicaResult =
                            typedValue.donatoriWithRulesDeduplica ??
                                List<StakeholderDeduplicaResult>.empty();

                        visibilityDeduplicationButton.value = true;
                        visibilityForceSaveButton.value = true;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackUtil.stylishSnackBar(
                                title: "Anagrafiche",
                                message:
                                    "Alcuni dati risultano già presenti. Azione necessaria",
                                contentType: "warning"));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Anagrafiche",
                              message: "Errore di connessione",
                              contentType: "failure"));
                    }
                  }
                });
              }
            }
          } else {
            String errorDescription = parseData['errorDescription'];
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Anagrafiche",
                    message: errorDescription,
                    contentType: "failure"));
          }
        });
      } else {
        if (editMode) {
          result = giveNotifier
              .updateStakeholder(
                  context: context,
                  token: authenticationNotifier.token,
                  mustForce: mustForce,
                  forcingId: forcingId,
                  idUserAppInstitution:
                      cUserAppInstitutionModel.idUserAppInstitution,
                  id: idSh,
                  nome: nameController.text,
                  cognome: surnameController.text,
                  ragSoc: ragSocController.text,
                  codfisc: cFController.text,
                  sesso: _characterGender != null
                      ? (_characterGender == GenderCharacter.male ? 1 : 2)
                      : null,
                  email: emailController.text,
                  tel: phoneNumberController.text,
                  cell: mobileNumberController.text,
                  nazione_nn_norm: countryController.text,
                  regione_nn_norm: regionController.text,
                  prov_nn_norm: provinceCodeController.text,
                  statoFederale_nn_norm: stateController.text,
                  cap_nn_norm: zipCodeController.text,
                  citta_nn_norm: cityController.text,
                  suddivisioneComune_2_nn_norm: district2Controller.text,
                  suddivisioneComune_3_nn_norm: district3Controller.text,
                  indirizzo_nn_norm: streetController.text,
                  localita_nn_norm: district1Controller.text,
                  n_civico_nn_norm: streetNumberController.text,
                  row4: '',
                  row5: '',
                  cdxcnl: '',
                  x: '',
                  y: '',
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
            if (value == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      title: "Anagrafiche",
                      message: "Errore di connessione",
                      contentType: "failure"));
            } else {
              var typedValue = value;
              if (typedValue.operationResult == "Ok") {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackUtil.stylishSnackBar(
                        title: "Anagrafiche",
                        message: "Informazioni aggiornate",
                        contentType: "success"));

                GiveNotifier giveNotifier =
                    Provider.of<GiveNotifier>(context, listen: false);
                giveNotifier.setStakeholder(typedValue.donatoriOk ??
                    StakeholderGiveModelSearch.empty());
                Navigator.pop(context);
              } else if (typedValue.operationResult == "Errore deduplica") {
                if (forcingId > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                          title: "Anagrafiche",
                          message: "Errore di connessione",
                          contentType: "failure"));
                } else {
                  stakeholderDeduplicaResult =
                      typedValue.donatoriWithRulesDeduplica ??
                          List<StakeholderDeduplicaResult>.empty();
                  if (stakeholderDeduplicaResult.isNotEmpty) {
                    visibilityDeduplicationButton.value = true;
                    visibilityForceSaveButton.value = true;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                          title: "Anagrafiche",
                          message:
                              "Alcuni dati risultano già presenti. Azione necessaria",
                          contentType: "warning"));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackUtil.stylishSnackBar(
                        title: "Anagrafiche",
                        message:
                            "Errore di connessione ${typedValue.operationResult.isNotEmpty ? "(${typedValue.operationResult})" : ""}",
                        contentType: "failure"));
              }
            }
          });
        } else {
          result = giveNotifier
              .addStakeholder(
                  context: context,
                  token: authenticationNotifier.token,
                  mustForce: mustForce,
                  idUserAppInstitution:
                      cUserAppInstitutionModel.idUserAppInstitution,
                  nome: nameController.text,
                  cognome: surnameController.text,
                  ragSoc: ragSocController.text,
                  codfisc: cFController.text,
                  sesso: _characterGender != null
                      ? (_characterGender == GenderCharacter.male ? 1 : 2)
                      : null,
                  email: emailController.text,
                  tel: phoneNumberController.text,
                  cell: mobileNumberController.text,
                  nazione_nn_norm: countryController.text,
                  regione_nn_norm: regionController.text,
                  statoFederale_nn_norm: stateController.text,
                  prov_nn_norm: provinceCodeController.text,
                  cap_nn_norm: zipCodeController.text,
                  citta_nn_norm: cityController.text,
                  suddivisioneComune_2_nn_norm: district2Controller.text,
                  suddivisioneComune_3_nn_norm: district3Controller.text,
                  indirizzo_nn_norm: streetController.text,
                  localita_nn_norm: district1Controller.text,
                  n_civico_nn_norm: streetNumberController.text,
                  row4: '',
                  row5: '',
                  cdxcnl: '',
                  x: '',
                  y: '',
                  com_cartacee: comCartacee ? 1 : 0,
                  com_email: comEmail ? 1 : 0,
                  consenso_ringrazia: consensoRingrazia ? 1 : 0,
                  consenso_materiale_info: consensoMaterialeInfo ? 1 : 0,
                  consenso_com_espresso: consensoComEspresso ? 1 : 0,
                  consenso_marketing: consensoMarketing ? 1 : 0,
                  consenso_sms: consensoSms ? 1 : 0,
                  datanascita: borndateController.text,
                  tipo_donatore: _characterGender != null
                      ? (_characterGender == TypeCharacter.personaFisica
                          ? 1
                          : 2)
                      : null)
              .then((value) {
            if (value == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      title: "Anagrafiche",
                      message: "Errore di connessione",
                      contentType: "failure"));
            } else {
              var typedValue = value;
              if (typedValue.operationResult == "Ok") {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackUtil.stylishSnackBar(
                        title: "Anagrafiche",
                        message: "Informazioni aggiornate",
                        contentType: "success"));

                GiveNotifier giveNotifier =
                    Provider.of<GiveNotifier>(context, listen: false);
                giveNotifier.setStakeholder(typedValue.donatoriOk ??
                    StakeholderGiveModelSearch.empty());
                Navigator.pop(context);
                // PersistentNavBarNavigator.pushNewScreen(
                //   context,
                //   screen: const ShManageScreen(),
                //   withNavBar: true,
                //   pageTransitionAnimation: PageTransitionAnimation.fade,
                // );
              } else if (typedValue.operationResult == "Errore deduplica") {
                if (forcingId > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                          title: "Anagrafiche",
                          message: "Errore di connessione",
                          contentType: "failure"));
                } else {
                  stakeholderDeduplicaResult =
                      typedValue.donatoriWithRulesDeduplica ??
                          List<StakeholderDeduplicaResult>.empty();

                  visibilityDeduplicationButton.value = true;
                  visibilityForceSaveButton.value = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                          title: "Anagrafiche",
                          message:
                              "Alcuni dati risultano già presenti. Azione necessaria",
                          contentType: "warning"));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackUtil.stylishSnackBar(
                        title: "Anagrafiche",
                        message: "Errore di connessione",
                        contentType: "failure"));
              }
            }
          });
        }
      }
    }
    return result;
  }

  void stakeholderDeduplicaSelected(StakeholderGiveModelSearch? val) {
    if (val != null) {
      String ragSocialeONomeCognome = val.ragionesociale.isNotEmpty
          ? val.ragionesociale
          : "${val.nome} ${val.cognome}";
      onDeduplicaSelectedStakeholderGiveModelSearch = val;
      showModalBottomSheet(
        // backgroundColor: Colors.red,
        useSafeArea: true,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Anagrafica di $ragSocialeONomeCognome (id: : ${val.id})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: Text('Aggiorna con i dati appena inseriti',
                    style: Theme.of(context).textTheme.titleSmall),
                onTap: () {
                  GiveNotifier giveNotifier =
                      Provider.of<GiveNotifier>(context, listen: false);
                  giveNotifier.setStakeholder(
                      onDeduplicaSelectedStakeholderGiveModelSearch ??
                          StakeholderGiveModelSearch.empty());

                  Navigator.pop(context);
                  createSh(
                      onDeduplicaSelectedStakeholderGiveModelSearch?.id ?? 0,
                      true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: Text('Utilizza senza aggiornare',
                    style: Theme.of(context).textTheme.titleSmall),
                onTap: () {
                  GiveNotifier giveNotifier =
                      Provider.of<GiveNotifier>(context, listen: false);
                  giveNotifier.setStakeholder(
                      onDeduplicaSelectedStakeholderGiveModelSearch ??
                          StakeholderGiveModelSearch.empty());
                  Navigator.pop(context);
                  Navigator.of(context)
                      .pushNamed(AppRouter.shManage, arguments: widget.idCart);
                  // PersistentNavBarNavigator.pushNewScreen(
                  //   context,
                  //   screen: const ShManageScreen(),
                  //   withNavBar: true,
                  //   pageTransitionAnimation: PageTransitionAnimation.fade,
                  // );
                },
              ),
              ListTile(
                leading: const Icon(Icons.undo),
                title: Text('Annulla',
                    style: Theme.of(context).textTheme.titleSmall),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const ListTile(
                title: Text(''),
              ),
            ],
          );
        },
      );
    }
  }

  void onChangeField() {
    _formKey.currentState?.validate();
  }

  void onFullAddressSelected(GeoFullAddressItemModel geoFullAddressItemModel) {
    setState(() {
      enableNormalization = true;
    });
    cGeoFullAddressItemModel = geoFullAddressItemModel;
    countryController.text = cGeoFullAddressItemModel.countryEn;
    stateController.text = cGeoFullAddressItemModel.state;
    regionController.text = cGeoFullAddressItemModel.region;
    provinceCodeController.text = cGeoFullAddressItemModel.provinceCode;
    cityController.text = cGeoFullAddressItemModel.city;

    district1Controller.text = cGeoFullAddressItemModel.district1;
    district2Controller.text = cGeoFullAddressItemModel.district2;
    district3Controller.text = cGeoFullAddressItemModel.district3;

    zipCodeController.text = cGeoFullAddressItemModel.zipcode;
    streetController.text = cGeoFullAddressItemModel.street;
    streetNumberController.text = cGeoFullAddressItemModel.numberAndExponent;
    cGeoCountryItemModel = GeoCountryItemModel.fromFullAddressItem(
        geoFullAddressItemModel, geoFullAddressItemModelList);

    countryController.text = cGeoCountryItemModel.countryEn;
    // onChangeField();
  }

  void onCountrySelected(GeoCountryItemModel geoCountryItemModel) {
    var tGeoFullAddressItemModel = GeoFullAddressItemModel.empty();
    tGeoFullAddressItemModel.iso3 = geoCountryItemModel.iso3;
    tGeoFullAddressItemModel.countryEn = geoCountryItemModel.countryEn;
    fullAddressController.text = '';
    onFullAddressSelected(tGeoFullAddressItemModel);
    setState(() {});
  }

  void onCitySelected(GeoCityItemModel geoCityItemModel) {
    setState(() {
      cGeoCityItemModel = geoCityItemModel;
    });
    regionController.text = geoCityItemModel.region;
    provinceCodeController.text = geoCityItemModel.province;
  }

  void onStreetSelected(GeoStreetItemModel geoStreetItemModel) {
    setState(() {});
  }

  void onGeoNormCandidateModel(GeoNormCandidateModel? cGeoNormCandidateModel) {
    if (cGeoNormCandidateModel != null) {
      regionController.text = cGeoNormCandidateModel.candidateRegion;
      provinceCodeController.text = cGeoNormCandidateModel.candidateProvince;
      cityController.text = cGeoNormCandidateModel.candidateCity;
      district1Controller.text = cGeoNormCandidateModel.candidateDistrict;
      zipCodeController.text = cGeoNormCandidateModel.candidateZipcode;
      streetController.text = cGeoNormCandidateModel.candidateStreet;
    }
  }

  void onGeoNormExactModel(GeoNormExactModel? cGeoNormExactModel) {
    if (cGeoNormExactModel != null) {
      countryController.text = cGeoNormExactModel.country;
      stateController.text = cGeoNormExactModel.state;
      regionController.text = cGeoNormExactModel.region;
      provinceCodeController.text = cGeoNormExactModel.provinceSigle;
      district1Controller.text = cGeoNormExactModel.district1;
      district2Controller.text = cGeoNormExactModel.district2;
      district3Controller.text = cGeoNormExactModel.district3;
      cityController.text = cGeoNormExactModel.city;
      streetController.text = cGeoNormExactModel.address;
      streetNumberController.text = cGeoNormExactModel.houseNumberAndExponent;
      zipCodeController.text = cGeoNormExactModel.zipCode;
    }
  }

  Future? getGeoSuggestionByAddressNumber(String query) async {
    // AuthenticationNotifier authenticationNotifier =
    //     Provider.of<AuthenticationNotifier>(context, listen: false);
    // UserAppInstitutionModel cUserAppInstitutionModel =
    //     authenticationNotifier.getSelectedUserAppInstitution();
    //cGeoModel.cap = zipCodeController.text;
    // cGeoModel.city = cityController.text;
    // cGeoModel.province = provinceCodeController.text;
    // // cGeoModel.state = stateController.text;
    // cGeoModel.street = streetController.text;
    //cGeoModel.streetNumber = streetNumberController.text;

    // var response = await GeoAutocompleteAPI.getGeoSuggestion(
    //     token: authenticationNotifier.token,
    //     idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
    //     typeRequest: "GetGeoCoords",
    //     geoModel: cGeoModel,
    //     query: query);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          (widget.editStakeholderGiveModelSearch == null ||
                  widget.editStakeholderGiveModelSearch!.id == 0)
              ? "Nuova anagrafica"
              : "Modifica anagrafica (id: ${widget.editStakeholderGiveModelSearch?.id})",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController, // Attach to the outer scroll view
        child: Column(
          children: [
            Form(
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
                                                          color:
                                                              Colors.blueGrey),
                                                ),
                                                leading: Radio<TypeCharacter>(
                                                  fillColor: MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.blueAccent),
                                                  focusColor: MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.blueAccent),
                                                  value: TypeCharacter
                                                      .personaFisica,
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
                                                          color:
                                                              Colors.blueGrey),
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
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: CustomTextFormField(
                                                controller: nameController,
                                                validator: (value) =>
                                                    value!.toString().isEmpty
                                                        ? "Inserire il nome"
                                                        : null,
                                                // onChanged: (_) =>
                                                //     onChangeField(),
                                                labelText: 'Nome',
                                                hintText: "Nome"),
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
                                            child: CustomTextFormField(
                                                controller: surnameController,
                                                validator: (value) =>
                                                    value!.toString().isEmpty
                                                        ? "Inserire il cognome"
                                                        : null,
                                                // onChanged: (_) =>
                                                //     onChangeField(),
                                                labelText: 'Cognome',
                                                hintText: "Cognome"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        _characterType == TypeCharacter.ente,
                                    child: Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: CustomTextFormField(
                                                controller: ragSocController,
                                                validator: (value) => value!
                                                        .toString()
                                                        .isEmpty
                                                    ? "Inserire la ragione sociale"
                                                    : null,
                                                // onChanged: (_) =>
                                                //     onChangeField(),
                                                labelText: 'Ragione sociale',
                                                hintText: "Ragione sociale"),
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
                                          child: CustomTextFormField(
                                              controller: borndateController,
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                              // validator: (value) {
                                              //   if (value!.isEmpty &&
                                              //       _characterType ==
                                              //           TypeCharacter
                                              //               .personaFisica) {
                                              //     return 'Inserire la data di nascita';
                                              //   }
                                              //   return null;
                                              // },
                                              // onChanged: (_) => onChangeField(),
                                              labelText: 'Data di nascita',
                                              hintText: "Data di nascita"),
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
                                                            color: Colors
                                                                .blueGrey),
                                                  ),
                                                  leading:
                                                      Radio<GenderCharacter>(
                                                    fillColor: MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.blueAccent),
                                                    focusColor: MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.blueAccent),
                                                    value: GenderCharacter.male,
                                                    groupValue:
                                                        _characterGender,
                                                    onChanged: (GenderCharacter?
                                                        value) {
                                                      setState(() {
                                                        _characterGender =
                                                            value ??
                                                                GenderCharacter
                                                                    .male;
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
                                                            color: Colors
                                                                .blueGrey),
                                                  ),
                                                  leading:
                                                      Radio<GenderCharacter>(
                                                    fillColor: MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.blueAccent),
                                                    focusColor: MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.blueAccent),
                                                    value:
                                                        GenderCharacter.female,
                                                    groupValue:
                                                        _characterGender,
                                                    onChanged: (GenderCharacter?
                                                        value) {
                                                      setState(() {
                                                        _characterGender =
                                                            value ??
                                                                GenderCharacter
                                                                    .female;
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
                                          child: CustomTextFormField(
                                              controller: cFController,
                                              // validator: (value) => value!
                                              //         .toString()
                                              //         .isEmpty
                                              //     ? "Inserire il codice fiscale"
                                              //     : null,
                                              // onChanged: (_) => onChangeField(),
                                              labelText: 'Codice fiscale',
                                              hintText: "Codice fiscale"),
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
                                          child: CustomTextFormField(
                                              controller: emailController,
                                              validator: (value) {
                                                const pattern =
                                                    r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                                                final regExp = RegExp(pattern);
                                                if (phoneNumberController
                                                    .text.isNotEmpty) {
                                                  return null;
                                                }
                                                if (value!.isEmpty) {
                                                  return "Inserire Email";
                                                } else if (!regExp
                                                    .hasMatch(value)) {
                                                  return 'Email non valida';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              // onChanged: (_) => onChangeField(),
                                              labelText: 'Email',
                                              hintText: "Email"),
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
                                          child: CustomTextFormField(
                                              controller: phoneNumberController,
                                              validator: (value) {
                                                // const pattern =
                                                //     r'(^(?:[+0])?[0-9]{12}$)';
                                                const pattern = r'\d+';
                                                final regExp = RegExp(pattern);

                                                if (emailController
                                                    .text.isNotEmpty) {
                                                  return null;
                                                }
                                                if (value!.isEmpty) {
                                                  return "inserisci il numero di telefono";
                                                } else if (!regExp
                                                    .hasMatch(value)) {
                                                  return 'inserisci un numero di telefono valido';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              // onChanged: (_) => onChangeField(),
                                              labelText: 'Numero di telefono',
                                              hintText: "Numero di telefono"),
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
                                          child: CustomTextFormField(
                                              controller:
                                                  mobileNumberController,
                                              // validator: (value) {
                                              //   const pattern =
                                              //       r'(^(?:[+0])?[0-9]{12}$)';
                                              //   final regExp = RegExp(pattern);

                                              //   if (value!.isEmpty) {
                                              //     return "inserisci il numero di cellulare";
                                              //   } else if (!regExp
                                              //       .hasMatch(value)) {
                                              //     return 'inserisci un numero di cellulare valido';
                                              //   } else {
                                              //     return null;
                                              //   }
                                              // },
                                              // onChanged: (_) => onChangeField(),
                                              labelText: 'Numero di cellulare',
                                              hintText: "Numero di cellulare"),
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
                                          child: FullAddressAutocomplete(
                                            focusNode: FocusNode(),
                                            cTextEditingController:
                                                fullAddressController,
                                            enabled: stepValidation >= 0,
                                            // onChanged: (String value) {
                                            //     cGeoModel.city = value;
                                            //    onChangeField();
                                            // },
                                            onValueSelected: (option) =>
                                                onFullAddressSelected(option),
                                            hintText: 'Recupera indirizzo',
                                            labelText: 'Recupera indirizzo',
                                          ),
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
                                    visible:
                                        cGeoCountryItemModel.cityVisibility,
                                    child: Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 10),
                                            child: CityAutocomplete(
                                              focusNode: FocusNode(),
                                              cTextEditingController:
                                                  cityController,
                                              enabled: stepValidation >= 0,
                                              country: cGeoCountryItemModel
                                                  .iso3, // onChanged: (String value) {
                                              //   cityController.text = value;
                                              //   onChangeField();
                                              // },
                                              onValueSelected: (option) {
                                                //cityController.text = option.city;
                                                onCitySelected(option);
                                              },
                                              hintText: 'Comune',
                                              labelText: 'Comune',
                                              // validator: (value) =>
                                              //     value!.toString().isEmpty
                                              //         ? "inserire il comune"
                                              //         : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                          child: StreetAutocomplete(
                                            focusNode: FocusNode(),
                                            cTextEditingController:
                                                streetController,
                                            enabled: stepValidation >= 0,
                                            country: cGeoCountryItemModel.iso3,
                                            city: cityController.text,
                                            // onChanged: (String value) {
                                            //   cityController.text = value;
                                            //   onChangeField();
                                            // },
                                            onValueSelected: (option) {
                                              //cityController.text = option.city;
                                              onStreetSelected(option);
                                            },
                                            hintText: 'Indirizzo',
                                            labelText: 'Indirizzo',
                                            // validator: (value) =>
                                            //     value!.toString().isEmpty
                                            //         ? "inserire l'indirizzo"
                                            //         : null,
                                          ),
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
                                          child: CustomTextFormField(
                                              enabled: stepValidation >= 0,
                                              controller:
                                                  streetNumberController,
                                              // validator: (value) => value!
                                              //         .toString()
                                              //         .isEmpty
                                              //     ? "Inserire il numero civico"
                                              //     : null,
                                              onChanged: (String value) {
                                                if (_timer?.isActive ?? false) {
                                                  _timer!.cancel();
                                                }
                                                _timer = Timer(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  getGeoSuggestionByAddressNumber(
                                                      streetNumberController
                                                          .text);
                                                });
                                              },
                                              // onChanged: (_) => _formKey
                                              //     .currentState
                                              //     ?.validate(),
                                              labelText: 'Numero civico',
                                              hintText: "Numero civico"),
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
                                    visible:
                                        cGeoCountryItemModel.stateVisibility,
                                    child: Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 10),
                                            child: CustomTextFormField(
                                                enabled: false,
                                                controller: stateController,
                                                // validator: (value) =>
                                                //     value!.toString().isEmpty
                                                //         ? "Inserire la provincia"
                                                //         : null,
                                                // onChanged: (String value) {

                                                // },
                                                labelText: 'Stato',
                                                hintText: "Stato"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible:
                                          cGeoCountryItemModel.regionVisibility,
                                      child: Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: CustomTextFormField(
                                                  enabled: false,
                                                  controller: regionController,
                                                  // validator: (value) =>
                                                  //     value!.toString().isEmpty
                                                  //         ? "Inserire la provincia"
                                                  //         : null,
                                                  // onChanged: (String value) {

                                                  // },
                                                  labelText: 'Regione',
                                                  hintText: "Regione"),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: cGeoCountryItemModel
                                          .provinceVisibility,
                                      child: Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: CustomTextFormField(
                                                  enabled: false,
                                                  controller:
                                                      provinceCodeController,
                                                  // validator: (value) =>
                                                  //     value!.toString().isEmpty
                                                  //         ? "Inserire la provincia"
                                                  //         : null,
                                                  // onChanged: (String value) {

                                                  // },
                                                  labelText: 'Provincia',
                                                  hintText: "provincia"),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: cGeoCountryItemModel
                                          .district1Visibility,
                                      child: Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: CustomTextFormField(
                                                  enabled: false,
                                                  controller:
                                                      district1Controller,
                                                  // validator: (value) =>
                                                  //     value!.toString().isEmpty
                                                  //         ? "Inserire la provincia"
                                                  //         : null,
                                                  // onChanged: (String value) {

                                                  // },
                                                  labelText: 'Distretto 1',
                                                  hintText: "Distretto 1"),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: cGeoCountryItemModel
                                          .district2Visibility,
                                      child: Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: CustomTextFormField(
                                                  enabled: false,
                                                  controller:
                                                      district2Controller,
                                                  // validator: (value) =>
                                                  //     value!.toString().isEmpty
                                                  //         ? "Inserire la provincia"
                                                  //         : null,
                                                  // onChanged: (String value) {

                                                  // },
                                                  labelText: 'Distretto 2',
                                                  hintText: "Distretto 2"),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: cGeoCountryItemModel
                                          .district3Visibility,
                                      child: Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: CustomTextFormField(
                                                  enabled: false,
                                                  controller:
                                                      district3Controller,
                                                  // validator: (value) =>
                                                  //     value!.toString().isEmpty
                                                  //         ? "Inserire la provincia"
                                                  //         : null,
                                                  // onChanged: (String value) {

                                                  // },
                                                  labelText: 'Distretto 3',
                                                  hintText: "Distretto 3"),
                                            ),
                                          ],
                                        ),
                                      )),
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
                                          child: CustomTextFormField(
                                              enabled: true,
                                              controller: zipCodeController,
                                              // validator: (value) {
                                              //   const pattern = r'(^[0-9]{5}$)';
                                              //   final regExp = RegExp(pattern);

                                              //   if (value!.isEmpty) {
                                              //     return "Inserire il codice postale";
                                              //   } else if (!regExp
                                              //       .hasMatch(value)) {
                                              //     return 'Codice postale non valido';
                                              //   } else {
                                              //     return null;
                                              //   }
                                              // },
                                              // onChanged: (_) => onChangeField(),
                                              labelText: 'Codice postale',
                                              hintText: "Codice postale"),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                          child: CountryAutocomplete(
                                            data: geoFullAddressItemModelList,
                                            focusNode: FocusNode(),
                                            cTextEditingController:
                                                countryController,
                                            enabled: stepValidation >= 0,
                                            // onChanged: (String value) {
                                            //   onChangeField();
                                            // },
                                            onValueSelected: (option) =>
                                                onCountrySelected(option),
                                            hintText: 'Nazione',
                                            labelText: 'Nazione',
                                            validator: (value) =>
                                                value!.toString().isEmpty
                                                    ? "Inserire la nazione"
                                                    : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: geoNormItemModelVisible,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownMenu<GeoNormCandidateModel>(
                                        // initialSelection: selection,
                                        // controller: colorController,
                                        label: const Text(
                                            'Normalizzazione: recuperati più indirizzi, selezionarne uno:'),
                                        // onSelected: (val) => {callback(val)},
                                        onSelected: (GeoNormCandidateModel?
                                            cGeoNormCandidateModel) {
                                          onGeoNormCandidateModel(
                                              cGeoNormCandidateModel);
                                        },
                                        dropdownMenuEntries:
                                            cGeoNormItemModel.candidateList.map<
                                                    DropdownMenuEntry<
                                                        GeoNormCandidateModel>>(
                                                (GeoNormCandidateModel item) {
                                          return DropdownMenuEntry<
                                              GeoNormCandidateModel>(
                                            value: item,
                                            label: item.candidateItemDesc,
                                          );
                                        }).toList()),
                                  ],
                                ),
                              ),
                              CheckboxListTile(
                                  title: Text("Abilita normalizzazione"),
                                  value: enableNormalization,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      enableNormalization = value!;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading),
                              Row(
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      side: const BorderSide(
                                          color: Colors.blueAccent),
                                      checkColor: Colors.blueAccent,
                                      checkboxShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      activeColor: Colors.blueAccent,

                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: consensoRingrazia,

                                      onChanged: (bool? value) {
                                        setState(() {
                                          consensoRingrazia = value!;
                                        });
                                      },
                                      title:
                                          const Text("Consenso ringraziamenti"),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                      : const Center(child: Text('View non implementata'));
                },
              ),
            ),
            ValueListenableBuilder<bool>(
              builder: (BuildContext context, bool value, Widget? child) {
                return Visibility(
                  visible: value,
                  child: SizedBox(
                    height: 600, // Give an explicit height
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ShowGiveShDataTableDeduplica(
                        snapshot: stakeholderDeduplicaResult,
                        width: MediaQuery.of(context).size.width,
                        stakeholderDeduplicaSelected:
                            stakeholderDeduplicaSelected,
                      ),
                    ),
                  ),
                );
              },
              valueListenable: visibilityDeduplicationScreen,
            ),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          ValueListenableBuilder<bool>(
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: value,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: BlinkWidget(
                      interval: 1000,
                      children: [
                        FloatingActionButton(
                          // shape: const CircleBorder(eccentricity: 0.5),
                          tooltip: "Gestisci duplicati",
                          // heroTag: 'Deduplication1',
                          onPressed: () {
                            setState(() {
                              visibilityDeduplicationScreen.value = true;
                            });

                            // Wait a short duration to ensure the widget is rendered
                            Future.delayed(Duration(milliseconds: 300), () {
                              scrollController.animateTo(
                                scrollController.position
                                    .maxScrollExtent, // Scroll to the bottom
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          backgroundColor: Colors.red[900],
                          child: const Icon(Icons.warning),
                        ),
                        FloatingActionButton(
                          // shape: const CircleBorder(eccentricity: 0.5),
                          tooltip: "Gestisci duplicati",
                          // heroTag: 'Deduplication2',
                          onPressed: () {
                            setState(() {
                              visibilityDeduplicationScreen.value = true;
                            });
                            // Wait a short duration to ensure the widget is rendered
                            Future.delayed(Duration(milliseconds: 300), () {
                              scrollController.animateTo(
                                scrollController.position
                                    .maxScrollExtent, // Scroll to the bottom
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          backgroundColor: Colors.red[100],
                          child: const Icon(Icons.warning),
                        ),
                      ],
                    )),
              );
            },
            valueListenable: visibilityDeduplicationButton,
          ),
          ValueListenableBuilder<bool>(
            valueListenable:
                visibilitySaveButton, // Listen for visibility condition
            builder: (BuildContext context, bool visible, Widget? child) {
              return Visibility(
                visible:
                    visible, // Show/hide the button based on visibilitySaveButton value
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: ValueListenableBuilder<bool>(
                    valueListenable:
                        _isSavingNotifier, // Listen to the save state (whether it’s in progress)
                    builder:
                        (BuildContext context, bool isSaving, Widget? child) {
                      return FloatingActionButton(
                        shape: const CircleBorder(eccentricity: 0.5),
                        tooltip: "Salva", // Tooltip text for the save button
                        onPressed: isSaving
                            ? null // Disable button if saving is in progress
                            : () async {
                                visibilityDeduplicationButton.value = false;
                                visibilityForceSaveButton.value = false;
                                visibilityDeduplicationScreen.value = false;

                                _isSavingNotifier.value = true;

                                await createSh(0, false);
                                _isSavingNotifier.value = false;
                              },
                        backgroundColor: isSaving ? Colors.grey : Colors.green,
                        child: const Icon(Icons.save),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          ValueListenableBuilder<bool>(
            valueListenable: visibilityForceSaveButton,
            builder: (BuildContext context, bool visible, Widget? child) {
              return Visibility(
                visible:
                    visible, // Show/hide the button based on visibilityForceSaveButton
                child: ValueListenableBuilder<bool>(
                  valueListenable:
                      _isSavingNotifier, // For controlling the save state
                  builder:
                      (BuildContext context, bool isSaving, Widget? child) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        shape: const CircleBorder(eccentricity: 0.5),
                        tooltip: "Forza salvataggio",
                        onPressed: isSaving
                            ? null // Disable the button if saving is in progress
                            : () async {
                                _isSavingNotifier.value = true;
                                await createSh(idSh, true);
                                _isSavingNotifier.value = false;
                              },
                        backgroundColor:
                            isSaving ? Colors.grey : Colors.deepOrange,
                        child: const Icon(Icons.save),
                      ),
                    );
                  },
                ),
              );
            },
          )
          // Add more buttons here
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final f = DateFormat('dd-MM-yyyy');
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
                foregroundColor: Colors.blueAccent, // button text color
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

class BlinkWidget extends StatefulWidget {
  final List<Widget> children;
  final int interval;
  const BlinkWidget({required this.children, this.interval = 500, super.key});

  @override
  State<BlinkWidget> createState() => _BlinkWidgetState();
}

class _BlinkWidgetState extends State<BlinkWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentWidget = 0;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (++_currentWidget == widget.children.length) {
            _currentWidget = 0;
          }
        });

        _controller.forward(from: 0.0);
      }
    });

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.children[_currentWidget],
    );
  }
}
