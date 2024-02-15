// import 'package:flutter/material.dart';
// import 'package:np_casse/core/models/cart.model.dart';
// import 'package:np_casse/core/models/cart.product.model.dart';
// import 'package:provider/provider.dart';
// import 'package:np_casse/core/notifiers/cart.notifier.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';

// Widget showCartData({
//   required snapshot,
//   // required themeFlag,
//   required BuildContext context,
//   required double height,
// }) {
//   List<CartProductModel> cCartProductModel =
//       (snapshot as CartModel).cartProducts;
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//     child: Stack(
//       children: [
//         ListView.builder(
//           physics: const ScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: cCartProductModel.length,
//           itemBuilder: (context, index) {
//             CartProductModel cartProductModel = cCartProductModel[index];
//             return _showCartData(
//               context: context,
//               snapshot: cartProductModel,
//               // themeFlag: themeFlag,
//               height: height,
//             );
//           },
//         ),
//         Align(
//           alignment: FractionalOffset.bottomCenter,
//           child: cartPrice(
//             snapshot: cCartProductModel,
//             // themeFlag: themeFlag,
//             context: context,
//           ),
//         )
//       ],
//     ),
//   );
// }

// Widget cartPrice({
//   required snapshot,
//   // required themeFlag,
//   required BuildContext context,
// }) {
//   double cartPrice = 0;

//   for (int i = 0; i < snapshot.length; i++) {
//     cartPrice += snapshot[i].freePriceCartProduct ?? 0;
//   }
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       // const Text(
//       //   'Total',
//       //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//       // ),
//       // Text(
//       //   '₹ $cartPrice',
//       //   style: CustomTextWidget.bodyText2(
//       //     color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//       //   ),
//       // ),
//       Expanded(
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: MaterialButton(
//             height: MediaQuery.of(context).size.height * 0.05,
//             minWidth: MediaQuery.of(context).size.width * 0.2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             onPressed: () async {
//               // Provider.of<PaymentService>(context, listen: false)
//               //     .checkMeOut(context: context, cartPrice: cartPrice);
//             },
//             color:  Theme.of(context).colorScheme.secondaryContainer,
//             child: Text(
//               'Pay Now $cartPrice €',
//               style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600)
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

// Widget _showCartData({
//   required BuildContext context,
//   required CartProductModel snapshot,
//   // required bool themeFlag,
//   required double height,
// }) {
//   return Container(
//     margin: const EdgeInsets.only(top: 16),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () {},
//           child: ClipRRect(
//               borderRadius: const BorderRadius.all(Radius.circular(4)),
//               child: Image.network(
//                 // cart.productImage,
//                 'https://source.unsplash.com/3tYZjGSBwbk',
//                 width: MediaQuery.of(context).size.width / 4,
//                 height: MediaQuery.of(context).size.width / 4,
//               )),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 // cartProductModel.productName,
//                 'Product Name',
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 // style: CustomTextWidget.bodyText2(
//                 //   color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//                 // ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 5),
//                 child: const Text(
//                   // '₹  ${cart.productPrice}',
//                   'Product prize',
//                   // style: CustomTextWidget.bodyText2(
//                   //   color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//                   // ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 5),
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () {
//                     deleteItemFromCart(
//                         context: context,
//                         // themeFlag: themeFlag,
//                         // productId: cartProductModel.idCartProduct,
//                         productId: snapshot.idCartProduct);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                     height: 30,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(width: 1, color: Colors.grey[300]!),
//                     ),
//                     child: const Icon(
//                       Icons.delete,
//                       // color: AppColors.rawSienna, size: 20
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// void deleteItemFromCart(
//     {required BuildContext context,
//     // required bool themeFlag,
//     required int productId}) {
//   CartNotifier cartNotifier = Provider.of<CartNotifier>(context, listen: false);

//   Widget cancelButton = TextButton(
//     onPressed: () {
//       Navigator.pop(context);
//     },
//     child: const Text(
//       'No',
//       style: TextStyle(
//           // color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//           ),
//     ),
//   );
//   Widget continueButton = TextButton(
//     onPressed: () {
//       cartNotifier
//           .deleteFromCart(context: context, productId: productId)
//           .then((value) {
//         if (value) {
//           Navigator.pop(context);
//           cartNotifier.refresh();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackUtil.stylishSnackBar(
//               text: 'Deleted From Cart',
//               context: context,
//             ),
//           );
//         } else if (!value) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackUtil.stylishSnackBar(
//               text: 'Oops Error Occured',
//               context: context,
//             ),
//           );
//         }
//       });
//     },
//     child: const Text(
//       'Yes',
//       style: TextStyle(
//           // color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//           ),
//     ),
//   );

//   AlertDialog alert = AlertDialog(
//     // backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     title: const Text(
//       'Delete from Cart',
//       style: TextStyle(fontSize: 18),
//     ),
//     content:
//         const Text('Are you sure to delete this item from your Shopping Cart ?',
//             style: TextStyle(
//               fontSize: 13,
//               // color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//             )),
//     actions: [
//       cancelButton,
//       continueButton,
//     ],
//   );

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
