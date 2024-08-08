import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/componenents/text.form.field.dart';
import 'package:np_casse/core/models/product.attribute.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class TempPredefinedAttributeListModel {
  int idPredefinedProductAttributeValue;
  String namePredefinedAttribute;
  int displayOrderPredefinedAttribute;
  double priceAdjustmentPredefinedAttribute;
  TempPredefinedAttributeListModel({
    required this.idPredefinedProductAttributeValue,
    required this.namePredefinedAttribute,
    required this.displayOrderPredefinedAttribute,
    required this.priceAdjustmentPredefinedAttribute,
  });
}

class EditableListTile extends StatefulWidget {
  final TempPredefinedAttributeListModel model;
  final Function(TempPredefinedAttributeListModel listModel) onChanged;
  final Function(TempPredefinedAttributeListModel listModel) onRemove;

  const EditableListTile({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  late TempPredefinedAttributeListModel model;

  late bool isEditingMode;

  late TextEditingController nameEditingController,
      displayOrderEditingController;
  CurrencyTextFieldController priceAdjustmentEditingController =
      CurrencyTextFieldController();
  @override
  void initState() {
    super.initState();
    this.model = widget.model;
    this.isEditingMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: nameWidget,
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: displayOrderWidget,
                )),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: priceAdjustmentWidget,
                )),
          ],
        ),
        // subtitle: displayOrderWidget,
        trailing: Wrap(
          spacing: 12,
          children: <Widget>[
            tralingButtonEditConfirm,
            tralingButtonDelete,
          ],
        ),
      ),
    );
  }

  Widget get nameWidget {
    nameEditingController =
        TextEditingController(text: model.namePredefinedAttribute);
    return AGTextFormField(
      enabled: isEditingMode,
      labelText: 'Nome attributo predefinito (ad es. S, M, L, ..)',
      controller: nameEditingController,
    );
  }

  Widget get displayOrderWidget {
    displayOrderEditingController = TextEditingController(
        text: model.displayOrderPredefinedAttribute.toString());
    return AGTextFormField(
      enabled: isEditingMode,
      // maxLength: 2,
      inputFormatter: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      labelText: 'Ordine visualizzazione',
      controller: displayOrderEditingController,
    );
  }

  Widget get priceAdjustmentWidget {
    priceAdjustmentEditingController = CurrencyTextFieldController(
        decimalSymbol: ',',
        thousandSymbol: '',
        currencySeparator: '',
        currencySymbol: '',
        enableNegative: true,
        numberOfDecimals: 2,
        maxDigits: 8,
        initDoubleValue: model.priceAdjustmentPredefinedAttribute);

    return AGTextFormField(
      enabled: isEditingMode,
      // maxLength: 2,
      labelText: 'Regolazione prezzo (+/- rispetto al prezzo)',
      controller: priceAdjustmentEditingController,
      suffixIcon: Icon(Icons.euro),
    );
  }

  Widget get tralingButtonEditConfirm {
    if (isEditingMode) {
      return IconButton(
        icon: Icon(Icons.check),
        onPressed: saveChange,
      );
    } else
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: _toggleMode,
      );
  }

  Widget get tralingButtonDelete {
    return IconButton(
      icon: Icon(Icons.remove_circle),
      onPressed: isEditingMode ? null : removeItem,
    );
  }

  void _toggleMode() {
    setState(() {
      isEditingMode = !isEditingMode;
    });
  }

  void saveChange() {
    this.model.namePredefinedAttribute = nameEditingController.text;
    this.model.displayOrderPredefinedAttribute =
        int.tryParse(displayOrderEditingController.text) ?? 0;
    this.model.priceAdjustmentPredefinedAttribute = double.tryParse(
            priceAdjustmentEditingController.text.replaceAll(',', '.')) ??
        0;
    _toggleMode();
    widget.onChanged(this.model);
  }

  void removeItem() {
    widget.onRemove(this.model);
  }
}

class ProductAttributeDetailScreen extends StatefulWidget {
  final ProductAttributeModel productAttributeModelArgument;
  const ProductAttributeDetailScreen({
    super.key,
    required this.productAttributeModelArgument,
  });

  @override
  State<ProductAttributeDetailScreen> createState() =>
      _ProductAttributeDetailState();
}

class _ProductAttributeDetailState extends State<ProductAttributeDetailScreen> {
  bool isEdit = false;
  int idProductAttribute = 0;

  List<TempPredefinedAttributeListModel> listPredefinedAttributeListModel = [];

  int selectedIndex = -1;
  final TextEditingController textEditingControllerNameProductAttribute =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionProductAttribute =
      TextEditingController();

  // final TextEditingController
  //     textEditingControllerNamePredefinedProductAttribute =
  //     TextEditingController();
  // final TextEditingController
  //     textEditingControllerPriceAdjustmentUsePercentageProductAttribute =
  //     TextEditingController();
  // final TextEditingController
  //     textEditingControllerPriceAdjustmentProductAttribute =
  //     TextEditingController();
  // final TextEditingController
  //     textEditingControllerDisplayOrderProductAttribute =
  //     TextEditingController();
  @override
  void initState() {
    super.initState();
    isEdit = widget.productAttributeModelArgument.idProductAttribute != 0;
    if (isEdit) {
      idProductAttribute =
          widget.productAttributeModelArgument.idProductAttribute;
      textEditingControllerNameProductAttribute.text =
          widget.productAttributeModelArgument.name;
      textEditingControllerDescriptionProductAttribute.text =
          widget.productAttributeModelArgument.description;
      // cPredefinedProductAttributeValueModel =
      //     widget.productAttributeModelArgument.predefinedProductAttributeValues;
    } else {}
    var tPredefinedProductAttributeValues =
        widget.productAttributeModelArgument.predefinedProductAttributeValues;
    for (int i = 0; i < tPredefinedProductAttributeValues.length; i++)
      listPredefinedAttributeListModel.add(TempPredefinedAttributeListModel(
          idPredefinedProductAttributeValue:
              tPredefinedProductAttributeValues[i]
                  .idPredefinedProductAttributeValue,
          namePredefinedAttribute: tPredefinedProductAttributeValues[i].name,
          displayOrderPredefinedAttribute:
              tPredefinedProductAttributeValues[i].displayOrder,
          priceAdjustmentPredefinedAttribute:
              tPredefinedProductAttributeValues[i].priceAdjustment));
  }

  // Widget getRow(int index) {
  //   return SizedBox(
  //     child: Expanded(
  //       child: Card(
  //         child: ListTile(
  //           leading: CircleAvatar(
  //             backgroundColor:
  //                 index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
  //             foregroundColor: Colors.white,
  //             child: Text(
  //               cTempPredefinedProductAttributeValueModel[index].name[0],
  //               style: const TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           title: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 cTempPredefinedProductAttributeValueModel[index].name,
  //                 style: const TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               Text(cTempPredefinedProductAttributeValueModel[index]
  //                   .displayOrder
  //                   .toString()),
  //             ],
  //           ),
  //           trailing: SizedBox(
  //             width: 70,
  //             child: Row(
  //               children: [
  //                 InkWell(
  //                     onTap: () {
  //                       //
  //                       textEditingControllerNamePredefinedProductAttribute
  //                               .text =
  //                           cTempPredefinedProductAttributeValueModel[index]
  //                               .name;
  //                       textEditingControllerDisplayOrderProductAttribute.text =
  //                           cTempPredefinedProductAttributeValueModel[index]
  //                               .displayOrder
  //                               .toString();
  //                       setState(() {
  //                         selectedIndex = index;
  //                       });
  //                       //
  //                     },
  //                     child: const Icon(Icons.edit)),
  //                 InkWell(
  //                     onTap: (() {
  //                       //
  //                       setState(() {
  //                         cTempPredefinedProductAttributeValueModel
  //                             .removeAt(index);
  //                       });
  //                       //
  //                     }),
  //                     child: const Icon(Icons.delete)),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    ProductAttributeNotifier productAttributeNotifier =
        Provider.of<ProductAttributeNotifier>(context);

    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Dettaglio attributo prodotto: ${widget.productAttributeModelArgument.name}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                  textEditingControllerNameProductAttribute,
                              minLines: 3,
                              maxLines: 3,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.edit),
                      leading: Tooltip(
                          message:
                              'Nome attributo prodotto (ad esempio: taglia, colore, ...)',
                          child: const Icon(Icons.title)),
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
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              //onChanged: ,
                              controller:
                                  textEditingControllerDescriptionProductAttribute,
                              minLines: 3,
                              maxLines: 3,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.edit),
                      leading: Tooltip(
                          message: 'Descrizione attributo prodotto',
                          child: const Icon(Icons.topic)),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                listPredefinedAttributeListModel.add(
                    TempPredefinedAttributeListModel(
                        idPredefinedProductAttributeValue: 0,
                        namePredefinedAttribute: '',
                        displayOrderPredefinedAttribute: 0,
                        priceAdjustmentPredefinedAttribute: 0));
              });
            },
          ),
          listPredefinedAttributeListModel.length > 0
              ? Expanded(
                  child: GridView.builder(
                  itemCount: listPredefinedAttributeListModel.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 15.0 / 1.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final item = listPredefinedAttributeListModel[index];
                    return EditableListTile(
                      key: ObjectKey(item),
                      model: listPredefinedAttributeListModel[index],
                      onChanged:
                          (TempPredefinedAttributeListModel updatedModel) {
                        //
                        listPredefinedAttributeListModel[index] = updatedModel;
                      },
                      onRemove:
                          (TempPredefinedAttributeListModel removedModel) {
                        listPredefinedAttributeListModel.remove(removedModel);
                        setState(() {});
                      },
                    );
                  },
                ))
              : Text('Nessun valore predefinito inserito')
        ]),
        floatingActionButton: Container(
          margin: const EdgeInsets.all(10),
          child: FloatingActionButton(
            shape: const CircleBorder(eccentricity: 0.5),
            onPressed: () {
              List<PredefinedProductAttributeValueModel> tList =
                  List.empty(growable: true);
              for (int i = 0;
                  i < listPredefinedAttributeListModel.length;
                  i++) {
                tList.add(new PredefinedProductAttributeValueModel(
                    idPredefinedProductAttributeValue:
                        listPredefinedAttributeListModel[i]
                            .idPredefinedProductAttributeValue,
                    name: listPredefinedAttributeListModel[i]
                        .namePredefinedAttribute,
                    displayOrder: listPredefinedAttributeListModel[i]
                        .displayOrderPredefinedAttribute,
                    priceAdjustment: listPredefinedAttributeListModel[i]
                        .priceAdjustmentPredefinedAttribute));
              }
              ProductAttributeModel productAttributeModel =
                  ProductAttributeModel(
                      idProductAttribute: widget
                          .productAttributeModelArgument.idProductAttribute,
                      name: textEditingControllerNameProductAttribute.text,
                      description:
                          textEditingControllerDescriptionProductAttribute.text,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      predefinedProductAttributeValues: tList);

              productAttributeNotifier
                  .addOrUpdateProductAttribute(
                      context: context,
                      token: authenticationNotifier.token,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      productAttributeModel: productAttributeModel)
                  .then((value) {
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                          title: "Attributi prodotto",
                          message: "Informazioni aggiornate",
                          contentType: "success"));
                  Navigator.of(context).pop();
                  productAttributeNotifier.refresh();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                          title: "Attributi prodotto",
                          message: "Errore di connessione",
                          contentType: "failure"));
                  Navigator.of(context).pop();
                }
              });
            },
            //backgroundColor: Colors.deepOrangeAccent,
            child: const Icon(Icons.check),
          ),
        ));
  }
}
