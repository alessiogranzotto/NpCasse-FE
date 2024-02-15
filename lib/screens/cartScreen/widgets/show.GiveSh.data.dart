import 'package:flutter/material.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/pdf.invoice.screen.dart';
import 'package:np_casse/screens/cartScreen/widgets/show.give.sh.data.table.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import 'package:collection/collection.dart';

class ShowGiveShData extends StatelessWidget {
  const ShowGiveShData(
      {Key? key,
      required this.width,
      required this.nameSurnameOrBusinessName,
      required this.email,
      required this.city,
      required this.cf,
      required this.callback1})
      : super(key: key);
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

    void stakeholderSelected2(StakeholderGiveModelSearch? val) {
      callback1(val);
    }

    return Row(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            width: MediaQuery.of(context).size.width,
            child: Consumer<GiveNotifier>(
              builder: (context, giveNotifier, _) {
                return FutureBuilder(
                  future: giveNotifier.findStakeholder(
                      context: context,
                      token: authenticationNotifier.token,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
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
                    } else if (snapshot.data.isEmpty) {
                      return Center(
                        child: Text('Nessuna anagrafica trovata',
                            style: Theme.of(context).textTheme.displayLarge),
                      );
                    } else {
                      var tSnapshot =
                          snapshot.data as List<StakeholderGiveModelSearch>;
                      int itemCount = tSnapshot.length;
                      if (itemCount >= 50) {
                        return Center(
                          child: Text(
                              'Recuperate più di 50 anagrafiche, restringere la ricerca.',
                              style: Theme.of(context).textTheme.displayLarge),
                        );
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Text('Recuperate $itemCount anagrafiche.',
                                  style:
                                      Theme.of(context).textTheme.displayLarge),
                              ShowGiveShDataTable(
                                  snapshot: tSnapshot,
                                  width: MediaQuery.of(context).size.width,
                                  callback2: stakeholderSelected2)
                            ],
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
