import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/functional.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/componenents/custom.chips.input/custom.chips.input.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'package:string_similarity/string_similarity.dart';

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
  bool deleted = false;
  bool tempDeleted = false;
  bool panelIdsGiveExpanded = false;
  bool panelOtherExpanded = false;

  final TextEditingController textEditingControllerNameCategory =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionCategory =
      TextEditingController();
  final TextEditingController textEditingControllerDisplayOrderCategory =
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

  // final TextEditingController textEditingControllerIdPagamentoContante =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdPagamentoBancomat =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdPagamentoCartaDiCredito =
  //     TextEditingController();
  // final TextEditingController textEditingControllerIdPagamentoAssegno =
  //     TextEditingController();

  //CUSTOM FIXED ID GIVE
  late List<String> customIdGive = [];
  int parentIdCategory = 0;
  int idCategory = 0;
  List<DropdownMenuItem<String>> availableCategory = [];

  Future<void> getAvailableCategories(int cIdCategory) async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    CategoryCatalogNotifier categoryCatalogNotifier =
        Provider.of<CategoryCatalogNotifier>(context, listen: false);
    List<DropdownMenuItem<String>> tAvailableLevelCategory = [];
    tAvailableLevelCategory.add(DropdownMenuItem(
        child: Text('Categoria di primo livello'), value: '0'));
    await categoryCatalogNotifier
        .getCategories(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idCategory: cIdCategory,
            levelCategory: 'FirstLevelCategory',
            readAlsoDeleted: false,
            numberResult: 'All',
            nameDescSearch: '',
            readImageData: false,
            orderBy: '')
        .then((value) {
      for (int i = 0; i < value.length; i++) {
        //ESCLUDO SE STESSA
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

  void onChangeParentCategory(String value) {
    parentIdCategory = int.tryParse(value) ?? 0;
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
            final bestMatch = StringSimilarity.findBestMatch(
                splitOnEqual[0].toLowerCase(), idGiveListNameCategory);

            if (bestMatch.bestMatch.rating != null) {
              if (bestMatch.bestMatch.rating! > 0.40) {
                String finalString =
                    bestMatch.bestMatch.target! + "=" + splitOnEqual[1];
                if (finalString.startsWith('Id') &&
                    num.tryParse(splitOnEqual[1]) != null) {
                  canContinue = true;
                } else if (finalString.startsWith('Codice') &&
                    splitOnEqual[1].isNotEmpty) {
                  canContinue = true;
                } else if (finalString.startsWith('FonteSh') &&
                    num.tryParse(splitOnEqual[1]) != null) {
                  canContinue = true;
                } else if (finalString.startsWith('Ringraziato') &&
                    ["0", "1"].contains(splitOnEqual[1])) {
                  canContinue = true;
                }
                if (canContinue) {
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
          }

          if (!isOk) {
            ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                title: "Categorie",
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
    parentIdCategory = widget.categoryCatalogModelArgument.parentIdCategory;
    idCategory = widget.categoryCatalogModelArgument.idCategory;
    isEdit = idCategory != 0;
    getAvailableCategories(0);

    if (widget.categoryCatalogModelArgument.idCategory != 0) {
      textEditingControllerNameCategory.text =
          widget.categoryCatalogModelArgument.nameCategory.toString();
      textEditingControllerDescriptionCategory.text =
          widget.categoryCatalogModelArgument.descriptionCategory;
      textEditingControllerDisplayOrderCategory.text =
          widget.categoryCatalogModelArgument.displayOrder.toString();

      deleted = widget.categoryCatalogModelArgument.deleted;
      tempDeleted = deleted;
      tImageString = widget.categoryCatalogModelArgument.imageData;
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idFinalizzazione.isNotEmpty) {
        // textEditingControllerIdFinalizzazione.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idFinalizzazione
        //     .toString();
        customIdGive.add("IdFinalizzazione=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idFinalizzazione
                .toString());
      } else {
        // textEditingControllerIdFinalizzazione.text = '';
      }
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel.idEvento
          .isNotEmpty) {
        // textEditingControllerIdEvento.text = widget
        //     .categoryCatalogModelArgument.giveIdsFlatStructureModel.idEvento
        //     .toString();
        customIdGive.add("IdEvento=" +
            widget
                .categoryCatalogModelArgument.giveIdsFlatStructureModel.idEvento
                .toString());
      } else {
        // textEditingControllerIdEvento.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idAttivita.isNotEmpty) {
        // textEditingControllerIdAttivita.text = widget
        //     .categoryCatalogModelArgument.giveIdsFlatStructureModel.idAttivita
        //     .toString();
        customIdGive.add("IdAttività=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idAttivita
                .toString());
      } else {
        // textEditingControllerIdAttivita.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel.idAgenda
          .isNotEmpty) {
        // textEditingControllerIdAgenda.text = widget
        //     .categoryCatalogModelArgument.giveIdsFlatStructureModel.idAgenda
        //     .toString();
        customIdGive.add("IdAgenda=" +
            widget
                .categoryCatalogModelArgument.giveIdsFlatStructureModel.idAgenda
                .toString());
      } else {
        // textEditingControllerIdAgenda.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idComunicazioni.isNotEmpty) {
        // textEditingControllerIdComunicazioni.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idComunicazioni
        //     .toString();
        customIdGive.add("IdComunicazioni=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idComunicazioni
                .toString());
      } else {
        // textEditingControllerIdComunicazioni.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idTipDonazione.isNotEmpty) {
        // textEditingControllerIdTipDonazione.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idTipDonazione
        //     .toString();
        customIdGive.add("IdTipDonazione=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idTipDonazione
                .toString());
      } else {
        // textEditingControllerIdTipDonazione.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idCatalogo.isNotEmpty) {
        // textEditingControllerIdCatalogo.text = widget
        //     .categoryCatalogModelArgument.giveIdsFlatStructureModel.idCatalogo
        //     .toString();
        customIdGive.add("IdCatalogo=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idCatalogo
                .toString());
      } else {
        // textEditingControllerIdCatalogo.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idPromotore.isNotEmpty) {
        // textEditingControllerIdPromotore.text = widget
        //     .categoryCatalogModelArgument.giveIdsFlatStructureModel.IdPromotore
        //     .toString();
        customIdGive.add("IdPromotore=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idPromotore
                .toString());
      } else {
        // textEditingControllerIdPromotore.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idPagamentoContante.isNotEmpty) {
        // textEditingControllerIdPagamentoContante.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idPagamentoContante
        //     .toString();
        customIdGive.add("IdPagamentoContante=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idPagamentoContante
                .toString());
      } else {
        // textEditingControllerIdPagamentoContante.text = '';
      }
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idPagamentoBancomat.isNotEmpty) {
        // textEditingControllerIdPagamentoBancomat.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idPagamentoBancomat
        //     .toString();
        customIdGive.add("IdPagamentoBancomat=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idPagamentoBancomat
                .toString());
      } else {
        // textEditingControllerIdPagamentoBancomat.text = '';
      }
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idPagamentoCartaDiCredito.isNotEmpty) {
        // textEditingControllerIdPagamentoCartaDiCredito.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idPagamentoCartaDiCredito
        //     .toString();
        customIdGive.add("IdPagamentoCartaDiCredito=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idPagamentoCartaDiCredito
                .toString());
      } else {
        // textEditingControllerIdPagamentoCartaDiCredito.text = '';
      }
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .idPagamentoAssegno.isNotEmpty) {
        // textEditingControllerIdPagamentoAssegno.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idPagamentoAssegno
        //     .toString();
        customIdGive.add("IdPagamentoAssegno=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .idPagamentoAssegno
                .toString());
      } else {
        // textEditingControllerIdPagamentoAssegno.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .codiceSottoconto.isNotEmpty) {
        // textEditingControllerIdPagamentoAssegno.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idPagamentoAssegno
        //     .toString();
        customIdGive.add("CodiceSottoconto=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .codiceSottoconto
                .toString());
      } else {
        // textEditingControllerIdPagamentoAssegno.text = '';
      }

      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .codiceCentroRicavo.isNotEmpty) {
        // textEditingControllerIdPagamentoAssegno.text = widget
        //     .categoryCatalogModelArgument
        //     .giveIdsFlatStructureModel
        //     .idPagamentoAssegno
        //     .toString();
        customIdGive.add("CodiceCentroRicavo=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .codiceCentroRicavo
                .toString());
      } else {
        // textEditingControllerIdPagamentoAssegno.text = '';
      }
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel.fonteSh
          .isNotEmpty) {
        // textEditingControllerIdPromotore.text = widget
        //     .productCatalogModelArgument.giveIdsFlatStructureModel.idPromotore
        //     .toString();
        customIdGive.add("FonteSh=" +
            widget
                .categoryCatalogModelArgument.giveIdsFlatStructureModel.fonteSh
                .toString());
      } else {
        // textEditingControllerIdPromotore.text = '';
      }
      if (widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
          .ringraziato.isNotEmpty) {
        // textEditingControllerIdPromotore.text = widget
        //     .productCatalogModelArgument.giveIdsFlatStructureModel.idPromotore
        //     .toString();
        customIdGive.add("Ringraziato=" +
            widget.categoryCatalogModelArgument.giveIdsFlatStructureModel
                .ringraziato
                .toString());
      } else {
        // textEditingControllerIdPromotore.text = '';
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
    CategoryCatalogNotifier categoryCatalogNotifier =
        Provider.of<CategoryCatalogNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    //bool canAddProduct = authenticationNotifier.canUserAddItem();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Dettaglio categoria: ${widget.categoryCatalogModelArgument.nameCategory}',
            style: Theme.of(context).textTheme.headlineMedium,
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
                      flex: 5,
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
                    Expanded(
                      flex: 3,
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
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 10,
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
                                        child: CustomDropDownButtonFormField(
                                      enabled: true,
                                      actualValue: parentIdCategory.toString(),
                                      labelText: '',
                                      listOfValue: availableCategory,
                                      onItemChanged: (value) {
                                        onChangeParentCategory(value);
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
                SizedBox(height: 20),
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
                //           SizedBox(
                //             height: 30,
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
                //                                     textEditingControllerIdPagamentoContante,
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
                //                                 child: Text(
                //                                     "Id Pagamento contante",
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
                //                                     textEditingControllerIdPagamentoBancomat,
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
                //                                 child: Text(
                //                                     "Id Pagamento bancomat",
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
                //                                     textEditingControllerIdPagamentoCartaDiCredito,
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
                //                                 child: Text(
                //                                     "Id Pagamento carta di credito",
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
                //                                     textEditingControllerIdPagamentoAssegno,
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
                //                                 child: Text(
                //                                     "Id pagamento assegno",
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
                                            idGiveListNameCategory.join("\n"),
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
                CategoryCatalogModel categoryCatalogModel =
                    CategoryCatalogModel(
                  idCategory: widget.categoryCatalogModelArgument.idCategory,
                  nameCategory: textEditingControllerNameCategory.text,
                  descriptionCategory:
                      textEditingControllerDescriptionCategory.text,
                  parentIdCategory: parentIdCategory,
                  parentCategoryName: '',
                  displayOrder: int.tryParse(
                          textEditingControllerDisplayOrderCategory.text) ??
                      0,
                  deleted: deleted,
                  idUserAppInstitution:
                      cUserAppInstitutionModel.idUserAppInstitution,
                  imageData: tImageString,
                  giveIdsFlatStructureModel:
                      GiveIdsFlatStructureModel.fromCustomIdGive(
                          customIdGive, "Category"),
                  // giveIdsFlatStructureModel: GiveIdsFlatStructureModel(
                  //   idFinalizzazione: int.tryParse(
                  //           textEditingControllerIdFinalizzazione.text) ??
                  //       0,
                  //   idEvento: int.tryParse(
                  //           textEditingControllerIdEvento.text) ??
                  //       0,
                  //   idAttivita: int.tryParse(
                  //           textEditingControllerIdAttivita.text) ??
                  //       0,
                  //   idAgenda: int.tryParse(
                  //           textEditingControllerIdAgenda.text) ??
                  //       0,
                  //   idComunicazioni: int.tryParse(
                  //           textEditingControllerIdComunicazioni.text) ??
                  //       0,
                  //   idTipDonazione: int.tryParse(
                  //           textEditingControllerIdTipDonazione.text) ??
                  //       0,
                  //   idCatalogo: int.tryParse(
                  //           textEditingControllerIdCatalogo.text) ??
                  //       0,
                  //   idPagamentoContante: int.tryParse(
                  //           textEditingControllerIdPagamentoContante
                  //               .text) ??
                  //       0,
                  //   idPagamentoBancomat: int.tryParse(
                  //           textEditingControllerIdPagamentoBancomat
                  //               .text) ??
                  //       0,
                  //   idPagamentoCartaDiCredito: int.tryParse(
                  //           textEditingControllerIdPagamentoCartaDiCredito
                  //               .text) ??
                  //       0,
                  //   idPagamentoAssegno: int.tryParse(
                  //           textEditingControllerIdPagamentoAssegno
                  //               .text) ??
                  //       0,
                  //)
                );

                categoryCatalogNotifier
                    .addOrUpdateCategory(
                        context: context,
                        token: authenticationNotifier.token,
                        categoryCatalogModel: categoryCatalogModel)
                    .then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackUtil.stylishSnackBar(
                            title: "Categorie",
                            message: "Informazioni aggiornate",
                            contentType: "success"));
                    Navigator.of(context).pop();
                    categoryCatalogNotifier.refresh();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackUtil.stylishSnackBar(
                            title: "Categorie",
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
                        title: "Eliminazione categoria",
                        content:
                            Text("Si desidera procedere alla cancellazione?"),
                        yesCallBack: () {
                          deleted = true;
                          CategoryCatalogModel categoryCatalogModel =
                              CategoryCatalogModel(
                            idCategory:
                                widget.categoryCatalogModelArgument.idCategory,
                            nameCategory:
                                textEditingControllerNameCategory.text,
                            descriptionCategory:
                                textEditingControllerDescriptionCategory.text,
                            parentIdCategory: parentIdCategory,
                            parentCategoryName: '',
                            displayOrder: int.tryParse(
                                    textEditingControllerDisplayOrderCategory
                                        .text) ??
                                0,
                            deleted: deleted,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution,
                            imageData: tImageString,
                            giveIdsFlatStructureModel:
                                GiveIdsFlatStructureModel.fromCustomIdGive(
                                    customIdGive, "Category"),
                            // giveIdsFlatStructureModel:
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
                            //           idPagamentoContante: int.tryParse(
                            //                   textEditingControllerIdPagamentoContante
                            //                       .text) ??
                            //               0,
                            //           idPagamentoBancomat: int.tryParse(
                            //                   textEditingControllerIdPagamentoBancomat
                            //                       .text) ??
                            //               0,
                            //           idPagamentoCartaDiCredito: int.tryParse(
                            //                   textEditingControllerIdPagamentoCartaDiCredito
                            //                       .text) ??
                            //               0,
                            //           idPagamentoAssegno: int.tryParse(
                            //                   textEditingControllerIdPagamentoAssegno
                            //                       .text) ??
                            //               0,
                            //         )
                          );

                          categoryCatalogNotifier
                              .addOrUpdateCategory(
                                  context: context,
                                  token: authenticationNotifier.token,
                                  categoryCatalogModel: categoryCatalogModel)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackUtil.stylishSnackBar(
                                      title: "Categorie",
                                      message: "Informazioni aggiornate",
                                      contentType: "success"));
                              Navigator.of(context).pop();
                              categoryCatalogNotifier.refresh();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackUtil.stylishSnackBar(
                                      title: "Categorie",
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
