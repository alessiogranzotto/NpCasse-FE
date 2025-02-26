import 'package:flutter/material.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/givepro.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/screens/cartScreen/widgets/show.give.sh.data.table.dart';
import 'package:np_casse/screens/cartScreen/widgets/show.givepro.sh.data.table.dart';
import 'package:provider/provider.dart';

class ShowGiveShGiveproData extends StatelessWidget {
  const ShowGiveShGiveproData(
      {super.key,
      required this.width,
      required this.nameSurnameOrBusinessName,
      required this.email,
      required this.city,
      required this.cf,
      required this.callback1});
  final String nameSurnameOrBusinessName;
  final String email;
  final String city;
  final String cf;
  final double width;
  final Function callback1;

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    GiveNotifier giveNotifier =
        Provider.of<GiveNotifier>(context, listen: false);
    StakeholderGiveModelSearch fromSaveUpdateStakeholder =
        giveNotifier.getStakeholder();
    // GiveNotifier giveNotifier = Provider.of<GiveNotifier>(context);
    // StakeholderGiveModelSearch? fromSaveUpdateStakeholder =
    //     giveNotifier.getStakeholder();

    void stakeholderSelected2(StakeholderGiveModelSearch? val) {
      callback1(val);
    }

    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
          width: MediaQuery.of(context).size.width,
          child: Consumer<GiveNotifier>(
            builder: (context, giveNotifier, _) {
              return FutureBuilder(
                future: giveNotifier.findStakeholderGivepro(
                    context: context,
                    token: authenticationNotifier.token,
                    idUserAppInstitution:
                        cUserAppInstitutionModel.idUserAppInstitution,
                    id: fromSaveUpdateStakeholder.id,
                    nameSurnameOrBusinessName: nameSurnameOrBusinessName,
                    email: email,
                    city: city,
                    cf: cf),
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
                    return Center(
                      child: Text('Nessuna anagrafica trovata',
                          style: Theme.of(context).textTheme.displayLarge),
                    );
                  } else {
                    var tSnapshot =
                        snapshot.data as StakeholderGiveProDataModel;
                    int itemCount = tSnapshot.totalCount;
                    if (itemCount >= 50) {
                      return Center(
                        child: Text(
                            'Recuperate più di 50 anagrafiche, restringere la ricerca.',
                            style: Theme.of(context).textTheme.displayLarge),
                      );
                    } else {
                      return Column(
                        children: [
                          Text('Recuperate $itemCount anagrafiche.',
                              style: Theme.of(context).textTheme.displayLarge),
                          Expanded(
                            child: ShowGiveproShDataTable(
                                snapshot: tSnapshot.stakeholderGiveproModel,
                                width: MediaQuery.of(context).size.width,
                                callback2: stakeholderSelected2),
                          )
                        ],
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
