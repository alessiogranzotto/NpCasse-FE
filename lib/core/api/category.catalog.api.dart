import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class CategoryCatalogAPI {
  final client = http.Client();

  Future getCategories({
    required String? token,
    required int idUserAppInstitution,
    bool readAlsoDeleted = false,
    bool readImageData = false,
    int idCategory = 0,
    String levelCategory = '',
    int pageNumber = 0,
    int pageSize = 0,
  }) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseCategoryURL}?IdUserAppInstitution=$idUserAppInstitution' +
            '&IdCategory=$idCategory' +
            '&LevelCategory=$levelCategory' +
            '&ReadAlsoDeleted=$readAlsoDeleted' +
            '&ReadImageData=$readImageData');
    print(uri);
    //https://localhost:7264/api/Product?IdUserAppInstitution=5&ReadAlsoDeleted=false&ReadImageData=false&IdCategory=0&PageNumber=1&PageSize=1
    //https://localhost:7264/api/Product?IdUserAppInstitution=5&ReadAlsoDeleted=true &ReadImageData= true&IdCategory=1&PageNumber=12&PageSize=12
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
