import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/ag.category.drop.down.menu.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:provider/provider.dart';

class _DataSource extends DataTableSource {
  final List<ProductCatalogModel> data;
  final Function onRowSelected;
  final double width;
  _DataSource(
      {required this.data, required this.onRowSelected, required this.width});

  int idRowSelected = 0;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];

    return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blueAccent[100];
          } else if (states.contains(MaterialState.hovered)) {
            return Color.fromARGB(255, 222, 226, 231);
          }
          return Colors.transparent; // Use the default value.
        }),
        selected: item.isSelected ?? false,
        onSelectChanged: (bool? selected) {
          data.forEach((f) => f.isSelected = false);
          if (selected != null && selected) {
            data[index].isSelected = selected;
            onRowSelected(data[index]);
          } else {
            onRowSelected(null);
          }
          notifyListeners();
        },
        cells: [
          DataCell(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //   fit: BoxFit.cover,
                //   image: ImageUtils.getImageFromStringBase64(
                //           stringImage: item.imageData)
                //       .image,
                // )),
                ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(item.nameProduct),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(item.descriptionProduct,
                maxLines: 2, overflow: TextOverflow.ellipsis),
          )),
          DataCell(
              Text(item.barcode, maxLines: 2, overflow: TextOverflow.ellipsis)),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text("€" + item.priceProduct.toString()),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          DataCell(Checkbox(
            value: item.freePriceProduct,
            onChanged: (value) {},
          )),
          DataCell(Checkbox(
            value: item.outOfAssortment,
            onChanged: (value) {},
          )),
          DataCell(Checkbox(
            value: item.deleted,
            onChanged: (value) {},
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

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  int currentPage = 1;
  int pageSize = 10;
  int pageNumber = 1;
  bool isLoading = false;
  ValueNotifier<bool> isRowSelected = ValueNotifier<bool>(false);
  ProductCatalogModel? cProductCatalogModel = null;
  CategoryCatalogModel? cCategoryCatalogModel = null;
  List<DataColumn> _createColumns(double width) {
    return [
      const DataColumn(
        label: Flexible(
          child: Text(
            '',
          ),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Nome prodotto',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Descrizione prodotto',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Codice a barre',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Prezzo prodotto',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Prezzo variabile',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Fuori assortimento',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child:
              Text('Cancellato', maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  String? _chosenSubCounty = '';
  void rowSelected(ProductCatalogModel? fProductCatalogModel) {
    if (fProductCatalogModel != null) {
      cProductCatalogModel = fProductCatalogModel;
      isRowSelected.value = true;
    } else {
      cProductCatalogModel = fProductCatalogModel;
      isRowSelected.value = false;
    }
  }

  onCategoryChanged(CategoryCatalogModel? category) {
    setState(() {
      cCategoryCatalogModel = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Prodotti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _chosenSubCounty,
                  //elevation: 5,
                  style: TextStyle(color: Colors.black),

                  items: <String>['', 'Mvita', 'Tudor', 'Kisauni']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Sub-County",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  onChanged: (value) => {
                    setState(() {
                      _chosenSubCounty = value;
                    })
                  },
                  // onChanged: (String value) {
                  //   setState(() {
                  //     _chosenSubCounty = value;
                  //   });
                  // },
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Consumer<ProductCatalogNotifier>(
                builder: (context, productCatalogNotifier, _) {
                  return FutureBuilder(
                    future: productCatalogNotifier.getProducts(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        idCategory: 0,
                        readAlsoDeleted: true,
                        readImageData: false,
                        pageSize: pageSize,
                        pageNumber: pageNumber),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 5,
                                        color: Colors.redAccent,
                                      ))),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            'No data...',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      } else {
                        ProductCatalogDataModel tSnapshot =
                            snapshot.data as ProductCatalogDataModel;
                        List<ProductCatalogModel> tSnapshotData =
                            tSnapshot.data;
                        return SingleChildScrollView(
                          child: PaginatedDataTable(
                            showCheckboxColumn: false,
                            showFirstLastButtons: true,
                            header: Consumer<ProductCatalogNotifier>(
                              builder: (context, productCatalogNotifier, _) {
                                return FutureBuilder(
                                  future: productCatalogNotifier.getProducts(
                                      context: context,
                                      token: authenticationNotifier.token,
                                      idUserAppInstitution:
                                          cUserAppInstitutionModel
                                              .idUserAppInstitution,
                                      idCategory: 0,
                                      readAlsoDeleted: true,
                                      readImageData: false,
                                      pageSize: pageSize,
                                      pageNumber: pageNumber),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                                child: SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 5,
                                                      color: Colors.redAccent,
                                                    ))),
                                          ],
                                        ),
                                      );
                                    } else if (!snapshot.hasData) {
                                      return const Center(
                                        child: Text(
                                          'No data...',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ProductCatalogDataModel tSnapshot =
                                          snapshot.data
                                              as ProductCatalogDataModel;
                                      List<ProductCatalogModel> tSnapshotData =
                                          tSnapshot.data;
                                      return SingleChildScrollView(
                                        child: PaginatedDataTable(
                                          showCheckboxColumn: false,
                                          showFirstLastButtons: true,
                                          rowsPerPage: pageSize,
                                          availableRowsPerPage: const [
                                            10,
                                            25,
                                            50
                                          ],
                                          onPageChanged: (value) {
                                            setState(() {
                                              pageNumber = value;
                                            });
                                          },
                                          onRowsPerPageChanged: (value) {
                                            setState(() {
                                              pageSize = value!;
                                            });
                                          },
                                          columns: _createColumns(
                                              MediaQuery.of(context)
                                                  .size
                                                  .width),
                                          source: _DataSource(
                                              data: tSnapshotData,
                                              onRowSelected: rowSelected,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            rowsPerPage: pageSize,
                            availableRowsPerPage: const [10, 25, 50],
                            onPageChanged: (value) {
                              setState(() {
                                pageNumber = value;
                              });
                            },
                            onRowsPerPageChanged: (value) {
                              setState(() {
                                pageSize = value!;
                              });
                            },
                            columns: _createColumns(
                                MediaQuery.of(context).size.width),
                            source: _DataSource(
                                data: tSnapshotData,
                                onRowSelected: rowSelected,
                                width: MediaQuery.of(context).size.width),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          ValueListenableBuilder<bool>(
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: isRowSelected.value,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRouter.productCatalogDetailRoute,
                        arguments: ProductCatalogModel(
                            idProduct: cProductCatalogModel!.idProduct,
                            idCategory: cProductCatalogModel!.idCategory,
                            nameProduct: cProductCatalogModel!.nameProduct,
                            descriptionProduct:
                                cProductCatalogModel!.descriptionProduct,
                            priceProduct: cProductCatalogModel!.priceProduct,
                            freePriceProduct:
                                cProductCatalogModel!.freePriceProduct,
                            outOfAssortment:
                                cProductCatalogModel!.outOfAssortment,
                            barcode: cProductCatalogModel!.barcode,
                            deleted: cProductCatalogModel!.deleted,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution,
                            imageData: cProductCatalogModel!.imageData,
                            giveIdsFlatStructureModel:
                                GiveIdsFlatStructureModel.empty()),
                      );
                    },
                    backgroundColor: Colors.deepOrangeAccent,
                    child: const Icon(Icons.edit),
                  ),
                ),
              );
            },
            valueListenable: isRowSelected,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRouter.productCatalogDetailRoute,
                  arguments: ProductCatalogModel(
                      idProduct: 0,
                      idCategory: 0,
                      nameProduct: '',
                      descriptionProduct: '',
                      priceProduct: 0,
                      freePriceProduct: false,
                      outOfAssortment: false,
                      barcode: '',
                      deleted: false,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      imageData: '',
                      giveIdsFlatStructureModel:
                          GiveIdsFlatStructureModel.empty()),
                );
              },
              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
