import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';

class CategoryCatalogAPI {
  final client = http.Client();

  Future getCategories(
      {required String? token,
      required int idUserAppInstitution,
      int idCategory = 0,
      String levelCategory = '',
      bool readAlsoDeleted = false,
      String numberResult = '',
      String nameDescSearch = '',
      bool readImageData = false,
      String orderBy = ''}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseCategoryURL}' +
        '?IdUserAppInstitution=$idUserAppInstitution' +
        '&IdCategory=$idCategory' +
        '&LevelCategory=$levelCategory' +
        '&ReadAlsoDeleted=$readAlsoDeleted' +
        '&NumberResult=$numberResult' +
        '&NameDescSearch=$nameDescSearch' +
        '&ReadImageData=$readImageData' +
        '&OrderBy=$orderBy');
    print(uri);
    //'https://localhost:7264/api/Category?IdUserAppInstitution=5&IdCategory=0&LevelCategory=AllCategory&ReadAlsoDeleted=true&NumberResult=10&NameDescSearch=ff&ReadImageData=true&OrderBy=NameCategory' \
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

  Future addOrUpdateCategory(
      {required String? token,
      required CategoryCatalogModel categoryCatalogModel}) async {
    int idCategory = categoryCatalogModel.idCategory;
    String x = jsonEncode(categoryCatalogModel);
    String y = jsonEncode(categoryCatalogModel.giveIdsFlatStructureModel);
    if (kDebugMode) {
      print(x);
      print(y);
      print(jsonEncode(categoryCatalogModel));
    }
    final http.Response response;
    if (idCategory == 0) {
      final Uri uri = Uri.parse('${ApiRoutes.baseCategoryURL}');
      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(categoryCatalogModel));
    } else {
      final Uri uri = Uri.parse('${ApiRoutes.baseCategoryURL}/$idCategory');
      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(categoryCatalogModel));
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
