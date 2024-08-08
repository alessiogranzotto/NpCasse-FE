import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:provider/provider.dart';

class _DataSource extends DataTableSource {
  final List<CategoryCatalogModel> data;
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
            child: Text(item.nameCategory),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(item.descriptionCategory,
                maxLines: 2, overflow: TextOverflow.ellipsis),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(item.parentCategoryName ?? '',
                maxLines: 2, overflow: TextOverflow.ellipsis),
          )),
          DataCell(Checkbox(
            value: item.deleted,
            onChanged: (value) {},
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class CategoryCatalogScreen extends StatefulWidget {
  const CategoryCatalogScreen({super.key});
  @override
  State<CategoryCatalogScreen> createState() => _CategoryCatalogScreenState();
}

class _CategoryCatalogScreenState extends State<CategoryCatalogScreen> {
  int currentPage = 1;
  int pageSize = 10;
  int pageNumber = 1;
  bool isLoading = false;
  ValueNotifier<bool> isRowSelected = ValueNotifier<bool>(false);
  ProductCatalogModel? cProductCatalogModel = null;
  CategoryCatalogModel? cCategoryCatalogModel = null;

  List<CategoryCatalogModel> availableCategory = [];
  bool firstLevelCategory = false;
  bool secondLevelCategory = false;
  bool allCategory = true;
  String levelCategory = 'AllCategory';

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
          child: Text('Nome categoria',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Descrizione categoria',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child: Text('Nome categoria padre',
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Flexible(
          child:
              Text('Cancellata', maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  void rowSelected(CategoryCatalogModel? fCategoryCatalogModel) {
    if (fCategoryCatalogModel != null) {
      cCategoryCatalogModel = fCategoryCatalogModel;
      isRowSelected.value = true;
    } else {
      cCategoryCatalogModel = fCategoryCatalogModel;
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
          'Categorie ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    side: const BorderSide(color: Colors.blueAccent),
                    checkColor: Colors.blueAccent,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    activeColor: Colors.blueAccent,

                    controlAffinity: ListTileControlAffinity.leading,
                    value: firstLevelCategory,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value!) {
                          firstLevelCategory = true;
                          secondLevelCategory = false;
                          allCategory = false;
                          levelCategory = 'FirstLevelCategory';
                        }
                      });
                    },
                    title: const Text('Mostra solo categorie di primo livello'),
                    // subtitle: const Text(""),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    side: const BorderSide(color: Colors.blueAccent),
                    checkColor: Colors.blueAccent,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    activeColor: Colors.blueAccent,

                    controlAffinity: ListTileControlAffinity.leading,
                    value: secondLevelCategory,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value!) {
                          firstLevelCategory = false;
                          secondLevelCategory = true;
                          allCategory = false;
                          levelCategory = 'SecondLevelCategory';
                        }
                      });
                    },
                    title:
                        const Text('Mostra solo categorie di secondo livello'),
                    // subtitle: const Text(""),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    side: const BorderSide(color: Colors.blueAccent),
                    checkColor: Colors.blueAccent,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    activeColor: Colors.blueAccent,

                    controlAffinity: ListTileControlAffinity.leading,
                    value: allCategory,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value!) {
                          firstLevelCategory = false;
                          secondLevelCategory = false;
                          allCategory = true;
                          levelCategory = 'AllCategory';
                        }
                      });
                    },
                    title: const Text('Mostra tutte le categorie'),
                    // subtitle: const Text(""),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Consumer<CategoryCatalogNotifier>(
                builder: (context, categoryCatalogNotifier, _) {
                  return FutureBuilder(
                    future: categoryCatalogNotifier.getCategories(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        idCategory: 0,
                        levelCategory: levelCategory,
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
                        CategoryCatalogDataModel tSnapshot =
                            snapshot.data as CategoryCatalogDataModel;
                        List<CategoryCatalogModel> tSnapshotData =
                            tSnapshot.data;

                        return SingleChildScrollView(
                          child: PaginatedDataTable(
                            showCheckboxColumn: false,
                            showFirstLastButtons: true,
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
                        AppRouter.categoryCatalogDetailRoute,
                        arguments: CategoryCatalogModel(
                            idCategory: cCategoryCatalogModel!.idCategory,
                            nameCategory: cCategoryCatalogModel!.nameCategory,
                            descriptionCategory:
                                cCategoryCatalogModel!.descriptionCategory,
                            parentIdCategory:
                                cCategoryCatalogModel!.parentIdCategory,
                            displayOrder: cCategoryCatalogModel!.displayOrder,
                            deleted: cCategoryCatalogModel!.deleted,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution,
                            imageData: cCategoryCatalogModel!.imageData,
                            parentCategoryName:
                                cCategoryCatalogModel!.parentCategoryName,
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
                  AppRouter.categoryCatalogDetailRoute,
                  arguments: CategoryCatalogModel(
                      idCategory: 0,
                      nameCategory: '',
                      descriptionCategory: '',
                      parentIdCategory: 0,
                      displayOrder: 0,
                      deleted: false,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      imageData: '',
                      parentCategoryName: '',
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
