import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class ReportApi {
  final client = http.Client();

  Future findCartList(
      {required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.reportURL}/find-cart-list?idUserAppInstitution=$idUserAppInstitution&pageNumber=$pageNumber&pageSize=$pageSize&orderBy=$orderBy');
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

  Future findProductList(
      {required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.reportURL}/find-product-list?idUserAppInstitution=$idUserAppInstitution&pageNumber=$pageNumber&pageSize=$pageSize&orderBy=$orderBy');
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
}
