import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/functional.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/componenents/custom.chips.input/custom.chips.input.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/product.category.mapping.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/vat.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'package:string_similarity/string_similarity.dart';

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
  bool tempDeleted = false;
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
  // final TextEditingController textEditingControllerIdFinalizzazione =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdEvento =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdAttivita =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdAgenda =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdComunicazioni =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdTipDonazione =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdCatalogo =
  //     TextEditingController();
  //CUSTOM FIXED ID GIVE
  late List<String> customIdGive = [];
  // final TextEditingController textEditingControllerIdPagamentoContante =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdPagamentoBancomat =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdPagamentoCartaDiCredito =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdPagamentoAssegno =
  //     TextEditingController();
  final controllerCategory = MultiSelectController<CategoryCatalogModel>();
  int idCategory = 0;
  List<DropdownMenuItem<String>> availableCategory = [];

  List<DropdownMenuItem<String>> availableVat = [];

  String? selectedVat;
  bool isLoadingVat = true;
  bool institutionFiscalized = false;

  Future<void> getCategories(
      List<ProductCategoryMappingModel> productCategoryMappingModel) async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    CategoryCatalogNotifier categoryCatalogNotifier =
        Provider.of<CategoryCatalogNotifier>(context, listen: false);

    List<DropdownItem<CategoryCatalogModel>> tAvailableLevelCategory = [];

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
      for (int i = 0; i < value.length; i++) {
        var isPresent = productCategoryMappingModel
            .map((e) => e.idCategory)
            .contains(value[i].idCategory);
        tAvailableLevelCategory.add(
          DropdownItem(
              selected: isPresent,
              label: value[i].nameCategory,
              value: value[i]),
        );
      }
      controllerCategory.addItems(tAvailableLevelCategory);
    });
  }

  onVatChanged(value) {
    if (value == '') {
      selectedVat = null;
    } else {
      selectedVat = value;
    }
  }

  Future<void> getVat() async {
    setState(() {
      isLoadingVat = true;
    });
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    ProductCatalogNotifier productCatalogNotifier =
        Provider.of<ProductCatalogNotifier>(context, listen: false);

    await productCatalogNotifier
        .getVat(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            isDelayed: true)
        .then((value) {
      VatDataModel cVatDataModel = value as VatDataModel;
      if (cVatDataModel.institutionFiscalized) {
        setState(() {
          institutionFiscalized = true;
        });
        availableVat.add(
          DropdownMenuItem(child: Text(''), value: null),
        );
        List<VatModel>? cValue = cVatDataModel.vatModelList;
        for (int i = 0; i < cValue.length; i++) {
          availableVat.add(
            DropdownMenuItem(
                child: Text(cValue[i].descriptionVat),
                value: cValue[i].valueVat),
          );
        }
      } else {
        setState(() {
          institutionFiscalized = false;
        });
      }

      setState(() {
        isLoadingVat = false;
      });
    });
  }

  void onChangeCategory(String? value) {
    idCategory = value == null ? 0 : int.tryParse(value) ?? 0;
  }

  Widget chipBuilderCustomIdGive(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'customIdGive'),
      onSelected: (data) => onChipTapped(data, 'customIdGive'),
    );
  }

  void onChipTapped(String topping, String area) {}

  void onChipDeleted(String topping, String area) {
    setState(() {
      if (area == 'customIdGive') {
        customIdGive.remove(topping);
      }
    });
  }

  void onSubmitted(String text, String area) {
    if (area == 'customIdGive') {
      if (text.trim().isNotEmpty) {
        bool isOk = false;
        String input = text.trim();
        try {
          var splitOnEqual = input.split('=');

          //CONTROL FOR INT OR STRING
          bool canContinue = false;
          if (splitOnEqual.length == 2) {
            if (text.toLowerCase().startsWith('id') &&
                num.tryParse(splitOnEqual[1]) != null) {
              canContinue = true;
            } else if (text.toLowerCase().startsWith('codice') &&
                splitOnEqual[1].isNotEmpty) {
              canContinue = true;
            }
          }
          if (canContinue) {
            final bestMatch = StringSimilarity.findBestMatch(
                splitOnEqual[0].toLowerCase(), idGiveListNameProduct);
            if (bestMatch.bestMatch.rating != null) {
              if (bestMatch.bestMatch.rating! > 0.40) {
                String finalString =
                    bestMatch.bestMatch.target! + "=" + splitOnEqual[1];
                if (!customIdGive.any((item) => item
                    .toLowerCase()
                    .contains(bestMatch.bestMatch.target!.toLowerCase()))) {
                  setState(() {
                    customIdGive = <String>[...customIdGive, finalString];
                  });
                  isOk = true;
                }
              }
            }
          }
          if (!isOk) {
            ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                title: "Prodotti",
                message:
                    "Parametro Id Give non trovato, non corretto o già presente",
                contentType: "warning"));
          }
        } catch (e) {}
      } else {
        // _chipFocusNode.unfocus();
        // setState(() {
        //   giveIds = <String>[];
        // });
      }
    }
  }

  void onChanged(List<String> data, String area) {
    setState(() {
      if (area == 'customIdGive') {
        customIdGive = data;
      }
    });
  }

  @override
  void initState() {
    isEdit = widget.productCatalogModelArgument.idProduct != 0;
    // getAvailableCategories(0);

    getCategories(
        widget.productCatalogModelArgument.productCategoryMappingModel);
    getVat();
    if (widget.productCatalogModelArgument.idProduct != 0) {
      textEditingControllerNameProduct.text =
          widget.productCatalogModelArgument.nameProduct;
      textEditingControllerDisplayOrderProduct.text =
          widget.productCatalogModelArgument.displayOrder.toString();
      textEditingControllerDescriptionProduct.text =
          widget.productCatalogModelArgument.descriptionProduct;
      tImageString = widget.productCatalogModelArgument.imageData;
      var t1 =
          widget.productCatalogModelArgument.priceProduct.toStringAsFixed(2);
      String t2 = '';
      t2 = t1.replaceAll('.', ',');
      textEditingControllerPriceProduct.text = t2;
      textEditingControllerBarcodeProduct.text =
          widget.productCatalogModelArgument.barcode.toString();
      freePriceProduct.value =
          widget.productCatalogModelArgument.freePriceProduct;
      outOfAssortment.value =
          widget.productCatalogModelArgument.outOfAssortment;
      deleted = widget.productCatalogModelArgument.deleted;
      tempDeleted = deleted;
      tImageString = widget.productCatalogModelArgument.imageData;
      selectedVat = widget.productCatalogModelArgument.valueVat;
      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idFinalizzazione >
          0) {
        // textEditingControllerIdFinalizzazione.text = widget
        //     .productCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idFinalizzazione
        //     .toString();
        customIdGive.add("IdFinalizzazione=" +
            widget.productCatalogModelArgument.giveIdsFlatStructureModel
                .idFinalizzazione
                .toString());
      } else {
        // textEditingControllerIdFinalizzazione.text = '';
      }
      if (widget
              .productCatalogModelArgument.giveIdsFlatStructureModel.idEvento >
          0) {
        // textEditingControllerIdEvento.text = widget
        //     .productCatalogModelArgument.giveIdsFlatStructureModel.idEvento
        //     .toString();

        customIdGive.add("IdEvento=" +
            widget
                .productCatalogModelArgument.giveIdsFlatStructureModel.idEvento
                .toString());
      } else {
        // textEditingControllerIdEvento.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idAttivita >
          0) {
        // textEditingControllerIdAttivita.text = widget
        //     .productCatalogModelArgument.giveIdsFlatStructureModel.idAttivita
        //     .toString();

        customIdGive.add("IdAttività=" +
            widget.productCatalogModelArgument.giveIdsFlatStructureModel
                .idAttivita
                .toString());
      } else {
        // textEditingControllerIdAttivita.text = '';
      }

      if (widget
              .productCatalogModelArgument.giveIdsFlatStructureModel.idAgenda >
          0) {
        // textEditingControllerIdAgenda.text = widget
        //     .productCatalogModelArgument.giveIdsFlatStructureModel.idAgenda
        //     .toString();

        customIdGive.add("IdAgenda=" +
            widget
                .productCatalogModelArgument.giveIdsFlatStructureModel.idAgenda
                .toString());
      } else {
        // textEditingControllerIdAgenda.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idComunicazioni >
          0) {
        // textEditingControllerIdComunicazioni.text = widget
        //     .productCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idComunicazioni
        //     .toString();
        customIdGive.add("IdComunicazioni=" +
            widget.productCatalogModelArgument.giveIdsFlatStructureModel
                .idComunicazioni
                .toString());
      } else {
        // textEditingControllerIdComunicazioni.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idTipDonazione >
          0) {
        // textEditingControllerIdTipDonazione.text = widget
        //     .productCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idTipDonazione
        //     .toString();
        customIdGive.add("IdTipDonazione=" +
            widget.productCatalogModelArgument.giveIdsFlatStructureModel
                .idTipDonazione
                .toString());
      } else {
        // textEditingControllerIdTipDonazione.text = '';
      }

      if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
              .idCatalogo >
          0) {
        // textEditingControllerIdCatalogo.text = widget
        //     .productCatalogModelArgument.giveIdsFlatStructureModel.idCatalogo
        //     .toString();
        customIdGive.add("IdCatalogo=" +
            widget.productCatalogModelArgument.giveIdsFlatStructureModel
                .idCatalogo
                .toString());
      } else {
        // textEditingControllerIdCatalogo.text = '';
      }

      // if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
      //         .idPagamentoContante >
      //     0) {
      //   textEditingControllerIdPagamentoContante.text = widget
      //       .productCatalogModelArgument
      //       .giveIdsFlatStructureModel
      //       .idPagamentoContante
      //       .toString();
      // } else {
      //   textEditingControllerIdPagamentoContante.text = '';
      // }
      // if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
      //         .idPagamentoBancomat >
      //     0) {
      //   textEditingControllerIdPagamentoBancomat.text = widget
      //       .productCatalogModelArgument
      //       .giveIdsFlatStructureModel
      //       .idPagamentoBancomat
      //       .toString();
      // } else {
      //   textEditingControllerIdPagamentoBancomat.text = '';
      // }
      // if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
      //         .idPagamentoCartaDiCredito >
      //     0) {
      //   textEditingControllerIdPagamentoCartaDiCredito.text = widget
      //       .productCatalogModelArgument
      //       .giveIdsFlatStructureModel
      //       .idPagamentoCartaDiCredito
      //       .toString();
      // } else {
      //   textEditingControllerIdPagamentoCartaDiCredito.text = '';
      // }
      // if (widget.productCatalogModelArgument.giveIdsFlatStructureModel
      //         .idPagamentoAssegno >
      //     0) {
      //   textEditingControllerIdPagamentoAssegno.text = widget
      //       .productCatalogModelArgument
      //       .giveIdsFlatStructureModel
      //       .idPagamentoAssegno
      //       .toString();
      // } else {
      //   textEditingControllerIdPagamentoAssegno.text = '';
      // }
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
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
                      flex: 5,
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
                      flex: 12,
                      child: Column(
                        children: [
                          Tooltip(
                            message: 'Categorie prodotto',
                            child: Card(
                              color: Theme.of(context).cardColor,
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MultiDropdown<CategoryCatalogModel>(
                                    items: [],
                                    controller: controllerCategory,
                                    enabled: true,
                                    searchEnabled: true,
                                    chipDecoration: ChipDecoration(
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(width: 1.5),
                                      backgroundColor: Colors.transparent,
                                      wrap: true,
                                      runSpacing: 2,
                                      spacing: 10,
                                    ),
                                    fieldDecoration: FieldDecoration(
                                      hintText: 'Selezionare le categorie...',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.3)),
                                      prefixIcon:
                                          const Icon(Icons.article_outlined),
                                      showClearIcon: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    dropdownItemDecoration:
                                        DropdownItemDecoration(
                                      selectedIcon: const Icon(Icons.check_box,
                                          color: Colors.green),
                                      disabledIcon: Icon(Icons.lock,
                                          color: Colors.grey.shade300),
                                    ),
                                    validator: (value) {
                                      // if (value == null || value.isEmpty) {
                                      //   return 'Please select a country';
                                      // }
                                      return null;
                                    },
                                    onSelectionChange: (selectedItems) {},
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLoadingVat
                        ? Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: JumpingDots(
                                color: CustomColors.darkBlue,
                                radius: 10,
                                numberOfDots: 5,
                              ),
                            ))
                        : institutionFiscalized
                            ? Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Tooltip(
                                      message: 'Iva',
                                      child: Card(
                                        color: Theme.of(context).cardColor,
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomDropDownButtonFormField(
                                              enabled: true,
                                              actualValue: selectedVat,
                                              labelText: 'IVA',
                                              listOfValue: availableVat,
                                              onItemChanged: (value) {
                                                onVatChanged(value);
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(flex: 4, child: SizedBox.shrink()),
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
                                          if (isEdit && tempDeleted) {
                                            setState(() {
                                              deleted = value!;
                                            });
                                          }
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

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ExpansionPanelList(
                //     expansionCallback: (panelIndex, isExpanded) {
                //       setState(() {
                //         panelIdsGiveExpanded = isExpanded;
                //       });
                //     },
                //     children: [
                //       ExpansionPanel(
                //         canTapOnHeader: true,
                //         headerBuilder: (BuildContext context, bool isExpanded) {
                //           return ListTile(
                //             title: Text('ID Give'),
                //             subtitle: Text('Inserire i dettagli degli Id Give'),
                //           );
                //         },
                //         body: Column(children: [
                //           Row(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Expanded(
                //                 child: Column(
                //                   children: [
                //                     Card(
                //                       color: Theme.of(context).cardColor,
                //                       elevation: 4,
                //                       child: ListTile(
                //                         subtitle: Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextField(
                //                                 controller:
                //                                     textEditingControllerIdFinalizzazione,
                //                                 minLines: 1,
                //                                 maxLines: 1,
                //                                 inputFormatters: <TextInputFormatter>[
                //                                   FilteringTextInputFormatter
                //                                       .digitsOnly
                //                                 ],
                //                                 onTapOutside: (event) {
                //                                   FocusManager
                //                                       .instance.primaryFocus
                //                                       ?.unfocus();
                //                                 },
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         trailing: const Icon(Icons.edit),
                //                         leading: Column(
                //                           mainAxisSize: MainAxisSize.min,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               height: 36.0,
                //                               width: 100.0,
                //                               color: CustomColors.darkBlue,
                //                               child: Center(
                //                                 child: Text("Id Finalizzazione",
                //                                     textAlign: TextAlign.center,
                //                                     style: Theme.of(context)
                //                                         .textTheme
                //                                         .headlineSmall),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         onTap: () {},
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               Expanded(
                //                 child: Column(
                //                   children: [
                //                     Card(
                //                       color: Theme.of(context).cardColor,
                //                       elevation: 4,
                //                       child: ListTile(
                //                         subtitle: Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextField(
                //                                 controller:
                //                                     textEditingControllerIdEvento,
                //                                 minLines: 1,
                //                                 maxLines: 1,
                //                                 inputFormatters: <TextInputFormatter>[
                //                                   FilteringTextInputFormatter
                //                                       .digitsOnly
                //                                 ],
                //                                 onTapOutside: (event) {
                //                                   FocusManager
                //                                       .instance.primaryFocus
                //                                       ?.unfocus();
                //                                 },
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         trailing: const Icon(Icons.edit),
                //                         leading: Column(
                //                           mainAxisSize: MainAxisSize.min,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               height: 36.0,
                //                               width: 100.0,
                //                               color: CustomColors.darkBlue,
                //                               child: Center(
                //                                 child: Text("Id Campagna",
                //                                     textAlign: TextAlign.center,
                //                                     style: Theme.of(context)
                //                                         .textTheme
                //                                         .headlineSmall),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         onTap: () {},
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               Expanded(
                //                 child: Column(
                //                   children: [
                //                     Card(
                //                       color: Theme.of(context).cardColor,
                //                       elevation: 4,
                //                       child: ListTile(
                //                         subtitle: Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextField(
                //                                 controller:
                //                                     textEditingControllerIdAttivita,
                //                                 minLines: 1,
                //                                 maxLines: 1,
                //                                 inputFormatters: <TextInputFormatter>[
                //                                   FilteringTextInputFormatter
                //                                       .digitsOnly
                //                                 ],
                //                                 onTapOutside: (event) {
                //                                   FocusManager
                //                                       .instance.primaryFocus
                //                                       ?.unfocus();
                //                                 },
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         trailing: const Icon(Icons.edit),
                //                         leading: Column(
                //                           mainAxisSize: MainAxisSize.min,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               height: 36.0,
                //                               width: 100.0,
                //                               color: CustomColors.darkBlue,
                //                               child: Center(
                //                                 child: Text("Id Attività",
                //                                     textAlign: TextAlign.center,
                //                                     style: Theme.of(context)
                //                                         .textTheme
                //                                         .headlineSmall),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         onTap: () {},
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               Expanded(
                //                 child: Column(
                //                   children: [
                //                     Card(
                //                       color: Theme.of(context).cardColor,
                //                       elevation: 4,
                //                       child: ListTile(
                //                         subtitle: Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextField(
                //                                 controller:
                //                                     textEditingControllerIdAgenda,
                //                                 minLines: 1,
                //                                 maxLines: 1,
                //                                 inputFormatters: <TextInputFormatter>[
                //                                   FilteringTextInputFormatter
                //                                       .digitsOnly
                //                                 ],
                //                                 onTapOutside: (event) {
                //                                   FocusManager
                //                                       .instance.primaryFocus
                //                                       ?.unfocus();
                //                                 },
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         trailing: const Icon(Icons.edit),
                //                         leading: Column(
                //                           mainAxisSize: MainAxisSize.min,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               height: 36.0,
                //                               width: 100.0,
                //                               color: CustomColors.darkBlue,
                //                               child: Center(
                //                                 child: Text("Id Evento",
                //                                     textAlign: TextAlign.center,
                //                                     style: Theme.of(context)
                //                                         .textTheme
                //                                         .headlineSmall),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         onTap: () {},
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //           Row(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Expanded(
                //                 child: Column(
                //                   children: [
                //                     Card(
                //                       color: Theme.of(context).cardColor,
                //                       elevation: 4,
                //                       child: ListTile(
                //                         subtitle: Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextField(
                //                                 controller:
                //                                     textEditingControllerIdComunicazioni,
                //                                 minLines: 1,
                //                                 maxLines: 1,
                //                                 inputFormatters: <TextInputFormatter>[
                //                                   FilteringTextInputFormatter
                //                                       .digitsOnly
                //                                 ],
                //                                 onTapOutside: (event) {
                //                                   FocusManager
                //                                       .instance.primaryFocus
                //                                       ?.unfocus();
                //                                 },
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         trailing: const Icon(Icons.edit),
                //                         leading: Column(
                //                           mainAxisSize: MainAxisSize.min,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               height: 36.0,
                //                               width: 100.0,
                //                               color: CustomColors.darkBlue,
                //                               child: Center(
                //                                 child: Text("Id Comunicazioni",
                //                                     textAlign: TextAlign.center,
                //                                     style: Theme.of(context)
                //                                         .textTheme
                //                                         .headlineSmall),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         onTap: () {},
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               Expanded(
                //                 child: Column(
                //                   children: [
                //                     Card(
                //                       color: Theme.of(context).cardColor,
                //                       elevation: 4,
                //                       child: ListTile(
                //                         subtitle: Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextField(
                //                                 controller:
                //                                     textEditingControllerIdTipDonazione,
                //                                 minLines: 1,
                //                                 maxLines: 1,
                //                                 inputFormatters: <TextInputFormatter>[
                //                                   FilteringTextInputFormatter
                //                                       .digitsOnly
                //                                 ],
                //                                 onTapOutside: (event) {
                //                                   FocusManager
                //                                       .instance.primaryFocus
                //                                       ?.unfocus();
                //                                 },
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         trailing: const Icon(Icons.edit),
                //                         leading: Column(
                //                           mainAxisSize: MainAxisSize.min,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               height: 36.0,
                //                               width: 100.0,
                //                               color: CustomColors.darkBlue,
                //                               child: Center(
                //                                 child: Text("Tipo Donazione",
                //                                     textAlign: TextAlign.center,
                //                                     style: Theme.of(context)
                //                                         .textTheme
                //                                         .headlineSmall),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         onTap: () {},
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               Expanded(
                //                 child: Column(
                //                   children: [
                //                     Card(
                //                       color: Theme.of(context).cardColor,
                //                       elevation: 4,
                //                       child: ListTile(
                //                         subtitle: Row(
                //                           children: [
                //                             Expanded(
                //                               child: TextField(
                //                                 controller:
                //                                     textEditingControllerIdCatalogo,
                //                                 minLines: 1,
                //                                 maxLines: 1,
                //                                 inputFormatters: <TextInputFormatter>[
                //                                   FilteringTextInputFormatter
                //                                       .digitsOnly
                //                                 ],
                //                                 onTapOutside: (event) {
                //                                   FocusManager
                //                                       .instance.primaryFocus
                //                                       ?.unfocus();
                //                                 },
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         trailing: const Icon(Icons.edit),
                //                         leading: Column(
                //                           mainAxisSize: MainAxisSize.min,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               height: 36.0,
                //                               width: 100.0,
                //                               color: CustomColors.darkBlue,
                //                               child: Center(
                //                                 child: Text("Id Catalogo",
                //                                     textAlign: TextAlign.center,
                //                                     style: Theme.of(context)
                //                                         .textTheme
                //                                         .headlineSmall),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                         onTap: () {},
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),

                //         ]),
                //         isExpanded: panelIdsGiveExpanded,
                //       ),
                //     ],
                //   ),
                // ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Card(
                            color: Theme.of(context).cardColor,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Tooltip(
                                        message:
                                            idGiveListNameProduct.join("\n"),
                                        preferBelow: false,
                                        verticalOffset: 12,
                                        margin: EdgeInsets.all(16),
                                        child: Icon(Icons.help_outline),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: ChipsInput<String>(
                                          values: customIdGive,
                                          label: AppStrings.giveIds,
                                          decoration: const InputDecoration(),
                                          strutStyle:
                                              const StrutStyle(fontSize: 12),
                                          onChanged: (data) =>
                                              onChanged(data, 'customIdGive'),
                                          onSubmitted: (data) =>
                                              onSubmitted(data, 'customIdGive'),
                                          chipBuilder: chipBuilderCustomIdGive,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                List<ProductCategoryMappingModel>
                    cProductCategoryMappingModelList = [];
                for (int i = 0;
                    i < controllerCategory.selectedItems.length;
                    i++) {
                  cProductCategoryMappingModelList.add(
                      ProductCategoryMappingModel(
                          idProductCategoryMapping: 0,
                          idProduct:
                              widget.productCatalogModelArgument.idProduct,
                          idCategory: controllerCategory
                              .selectedItems[i].value.idCategory,
                          categoryModel: controllerCategory.items[i].value));
                }
                ProductCatalogModel productCatalogModel = ProductCatalogModel(
                    idProduct: widget.productCatalogModelArgument.idProduct,
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
                    wishlisted: false,
                    barcode: textEditingControllerBarcodeProduct.text,
                    valueVat: selectedVat,
                    deleted: deleted,
                    idUserAppInstitution:
                        cUserAppInstitutionModel.idUserAppInstitution,
                    imageData: tImageString,
                    // categoryName: '',
                    giveIdsFlatStructureModel:
                        GiveIdsFlatStructureModel.fromCustomIdGive(
                            customIdGive, "Product"),
                    // GiveIdsFlatStructureModel(
                    //     idFinalizzazione:
                    //         int.tryParse(textEditingControllerIdFinalizzazione.text) ??
                    //             0,
                    //     idEvento:
                    //         int.tryParse(textEditingControllerIdEvento.text) ??
                    //             0,
                    //     idAttivita:
                    //         int.tryParse(textEditingControllerIdAttivita.text) ?? 0,
                    //     idAgenda: int.tryParse(textEditingControllerIdAgenda.text) ?? 0,
                    //     idComunicazioni: int.tryParse(textEditingControllerIdComunicazioni.text) ?? 0,
                    //     idTipDonazione: int.tryParse(textEditingControllerIdTipDonazione.text) ?? 0,
                    //     idCatalogo: int.tryParse(textEditingControllerIdCatalogo.text) ?? 0,
                    //     idPagamentoContante: 0,
                    //     idPagamentoBancomat: 0,
                    //     idPagamentoCartaDiCredito: 0,
                    //     idPagamentoAssegno: 0
                    //     ),
                    productCategoryMappingModel:
                        cProductCategoryMappingModelList,
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
                    // wishlistProductNotifier.refresh();
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
          (isEdit && !tempDeleted)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      var dialog = CustomAlertDialog(
                        title: "Eliminazione prodotto",
                        content:
                            Text("Si desidera procedere alla cancellazione?"),
                        yesCallBack: () {
                          deleted = true;
                          ProductCatalogModel productCatalogModel =
                              ProductCatalogModel(
                                  idProduct: widget
                                      .productCatalogModelArgument.idProduct,
                                  nameProduct: textEditingControllerNameProduct
                                      .text,
                                  displayOrder: int.tryParse(
                                          textEditingControllerDisplayOrderProduct
                                              .text) ??
                                      0,
                                  descriptionProduct:
                                      textEditingControllerDescriptionProduct
                                          .text,
                                  priceProduct: double.tryParse(
                                          textEditingControllerPriceProduct
                                              .text) ??
                                      0,
                                  freePriceProduct: freePriceProduct.value,
                                  outOfAssortment: outOfAssortment.value,
                                  wishlisted: false,
                                  barcode:
                                      textEditingControllerBarcodeProduct.text,
                                  valueVat: selectedVat,
                                  deleted: deleted,
                                  idUserAppInstitution: cUserAppInstitutionModel
                                      .idUserAppInstitution,
                                  imageData: tImageString,
                                  // categoryName: '',
                                  giveIdsFlatStructureModel:
                                      GiveIdsFlatStructureModel
                                          .fromCustomIdGive(
                                              customIdGive, "Product"),
                                  // giveIdsFlatStructureModel: GiveIdsFlatStructureModel(
                                  //     idFinalizzazione: int.tryParse(
                                  //             textEditingControllerIdFinalizzazione.text) ??
                                  //         0,
                                  //     idEvento: int.tryParse(textEditingControllerIdEvento.text) ?? 0,
                                  //     idAttivita: int.tryParse(textEditingControllerIdAttivita.text) ?? 0,
                                  //     idAgenda: int.tryParse(textEditingControllerIdAgenda.text) ?? 0,
                                  //     idComunicazioni: int.tryParse(textEditingControllerIdComunicazioni.text) ?? 0,
                                  //     idTipDonazione: int.tryParse(textEditingControllerIdTipDonazione.text) ?? 0,
                                  //     idCatalogo: int.tryParse(textEditingControllerIdCatalogo.text) ?? 0,
                                  //     idPagamentoContante: 0,
                                  //     idPagamentoBancomat: 0,
                                  //     idPagamentoCartaDiCredito: 0,
                                  //     idPagamentoAssegno: 0

                                  //     ),
                                  productAttributeCombination: List.empty(),
                                  productCategoryMappingModel: List.empty(),
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
