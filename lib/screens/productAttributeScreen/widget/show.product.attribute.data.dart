import 'package:flutter/material.dart';
import 'package:np_casse/core/models/product.attribute.model.dart';

class ShowProductAttributeData extends StatefulWidget {
  final ProductAttributeDataModel snapshot;
  final double width;
  final int currentPage;
  final int pageSize;
  final Function changedPageCallback;
  final Function changedPageSizeCallback;
  // final ProductDetailsArgs productDetailsArguments;
  const ShowProductAttributeData({
    super.key,
    required this.snapshot,
    required this.width,
    required this.changedPageCallback,
    required this.changedPageSizeCallback,
    required this.currentPage,
    required this.pageSize,
  });

  @override
  State<ShowProductAttributeData> createState() =>
      _ShowProductAttributeDataState();
}

class _ShowProductAttributeDataState extends State<ShowProductAttributeData> {
  // late int currentPage;
  // late int pageSize;
  int? idRowSelected;
  @override
  void initState() {
    super.initState();
  }

  DataTable _createDataTable(List<ProductAttributeModel> data) {
    return DataTable(
      dataRowMinHeight: 48, // new property
      dataRowMaxHeight: double.infinity, // new property
      dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // if (states.contains(MaterialState.focused)) {
        //   return Colors.red;
        // }
        // if (states.contains(MaterialState.hovered)) {
        //   return Colors.blue[100];
        // }
        // // if (states.contains(MaterialState.pressed)) {
        // //   return Colors.yellow;
        // // }
        if (states.contains(MaterialState.selected)) {
          return Colors.blueAccent[100];
        }
        return null; // Use the default value.
      }),
      columnSpacing: 10,
      showCheckboxColumn: false,
      columns: _createColumns(data),
      rows: _createRows(data),
      // sortColumnIndex: _currentSortColumn,
      // sortAscending: _isSortAsc,
      dividerThickness: 2,
      showBottomBorder: true,
      // headingTextStyle:
      //     const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      // headingRowColor:
      //     MaterialStateProperty.resolveWith((states) => Colors.blueAccent),
    );
  }

  List<DataColumn> _createColumns(List<ProductAttributeModel> snapshot) {
    return [
      const DataColumn(
        label: Flexible(
          child: Text('Nome attributo prodotto'),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Descrizione attributo prodotto',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Elenco attributi predefiniti prodotto',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  List<DataRow> _createRows(List<ProductAttributeModel> snapshot) {
    return List.generate(
      snapshot.length,
      (index) {
        ProductAttributeModel cProductAttributeModel = snapshot[index];
        return DataRow(
            selected: idRowSelected == index,
            onSelectChanged: (bool? selected) {
              setState(() {
                if (selected != null && selected) {
                  idRowSelected = index;
                  // widget.callback2(cStakeholderGiveModel);
                } else {
                  idRowSelected = -1;
                  // widget.callback2(null);
                }
                if (idRowSelected != 0) {
                  // editAndReceiptVisible == true;
                } else {
                  // editAndReceiptVisible == false;
                }
              });
            },
            cells: [
              DataCell(
                Text(cProductAttributeModel.name,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              DataCell(
                Text(cProductAttributeModel.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              DataCell(
                Text(cProductAttributeModel.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ]);
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: MediaQuery.of(context).size.height * 0.80,
        // width: MediaQuery.of(context).size.width * 0.5,
        child: SingleChildScrollView(
            child: Column(
      children: [
        _createDataTable(widget.snapshot.data),
      ],
    )));
    // PaginatedDataTable(
    //   // header: Text('Attributi prodotto presenti: ' +
    //   //     widget.snapshot.totalCount.toString()),
    //   rowsPerPage: 10,
    //   availableRowsPerPage: const [10, 20, 50],
    //   onRowsPerPageChanged: (value) {
    //     setState(() {
    //       // pageSize = value!;
    //       widget.changedPageSizeCallback(value!);
    //     });
    //   },
    //   onPageChanged: (value) {
    //     setState(() {
    //       widget.changedPageCallback(value);
    //     });
    //   },
    //   columns: const [
    //     DataColumn(label: Text('Age')),
    //     DataColumn(label: Text('ID')),
    //     DataColumn(label: Text('Name')),
    //     DataColumn(label: Text('Age')),
    //   ],
    //   source: DataSource(data: widget.snapshot.data),
    // ),

    //         ExpandableTheme(
    //   data: ExpandableThemeData(context,
    //       contentPadding: const EdgeInsets.all(20),
    //       expandedBorderColor: Colors.transparent,
    //       paginationSize: widget.snapshot.pageSize.toDouble(),
    //       headerHeight: 48,
    //       headerColor: Colors.blueAccent[400],
    //       headerBorder: const BorderSide(
    //         color: Colors.black,
    //         width: 1,
    //       ),
    //       //evenRowColor: const Color(0xFFFFFFFF),
    //       //oddRowColor: Colors.amber[200],
    //       rowBorder: const BorderSide(
    //         color: Colors.black,
    //         width: 0.3,
    //       ),
    //       headerTextMaxLines: 4,
    //       headerSortIconColor: const Color(0xFF6c59cf),
    //       paginationSelectedFillColor: const Color(0xFF6c59cf),
    //       paginationSelectedTextColor: Colors.white,
    //       expansionIcon: Icon(Icons.expand_more),
    //       editIcon: Icon(Icons.edit)),
    //   child: ExpandableDataTable(
    //     pageSize: widget.snapshot.pageSize,
    //     rows: createRows(widget.snapshot.data),
    //     headers: headers,
    //     visibleColumnCount: 5,
    //     multipleExpansion: false,
    //     isEditable: false,
    //     onPageChanged: (page) {
    //       print(page);
    //     },
    //     renderExpansionContent: (cProductAttributeModel) {
    //       return EditProductAttribute(
    //           ProductAttributeModel: cProductAttributeModel);
    //     },
    //     renderCustomPagination: (count, page, onChange) {
    //       return Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           IconButton(
    //             icon: Icon(Icons.navigate_before),
    //             onPressed: () {
    //               if (page > 0) {
    //                 onChange(page - 1);
    //               }
    //             },
    //           ),
    //           Text("Total: $count"),
    //           Text("Current index: $page"),
    //           IconButton(
    //               icon: Icon(Icons.navigate_next),
    //               onPressed: () {
    //                 if (page < count - 1) {
    //                   onChange(page + 1);
    //                 }
    //               }),
    //         ],
    //       );
    //     },
    //   ),
    // ));
  }
}

class DataSource extends DataTableSource {
  final List<ProductAttributeModel> data;

  DataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(cells: [
      // DataCell(Text(item.idInstitution.toString())),
      DataCell(Text(item.name)),
      DataCell(Text(item.description)),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_right),
            tooltip: 'Show Details',
            onPressed: () {
              Text('Placeholder');
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
