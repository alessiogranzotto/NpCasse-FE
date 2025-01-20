import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/institution.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.institution.admin.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class InstitutionSettingScreen extends StatefulWidget {
  const InstitutionSettingScreen({super.key});
  @override
  State<InstitutionSettingScreen> createState() =>
      _InstitutionSettingScreenState();
}

class _InstitutionSettingScreenState extends State<InstitutionSettingScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  final ValueNotifier<bool> paymentMethodValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> stripeValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> securityFieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> casseModuleValidNotifier = ValueNotifier(true);

  late final TextEditingController idContantiController;
  late final TextEditingController idBancomatController;
  late final TextEditingController idCartaCreditoController;
  late final TextEditingController idAssegnoController;
  late final TextEditingController stripeApiKeyController;
  late TextEditingController tokenExpirationController =
      TextEditingController();
  late TextEditingController maxInactivityController = TextEditingController();
  List<DropdownMenuItem<String>> availableOtpMode = [
    DropdownMenuItem(child: Text("No"), value: "No"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];
  String valueOtpMode = 'No';
  bool institutionFiscalized = false;
  bool posAuthorization = false;

  List<bool> panelOpen = [false, false, false, false];
  bool isRefreshing = true; // Track if data is refreshing

  void initializeControllers() {
    idContantiController = TextEditingController()
      ..addListener(paymentMethodControllerListener);
    idBancomatController = TextEditingController()
      ..addListener(paymentMethodControllerListener);
    idCartaCreditoController = TextEditingController()
      ..addListener(paymentMethodControllerListener);
    idAssegnoController = TextEditingController()
      ..addListener(paymentMethodControllerListener);
    stripeApiKeyController = TextEditingController()
      ..addListener(stripeControllerListener);
    tokenExpirationController = TextEditingController()
      ..addListener(securityControllerListener);
    maxInactivityController = TextEditingController()
      ..addListener(securityControllerListener);
  }

  void disposeControllers() {
    idContantiController.dispose();
    idBancomatController.dispose();
    idCartaCreditoController.dispose();
    idAssegnoController.dispose();
    stripeApiKeyController.dispose();
    tokenExpirationController.dispose();
    maxInactivityController.dispose();
  }

  void paymentMethodControllerListener() {
    if (idContantiController.text.isEmpty ||
        idBancomatController.text.isEmpty ||
        idCartaCreditoController.text.isEmpty ||
        idAssegnoController.text.isEmpty) {
      paymentMethodValidNotifier.value = false;
    } else {
      paymentMethodValidNotifier.value = true;
    }
  }

  void stripeControllerListener() {
    if (stripeApiKeyController.text.isEmpty) {
      stripeValidNotifier.value = false;
    } else {
      stripeValidNotifier.value = true;
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

  Future<void> getInstitutionAttributes() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    InstitutionAttributeInstitutionAdminNotifier
        institutionAttributeInstitutionAdminNotifier =
        Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context,
            listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    await institutionAttributeInstitutionAdminNotifier
        .getInstitutionAttribute(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idInstitution:
                cUserAppInstitutionModel.idInstitutionNavigation.idInstitution)
        .then((value) {
      if (value != null) {
        List<InstitutionAttributeModel> cValue =
            value as List<InstitutionAttributeModel>;

        //ID PAYMENT
        var itemIdContanti = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Contanti')
            .firstOrNull;
        if (itemIdContanti != null) {
          idContantiController.text = itemIdContanti.attributeValue;
        }

        var itemIdBancomat = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Bancomat')
            .firstOrNull;
        if (itemIdBancomat != null) {
          idBancomatController.text = itemIdBancomat.attributeValue;
        }

        var itemIdCartaCredito = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.CartaCredito')
            .firstOrNull;
        if (itemIdCartaCredito != null) {
          idCartaCreditoController.text = itemIdCartaCredito.attributeValue;
        }

        var itemIdAssegno = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Assegni')
            .firstOrNull;
        if (itemIdAssegno != null) {
          idAssegnoController.text = itemIdAssegno.attributeValue;
        }

        //STRIPE
        var itemStripeApiKey = cValue
            .where((element) => element.attributeName == 'Stripe.ApiKey')
            .firstOrNull;
        if (itemStripeApiKey != null) {
          stripeApiKeyController.text = itemStripeApiKey.attributeValue;
        }

        //SECURITY
        var itemValueOtpMode = cValue
            .where((element) => element.attributeName == 'User.OtpMode')
            .firstOrNull;
        if (itemValueOtpMode != null) {
          valueOtpMode = itemValueOtpMode.attributeValue;
        }

        var itemTokenExpiration = cValue
            .where((element) => element.attributeName == 'User.TokenExpiration')
            .firstOrNull;
        if (itemTokenExpiration != null) {
          tokenExpirationController.text = itemTokenExpiration.attributeValue;
        }

        var itemMaxInactivity = cValue
            .where((element) => element.attributeName == 'User.MaxInactivity')
            .firstOrNull;
        if (itemMaxInactivity != null) {
          maxInactivityController.text = itemMaxInactivity.attributeValue;
        }

        //CASSE
        var itemInstitutionFiscalized = cValue
            .where(
                (element) => element.attributeName == 'Institution.Fiscalized')
            .firstOrNull;
        if (itemInstitutionFiscalized != null &&
            itemInstitutionFiscalized.attributeValue == "true") {
          institutionFiscalized = true;
        }

        var itemPosAuthorization = cValue
            .where((element) =>
                element.attributeName == 'Institution.PosAuthorization')
            .firstOrNull;
        if (itemPosAuthorization != null &&
            itemPosAuthorization.attributeValue == "true") {
          posAuthorization = true;
        }
      }
    });
  }

  updateInstitutionPaymentMethodData() {
    if (_formKey1.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      var institutionAttributeInstitutionAdminNotifier =
          Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context,
              listen: false);

      institutionAttributeInstitutionAdminNotifier
          .updateInstitutionPaymentMethodAttribute(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idInstitution: cUserAppInstitutionModel
                  .idInstitutionNavigation.idInstitution,
              idPaymentTypeContanti: int.parse(idContantiController.text),
              idPaymentTypeBancomat: int.parse(idBancomatController.text),
              idPaymentTypeCartaCredito:
                  int.parse(idCartaCreditoController.text),
              idPaymentTypeAssegni: int.parse(idAssegnoController.text))
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni ente",
                    message: "Metodi di pagamento aggiornati correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  updateInstitutionStripeData() {
    if (_formKey2.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      var institutionAttributeInstitutionAdminNotifier =
          Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context,
              listen: false);

      institutionAttributeInstitutionAdminNotifier
          .updateInstitutionStripeAttribute(
        context: context,
        token: authNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        stripeApiKey: stripeApiKeyController.text,
      )
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni ente",
                    message: "Parametri Stripe aggiornati correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  updateInstitutionSecurityData() {
    if (_formKey3.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      var institutionAttributeInstitutionAdminNotifier =
          Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context,
              listen: false);

      institutionAttributeInstitutionAdminNotifier
          .updateInstitutionSecurityAttribute(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idInstitution: cUserAppInstitutionModel
                  .idInstitutionNavigation.idInstitution,
              otpMode: valueOtpMode,
              tokenExpiration: int.parse(tokenExpirationController.text),
              maxInactivity: int.parse(maxInactivityController.text))
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni ente",
                    message: "Criteri di sicurezza aggiornati correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  updateCasseModuleData() {
    if (_formKey4.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      var institutionAttributeInstitutionAdminNotifier =
          Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context,
              listen: false);

      institutionAttributeInstitutionAdminNotifier
          .updateCasseModuleDataAttribute(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idInstitution: cUserAppInstitutionModel
                  .idInstitutionNavigation.idInstitution,
              institutionFiscalized: institutionFiscalized,
              posAuthorization: posAuthorization)
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni ente",
                    message: "Criteri modulo casse aggiornati correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InstitutionAttributeInstitutionAdminNotifier
        institutionAttributeInstitutionAdminNotifier =
        Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (institutionAttributeInstitutionAdminNotifier.isUpdated) {
      // Post-frame callback to avoid infinite loop during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        institutionAttributeInstitutionAdminNotifier
            .setUpdate(false); // Reset the update flag
        getInstitutionAttributes();
      });
    }
  }

  @override
  void initState() {
    initializeControllers();
    // getInstitutionAttributes();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Impostazioni ente ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution} ',
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
                          animationDuration: Duration(milliseconds: 500),
                          elevation: 1,
                          children: [
                            ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Metodi di pagamento Shop Casse'),
                                  leading: const Icon(Icons.payment_sharp),
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
                                          controller: idContantiController,
                                          labelText:
                                              AppStrings.IdPaymentTypeContanti,
                                          keyboardType: TextInputType.number,
                                          inputFormatter: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterIdPaymentTypeContanti;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: idBancomatController,
                                          labelText:
                                              AppStrings.IdPaymentTypeBancomat,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          inputFormatter: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterIdPaymentTypeBancomat;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: idCartaCreditoController,
                                          labelText: AppStrings
                                              .IdPaymentTypeCartaCredito,
                                          keyboardType: TextInputType.number,
                                          inputFormatter: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterIdPaymentTypeCartaCredito;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: idAssegnoController,
                                          labelText:
                                              AppStrings.IdPaymentTypeAssegno,
                                          keyboardType: TextInputType.number,
                                          inputFormatter: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterIdPaymentTypeAssegno;
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  paymentMethodValidNotifier,
                                              builder: (_, isValid, __) {
                                                return ElevatedButton(
                                                  onPressed: isValid
                                                      ? () {
                                                          updateInstitutionPaymentMethodData();
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
                                  title: Text('POS bancario'),
                                  leading: const Icon(Icons.extension_rounded),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CustomTextFormField(
                                          controller: stripeApiKeyController,
                                          labelText: AppStrings.stripeApiKey,
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => _formKey1
                                              .currentState
                                              ?.validate(),
                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterstripeApiKey;
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  stripeValidNotifier,
                                              builder: (_, isValid, __) {
                                                return ElevatedButton(
                                                  onPressed: isValid
                                                      ? () {
                                                          updateInstitutionStripeData();
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
                              isExpanded: panelOpen[1],
                            ),
                            ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Sicurezza utenti'),
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
                                                          updateInstitutionSecurityData();
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
                            ExpansionPanel(
                              canTapOnHeader: true,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Modulo casse'),
                                  leading: const Icon(Icons.receipt),
                                );
                              },
                              body: Form(
                                key: _formKey4,
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CheckboxListTile(
                                            title: Text("Ente fiscalizzato"),
                                            value: institutionFiscalized,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                institutionFiscalized = value!;
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .leading),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CheckboxListTile(
                                            title: Text(
                                                "Autorizza pagamento tramite POS"),
                                            value: posAuthorization,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                posAuthorization = value!;
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .leading),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ValueListenableBuilder(
                                              valueListenable:
                                                  casseModuleValidNotifier,
                                              builder: (_, isValid, __) {
                                                return ElevatedButton(
                                                  onPressed: isValid
                                                      ? () {
                                                          updateCasseModuleData();
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
                              isExpanded: panelOpen[3],
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
