import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:np_casse/componenents/custom.table.footer.dart';
import 'package:np_casse/componenents/table.filter.dart';
import 'package:np_casse/core/models/myosotis.access.history.model.dart';
import 'package:np_casse/core/models/state.model.dart';
import 'package:np_casse/core/notifiers/report.myosotis.access.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';

class MyosotisAccessHistoryScreen extends StatefulWidget {
  const MyosotisAccessHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MyosotisAccessHistoryScreen> createState() =>
      _MyosotisAccessHistoryScreenState();
}

class _MyosotisAccessHistoryScreenState
    extends State<MyosotisAccessHistoryScreen> {
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
    ReportMyosotisAccessNotifier reportMyosotisAccessNotifier =
        Provider.of<ReportMyosotisAccessNotifier>(context);
    // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
    if (reportMyosotisAccessNotifier.isUpdated && !isRefreshing) {
      // Post-frame callback to avoid infinite loop during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reportMyosotisAccessNotifier.setUpdate(false); // Reset the update flag
        tableController.refresh();
      });
    }
  }

  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final reportMyosotisAccessNotifier =
        Provider.of<ReportMyosotisAccessNotifier>(context, listen: false);
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
        if (filterModel['startDate'] != null) {
          String cStartDate = filterModel['startDate'];
          filterStringModel.add('Filter=startDate:::' + cStartDate);
        }
        if (filterModel['endDate'] != null) {
          String cEndDate = filterModel['endDate'];
          filterStringModel.add('Filter=endDate:::' + cEndDate);
        }
      }

      // Set refreshing to true before data fetching
      setState(() {
        isRefreshing = true;
      });

      var response = await reportMyosotisAccessNotifier.findMyosotisAccessList(
          context: context,
          token: authNotifier.token,
          idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
          filter: filterStringModel);

      if (response is MyosotisAccessHistoryModel) {
        totalCount = response.totalCount;
        totalAmount = response.totalAmount;
        List<Map<String, dynamic>> data = response.myosotisAccessHistoryList
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
      reportMyosotisAccessNotifier.setUpdate(false); // Reset the update flag

      setState(() {
        isRefreshing = false;
      });
    }
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
          'Report accessi ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
          footer: CustomTableFooter<String, Map<String, dynamic>>(
            totalItems: totalCount,
            totalAmount: totalAmount,
            controller: tableController,
          ),
          columns: [
            TableColumn(
              id: 'shortMessage',
              title: const Text('Request from'),
              cellBuilder: (context, item, index) =>
                  SelectableText(item['shortMessage']),
              size: const FixedColumnSize(400),
              sortable: false,
            ),
            TableColumn(
              id: 'dateIns',
              title: const Text('Data accesso'),
              cellBuilder: (context, item, index) {
                final dateStr = item['dateIns'] as String;
                final parsedDate = DateTime.tryParse(dateStr);
                final formatted = parsedDate != null
                    ? DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(parsedDate.toLocal())
                    : 'Invalid date';

                return SelectableText(formatted);
              },
              size: const FixedColumnSize(200),
              sortable: false,
            ),
          ],
          filters: [
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
