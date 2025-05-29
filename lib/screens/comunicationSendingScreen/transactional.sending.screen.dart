import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/transactional.sending.notifier.dart';
import 'package:np_casse/screens/comunicationSendingScreen/mass.sending.card.dart';
import 'package:np_casse/screens/comunicationSendingScreen/transactional.sending.card.dart';
import 'package:provider/provider.dart';

class TransactionalSendingScreen extends StatefulWidget {
  const TransactionalSendingScreen({super.key});

  @override
  State<TransactionalSendingScreen> createState() =>
      _TransactionalSendingScreenState();
}

class _TransactionalSendingScreenState
    extends State<TransactionalSendingScreen> {
  final double widgetWitdh = 350;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;
  final double widgetHeight = 150;
  Timer? _timer;

  TextEditingController nameDescSearchController = TextEditingController();
  bool readAlsoArchived = false;

  String numberResult = '10';
  List<DropdownMenuItem<String>> availableNumberResult = [
    DropdownMenuItem(child: Text("Tutti"), value: "All"),
    DropdownMenuItem(child: Text("10"), value: "10"),
    DropdownMenuItem(child: Text("25"), value: "25"),
    DropdownMenuItem(child: Text("50"), value: "50"),
  ];

  String orderBy = '';

  Icon iconaNameDescSearch = const Icon(Icons.search);

  void onChangeNumberResult(value) {
    setState(() {
      numberResult = value!;
    });
  }

  void onChangeOrderBy(value) {
    setState(() {
      orderBy = value!;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          'Transazionali ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: CustomDropDownButtonFormField(
                      enabled: true,
                      actualValue: numberResult,
                      labelText: 'Mostra numero risultati',
                      listOfValue: availableNumberResult,
                      onItemChanged: (value) {
                        onChangeNumberResult(value);
                      },
                    )),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.blueGrey),
                    onChanged: (String value) {
                      if (_timer?.isActive ?? false) {
                        _timer!.cancel();
                      }
                      _timer = Timer(const Duration(milliseconds: 1000), () {
                        setState(() {
                          iconaNameDescSearch = const Icon(Icons.cancel);
                          if (value.isEmpty) {
                            iconaNameDescSearch = const Icon(Icons.search);
                          }
                        });
                      });
                    },
                    controller: nameDescSearchController,
                    decoration: InputDecoration(
                      labelText: "Ricerca per nome o descrizione",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.blueGrey),
                      hintText: "Ricerca per nome o descrizione",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.3)),
                      suffixIcon: IconButton(
                        icon: iconaNameDescSearch,
                        onPressed: () {
                          setState(() {
                            if (iconaNameDescSearch.icon == Icons.search) {
                              iconaNameDescSearch = const Icon(Icons.cancel);
                            } else {
                              iconaNameDescSearch = const Icon(Icons.search);
                              nameDescSearchController.text = "";
                            }
                          });
                        },
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            color: Colors.deepOrangeAccent, width: 1.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: CheckboxListTile(
                      side: const BorderSide(color: Colors.blueGrey),
                      checkColor: Colors.blueAccent,
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      activeColor: Colors.blueAccent,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: readAlsoArchived,
                      onChanged: (bool? value) {
                        setState(() {
                          readAlsoArchived = value!;
                        });
                      },
                      title: Text(
                        'Mostra anche archiviate',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.blueGrey),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Consumer<TransactionalSendingNotifier>(
                builder: (context, transactionalSendingNotifier, _) {
                  return FutureBuilder(
                    future:
                        transactionalSendingNotifier.findTransactionalSendings(
                            context: context,
                            token: authenticationNotifier.token,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution,
                            idInstitution: cUserAppInstitutionModel
                                .idInstitutionNavigation.idInstitution,
                            readAlsoArchived: readAlsoArchived,
                            numberResult: numberResult,
                            nameDescSearch: nameDescSearchController.text,
                            orderBy: orderBy,
                            type: ""),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 5,
                                        color: Colors.redAccent,
                                      ))),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            'No data...',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      } else {
                        var tSnapshot =
                            snapshot.data as List<TransactionalSendingModel>;

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                    crossAxisCount:
                                        (MediaQuery.of(context).size.width) ~/
                                            widgetWitdh,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: gridMainAxisSpacing,
                                    height: widgetHeight,
                                  ),
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: tSnapshot.length,
                                  itemBuilder: (context, index) {
                                    TransactionalSendingModel
                                        transactionalSendingModel =
                                        tSnapshot[index];
                                    return TransactionalSendingCard(
                                        transactionalSendingModel:
                                            transactionalSendingModel);
                                  }),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRouter.transactionalSendingDetailRoute,
                  arguments: TransactionalSendingModel.empty(),
                );
              },
              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
