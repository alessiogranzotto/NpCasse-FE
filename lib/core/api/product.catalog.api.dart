import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';

class ProductCatalogAPI {
  final client = http.Client();

  Future getProducts(
      {required String? token,
      required int idUserAppInstitution,
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
        '&IdCategory=$idCategory' +
        '&ReadAlsoDeleted=$readAlsoDeleted' +
        '&NumberResult=$numberResult' +
        '&NameDescSearch=$nameDescSearch' +
        '&ReadImageData=$readImageData' +
        '&OrderBy=$orderBy' +
        '&ShowVariant=$showVariant' +
        '&viewOutOfAssortment=$viewOutOfAssortment');
    print(uri);
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

  Future getProductPrice(
      {required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required List<String?> parameters}) async {
    String paramEncode = '';
    for (int i = 0; i < parameters.length; i++) {
      String p = parameters[i] ?? '';
      paramEncode = paramEncode + '&Parameters' + '=' + p;
    }
    final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}' +
        '/$idProduct/GetProductPrice?IdUserAppInstitution=$idUserAppInstitution' +
        paramEncode);
    print(uri);
    String x = jsonEncode(parameters);
    print(x);
    //https://localhost:7264/api/Product/1/GetProductPrice?IdUserAppInstitution=5&Parameters=1&Parameters=2&Parameters=3'\
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

  Future addOrUpdateProduct(
      {required String? token,
      required ProductCatalogModel productCatalogModel}) async {
    int idProduct = productCatalogModel.idProduct;
    String x = jsonEncode(productCatalogModel);
    String y = jsonEncode(productCatalogModel.giveIdsFlatStructureModel);
    if (kDebugMode) {
      print(x);
      print(y);
      print(jsonEncode(productCatalogModel));
    }
    final http.Response response;
    if (idProduct == 0) {
      final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}');
      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(productCatalogModel));
    } else {
      final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}/$idProduct');
      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(productCatalogModel));
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
