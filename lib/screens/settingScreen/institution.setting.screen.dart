import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:np_casse/app/constants/functional.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/copyable.tooltip.dart';
import 'package:np_casse/componenents/custom.chips.input/custom.chips.input.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/institution.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/productCatalogScreen/product.autocomplete.dart';
import 'package:provider/provider.dart';
import 'package:string_similarity/string_similarity.dart';

class InstitutionSettingScreen extends StatefulWidget {
  const InstitutionSettingScreen({super.key});
  @override
  State<InstitutionSettingScreen> createState() =>
      _InstitutionSettingScreenState();
}

class _InstitutionSettingScreenState extends State<InstitutionSettingScreen> {
  bool isLoading = false;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  final ValueNotifier<bool> paymentMethodValidNotifier = ValueNotifier(true);
  final ValueNotifier<bool> stripeValidNotifier = ValueNotifier(true);
  final ValueNotifier<bool> securityFieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> casseModuleValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> parameterValidNotifier = ValueNotifier(true);

  late final TextEditingController stripeApiKeyPrivateController;
  late final TextEditingController stripeApiKeyPublicController;
  late final TextEditingController stripeIdConnectedAccountController;
  late final TextEditingController paypalClientIdController;
  late final TextEditingController parameterIdShAnonymousApiKeyController;
  late final TextEditingController preestablishedProductController;

  List<UserModelTeam> userModelTeam = List.empty();
  UserModelTeam? selectedUserModelTeam;
  ProductCatalogModel? predefinedProductSelected;

  late TextEditingController tokenExpirationController =
      TextEditingController();
  late TextEditingController maxInactivityController = TextEditingController();
  List<DropdownMenuItem<String>> availableOtpMode = [
    DropdownMenuItem(child: Text("No"), value: "No"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];
  String valueOtpMode = 'No';
  bool institutionFiscalized = false;
  late final TextEditingController institutionFiscalizationCfController;
  late final TextEditingController institutionFiscalizationPasswordController;
  late final TextEditingController institutionFiscalizationPinController;
  bool posAuthorization = false;

  List<bool> panelOpen = [false, false, false, false, false];
  bool isRefreshing = true;

  late List<String> customIdGive = [];
  Map<String, bool> paymentTypeVisibility = {};

  Widget chipBuilderCustomIdGive(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'customIdGive'),
      onSelected: (data) => onChipTapped(data, 'customIdGive'),
    );
  }

  void onChipTapped(String topping, String area) {}

  void onChipDeleted(String topping, String area) {
    setState(() {
      if (area == 'customIdGive') {
        customIdGive.remove(topping);
      }
    });
  }

  void onSubmitted(String text, String area) {
    if (area == 'customIdGive') {
      if (text.trim().isNotEmpty) {
        bool isOk = false;
        String input = text.trim();
        try {
          var splitOnEqual = input.split('=');

          //CONTROL FOR INT OR STRING
          bool canContinue = false;
          if (splitOnEqual.length == 2) {
            final bestMatch = StringSimilarity.findBestMatch(
                splitOnEqual[0].toLowerCase(), idGiveListNameCategory);

            if (bestMatch.bestMatch.rating != null) {
              if (bestMatch.bestMatch.rating! > 0.40) {
                String finalString =
                    bestMatch.bestMatch.target! + "=" + splitOnEqual[1];
                if (finalString.startsWith('Id') &&
                    num.tryParse(splitOnEqual[1]) != null) {
                  canContinue = true;
                } else if (finalString.startsWith('Codice') &&
                    splitOnEqual[1].isNotEmpty) {
                  canContinue = true;
                } else if (finalString.startsWith('FonteSh') &&
                    num.tryParse(splitOnEqual[1]) != null) {
                  canContinue = true;
                } else if (finalString.startsWith('Ringraziato') &&
                    ["0", "1"].contains(splitOnEqual[1])) {
                  canContinue = true;
                }
                if (canContinue) {
                  if (!customIdGive.any((item) => item
                      .toLowerCase()
                      .contains(bestMatch.bestMatch.target!.toLowerCase()))) {
                    setState(() {
                      customIdGive = <String>[...customIdGive, finalString];
                    });
                    isOk = true;
                  }
                }
              }
            }
          }

          if (!isOk) {
            ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                title: "Categorie",
                message:
                    "Parametro Id Give non trovato, non corretto o già presente",
                contentType: "warning"));
          }
        } catch (e) {}
      } else {
        // _chipFocusNode.unfocus();
        // setState(() {
        //   giveIds = <String>[];
        // });
      }
    }
  }

  void onChanged(List<String> data, String area) {
    setState(() {
      if (area == 'customIdGive') {
        customIdGive = data;
      }
    });
  }

  getIconByRole(String roleUserInstitution) {
    if (roleUserInstitution == "InstitutionAdmin") {
      return Icon(Icons.group);
    } else if (roleUserInstitution == "User") {
      return Icon(Icons.person);
    } else if (roleUserInstitution == "Admin") {
      return Icon(Icons.admin_panel_settings_outlined);
    }
  }

  void onPredefinedProductSelected(ProductCatalogModel option) {
    predefinedProductSelected = option;
  }

  void initializeControllers() {
    stripeApiKeyPrivateController = TextEditingController()
      ..addListener(stripeControllerListener);
    stripeApiKeyPublicController = TextEditingController()
      ..addListener(stripeControllerListener);
    stripeIdConnectedAccountController = TextEditingController()
      ..addListener(stripeControllerListener);
    paypalClientIdController = TextEditingController()
      ..addListener(paypalControllerListener);
    parameterIdShAnonymousApiKeyController = TextEditingController()
      ..addListener(parameterControllerListener);
    preestablishedProductController = TextEditingController()
      ..addListener(parameterControllerListener);

    tokenExpirationController = TextEditingController()
      ..addListener(securityControllerListener);
    maxInactivityController = TextEditingController()
      ..addListener(securityControllerListener);

    institutionFiscalizationCfController = TextEditingController()
      ..addListener(casseModuleControllerListener);
    institutionFiscalizationPasswordController = TextEditingController()
      ..addListener(casseModuleControllerListener);
    institutionFiscalizationPinController = TextEditingController()
      ..addListener(casseModuleControllerListener);
  }

  void disposeControllers() {
    stripeApiKeyPrivateController.dispose();
    stripeApiKeyPublicController.dispose();
    stripeIdConnectedAccountController.dispose();
    paypalClientIdController.dispose();
    tokenExpirationController.dispose();
    maxInactivityController.dispose();
    institutionFiscalizationCfController.dispose();
    institutionFiscalizationPasswordController.dispose();
    institutionFiscalizationPinController.dispose();
    parameterIdShAnonymousApiKeyController.dispose();
    preestablishedProductController.dispose();
  }

  void casseModuleControllerListener() {
    if (institutionFiscalized) {
      if (institutionFiscalizationCfController.text.isEmpty ||
          institutionFiscalizationPasswordController.text.isEmpty ||
          institutionFiscalizationPinController.text.isEmpty) {
        casseModuleValidNotifier.value = false;
      } else {
        casseModuleValidNotifier.value = true;
      }
    } else {
      casseModuleValidNotifier.value = true;
    }
  }

  void stripeControllerListener() {
    stripeValidNotifier.value = true;
  }

  void paypalControllerListener() {
    stripeValidNotifier.value = true;
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

  void parameterControllerListener() {
    parameterValidNotifier.value = true;
  }

  Future<void> getUserInstitution() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    InstitutionAttributeNotifier institutionAttributeNotifier =
        Provider.of<InstitutionAttributeNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    await institutionAttributeNotifier
        .getInstitutionUser(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idInstitution:
                cUserAppInstitutionModel.idInstitutionNavigation.idInstitution)
        .then((value) {
      if (value != null) {
        userModelTeam = value;
      }
    });
  }

  Future<void> getInstitutionAttributes() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    InstitutionAttributeNotifier institutionAttributeNotifier =
        Provider.of<InstitutionAttributeNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    await institutionAttributeNotifier
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
        customIdGive.clear();

        var itemIdContanti = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Contanti')
            .firstOrNull;
        if (itemIdContanti != null) {
          customIdGive
              .add("IdPagamentoContante=" + itemIdContanti.attributeValue);
        }

        var itemIdBancomat = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Bancomat')
            .firstOrNull;
        if (itemIdBancomat != null) {
          customIdGive
              .add("IdPagamentoBancomat=" + itemIdBancomat.attributeValue);
        }

        var itemIdCartaCredito = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.CartaCredito')
            .firstOrNull;
        if (itemIdCartaCredito != null) {
          customIdGive.add(
              "IdPagamentoCartaDiCredito=" + itemIdCartaCredito.attributeValue);
        }

        var itemIdAssegno = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Assegni')
            .firstOrNull;
        if (itemIdAssegno != null) {
          customIdGive
              .add("IdPagamentoAssegno=" + itemIdAssegno.attributeValue);
        }

        var itemIdPaypal = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Paypal')
            .firstOrNull;
        if (itemIdPaypal != null) {
          customIdGive.add("IdPagamentoPaypal=" + itemIdPaypal.attributeValue);
        }

        var itemIdSdd = cValue
            .where(
                (element) => element.attributeName == 'Give.IdPaymentType.Sdd')
            .firstOrNull;
        if (itemIdSdd != null) {
          customIdGive.add("IdPagamentoSdd=" + itemIdSdd.attributeValue);
        }

        var itemIdEsterno = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Esterno')
            .firstOrNull;
        if (itemIdEsterno != null) {
          customIdGive
              .add("IdPagamentoEsterno=" + itemIdEsterno.attributeValue);
        }
        var itemIdBonificoPromessa = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.BonificoPromessa')
            .firstOrNull;
        if (itemIdBonificoPromessa != null) {
          customIdGive.add("IdPagamentoBonificoPromessa=" +
              itemIdBonificoPromessa.attributeValue);
        }
        var itemIdBonificoIstantaneo = cValue
            .where((element) =>
                element.attributeName ==
                'Give.IdPaymentType.BonificoIstantaneo')
            .firstOrNull;
        if (itemIdBonificoIstantaneo != null) {
          customIdGive.add("IdPagamentoBonificoIstantaneo=" +
              itemIdBonificoIstantaneo.attributeValue);
        }

        var itemIdBonificoLink = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.BonificoLink')
            .firstOrNull;
        if (itemIdBonificoLink != null) {
          customIdGive.add(
              "IdPagamentoBonificoLink=" + itemIdBonificoLink.attributeValue);
        }
        var itemIdPaymentVisibility = cValue
            .where((element) =>
                element.attributeName == 'Give.IdPaymentType.Visibility')
            .firstOrNull;
        if (itemIdPaymentVisibility != null) {
          List<String> visiblePaymentmethod =
              itemIdPaymentVisibility.attributeValue.split(';');
          paymentTypeVisibility = {
            for (var key in idGivePaymentType)
              key: visiblePaymentmethod.contains(key)
          };
        }
        //STRIPE
        var itemStripeApiKeyPrivate = cValue
            .where((element) => element.attributeName == 'Stripe.ApiKeyPrivate')
            .firstOrNull;
        if (itemStripeApiKeyPrivate != null) {
          stripeApiKeyPrivateController.text =
              itemStripeApiKeyPrivate.attributeValue;
        }
        var itemStripeApiKeyPublic = cValue
            .where((element) => element.attributeName == 'Stripe.ApiKeyPublic')
            .firstOrNull;
        if (itemStripeApiKeyPublic != null) {
          stripeApiKeyPublicController.text =
              itemStripeApiKeyPublic.attributeValue;
        }
        var itemStripeIdConnectedAccount = cValue
            .where((element) =>
                element.attributeName == 'Stripe.IdConnectedAccount')
            .firstOrNull;
        if (itemStripeIdConnectedAccount != null) {
          stripeIdConnectedAccountController.text =
              itemStripeIdConnectedAccount.attributeValue;
        }

        //PAYPAL
        var itemPaypalApiKey = cValue
            .where((element) => element.attributeName == 'Paypal.ClientId')
            .firstOrNull;
        if (itemPaypalApiKey != null) {
          paypalClientIdController.text = itemPaypalApiKey.attributeValue;
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

        var itemInstitutionFiscalizationCf = cValue
            .where((element) =>
                element.attributeName == 'Institution.Fiscalization-Cf')
            .firstOrNull;
        if (itemInstitutionFiscalizationCf != null) {
          institutionFiscalizationCfController.text =
              itemInstitutionFiscalizationCf.attributeValue;
        }
        var itemInstitutionFiscalizationPassword = cValue
            .where((element) =>
                element.attributeName == 'Institution.Fiscalization-Password')
            .firstOrNull;
        if (itemInstitutionFiscalizationPassword != null) {
          institutionFiscalizationPasswordController.text =
              itemInstitutionFiscalizationPassword.attributeValue;
        }
        var itemInstitutionFiscalizationPin = cValue
            .where((element) =>
                element.attributeName == 'Institution.Fiscalization-Pin')
            .firstOrNull;
        if (itemInstitutionFiscalizationPin != null) {
          institutionFiscalizationPinController.text =
              itemInstitutionFiscalizationPin.attributeValue;
        }
        var itemPosAuthorization = cValue
            .where((element) =>
                element.attributeName == 'Institution.PosAuthorization')
            .firstOrNull;
        if (itemPosAuthorization != null &&
            itemPosAuthorization.attributeValue == "true") {
          posAuthorization = true;
        }

        //PARAMETER
        var itemParameterIdStakeholderAnonymous = cValue
            .where(
                (element) => element.attributeName == 'Parameter.IdShAnonymous')
            .firstOrNull;
        if (itemParameterIdStakeholderAnonymous != null) {
          parameterIdShAnonymousApiKeyController.text =
              itemParameterIdStakeholderAnonymous.attributeValue;
        }
        var itemEmailUserAuthMyosotis = cValue
            .where((element) =>
                element.attributeName == 'Parameter.EmailUserAuthMyosotis')
            .firstOrNull;

        if (itemEmailUserAuthMyosotis != null) {
          selectedUserModelTeam = userModelTeam.firstWhereOrNull(
            (element) =>
                element.email == itemEmailUserAuthMyosotis.attributeValue,
          );
        }

        var itemPredefinedProduct = cValue
            .where((element) =>
                element.attributeName == 'Parameter.PredefinedProduct')
            .firstOrNull;
        if (itemPredefinedProduct != null) {
          List<String> predefinedProductSplit =
              itemPredefinedProduct.attributeValue.split("*;*");

          String namePredefinedProduct = predefinedProductSplit.length > 1
              ? predefinedProductSplit[1]
              : "";

          preestablishedProductController.text = namePredefinedProduct;
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

      var institutionAttributeNotifier =
          Provider.of<InstitutionAttributeNotifier>(context, listen: false);
      int idPagamentoContante = 0;
      int idPagamentoBancomat = 0;
      int idPagamentoCartaDiCredito = 0;
      int idPagamentoAssegno = 0;
      int idPagamentoPaypal = 0;
      int idPagamentoEsterno = 0;
      int idPagamentoSdd = 0;
      int idPagamentoBonificoPromessa = 0;
      int idPagamentoBonificoIstantaneo = 0;
      int idPagamentoBonificoLink = 0;

      for (int i = 0; i < customIdGive.length; i++) {
        var split = customIdGive[i].split('=');
        if (split.length < 2) continue;

        var key = split[0];
        var value = int.tryParse(split[1]) ?? 0;
        if (value == 0) continue;
        switch (key) {
          case "IdPagamentoContante":
            idPagamentoContante = value;
            break;
          case "IdPagamentoBancomat":
            idPagamentoBancomat = value;
            break;
          case "IdPagamentoCartaDiCredito":
            idPagamentoCartaDiCredito = value;
            break;
          case "IdPagamentoAssegno":
            idPagamentoAssegno = value;
            break;
          case "IdPagamentoPaypal":
            idPagamentoPaypal = value;
            break;
          case "IdPagamentoEsterno":
            idPagamentoEsterno = value;
            break;
          case "IdPagamentoSdd":
            idPagamentoSdd = value;
            break;
          case "IdPagamentoBonificoPromessa":
            idPagamentoBonificoPromessa = value;
            break;
          case "IdPagamentoBonificoIstantaneo":
            idPagamentoBonificoIstantaneo = value;
            break;
          case "IdPagamentoBonificoLink":
            idPagamentoBonificoLink = value;
            break;
        }
      }
      String paymentTypeVisibilityString = paymentTypeVisibility.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .join(';');
      institutionAttributeNotifier
          .updateInstitutionPaymentMethodAttribute(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idInstitution: cUserAppInstitutionModel
                  .idInstitutionNavigation.idInstitution,
              idPaymentTypeContanti: idPagamentoContante,
              idPaymentTypeBancomat: idPagamentoBancomat,
              idPaymentTypeCartaCredito: idPagamentoCartaDiCredito,
              idPaymentTypeAssegni: idPagamentoAssegno,
              idPaymentTypePaypal: idPagamentoPaypal,
              idPaymentTypeEsterno: idPagamentoEsterno,
              iddPaymentTypeSdd: idPagamentoSdd,
              idPaymentTypeBonificoPromessa: idPagamentoBonificoPromessa,
              idPaymentTypeBonificoIstantaneo: idPagamentoBonificoIstantaneo,
              idPaymentTypeBonificoLink: idPagamentoBonificoLink,
              paymentTypeVisibility: paymentTypeVisibilityString)
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

      var institutionAttributeNotifier =
          Provider.of<InstitutionAttributeNotifier>(context, listen: false);

      institutionAttributeNotifier
          .updateInstitutionPosBancariAttribute(
        context: context,
        token: authNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        stripeApiKeyPrivate: stripeApiKeyPrivateController.text,
        stripeApiKeyPublic: stripeApiKeyPublicController.text,
        stripeIdConnectedAccount: stripeIdConnectedAccountController.text,
        paypalClientId: paypalClientIdController.text,
      )
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni ente",
                    message: "Parametri POS bancari aggiornati correttamente",
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

      var institutionAttributeNotifier =
          Provider.of<InstitutionAttributeNotifier>(context, listen: false);

      institutionAttributeNotifier
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

      var institutionAttributeNotifier =
          Provider.of<InstitutionAttributeNotifier>(context, listen: false);

      institutionAttributeNotifier
          .updateCasseModuleDataAttribute(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idInstitution: cUserAppInstitutionModel
                  .idInstitutionNavigation.idInstitution,
              institutionFiscalized: institutionFiscalized,
              institutionFiscalizationCf:
                  institutionFiscalizationCfController.text,
              institutionFiscalizationPassword:
                  institutionFiscalizationPasswordController.text,
              institutionFiscalizationPin:
                  institutionFiscalizationPinController.text,
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

  updateParameterData() {
    if (_formKey5.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      var institutionAttributeNotifier =
          Provider.of<InstitutionAttributeNotifier>(context, listen: false);
      String predefinedProductSelectedToSave = "";
      if (predefinedProductSelected != null) {
        predefinedProductSelectedToSave =
            predefinedProductSelected!.idProduct.toString() +
                "*;*" +
                predefinedProductSelected!.nameProduct.toString();
      }
      institutionAttributeNotifier
          .updateInstitutionParameterAttribute(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idInstitution: cUserAppInstitutionModel
                  .idInstitutionNavigation.idInstitution,
              parameterIdShAnonymous:
                  parameterIdShAnonymousApiKeyController.text,
              parameterEmailUserAuthMyosotis: selectedUserModelTeam != null
                  ? selectedUserModelTeam!.email
                  : "",
              predefinedProduct: predefinedProductSelectedToSave)
          .then((value) {
        if (value) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni ente",
                    message: "Parametri aggiornati correttamente",
                    contentType: "success"));
          }
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InstitutionAttributeNotifier institutionAttributeNotifier =
        Provider.of<InstitutionAttributeNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (institutionAttributeNotifier.isUpdated) {
      setState(() => isLoading = true);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Reset il flag prima di fare le chiamate
        institutionAttributeNotifier.setUpdate(false);
        await getUserInstitution();
        await getInstitutionAttributes();
        if (mounted) {
          setState(() => isLoading = false); // Nascondi loader
        }
      });
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
      body: isLoading
          ? const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.redAccent,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionPanelList.radio(
                    // expansionCallback: (int index, bool isExpanded) {
                    //   setState(() {
                    //     panelOpen[index] = isExpanded;
                    //   });
                    // },
                    animationDuration: Duration(milliseconds: 250),
                    elevation: 1,
                    children: [
                      ExpansionPanelRadio(
                        value: 0,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
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
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: CopyableTooltip(
                                        items: idGivePaymentType,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: ChipsInput<String>(
                                          values: customIdGive,
                                          label:
                                              AppStrings.giveIdsPaymentMethod,
                                          height: 140,
                                          decoration: const InputDecoration(),
                                          strutStyle:
                                              const StrutStyle(fontSize: 12),
                                          onChanged: (data) =>
                                              onChanged(data, 'customIdGive'),
                                          onSubmitted: (data) =>
                                              onSubmitted(data, 'customIdGive'),
                                          chipBuilder: chipBuilderCustomIdGive,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      // Container con bordo e padding
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 460,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.only(
                                                top:
                                                    12), // spazio per il titolo
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    height:
                                                        16), // margine superiore sotto il titolo
                                                // Row dei checkbox
                                                Row(
                                                  children: idGivePaymentType
                                                      .take(5)
                                                      .toList()
                                                      .map((key) {
                                                    final isEnabled =
                                                        customIdGive.any(
                                                            (chip) =>
                                                                chip.startsWith(
                                                                    "$key="));
                                                    if (!isEnabled) {
                                                      paymentTypeVisibility[
                                                          key] = false;
                                                    }
                                                    final checked =
                                                        paymentTypeVisibility[
                                                                key] ??
                                                            false;
                                                    final iconData =
                                                        paymentTypeInfo[key]
                                                                ?['icon']
                                                            as IconData?;
                                                    final tooltipText =
                                                        paymentTypeInfo[key]
                                                                    ?['tooltip']
                                                                as String? ??
                                                            key;

                                                    final Color activeColor =
                                                        isEnabled
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Colors.grey;
                                                    final Color iconColor =
                                                        isEnabled
                                                            ? Colors.black
                                                            : Colors.grey;

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 32,
                                                              bottom: 8),
                                                      child: Tooltip(
                                                        message: tooltipText,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Checkbox(
                                                              value: checked,
                                                              onChanged:
                                                                  isEnabled
                                                                      ? (val) {
                                                                          setState(
                                                                              () {
                                                                            paymentTypeVisibility[key] =
                                                                                val ?? false;
                                                                          });
                                                                        }
                                                                      : null,
                                                              checkColor:
                                                                  Colors.black,
                                                              activeColor:
                                                                  activeColor,
                                                            ),
                                                            if (iconData !=
                                                                null)
                                                              Icon(
                                                                iconData,
                                                                color:
                                                                    iconColor,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                                Row(
                                                  children: idGivePaymentType
                                                      .skip(5)
                                                      .toList()
                                                      .map((key) {
                                                    final isEnabled =
                                                        customIdGive.any(
                                                            (chip) =>
                                                                chip.startsWith(
                                                                    "$key="));
                                                    if (!isEnabled) {
                                                      paymentTypeVisibility[
                                                          key] = false;
                                                    }
                                                    final checked =
                                                        paymentTypeVisibility[
                                                                key] ??
                                                            false;
                                                    final iconData =
                                                        paymentTypeInfo[key]
                                                                ?['icon']
                                                            as IconData?;
                                                    final tooltipText =
                                                        paymentTypeInfo[key]
                                                                    ?['tooltip']
                                                                as String? ??
                                                            key;

                                                    final Color activeColor =
                                                        isEnabled
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Colors.grey;
                                                    final Color iconColor =
                                                        isEnabled
                                                            ? Colors.black
                                                            : Colors.grey;

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 32,
                                                              bottom: 8),
                                                      child: Tooltip(
                                                        message: tooltipText,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Checkbox(
                                                              value: checked,
                                                              onChanged:
                                                                  isEnabled
                                                                      ? (val) {
                                                                          setState(
                                                                              () {
                                                                            paymentTypeVisibility[key] =
                                                                                val ?? false;
                                                                          });
                                                                        }
                                                                      : null,
                                                              checkColor:
                                                                  Colors.black,
                                                              activeColor:
                                                                  activeColor,
                                                            ),
                                                            if (iconData !=
                                                                null)
                                                              Icon(
                                                                iconData,
                                                                color:
                                                                    iconColor,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Titolo sospeso sul bordo
                                      Positioned(
                                        left: 12,
                                        top: 04,
                                        child: Container(
                                          color: Colors
                                              .white, // stesso colore dello sfondo per "interrompere" il bordo
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            'Gestione visibilità metodi di pagamento per carrello',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                        // isExpanded: panelOpen[0],
                      ),
                      ExpansionPanelRadio(
                        value: 1,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('POS bancari'),
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    obscureText: true,
                                    controller: stripeApiKeyPrivateController,
                                    labelText: AppStrings.stripeApiKeyPrivate +
                                        ((stripeApiKeyPrivateController
                                                    .text.length >
                                                5
                                            ? " ******" +
                                                stripeApiKeyPrivateController
                                                    .text
                                                    .substring(
                                                        stripeApiKeyPrivateController
                                                                .text.length -
                                                            5,
                                                        stripeApiKeyPrivateController
                                                            .text.length)
                                            : "")),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey1.currentState?.validate(),
                                    // validator: (value) {
                                    //   return value!.isNotEmpty
                                    //       ? null
                                    //       : AppStrings
                                    //           .pleaseEnterstripeApiKey;
                                    // },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    obscureText: true,
                                    controller: stripeApiKeyPublicController,
                                    labelText: AppStrings.stripeApiKeyPublic +
                                        ((stripeApiKeyPublicController
                                                    .text.length >
                                                5
                                            ? " ******" +
                                                stripeApiKeyPublicController
                                                    .text
                                                    .substring(
                                                        stripeApiKeyPublicController
                                                                .text.length -
                                                            5,
                                                        stripeApiKeyPublicController
                                                            .text.length)
                                            : "")),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey1.currentState?.validate(),
                                    // validator: (value) {
                                    //   return value!.isNotEmpty
                                    //       ? null
                                    //       : AppStrings
                                    //           .pleaseEnterstripeApiKey;
                                    // },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    obscureText: true,
                                    controller:
                                        stripeIdConnectedAccountController,
                                    labelText: AppStrings
                                            .stripeIdConnectedAccount +
                                        ((stripeIdConnectedAccountController
                                                    .text.length >
                                                5
                                            ? " ******" +
                                                stripeIdConnectedAccountController
                                                    .text
                                                    .substring(
                                                        stripeIdConnectedAccountController
                                                                .text.length -
                                                            5,
                                                        stripeIdConnectedAccountController
                                                            .text.length)
                                            : "")),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey1.currentState?.validate(),
                                    // validator: (value) {
                                    //   return value!.isNotEmpty
                                    //       ? null
                                    //       : AppStrings
                                    //           .pleaseEnterstripeApiKey;
                                    // },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    obscureText: true,
                                    controller: paypalClientIdController,
                                    labelText: AppStrings.paypalApiKey +
                                        ((paypalClientIdController.text.length >
                                                5
                                            ? " ******" +
                                                paypalClientIdController.text
                                                    .substring(
                                                        paypalClientIdController
                                                                .text.length -
                                                            5,
                                                        paypalClientIdController
                                                            .text.length)
                                            : "")),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey1.currentState?.validate(),
                                    // validator: (value) {
                                    //   return value!.isNotEmpty
                                    //       ? null
                                    //       : AppStrings
                                    //           .pleaseEnterstripeApiKey;
                                    // },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ValueListenableBuilder(
                                        valueListenable: stripeValidNotifier,
                                        builder: (_, isValid, __) {
                                          return ElevatedButton(
                                            onPressed: isValid
                                                ? () {
                                                    updateInstitutionStripeData();
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
                        // isExpanded: panelOpen[1],
                      ),
                      ExpansionPanelRadio(
                        value: 2,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
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
                                        _formKey3.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : AppStrings
                                              .pleaseEnterTokenExpiration;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    controller: maxInactivityController,
                                    labelText: AppStrings.userMaxInactivity,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey3.currentState?.validate(),
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
                        // isExpanded: panelOpen[2],
                      ),
                      ExpansionPanelRadio(
                        value: 3,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CheckboxListTile(
                                      title: Text("Ente fiscalizzato"),
                                      value: institutionFiscalized,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          institutionFiscalized = value!;
                                        });
                                        casseModuleControllerListener();
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    enabled: institutionFiscalized,
                                    controller:
                                        institutionFiscalizationCfController,
                                    labelText:
                                        AppStrings.institutionFiscalizationCf,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey4.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : AppStrings
                                              .pleaseEnterInstitutionFiscalizationCf;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    enabled: institutionFiscalized,
                                    obscureText: true,
                                    controller:
                                        institutionFiscalizationPasswordController,
                                    labelText: AppStrings
                                        .institutionFiscalizationPassword,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey4.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : AppStrings
                                              .pleaseEnterInstitutionFiscalizationPassword;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    enabled: institutionFiscalized,
                                    obscureText: true,
                                    controller:
                                        institutionFiscalizationPinController,
                                    labelText:
                                        AppStrings.institutionFiscalizationPin,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey4.currentState?.validate(),
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : AppStrings
                                              .pleaseEnterInstitutionFiscalizationPin;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CheckboxListTile(
                                      title: Text(
                                          "Autorizza pagamento tramite POS"),
                                      value: posAuthorization,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          posAuthorization = value!;
                                        });
                                        casseModuleControllerListener();
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading),
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
                        // isExpanded: panelOpen[3],
                      ),
                      ExpansionPanelRadio(
                        value: 4,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('Parametri'),
                            leading: const Icon(Icons.settings),
                          );
                        },
                        body: Form(
                          key: _formKey5,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomTextFormField(
                                    controller:
                                        parameterIdShAnonymousApiKeyController,
                                    labelText:
                                        AppStrings.parameterIdShAnonymous,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey1.currentState?.validate(),
                                    // validator: (value) {
                                    //   return value!.isNotEmpty
                                    //       ? null
                                    //       : AppStrings
                                    //           .pleaseEnterstripeApiKey;
                                    // },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: CustomDropDownButtonFormField(
                                    enabled: true,
                                    actualValue: selectedUserModelTeam,
                                    labelText: AppStrings
                                        .parameterEmailUserAuthMyosotis,
                                    listOfValue:
                                        userModelTeam.map((UserModelTeam u) {
                                      return DropdownMenuItem<UserModelTeam>(
                                        value: u,
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getIconByRole(u.role),
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(u.name + " " + u.surname,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(u.email,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[600])),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onItemChanged: (value) {
                                      selectedUserModelTeam = value;
                                      // onChangeNumberResult(value);
                                    },
                                    selectedItemBuilder: (context) {
                                      return userModelTeam.map((u) {
                                        return Text(u.name +
                                            " " +
                                            u.surname +
                                            " - " +
                                            u.email); // 👈 Custom visualizzazione elemento selezionato
                                      }).toList();
                                    },
                                  ),
                                ),
                                ProductAutocomplete(
                                  focusNode: FocusNode(),
                                  cTextEditingController:
                                      preestablishedProductController,
                                  enabled: true,
                                  // onChanged: (String value) {
                                  //   cityController.text = value;
                                  //   onChangeField();
                                  // },
                                  onValueSelected: (option) {
                                    //cityController.text = option.city;
                                    onPredefinedProductSelected(option);
                                  },
                                  hintText: 'Prodotto predefinito',
                                  labelText: 'Prodotto predefinito',
                                  // validator: (value) =>
                                  //     value!.toString().isEmpty
                                  //         ? "inserire il comune"
                                  //         : null,
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ValueListenableBuilder(
                                        valueListenable: parameterValidNotifier,
                                        builder: (_, isValid, __) {
                                          return ElevatedButton(
                                            onPressed: isValid
                                                ? () {
                                                    updateParameterData();
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
                        // isExpanded: panelOpen[4],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
