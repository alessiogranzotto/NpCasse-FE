import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/cart.product.model.dart';

class CartAPI {
  final client = http.Client();

  Future findCart(
      {required String? token,
      required int idUserAppInstitution,
      required int cartStateEnum}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.cartURL}/find-cart?idUserAppInstitution=$idUserAppInstitution&CartStateEnum=$cartStateEnum');
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
    } else if (response.statusCode == 401) {
      //REFRESH TOKEN??
      return null;
    }
  }

  Future addToCart(
      {required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required int quantity,
      double? price,
      required List<CartProductVariants?> cartProductVariants,
      String? notes}) async {
    final Uri uri = Uri.parse('${ApiRoutes.cartURL}/Add-to-cart');
    var p = jsonEncode({
      "idUserAppInstitution": idUserAppInstitution,
      "idProduct": idProduct,
      "quantityCartProduct": quantity,
      "priceCartProduct": price,
      "notesCartProduct": notes,
      "cartProductVariants": cartProductVariants
    });
    print(p);
    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "idUserAppInstitution": idUserAppInstitution,
          "idProduct": idProduct,
          "quantityCartProduct": quantity,
          "priceCartProduct": price,
          "notesCartProduct": notes,
          "cartProductVariants": cartProductVariants
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

  Future updateCartProduct(
      {String? token,
      required int idUserAppInstitution,
      required int idCart,
      required int idCartProduct,
      required int quantityCartProduct}) async {
    final Uri uri = Uri.parse('${ApiRoutes.cartURL}/update-cart');

    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "idUserAppInstitution": idUserAppInstitution,
          "idCart": idCart,
          "idCartProduct": idCartProduct,
          "quantityCartProduct": quantityCartProduct
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

  Future setCartCheckout(
      {String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String typePayment,
      required double totalPriceCart}) async {
    final Uri uri = Uri.parse('${ApiRoutes.cartURL}/Set-cart-checkout');

    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "idCart": idCart,
          "idUserAppInstitution": idUserAppInstitution,
          "typePayment": typePayment,
          "totalPriceCart": totalPriceCart
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

  Future getInvoiceType(
      {required String? token, required int idUserAppInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.cartURL}/Get-invoice-type?idUserAppInstitution=$idUserAppInstitution');
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

  Future getInvoice(
      {required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String emailName}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.cartURL}/Get-invoice?IdUserAppInstitution=$idUserAppInstitution&IdCart=$idCart&EmailName=$emailName');
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
      final dynamic bodyBytes = response.bodyBytes;
      return bodyBytes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future sendInvoice(
      {required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String emailName}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.cartURL}/Send-invoice?IdUserAppInstitution=$idUserAppInstitution&IdCart=$idCart&EmailName=$emailName');
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
      final dynamic bodyBytes = response.body;
      return bodyBytes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future cartToStakeholder(
      {String? token,
      required int idUserAppInstitution,
      required int idCart,
      required int idStakeholder}) async {
    final Uri uri = Uri.parse('${ApiRoutes.cartURL}/cart-to-stakeholder');

    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "idCart": idCart,
          "idUserAppInstitution": idUserAppInstitution,
          "idStakeholder": idStakeholder
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
