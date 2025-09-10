import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/product.attribute.combination.model.dart';

class ProductAttributeCombinationAPI {
  final client = http.Client();

  Future updateProductAttributeCombination(
      {String? token,
      required idProduct,
      required idUserAppInstitution,
      required List<ProductAttributeCombinationModel>
          productAttributeCombinationList}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseProductURL}' +
        '/$idProduct/ProductAttributeCombination' +
        '?IdUserAppInstitution=$idUserAppInstitution');
    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode(productAttributeCombinationList));

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
