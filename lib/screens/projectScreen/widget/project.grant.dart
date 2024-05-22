import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/core/models/project.grant.structure.model.dart';

class ProjectGrant extends StatefulWidget {
  const ProjectGrant({super.key, required this.snapshot});
  final List<ProjectGrantStructureModel> snapshot;

  @override
  State<ProjectGrant> createState() => _ProjectGrantState();
}

class _ProjectGrantState extends State<ProjectGrant> {
  // List<ProjectGrantStructureModel> userWithReadOp = [];
  // List<ProjectGrantStructureModel> userWithEditOp = [];
  List<ProjectGrantStructureModel> snapshotStated = [];
  @override
  void initState() {
    super.initState();
    snapshotStated = widget.snapshot;
    // for (var item in widget.snapshot) {
    //   if (item.operationRead) {
    //     userWithReadOp.add(item);
    //   }
    //   if (item.operationEdit) {
    //     userWithEditOp.add(item);
    //   }
    // }
  }

  DataTable _createDataTable() {
    return DataTable(
      border: const TableBorder(
          horizontalInside: BorderSide(width: 10, color: Colors.transparent)),
      dataRowMinHeight: 40, // new property
      dataRowMaxHeight: double.infinity, // new property
      dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blueAccent[100];
        }
        return null; // Use the default value.
      }),
      columnSpacing: 10,
      showCheckboxColumn: false,
      columns: _createColumns(snapshotStated),
      rows: _createRows(snapshotStated),
      dividerThickness: 0,
      showBottomBorder: true,
    );
  }

  List<DataColumn> _createColumns(List<ProjectGrantStructureModel> snapshot) {
    return [
      const DataColumn(
        label: Flexible(
          child: Text('Nominativo utente'),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Email utente'),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Lettura progetto'),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Modifica progetto'),
        ),
      ),
    ];
  }

  List<DataRow> _createRows(List<ProjectGrantStructureModel> snapshot) {
    return List.generate(
      snapshot.length,
      (index) {
        ProjectGrantStructureModel cProjectGrantStructureModel =
            snapshot[index];

        return DataRow(
            onSelectChanged: (bool? selected) {
              setState(() {});
            },
            cells: [
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person),
                    Flexible(
                      child: Text(
                          " ${cProjectGrantStructureModel.nameUser} ${cProjectGrantStructureModel.surnameUser}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email),
                    Flexible(
                      child: Text(" ${cProjectGrantStructureModel.emailUser}",
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
              DataCell(
                Checkbox(
                  // value: userWithReadOp.contains(cProjectGrantStructureModel),
                  value: snapshot.elementAt(index).operationRead,
                  onChanged: (val) {
                    onSelectedReadOp(val, cProjectGrantStructureModel);
                  },
                ),
              ),
              DataCell(
                Checkbox(
                  // value: userWithEditOp.contains(cProjectGrantStructureModel),
                  value: snapshot.elementAt(index).operationEdit,

                  onChanged: (val) {
                    onSelectedEditOp(val, cProjectGrantStructureModel);
                  },
                ),
              ),
            ]);
      },
    ).toList();
  }

  void onSelectedReadOp(bool? selected, ProjectGrantStructureModel item) {
    var itemSnapshotStated = snapshotStated.firstWhereOrNull(
        (element) => element.idUserAppInstitution == item.idUserAppInstitution);
    if (itemSnapshotStated != null) {
      setState(() {
        itemSnapshotStated.operationRead = selected ?? false;
        if ((selected ?? false) == false) {
          itemSnapshotStated.operationEdit = false;
        }
      });
    }
  }

  void onSelectedEditOp(bool? selected, ProjectGrantStructureModel item) {
    var itemSnapshotStated = snapshotStated.firstWhereOrNull(
        (element) => element.idUserAppInstitution == item.idUserAppInstitution);
    if (itemSnapshotStated != null) {
      setState(() {
        itemSnapshotStated.operationEdit = selected ?? false;
        if (selected ?? false) {
          itemSnapshotStated.operationRead = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: MediaQuery.of(context).size.height * 0.80,
        // width: MediaQuery.of(context).size.width,
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: _createDataTable(),
    ));

    //       return Column(
    //   children: [
    //     SizedBox(
    //       height: 100,
    //       // width: 100,
    //       child: ListView.builder(
    //           itemCount: widget.snapshot.length,
    //           itemBuilder: (context, i) {
    //             return ListTile(
    //                 title: Text(widget.snapshot[i].emailUser),
    //                 trailing: Row(
    //                   children: [
    //                     Checkbox(
    //                       value: userWithReadOp.contains(widget.snapshot[i]),
    //                       onChanged: (val) {
    //                         onSelectedReadOp(val, widget.snapshot[i]);
    //                       },
    //                     ),
    //                     Checkbox(
    //                       value: userWithReadOp.contains(widget.snapshot[i]),
    //                       onChanged: (val) {
    //                         onSelectedReadOp(val, widget.snapshot[i]);
    //                       },
    //                     ),
    //                   ],
    //                 )
    //                 //you can use checkboxlistTile too
    //                 );
    //           }),
    //     ),
    //   ],
    // );
  }
}
