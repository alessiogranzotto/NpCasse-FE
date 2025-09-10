import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/rotation.icon.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class MassSendingCard extends StatelessWidget {
  const MassSendingCard({Key? key, required this.massSendingModel})
      : super(key: key);
  final MassSendingModel massSendingModel;

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
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  massSendingModel.nameMassSending,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SizedBox(
              height: 25,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  massSendingModel.descriptionMassSending,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 25,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Prossima esecuzione: ' +
                      (massSendingModel.nextExecutionMassSending != null
                          ? DateFormat('dd/MM/yyyy - HH:mm').format(
                              massSendingModel.nextExecutionMassSending!)
                          : '-'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: (massSendingModel.stateMassSending ?? 0) == 2 ||
                              (massSendingModel.stateMassSending ?? 0) == 4
                          ? RotatingIcon(size: 24)
                          : null,
                    ),
                    const SizedBox(
                        width: 8), // piccolo spazio tra ingranaggio e testo
                    Text(
                      massSendingModel.stateMassSendingDescription ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),

                // IconButton sempre a destra
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.massSendingDetailRoute,
                          arguments: massSendingModel,
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.massSendingStatisticsRoute,
                          arguments: massSendingModel,
                        );
                      },
                      icon: const Icon(
                        Icons.query_stats,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
