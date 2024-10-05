import 'package:flutter/material.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/institution.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class InstitutionScreen extends StatefulWidget {
  const InstitutionScreen({super.key});

  @override
  State<InstitutionScreen> createState() => _InstitutionScreenState();
}

class _InstitutionScreenState extends State<InstitutionScreen> {
  UserAppInstitutionModel? selectedInstitution;
  List<DropdownMenuItem<UserAppInstitutionModel>> availableUserAppInstitution =
      [];

  var nameTextEditingController;
  List<DropdownMenuItem<UserAppInstitutionModel>>
      getAvailableUserAppInstitution() {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    List<UserAppInstitutionModel> cUserAppInstitutionModel =
        authenticationNotifier.getUserAppInstitution();

    return cUserAppInstitutionModel
        .map<DropdownMenuItem<UserAppInstitutionModel>>(
            (UserAppInstitutionModel value) {
      return DropdownMenuItem<UserAppInstitutionModel>(
          value: value,
          child: Text(value.idInstitutionNavigation.nameInstitution));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    List<UserAppInstitutionModel> cUserAppInstitutionModel =
        authenticationNotifier.getUserAppInstitution();

    UserModel currentUserModel = authenticationNotifier.getUser();
    String name = currentUserModel.name;
    TextEditingController nameTextEditingController = TextEditingController();
    nameTextEditingController.text = name;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        //drawer: const CustomDrawerWidget(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Associazioni',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Card(
              color: Theme.of(context).cardColor,
              elevation: 4,
              child: ListTile(
                // title: Text(
                //   'qui ci va la descrizione del progetto',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, ),
                // ),
                subtitle: Row(
                  children: [
                    Expanded(
                        child: CustomDropDownButtonFormField(
                      enabled: true,
                      actualValue: selectedInstitution,
                      labelText: '',
                      listOfValue: getAvailableUserAppInstitution(),
                      onItemChanged: (String value) {
                        // onChangeParentCategory(value);
                      },
                    )),
                    Expanded(
                        child: CustomTextFormField(
                            controller: nameTextEditingController))
                  ],
                ),
                trailing: const Icon(Icons.edit),
                leading: const Icon(Icons.book),
                onTap: () {},
              ),
            ),
          ]),
        ));
  }
}
