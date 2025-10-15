import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class CommonAPI {
  final client = http.Client();

  Future getCategories(
      {required String? token,
      required int idUserAppInstitution,
      int idCategory = 0,
      String levelCategory = '',
      bool readAlsoDeleted = false,
      String numberResult = '',
      String nameDescSearch = '',
      bool readImageData = false,
      String orderBy = ''}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseCategoryURL}' +
        '?IdUserAppInstitution=$idUserAppInstitution' +
        '&IdCategory=$idCategory' +
        '&LevelCategory=$levelCategory' +
        '&ReadAlsoDeleted=$readAlsoDeleted' +
        '&NumberResult=$numberResult' +
        '&NameDescSearch=$nameDescSearch' +
        '&ReadImageData=$readImageData' +
        '&OrderBy=$orderBy');
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

  Future getProducts(
      {required String? token,
      required int idUserAppInstitution,
      int idProduct = 0,
      int idCategory = 0,
      bool readAlsoDeleted = false,
      String numberResult = '',
      String nameDescSearch = '',
      bool readImageData = false,
      String orderBy = '',
      bool showVariant = false,
      bool viewOutOfAssortment = false}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}' +
        '?IdUserAppInstitution=$idUserAppInstitution' +
        '&IdProduct=$idProduct' +
        '&IdCategory=$idCategory' +
        '&ReadAlsoDeleted=$readAlsoDeleted' +
        '&NumberResult=$numberResult' +
        '&NameDescSearch=$nameDescSearch' +
        '&ReadImageData=$readImageData' +
        '&OrderBy=$orderBy' +
        '&ShowVariant=$showVariant' +
        '&viewOutOfAssortment=$viewOutOfAssortment');
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

  Future getVat({
    required String? token,
    required int idUserAppInstitution,
  }) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseVatURL}' +
        '?IdUserAppInstitution=$idUserAppInstitution');
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
