import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/core/models/mass.sending.history.model.dart';
import 'package:np_casse/core/models/mass.sending.job.model.dart';
import 'package:np_casse/core/models/mass.sending.model.dart';
import 'package:np_casse/core/models/state.model.dart';
import 'package:np_casse/core/notifiers/report.massive.sending.notifier.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/models/cart.history.model.dart';

class MassSendingHistoryScreen extends StatefulWidget {
  const MassSendingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MassSendingHistoryScreen> createState() =>
      _MassSendingHistoryScreenState();
}

class _MassSendingHistoryScreenState extends State<MassSendingHistoryScreen> {
  final PagedDataTableController<String, Map<String, dynamic>> tableController =
      PagedDataTableController();
  bool isRefreshing = true; // Track if data is refreshing
  List<DropdownMenuItem<StateModel>> categoryDropdownItems = [];
  List<DropdownMenuItem<StateModel>> subCategoryDropdownItems = [];
  List<String> filterStringModel = [];
  String? sortBy;
  String? sortDirection;
  String sortColumnAndDirection = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ReportMassSendingNotifier reportMassSendingNotifier =
        Provider.of<ReportMassSendingNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (reportMassSendingNotifier.isUpdated && !isRefreshing) {
      // Post-frame callback to avoid infinite loop during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reportMassSendingNotifier.setUpdate(false); // Reset the update flag
        tableController.refresh();
      });
    }
  }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final reportMassSendingNotifier =
        Provider.of<ReportMassSendingNotifier>(context, listen: false);
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

      var response = await reportMassSendingNotifier.findMassSendingList(
          context: context,
          token: authNotifier.token,
          idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
          filter: filterStringModel);

      if (response is MassSendingHistoryModel) {
        List<Map<String, dynamic>> data = response.massSendingHistoryList
            .map((massSendingJob) => massSendingJob.toJson())
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
      reportMassSendingNotifier.setUpdate(false); // Reset the update flag

      setState(() {
        isRefreshing = false;
      });
    }
  }

  // void handleDownloadCartList(BuildContext context) async {
  //   final reportMassSendingNotifier =
  //       Provider.of<ReportMassSendingNotifier>(context, listen: false);
  //   var authNotifier =
  //       Provider.of<AuthenticationNotifier>(context, listen: false);
  //   UserAppInstitutionModel cUserAppInstitutionModel =
  //       authNotifier.getSelectedUserAppInstitution();

  //   await reportNotifier.downloadCartList(
  //       context: context,
  //       token: authNotifier.token,
  //       pageNumber: 1,
  //       pageSize: -1,
  //       idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
  //       orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
  //       filter: filterStringModel);
  // }

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
          'Email report ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PagedDataTableTheme(
          data: PagedDataTableThemeData(
            // selectedRow: Colors.blueAccent[100],
            //             rowColor: (index) {
            //   // Highlight the row if it's selected
            //   return idRowSelected == widget.snapshot[index].id
            //       ? Colors.blueAccent[100]
            //       : Colors.transparent;
            // },
            cellPadding: EdgeInsets.zero, // Removes padding inside cells
            padding: EdgeInsets.zero, // Removes overall table padding
          ),
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
                // PopupMenuItem(
                //   child: const Text("Export Excel"),
                //   onTap: () {
                //     handleDownloadCartList(context);
                //   },
                // ),
              ],
            ),
            columns: [
              // RowSelectorColumn(),
              TableColumn(
                id: 'dateSend',
                title: const Text('Nome comunicazione'),
                cellBuilder: (context, item, index) {
                  MassSendingModel massSendingModel =
                      item['idMassSendingNavigation'];
                  return Text(massSendingModel.nameMassSending);
                },
                size: const FixedColumnSize(250),
                sortable: true,
              ),
              TableColumn(
                id: 'dateSend',
                title: const Text('Data invio'),
                cellBuilder: (context, item, index) => item['dateSend'] != null
                    ? Text(item['dateSend'].toString())
                    : Text(''),
                size: const FixedColumnSize(250),
                sortable: true,
              ),
              TableColumn(
                id: 'emailSh',
                title: const Text('Email'),
                cellBuilder: (context, item, index) =>
                    Text(item['emailSh'].toString()),
                size: const FixedColumnSize(250),
                sortable: true,
              ),
              TableColumn(
                id: 'stateMassSendingJob',
                title: const Text('Stato comunicazione'),
                cellBuilder: (context, item, index) => Text(
                    item['stateMassSendingJob'] != null
                        ? item['stateMassSendingJob']
                        : ''),
                size: const FixedColumnSize(200),
                sortable: true,
              ),
              TableColumn(
                id: 'dateStateMassSendingJob',
                title: const Text('Data ultimo aggiornamento'),
                cellBuilder: (context, item, index) =>
                    item['dateStateMassSendingJob'] != null
                        ? Text(item['dateStateMassSendingJob'].toString())
                        : Text(''),
                size: const FixedColumnSize(250),
                sortable: true,
              ),
            ],
            filters: [
              //   id: "endDate",
              //   chipFormatter: (value) => 'A "$value"',
              //   name: "A",
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
