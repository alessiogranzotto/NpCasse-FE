import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/utilities/image.utils.dart';
import 'package:np_casse/componenents/custom.chips.input/custom.chips.input.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/myosotis.configuration.model.dart';

class ImagePickerCard extends StatelessWidget {
  const ImagePickerCard(
      {required this.label, required this.imageBase64, required this.onPick});

  final String label;
  final String imageBase64;
  final void Function(String) onPick;

  Future<void> _pick() async {
    final res = await ImageUtils.imageSelectorFile();
    onPick(res);
  }

  @override
  Widget build(BuildContext context) {
// Supponendo che imageBase64 sia una variabile esterna di tipo String?
    Widget imageWidget;

    try {
      if (imageBase64.trim().isEmpty) {
        // Nessuna immagine disponibile: uso null o gestisco altrove
        imageWidget = const SizedBox.shrink();
      } else {
        Uint8List bytes = base64Decode(imageBase64);
        imageWidget = Image.memory(
          bytes,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      }
    } catch (e) {
      // Base64 malformato o errore di decodifica
      imageWidget = const SizedBox.shrink();
    }

    return SizedBox(
      width: 240,
      child: Card(
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: imageWidget,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Tooltip(
                  message: 'Upload $label',
                  child: IconButton(
                    icon: const Icon(Icons.upload, size: 20),
                    onPressed: _pick,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FrequencyDonationAmountList extends StatefulWidget {
  final List<FrequencyContinuousDonation> frequencyContinuousDonationList;
  final List<String> availableFrequencies;
  final ValueChanged<List<FrequencyContinuousDonation>> onChanged; // callback

  const FrequencyDonationAmountList({
    Key? key,
    required this.frequencyContinuousDonationList,
    required this.availableFrequencies,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<FrequencyDonationAmountList> createState() =>
      _FrequencyDonationAmountListState();
}

class _FrequencyDonationAmountListState
    extends State<FrequencyDonationAmountList> {
  late List<FrequencyContinuousDonation> frequencyItem;

  @override
  void initState() {
    super.initState();
    frequencyItem = widget.frequencyContinuousDonationList
        .map((d) => FrequencyContinuousDonation(
              nameFrequencyContinuousDonation:
                  d.nameFrequencyContinuousDonation,
              amountFrequencyContinuousDonation:
                  List.from(d.amountFrequencyContinuousDonation),
              showFreeAmountNotifier: d.showFreeAmountNotifier,
            ))
        .toList();
  }

  void notifyParent() {
    widget.onChanged(frequencyItem);
  }

  void addFrequencyItem() {
    setState(() {
      frequencyItem.add(FrequencyContinuousDonation(
          nameFrequencyContinuousDonation:
              widget.availableFrequencies.isNotEmpty
                  ? widget.availableFrequencies.first
                  : '',
          amountFrequencyContinuousDonation: [],
          showFreeAmountNotifier: ValueNotifier(false)));
    });
    notifyParent();
  }

  void removeFrequencyItem(int index) {
    setState(() {
      frequencyItem.removeAt(index);
    });
    notifyParent();
  }

  void onChipDeleted(String topping, int index) {
    setState(() {
      frequencyItem[index].amountFrequencyContinuousDonation.remove(topping);
    });
    notifyParent();
  }

  void onChipTapped(String topping, int index) {
    // Se modifichi qualcosa qui, chiama notifyParent anche qui
  }

  void onFrequencyChanged(String? value, int index) {
    if (value == null) return;
    setState(() {
      frequencyItem[index].nameFrequencyContinuousDonation = value;
    });
    notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16), // spazio esterno opzionale
      padding: const EdgeInsets.all(12), // spazio interno opzionale
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // sfondo opzionale
        border: Border.all(
          color:
              Theme.of(context).colorScheme.inversePrimary, // colore del bordo
          width: 1, // spessore del bordo
        ),
        borderRadius: BorderRadius.circular(8), // angoli arrotondati
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: addFrequencyItem,
                    child: const Text("Aggiungi frequenza ed importi"),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: frequencyItem.length,
            itemBuilder: (context, index) {
              final item = frequencyItem[index];
              return buildDonationRow(item, index);
            },
          ),
        ],
      ),
    );
  }

  Widget buildDonationRow(FrequencyContinuousDonation donation, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: CustomDropDownButtonFormField(
                  enabled: true,
                  actualValue: donation.nameFrequencyContinuousDonation,
                  labelText: 'Frequenza donazione',
                  listOfValue: widget.availableFrequencies
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onItemChanged: (value) => onFrequencyChanged(value, index),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: ChipsInput<String>(
                  height: 60,
                  values: donation.amountFrequencyContinuousDonation,
                  label: 'Importi predefiniti',
                  strutStyle: const StrutStyle(fontSize: 12),
                  onChanged: (data) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      setState(() {
                        donation.amountFrequencyContinuousDonation =
                            List.from(data);
                      });
                      notifyParent();
                    });
                  },
                  onSubmitted: (data) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      setState(() {
                        if (!donation.amountFrequencyContinuousDonation
                            .contains(data)) {
                          donation.amountFrequencyContinuousDonation.add(data);
                        }
                      });
                      notifyParent();
                    });
                  },
                  chipBuilder: chipBuilderFrequencyItem(index),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: donation.showFreeAmountNotifier,
                  builder: (context, value, child) {
                    return CheckboxListTile(
                      title: Text(AppStrings.showFreePriceConfiguration),
                      value: value,
                      onChanged: (bool? newValue) {
                        donation.showFreeAmountNotifier.value =
                            newValue ?? false;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => removeFrequencyItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Function(BuildContext, String) chipBuilderFrequencyItem(int index) {
    return (BuildContext context, String topping) {
      return ToppingInputChip(
        topping: topping,
        onDeleted: (data) => onChipDeleted(data, index),
        onSelected: (data) => onChipTapped(data, index),
      );
    };
  }
}

class OptionalFieldWidget extends StatefulWidget {
  final List<OptionalField> optionalFieldList;
  final List<String> availableTypeOptionalField;
  final List<String> availableTextTypeOptionalField;
  final ValueChanged<List<OptionalField>> onChanged; // callback

  const OptionalFieldWidget({
    Key? key,
    required this.optionalFieldList,
    required this.availableTypeOptionalField,
    required this.availableTextTypeOptionalField,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OptionalFieldWidget> createState() => _OptionalFieldWidgetState();
}

class _OptionalFieldWidgetState extends State<OptionalFieldWidget> {
  late List<OptionalField> optionalFieldItem;
  List<TextEditingController> labelOptionalFieldController = [];
  List<TextEditingController> giveFieldNameOptionalFieldController = [];
  late List<ValueNotifier<bool>> showAvailableItemOptionalFieldList;

  @override
  void initState() {
    super.initState();
    optionalFieldItem = widget.optionalFieldList
        .map((d) => OptionalField(
              labelOptionalField: d.labelOptionalField,
              typeOptionalField: d.typeOptionalField,
              selectableDDOptionalField: List.from(d.selectableDDOptionalField),
              mantainOptionalFieldOnTransactionNotifier:
                  d.mantainOptionalFieldOnTransactionNotifier,
              giveFieldNameOptionalField: d.giveFieldNameOptionalField,
              mandatoryOptionalFieldNotifier: d.mandatoryOptionalFieldNotifier,
              textTypeOptionalField: d.textTypeOptionalField,
              // availableTextTypeOptionalField:
              //     List.from(d.availableTextTypeOptionalField),
            ))
        .toList();
    labelOptionalFieldController = optionalFieldItem
        .map((d) => TextEditingController(text: d.labelOptionalField))
        .toList();
    giveFieldNameOptionalFieldController = optionalFieldItem
        .map((d) => TextEditingController(text: d.giveFieldNameOptionalField))
        .toList();
    showAvailableItemOptionalFieldList = widget.optionalFieldList.map((d) {
      return ValueNotifier<bool>(d.typeOptionalField == 'Elenco a discesa');
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in labelOptionalFieldController) {
      controller.dispose();
    }
    super.dispose();
  }

  void notifyParent() {
    widget.onChanged(optionalFieldItem);
  }

  void addOptionalFieldItem() {
    setState(() {
      optionalFieldItem.add(OptionalField(
        labelOptionalField: '',
        typeOptionalField: widget.availableTypeOptionalField.first,
        selectableDDOptionalField: [],
        giveFieldNameOptionalField: '',
        mantainOptionalFieldOnTransactionNotifier: ValueNotifier(false),
        mandatoryOptionalFieldNotifier: ValueNotifier(false),
        textTypeOptionalField: widget.availableTextTypeOptionalField.first,
        // availableTextTypeOptionalField: []
      ));
      labelOptionalFieldController.add(TextEditingController());
      giveFieldNameOptionalFieldController.add(TextEditingController());
      showAvailableItemOptionalFieldList.add(ValueNotifier<bool>(false));
    });
    notifyParent();
  }

  void removeOptionalFieldItem(int index) {
    setState(() {
      optionalFieldItem.removeAt(index);
      labelOptionalFieldController.removeAt(index).dispose();
      giveFieldNameOptionalFieldController.removeAt(index).dispose();

      showAvailableItemOptionalFieldList.removeAt(index).dispose();
    });
    notifyParent();
  }

  void onChipDeleted(String topping, int index) {
    setState(() {
      optionalFieldItem[index].selectableDDOptionalField.remove(topping);
    });
    notifyParent();
  }

  void onChipTapped(String topping, int index) {
    // Se modifichi qualcosa qui, chiama notifyParent anche qui
  }

  void onTypeOptionalFieldChanged(String? value, int index) {
    if (value == null) return;
    setState(() {
      optionalFieldItem[index].typeOptionalField = value;
      optionalFieldItem[index].selectableDDOptionalField = [];
      optionalFieldItem[index].textTypeOptionalField =
          widget.availableTextTypeOptionalField.first;
      showAvailableItemOptionalFieldList[index].value =
          value == 'Elenco a discesa';
    });
    notifyParent();
  }

  void onTextTypeOptionalFieldChanged(String? value, int index) {
    if (value == null) return;
    setState(() {
      optionalFieldItem[index].textTypeOptionalField = value;
      showAvailableItemOptionalFieldList[index].value =
          value == 'Elenco a discesa';
    });
    notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16), // spazio esterno opzionale
      padding: const EdgeInsets.all(12), // spazio interno opzionale
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // sfondo opzionale
        border: Border.all(
          color:
              Theme.of(context).colorScheme.inversePrimary, // colore del bordo
          width: 1, // spessore del bordo
        ),
        borderRadius: BorderRadius.circular(8), // angoli arrotondati
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: addOptionalFieldItem,
                    child: const Text("Aggiungi elemento opzionale"),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: optionalFieldItem.length,
            itemBuilder: (context, index) {
              final item = optionalFieldItem[index];
              return buildOptionalFieldRow(item, index);
            },
          ),
        ],
      ),
    );
  }

  Widget buildOptionalFieldRow(OptionalField optionalField, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: CustomTextFormField(
                  enabled: true,
                  controller: labelOptionalFieldController[index],
                  labelText: AppStrings.labelOptionalField,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    optionalFieldItem[index].labelOptionalField = value;
                    notifyParent();
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable:
                      optionalField.mantainOptionalFieldOnTransactionNotifier,
                  builder: (context, value, child) {
                    return CheckboxListTile(
                      title: Text('Mantieni valore'),
                      value: value,
                      onChanged: (bool? newValue) {
                        optionalField.mantainOptionalFieldOnTransactionNotifier
                            .value = newValue ?? false;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: optionalField.mandatoryOptionalFieldNotifier,
                  builder: (context, value, child) {
                    return CheckboxListTile(
                      title: Text('Elemento obbligatorio'),
                      value: value,
                      onChanged: (bool? newValue) {
                        optionalField.mandatoryOptionalFieldNotifier.value =
                            newValue ?? false;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: CustomTextFormField(
                  enabled: true,
                  controller: giveFieldNameOptionalFieldController[index],
                  labelText: AppStrings.giveFieldOptionalField,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    optionalFieldItem[index].giveFieldNameOptionalField = value;
                    notifyParent();
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: CustomDropDownButtonFormField(
                  enabled: true,
                  actualValue: optionalField.typeOptionalField,
                  labelText: 'Tipo elemento opzionale',
                  listOfValue: widget.availableTypeOptionalField
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onItemChanged: (value) {
                    showAvailableItemOptionalFieldList[index].value =
                        (value ?? '') == 'Elenco a discesa';
                    onTypeOptionalFieldChanged(value, index);
                  },
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 2,
              child: ValueListenableBuilder<bool>(
                valueListenable: showAvailableItemOptionalFieldList[index],
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    child: value
                        ? Align(
                            alignment: Alignment.center,
                            child: ChipsInput<String>(
                              height: 60,
                              values: optionalField.selectableDDOptionalField,
                              label: AppStrings.availableTypeOptionalField,
                              strutStyle: const StrutStyle(fontSize: 12),
                              onChanged: (data) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    optionalField.selectableDDOptionalField =
                                        List.from(data);
                                  });
                                  notifyParent();
                                });
                              },
                              onSubmitted: (data) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    if (!optionalField.selectableDDOptionalField
                                        .contains(data)) {
                                      optionalField.selectableDDOptionalField
                                          .add(data);
                                    }
                                  });
                                  notifyParent();
                                });
                              },
                              chipBuilder: chipBuilderOptionalField(index),
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: optionalField.textTypeOptionalField,
                              labelText: 'Formato elemento',
                              listOfValue: widget.availableTextTypeOptionalField
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              onItemChanged: (value) {
                                showAvailableItemOptionalFieldList[index]
                                        .value =
                                    (value ?? '') == 'Elenco a discesa';
                                onTextTypeOptionalFieldChanged(value, index);
                              },
                            ),
                          ), // Contenitore vuoto che occupa lo spazio senza causare problemi
                  );
                },
              ),
            ),
            const SizedBox(width: 4),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => removeOptionalFieldItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Function(BuildContext, String) chipBuilderOptionalField(int index) {
    return (BuildContext context, String topping) {
      return ToppingInputChip(
        topping: topping,
        onDeleted: (data) => onChipDeleted(data, index),
        onSelected: (data) => onChipTapped(data, index),
      );
    };
  }
}
