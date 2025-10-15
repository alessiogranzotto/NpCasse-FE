import 'package:flutter/material.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/screens/comunicationSendingScreen/comunication.sending.utility.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class MassSendingStatisticsScreen extends StatefulWidget {
  final MassSendingModel massSendingModel;
  const MassSendingStatisticsScreen(
      {super.key, required this.massSendingModel});

  @override
  State<MassSendingStatisticsScreen> createState() =>
      _MassSendingStatisticsState();
}

class _MassSendingStatisticsState extends State<MassSendingStatisticsScreen> {
  bool isLoading = true;
  List<ComunicationStatistics> massSendingJobStatistics = List.empty();

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
      var snapshot = value as List<ComunicationStatistics>;
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
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Statistiche invio massivo: ${widget.massSendingModel.nameMassSending}',
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
            : Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 28),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: massSendingJobStatistics.length,
                        itemBuilder: (context, index) {
                          var item = massSendingJobStatistics[index];
                          double ratio =
                              massSendingJobStatistics[0].parameterValue != 0
                                  ? (100 *
                                      item.parameterValue /
                                      massSendingJobStatistics[0]
                                          .parameterValue)
                                  : 0;

                          var ratioStr =
                              massSendingJobStatistics[0].parameterValue != 0
                                  ? (100 *
                                              item.parameterValue /
                                              massSendingJobStatistics[0]
                                                  .parameterValue)
                                          .toStringAsFixed(2) +
                                      " %"
                                  : "0,00 %";
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
                                      radius: 8,
                                      backgroundColor:
                                          ComunicationSendingUtility
                                              .getWebhooksColor(
                                                  item.parameterName),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 350,
                                  child: Text(
                                    item.parameterName.length >
                                            'Link clicked by recipient '.length
                                        ? item.parameterName.replaceAll(
                                            'Link clicked by recipient ',
                                            'Link clicked by recipient\n',
                                          )
                                        : item.parameterName,
                                    softWrap: true,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 80,
                                    child:
                                        Text(item.parameterValue.toString())),
                                Container(
                                    width: ratio,
                                    height: 12,
                                    color: ComunicationSendingUtility
                                        .getWebhooksColor(item.parameterName)),
                                SizedBox(width: 10),
                                SizedBox(width: 80, child: Text(ratioStr)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
