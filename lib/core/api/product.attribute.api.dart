import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/product.attribute.model.dart';

class ProductAttributeAPI {
  final client = http.Client();

  Future getProductAttribute({
    required String? token,
    required int idUserAppInstitution,
  }) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseProductAttributeURL}?IdUserAppInstitution=$idUserAppInstitution');

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

  Future addOrUpdateProductAttribute(
      {required String? token,
      required int idUserAppInstitution,
      required ProductAttributeModel productAttributeModel}) async {
    int idProductAttribute = productAttributeModel.idProductAttribute;

    final http.Response response;

    if (idProductAttribute == 0) {
      final Uri uri = Uri.parse('${ApiRoutes.baseProductAttributeURL}');

      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(productAttributeModel));
    } else {
      final Uri uri =
          Uri.parse('${ApiRoutes.baseProductAttributeURL}/$idProductAttribute');
      var t = jsonEncode(productAttributeModel);
      print(t);
      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(productAttributeModel));
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
