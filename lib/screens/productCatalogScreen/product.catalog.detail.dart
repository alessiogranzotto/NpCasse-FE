import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class ProductCatalogDetailScreen extends StatefulWidget {
  final ProductCatalogModel productCatalogModelArgument;
  // final ProductCatalogDetailsArgs ProductCatalogDetailsArguments;
  const ProductCatalogDetailScreen({
    super.key,
    required this.productCatalogModelArgument,
  });

  @override
  State<ProductCatalogDetailScreen> createState() =>
      _ProductCatalogDetailState();
}

class _ProductCatalogDetailState extends State<ProductCatalogDetailScreen> {
  final ValueNotifier<bool> isFreePriceProduct = ValueNotifier<bool>(false);
  bool isOutOfAssortment = false;
  String tImageString = '';
  bool isEdit = false;
  bool panelIdsGiveExpanded = false;
  bool panelOtherExpanded = false;
  final TextEditingController textEditingControllerIdCategoryProduct =
      TextEditingController();
  final TextEditingController textEditingControllerNameProduct =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionProduct =
      TextEditingController();
  final TextEditingController textEditingControllerPriceProduct =
      TextEditingController();
  final TextEditingController textEditingControllerBarcodeProduct =
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

  @override
  void initState() {
    isEdit = widget.productCatalogModelArgument.idProduct != 0;
    if (widget.productCatalogModelArgument.idProduct != 0) {
      textEditingControllerIdCategoryProduct.text =
          widget.productCatalogModelArgument.idCategory.toString();
      textEditingControllerNameProduct.text =
          widget.productCatalogModelArgument.nameProduct;
      textEditingControllerDescriptionProduct.text =
          widget.productCatalogModelArgument.descriptionProduct;
      textEditingControllerPriceProduct.text =
          widget.productCatalogModelArgument.priceProduct.toString();
      textEditingControllerBarcodeProduct.text =
          widget.productCatalogModelArgument.barcode.toString();
      isFreePriceProduct.value =
          widget.productCatalogModelArgument.freePriceProduct;
      isOutOfAssortment = widget.productCatalogModelArgument.outOfAssortment;

      tImageString = widget.productCatalogModelArgument.imageData;
      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idFinalizzazione >
          0) {
        textEditingControllerIdFinalizzazione.text = widget
            .productCatalogModelArgument
            .giveIdsFlatStructureModel
            .idFinalizzazione
            .toString();
      } else {
        textEditingControllerIdFinalizzazione.text = '';
      }
      if (widget
              .productCatalogModelArgument.giveIdsFlatStructureModel.idEvento >
          0) {
        textEditingControllerIdEvento.text = widget
            .productCatalogModelArgument.giveIdsFlatStructureModel.idEvento
            .toString();
      } else {
        textEditingControllerIdEvento.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idAttivita >
          0) {
        textEditingControllerIdAttivita.text = widget
            .productCatalogModelArgument.giveIdsFlatStructureModel.idAttivita
            .toString();
      } else {
        textEditingControllerIdAttivita.text = '';
      }

      if (widget
              .productCatalogModelArgument.giveIdsFlatStructureModel.idAgenda >
          0) {
        textEditingControllerIdAgenda.text = widget
            .productCatalogModelArgument.giveIdsFlatStructureModel.idAgenda
            .toString();
      } else {
        textEditingControllerIdAgenda.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idComunicazioni >
          0) {
        textEditingControllerIdComunicazioni.text = widget
            .productCatalogModelArgument
            .giveIdsFlatStructureModel
            .idComunicazioni
            .toString();
      } else {
        textEditingControllerIdComunicazioni.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idTipDonazione >
          0) {
        textEditingControllerIdTipDonazione.text = widget
            .productCatalogModelArgument
            .giveIdsFlatStructureModel
            .idTipDonazione
            .toString();
      } else {
        textEditingControllerIdTipDonazione.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idCatalogo >
          0) {
        textEditingControllerIdCatalogo.text = widget
            .productCatalogModelArgument.giveIdsFlatStructureModel.idCatalogo
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
            'Dettaglio prodotto: ${widget.productCatalogModelArgument.nameProduct}',
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
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var width = MediaQuery.of(context).size.width;
                return width > 1200
                    ? Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
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
                                                    textEditingControllerNameProduct,
                                                minLines: 3,
                                                maxLines: 3,
                                                //maxLength: 300,
                                                //keyboardType: ,
                                                // decoration: const InputDecoration(
                                                //   prefixText: '€ ',
                                                //   label: Text('amount'),
                                                // ),
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
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
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
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
                                                    textEditingControllerDescriptionProduct,
                                                minLines: 3,
                                                maxLines: 3,

                                                //maxLength: 300,
                                                //keyboardType: ,
                                                // decoration: const InputDecoration(
                                                //   prefixText: '€ ',
                                                //   label: Text('amount'),
                                                // ),
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
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
                                    Card(
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
                                                    textEditingControllerPriceProduct,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(),

                                                minLines: 1,
                                                maxLines: 1,

                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: const Icon(Icons.euro),
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(children: [
                                          Expanded(
                                            child: ValueListenableBuilder<bool>(
                                              builder: (BuildContext context,
                                                  bool value, Widget? child) {
                                                return CheckboxListTile(
                                                    title: const SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Prezzo variabile")),
                                                    value: isFreePriceProduct
                                                        .value,
                                                    onChanged: (bool? value) {
                                                      isFreePriceProduct.value =
                                                          value!;
                                                    },
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading);
                                              },
                                              valueListenable:
                                                  isFreePriceProduct,
                                            ),
                                          )
                                        ]),
                                        // trailing: const Icon(Icons.edit),
                                        leading: const Icon(Icons.local_offer),
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(children: [
                                          Expanded(
                                            child: CheckboxListTile(
                                                title: const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                        "Fuori assortimento")),
                                                value: isOutOfAssortment,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isOutOfAssortment = value!;
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading),
                                          )
                                        ]),
                                        // trailing: const Icon(Icons.edit),
                                        leading: const Icon(Icons.warehouse),
                                        onTap: () {},
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
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text('ID Give'),
                                    subtitle: Text(
                                        'Inserire i dettagli degli Id di Give'),
                                  );
                                },
                                body: Text('IDs Give'),
                                isExpanded: panelIdsGiveExpanded,
                              ),
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
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
                    : Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
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
                                                    textEditingControllerNameProduct,
                                                minLines: 3,
                                                maxLines: 3,
                                                //maxLength: 300,
                                                //keyboardType: ,
                                                // decoration: const InputDecoration(
                                                //   prefixText: '€ ',
                                                //   label: Text('amount'),
                                                // ),
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
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
                                    Card(
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
                                                    textEditingControllerDescriptionProduct,
                                                minLines: 3,
                                                maxLines: 3,

                                                //maxLength: 300,
                                                //keyboardType: ,
                                                // decoration: const InputDecoration(
                                                //   prefixText: '€ ',
                                                //   label: Text('amount'),
                                                // ),
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
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
                                    Card(
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
                                                    textEditingControllerPriceProduct,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(),

                                                minLines: 1,
                                                maxLines: 1,

                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: const Icon(Icons.euro),
                                        onTap: () {},
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
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(children: [
                                          Expanded(
                                            child: ValueListenableBuilder<bool>(
                                              builder: (BuildContext context,
                                                  bool value, Widget? child) {
                                                return CheckboxListTile(
                                                    title: const SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                            "Prezzo variabile")),
                                                    value: isFreePriceProduct
                                                        .value,
                                                    onChanged: (bool? value) {
                                                      isFreePriceProduct.value =
                                                          value!;
                                                    },
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading);
                                              },
                                              valueListenable:
                                                  isFreePriceProduct,
                                            ),
                                          )
                                        ]),
                                        // trailing: const Icon(Icons.edit),
                                        leading: const Icon(Icons.local_offer),
                                        onTap: () {},
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
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(children: [
                                          Expanded(
                                            child: CheckboxListTile(
                                                title: const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                        "Fuori assortimento")),
                                                value: isOutOfAssortment,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isOutOfAssortment = value!;
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading),
                                          )
                                        ]),
                                        // trailing: const Icon(Icons.edit),
                                        leading: const Icon(Icons.warehouse),
                                        onTap: () {},
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
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    textEditingControllerIdFinalizzazione,
                                                minLines: 1,
                                                maxLines: 1,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0), //or 15.0
                                              child: Container(
                                                height: 48.0,
                                                width: 140.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                child: Center(
                                                  child: Text(
                                                      "Id Finalizzazione",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            ),
                                            // CircleAvatar(
                                            //   radius: 24,
                                            //   backgroundColor: Theme.of(context)
                                            //       .colorScheme
                                            //       .secondaryContainer,
                                            //   child: Text("Fid",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .headlineLarge),
                                            // ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    textEditingControllerIdEvento,
                                                minLines: 1,
                                                maxLines: 1,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0), //or 15.0
                                              child: Container(
                                                height: 48.0,
                                                width: 140.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                child: Center(
                                                  child: Text("Id Evento",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            ),
                                            // CircleAvatar(
                                            //   radius: 24,
                                            //   backgroundColor: Theme.of(context)
                                            //       .colorScheme
                                            //       .secondaryContainer,
                                            //   child: Text("Ev",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .headlineLarge),
                                            // ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    )
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
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    textEditingControllerIdAttivita,
                                                minLines: 1,
                                                maxLines: 1,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0), //or 15.0
                                              child: Container(
                                                height: 48.0,
                                                width: 140.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                child: Center(
                                                  child: Text("Id Attività",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            ),
                                            // CircleAvatar(
                                            //   radius: 24,
                                            //   backgroundColor: Theme.of(context)
                                            //       .colorScheme
                                            //       .secondaryContainer,
                                            //   child: Text("Att",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .headlineLarge),
                                            // ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    textEditingControllerIdAgenda,
                                                minLines: 1,
                                                maxLines: 1,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0), //or 15.0
                                              child: Container(
                                                height: 48.0,
                                                width: 140.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                child: Center(
                                                  child: Text("Id Agenda",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            ),
                                            // CircleAvatar(
                                            //   radius: 24,
                                            //   backgroundColor: Theme.of(context)
                                            //       .colorScheme
                                            //       .secondaryContainer,
                                            //   child: Text("Ag",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .headlineLarge),
                                            // ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    )
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
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    textEditingControllerIdComunicazioni,
                                                minLines: 1,
                                                maxLines: 1,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0), //or 15.0
                                              child: Container(
                                                height: 48.0,
                                                width: 140.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                child: Center(
                                                  child: Text(
                                                      "Id Comunicazioni",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            ),
                                            // CircleAvatar(
                                            //   radius: 24,
                                            //   backgroundColor: Theme.of(context)
                                            //       .colorScheme
                                            //       .secondaryContainer,
                                            //   child: Text("Com",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .headlineLarge),
                                            // ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    textEditingControllerIdTipDonazione,
                                                minLines: 1,
                                                maxLines: 1,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0), //or 15.0
                                              child: Container(
                                                height: 48.0,
                                                width: 140.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                child: Center(
                                                  child: Text("Tipo Donazione",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            ),
                                            // CircleAvatar(
                                            //   radius: 24,
                                            //   backgroundColor: Theme.of(context)
                                            //       .colorScheme
                                            //       .secondaryContainer,
                                            //   child: Text("Td",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .headlineLarge),
                                            // ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    )
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
                                    Card(
                                      color: Theme.of(context).cardColor,
                                      elevation: 4,
                                      child: ListTile(
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    textEditingControllerIdCatalogo,
                                                minLines: 1,
                                                maxLines: 1,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(Icons.edit),
                                        leading: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.0), //or 15.0
                                              child: Container(
                                                height: 48.0,
                                                width: 140.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryContainer,
                                                child: Center(
                                                  child: Text("Id Catalogo",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                ),
                                              ),
                                            ),
                                            // CircleAvatar(
                                            //   radius: 24,
                                            //   backgroundColor: Theme.of(context)
                                            //       .colorScheme
                                            //       .secondaryContainer,
                                            //   child: Text("Cat",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .headlineLarge),
                                            // ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          canAddProduct
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      ProductCatalogModel productCatalogModel =
                          ProductCatalogModel(
                              idProduct:
                                  widget.productCatalogModelArgument.idProduct,
                              idCategory:
                                  widget.productCatalogModelArgument.idCategory,
                              nameProduct:
                                  textEditingControllerNameProduct.text,
                              descriptionProduct:
                                  textEditingControllerDescriptionProduct.text,
                              priceProduct: double.tryParse(
                                      textEditingControllerPriceProduct.text) ??
                                  0,
                              freePriceProduct: isFreePriceProduct.value,
                              outOfAssortment: isOutOfAssortment,
                              barcode: textEditingControllerBarcodeProduct.text,
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
                      //         ProductCatalogDataModel: ProductCatalogDataModel)
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
                          // ProductCatalogDataModel ProductCatalogDataModel =
                          //     ProductCatalogDataModel(
                          //         idProduct: widget
                          //             .productCatalogModelArgument
                          //             .idProduct,
                          //         idStore: widget
                          //             .productCatalogModelArgument.idStore,
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
                          //         ProductCatalogDataModel:
                          //             ProductCatalogDataModel)
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
