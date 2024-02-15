import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/product.model.dart';

class ProductAPI {
  final client = http.Client();

  Future getProduct(
      {required String? token,
      required int idUserAppInstitution,
      required idProject,
      required idStore}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project/$idProject/Store/$idStore/Product');

    //https://localhost:7262/api/UserInstitution/1/Project'
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
