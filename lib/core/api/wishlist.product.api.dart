import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class WishlistProductAPI {
  final client = http.Client();

  Future findWishlistedProducts(
      {required String? token, required int idUserAppInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.wishlistProductURL}/find-wishlisted-product?idUserAppInstitution=$idUserAppInstitution');

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

  Future updateWishlistedProductState(
      {required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required bool state}) async {
    final http.Response response;

    final Uri uri = Uri.parse(
        '${ApiRoutes.wishlistProductURL}/update-wishlisted-product-state');

    response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "idUserAppInstitution": idUserAppInstitution,
          "idProduct": idProduct,
          "state": state,
        }));

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
