import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/core/models/mass.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:uiblock/uiblock.dart';

class MassSendingRecipientScreen extends StatefulWidget {
  final MassSendingModel massSendingModel;
  const MassSendingRecipientScreen({super.key, required this.massSendingModel});

  @override
  State<MassSendingRecipientScreen> createState() =>
      _MyosotisConfigurationDetailState();
}

class _MyosotisConfigurationDetailState
    extends State<MassSendingRecipientScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isLoadingData = true;
  bool isLoading = true;
  //ISARCHIVED MASS SENDING
  final ValueNotifier<bool> archiviedNotifier = ValueNotifier<bool>(false);

  //GIVE ACCUMULATOR
  final accumulatorGiveController =
      MultiSelectController<AccumulatorGiveModel>();
  List<AccumulatorGiveModel> availableAccumulatorGive = List.empty();
  List<DropdownItem<AccumulatorGiveModel>> availableAccumulatorGiveItem = [];

  void initializeControllers() {
    accumulatorGiveController.addListener(dataControllerListener);
  }

  void disposeControllers() {
    accumulatorGiveController.dispose();
  }

  void dataControllerListener() {}

  Future<void> getMassSendingData() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context, listen: false);

    await massSendingNotifier
        .getAccumulatorFromGive(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idInstitution:
                cUserAppInstitutionModel.idInstitutionNavigation.idInstitution)
        .then((value) {
      var snapshot = value as List<AccumulatorGiveModel>;
      availableAccumulatorGive = snapshot;
      isLoadingData = false;

      setInitialData();
    });
  }

  void setInitialData() {
    //AVAILABLE ACCUMULATOR GIVE SENDING
    // availableAccumulatorGiveItem = availableAccumulatorGive
    //     .map<DropdownItem<AccumulatorGiveModel>>((AccumulatorGiveModel item) {
    //   return DropdownItem<AccumulatorGiveModel>(
    //       value: item, label: item.id.toString() + " - " + item.titolo);
    // }).toList();
    isEdit = widget.massSendingModel.idMassSending != 0;

    for (int i = 0; i < availableAccumulatorGive.length; i++) {
      var isPresent = widget.massSendingModel.massSendingGiveAccumulator
          .map((e) => e.idGiveAccumulator)
          .contains(availableAccumulatorGive[i].id);

      print(isPresent);
      availableAccumulatorGiveItem.add(DropdownItem(
          selected: isPresent,
          label: availableAccumulatorGive[i].id.toString() +
              " - " +
              availableAccumulatorGive[i].titolo,
          value: availableAccumulatorGive[i]));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    getMassSendingData();
  }

  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Dettaglio invio massivo: ${widget.massSendingModel.nameMassSending}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.redAccent,
                    )))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Row(
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
                                      child:
                                          MultiDropdown<AccumulatorGiveModel>(
                                        items: availableAccumulatorGiveItem,
                                        controller: accumulatorGiveController,
                                        enabled: true,
                                        searchEnabled: true,
                                        chipDecoration: ChipDecoration(
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          border: Border.all(width: 1.5),
                                          backgroundColor: Colors.transparent,
                                          wrap: true,
                                          runSpacing: 2,
                                          spacing: 10,
                                        ),
                                        fieldDecoration: FieldDecoration(
                                          hintText: 'Selezionare accumulatore',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor
                                                      .withOpacity(0.3)),
                                          prefixIcon: const Icon(
                                              Icons.article_outlined),
                                          showClearIcon: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        dropdownItemDecoration:
                                            DropdownItemDecoration(
                                          selectedIcon: const Icon(
                                              Icons.check_box,
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
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                              valueListenable:
                                  archiviedNotifier, // Ascolta i cambiamenti del ValueNotifier
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                    title: Text(
                                        "Ricrea il processo al salvataggio"),
                                    value: value,
                                    onChanged: (bool? newValue) {
                                      archiviedNotifier.value = newValue ??
                                          false; // Aggiorna il valore del ValueNotifier
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading);
                              },
                            )),
                      ],
                    )
                  ],
                ))),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  UIBlock.block(context);

                  List<MassSendingGiveAccumulator> massSendingGiveAccumulator =
                      [];
                  for (int i = 0;
                      i < accumulatorGiveController.selectedItems.length;
                      i++) {
                    massSendingGiveAccumulator.add(MassSendingGiveAccumulator(
                        idGiveAccumulator:
                            accumulatorGiveController.selectedItems[i].value.id,
                        titleGiveAccumulator: accumulatorGiveController
                            .selectedItems[i].value.titolo));
                  }

                  massSendingNotifier
                      .updateMassSendingGiveAccumulator(
                          context: context,
                          token: authenticationNotifier.token,
                          idMassSending: widget.massSendingModel.idMassSending,
                          idUserAppInstitution:
                              cUserAppInstitutionModel.idUserAppInstitution,
                          massSendingGiveAccumulator:
                              massSendingGiveAccumulator)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Comunicazioni",
                              message: "Informazioni aggiornate",
                              contentType: "success"));
                      UIBlock.unblock(context);
                      Navigator.of(context).pop();
                      massSendingNotifier.refresh();
                    } else {
                      UIBlock.unblock(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Comunicazioni",
                              message: "Errore di connessione",
                              contentType: "failure"));
                    }
                  });
                }
              },

              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.check),
            ),
          ),
        ]));
  }
}
