import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/core/models/mass.sending.job.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/screens/massSendingScreen/mass.sending.utility.dart';
import 'package:provider/provider.dart';

class MassSendingEventDetailScreen extends StatefulWidget {
  final MassSendingJobModelForEventDetail massSendingJobModelForEventDetail;
  const MassSendingEventDetailScreen(
      {super.key, required this.massSendingJobModelForEventDetail});

  @override
  State<MassSendingEventDetailScreen> createState() =>
      _MyosotisConfigurationDetailState();
}

class _MyosotisConfigurationDetailState
    extends State<MassSendingEventDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
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
          'Dettaglio stati Email',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .start, // Aligns containers in the center vertically
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Aligns containers in the center horizontally

              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.numbers,
                        size: 16,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(widget.massSendingJobModelForEventDetail.emailId),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(widget.massSendingJobModelForEventDetail.emailSh),
                    ],
                  ),
                ),
                Container(
                  height: 400,
                  width:
                      480, // Imposta la larghezza fissa del Container che avvolge il ListView
                  child: ListView.builder(
                    itemCount: widget
                        .massSendingJobModelForEventDetail
                        .webhooksEvent!
                        .length, // Numero di elementi nella lista
                    itemBuilder: (context, index) {
                      var item = widget.massSendingJobModelForEventDetail
                          .webhooksEvent![index];
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Tooltip(
                                message: item.event,
                                child: CircleAvatar(
                                  radius: 8, // Imposta il raggio dell'avatar
                                  backgroundColor:
                                      MassSendingUtility.getWebhooksColor(
                                          item.event), // Immagine dell'avatar
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                item.event,
                              ),
                            ),
                            SizedBox(
                              width: 220,
                              child: Text(
                                item.dateUpdate.toString(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )

          // ListView.builder(
          //     padding: const EdgeInsets.all(8),
          //           margin: EdgeInsets.only(bottom: 5.0),

          //     itemBuilder: (BuildContext context, int index) {

          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 2.0),
          //         child: CircleAvatar(
          //           radius: 8, // Imposta il raggio dell'avatar
          //           backgroundColor:
          //               getWebhooksColor(item), // Immagine dell'avatar
          //         ),
          //       );
          //     })

          ),
    );
  }
}
