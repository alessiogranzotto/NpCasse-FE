import 'package:flutter/material.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:provider/provider.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class CategoryCatalogDetailScreen extends StatefulWidget {
  final CategoryCatalogModel categoryCatalogModelArgument;
  // final CategoryCatalogDetailsArgs CategoryCatalogDetailsArguments;
  const CategoryCatalogDetailScreen({
    super.key,
    required this.categoryCatalogModelArgument,
  });

  @override
  State<CategoryCatalogDetailScreen> createState() =>
      _CategoryCatalogDetailState();
}

class _CategoryCatalogDetailState extends State<CategoryCatalogDetailScreen> {
  final ValueNotifier<bool> isFreePriceProduct = ValueNotifier<bool>(false);
  String tImageString = '';
  bool isEdit = false;
  bool panelIdsGiveExpanded = false;
  bool panelOtherExpanded = false;

  final TextEditingController textEditingControllerIdCategory =
      TextEditingController();
  final TextEditingController textEditingControllerNameCategory =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionCategory =
      TextEditingController();
  final TextEditingController textEditingControllerDisplayOrderCategory =
      TextEditingController();

  final TextEditingController textEditingControllerIdFinalizzazione =
      TextEditingController();
  final TextEditingController textEditingControllerIdEvento =
      TextEditingController();
  final TextEditingController textEditingControllerIdAttivita =
      TextEditingController();
  final TextEditingController textEditingControllerIdAgenda =
      TextEditingController();
  final TextEditingController textEditingControllerIdComunicazioni =
      TextEditingController();
  final TextEditingController textEditingControllerIdTipDonazione =
      TextEditingController();
  final TextEditingController textEditingControllerIdCatalogo =
      TextEditingController();

  Future<List<CategoryCatalogModel>> getAvailableCategories() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    CategoryCatalogNotifier categoryCatalogNotifier =
        Provider.of<CategoryCatalogNotifier>(context, listen: false);
    var r = await categoryCatalogNotifier.getCategories(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idCategory: 0,
        levelCategory: 'AllCategory',
        readAlsoDeleted: false,
        readImageData: false,
        pageSize: -1 >>> 1,
        pageNumber: 1);
    print(r);
    return r;
  }

  @override
  void initState() {
    getAvailableCategories();
    isEdit = widget.categoryCatalogModelArgument.idCategory != 0;
    if (widget.categoryCatalogModelArgument.idCategory != 0) {
      textEditingControllerNameCategory.text =
          widget.categoryCatalogModelArgument.nameCategory.toString();
      textEditingControllerDescriptionCategory.text =
          widget.categoryCatalogModelArgument.descriptionCategory;
      textEditingControllerDisplayOrderCategory.text =
          widget.categoryCatalogModelArgument.displayOrder.toString();

      tImageString = widget.categoryCatalogModelArgument.imageData;
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
              .idFinalizzazione >
          0) {
        textEditingControllerIdFinalizzazione.text = widget
            .categoryCatalogModelArgument
            .giveIdsFlatStructureModel
            .idFinalizzazione
            .toString();
      } else {
        textEditingControllerIdFinalizzazione.text = '';
      }
      if (widget
              .categoryCatalogModelArgument.giveIdsFlatStructureModel.idEvento >
          0) {
        textEditingControllerIdEvento.text = widget
            .categoryCatalogModelArgument.giveIdsFlatStructureModel.idEvento
            .toString();
      } else {
        textEditingControllerIdEvento.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
              .idAttivita >
          0) {
        textEditingControllerIdAttivita.text = widget
            .categoryCatalogModelArgument.giveIdsFlatStructureModel.idAttivita
            .toString();
      } else {
        textEditingControllerIdAttivita.text = '';
      }

      if (widget
              .categoryCatalogModelArgument.giveIdsFlatStructureModel.idAgenda >
          0) {
        textEditingControllerIdAgenda.text = widget
            .categoryCatalogModelArgument.giveIdsFlatStructureModel.idAgenda
            .toString();
      } else {
        textEditingControllerIdAgenda.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
              .idComunicazioni >
          0) {
        textEditingControllerIdComunicazioni.text = widget
            .categoryCatalogModelArgument
            .giveIdsFlatStructureModel
            .idComunicazioni
            .toString();
      } else {
        textEditingControllerIdComunicazioni.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
              .idTipDonazione >
          0) {
        textEditingControllerIdTipDonazione.text = widget
            .categoryCatalogModelArgument
            .giveIdsFlatStructureModel
            .idTipDonazione
            .toString();
      } else {
        textEditingControllerIdTipDonazione.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
              .idCatalogo >
          0) {
        textEditingControllerIdCatalogo.text = widget
            .categoryCatalogModelArgument.giveIdsFlatStructureModel.idCatalogo
            .toString();
      } else {
        textEditingControllerIdCatalogo.text = '';
      }
    } else {
      //tImageString = AppAssets.noImageString;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    // UserAppInstitutionNotifier userAppInstitutionNotifier =
    //     Provider.of<UserAppInstitutionNotifier>(context);
    // ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
    // StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    // ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    bool canAddProduct = authenticationNotifier.canUserAddItem();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Dettaglio categoria: ${widget.categoryCatalogModelArgument.nameCategory}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
          // ],
        ),
        body: ListView(
          children: [
            Card(
              color: Theme.of(context).cardColor,
              elevation: 4,
              child: SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width) / 5,
                      height: (MediaQuery.of(context).size.width) / 2,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.width) / 2,
                        width: (MediaQuery.of(context).size.width) / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          image: DecorationImage(
                                            image: ImageUtils
                                                    .getImageFromStringBase64(
                                                        stringImage:
                                                            tImageString)
                                                .image,
                                          )),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          ImageUtils.getImageFromStringBase64(
                                                  stringImage: tImageString)
                                              .image,
                                      fit: BoxFit.contain),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.width) / 2,
                      width: (MediaQuery.of(context).size.width) / 5,
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.photo_camera),
                        onPressed: () {
                          showModalBottomSheet(
                            isDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.photo),
                                    title: Text(
                                      'Capture Image',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    onTap: () {
                                      ImageUtils.imageSelectorCamera()
                                          .then((value) {
                                        setState(() {
                                          tImageString = value;
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.folder),
                                    title: Text(
                                      'Select Image',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    onTap: () {
                                      ImageUtils.imageSelectorFile()
                                          .then((value) {
                                        setState(() {
                                          tImageString = value;
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: Text(
                                      'Delete Image',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        tImageString = tImageString =
                                            ImageUtils.setNoImage();
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.undo),
                                    title: Text(
                                      'Undo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const ListTile(
                                    title: Text(''),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Nome categoria',
                            child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 4,
                              child: ListTile(
                                // title: Text(
                                //   'Nome Progetto',
                                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                // ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        //onChanged: ,
                                        controller:
                                            textEditingControllerNameCategory,
                                        minLines: 3,
                                        maxLines: 3,
                                        //maxLength: 300,
                                        //keyboardType: ,
                                        // decoration: const InputDecoration(
                                        //   prefixText: '€ ',
                                        //   label: Text('amount'),
                                        // ),
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.title),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Descrizione categoria',
                            child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 4,
                              child: ListTile(
                                // title: Text(
                                //   'qui ci va la descrizione del progetto',
                                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, ),
                                // ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        //onChanged: ,
                                        controller:
                                            textEditingControllerDescriptionCategory,
                                        minLines: 3,
                                        maxLines: 3,

                                        //maxLength: 300,
                                        //keyboardType: ,
                                        // decoration: const InputDecoration(
                                        //   prefixText: '€ ',
                                        //   label: Text('amount'),
                                        // ),
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.topic),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Categoria padre',
                            child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 4,
                              child: ListTile(
                                // title: Text(
                                //   'qui ci va la descrizione del progetto',
                                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, ),
                                // ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        //onChanged: ,
                                        controller:
                                            textEditingControllerDisplayOrderCategory,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),

                                        minLines: 1,
                                        maxLines: 1,

                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.sort),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Ordine di visualizzazione',
                            child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 4,
                              child: ListTile(
                                // title: Text(
                                //   'qui ci va la descrizione del progetto',
                                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, ),
                                // ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        //onChanged: ,
                                        controller:
                                            textEditingControllerDisplayOrderCategory,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),

                                        minLines: 1,
                                        maxLines: 1,

                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.sort),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) {
                    print(panelIndex);
                    print(isExpanded);
                    setState(() {
                      if (panelIndex == 0) {
                        panelIdsGiveExpanded = isExpanded;
                      } else if (panelIndex == 1) {
                        panelOtherExpanded = isExpanded;
                      }
                    });
                    print(panelIdsGiveExpanded);
                    print(panelOtherExpanded);
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text('ID Give'),
                          subtitle:
                              Text('Inserire i dettagli degli Id di Give'),
                        );
                      },
                      body: Text('IDs Give'),
                      isExpanded: panelIdsGiveExpanded,
                    ),
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text('Attributi prodotto'),
                          subtitle: Text(
                              'Inserire i dettagli degli attributo prodotto'),
                        );
                      },
                      body: Text(''),
                      isExpanded: panelOtherExpanded,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          canAddProduct
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      CategoryCatalogModel categoryCatalogModel =
                          CategoryCatalogModel(
                              idCategory: widget
                                  .categoryCatalogModelArgument.idCategory,
                              nameCategory:
                                  textEditingControllerNameCategory.text,
                              descriptionCategory:
                                  textEditingControllerDescriptionCategory.text,
                              parentIdCategory: 0,
                              displayOrder: int.tryParse(
                                      textEditingControllerDisplayOrderCategory
                                          .text) ??
                                  0,
                              deleted: false,
                              idUserAppInstitution:
                                  cUserAppInstitutionModel.idUserAppInstitution,
                              imageData: tImageString,
                              giveIdsFlatStructureModel:
                                  GiveIdsFlatStructureModel(
                                idFinalizzazione: int.tryParse(
                                        textEditingControllerIdFinalizzazione
                                            .text) ??
                                    0,
                                idEvento: int.tryParse(
                                        textEditingControllerIdEvento.text) ??
                                    0,
                                idAttivita: int.tryParse(
                                        textEditingControllerIdAttivita.text) ??
                                    0,
                                idAgenda: int.tryParse(
                                        textEditingControllerIdAgenda.text) ??
                                    0,
                                idComunicazioni: int.tryParse(
                                        textEditingControllerIdComunicazioni
                                            .text) ??
                                    0,
                                idTipDonazione: int.tryParse(
                                        textEditingControllerIdTipDonazione
                                            .text) ??
                                    0,
                                idCatalogo: int.tryParse(
                                        textEditingControllerIdCatalogo.text) ??
                                    0,
                              ));

                      // productNotifier
                      //     .addOrUpdateProduct(
                      //         context: context,
                      //         token: authenticationNotifier.token,
                      //         idUserAppInstitution:
                      //             cUserAppInstitutionModel.idUserAppInstitution,
                      //         idProject: projectNotifier.getIdProject,
                      //         idStore: storeNotifier.getIdStore,
                      //         CategoryCatalogDataModel: CategoryCatalogDataModel)
                      //     .then((value) {
                      //   if (value) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackUtil.stylishSnackBar(
                      //             title: "Prodotti",
                      //             message: "Informazioni aggiornate",
                      //             contentType: "success"));
                      //     Navigator.of(context).pop();
                      //     productNotifier.refresh();
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackUtil.stylishSnackBar(
                      //             title: "Prodotti",
                      //             message: "Errore di connessione",
                      //             contentType: "failure"));
                      //     Navigator.of(context).pop();
                      //   }
                      // });
                    },
                    //backgroundColor: Colors.deepOrangeAccent,
                    child: const Icon(Icons.check),
                  ),
                )
              : const SizedBox.shrink(),
          (canAddProduct && isEdit)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      var dialog = CustomAlertDialog(
                        title: "Eliminazione prodotto",
                        content: "Si desidera procedere alla cancellazione?",
                        yesCallBack: () {
                          // CategoryCatalogDataModel CategoryCatalogDataModel =
                          //     CategoryCatalogDataModel(
                          //         idProduct: widget
                          //             .categoryCatalogModelArgument
                          //             .idProduct,
                          //         idStore: widget
                          //             .categoryCatalogModelArgument.idStore,
                          //         nameProduct:
                          //             textEditingControllerNameProduct.text,
                          //         descriptionProduct:
                          //             textEditingControllerDescriptionProduct
                          //                 .text,
                          //         priceProduct: double.tryParse(
                          //                 textEditingControllerPriceProduct
                          //                     .text) ??
                          //             0,
                          //         imageProduct: tImageString,
                          //         isWishlisted: ValueNotifier<bool>(false),
                          //         isFreePriceProduct: isFreePriceProduct.value,
                          //         isDeleted: true,
                          //         isOutOfAssortment: isOutOfAssortment,
                          //         giveIdsFlatStructureModel:
                          //             GiveIdsFlatStructureModel(
                          //           idFinalizzazione: int.tryParse(
                          //                   textEditingControllerIdFinalizzazione
                          //                       .text) ??
                          //               0,
                          //           idEvento: int.tryParse(
                          //                   textEditingControllerIdEvento
                          //                       .text) ??
                          //               0,
                          //           idAttivita: int.tryParse(
                          //                   textEditingControllerIdAttivita
                          //                       .text) ??
                          //               0,
                          //           idAgenda: int.tryParse(
                          //                   textEditingControllerIdAgenda
                          //                       .text) ??
                          //               0,
                          //           idComunicazioni: int.tryParse(
                          //                   textEditingControllerIdComunicazioni
                          //                       .text) ??
                          //               0,
                          //           idTipDonazione: int.tryParse(
                          //                   textEditingControllerIdTipDonazione
                          //                       .text) ??
                          //               0,
                          //           idCatalogo: int.tryParse(
                          //                   textEditingControllerIdCatalogo
                          //                       .text) ??
                          //               0,
                          //         ));

                          // productNotifier
                          //     .addOrUpdateProduct(
                          //         context: context,
                          //         token: authenticationNotifier.token,
                          //         idUserAppInstitution: cUserAppInstitutionModel
                          //             .idUserAppInstitution,
                          //         idProject: projectNotifier.getIdProject,
                          //         idStore: storeNotifier.getIdStore,
                          //         CategoryCatalogDataModel:
                          //             CategoryCatalogDataModel)
                          //     .then((value) {
                          //   if (value) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //         SnackUtil.stylishSnackBar(
                          //             title: "Prodotti",
                          //             message: "Informazioni aggiornate",
                          //             contentType: "success"));
                          //     Navigator.of(context).pop();
                          //     productNotifier.refresh();
                          //   } else {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //         SnackUtil.stylishSnackBar(
                          //             title: "Prodotti",
                          //             message: "Errore di connessione",
                          //             contentType: "failure"));
                          //     Navigator.of(context).pop();
                          //   }
                          // });
                        },
                        noCallBack: () {},
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog);
                    },
                    //backgroundColor: Colors.deepOrangeAccent,
                    child: const Icon(Icons.delete),
                  ),
                )
              : const SizedBox.shrink()
        ]));
  }
}
