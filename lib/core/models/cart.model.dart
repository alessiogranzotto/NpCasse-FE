import 'package:intl/intl.dart';
import 'package:np_casse/core/models/cart.product.model.dart';

class CartModel {
  CartModel({
    required this.idCart,
    required this.idUserAppInstitution, // Include this in the constructor
    required this.dateCreatedCart,
    required this.paymentTypeCart,
    required this.docNumberCart,
    required this.stateCart,
    required this.stateCartDescription,
    required this.fiscalization,
    required this.stateFiscalization,
    required this.fiscalizationId,
    required this.notesCart,
    required this.cartProducts,
    required this.totalPriceCart,
    required this.percDiscount,
    required this.idStakeholder,
    required this.denominationStakeholder,
  });

  late final int idCart;
  late final int idUserAppInstitution;
  late final DateTime dateCreatedCart;
  late final String paymentTypeCart;
  late final int docNumberCart;
  late final int stateCart;
  late final String stateCartDescription;

  late final int fiscalization;
  late final String stateFiscalization;
  late final String? fiscalizationId;
  late final String? fiscalizationExternalId;

  late final String notesCart;
  late final double? totalPriceCart;
  late final double? percDiscount;
  late final int? idStakeholder;
  late final String? denominationStakeholder;
  late final List<CartProductModel> cartProducts;

  // Empty constructor with default values
  CartModel.empty() {
    idCart = 0;
    idUserAppInstitution = 0; // Ensure it's initialized here
    dateCreatedCart = DateTime.now();
    paymentTypeCart = '';
    docNumberCart = 0;
    stateCart = 0;
    stateCartDescription = '';
    fiscalization = 0;
    stateFiscalization = '';
    fiscalizationId = null;
    notesCart = '';
    totalPriceCart = null;
    percDiscount = null;
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
    docNumberCart = json['docNumberCart'];
    stateCart = json['stateCart'];
    stateCartDescription = json['stateCartDescription'];

    fiscalization = json['fiscalization'];
    stateFiscalization = json['fiscalizationDescription'];
    fiscalizationId = json['fiscalizationId'];
    fiscalizationExternalId = json['fiscalizationExternalId'];

    notesCart = json['notesCart'] ?? '';
    totalPriceCart = (json['totalPriceCart'] != null)
        ? double.parse((json['totalPriceCart']).toStringAsFixed(2))
        : json['totalPriceCart'];
    percDiscount = double.parse((json['percDiscount']).toStringAsFixed(2));
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
    data['docNumberCart'] = docNumberCart;
    data['stateCart'] = stateCart;
    data['stateCartDescription'] = stateCartDescription;

    data['fiscalization'] = fiscalization;
    data['stateFiscalization'] = stateFiscalization;
    data['fiscalizationId'] = fiscalizationId;
    data['fiscalizationExternalId'] = fiscalizationExternalId;

    data['notesCart'] = notesCart;
    data['totalPriceCart'] = totalPriceCart;
    data['percDiscount'] = percDiscount;
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
