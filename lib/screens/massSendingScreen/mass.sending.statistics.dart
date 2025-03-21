import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

class MassSendingStatisticsScreen extends StatefulWidget {
  final MassSendingModel massSendingModel;
  const MassSendingStatisticsScreen(
      {super.key, required this.massSendingModel});

  @override
  State<MassSendingStatisticsScreen> createState() =>
      _MyosotisConfigurationDetailState();
}

class _MyosotisConfigurationDetailState
    extends State<MassSendingStatisticsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isLoadingData = true;
  bool isLoading = true;
  //ISARCHIVED MASS SENDING
  final ValueNotifier<bool> archiviedNotifier = ValueNotifier<bool>(false);

  // //ACCUMULATOR
  // TextEditingController accumulatorController = TextEditingController();

  //VISIBLE PERSONAL FORM FIELD  CONFIGURATION
  final accumulatorGiveController =
      MultiSelectController<AccumulatorGiveModel>();

  //AVAILABLE GIVE ACCUMULATOR
  List<AccumulatorGiveModel> availableAccumulatorGive = List.empty();
  List<DropdownItem<AccumulatorGiveModel>> availableAccumulatorGiveItem = [];

  // //SMTP2GO TEMPLATE MASS SENDING
  // AccumulatorGiveModel? accumulatorGive;

  int touchedIndex = -1;

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

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
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            height: 18,
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections(),
                                ),
                              ),
                            ),
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Indicator(
                                color: Colors.blue,
                                text: 'First',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: Colors.yellow,
                                text: 'Second',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: Colors.purple,
                                text: 'Third',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Indicator(
                                color: Colors.green,
                                text: 'Fourth',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 28,
                          ),
                        ],
                      ),
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

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
