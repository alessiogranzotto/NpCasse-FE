import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/product.attribute.mapping.model.dart';

class ProductAttributeMappingAPI {
  final client = http.Client();

  Future getProductAttributeMapping(
      {required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      bool readAlsoDeleted = false,
      String numberResult = ''}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}' +
        '/$idProduct/ProductAttributeMapping' +
        '?IdUserAppInstitution=$idUserAppInstitution' +
        '&ReadAlsoDeleted=$readAlsoDeleted' +
        '&NumberResult=$numberResult');
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

  Future updateProductAttributeMapping(
      {String? token,
      required idProduct,
      required idUserAppInstitution,
      required List<ProductAttributeMappingModel>
          productAttributeMappingModelList}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}' +
        '/$idProduct/ProductAttributeMapping' +
        '?IdUserAppInstitution=$idUserAppInstitution');
    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode(productAttributeMappingModelList));

    print(jsonEncode(productAttributeMappingModelList));
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
