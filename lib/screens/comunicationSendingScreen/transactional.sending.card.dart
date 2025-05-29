import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class TransactionalSendingCard extends StatelessWidget {
  const TransactionalSendingCard(
      {Key? key, required this.transactionalSendingModel})
      : super(key: key);
  final TransactionalSendingModel transactionalSendingModel;

  bool checkState(String area) {
    return true;
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
                  transactionalSendingModel.nameTransactionalSending,
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
                  transactionalSendingModel.descriptionTransactionalSending,
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
                      transactionalSendingModel.actionTransactionalSending,
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
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.transactionalSendingDetailRoute,
                              arguments: TransactionalSendingModel(
                                idTransactionalSending:
                                    transactionalSendingModel
                                        .idTransactionalSending,
                                idInstitution:
                                    transactionalSendingModel.idInstitution,
                                idUserAppInstitution: cUserAppInstitutionModel
                                    .idUserAppInstitution,
                                archived: transactionalSendingModel.archived,
                                nameTransactionalSending:
                                    transactionalSendingModel
                                        .nameTransactionalSending,
                                descriptionTransactionalSending:
                                    transactionalSendingModel
                                        .descriptionTransactionalSending,
                                senderTransactionalSending:
                                    transactionalSendingModel
                                        .senderTransactionalSending,
                                emailSenderTransactionalSending:
                                    transactionalSendingModel
                                        .emailSenderTransactionalSending,
                                actionTransactionalSending:
                                    transactionalSendingModel
                                        .actionTransactionalSending,
                                idTemplateTransactionalSending:
                                    transactionalSendingModel
                                        .idTemplateTransactionalSending,
                                idAttachTransactionalSending:
                                    transactionalSendingModel
                                        .idAttachTransactionalSending,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.abc,
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
                                    AppRouter
                                        .transactionalSendingStatisticsRoute,
                                    arguments: TransactionalSendingModel(
                                      idTransactionalSending:
                                          transactionalSendingModel
                                              .idTransactionalSending,
                                      idInstitution: transactionalSendingModel
                                          .idInstitution,
                                      idUserAppInstitution:
                                          cUserAppInstitutionModel
                                              .idUserAppInstitution,
                                      archived:
                                          transactionalSendingModel.archived,
                                      nameTransactionalSending:
                                          transactionalSendingModel
                                              .nameTransactionalSending,
                                      descriptionTransactionalSending:
                                          transactionalSendingModel
                                              .descriptionTransactionalSending,
                                      senderTransactionalSending:
                                          transactionalSendingModel
                                              .senderTransactionalSending,
                                      emailSenderTransactionalSending:
                                          transactionalSendingModel
                                              .emailSenderTransactionalSending,
                                      actionTransactionalSending:
                                          transactionalSendingModel
                                              .actionTransactionalSending,
                                      idTemplateTransactionalSending:
                                          transactionalSendingModel
                                              .idTemplateTransactionalSending,
                                      idAttachTransactionalSending:
                                          transactionalSendingModel
                                              .idAttachTransactionalSending,
                                    ),
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
