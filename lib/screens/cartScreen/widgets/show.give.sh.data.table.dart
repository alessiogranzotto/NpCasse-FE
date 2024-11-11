import 'package:flutter/material.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:paged_datatable/paged_datatable.dart';

class ShowGiveShDataTable extends StatefulWidget {
  final List<StakeholderGiveModelSearch> snapshot;
  final double width;
  final Function callback2;

  const ShowGiveShDataTable({
    super.key,
    required this.snapshot,
    required this.width,
    required this.callback2,
  });

  @override
  State<ShowGiveShDataTable> createState() => _ShowGiveShDataTableState();
}

class _ShowGiveShDataTableState extends State<ShowGiveShDataTable> {
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
        'email': stakeholder.email,
        'tel': stakeholder.tel,
        'cell': stakeholder.cell,
        'codfisc': stakeholder.codfisc,
        'address': '${stakeholder.recapitoGiveModel.indirizzo} ${stakeholder.recapitoGiveModel.nCivico} ${stakeholder.recapitoGiveModel.cap} ${stakeholder.recapitoGiveModel.citta} ${stakeholder.recapitoGiveModel.prov}',
        'contacts': stakeholder.contattiGiveModel.isNotEmpty ? 'C' : 'SH',
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
          ),
          child: PagedDataTable<String, Map<String, dynamic>>(
            controller: tableController,
            initialPageSize: 50,
            pageSizes: const [50],
            fetcher: (pageSize, sortModel, filterModel, pageToken) =>
                fetchData(pageSize, sortModel, filterModel, pageToken),
            columns: [
              TableColumn(
                id: 'contacts',
                title: const Text(''),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(
                    index,
                    item['contacts'],
                    isCircleAvatar: true,
                  );
                },
                size: const FixedColumnSize(120),
              ),
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
              TableColumn(
                id: 'email',
                title: const Text('Email'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['email']);
                },
                size: const FixedColumnSize(300),
                sortable: true,
              ),
              TableColumn(
                id: 'tel',
                title: const Text('Telefono'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['tel']);
                },
                size: const FixedColumnSize(150),
                sortable: false,
              ),
              TableColumn(
                id: 'cell',
                title: const Text('Cell'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['cell']);
                },
                size: const FixedColumnSize(150),
                sortable: false,
              ),
              TableColumn(
                id: 'codfisc',
                title: const Text('Codice fiscale'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['codfisc']);
                },
                size: const FixedColumnSize(150),
                sortable: false,
              ),
              TableColumn(
                id: 'address',
                title: const Text('Recapito'),
                cellBuilder: (context, item, index) {
                  
                  return _buildSelectableRow(index, item['address']);
                },
                size: const FixedColumnSize(350),
                sortable: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

 // Helper method to build a selectable row
  Widget _buildSelectableRow(int index, String displayText, {bool isCircleAvatar = false,
  Icon? optionalIcon}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          idRowSelected = widget.snapshot[index].id;
          StakeholderGiveModelSearch cStakeholderGiveModel = widget.snapshot[index];
          widget.callback2(cStakeholderGiveModel);
          if (idRowSelected != 0) {
              editAndReceiptVisible == true;
          } else {
              editAndReceiptVisible == false;
          }
        });
      },
      child: Container(
          height: 40, // Make sure to define a consistent row height
          child: Row(
            children: [
              if (isCircleAvatar) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(displayText, style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
                SizedBox(width: 8),
              ],
              // Add Text only if CircleAvatar is not being displayed
          if (!isCircleAvatar) ...[
            if (optionalIcon != null) ...[
              optionalIcon,
            ],
            Expanded(child: Text(displayText)),
            ],
            ],
          ),
      ),
    );
  }
}

class ShowGiveShDataTableDeduplica extends StatefulWidget {
  final List<StakeholderDeduplicaResult> snapshot;
  final double width;
  final Function stakeholderDeduplicaSelected;
  
  const ShowGiveShDataTableDeduplica({
    Key? key,
    required this.snapshot,
    required this.width,
    required this.stakeholderDeduplicaSelected,
  }) : super(key: key);

  @override
  State<ShowGiveShDataTableDeduplica> createState() => _ShowGiveShDataTableDeduplica();
}

class _ShowGiveShDataTableDeduplica extends State<ShowGiveShDataTableDeduplica> {
  int? idRowSelected; // To track the selected row's ID
  bool editAndReceiptVisible = false;
  final PagedDataTableController<String, Map<String, dynamic>> tableController =
      PagedDataTableController();

  @override
  void initState() {
    super.initState();
  }

Future<(List<Map<String, dynamic>>, String?)> fetchData(
  int pageSize,
  SortModel? sortModel,
  FilterModel filterModel,
  String? pageToken,
) async {
  widget.stakeholderDeduplicaSelected(null);

  // Mapping data from the snapshot
  List<Map<String, dynamic>> data = widget.snapshot.map((stakeholderDeduplicaResult) {
    // Ensure we access 'id' from 'stakeholderGiveModelSearch'
    var stakeholder = stakeholderDeduplicaResult.stakeholderGiveModelSearch;
    
    return {
      'id': stakeholder.id, // Accessing 'id' from the nested StakeholderGiveModelSearch
      'name': stakeholder.ragionesociale.isNotEmpty
          ? stakeholder.ragionesociale
          : "${stakeholder.nome} ${stakeholder.cognome}",
      'email': stakeholder.email,
      'tel': stakeholder.tel,
      'cell': stakeholder.cell,
      'codfisc': stakeholder.codfisc,
      'contacts': stakeholder.contattiGiveModel.isNotEmpty ? 'C' : 'SH',
      'address': '${stakeholder.recapitoGiveModel.indirizzo} ${stakeholder.recapitoGiveModel.nCivico} ${stakeholder.recapitoGiveModel.cap} ${stakeholder.recapitoGiveModel.citta} ${stakeholder.recapitoGiveModel.prov}',
    };
  }).toList();

  String? nextPageToken = null;
  return Future.delayed(Duration(seconds: 1), () => (data, nextPageToken));
}


  // Helper method to build a selectable row
  Widget _buildSelectableRow(int index, String displayText, {bool isCircleAvatar = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          idRowSelected = widget.snapshot[index].stakeholderGiveModelSearch.id;
          StakeholderGiveModelSearch cStakeholderGiveModel = widget.snapshot[index].stakeholderGiveModelSearch;
          widget.stakeholderDeduplicaSelected(cStakeholderGiveModel);
          editAndReceiptVisible = idRowSelected != 0;
        });
      },
      child: Container(
        height: 40, // Define a consistent row height
        child: Row(
          children: [
            if (isCircleAvatar) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(displayText, style: Theme.of(context).textTheme.bodySmall),
                ),
              ),
              SizedBox(width: 8),
            ],
            if (!isCircleAvatar) ...[
              Expanded(child: Text(displayText)),
            ],
          ],
        ),
      ),
    );
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
              return idRowSelected == widget.snapshot[index].stakeholderGiveModelSearch.id
                  ? Colors.blueAccent[100]
                  : Colors.transparent;
            },
          ),
          child: PagedDataTable<String, Map<String, dynamic>>(
            controller: tableController,
            initialPageSize: 50,
            pageSizes: const [50],
            fetcher: (pageSize, sortModel, filterModel, pageToken) =>
                fetchData(pageSize, sortModel, filterModel, pageToken),
            columns: [
              TableColumn(
                id: 'contacts',
                title: const Text(''),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(
                    index,
                    item['contacts'],
                    isCircleAvatar: true,
                  );
                },
                size: const FixedColumnSize(120),
              ),
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
              TableColumn(
                id: 'email',
                title: const Text('Email'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['email']);
                },
                size: const FixedColumnSize(300),
                sortable: true,
              ),
              TableColumn(
                id: 'tel',
                title: const Text('Telefono'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['tel']);
                },
                size: const FixedColumnSize(150),
                sortable: false,
              ),
              TableColumn(
                id: 'cell',
                title: const Text('Cell'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['cell']);
                },
                size: const FixedColumnSize(150),
                sortable: false,
              ),
              TableColumn(
                id: 'codfisc',
                title: const Text('Codice fiscale'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['codfisc']);
                },
                size: const FixedColumnSize(150),
                sortable: false,
              ),
              TableColumn(
                id: 'address',
                title: const Text('Recapito'),
                cellBuilder: (context, item, index) {
                  return _buildSelectableRow(index, item['address']);
                },
                size: const FixedColumnSize(350),
                sortable: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//   DataTable _createDataTable() {
//     return DataTable(
//       dataRowMinHeight: 40, // new property
//       dataRowMaxHeight: double.infinity, // new property
//       dataRowColor: MaterialStateProperty.resolveWith<Color?>(
//           (Set<MaterialState> states) {
//         // if (states.contains(MaterialState.focused)) {
//         //   return Colors.red;
//         // }
//         // if (states.contains(MaterialState.hovered)) {
//         //   return Colors.blue[100];
//         // }
//         // // if (states.contains(MaterialState.pressed)) {
//         // //   return Colors.yellow;
//         // // }
//         if (states.contains(MaterialState.selected)) {
//           return Colors.blueAccent[100];
//         }
//         return null; // Use the default value.
//       }),
//       columnSpacing: 10,
//       showCheckboxColumn: false,
//       columns: _createColumns(widget.snapshot, widget.width),
//       rows: _createRows(widget.snapshot, widget.width),
//       // sortColumnIndex: _currentSortColumn,
//       // sortAscending: _isSortAsc,
//       dividerThickness: 2,
//       showBottomBorder: true,
//       // headingTextStyle:
//       //     const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//       // headingRowColor:
//       //     MaterialStateProperty.resolveWith((states) => Colors.blueAccent),
//     );
//   }

//   List<DataColumn> _createColumns(
//       List<StakeholderGiveModelSearch> snapshot, double width) {
//     if (width > 1200) {
//       return [
//         const DataColumn(
//           label: Flexible(
//             child: Text(''),
//           ),
//         ),
//         const DataColumn(
//           label: Flexible(
//             child: Text('Id'),
//           ),
//         ),
//         const DataColumn(
//           label: Flexible(
//             child: Text('Ragione sociale o nominativo',
//                 maxLines: 2, overflow: TextOverflow.ellipsis),
//           ),
//         ),
//         const DataColumn(
//           label: Text('Email'),
//         ),
//         const DataColumn(
//           label: Text('Telefono'),
//         ),
//         const DataColumn(
//           label: Text('Cellulare'),
//         ),
//         const DataColumn(
//           label: Text('Codice fiscale'),
//         ),
//         const DataColumn(
//           label: Text('Recapito'),
//         ),
//       ];
//     } else {
//       return [
//         const DataColumn(
//           label: Flexible(
//             child: Text(''),
//           ),
//         ),
//         DataColumn(
//           label: SizedBox(
//             width: width * 0.20,
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Ragione sociale o nominativo',
//                     maxLines: 2, overflow: TextOverflow.ellipsis),
//                 Text('Codice fiscale'),
//                 Text('Id')
//               ],
//             ),
//           ),
//         ),
//         DataColumn(
//           label: SizedBox(
//             width: width * 0.30,
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [Text('Email'), Text('Telefono'), Text('Cellulare')],
//             ),
//           ),
//         ),
//         DataColumn(
//           label: SizedBox(
//             width: width * 0.35,
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Recapito'),
//               ],
//             ),
//           ),
//         ),
//       ];
//     }
//   }

//   List<DataRow> _createRows(
//       List<StakeholderGiveModelSearch> snapshot, double width) {
//     if (width > 1200) {
//       return List.generate(
//         snapshot.length,
//         (index) {
//           StakeholderGiveModelSearch cStakeholderGiveModel = snapshot[index];
//           bool haveContacts =
//               cStakeholderGiveModel.contattiGiveModel.isNotEmpty;
//           String ragSocialeONomeCognome = cStakeholderGiveModel
//                   .ragionesociale.isNotEmpty
//               ? cStakeholderGiveModel.ragionesociale
//               : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

//           return DataRow(
//               selected: idRowSelected == index,
//               onSelectChanged: (bool? selected) {
//                 setState(() {
//                   if (selected != null && selected) {
//                     idRowSelected = index;
//                     widget.callback2(cStakeholderGiveModel);
//                   } else {
//                     idRowSelected = -1;
//                     widget.callback2(null);
//                   }
//                   if (idRowSelected != 0) {
//                     editAndReceiptVisible == true;
//                   } else {
//                     editAndReceiptVisible == false;
//                   }
//                 });
//               },
//               cells: [
//                 DataCell(
//                   haveContacts
//                       ? CircleAvatar(
//                           radius: 16,
//                           backgroundColor:
//                               Theme.of(context).colorScheme.secondaryContainer,
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('C',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                           ),
//                         )
//                       : CircleAvatar(
//                           radius: 16,
//                           backgroundColor:
//                               Theme.of(context).colorScheme.secondaryContainer,
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('SH',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                           ),
//                         ),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.id.toString()),
//                 ),
//                 DataCell(
//                   Text(ragSocialeONomeCognome,
//                       maxLines: 2, overflow: TextOverflow.ellipsis),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.email),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.tel),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.cell),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.codfisc),
//                 ),
//                 DataCell(
//                   Text(
//                       '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta} ${cStakeholderGiveModel.recapitoGiveModel.prov}',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis),
//                 ),
//               ]);
//         },
//       ).toList();
//     } else {
//       return List.generate(
//         snapshot.length,
//         (index) {
//           StakeholderGiveModelSearch cStakeholderGiveModel = snapshot[index];
//           bool haveContacts =
//               cStakeholderGiveModel.contattiGiveModel.isNotEmpty;
//           String ragSocialeONomeCognome = cStakeholderGiveModel
//                   .ragionesociale.isNotEmpty
//               ? cStakeholderGiveModel.ragionesociale
//               : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

//           return DataRow(
//               selected: idRowSelected == index,
//               onSelectChanged: (bool? selected) {
//                 setState(() {
//                   if (selected != null && selected) {
//                     idRowSelected = index;
//                     widget.callback2(cStakeholderGiveModel);
//                   } else {
//                     idRowSelected = -1;
//                     widget.callback2(null);
//                   }
//                   if (idRowSelected != 0) {
//                     editAndReceiptVisible == true;
//                   } else {
//                     editAndReceiptVisible == false;
//                   }
//                 });
//               },
//               cells: [
//                 DataCell(
//                   haveContacts
//                       ? CircleAvatar(
//                           radius: 16,
//                           backgroundColor:
//                               Theme.of(context).colorScheme.secondaryContainer,
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('C',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                           ),
//                         )
//                       : CircleAvatar(
//                           radius: 16,
//                           backgroundColor:
//                               Theme.of(context).colorScheme.secondaryContainer,
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('SH',
//                                 style: Theme.of(context).textTheme.bodySmall),
//                           ),
//                         ),
//                 ),
//                 DataCell(
//                   SizedBox(
//                     width: width * 0.20,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.person),
//                               Flexible(
//                                 child: Text(ragSocialeONomeCognome,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis),
//                               )
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.code),
//                               Flexible(
//                                   child: Text(cStakeholderGiveModel.codfisc,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis)),
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.numbers),
//                               Flexible(
//                                   child: Text(
//                                       cStakeholderGiveModel.id.toString())),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   SizedBox(
//                     width: width * 0.30,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.email),
//                               Flexible(
//                                 child: Text(cStakeholderGiveModel.email,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis),
//                               )
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.phone),
//                               Text(cStakeholderGiveModel.tel),
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.phone_android),
//                               Text(cStakeholderGiveModel.cell),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   SizedBox(
//                     width: width * 0.35,
//                     child: Text(
//                         '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta}',
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis),
//                   ),
//                 ),
//               ]);
//         },
//       ).toList();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.80,
//         width: MediaQuery.of(context).size.width,
//         child: SingleChildScrollView(child: _createDataTable()));
//   }
// }




// class ShowGiveShDataTableDeduplica extends StatefulWidget {
//   final List<StakeholderDeduplicaResult> snapshot;
//   final double width;
//   final Function stakeholderDeduplicaSelected;
//   // final ProductDetailsArgs productDetailsArguments;
//   const ShowGiveShDataTableDeduplica(
//       {Key? key,
//       required this.snapshot,
//       required this.width,
//       required this.stakeholderDeduplicaSelected})
//       : super(key: key);

//   @override
//   State<ShowGiveShDataTableDeduplica> createState() =>
//       _ShowGiveShDataTableDeduplica();
// }

// class _ShowGiveShDataTableDeduplica
//     extends State<ShowGiveShDataTableDeduplica> {
//   int? idRowSelected;
//   bool editAndReceiptVisible = false;

//   DataTable _createDataTable() {
//     return DataTable(
//       dataRowMinHeight: 40, // new property
//       dataRowMaxHeight: double.infinity, // new property
//       dataRowColor: MaterialStateProperty.resolveWith<Color?>(
//           (Set<MaterialState> states) {
//         // if (states.contains(MaterialState.focused)) {
//         //   return Colors.red;
//         // }
//         // if (states.contains(MaterialState.hovered)) {
//         //   return Colors.blue[100];
//         // }
//         // // if (states.contains(MaterialState.pressed)) {
//         // //   return Colors.yellow;
//         // // }
//         if (states.contains(MaterialState.selected)) {
//           return Colors.blueAccent[100];
//         }
//         return null; // Use the default value.
//       }),
//       columnSpacing: 10,
//       showCheckboxColumn: false,
//       columns: _createColumns(widget.snapshot, widget.width),
//       rows: _createRows(widget.snapshot, widget.width),
//       // sortColumnIndex: _currentSortColumn,
//       // sortAscending: _isSortAsc,
//       dividerThickness: 2,
//       showBottomBorder: true,
//       // headingTextStyle:
//       //     const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//       // headingRowColor:
//       //     MaterialStateProperty.resolveWith((states) => Colors.blueAccent),
//     );
//   }

//   List<DataColumn> _createColumns(
//       List<StakeholderDeduplicaResult> snapshot, double width) {
//     if (width > 1200) {
//       return [
//         const DataColumn(
//           label: Flexible(
//             child: Text('Regola deduplica',
//                 maxLines: 2, overflow: TextOverflow.ellipsis),
//           ),
//         ),
//         const DataColumn(
//           label: Flexible(
//             child: Text('Id'),
//           ),
//         ),
//         const DataColumn(
//           label: Flexible(
//             child: Text('Ragione sociale o nominativo',
//                 maxLines: 2, overflow: TextOverflow.ellipsis),
//           ),
//         ),
//         const DataColumn(
//           label: Text('Email'),
//         ),
//         const DataColumn(
//           label: Text('Telefono'),
//         ),
//         const DataColumn(
//           label: Text('Cellulare'),
//         ),
//         const DataColumn(
//           label: Text('Codice fiscale'),
//         ),
//         const DataColumn(
//           label: Text('Recapito'),
//         ),
//       ];
//     } else {
//       return [
//         DataColumn(
//           label: SizedBox(
//             width: width * 0.05,
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [Text('R. D.'), Text('Id')],
//             ),
//           ),
//         ),
//         DataColumn(
//           label: SizedBox(
//             width: width * 0.20,
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Ragione sociale o nominativo',
//                     maxLines: 2, overflow: TextOverflow.ellipsis),
//                 Text('Codice fiscale')
//               ],
//             ),
//           ),
//         ),
//         DataColumn(
//           label: SizedBox(
//             width: width * 0.30,
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [Text('Email'), Text('Telefono'), Text('Cellulare')],
//             ),
//           ),
//         ),
//         DataColumn(
//           label: SizedBox(
//             width: width * 0.35,
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Recapito', maxLines: 2, overflow: TextOverflow.ellipsis),
//               ],
//             ),
//           ),
//         ),
//       ];
//     }
//   }

//   List<DataRow> _createRows(
//       List<StakeholderDeduplicaResult> snapshot, double width) {
//     if (width > 1200) {
//       return List.generate(
//         snapshot.length,
//         (index) {
//           StakeholderGiveModelSearch cStakeholderGiveModel =
//               snapshot[index].stakeholderGiveModelSearch;
//           String rulesDeduplica = snapshot[index].rules;
//           String ragSocialeONomeCognome = cStakeholderGiveModel
//                   .ragionesociale.isNotEmpty
//               ? cStakeholderGiveModel.ragionesociale
//               : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

//           return DataRow(
//               selected: idRowSelected == index,
//               onSelectChanged: (bool? selected) {
//                 setState(() {
//                   if (selected != null && selected) {
//                     idRowSelected = index;
//                     widget.stakeholderDeduplicaSelected(cStakeholderGiveModel);
//                   } else {
//                     idRowSelected = -1;
//                     widget.stakeholderDeduplicaSelected(null);
//                   }
//                   if (idRowSelected != 0) {
//                     editAndReceiptVisible == true;
//                   } else {
//                     editAndReceiptVisible == false;
//                   }
//                 });
//               },
//               cells: [
//                 DataCell(
//                   Text(rulesDeduplica.toString()),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.id.toString()),
//                 ),
//                 DataCell(
//                   Text(ragSocialeONomeCognome,
//                       maxLines: 2, overflow: TextOverflow.ellipsis),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.email),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.tel),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.cell),
//                 ),
//                 DataCell(
//                   Text(cStakeholderGiveModel.codfisc),
//                 ),
//                 DataCell(
//                   Text(
//                       '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta} ${cStakeholderGiveModel.recapitoGiveModel.prov}',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis),
//                 ),
//               ]);
//         },
//       ).toList();
//     } else {
//       return List.generate(
//         snapshot.length,
//         (index) {
//           StakeholderGiveModelSearch cStakeholderGiveModel =
//               snapshot[index].stakeholderGiveModelSearch;
//           String rulesDeduplica = snapshot[index].rules;
//           String ragSocialeONomeCognome = cStakeholderGiveModel
//                   .ragionesociale.isNotEmpty
//               ? cStakeholderGiveModel.ragionesociale
//               : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

//           return DataRow(
//               selected: idRowSelected == index,
//               onSelectChanged: (bool? selected) {
//                 setState(() {
//                   if (selected != null && selected) {
//                     idRowSelected = index;
//                     widget.stakeholderDeduplicaSelected(cStakeholderGiveModel);
//                   } else {
//                     idRowSelected = -1;
//                     widget.stakeholderDeduplicaSelected(null);
//                   }
//                   if (idRowSelected != 0) {
//                     editAndReceiptVisible == true;
//                   } else {
//                     editAndReceiptVisible == false;
//                   }
//                 });
//               },
//               cells: [
//                 DataCell(
//                   SizedBox(
//                     width: width * 0.20,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircleAvatar(
//                                 radius: 16,
//                                 backgroundColor: Theme.of(context)
//                                     .colorScheme
//                                     .secondaryContainer,
//                                 child: Text(rulesDeduplica.toString(),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headlineLarge),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   SizedBox(
//                     width: width * 0.20,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.person),
//                               Flexible(
//                                 child: Text(ragSocialeONomeCognome,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis),
//                               )
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.code),
//                               Flexible(
//                                   child: Text(cStakeholderGiveModel.codfisc,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis)),
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.numbers),
//                               Flexible(
//                                   child: Text(
//                                       cStakeholderGiveModel.id.toString())),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   SizedBox(
//                     width: width * 0.30,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.email),
//                               Flexible(
//                                 child: Text(cStakeholderGiveModel.email,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis),
//                               )
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.phone),
//                               Text(cStakeholderGiveModel.tel),
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.phone_android),
//                               Text(cStakeholderGiveModel.cell),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataCell(
//                   SizedBox(
//                     width: width * 0.35,
//                     child: Text(
//                         '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta}',
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis),
//                   ),
//                 ),
//               ]);
//         },
//       ).toList();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         // height: MediaQuery.of(context).size.height * 8,
//         width: MediaQuery.of(context).size.width,
//         child: _createDataTable());
//   }
// }


// class GiveShDataSource extends DataTableSource {
//   final List<StakeholderGiveModelSearch> results;
//   double width;
//   GiveShDataSource(this.results, this.width);
//   // rest of the class@override

//   @override
//   bool get isRowCountApproximate => false;
//   @override
//   int get rowCount => results.length;
//   @override
//   int get selectedRowCount => 0;
//   @override
//   DataRow getRow(int index) {
//     StakeholderGiveModelSearch cStakeholderGiveModel = results[index];
//     String ragSocialeONomeCognome =
//         cStakeholderGiveModel.ragionesociale.isNotEmpty
//             ? cStakeholderGiveModel.ragionesociale
//             : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

//     return DataRow(cells: [
//       DataCell(
//         SizedBox(
//           width: width * 0.2,
//           child: Text(ragSocialeONomeCognome,
//               maxLines: 2, overflow: TextOverflow.ellipsis),
//         ),
//       ),
//       DataCell(
//         SizedBox(
//           width: width * 0.30,
//           child: Text(cStakeholderGiveModel.email,
//               maxLines: 2, overflow: TextOverflow.ellipsis),
//         ),
//       ),
//       DataCell(
//         SizedBox(
//           width: width * 0.30,
//           child: Text(
//               '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta}',
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis),
//         ),
//       ),
//     ]);
//   }
// }

// class DataTableWidget extends StatefulWidget {
//   const DataTableWidget({super.key});

//   @override
//   State<DataTableWidget> createState() => _DataTableWidgetState();
// }

// class _DataTableWidgetState extends State<DataTableWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
