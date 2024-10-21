import 'package:intl/intl.dart';
import 'package:np_casse/core/models/cart.product.model.dart';

class CartModel {
  CartModel({
    required this.idCart,
    required this.idUserAppInstitution, // Include this in the constructor
    required this.dateCreatedCart,
    required this.paymentTypeCart,
    required this.stateCart,
    required this.notesCart,
    required this.cartProducts,
    required this.totalPriceCart,
    required this.idStakeholder,
    required this.denominationStakeholder,
  });

  late final int idCart;
  late final int idUserAppInstitution;
  late final DateTime dateCreatedCart;
  late final String paymentTypeCart;
  late final int stateCart;
  late final String notesCart;
  late final double? totalPriceCart;
  late final int? idStakeholder;
  late final String? denominationStakeholder;
  late final List<CartProductModel> cartProducts;

  // Empty constructor with default values
  CartModel.empty() {
    idCart = 0;
    idUserAppInstitution = 0; // Ensure it's initialized here
    dateCreatedCart = DateTime.now();
    paymentTypeCart = '';
    stateCart = 0;
    notesCart = '';
    totalPriceCart = null;
    idStakeholder = null;
    denominationStakeholder = null;
    cartProducts = List.empty();
  }

  // JSON deserialization
  CartModel.fromJson(Map<String, dynamic> json) {
    idCart = json['idCart'];
    idUserAppInstitution = json['idUserAppInstitution'] ?? 0; // Handle null
    var dateTimeC =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateCreatedCart'], true);
    dateCreatedCart = dateTimeC.toLocal();
    paymentTypeCart = json['paymentTypeCart'] ?? '';
    stateCart = json['stateCart'];
    notesCart = json['notesCart'] ?? '';
    totalPriceCart = json['totalPriceCart'];
    idStakeholder = json['idStakeholder'];
    denominationStakeholder = json['denominationStakeholder'];
    cartProducts = List.from(json['cartProducts'])
        .map((e) => CartProductModel.fromJson(e))
        .toList();
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idCart'] = idCart;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['dateCreatedCart'] = dateCreatedCart.toIso8601String();
    data['paymentTypeCart'] = paymentTypeCart;
    data['stateCart'] = stateCart;
    data['notesCart'] = notesCart;
    data['totalPriceCart'] = totalPriceCart;
    data['idStakeholder'] = idStakeholder;
    data['denominationStakeholder'] = denominationStakeholder;
    data['cartProducts'] = cartProducts.map((e) => e.toJson()).toList();
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
