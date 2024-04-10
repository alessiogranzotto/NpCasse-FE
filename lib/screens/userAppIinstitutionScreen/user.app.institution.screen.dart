import 'package:flutter/material.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/home.notifier.dart';
import 'package:np_casse/screens/userAppIinstitutionScreen/widget/show.user.app.institution.dart';
import 'package:provider/provider.dart';
//import 'package:np_casse/core/notifiers/user.notifier.dart';

class UserAppInstitutionScreen extends StatelessWidget {
  const UserAppInstitutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    // UserAppInstitutionNotifier userAppInstitutionNotifier =
    //     Provider.of<UserAppInstitutionNotifier>(context);
    HomeNotifier homeNotifier = Provider.of<HomeNotifier>(context);
    // UserInstitutionModel? selectedUserInstitution;
    // InstitutionModel? selectedInstitution;
    // String nameInstitution = 'Prova';
    // int idUserAppInstitution = 0;
    // var nameUser = userData.getUserName ?? ' ';
    // var idUser = userData.getIdUser;
    // var nameInstitution = institutionData.getNameInstitution ?? ' ';
    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    void userAppInstitutionSelected(UserAppInstitutionModel? val) {
      authenticationNotifier.setSelectedUserAppInstitution(val);
      homeNotifier.setStateManagementFalse();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
              'Associazione: ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
              style: Theme.of(context).textTheme.headlineLarge),
          // actions: <Widget>[
          //   Center(
          //       child: Text(
          //     "Associazioni",
          //     style: Theme.of(context).textTheme.headlineMedium,
          //     textAlign: TextAlign.right,
          //   )),
          //   IconButton(
          //     icon: const Icon(Icons.add),
          //     tooltip: 'Show Snackbar',
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(content: Text('This is a snackbar')));
          //     },
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.05,
                      // width: MediaQuery.of(context).size.width * 0.10,
                      child: Consumer<AuthenticationNotifier>(
                        builder: (context, notifier, _) {
                          return FutureBuilder(
                            future: notifier.getUserAppInstitution(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 5,
                                              ))),
                                    ],
                                  ),
                                );
                              } else if (!snapshot.hasData) {
                                return const Center(
                                  child: Text(
                                    'No data...',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                );
                              } else {
                                var tSnapshot = snapshot.data as List;
                                return showUserInstitution(
                                    callback: userAppInstitutionSelected,
                                    snapshot: tSnapshot,
                                    selection: cUserAppInstitutionModel,
                                    context: context);
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
