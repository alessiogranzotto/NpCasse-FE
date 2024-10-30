import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/core/models/product.history.model.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/notifiers/report.notifier.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';

class ProductHistoryScreen extends StatefulWidget {
  const ProductHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ProductHistoryScreen> createState() => _ProductHistoryScreenState();
}

class _ProductHistoryScreenState extends State<ProductHistoryScreen> {
  final PagedDataTableController<String, Map<String, dynamic>> tableController =
      PagedDataTableController();
  UserAppInstitutionModel? cSelectedUserAppInstitution;
  UserAppInstitutionModel? previousSelectedInstitution;

  List<DropdownMenuItem<CategoryCatalogModel>> categoryDropdownItems = [];

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   AuthenticationNotifier authenticationNotifier =
  //       Provider.of<AuthenticationNotifier>(context, listen: true);
  //   UserAppInstitutionModel? currentInstitution =
  //       authenticationNotifier.getSelectedUserAppInstitution();

  //   // Check if the institution has changed
  //   if (currentInstitution != previousSelectedInstitution) {
  //     setState(() {
  //       cSelectedUserAppInstitution = currentInstitution;
  //       previousSelectedInstitution =
  //           currentInstitution; // Update previous value
  //       tableController.refresh();
  //     });
  //   }
  // }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final reportNotifier = Provider.of<ReportNotifier>(context, listen: false);
    try {
      int pageNumber = (pageToken != null) ? int.parse(pageToken) : 1;
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      String? sortBy;
      String? sortDirection;
      String? sortColumnAndDirection = '';

      if (sortModel != null) {
        sortBy = sortModel.fieldName;
        sortDirection = sortModel.descending ? 'DESC' : 'ASC';
        sortColumnAndDirection = '$sortBy;$sortDirection';
      }

      DateTimeRange? dateRange = filterModel?["dateRange"];
      DateTime? startDate = dateRange?.start;
      DateTime? endDate = dateRange?.end;

      var response = await reportNotifier.findProductList(
        context: context,
        token: authNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        pageNumber: pageNumber,
        pageSize: pageSize,
        orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
      );

      if (response is ProductHistoryModel) {
        List<Map<String, dynamic>> data = response.productHistoryList
            .map((cart) =>
                cart.toJson()) // Assuming CartModel has a toJson method
            .toList();

        String? nextPageToken =
            response.hasNext ? (pageNumber + 1).toString() : null;
        return (data, nextPageToken);
      } else {
        return (<Map<String, dynamic>>[], null);
      }
    } catch (e) {
      print('Error fetching data: $e');
      return (<Map<String, dynamic>>[], null);
    }
  }

  void handleDownloadProductList(BuildContext context) async {
    final reportNotifier = Provider.of<ReportNotifier>(context, listen: false);
    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authNotifier.getSelectedUserAppInstitution();

    await reportNotifier.downloadProductList(
      context: context,
      token: authNotifier.token,
      idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Report prodotti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PagedDataTable<String, Map<String, dynamic>>(
          controller: tableController,
          initialPageSize: 20,
          pageSizes: const [10, 20, 50],
          fetcher: (pageSize, sortModel, filterModel, pageToken) =>
              fetchData(pageSize, sortModel, filterModel, pageToken),
          filterBarChild: PopupMenuButton(
            icon: const Icon(Icons.more_vert_outlined),
            itemBuilder: (context) => <PopupMenuEntry>[
              // PopupMenuItem(
              //   child: const Text("Seleziona tutti"),
              //   onTap: () {
              //     tableController.selectAllRows();
              //   },
              // ),
              // PopupMenuItem(
              //   child: const Text("Deseleziona tutti"),
              //   onTap: () {
              //     tableController.unselectAllRows();
              //   },
              // ),
              //const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text("Export Excel"),
                onTap: () {
                  handleDownloadProductList(context);
                },
              ),
            ],
          ),
          columns: [
            // RowSelectorColumn(),
            TableColumn(
              id: 'docNumberCart',
              title: const Text('#'),
              cellBuilder: (context, item, index) =>
                  Text(item['docNumberCart'].toString().padLeft(6, '0')),
              size: const FixedColumnSize(100),
              sortable: true,
            ),

            TableColumn(
              id: 'dateCart',
              title: const Text('Data carrello'),
              cellBuilder: (context, item, index) =>
                  Text(item['dateCart'].toString()),
              size: const FixedColumnSize(150),
              sortable: true,
            ),

            TableColumn(
              id: 'nameProduct',
              title: const Text('Nome prodotto'),
              cellBuilder: (context, item, index) =>
                  Text(item['nameProduct'].toString()),
              size: const FixedColumnSize(200),
              sortable: true,
            ),
            TableColumn(
              id: 'productAttributeExplicit',
              title: const Text('Variante'),
              cellBuilder: (context, item, index) =>
                  Text(item['productAttributeExplicit'].toString()),
              size: const FixedColumnSize(350),
              sortable: false,
            ),
            TableColumn(
              id: 'quantityCartProduct',
              title: const Text('Q.ta'),
              cellBuilder: (context, item, index) => Text(
                  (item['quantityCartProduct'] as ValueNotifier<int>)
                      .value
                      .toString()),
              size: const FixedColumnSize(100),
              sortable: true,
            ),
            TableColumn(
              id: 'priceCartProduct',
              title: const Text('Prezzo'),
              cellBuilder: (context, item, index) =>
                  Text(item['priceCartProduct'].toStringAsFixed(2) + ' €'),
              size: const FixedColumnSize(100),
              sortable: true,
            ),
            TableColumn(
              id: 'percDiscount',
              title: const Text('Sconto'),
              cellBuilder: (context, item, index) =>
                  Text(item['percDiscount'].toStringAsFixed(2) + ' %'),
              size: const FixedColumnSize(100),
              sortable: true,
            ),
            TableColumn(
              id: 'priceDiscounted',
              title: const Text('Prezzo scontato'),
              cellBuilder: (context, item, index) =>
                  Text(item['priceDiscounted'].toStringAsFixed(2) + ' €'),
              size: const FixedColumnSize(150),
              sortable: true,
            ),

            TableColumn(
              id: 'notesCartProduct',
              title: const Text('Note'),
              cellBuilder: (context, item, index) =>
                  Text(item['notesCartProduct'].toString()),
              size: const FixedColumnSize(350),
              sortable: true,
            ),
          ],
          filters: [],
        ),
      ),
    );
  }
}
