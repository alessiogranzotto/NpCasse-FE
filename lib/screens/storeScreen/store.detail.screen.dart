import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/store.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/store.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class StoreDetailScreen extends StatefulWidget {
  final StoreModel storeModelArgument;
  // final ProjectDetailsArgs projectDetailsArguments;
  const StoreDetailScreen({
    Key? key,
    required this.storeModelArgument,
  }) : super(key: key);

  @override
  State<StoreDetailScreen> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetailScreen> {
  String tImageString = '';
  bool isEdit = false;

  final TextEditingController textEditingControllerNameStore =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionStore =
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
    isEdit = widget.storeModelArgument.idStore != 0;
    if (widget.storeModelArgument.idStore != 0) {
      textEditingControllerNameStore.text = widget.storeModelArgument.nameStore;
      textEditingControllerDescriptionStore.text =
          widget.storeModelArgument.descriptionStore;
      tImageString = widget.storeModelArgument.imageStore;
      if (widget.storeModelArgument.giveIdsFlatStructureModel.idFinalizzazione >
          0) {
        textEditingControllerIdFinalizzazione.text = widget
            .storeModelArgument.giveIdsFlatStructureModel.idFinalizzazione
            .toString();
      } else {
        textEditingControllerIdFinalizzazione.text = '';
      }
      if (widget.storeModelArgument.giveIdsFlatStructureModel.idEvento > 0) {
        textEditingControllerIdEvento.text = widget
            .storeModelArgument.giveIdsFlatStructureModel.idEvento
            .toString();
      } else {
        textEditingControllerIdEvento.text = '';
      }

      if (widget.storeModelArgument.giveIdsFlatStructureModel.idAttivita > 0) {
        textEditingControllerIdAttivita.text = widget
            .storeModelArgument.giveIdsFlatStructureModel.idAttivita
            .toString();
      } else {
        textEditingControllerIdAttivita.text = '';
      }

      if (widget.storeModelArgument.giveIdsFlatStructureModel.idAgenda > 0) {
        textEditingControllerIdAgenda.text = widget
            .storeModelArgument.giveIdsFlatStructureModel.idAgenda
            .toString();
      } else {
        textEditingControllerIdAgenda.text = '';
      }

      if (widget.storeModelArgument.giveIdsFlatStructureModel.idComunicazioni >
          0) {
        textEditingControllerIdComunicazioni.text = widget
            .storeModelArgument.giveIdsFlatStructureModel.idComunicazioni
            .toString();
      } else {
        textEditingControllerIdComunicazioni.text = '';
      }

      if (widget.storeModelArgument.giveIdsFlatStructureModel.idTipDonazione >
          0) {
        textEditingControllerIdTipDonazione.text = widget
            .storeModelArgument.giveIdsFlatStructureModel.idTipDonazione
            .toString();
      } else {
        textEditingControllerIdTipDonazione.text = '';
      }

      if (widget.storeModelArgument.giveIdsFlatStructureModel.idCatalogo > 0) {
        textEditingControllerIdCatalogo.text = widget
            .storeModelArgument.giveIdsFlatStructureModel.idCatalogo
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
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    bool canAddStore = authenticationNotifier.canUserAddItem();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Dettaglio negozi di ${storeNotifier.getNameStore}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         StoreModel storeModel = StoreModel(
          //             idStore: widget.storeModelArgument.idStore,
          //             idProject: widget.storeModelArgument.idProject,
          //             nameStore: textEditingControllerNameStore.text,
          //             descriptionStore:
          //                 textEditingControllerDescriptionStore.text,
          //             imageStore: tImageString,
          //             giveIdsFlatStructureModel: GiveIdsFlatStructureModel(
          //               idFinalizzazione: int.tryParse(
          //                       textEditingControllerIdFinalizzazione.text) ??
          //                   0,
          //               idEvento:
          //                   int.tryParse(textEditingControllerIdEvento.text) ??
          //                       0,
          //               idAttivita: int.tryParse(
          //                       textEditingControllerIdAttivita.text) ??
          //                   0,
          //               idAgenda:
          //                   int.tryParse(textEditingControllerIdAgenda.text) ??
          //                       0,
          //               idComunicazioni: int.tryParse(
          //                       textEditingControllerIdComunicazioni.text) ??
          //                   0,
          //               idTipDonazione: int.tryParse(
          //                       textEditingControllerIdTipDonazione.text) ??
          //                   0,
          //               idCatalogo: int.tryParse(
          //                       textEditingControllerIdCatalogo.text) ??
          //                   0,
          //             ));
          //         storeNotifier
          //             .addOrUpdateStore(
          //                 context: context,
          //                 token: authenticationNotifier.token,
          //                 idUserAppInstitution:
          //                     cUserAppInstitutionModel.idUserAppInstitution,
          //                 idProject: widget.storeModelArgument.idProject,
          //                 storeModel: storeModel)
          //             .then((value) {
          //           if (value) {
          //             ScaffoldMessenger.of(context).showSnackBar(
          //                 SnackUtil.stylishSnackBar(
          //                     title: "Negozi",
          //                     message: "Informazioni aggiornate",
          //                     contentType: "success"));

          //             Navigator.of(context).pop();
          //             storeNotifier.refresh();
          //           } else {
          //             ScaffoldMessenger.of(context).showSnackBar(
          //                 SnackUtil.stylishSnackBar(
          //                     title: "Negozi",
          //                     message: "Errore di connessione",
          //                     contentType: "failure"));

          //             Navigator.of(context).pop();
          //           }
          //         });
          //       },
          //       icon: const Icon(Icons.check)),
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
                              )

                              // CircleAvatar(
                              //     backgroundImage: ImageUtils.getImageFromString(
                              //             stringImage: tImageString)
                              //         .image),
                              ),
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
                                                    textEditingControllerNameStore,
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
                                                    textEditingControllerDescriptionStore,
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
                                                    textEditingControllerNameStore,
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
                                                    textEditingControllerDescriptionStore,
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
          canAddStore
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      StoreModel storeModel = StoreModel(
                          idStore: widget.storeModelArgument.idStore,
                          idProject: widget.storeModelArgument.idProject,
                          nameStore: textEditingControllerNameStore.text,
                          descriptionStore:
                              textEditingControllerDescriptionStore.text,
                          isDeleted: false,
                          imageStore: tImageString,
                          giveIdsFlatStructureModel: GiveIdsFlatStructureModel(
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
                                    textEditingControllerIdTipDonazione.text) ??
                                0,
                            idCatalogo: int.tryParse(
                                    textEditingControllerIdCatalogo.text) ??
                                0,
                          ));
                      storeNotifier
                          .addOrUpdateStore(
                              context: context,
                              token: authenticationNotifier.token,
                              idUserAppInstitution:
                                  cUserAppInstitutionModel.idUserAppInstitution,
                              idProject: widget.storeModelArgument.idProject,
                              storeModel: storeModel)
                          .then((value) {
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackUtil.stylishSnackBar(
                                  title: "Negozi",
                                  message: "Informazioni aggiornate",
                                  contentType: "success"));

                          Navigator.of(context).pop();
                          storeNotifier.refresh();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackUtil.stylishSnackBar(
                                  title: "Negozi",
                                  message: "Errore di connessione",
                                  contentType: "failure"));

                          Navigator.of(context).pop();
                        }
                      });
                    },
                    //backgroundColor: Colors.deepOrangeAccent,
                    child: const Icon(Icons.check),
                  ),
                )
              : const SizedBox.shrink(),
          (canAddStore && isEdit)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      var dialog = CustomAlertDialog(
                        title: "Eliminazione negozio",
                        content: "Si desidera procedere alla cancellazione?",
                        yesCallBack: () {
                          StoreModel storeModel = StoreModel(
                              idStore: widget.storeModelArgument.idStore,
                              idProject: widget.storeModelArgument.idProject,
                              nameStore: textEditingControllerNameStore.text,
                              descriptionStore:
                                  textEditingControllerDescriptionStore.text,
                              isDeleted: true,
                              imageStore: tImageString,
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
                          storeNotifier
                              .addOrUpdateStore(
                                  context: context,
                                  token: authenticationNotifier.token,
                                  idUserAppInstitution: cUserAppInstitutionModel
                                      .idUserAppInstitution,
                                  idProject:
                                      widget.storeModelArgument.idProject,
                                  storeModel: storeModel)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackUtil.stylishSnackBar(
                                      title: "Negozi",
                                      message: "Informazioni aggiornate",
                                      contentType: "success"));

                              Navigator.of(context).pop();
                              storeNotifier.refresh();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackUtil.stylishSnackBar(
                                      title: "Negozi",
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
