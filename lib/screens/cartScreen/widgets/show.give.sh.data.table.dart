import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/pdf.invoice.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ShowGiveShDataTable extends StatefulWidget {
  final List<StakeholderGiveModelSearch> snapshot;
  final double width;
  final Function callback2;
  // final ProductDetailsArgs productDetailsArguments;
  const ShowGiveShDataTable(
      {Key? key,
      required this.snapshot,
      required this.width,
      required this.callback2})
      : super(key: key);

  @override
  State<ShowGiveShDataTable> createState() => _ShowGiveShDataTableState();
}

class _ShowGiveShDataTableState extends State<ShowGiveShDataTable> {
  int? idRowSelected;
  bool editAndReceiptVisible = false;

  DataTable _createDataTable() {
    return DataTable(
      dataRowMinHeight: 40, // new property
      dataRowMaxHeight: double.infinity, // new property
      dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return Colors.red;
        }
        if (states.contains(MaterialState.hovered)) {
          return Colors.blue[100];
        }
        // if (states.contains(MaterialState.pressed)) {
        //   return Colors.yellow;
        // }
        if (states.contains(MaterialState.selected)) {
          return Colors.blueAccent[100];
        }
        return null; // Use the default value.
      }),
      columnSpacing: 10,
      showCheckboxColumn: false,
      columns: _createColumns(widget.snapshot, widget.width),
      rows: _createRows(widget.snapshot, widget.width),
      // sortColumnIndex: _currentSortColumn,
      // sortAscending: _isSortAsc,
      dividerThickness: 2,
      showBottomBorder: true,
      headingTextStyle:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.blueAccent),
    );
  }

  List<DataColumn> _createColumns(
      List<StakeholderGiveModelSearch> snapshot, double width) {
    if (width > 1200) {
      return [
        const DataColumn(
          label: Flexible(
            child: Text('Ragione sociale o nominativo',
                maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ),
        const DataColumn(
          label: Text('Email'),
        ),
        const DataColumn(
          label: Text('Telefono'),
        ),
        const DataColumn(
          label: Text('Cellulare'),
        ),
        const DataColumn(
          label: Text('Codice fiscale'),
        ),
        const DataColumn(
          label: Text('Recapito'),
        ),
      ];
    } else {
      return [
        DataColumn(
          label: SizedBox(
            width: width * 0.20,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ragione sociale o nominativo',
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                Text('Codice fiscale')
              ],
            ),
          ),
        ),
        DataColumn(
          label: SizedBox(
            width: width * 0.30,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Email'), Text('Telefono'), Text('Cellulare')],
            ),
          ),
        ),
        DataColumn(
          label: SizedBox(
            width: width * 0.35,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Recapito'),
              ],
            ),
          ),
        ),
      ];
    }
  }

  List<DataRow> _createRows(
      List<StakeholderGiveModelSearch> snapshot, double width) {
    if (width > 1200) {
      return List.generate(
        snapshot.length,
        (index) {
          StakeholderGiveModelSearch cStakeholderGiveModel = snapshot[index];
          String ragSocialeONomeCognome = cStakeholderGiveModel
                  .ragionesociale.isNotEmpty
              ? cStakeholderGiveModel.ragionesociale
              : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

          return DataRow(
              selected: idRowSelected == index,
              onSelectChanged: (bool? selected) {
                setState(() {
                  if (selected != null && selected) {
                    idRowSelected = index;
                    widget.callback2(cStakeholderGiveModel);
                  } else {
                    idRowSelected = -1;
                    widget.callback2(null);
                  }
                  if (idRowSelected != 0) {
                    editAndReceiptVisible == true;
                  } else {
                    editAndReceiptVisible == false;
                  }
                });
              },
              cells: [
                DataCell(
                  Text(ragSocialeONomeCognome,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                DataCell(
                  Text(cStakeholderGiveModel.email),
                ),
                DataCell(
                  Text(cStakeholderGiveModel.tel),
                ),
                DataCell(
                  Text(cStakeholderGiveModel.cell),
                ),
                DataCell(
                  Text(cStakeholderGiveModel.codfisc),
                ),
                DataCell(
                  Text(
                      '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta} ${cStakeholderGiveModel.recapitoGiveModel.prov}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ]);
        },
      ).toList();
    } else {
      return List.generate(
        snapshot.length,
        (index) {
          StakeholderGiveModelSearch cStakeholderGiveModel = snapshot[index];
          String ragSocialeONomeCognome = cStakeholderGiveModel
                  .ragionesociale.isNotEmpty
              ? cStakeholderGiveModel.ragionesociale
              : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

          return DataRow(
              selected: idRowSelected == index,
              onSelectChanged: (bool? selected) {
                setState(() {
                  if (selected != null && selected) {
                    idRowSelected = index;
                    widget.callback2(cStakeholderGiveModel);
                  } else {
                    idRowSelected = -1;
                    widget.callback2(null);
                  }
                  if (idRowSelected != 0) {
                    editAndReceiptVisible == true;
                  } else {
                    editAndReceiptVisible == false;
                  }
                });
              },
              cells: [
                DataCell(
                  SizedBox(
                    width: width * 0.20,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person),
                              Flexible(
                                child: Text(ragSocialeONomeCognome,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.code),
                              Flexible(
                                  child: Text(cStakeholderGiveModel.codfisc,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: width * 0.30,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.email),
                              Flexible(
                                child: Text(cStakeholderGiveModel.email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone),
                              Text(cStakeholderGiveModel.tel),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone_android),
                              Text(cStakeholderGiveModel.cell),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: width * 0.35,
                    child: Text(
                        '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ]);
        },
      ).toList();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(child: _createDataTable()));
  }
}

class GiveShDataSource extends DataTableSource {
  final List<StakeholderGiveModelSearch> results;
  double width;
  GiveShDataSource(this.results, this.width);
  // rest of the class@override

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => results.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    StakeholderGiveModelSearch cStakeholderGiveModel = results[index];
    String ragSocialeONomeCognome =
        cStakeholderGiveModel.ragionesociale.isNotEmpty
            ? cStakeholderGiveModel.ragionesociale
            : "${cStakeholderGiveModel.nome} ${cStakeholderGiveModel.cognome}";

    return DataRow(cells: [
      DataCell(
        SizedBox(
          width: width * 0.2,
          child: Text(ragSocialeONomeCognome,
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      DataCell(
        SizedBox(
          width: width * 0.30,
          child: Text(cStakeholderGiveModel.email,
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      DataCell(
        SizedBox(
          width: width * 0.30,
          child: Text(
              '${cStakeholderGiveModel.recapitoGiveModel.indirizzo} ${cStakeholderGiveModel.recapitoGiveModel.nCivico} ${cStakeholderGiveModel.recapitoGiveModel.cap} ${cStakeholderGiveModel.recapitoGiveModel.citta}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
      ),
    ]);
  }
}

class DataTableWidget extends StatefulWidget {
  const DataTableWidget({super.key});

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
