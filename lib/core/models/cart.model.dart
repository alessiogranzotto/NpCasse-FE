import 'package:np_casse/core/models/cart.product.model.dart';

class CartModel {
  CartModel(
      {required this.idCart,
      required this.idUserAppInstitution,
      required this.dateCreatedCart,
      required this.stateCart});
  late final int idCart;
  late final int idUserAppInstitution;
  late final DateTime dateCreatedCart;
  late final int stateCart;
  late final String notesCart;
  late final List<CartProductModel> cartProducts;

  CartModel.empty() {
    idCart = 0;
    idUserAppInstitution = 0;
    dateCreatedCart = DateTime.now();
    stateCart = 0;
    notesCart = "";
    cartProducts = List.empty();
  }
  CartModel.fromJson(Map<String, dynamic> json) {
    idCart = json['idCart'];
    idUserAppInstitution = json['idUserAppInstitution'];
    dateCreatedCart = DateTime.parse(json['dateCreatedCart']);
    stateCart = json['stateCart'];
    notesCart = json['notesCart'];
    cartProducts = List.from(json['cartProducts'])
        .map((e) => CartProductModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idCart'] = idCart;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['dateCreatedCart'] = dateCreatedCart;
    data['stateCart'] = stateCart;
    data['notesCart'] = notesCart;
    data['cartProducts'] = cartProducts;
    return data;
  }
}

class InvoiceTypeModel {
  InvoiceTypeModel({required this.emailName});
  late final String emailName;

  InvoiceTypeModel.fromJson(Map<String, dynamic> json) {
    emailName = json['emailName'];
  }
}
