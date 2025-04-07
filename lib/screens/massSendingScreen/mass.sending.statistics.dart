import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/core/models/mass.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/massSendingScreen/mass.sending.utility.dart';
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
  bool isLoading = true;

  //AVAILABLE GIVE ACCUMULATOR
  List<MassSendingJobStatistics> massSendingJobStatistics = List.empty();
  List<DropdownItem<AccumulatorGiveModel>> availableAccumulatorGiveItem = [];

  // //SMTP2GO TEMPLATE MASS SENDING
  // AccumulatorGiveModel? accumulatorGive;

  int touchedIndex = -1;

  List<PieChartSectionData> showingSections(List<MassSendingJobStatistics> s) {
    List<MassSendingJobStatistics> wS = List.from(s);
    int emailPrepared = wS[0].parameterValue;
    List<int> indexToRemove = [0, 1, 8];
    for (int index in indexToRemove) {
      if (index < wS.length) {
        wS.removeAt(index);
      }
    }
    return List.generate(wS.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: MassSendingUtility.getWebhooksColor(wS[i].parameterName),
        value: wS[i].parameterValue / emailPrepared,
        title: (wS[i].parameterValue / emailPrepared).toStringAsFixed(2),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  void initializeControllers() {}

  void disposeControllers() {}

  void dataControllerListener() {}

  Future<void> getStatisticsData() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context, listen: false);

    await massSendingNotifier
        .getMassSendingJobStatistics(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idInstitution:
                cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
            idMassSending: widget.massSendingModel.idMassSending)
        .then((value) {
      var snapshot = value as List<MassSendingJobStatistics>;
      massSendingJobStatistics = snapshot;
      setInitialData();
    });
  }

  void setInitialData() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    getStatisticsData();
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
            : SingleChildScrollView(
                child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          width: 28,
                        ),
                        Container(
                          height: 400,
                          width:
                              520, // Imposta la larghezza fissa del Container che avvolge il ListView
                          child: ListView.builder(
                            itemCount: massSendingJobStatistics
                                .length, // Numero di elementi nella lista
                            itemBuilder: (context, index) {
                              var item = massSendingJobStatistics[index];
                              var ratio = (100 *
                                  item.parameterValue /
                                  massSendingJobStatistics[0].parameterValue);
                              var ratioStr = (100 *
                                          item.parameterValue /
                                          massSendingJobStatistics[0]
                                              .parameterValue)
                                      .toStringAsFixed(2) +
                                  " %";
                              return Container(
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Tooltip(
                                        message: item.parameterName,
                                        child: CircleAvatar(
                                          radius:
                                              8, // Imposta il raggio dell'avatar
                                          backgroundColor: MassSendingUtility
                                              .getWebhooksColor(item
                                                  .parameterName), // Immagine dell'avatar
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        item.parameterName.toString(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        item.parameterValue.toString(),
                                      ),
                                    ),
                                    Container(
                                      width: ratio,
                                      height: 12, // Altezza della barra
                                      color: MassSendingUtility
                                          .getWebhooksColor(item
                                              .parameterName), // Colore della barra
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        ratioStr,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        // SizedBox(
                        //   width: 400,
                        //   height: 150,
                        //   child: PieChart(
                        //     PieChartData(
                        //       pieTouchData: PieTouchData(
                        //         touchCallback:
                        //             (FlTouchEvent event, pieTouchResponse) {
                        //           setState(() {
                        //             if (!event.isInterestedForInteractions ||
                        //                 pieTouchResponse == null ||
                        //                 pieTouchResponse.touchedSection ==
                        //                     null) {
                        //               touchedIndex = -1;
                        //               return;
                        //             }
                        //             touchedIndex = pieTouchResponse
                        //                 .touchedSection!.touchedSectionIndex;
                        //           });
                        //         },
                        //       ),
                        //       borderData: FlBorderData(
                        //         show: false,
                        //       ),
                        //       sectionsSpace: 0,
                        //       centerSpaceRadius: 40,
                        //       sections:
                        //           showingSections(massSendingJobStatistics),
                        //     ),
                        //   ),
                        // ),
                        // const Column(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     Indicator(
                        //       color: Colors.blue,
                        //       text: 'First',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 4,
                        //     ),
                        //     Indicator(
                        //       color: Colors.yellow,
                        //       text: 'Second',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 4,
                        //     ),
                        //     Indicator(
                        //       color: Colors.purple,
                        //       text: 'Third',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 4,
                        //     ),
                        //     Indicator(
                        //       color: Colors.green,
                        //       text: 'Fourth',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 18,
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   width: 28,
                        // ),
                      ],
                    ),
                  ],
                ),
              )),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {},

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
