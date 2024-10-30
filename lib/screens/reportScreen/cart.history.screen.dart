import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/core/notifiers/report.notifier.dart';
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
  UserAppInstitutionModel? cSelectedUserAppInstitution;
  UserAppInstitutionModel? previousSelectedInstitution;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: true);
    UserAppInstitutionModel? currentInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();

    if (currentInstitution != previousSelectedInstitution) {
      setState(() {
        cSelectedUserAppInstitution = currentInstitution;
        previousSelectedInstitution = currentInstitution;
        tableController.refresh();
      });
    }
  }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final cartHistoryNotifier =
        Provider.of<ReportNotifier>(context, listen: false);
    try {
      int pageNumber = (pageToken != null) ? int.parse(pageToken) : 1;
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      // Sorting logic
      String? sortBy;
      String? sortDirection;
      String? sortColumnAndDirection = '';

      if (sortModel != null) {
        sortBy = sortModel.fieldName;
        sortDirection = sortModel.descending ? 'DESC' : 'ASC';
        sortColumnAndDirection = '$sortBy;$sortDirection';
      }

      // Date range filter logic
      DateTimeRange? dateRange = filterModel?["dateRange"];
      DateTime? startDate = dateRange?.start;
      DateTime? endDate = dateRange?.end;

      var response = await cartHistoryNotifier.findCartList(
        context: context,
        token: authNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        pageNumber: pageNumber,
        pageSize: pageSize,
        orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
        // startDate: startDate,   // Pass start date
        // endDate: endDate,       // Pass end date
      );

      if (response is CartHistoryModel) {
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
    }
  }

  void handleDownloadCartList(BuildContext context) async {
    final reportNotifier = Provider.of<ReportNotifier>(context, listen: false);
    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authNotifier.getSelectedUserAppInstitution();

    await reportNotifier.downloadCartList(
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
          'Report carrelli ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
              id: 'stateCartDescription',
              title: const Text('State'),
              cellBuilder: (context, item, index) =>
                  Text(item['stateCartDescription'].toString()),
              size: const FixedColumnSize(150),
              sortable: true,
            ),
            TableColumn(
              id: 'paymentTypeCart',
              title: const Text('Tipo pagamento'),
              cellBuilder: (context, item, index) =>
                  Text(item['paymentTypeCart'].toString().split('.').last),
              size: const FixedColumnSize(150),
              sortable: true,
            ),
            TableColumn(
              id: 'dateCreatedCart',
              title: const Text('Data'),
              cellBuilder: (context, item, index) => Text(
                  DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(item['dateCreatedCart'], true)
                      .toString()),
              size: const FixedColumnSize(170),
              sortable: true,
            ),
            TableColumn(
              id: 'totalPriceCart',
              title: const Text('Totale'),
              cellBuilder: (context, item, index) => Text(
                  item['totalPriceCart'] != null
                      ? '${item['totalPriceCart'].toStringAsFixed(2)} €'
                      : ''),
              size: const FixedColumnSize(120),
              sortable: true,
            ),
            TableColumn(
              id: 'idStakeholder',
              title: const Text('# Stakeholder'),
              cellBuilder: (context, item, index) => Text(
                  item['idStakeholder'] != null
                      ? item['idStakeholder'].toString()
                      : ''),
              size: const FixedColumnSize(150),
              sortable: true,
            ),
            TableColumn(
              id: 'denominationStakeholder',
              title: const Text('Stakeholder'),
              cellBuilder: (context, item, index) => Text(
                  item['denominationStakeholder'] != null
                      ? item['denominationStakeholder'].toString()
                      : ''),
              size: const FixedColumnSize(150),
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
                ],
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.of(context).pushNamed(AppRouter.shPdfInvoice,
                        arguments: item['idCart']);
                  }
                },
              ),
              size: const FixedColumnSize(100),
            ),
          ],
          filters: [
            DateRangePickerTableFilter(
              id: "dateRange",
              name: "",
              chipFormatter: (range) =>
                  "From ${DateFormat("yyyy-MM-dd").format(range.start)} to ${DateFormat("yyyy-MM-dd").format(range.end)}",
              firstDate: DateTime(DateTime.now().year - 5, 1,
                  1), // Start from January last year
              lastDate: DateTime.now(),
              initialValue: null, // No default selection
              formatter: (range) =>
                  "${DateFormat("yyyy-MM-dd").format(range.start)} - ${DateFormat("yyyy-MM-dd").format(range.end)}",
            ),
          ],
        ),
      ),
    );
  }
}

class DateRangePickerTableFilter extends TableFilter<DateTimeRange> {
  final String id;
  final String name;
  final DateTime firstDate;
  final DateTime lastDate;
  final String Function(DateTimeRange) chipFormatter;
  final String Function(DateTimeRange) formatter;

  const DateRangePickerTableFilter({
    required this.id,
    required this.name,
    required this.chipFormatter,
    required this.firstDate,
    required this.lastDate,
    DateTimeRange? initialValue, // Allow for initial value
    required this.formatter,
    super.enabled = true,
  }) : super(
            initialValue: initialValue,
            id: id,
            name: name,
            chipFormatter:
                chipFormatter); // Pass required parameters to superclass

  @override
  Widget buildPicker(BuildContext context, FilterState<DateTimeRange> state) {
    return TextButton(
      onPressed: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: firstDate,
          lastDate: lastDate,
          initialDateRange: state.value ?? initialValue,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.blueAccent, // <-- SEE HERE
                  onPrimary: Colors.white, // <-- SEE HERE
                  onSurface: Colors.blueAccent, // <-- SEE HERE
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent, // button text color
                  ),
                ),
              ),
              child: child ?? const SizedBox(),
            );
          },
        );

        if (picked != null &&
            picked !=
                DateTimeRange(start: DateTime.now(), end: DateTime.now())) {
          state.value = picked; // Update the selected date range
        }
      },
      child: Text(
        state.value == null
            ? 'Select date range'
            : chipFormatter(state.value!), // Format the chip text
      ),
    );
  }
}
