import 'package:flutter/material.dart';

import 'package:np_casse/core/models/comunication.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/screens/comunicationSendingScreen/comunication.sending.utility.dart';
import 'package:provider/provider.dart';

class MassSendingEventDetailScreen extends StatefulWidget {
  final ComunicationModelForEventDetail massSendingJobModelForEventDetail;
  const MassSendingEventDetailScreen(
      {super.key, required this.massSendingJobModelForEventDetail});

  @override
  State<MassSendingEventDetailScreen> createState() =>
      _MassSendingEventDetailState();
}

class _MassSendingEventDetailState extends State<MassSendingEventDetailScreen> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.numbers, size: 16),
                      SizedBox(width: 6),
                      Text(widget.massSendingJobModelForEventDetail.emailId),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.email, size: 20),
                      SizedBox(width: 6),
                      Text(widget.massSendingJobModelForEventDetail.emailSh),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.massSendingJobModelForEventDetail
                        .webhooksEvent!.length,
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
                                  radius: 8,
                                  backgroundColor: ComunicationSendingUtility
                                      .getWebhooksColor(item.event),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 350,
                              child: Text(
                                item.event.length >
                                        'Link clicked by recipient '.length
                                    ? item.event.replaceAll(
                                        'Link clicked by recipient ',
                                        'Link clicked by recipient\n',
                                      )
                                    : item.event,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(width: 20),
                            SizedBox(
                              width: 220,
                              child: Text(item.dateUpdate.toString()),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
