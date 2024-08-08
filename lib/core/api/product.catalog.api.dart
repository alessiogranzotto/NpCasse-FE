import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/product.model.dart';

class ProductCatalogAPI {
  final client = http.Client();

  Future getProducts({
    required String? token,
    required int idUserAppInstitution,
    bool readAlsoDeleted = false,
    bool readImageData = false,
    int idCategory = 0,
    int pageNumber = 0,
    int pageSize = 0,
  }) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseWhProductURL}?IdUserAppInstitution=$idUserAppInstitution' +
            '&ReadAlsoDeleted=$readAlsoDeleted' +
            '&ReadImageData=$readImageData' +
            '&IdCategory=$idCategory' +
            '&PageNumber=$pageNumber' +
            '&PageSize=$pageSize');
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

  Future addOrUpdateProductCatalog(
      {required String? token,
      required int idUserAppInstitution,
      required int idProject,
      required int idStore,
      required ProductModel productModel}) async {
    int idProduct = productModel.idProduct;

    final http.Response response;

    if (idProduct == 0) {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project/$idProject/Store/$idStore/Product');

      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(productModel));
    } else {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project/$idProject/Store/$idStore/Product/$idProduct');

      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(productModel));
    }

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
