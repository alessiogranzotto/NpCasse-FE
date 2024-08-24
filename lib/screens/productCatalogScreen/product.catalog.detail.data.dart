import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class ProductCatalogDetailDataScreen extends StatefulWidget {
  final ProductCatalogModel productCatalogModelArgument;
  // final ProductCatalogDetailsArgs ProductCatalogDetailsArguments;
  const ProductCatalogDetailDataScreen({
    super.key,
    required this.productCatalogModelArgument,
  });

  @override
  State<ProductCatalogDetailDataScreen> createState() =>
      _ProductCatalogDetailState();
}

class _ProductCatalogDetailState extends State<ProductCatalogDetailDataScreen> {
  final ValueNotifier<bool> freePriceProduct = ValueNotifier<bool>(false);
  final ValueNotifier<bool> outOfAssortment = ValueNotifier<bool>(false);
  bool deleted = false;
  String tImageString = '';
  bool isEdit = false;
  bool panelIdsGiveExpanded = false;
  bool panelOtherExpanded = false;

  final TextEditingController textEditingControllerNameProduct =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionProduct =
      TextEditingController();

  CurrencyTextFieldController textEditingControllerPriceProduct =
      CurrencyTextFieldController(
          decimalSymbol: ',',
          thousandSymbol: '',
          currencySeparator: '',
          currencySymbol: '',
          enableNegative: false,
          numberOfDecimals: 2,
          initDoubleValue: 0,
          maxDigits: 8);
  final TextEditingController textEditingControllerDisplayOrderProduct =
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

  int idCategory = 0;
  List<DropdownMenuItem<String>> availableCategory = [];

  Future<void> getAvailableCategories() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    CategoryCatalogNotifier categoryCatalogNotifier =
        Provider.of<CategoryCatalogNotifier>(context, listen: false);

    List<DropdownMenuItem<String>> tAvailableLevelCategory = [];

    await categoryCatalogNotifier
        .getCategories(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idCategory: 0,
            levelCategory: 'SecondLevelCategory',
            readAlsoDeleted: false,
            numberResult: 'All',
            nameDescSearch: '',
            readImageData: false,
            orderBy: '')
        .then((value) {
      tAvailableLevelCategory.add(
        DropdownMenuItem(child: Text('Selezionare la categoria'), value: '0'),
      );
      for (int i = 0; i < value.length; i++) {
        tAvailableLevelCategory.add(
          DropdownMenuItem(
              child: Text(value[i].nameCategory),
              value: value[i].idCategory.toString()),
        );
      }
      setState(() {
        availableCategory = tAvailableLevelCategory;
      });
    });
  }

  void onChangeCategory(String value) {
    idCategory = int.tryParse(value) ?? 0;
  }

  @override
  void initState() {
    idCategory = widget.productCatalogModelArgument.idCategory;
    isEdit = widget.productCatalogModelArgument.idProduct != 0;
    getAvailableCategories();
    print(availableCategory);

    if (widget.productCatalogModelArgument.idCategory != 0) {
      textEditingControllerNameProduct.text =
          widget.productCatalogModelArgument.nameProduct;
      textEditingControllerDisplayOrderProduct.text =
          widget.productCatalogModelArgument.displayOrder.toString();
      textEditingControllerDescriptionProduct.text =
          widget.productCatalogModelArgument.descriptionProduct;
      tImageString = widget.productCatalogModelArgument.imageData;
      var t1 = widget.productCatalogModelArgument.priceProduct.toString();
      String t2 = '';
      if (t1.contains('.')) {
        t2 = t1.replaceAll('.', ',');
      } else {
        t2 = t1 + ',00';
      }
      textEditingControllerPriceProduct.text = t2;
      textEditingControllerBarcodeProduct.text =
          widget.productCatalogModelArgument.barcode.toString();
      freePriceProduct.value =
          widget.productCatalogModelArgument.freePriceProduct;
      outOfAssortment.value =
          widget.productCatalogModelArgument.outOfAssortment;
      deleted = widget.productCatalogModelArgument.deleted;
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
    ProductCatalogNotifier productCatalogNotifier =
        Provider.of<ProductCatalogNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Dettaglio prodotto: ${widget.productCatalogModelArgument.nameProduct}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
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
                      flex: 4,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Nome prodotto',
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
                                            textEditingControllerNameProduct,
                                        minLines: 1,
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
                      flex: 3,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Descrizione prodotto',
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
                                            textEditingControllerDescriptionProduct,
                                        minLines: 1,
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
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Barcode prodotto',
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
                                            textEditingControllerBarcodeProduct,
                                        // keyboardType: const TextInputType
                                        //     .numberWithOptions(),

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
                                leading: const Icon(Icons.barcode_reader),
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
                      flex: 8,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Categoria prodotto',
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
                                        child: CustomDropDownButtonFormField(
                                      validator: (value) =>
                                          value!.toString().isEmpty
                                              ? "Inserire la nazione"
                                              : null,
                                      actualValue: idCategory.toString(),
                                      labelText: '',
                                      listOfValue: availableCategory,
                                      onItemChanged: (String value) {
                                        onChangeCategory(value);
                                      },
                                    )),
                                  ],
                                ),
                                trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.book),
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
                      flex: 4,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Prezzo prodotto',
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
                                            textEditingControllerPriceProduct,
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
                                leading: const Icon(Icons.euro),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Prodotto a prezzo variabile ',
                            child: Card(
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
                                                child:
                                                    Text("Prezzo variabile")),
                                            value: freePriceProduct.value,
                                            onChanged: (bool? value) {
                                              freePriceProduct.value = value!;
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .leading);
                                      },
                                      valueListenable: freePriceProduct,
                                    ),
                                  )
                                ]),
                                // trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.local_offer),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Prodotto fuori assortimento',
                            child: Card(
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
                                                child:
                                                    Text("Fuori assortimento")),
                                            value: outOfAssortment.value,
                                            onChanged: (bool? value) {
                                              outOfAssortment.value = value!;
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .leading);
                                      },
                                      valueListenable: outOfAssortment,
                                    ),
                                  )
                                ]),
                                // trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.warehouse),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Prodotto cancellato',
                            child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 4,
                              child: ListTile(
                                subtitle: Row(children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                        title: const SizedBox(
                                            width: 100,
                                            child: Text("Cancellato")),
                                        value: deleted,
                                        onChanged: (bool? value) {
                                          // setState(() {
                                          //   deleted = value!;
                                          // });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading),
                                  )
                                ]),
                                // trailing: const Icon(Icons.edit),
                                leading: const Icon(Icons.delete_rounded),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
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
                                            textEditingControllerDisplayOrderProduct,
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        panelIdsGiveExpanded = isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('ID Give'),
                            subtitle: Text('Inserire i dettagli degli Id Give'),
                          );
                        },
                        body: Column(children: [
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
                                            //   child: Text("Fin",
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
                        ]),
                        isExpanded: panelIdsGiveExpanded,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                ProductCatalogModel productCatalogModel = ProductCatalogModel(
                    idProduct: widget.productCatalogModelArgument.idProduct,
                    idCategory: idCategory,
                    nameProduct: textEditingControllerNameProduct.text,
                    displayOrder: int.tryParse(
                            textEditingControllerDisplayOrderProduct.text) ??
                        0,
                    descriptionProduct:
                        textEditingControllerDescriptionProduct.text,
                    priceProduct: double.tryParse(
                            textEditingControllerPriceProduct.text
                                .replaceAll(',', '.')) ??
                        0,
                    freePriceProduct: freePriceProduct.value,
                    outOfAssortment: outOfAssortment.value,
                    isWishlisted: ValueNotifier<bool>(false),
                    barcode: textEditingControllerBarcodeProduct.text,
                    deleted: deleted,
                    idUserAppInstitution:
                        cUserAppInstitutionModel.idUserAppInstitution,
                    imageData: tImageString,
                    categoryName: '',
                    giveIdsFlatStructureModel: GiveIdsFlatStructureModel(
                      idFinalizzazione: int.tryParse(
                              textEditingControllerIdFinalizzazione.text) ??
                          0,
                      idEvento:
                          int.tryParse(textEditingControllerIdEvento.text) ?? 0,
                      idAttivita:
                          int.tryParse(textEditingControllerIdAttivita.text) ??
                              0,
                      idAgenda:
                          int.tryParse(textEditingControllerIdAgenda.text) ?? 0,
                      idComunicazioni: int.tryParse(
                              textEditingControllerIdComunicazioni.text) ??
                          0,
                      idTipDonazione: int.tryParse(
                              textEditingControllerIdTipDonazione.text) ??
                          0,
                      idCatalogo:
                          int.tryParse(textEditingControllerIdCatalogo.text) ??
                              0,
                    ),
                    productAttributeCombination: List.empty(),
                    smartProductAttributeJson: List.empty());

                productCatalogNotifier
                    .addOrUpdateProduct(
                        context: context,
                        token: authenticationNotifier.token,
                        productCatalogModel: productCatalogModel)
                    .then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackUtil.stylishSnackBar(
                            title: "Prodotti",
                            message: "Informazioni aggiornate",
                            contentType: "success"));
                    Navigator.of(context).pop();
                    productCatalogNotifier.refresh();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackUtil.stylishSnackBar(
                            title: "Prodotti",
                            message: "Errore di connessione",
                            contentType: "failure"));
                    Navigator.of(context).pop();
                  }
                });
              },
              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.check),
            ),
          ),
          (isEdit)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      var dialog = CustomAlertDialog(
                        title: "Eliminazione categoria",
                        content: "Si desidera procedere alla cancellazione?",
                        yesCallBack: () {
                          deleted = true;
                          ProductCatalogModel productCatalogModel =
                              ProductCatalogModel(
                                  idProduct: widget
                                      .productCatalogModelArgument.idProduct,
                                  idCategory: idCategory,
                                  nameProduct: textEditingControllerNameProduct
                                      .text,
                                  displayOrder:
                                      int.tryParse(
                                              textEditingControllerDisplayOrderProduct
                                                  .text) ??
                                          0,
                                  descriptionProduct:
                                      textEditingControllerDescriptionProduct
                                          .text,
                                  priceProduct:
                                      double
                                              .tryParse(
                                                  textEditingControllerPriceProduct
                                                      .text) ??
                                          0,
                                  freePriceProduct: freePriceProduct.value,
                                  outOfAssortment: outOfAssortment.value,
                                  isWishlisted: ValueNotifier<bool>(false),
                                  barcode:
                                      textEditingControllerBarcodeProduct.text,
                                  deleted: deleted,
                                  idUserAppInstitution: cUserAppInstitutionModel
                                      .idUserAppInstitution,
                                  imageData: tImageString,
                                  categoryName: '',
                                  giveIdsFlatStructureModel:
                                      GiveIdsFlatStructureModel(
                                    idFinalizzazione: int.tryParse(
                                            textEditingControllerIdFinalizzazione
                                                .text) ??
                                        0,
                                    idEvento: int.tryParse(
                                            textEditingControllerIdEvento
                                                .text) ??
                                        0,
                                    idAttivita: int.tryParse(
                                            textEditingControllerIdAttivita
                                                .text) ??
                                        0,
                                    idAgenda: int.tryParse(
                                            textEditingControllerIdAgenda
                                                .text) ??
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
                                            textEditingControllerIdCatalogo
                                                .text) ??
                                        0,
                                  ),
                                  productAttributeCombination: widget
                                      .productCatalogModelArgument
                                      .productAttributeCombination,
                                  smartProductAttributeJson: List.empty());

                          productCatalogNotifier
                              .addOrUpdateProduct(
                                  context: context,
                                  token: authenticationNotifier.token,
                                  productCatalogModel: productCatalogModel)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackUtil.stylishSnackBar(
                                      title: "Prodotti",
                                      message: "Informazioni aggiornate",
                                      contentType: "success"));
                              Navigator.of(context).pop();
                              productCatalogNotifier.refresh();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackUtil.stylishSnackBar(
                                      title: "Prodotti",
                                      message: "Errore di connessione",
                                      contentType: "failure"));
                              Navigator.of(context).pop();
                            }
                          });
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