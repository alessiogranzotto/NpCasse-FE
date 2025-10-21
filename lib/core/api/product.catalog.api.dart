import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';

class ProductCatalogAPI {
  final client = http.Client();

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

  Future downloadProductCatalog(
      {required String? token,
      required int idUserAppInstitution,
      required int idCategory,
      required bool readAlsoDeleted,
      required String numberResult,
      required String nameDescSearch,
      required bool readImageData,
      required String orderBy,
      required bool showVariant,
      required bool viewOutOfAssortment}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}/download-product' +
        '?IdUserAppInstitution=$idUserAppInstitution' +
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
}
