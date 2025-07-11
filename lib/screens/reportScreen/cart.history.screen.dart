import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/componenents/custom.table.footer.dart';
import 'package:np_casse/componenents/table.filter.dart';
import 'package:np_casse/core/models/state.model.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/report.cart.notifier.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/models/cart.history.model.dart';
import 'package:np_casse/app/routes/app_routes.dart';

class CartHistoryScreen extends StatefulWidget {
  const CartHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CartHistoryScreen> createState() => _CartHistoryScreenState();
}

class _CartHistoryScreenState extends State<CartHistoryScreen> {
  final PagedDataTableController<String, Map<String, dynamic>> tableController =
      PagedDataTableController();
  bool isRefreshing = true; // Track if data is refreshing
  int totalCount = 0;
  double totalAmount = 0;

  List<DropdownMenuItem<StateModel>> categoryDropdownItems = [];
  List<DropdownMenuItem<StateModel>> subCategoryDropdownItems = [];
  List<String> filterStringModel = [];
  String? sortBy;
  String? sortDirection;
  String sortColumnAndDirection = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ReportCartNotifier reportCartNotifier =
        Provider.of<ReportCartNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (reportCartNotifier.isUpdated && !isRefreshing) {
      // Post-frame callback to avoid infinite loop during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reportCartNotifier.setUpdate(false); // Reset the update flag
        tableController.refresh();
      });
    }
  }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final cartHistoryNotifier =
        Provider.of<ReportCartNotifier>(context, listen: false);
    try {
      int pageNumber = (pageToken != null) ? int.parse(pageToken) : 1;
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      sortColumnAndDirection = '';

      if (sortModel != null) {
        sortBy = sortModel.fieldName;
        sortDirection = sortModel.descending ? 'DESC' : 'ASC';
        sortColumnAndDirection = '$sortBy;$sortDirection';
      }

      filterStringModel = [];
      if (filterModel != null) {
        if (filterModel['stateFilter'] != null) {
          StateModel stateModel = filterModel['stateFilter'];
          filterStringModel
              .add('Filter=stateFilter:' + stateModel.id.toString());
        }
        if (filterModel['paymentTypeFilter'] != null) {
          StateModel stateModel = filterModel['paymentTypeFilter'];
          filterStringModel
              .add('Filter=paymentTypeFilter:' + stateModel.id.toString());
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

      // Set refreshing to true before data fetching
      setState(() {
        isRefreshing = true;
      });

      var response = await cartHistoryNotifier.findCartList(
          context: context,
          token: authNotifier.token,
          idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
          filter: filterStringModel);

      if (response is CartHistoryModel) {
        totalCount = response.totalCount;
        totalAmount = response.totalAmount;
        List<Map<String, dynamic>> data =
            response.CartHistoryList.map((cart) => cart.toJson()).toList();

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
      cartHistoryNotifier.setUpdate(false); // Reset the update flag

      setState(() {
        isRefreshing = false;
      });
    }
  }

  void handleDownloadCartList(BuildContext context) async {
    final reportNotifier =
        Provider.of<ReportCartNotifier>(context, listen: false);
    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authNotifier.getSelectedUserAppInstitution();

    await reportNotifier.downloadCartList(
        context: context,
        token: authNotifier.token,
        pageNumber: 1,
        pageSize: -1,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
        filter: filterStringModel);
  }

  void changeCartState(idCart, int state) async {
    var authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    await cartNotifier
        .changeCartState(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idCart: idCart,
            state: state)
        .then((value) {
      tableController.refresh();
    });
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
          'Report acquisti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
              // const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text("Export Excel"),
                onTap: () {
                  handleDownloadCartList(context);
                },
              ),
            ],
          ),
          footer: CustomTableFooter<String, Map<String, dynamic>>(
            totalItems: totalCount,
            totalAmount: totalAmount,
            controller: tableController,
          ),
          columns: [
            // RowSelectorColumn(),
            TableColumn(
              id: 'docNumberCart',
              title: const Text('#'),
              cellBuilder: (context, item, index) => SelectableText(
                  item['docNumberCart'].toString().padLeft(6, '0')),
              size: const FixedColumnSize(100),
              sortable: true,
            ),
            TableColumn(
              id: 'stateCartDescription',
              title: const Text('Stato carrello'),
              cellBuilder: (context, item, index) =>
                  SelectableText(item['stateCartDescription'].toString()),
              size: const FixedColumnSize(200),
              sortable: true,
            ),
            TableColumn(
              id: 'paymentTypeCart',
              title: const Text('Tipo pagamento'),
              cellBuilder: (context, item, index) => SelectableText(
                  item['paymentTypeCart'].toString().split('.').last),
              size: const FixedColumnSize(150),
              sortable: true,
            ),
            TableColumn(
              id: 'dateCreatedCart',
              title: const Text('Data'),
              cellBuilder: (context, item, index) => SelectableText(
                  DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(item['dateCreatedCart'], true)
                      .toString()),
              size: const FixedColumnSize(200),
              sortable: true,
            ),
            TableColumn(
              id: 'totalPriceCart',
              title: const Text('Totale'),
              cellBuilder: (context, item, index) => SelectableText(
                  item['totalPriceCart'] != null
                      ? '${item['totalPriceCart'].toStringAsFixed(2)} €'
                      : ''),
              size: const FixedColumnSize(120),
              sortable: true,
            ),
            TableColumn(
              id: 'idStakeholder',
              title: const Text('# Stakeholder'),
              cellBuilder: (context, item, index) => SelectableText(
                  item['idStakeholder'] != null
                      ? item['idStakeholder'].toString()
                      : ''),
              size: const FixedColumnSize(150),
              sortable: true,
            ),
            TableColumn(
              id: 'denominationStakeholder',
              title: const Text('Stakeholder'),
              cellBuilder: (context, item, index) => SelectableText(
                  item['denominationStakeholder'] != null
                      ? item['denominationStakeholder'].toString()
                      : ''),
              size: const FixedColumnSize(150),
              sortable: true,
            ),
            TableColumn(
              id: 'stateFiscalization',
              title: const Text('Fiscalizzazione'),
              cellBuilder: (context, item, index) {
                bool warning = item['fiscalization'] == 2;
                return Row(
                  children: [
                    warning
                        ? Tooltip(
                            message:
                                "Fattura richiesta: in attesa di essere inviata o priva di dati donatore",
                            child: Icon(
                              size: 24,
                              Icons.warning_rounded,
                              color: Colors.red,
                            ),
                          )
                        : SizedBox.shrink(),
                    warning ? SizedBox(width: 6) : SizedBox.shrink(),
                    Expanded(
                      child: Text(
                        item['stateFiscalization'].toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
              size: const FixedColumnSize(250),
              sortable: true,
            ),
            TableColumn(
              id: 'actions',
              title: const Text('Azioni'),
              cellBuilder: (context, item, index) => PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  if (item['idStakeholder'] != null)
                    PopupMenuItem<int>(
                      value: 1,
                      child: const Text('Emissione ricevuta'),
                    ),
                  if (item['idStakeholder'] == null &&
                      item['docNumberCart'] > 0)
                    PopupMenuItem<int>(
                      value: 2,
                      child: const Text('Associa donatore'),
                    ),
                  if (item['fiscalizationExternalId'] != null &&
                      [1, 3, 5, 9].contains(item['fiscalization']))
                    PopupMenuItem<int>(
                      value: 3,
                      child: const Text('Visualizza scontrino'),
                    ),
                  if (item['paymentTypeCart'].toString().isNotEmpty)
                    PopupMenuItem<int>(
                      value: 4,
                      child: const Text('Storna carrello'),
                    ),
                  if (item['paymentTypeCart'].toString().isNotEmpty)
                    PopupMenuItem<int>(
                      value: 5,
                      child: const Text('Annulla carrello'),
                    ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.of(context).pushNamed(AppRouter.shPdfInvoice,
                        arguments: item['idCart']);
                  }
                  if (value == 2) {
                    Navigator.of(context).pushNamed(AppRouter.shManage,
                        arguments: item['idCart']);
                  }
                  if (value == 3) {
                    Navigator.of(context).pushNamed(AppRouter.receiptPdf,
                        arguments: item['fiscalizationExternalId']);
                  }
                  if (value == 4) {
                    var dialog = CustomAlertDialog(
                      title: "Cambio di stato",
                      content: Text("Si desidera stornare il carrello?"),
                      yesCallBack: () {
                        changeCartState(item['idCart'], 7);
                      },
                      noCallBack: () {},
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog);
                  }
                  if (value == 5) {
                    var dialog = CustomAlertDialog(
                      title: "Cambio di stato",
                      content: Text("Si desidera annullare il carrello?"),
                      yesCallBack: () {
                        changeCartState(item['idCart'], 8);
                      },
                      noCallBack: () {},
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog);
                  }
                },
              ),
              size: const FixedColumnSize(100),
            ),
          ],
          filters: [
            CustomDropdownTableFilter<StateModel>(
              loadOptions: () async {
                final states = [
                  StateModel(id: 1, name: '1-Creato'),
                  StateModel(id: 2, name: '2-Pagato'),
                  StateModel(id: 4, name: '4-In acquisizione'),
                  StateModel(id: 5, name: '5-Acquisito'),
                  StateModel(id: 7, name: '7-Stornato'),
                  StateModel(id: 8, name: '8-Annullato'),
                  StateModel(id: 9, name: '9-Errore'),
                ];

                return states;
              },
              chipFormatter: (value) => 'Stato: ${value?.name ?? "None"}',
              id: "stateFilter",
              name: "Stato",
              onChanged: (StateModel? newValue) {
                setState(() {});
              },
              displayStringForOption: (state) => state.name,
            ),
            CustomDropdownTableFilter<StateModel>(
              loadOptions: () async {
                final states = [
                  StateModel(id: 'PaymentType.bancomat', name: 'Bancomat'),
                  StateModel(
                      id: 'PaymentType.cartaCredito', name: 'Carta di Credito'),
                  StateModel(id: 'PaymentType.contanti', name: 'Contanti'),
                  StateModel(id: 'PaymentType.assegni', name: 'Assegni'),
                ];

                return states;
              },
              chipFormatter: (value) =>
                  'Tipo pagamento: ${value?.name ?? "None"}',
              id: "paymentTypeFilter",
              name: "Tipo pagamento",
              onChanged: (StateModel? newValue) {
                setState(() {});
              },
              displayStringForOption: (state) => state.name,
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
