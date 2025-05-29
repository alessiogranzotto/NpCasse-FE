import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class MassSendingCard extends StatelessWidget {
  const MassSendingCard({Key? key, required this.massSendingModel})
      : super(key: key);
  final MassSendingModel massSendingModel;

  bool checkState(String area) {
    int? stateModel = massSendingModel.stateMassSending;
    if (area == 'detail') {
      if (stateModel == 1) {
        return true;
      } else if (stateModel == 2) {
        return true;
      } else if (stateModel == 3) {
        return false;
      }
      return false;
    }
    if (area == 'recipient') {
      if (stateModel == 1) {
        return true;
      } else if (stateModel == 2) {
        return true;
      } else if (stateModel == 3) {
        return false;
      }
      return false;
    }
    if (area == 'plan') {
      if (stateModel == 1) {
        return false;
      } else if (stateModel == 2) {
        return false;
      } else if (stateModel == 3) {
        return false;
      } else if (stateModel == 4) {
        return true;
      } else if (stateModel == 5) {
        return true;
      }
      return false;
    }
    if (area == 'statistics') {
      if (stateModel == 1) {
        return false;
      } else if (stateModel == 2) {
        return false;
      } else if (stateModel == 3) {
        return false;
      } else if (stateModel == 4) {
        return false;
      } else if (stateModel == 5) {
        return false;
      } else if (stateModel == 6) {
        return false;
      } else if (stateModel == 7) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Card(
      elevation: 8,
      child: Container(
        //margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.6),
                  offset: const Offset(0.0, 0.0), //(x,y)
                  blurRadius: 4.0,
                  blurStyle: BlurStyle.solid)
            ],
            //color: Colors.white,
            color: Theme.of(context).cardColor),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  massSendingModel.nameMassSending,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  massSendingModel.descriptionMassSending,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      massSendingModel.stateMassSendingDescription ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: IconButton(
                          onPressed: checkState('detail')
                              ? () {
                                  Navigator.of(context).pushNamed(
                                    AppRouter.massSendingDetailRoute,
                                    arguments: MassSendingModel(
                                        idMassSending:
                                            massSendingModel.idMassSending,
                                        idInstitution:
                                            massSendingModel.idInstitution,
                                        idUserAppInstitution:
                                            cUserAppInstitutionModel
                                                .idUserAppInstitution,
                                        archived: massSendingModel.archived,
                                        nameMassSending:
                                            massSendingModel.nameMassSending,
                                        descriptionMassSending: massSendingModel
                                            .descriptionMassSending,
                                        senderMassSending:
                                            massSendingModel.senderMassSending,
                                        emailSenderMassSending: massSendingModel
                                            .emailSenderMassSending,
                                        idTemplateMassSending: massSendingModel
                                            .idTemplateMassSending,
                                        stateMassSending:
                                            massSendingModel.stateMassSending,
                                        stateMassSendingDescription:
                                            massSendingModel
                                                .stateMassSendingDescription,
                                        massSendingGiveAccumulator:
                                            massSendingModel
                                                .massSendingGiveAccumulator,
                                        planningDate:
                                            massSendingModel.planningDate),
                                  );
                                }
                              : null,
                          icon: const Icon(
                            Icons.abc,
                            size: 24,
                          )),
                    ),
                    SizedBox(
                      // height: 30,
                      // width: 30,
                      child: IconButton(
                          onPressed: checkState('recipient')
                              ? () {
                                  Navigator.of(context).pushNamed(
                                    AppRouter.massSendingRecipientRoute,
                                    arguments: MassSendingModel(
                                        idMassSending:
                                            massSendingModel.idMassSending,
                                        idInstitution:
                                            massSendingModel.idInstitution,
                                        idUserAppInstitution:
                                            cUserAppInstitutionModel
                                                .idUserAppInstitution,
                                        archived: massSendingModel.archived,
                                        nameMassSending:
                                            massSendingModel.nameMassSending,
                                        descriptionMassSending: massSendingModel
                                            .descriptionMassSending,
                                        senderMassSending:
                                            massSendingModel.senderMassSending,
                                        emailSenderMassSending: massSendingModel
                                            .emailSenderMassSending,
                                        idTemplateMassSending: massSendingModel
                                            .idTemplateMassSending,
                                        stateMassSending:
                                            massSendingModel.stateMassSending,
                                        massSendingGiveAccumulator:
                                            massSendingModel
                                                .massSendingGiveAccumulator,
                                        planningDate:
                                            massSendingModel.planningDate),
                                  );
                                }
                              : null,
                          icon: const Icon(
                            Icons.people,
                            size: 24,
                          )),
                    ),
                    SizedBox(
                      // height: 30,
                      // width: 30,
                      child: IconButton(
                          onPressed: checkState('plan')
                              ? () {
                                  Navigator.of(context).pushNamed(
                                    AppRouter.massSendingPlanRoute,
                                    arguments: MassSendingModel(
                                        idMassSending:
                                            massSendingModel.idMassSending,
                                        idInstitution:
                                            massSendingModel.idInstitution,
                                        idUserAppInstitution:
                                            cUserAppInstitutionModel
                                                .idUserAppInstitution,
                                        archived: massSendingModel.archived,
                                        nameMassSending:
                                            massSendingModel.nameMassSending,
                                        descriptionMassSending: massSendingModel
                                            .descriptionMassSending,
                                        senderMassSending:
                                            massSendingModel.senderMassSending,
                                        emailSenderMassSending: massSendingModel
                                            .emailSenderMassSending,
                                        idTemplateMassSending: massSendingModel
                                            .idTemplateMassSending,
                                        stateMassSending:
                                            massSendingModel.stateMassSending,
                                        stateMassSendingDescription:
                                            massSendingModel
                                                .stateMassSendingDescription,
                                        massSendingGiveAccumulator:
                                            massSendingModel
                                                .massSendingGiveAccumulator,
                                        planningDate:
                                            massSendingModel.planningDate),
                                  );
                                }
                              : null,
                          icon: const Icon(
                            Icons.schedule,
                            size: 24,
                          )),
                    ),
                    SizedBox(
                      // height: 30,
                      // width: 30,
                      child: IconButton(
                          onPressed: checkState('statistics')
                              ? () {
                                  Navigator.of(context).pushNamed(
                                    AppRouter.massSendingStatisticsRoute,
                                    arguments: MassSendingModel(
                                        idMassSending:
                                            massSendingModel.idMassSending,
                                        idInstitution:
                                            massSendingModel.idInstitution,
                                        idUserAppInstitution:
                                            cUserAppInstitutionModel
                                                .idUserAppInstitution,
                                        archived: massSendingModel.archived,
                                        nameMassSending:
                                            massSendingModel.nameMassSending,
                                        descriptionMassSending: massSendingModel
                                            .descriptionMassSending,
                                        senderMassSending:
                                            massSendingModel.senderMassSending,
                                        emailSenderMassSending: massSendingModel
                                            .emailSenderMassSending,
                                        idTemplateMassSending: massSendingModel
                                            .idTemplateMassSending,
                                        stateMassSending:
                                            massSendingModel.stateMassSending,
                                        stateMassSendingDescription:
                                            massSendingModel
                                                .stateMassSendingDescription,
                                        massSendingGiveAccumulator:
                                            massSendingModel
                                                .massSendingGiveAccumulator,
                                        planningDate:
                                            massSendingModel.planningDate),
                                  );
                                }
                              : null,
                          icon: const Icon(
                            Icons.query_stats,
                            size: 24,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
