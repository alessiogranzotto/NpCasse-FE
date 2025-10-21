import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/app/constants/functional.dart';
import 'package:np_casse/app/routes/app_routes.dart';

import 'package:np_casse/componenents/custom.table.footer.dart';
import 'package:np_casse/componenents/table.filter.dart';
import 'package:np_casse/core/models/myosotis.donation.history.model.dart';
import 'package:np_casse/core/models/myosotis.donation.model.dart';
import 'package:np_casse/core/models/state.model.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/report.cart.notifier.dart';
import 'package:np_casse/core/notifiers/report.myosotis.donation.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';

class MyosotisDonationHistoryScreen extends StatefulWidget {
  const MyosotisDonationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MyosotisDonationHistoryScreen> createState() =>
      _MyosotisDonationHistoryScreenState();
}

class _MyosotisDonationHistoryScreenState
    extends State<MyosotisDonationHistoryScreen> {
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
  bool showAllColumns = false;

  List<ReadOnlyTableColumn<String, Map<String, dynamic>>> getAllColumns() {
    return [
      TableColumn(
        id: 'finalizeAction',
        title: const Text(''),
        cellBuilder: (context, item, index) {
          if (item['stateDescription']?.toString() == '0-Pending') {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min, // riduce larghezza al minimo
                children: [
                  IconButton(
                    onPressed: () {
                      final currentMyosotisDonationModel =
                          MyosotisDonationModel.fromJson(item);
                      Navigator.of(context).pushNamed(
                          AppRouter.myosotisDonationFinalizeRoute,
                          arguments: currentMyosotisDonationModel);
                    },
                    icon: const Icon(Icons.account_balance),
                    tooltip: 'Finalizza donazione',
                    color: CustomColors.darkBlue,
                    padding: EdgeInsets.zero, // rimuove padding extra
                    constraints:
                        const BoxConstraints(), // riduce lo spazio extra
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        size: const FixedColumnSize(72),
        sortable: false,
      ),
      TableColumn(
        id: 'idMyosotisFormData',
        title: const Text('#'),
        cellBuilder: (context, item, index) => SelectableText(
            item['idMyosotisFormData'].toString().padLeft(6, '0')),
        size: const FixedColumnSize(100),
        sortable: true,
      ),
      TableColumn(
        id: 'nameMyosotisConfiguration',
        title: const Text('Nome configurazione'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['nameMyosotisConfiguration']),
        size: const FixedColumnSize(300),
        sortable: true,
      ),
      TableColumn(
        id: 'stateDescription',
        title: const Text('Stato'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['stateDescription'].toString()),
        size: const FixedColumnSize(150),
        sortable: true,
      ),
      TableColumn(
        id: 'dateDonation',
        title: const Text('Data donazione'),
        cellBuilder: (context, item, index) {
          return SelectableText(
              DateFormat('yyyy-MM-dd HH:mm:ss').format(item['dateDonation']));
        },
        size: const FixedColumnSize(200),
        sortable: true,
      ),
      TableColumn(
        id: 'amountDonation',
        title: const Text('Importo donazione'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['amountDonation'].toStringAsFixed(2)),
        size: const FixedColumnSize(200),
        sortable: true,
      ),
      TableColumn(
        id: 'paymentType',
        title: const Text('Tipo pagamento'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['paymentType'].toString().split('.').last),
        size: const FixedColumnSize(150),
        sortable: true,
      ),
      TableColumn(
        id: 'name-surname-businessName',
        title: const Text('Nominativo'),
        cellBuilder: (context, item, index) => SelectableText(
            (item['businessName'].toString()).isNotEmpty
                ? item['businessName'].toString()
                : item['name'].toString() + ' ' + item['surname'].toString()),
        size: const FixedColumnSize(200),
        sortable: true,
      ),
      TableColumn(
        id: 'cf',
        title: const Text('CF/PIVA'),
        cellBuilder: (context, item, index) => SelectableText(item['cf'] != null
            ? item['cf'].toString()
            : item['piva'].toString()),
        size: const FixedColumnSize(200),
        sortable: false,
      ),
      TableColumn(
        id: 'email',
        title: const Text('Email'),
        cellBuilder: (context, item, index) => SelectableText(item['email']),
        size: const FixedColumnSize(300),
        sortable: true,
      ),
      TableColumn(
        id: 'phone',
        title: const Text('Telefono'),
        cellBuilder: (context, item, index) => SelectableText(item['phone']),
        size: const FixedColumnSize(200),
        sortable: false,
      ),
      TableColumn(
        id: 'mobile',
        title: const Text('Cellulare'),
        cellBuilder: (context, item, index) => SelectableText(item['mobile']),
        size: const FixedColumnSize(200),
        sortable: false,
      ),
      TableColumn(
        id: 'externalIdPayment1',
        title: const Text('Id pagamento'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['externalIdPayment1']),
        size: const FixedColumnSize(200),
        sortable: false,
      ),
      TableColumn(
        id: 'externalIdPayment2',
        title: const Text('Id sottoscrizione'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['externalIdPayment2']),
        size: const FixedColumnSize(200),
        sortable: false,
      ),

      // TableColumn(
      //   id: 'idGive',
      //   title: const Text('Id give'),
      //   cellBuilder: (context, item, index) => SelectableText(item['idGive']),
      //   size: const FixedColumnSize(2000),
      //   sortable: false,
      // ),
      TableColumn(
        id: 'typeDonation',
        title: const Text('Tipo donazione'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['typeDonation']),
        size: const FixedColumnSize(150),
        sortable: false,
      ),
      TableColumn(
        id: 'frequency',
        title: const Text('Frequenza donazione'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['frequency']),
        size: const FixedColumnSize(200),
        sortable: false,
      ),
      // TableColumn(
      //   id: 'currency',
      //   title: const Text('Valuta'),
      //   cellBuilder: (context, item, index) =>
      //       SelectableText(item['currency']),
      //   size: const FixedColumnSize(100),
      //   sortable: false,
      // ),
      TableColumn(
        id: 'optionalField',
        title: const Text('Dati opzionali'),
        cellBuilder: (context, item, index) =>
            SelectableText(item['optionalField']),
        size: const FixedColumnSize(2000),
        sortable: false,
      ),
      TableColumn(
        id: 'actions',
        title: const Text('Azioni'),
        cellBuilder: (context, item, index) => PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            if (item['stateDescription']?.toString() == '0-Pending')
              PopupMenuItem<int>(
                value: 1,
                child: const Text('Finalizza donazione'),
              ),
          ],
          onSelected: (value) {
            if (value == 1) {
              final currentMyosotisDonationModel =
                  MyosotisDonationModel.fromJson(item);
              Navigator.of(context).pushNamed(
                  AppRouter.myosotisDonationFinalizeRoute,
                  arguments: currentMyosotisDonationModel);
            }
          },
        ),
        size: const FixedColumnSize(100),
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ReportMyosotisDonationNotifier reportMyosotisDonationNotifier =
        Provider.of<ReportMyosotisDonationNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (reportMyosotisDonationNotifier.isUpdated && !isRefreshing) {
      // Post-frame callback to avoid infinite loop during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reportMyosotisDonationNotifier
            .setUpdate(false); // Reset the update flag
        tableController.refresh();
      });
    }
  }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final reportMyosotisDonationNotifier =
        Provider.of<ReportMyosotisDonationNotifier>(context, listen: false);
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
        sortColumnAndDirection = '$sortBy:::$sortDirection';
      }

      filterStringModel = [];
      if (filterModel != null) {
        if (filterModel['stateFilter'] != null) {
          StateModel stateModel = filterModel['stateFilter'];
          filterStringModel
              .add('Filter=stateFilter:::' + stateModel.id.toString());
        }
        if (filterModel['paymentTypeFilter'] != null) {
          PaymentType stateModel = filterModel['paymentTypeFilter'];
          filterStringModel
              .add('Filter=paymentTypeFilter:::' + stateModel.toString());
        }
        if (filterModel['startDate'] != null) {
          String cStartDate = filterModel['startDate'];
          filterStringModel.add('Filter=startDate:::' + cStartDate);
        }
        if (filterModel['endDate'] != null) {
          String cEndDate = filterModel['endDate'];
          filterStringModel.add('Filter=endDate:::' + cEndDate);
        }
        if (filterModel['nameMyosotisConfiguration'] != null) {
          String nameMyosotisConfiguration =
              filterModel['nameMyosotisConfiguration'];
          filterStringModel.add('Filter=nameMyosotisConfiguration:::' +
              nameMyosotisConfiguration);
        }
      }

      // Set refreshing to true before data fetching
      setState(() {
        isRefreshing = true;
      });

      var response =
          await reportMyosotisDonationNotifier.findMyosotisDonationList(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              pageNumber: pageNumber,
              pageSize: pageSize,
              orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
              filter: filterStringModel);

      if (response is MyosotisDonationHistoryModel) {
        totalCount = response.totalCount;
        totalAmount = response.totalAmount;
        List<Map<String, dynamic>> data = response.myosotisDonationHistoryList
            .map((cart) => cart.toJson())
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
      reportMyosotisDonationNotifier.setUpdate(false); // Reset the update flag

      setState(() {
        isRefreshing = false;
      });
    }
  }

  void handleDownloadDonationList(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    final columns = showAllColumns
        ? getAllColumns()
        : getAllColumns().where((col) {
            const visibleIds = [
              'finalizeAction',
              'name-surname-businessName',
              'typeDonation',
              'idMyosotisFormData',
              'nameMyosotisConfiguration',
              'stateDescription',
              'dateDonation',
              'amountDonation',
              'paymentType',
              'actions'
            ];
            return visibleIds.contains(col.id);
          }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Report donazioni ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
          filterBarChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: showAllColumns,
                    onChanged: (value) {
                      setState(() {
                        showAllColumns = value ?? false;
                      });
                    },
                  ),
                  const Text("Mostra tutte le colonne"),
                ],
              ),
              SizedBox(width: 32),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_outlined),
                onSelected: (value) {
                  if (value == 'export_excel') {
                    handleDownloadDonationList(context);
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'export_excel',
                    child: Text("Export Excel"),
                  ),
                ],
              ),
            ],
          ),
          footer: CustomTableFooter<String, Map<String, dynamic>>(
            totalItems: totalCount,
            totalAmount: totalAmount,
            controller: tableController,
          ),
          columns: columns,
          filters: [
            CustomDropdownTableFilter<StateModel>(
              loadOptions: () async {
                final states = [
                  StateModel(id: 0, name: '0-Pending'),
                  StateModel(id: 1, name: '1-Creato'),
                  StateModel(id: 2, name: '2-Acquisito'),
                  StateModel(id: 3, name: '3-Ringraziato'),
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
            CustomDropdownTableFilter<PaymentType>(
              loadOptions: () async => PaymentType.values,
              chipFormatter: (value) =>
                  'Pagamento: ${value?.name ?? "Nessuno"}',
              id: "paymentTypeFilter",
              name: "Tipo di pagamento",
              displayStringForOption: (e) => e.name,
              onChanged: (PaymentType? newValue) {
                setState(() {});
              },
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
            StringTextTableFilter(
              id: "nameMyosotisConfiguration",
              chipFormatter: (value) => "Nome configurazione myosotis: $value",
              name: "Nome configurazione myosotis",
            ),
          ],
        ),
      ),
    );
  }
}
