import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.table.footer.dart';
import 'package:np_casse/componenents/table.filter.dart';
import 'package:np_casse/core/models/comunication.model.dart';
import 'package:np_casse/core/models/mass.sending.job.model.dart';
import 'package:np_casse/core/models/state.model.dart';
import 'package:np_casse/core/models/transactional.sending.history.model.dart';
import 'package:np_casse/core/notifiers/report.transactional.sending.notifier.dart';
import 'package:np_casse/screens/comunicationSendingScreen/comunication.sending.utility.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';

class TransactionalSendingHistoryScreen extends StatefulWidget {
  const TransactionalSendingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionalSendingHistoryScreen> createState() =>
      _TransactionalSendingHistoryScreenState();
}

class _TransactionalSendingHistoryScreenState
    extends State<TransactionalSendingHistoryScreen> {
  final PagedDataTableController<String, Map<String, dynamic>> tableController =
      PagedDataTableController();
  bool isRefreshing = true; // Track if data is refreshing
  List<String> filterStringModel = [];
  String? sortBy;
  String? sortDirection;
  String sortColumnAndDirection = '';
  int totalCount = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ReportTransactionalSendingNotifier reportTransactionalSendingNotifier =
        Provider.of<ReportTransactionalSendingNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (reportTransactionalSendingNotifier.isUpdated && !isRefreshing) {
      // Post-frame callback to avoid infinite loop during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reportTransactionalSendingNotifier
            .setUpdate(false); // Reset the update flag
        tableController.refresh();
      });
    }
  }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final reportTransactionalSendingNotifier =
        Provider.of<ReportTransactionalSendingNotifier>(context, listen: false);
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

        if (filterModel['transactionalSendingModelNameComunication'] != null) {
          String transactionalSendingModelNameComunication =
              filterModel['transactionalSendingModelNameComunication'];
          filterStringModel.add(
              'Filter=transactionalSendingModelNameComunication:' +
                  transactionalSendingModelNameComunication);
        }
        if (filterModel['denominationSh'] != null) {
          String denominationSh = filterModel['denominationSh'];
          filterStringModel.add('Filter=denominationSh:' + denominationSh);
        }
        if (filterModel['emailSh'] != null) {
          String emailSh = filterModel['emailSh'];
          filterStringModel.add('Filter=emailSh:' + emailSh);
        }
      }

      // Set refreshing to true before data fetching
      setState(() {
        isRefreshing = true;
      });

      var response =
          await reportTransactionalSendingNotifier.findTransactionalSendingList(
              context: context,
              token: authNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              pageNumber: pageNumber,
              pageSize: pageSize,
              orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
              filter: filterStringModel);

      if (response is TransactionalSendingHistoryModel) {
        totalCount = response.totalCount;
        List<Map<String, dynamic>> data =
            response.TransactionalSendingHistoryList.map(
                (TransactionalSendingJob) =>
                    TransactionalSendingJob.toJson()).toList();

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
      reportTransactionalSendingNotifier
          .setUpdate(false); // Reset the update flag

      setState(() {
        isRefreshing = false;
      });
    }
  }

  void handleDownloadTransactionalSendingHistoryList(
      BuildContext context) async {
    final reportTransactionalSendingNotifier =
        Provider.of<ReportTransactionalSendingNotifier>(context, listen: false);
    var authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    await reportTransactionalSendingNotifier.downloadTransactionalSendingList(
        context: context,
        token: authenticationNotifier.token,
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
          'Report transazionali ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
                PopupMenuItem(
                  child: const Text("Export Excel"),
                  onTap: () {
                    handleDownloadTransactionalSendingHistoryList(context);
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
                id: 'transactionSendingModelNameComunication',
                title: const Text('Transazionale'),
                cellBuilder: (context, item, index) {
                  return Text(item['transactionSendingModelNameComunication']);
                },
                size: const FixedColumnSize(200),
                sortable: true,
              ),
              TableColumn(
                id: 'dateSend',
                title: const Text('Data invio'),
                cellBuilder: (context, item, index) => item['dateSend'] != null
                    ? Text(item['dateSend'].toString())
                    : Text(''),
                size: const FixedColumnSize(200),
                sortable: true,
              ),
              TableColumn(
                id: 'idStakeholder',
                title: const Text('Id Stakeholder'),
                cellBuilder: (context, item, index) =>
                    Text(item['idStakeholder'].toString()),
                size: const FixedColumnSize(250),
                sortable: false,
              ),
              TableColumn(
                id: 'denominationStakeholder',
                title: const Text('Destinatario'),
                cellBuilder: (context, item, index) =>
                    Text(item['denominationStakeholder'].toString()),
                size: const FixedColumnSize(250),
                sortable: true,
              ),
              TableColumn(
                id: 'emailStakeholder',
                title: const Text('Email destinatario'),
                cellBuilder: (context, item, index) =>
                    Text(item['emailStakeholder'].toString()),
                size: const FixedColumnSize(250),
                sortable: true,
              ),
              TableColumn(
                id: 'webhooksEvent',
                title: const Text('Eventi comunicazione'),
                cellBuilder: (context, item, index) {
                  List<WebhooksEvent> webhooksEvent = item['webhooksEvent'];
                  if (webhooksEvent.isEmpty) {
                    return Text('');
                  } else {
                    webhooksEvent
                        .sort((a, b) => b.dateUpdate.compareTo(a.dateUpdate));
                    var firstwebhooksEvent = webhooksEvent.first;
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Tooltip(
                          message: firstwebhooksEvent.event,
                          child: CircleAvatar(
                            radius: 8, // Imposta il raggio dell'avatar
                            backgroundColor:
                                ComunicationSendingUtility.getWebhooksColor(
                                    firstwebhooksEvent
                                        .event), // Immagine dell'avatar
                          ),
                        ),
                      ),
                    );
                  }
                },
                size: const FixedColumnSize(150),
                sortable: false,
              ),
              TableColumn(
                id: 'dateLastUpdate',
                title: const Text('Data ultimo aggiornamento'),
                cellBuilder: (context, item, index) =>
                    item['dateLastUpdate'] != null
                        ? Text(item['dateLastUpdate'].toString())
                        : Text(''),
                size: const FixedColumnSize(250),
                sortable: false,
              ),
              TableColumn(
                id: 'actions',
                title: const Text('Azioni'),
                cellBuilder: (context, item, index) => PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    if (item['dateLastUpdate'] != null)
                      PopupMenuItem<int>(
                        value: 1,
                        child: const Text('Visualizza stati'),
                      ),
                  ],
                  onSelected: (value) {
                    if (value == 1) {
                      ComunicationModelForEventDetail
                          comunicationModelForEventDetail =
                          ComunicationModelForEventDetail(
                        emailSh: item['emailStakeholder'].toString(),
                        emailId: item['emailId'].toString(),
                        webhooksEvent: item['webhooksEvent'],
                        dateLastUpdate: item['dateLastUpdate'],
                      );

                      Navigator.of(context).pushNamed(
                          AppRouter.transactionalSendingEventDetailRoute,
                          arguments: comunicationModelForEventDetail);
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
                    StateModel(id: 'Email processed', name: 'Email processed'),
                    StateModel(id: 'Bounced soft', name: 'Bounced soft'),
                    StateModel(id: 'Bounced hard', name: 'Bounced hard'),
                    StateModel(id: 'Rejected', name: 'Rejected'),
                    StateModel(id: 'Marked as spam', name: 'Marked as spam'),
                    StateModel(
                        id: 'Delivered to recipient',
                        name: 'Delivered to recipient'),
                    StateModel(
                        id: 'Unsubscribed/Resuscribed',
                        name: 'Unsubscribed/Resuscribed'),
                    StateModel(
                        id: 'Opened by recipient', name: 'Opened by recipient'),
                    StateModel(
                        id: 'Link clicked by recipient',
                        name: 'Link clicked by recipient'),
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
                id: "transactionalSendingModelNameComunication",
                chipFormatter: (value) => "Transazionale: $value",
                name: "Transazionale",
              ),
              StringTextTableFilter(
                id: "denominationSh",
                chipFormatter: (value) => "Destinatario: $value",
                name: "Destinatario",
              ),
              StringTextTableFilter(
                id: "emailSh",
                chipFormatter: (value) => "Email destinatario: $value",
                name: "Email destinatario",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
