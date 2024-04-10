import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class GeoAutocompleteAPI {
  final client = http.Client();

  static Future getFullAddressSuggestion(
      {required String? token,
      required int idUserAppInstitution,
      required String queryFullAddress}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.geoSuggestionsURL}/Get-full-address-suggestions?IdUserAppInstitution=$idUserAppInstitution&QueryFullAddress=$queryFullAddress');
    final http.Response response = await http.Client().get(
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

  static Future getCountrySuggestion(
      {required String? token,
      required int idUserAppInstitution,
      required String queryCountry}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.geoSuggestionsURL}/Get-country-suggestions?IdUserAppInstitution=$idUserAppInstitution&QueryCountry=$queryCountry');
    final http.Response response = await http.Client().get(
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

  static Future getAllCountrySuggestion(
      {required String? token, required int idUserAppInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.geoSuggestionsURL}/Get-all-country-suggestions?IdUserAppInstitution=$idUserAppInstitution');
    final http.Response response = await http.Client().get(
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

  static Future getCitySuggestion(
      {required String? token,
      required int idUserAppInstitution,
      required String country,
      required String queryCity}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.geoSuggestionsURL}/Get-city-suggestions?IdUserAppInstitution=$idUserAppInstitution&Country=$country&QueryCity=$queryCity');
    final http.Response response = await http.Client().get(
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

  static Future getStreetSuggestion(
      {required String? token,
      required int idUserAppInstitution,
      required String country,
      required String city,
      required String queryStreet}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.geoSuggestionsURL}/Get-street-suggestions?IdUserAppInstitution=$idUserAppInstitution&Country=$country&City=$city&QueryStreet=$queryStreet');
    final http.Response response = await http.Client().get(
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

  static Future executeNormalization(
      {String? token,
      required int idUserAppInstitution,
      required String iso3,
      required String state,
      required String region,
      required String province,
      required String city,
      required String district1,
      required String district2,
      required String district3,
      required String postalCode,
      required String streetName,
      required String streetNumber}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.geoSuggestionsURL}/Execute-normalization?IdUserAppInstitution=$idUserAppInstitution&Iso3=$iso3&State=$state&Province=$province&City=$city&District1=$district1&District2=$district2&District3=$district3&PostalCode=$postalCode&StreetName=$streetName&StreetNumber=$streetNumber');
    final http.Response response = await http.Client().get(
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
