import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/componenents/custom.table.footer.dart';
import 'package:np_casse/componenents/table.filter.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/product.history.model.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/notifiers/report.product.notifier.dart';
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
  List<DropdownMenuItem<CategoryCatalogModel>> subCategoryDropdownItems = [];
  List<DropdownMenuItem<ProductCatalogModel>> productDropdownItems = [];

  CategoryCatalogModel? selectedCategory; // Track the selected category
  CategoryCatalogModel? selectedSubCategory; // Track the selectedSubCategory

  bool isLoadingCategories = true; // Add loading state variable

  List<String> filterStringModel = [];
  String? sortBy;
  String? sortDirection;
  String sortColumnAndDirection = '';
  bool isRefreshing = true; // Track if data is refreshing
  int totalCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ReportProductNotifier reportProductNotifier =
        Provider.of<ReportProductNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (reportProductNotifier.isUpdated && !isRefreshing) {
      // Post-frame callback to avoid infinite loop during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reportProductNotifier.setUpdate(false); // Reset the update flag
        tableController.refresh();
      });
    }
  }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final reportNotifier =
        Provider.of<ReportProductNotifier>(context, listen: false);
    try {
      int pageNumber = (pageToken != null) ? int.parse(pageToken) : 1;
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      // String? sortBy;
      // String? sortDirection;
      sortColumnAndDirection = '';

      // Set refreshing to true before data fetching
      setState(() {
        isRefreshing = true;
      });
      if (sortModel != null) {
        sortBy = sortModel.fieldName;
        sortDirection = sortModel.descending ? 'DESC' : 'ASC';
        sortColumnAndDirection = '$sortBy;$sortDirection';
      }
      filterStringModel = [];
      if (filterModel != null) {
        if (filterModel['categoryFilter'] != null) {
          CategoryCatalogModel cCategoryCatalogModel =
              filterModel['categoryFilter'];
          filterStringModel.add('Filter=categoryFilter:' +
              cCategoryCatalogModel.idCategory.toString());
        }
        if (filterModel['subcategoryFilter'] != null) {
          CategoryCatalogModel cCategoryCatalogModel =
              filterModel['subcategoryFilter'];
          filterStringModel.add('Filter=subcategoryFilter:' +
              cCategoryCatalogModel.idCategory.toString());
        }
        if (filterModel['productFilter'] != null) {
          ProductCatalogModel cProductCatalogModel =
              filterModel['productFilter'];
          filterStringModel.add('Filter=productFilter:' +
              cProductCatalogModel.idProduct.toString());
        }
        if (filterModel['orderNumber'] != null) {
          int orderNumber = filterModel['orderNumber'];
          filterStringModel.add('Filter=orderNumber:' + orderNumber.toString());
        }
        if (filterModel['startDate'] != null) {
          String cStartDate = filterModel['startDate'];
          filterStringModel.add('Filter=startDate:' + cStartDate);
        }
        if (filterModel['endDate'] != null) {
          String cEndDate = filterModel['endDate'];
          filterStringModel.add('Filter=endDate:' + cEndDate);
        }
      }

      var response = await reportNotifier.findProductList(
          context: context,
          token: authNotifier.token,
          idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
          filter: filterStringModel);

      if (response is ProductHistoryModel) {
        totalCount = response.totalCount;
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
    } finally {
      // After fetching data, set isRefreshing to false
      reportNotifier.setUpdate(false); // Reset the update flag

      setState(() {
        isRefreshing = false;
      });
    }
  }

  void handleDownloadProductList(BuildContext context) async {
    final reportNotifier =
        Provider.of<ReportProductNotifier>(context, listen: false);
    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authNotifier.getSelectedUserAppInstitution();

    await reportNotifier.downloadProductList(
        context: context,
        token: authNotifier.token,
        pageNumber: 1,
        pageSize: -1,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
        filter: filterStringModel);
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
        backgroundColor: CustomColors.darkBlue,
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
              PopupMenuItem(
                child: const Text("Export Excel"),
                onTap: () {
                  handleDownloadProductList(context);
                },
              ),
            ],
          ),
          footer: CustomTableFooter<String, Map<String, dynamic>>(
            totalItems: totalCount, 
            controller: tableController, 
          ),
          columns: [
            // RowSelectorColumn(),
            TableColumn(
              id: 'docNumberCart',
              title: const Text('#'),
              cellBuilder: (context, item, index) =>
                  SelectableText(item['docNumberCart'].toString().padLeft(6, '0')),
              size: const FixedColumnSize(100),
              sortable: true,
            ),
            TableColumn(
              id: 'dateCart',
              title: const Text('Data'),
              cellBuilder: (context, item, index) =>
                  SelectableText(item['dateCart'].toString()),
              size: const FixedColumnSize(200),
              sortable: true,
            ),
            TableColumn(
              id: 'nameProduct',
              title: const Text('Nome prodotto'),
              cellBuilder: (context, item, index) =>
                  SelectableText(item['nameProduct'].toString()),
              size: const FixedColumnSize(300),
              sortable: true,
            ),
            TableColumn(
              id: 'productAttributeExplicit',
              title: const Text('Variante'),
              cellBuilder: (context, item, index) =>
                  SelectableText(item['productAttributeExplicit'].toString()),
              size: const FixedColumnSize(300),
              sortable: false,
            ),
            TableColumn(
              id: 'quantityCartProduct',
              title: const Text('Q.ta'),
              cellBuilder: (context, item, index) => SelectableText(
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
                  SelectableText(item['priceCartProduct'].toStringAsFixed(2) + ' €'),
              size: const FixedColumnSize(150),
              sortable: true,
            ),
            TableColumn(
              id: 'notesCartProduct',
              title: const Text('Note'),
              cellBuilder: (context, item, index) =>
                  SelectableText(item['notesCartProduct'].toString()),
              size: const FixedColumnSize(350),
              sortable: true,
            ),
          ],
          filters: [
            // Category filter
            CustomDropdownTableFilter<CategoryCatalogModel>(
              loadOptions: () async {
                final categoryCatalogNotifier =
                    Provider.of<CategoryCatalogNotifier>(context,
                        listen: false);
                final authNotifier =
                    Provider.of<AuthenticationNotifier>(context, listen: false);
                final idUserAppInstitution = authNotifier
                    .getSelectedUserAppInstitution()
                    .idUserAppInstitution;

                final categories = await categoryCatalogNotifier.getCategories(
                  context: context,
                  token: authNotifier.token,
                  idUserAppInstitution: idUserAppInstitution,
                  idCategory: 0,
                  levelCategory: 'FirstLevelCategory',
                  readAlsoDeleted: false,
                  numberResult: 'All',
                  nameDescSearch: '',
                  readImageData: false,
                  orderBy: 'NameCategory',
                );

                return categories ?? [CategoryCatalogModel.empty()];
              },
              chipFormatter: (value) =>
                  'Categoria: ${value?.nameCategory ?? "None"}',
              id: "categoryFilter",
              name: "Categoria",
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              displayStringForOption: (category) => category.nameCategory,
            ),

            // Subcategory filter
            CustomDropdownTableFilter<CategoryCatalogModel>(
              loadOptions: () async {
                if (selectedCategory == null) return [];
                final categoryCatalogNotifier =
                    Provider.of<CategoryCatalogNotifier>(context,
                        listen: false);
                final authNotifier =
                    Provider.of<AuthenticationNotifier>(context, listen: false);
                final idUserAppInstitution = authNotifier
                    .getSelectedUserAppInstitution()
                    .idUserAppInstitution;

                final categories = await categoryCatalogNotifier.getCategories(
                  context: context,
                  token: authNotifier.token,
                  idUserAppInstitution: idUserAppInstitution,
                  idCategory: selectedCategory!
                      .idCategory, // Use the selected category ID
                  levelCategory: 'SubCategory',
                  readAlsoDeleted: false,
                  numberResult: 'All',
                  nameDescSearch: '',
                  readImageData: false,
                  orderBy: 'NameCategory',
                );

                return categories ?? [CategoryCatalogModel.empty()];
              },
              chipFormatter: (value) =>
                  'Sottocategoria: ${value?.nameCategory ?? "None"}',
              id: "subcategoryFilter",
              name: "Sottocategoria",
              onChanged: (newValue) {
                setState(() {
                  selectedSubCategory = newValue;
                });
              },
              displayStringForOption: (category) => category.nameCategory,
            ),

            AutocompleteTableFilter<ProductCatalogModel>(
              // options: [], // Initially empty; will be loaded
              displayStringForOption: (ProductCatalogModel product) =>
                  product.nameProduct,
              id: 'productFilter',
              name: 'Prodotto',
              chipFormatter: (ProductCatalogModel product) =>
                  'Prodotto: ${product.nameProduct}',
              loadOptions: () async {
                final productCatalogNotifier =
                    Provider.of<ProductCatalogNotifier>(context, listen: false);
                final authNotifier =
                    Provider.of<AuthenticationNotifier>(context, listen: false);
                final idUserAppInstitution = authNotifier
                    .getSelectedUserAppInstitution()
                    .idUserAppInstitution;
                return await productCatalogNotifier.getProducts(
                  context: context,
                  token: authNotifier.token,
                  idUserAppInstitution: idUserAppInstitution,
                  idCategory: selectedCategory?.idCategory == null
                      ? selectedCategory?.idCategory ?? 0
                      : selectedSubCategory?.idCategory ?? 0,
                  readAlsoDeleted: false,
                  numberResult: 'All',
                  nameDescSearch: '',
                  readImageData: false,
                  shoWVariant: false,
                  orderBy: 'NameProduct',
                  viewOutOfAssortment: true,
                );
              },
              decoration: InputDecoration(
                labelText: 'Prodotto',
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            IntegerTextTableFilter(
              id: "orderNumber",
              chipFormatter: (value) => "Carrello: $value",
              name: "Carrello",
            ),
            DateTextTableFilter(
              id: "startDate",
              chipFormatter: (value) => 'Da "$value"',
              name: "Da",
            ),
            DateTextTableFilter(
              id: "endDate",
              chipFormatter: (value) => 'A "$value"',
              name: "A",
            ),
          ],
        ),
      ),
    );
  }
}
