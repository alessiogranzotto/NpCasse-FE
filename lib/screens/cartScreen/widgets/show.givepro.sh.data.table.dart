import 'package:flutter/material.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/givepro.model.dart';
import 'package:paged_datatable/paged_datatable.dart';

class ShowGiveproShDataTable extends StatefulWidget {
  final List<StakeholderGiveproModel> snapshot;
  final double width;
  final Function callback2;

  const ShowGiveproShDataTable({
    super.key,
    required this.snapshot,
    required this.width,
    required this.callback2,
  });

  @override
  State<ShowGiveproShDataTable> createState() => _ShowGiveproShDataTableState();
}

class _ShowGiveproShDataTableState extends State<ShowGiveproShDataTable> {
  int? idRowSelected; // To track the selected row's ID
  bool editAndReceiptVisible = false;
  final PagedDataTableController<String, Map<String, dynamic>> tableController =
      PagedDataTableController();

  @override
  void initState() {
    super.initState();
  }

  // Fetch data function to be used in the PagedDataTable
  Future<(List<Map<String, dynamic>>, String?)> fetchData(
    int pageSize,
    SortModel? sortModel,
    FilterModel filterModel,
    String? pageToken,
  ) async {
    widget.callback2(null);
    List<Map<String, dynamic>> data = widget.snapshot.map((stakeholder) {
      return {
        'id': stakeholder.id,
        'name': stakeholder.ragionesociale.isNotEmpty
            ? stakeholder.ragionesociale
            : "${stakeholder.nome} ${stakeholder.cognome}",
        // 'email': stakeholder.email,
        // 'tel': stakeholder.tel,
        // 'cell': stakeholder.cell,
        // 'codfisc': stakeholder.codfisc,
        // 'address':
        //     '${stakeholder.recapitoGiveModel.indirizzo} ${stakeholder.recapitoGiveModel.nCivico} ${stakeholder.recapitoGiveModel.cap} ${stakeholder.recapitoGiveModel.citta} ${stakeholder.recapitoGiveModel.prov}',
        // 'contacts': stakeholder.contattiGiveModel.isNotEmpty ? 'C' : 'SH',
      };
    }).toList();

    String? nextPageToken = null;
    return Future.delayed(Duration(seconds: 1), () => (data, nextPageToken));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PagedDataTableTheme(
          data: PagedDataTableThemeData(
            selectedRow: Colors.blueAccent[100], // Set the selected row color
            rowColor: (index) {
              // Highlight the row if it's selected
              return idRowSelected == widget.snapshot[index].id
                  ? Colors.blueAccent[100]
                  : Colors.transparent;
            },
            cellPadding: EdgeInsets.zero, // Removes padding inside cells
            padding: EdgeInsets.zero, // Removes overall table padding
          ),
          child: PagedDataTable<String, Map<String, dynamic>>(
            controller: tableController,
            initialPageSize: 50,
            pageSizes: const [50],
            fetcher: (pageSize, sortModel, filterModel, pageToken) =>
                fetchData(pageSize, sortModel, filterModel, pageToken),
            columns: [
              // TableColumn(
              //   id: 'contacts',
              //   title: const Text(''),
              //   cellBuilder: (context, item, index) {
              //     return _buildSelectableRow(
              //       index,
              //       item['contacts'],
              //       isCircleAvatar: true,
              //     );
              //   },
              //   size: const FixedColumnSize(120),
              // ),
              TableColumn(
                id: 'id',
                title: const Text('Id'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['id'].toString());
                },
                size: const FixedColumnSize(150),
                sortable: true,
              ),
              TableColumn(
                id: 'name',
                title: const Text('Ragione sociale o nominativo'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['name']);
                },
                size: const FixedColumnSize(250),
                sortable: true,
              ),
              // TableColumn(
              //   id: 'email',
              //   title: const Text('Email'),
              //   cellBuilder: (context, item, index) {
              //     return _buildSelectableRow(index, item['email']);
              //   },
              //   size: const FixedColumnSize(300),
              //   sortable: true,
              // ),
              // TableColumn(
              //   id: 'tel',
              //   title: const Text('Telefono'),
              //   cellBuilder: (context, item, index) {
              //     return _buildSelectableRow(index, item['tel']);
              //   },
              //   size: const FixedColumnSize(150),
              //   sortable: false,
              // ),
              // TableColumn(
              //   id: 'cell',
              //   title: const Text('Cell'),
              //   cellBuilder: (context, item, index) {
              //     return _buildSelectableRow(index, item['cell']);
              //   },
              //   size: const FixedColumnSize(150),
              //   sortable: false,
              // ),
              // TableColumn(
              //   id: 'codfisc',
              //   title: const Text('Codice fiscale'),
              //   cellBuilder: (context, item, index) {
              //     return _buildSelectableRow(index, item['codfisc']);
              //   },
              //   size: const FixedColumnSize(150),
              //   sortable: false,
              // ),
              // TableColumn(
              //   id: 'address',
              //   title: const Text('Recapito'),
              //   cellBuilder: (context, item, index) {
              //     return _buildSelectableRow(index, item['address']);
              //   },
              //   size: const FixedColumnSize(350),
              //   sortable: false,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a selectable row
  Widget _buildSelectableRow(int index, String displayText,
      {bool isCircleAvatar = false, Icon? optionalIcon}) {
    bool isSelected = idRowSelected == widget.snapshot[index].id; // Check if this row is selected
    return GestureDetector(
      onTap: () {
        setState(() {
          idRowSelected = widget.snapshot[index].id;
          StakeholderGiveproModel cStakeholderGiveModel =
              widget.snapshot[index];
          widget.callback2(cStakeholderGiveModel);
          if (idRowSelected != 0) {
            editAndReceiptVisible == true;
          } else {
            editAndReceiptVisible == false;
          }
        });
      },
      child: Container(
        width: double.infinity, // Ensures it spans the entire column width
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent, // Highlight full cell
        alignment: Alignment.centerLeft, // Aligns text to the left
        child: Row(
          children: [
            // Circle Avatar (if needed)
            if (isCircleAvatar) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Text(
                  displayText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            // Text or Icon
            if (!isCircleAvatar) ...[
              if (optionalIcon != null) optionalIcon,
              Expanded( // This makes sure text spans and doesn't restrict clicks
                child: Text(
                  displayText,
                  softWrap: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
