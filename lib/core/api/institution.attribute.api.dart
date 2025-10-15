import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/institution.model.dart';

class InstitutionAttributeAPI {
  final client = http.Client();

  Future getInstitutionAttribute(
      {String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseInstitutionAttributeURL}/Get-institution-attribute?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
        "Authorization": token ?? ''
      },
    );
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    }
  }

  Future getInstitutionEmail(
      {required String? token, required int idUserAppInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseInstitutionEmailURL}/Get-institution-email?idUserAppInstitution=$idUserAppInstitution');
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
        "Authorization": token ?? ''
      },
    );
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future getInstitutionUser(
      {String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseUserAppInstitutionURL}/Get-user-app-institution?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
        "Authorization": token ?? ''
      },
    );
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    }
  }

  Future updateInstitutionPaymentMethodAttribute(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required int idPaymentTypeContanti,
      required int idPaymentTypeBancomat,
      required int idPaymentTypeCartaCredito,
      required int idPaymentTypeAssegni,
      required int idPaymentTypePaypal,
      required int idPaymentTypeEsterno,
      required int idPaymentTypeSdd,
      required int idPaymentTypeBonificoPromessa,
      required int idPaymentTypeBonificoIstantaneo,
      required int idPaymentTypeBonificoLink,
      required String paymentTypeVisibility}) async {
    List<InstitutionAttributeModel> cInstitutionAttributeModel = [];
    final paymentTypes = {
      'Contanti': idPaymentTypeContanti,
      'Bancomat': idPaymentTypeBancomat,
      'CartaCredito': idPaymentTypeCartaCredito,
      'Assegni': idPaymentTypeAssegni,
      'Paypal': idPaymentTypePaypal,
      'Esterno': idPaymentTypeEsterno,
      'Sdd': idPaymentTypeSdd,
      'BonificoPromessa': idPaymentTypeBonificoPromessa,
      'BonificoIstantaneo': idPaymentTypeBonificoIstantaneo,
      'BonificoLink': idPaymentTypeBonificoLink
    };

    for (var entry in paymentTypes.entries) {
      if (entry.value > 0) {
        cInstitutionAttributeModel.add(
          InstitutionAttributeModel(
            attributeName: 'Give.IdPaymentType.${entry.key}',
            attributeValue: entry.value.toString(),
          ),
        );
      }
    }
    cInstitutionAttributeModel.add(
      InstitutionAttributeModel(
        attributeName: 'Give.IdPaymentType.Visibility',
        attributeValue: paymentTypeVisibility,
      ),
    );
    final Uri uri = Uri.parse(
        '${ApiRoutes.updateInstitutionAttributeURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode(
            {"updateInstitutionAttributeRequest": cInstitutionAttributeModel}));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future updateInstitutionPosBancariAttribute({
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required String stripeApiKeyPrivate,
    required String stripeApiKeyPublic,
    required String stripeIdConnectedAccount,
    required String paypalClientId,
  }) async {
    List<InstitutionAttributeModel> cInstitutionAttributeModel = [];
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Stripe.ApiKeyPrivate',
        attributeValue: stripeApiKeyPrivate));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Stripe.ApiKeyPublic',
        attributeValue: stripeApiKeyPublic));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Stripe.IdConnectedAccount',
        attributeValue: stripeIdConnectedAccount));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Paypal.ClientId', attributeValue: paypalClientId));

    final Uri uri = Uri.parse(
        '${ApiRoutes.updateInstitutionAttributeURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "updateInstitutionAttributeRequest": cInstitutionAttributeModel,
        }));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future updateInstitutionSecurityAttribute({
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required String otpMode,
    required int tokenExpiration,
    required int maxInactivity,
  }) async {
    List<InstitutionAttributeModel> cInstitutionAttributeModel = [];
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'User.OtpMode', attributeValue: otpMode));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'User.TokenExpiration',
        attributeValue: tokenExpiration.toString()));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'User.MaxInactivity',
        attributeValue: maxInactivity.toString()));

    final Uri uri = Uri.parse(
        '${ApiRoutes.updateInstitutionAttributeURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "updateInstitutionAttributeRequest": cInstitutionAttributeModel,
        }));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future updateGiveAttribute({
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required String giveNomeLogin,
    required String giveBaseAddress,
    required String giveUserName,
    required String givePassword,
  }) async {
    List<InstitutionAttributeModel> cInstitutionAttributeModel = [];
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Give.NomeLogin', attributeValue: giveNomeLogin));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Give.BaseAddress', attributeValue: giveBaseAddress));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Give.Username', attributeValue: giveUserName));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Give.Password', attributeValue: givePassword));

    final Uri uri = Uri.parse(
        '${ApiRoutes.updateInstitutionAttributeURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "updateInstitutionAttributeRequest": cInstitutionAttributeModel,
        }));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      return null;
    }
  }

  Future updateEmailSendAttribute({
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required String emailSendAccompaniment,
    required String emailSendFrom,
  }) async {
    List<InstitutionAttributeModel> cInstitutionAttributeModel = [];
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Smtp2Go.IdTemplateAccompaniment',
        attributeValue: emailSendAccompaniment));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Smtp2Go.SendingEmail', attributeValue: emailSendFrom));

    final Uri uri = Uri.parse(
        '${ApiRoutes.updateInstitutionAttributeURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "updateInstitutionAttributeRequest": cInstitutionAttributeModel,
        }));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future updateCasseModuleDataAttribute(
      {String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool institutionFiscalized,
      required String institutionFiscalizationCf,
      required String institutionFiscalizationPassword,
      required String institutionFiscalizationPin,
      required bool posAuthorization}) async {
    List<InstitutionAttributeModel> cInstitutionAttributeModel = [];
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Institution.Fiscalized',
        attributeValue: institutionFiscalized.toString()));

    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Institution.PosAuthorization',
        attributeValue: posAuthorization.toString()));

    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Institution.Fiscalization-Cf',
        attributeValue: institutionFiscalizationCf));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Institution.Fiscalization-Password',
        attributeValue: institutionFiscalizationPassword));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Institution.Fiscalization-Pin',
        attributeValue: institutionFiscalizationPin));

    final Uri uri = Uri.parse(
        '${ApiRoutes.updateInstitutionAttributeURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "updateInstitutionAttributeRequest": cInstitutionAttributeModel,
        }));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future updateInstitutionParameterAttribute(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required String parameterIdShAnonymous,
      required String parameterEmailUserAuthMyosotis,
      required String predefinedProduct}) async {
    List<InstitutionAttributeModel> cInstitutionAttributeModel = [];
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Parameter.IdShAnonymous',
        attributeValue: parameterIdShAnonymous));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Parameter.EmailUserAuthMyosotis',
        attributeValue: parameterEmailUserAuthMyosotis));
    cInstitutionAttributeModel.add(new InstitutionAttributeModel(
        attributeName: 'Parameter.PredefinedProduct',
        attributeValue: predefinedProduct));

    final Uri uri = Uri.parse(
        '${ApiRoutes.updateInstitutionAttributeURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "updateInstitutionAttributeRequest": cInstitutionAttributeModel,
        }));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future downloadInstitutionEmail(
      {String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required String emailName}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseInstitutionEmailURL}/Downlaod-institution-email?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&EmailName=$emailName');
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
        "Authorization": token ?? ''
      },
    );
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }
}
