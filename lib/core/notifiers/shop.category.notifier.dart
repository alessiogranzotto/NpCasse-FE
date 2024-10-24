// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:np_casse/core/api/category.catalog.api.dart';
// import 'package:np_casse/core/models/category.catalog.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';
// import 'package:provider/provider.dart';

// class ShopCategoryNotifier with ChangeNotifier {
//   final CategoryCatalogAPI categoryCatalogAPI = CategoryCatalogAPI();
//   CategoryCatalogModel currentCategoryCatalogModel =
//       CategoryCatalogModel.empty();
//   // int get getIdProduct => currentProductModel.idProduct;
//   // int get getIdStore => currentProductModel.idStore;
//   // String get getNameProduct => currentProductModel.nameProduct;
//   // double get getPriceProduct => currentProductModel.priceProduct;

//   setCategoryCatalog(CategoryCatalogModel CategoryCatalogModel) {
//     currentCategoryCatalogModel = CategoryCatalogModel;
//   }

//   Future getCategories(
//       {required BuildContext context,
//       required String? token,
//       required int idUserAppInstitution,
//       required int idCategory,
//       required String levelCategory,
//       required bool readAlsoDeleted,
//       required String numberResult,
//       required String nameDescSearch,
//       required bool readImageData,
//       required String orderBy}) async {
//     try {
//       var response = await categoryCatalogAPI.getCategories(
//           token: token,
//           idUserAppInstitution: idUserAppInstitution,
//           idCategory: idCategory,
//           levelCategory: levelCategory,
//           readAlsoDeleted: readAlsoDeleted,
//           numberResult: numberResult,
//           nameDescSearch: nameDescSearch,
//           readImageData: readImageData,
//           orderBy: orderBy);
//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         bool isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Categorie",
//                     message: errorDescription,
//                     contentType: "failure"));
//           }
//         } else {
//           List<CategoryCatalogModel> categories =
//               List.from(parseData['okResult'])
//                   .map((e) => CategoryCatalogModel.fromJson(e))
//                   .toList();
//           return categories;
//           // notifyListeners();
//         }
//       } else {
//         AuthenticationNotifier authenticationNotifier =
//             Provider.of<AuthenticationNotifier>(context, listen: false);
//         authenticationNotifier.exit(context);
//       }
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Categorie",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }

//   Future addOrUpdateCategory(
//       {required BuildContext context,
//       required String? token,
//       required CategoryCatalogModel categoryCatalogModel}) async {
//     try {
//       bool isOk = false;
//       //SVUOTO SE IMMAGINE NON IMPOSTATA
//       // if (projectModel.imageProject == AppAssets.noImageString) {
//       //   projectModel.imageProject = '';
//       // }
//       var response = await categoryCatalogAPI.addOrUpdateCategory(
//           token: token, categoryCatalogModel: categoryCatalogModel);

//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Categorie",
//                     message: errorDescription,
//                     contentType: "failure"));
//             // Navigator.pop(context);
//           }
//         } else {
//           // ProjectModel projectDetail =
//           //     ProjectModel.fromJson(parseData['okResult']);
//           //return projectDetail;
//           // notifyListeners();
//         }
//       }
//       return isOk;
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "progetti",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }

//   void refresh() {
//     notifyListeners();
//   }
// }
