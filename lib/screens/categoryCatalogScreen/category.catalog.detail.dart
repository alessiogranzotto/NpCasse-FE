import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
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
  bool deleted = false;
  bool panelIdsGiveExpanded = false;
  bool panelOtherExpanded = false;

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

  @override
  void initState() {
    parentIdCategory = widget.categoryCatalogModelArgument.parentIdCategory;
    idCategory = widget.categoryCatalogModelArgument.idCategory;
    isEdit = idCategory != 0;
    getAvailableCategories(0);
    print(availableCategory);

    if (widget.categoryCatalogModelArgument.idCategory != 0) {
      textEditingControllerNameCategory.text =
          widget.categoryCatalogModelArgument.nameCategory.toString();
      textEditingControllerDescriptionCategory.text =
          widget.categoryCatalogModelArgument.descriptionCategory;
      textEditingControllerDisplayOrderCategory.text =
          widget.categoryCatalogModelArgument.displayOrder.toString();

      deleted = widget.categoryCatalogModelArgument.deleted;
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
    CategoryCatalogNotifier categoryCatalogNotifier =
        Provider.of<CategoryCatalogNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    //bool canAddProduct = authenticationNotifier.canUserAddItem();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                                                  child: Text("Id Campagna",
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
                                                  child: Text("Id Evento",
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
                CategoryCatalogModel categoryCatalogModel =
                    CategoryCatalogModel(
                        idCategory:
                            widget.categoryCatalogModelArgument.idCategory,
                        nameCategory: textEditingControllerNameCategory.text,
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
                        giveIdsFlatStructureModel: GiveIdsFlatStructureModel(
                          idFinalizzazione: int.tryParse(
                                  textEditingControllerIdFinalizzazione.text) ??
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
                                  textEditingControllerIdComunicazioni.text) ??
                              0,
                          idTipDonazione: int.tryParse(
                                  textEditingControllerIdTipDonazione.text) ??
                              0,
                          idCatalogo: int.tryParse(
                                  textEditingControllerIdCatalogo.text) ??
                              0,
                        ));

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
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                var dialog = CustomAlertDialog(
                  title: "Eliminazione categoria",
                  content: Text("Si desidera procedere alla cancellazione?"),
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
                        // categoryCatalogNotifier.refresh();
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
        ]));
  }
}
