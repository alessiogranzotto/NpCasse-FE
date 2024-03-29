import 'package:flutter/material.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/pdf.invoice.screen.dart';
import 'package:np_casse/screens/cartScreen/sh.new.edit.sh.screen.dart';
import 'package:np_casse/screens/cartScreen/widgets/sh.search.textfield.dart';
import 'package:np_casse/screens/cartScreen/widgets/show.GiveSh.data.dart';
import 'package:np_casse/screens/productScreen/product.detail.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ShManageScreen extends StatefulWidget {
  const ShManageScreen({super.key});

  @override
  State<ShManageScreen> createState() => _ShManageScreenState();
}

class _ShManageScreenState extends State<ShManageScreen> {
  final TextEditingController nameSurnameorBusinessNameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController cfController = TextEditingController();

  bool isExecuted = false;
  ValueNotifier<bool> visibilityNew = ValueNotifier<bool>(true);
  ValueNotifier<bool> visibilityEdit = ValueNotifier<bool>(false);
  ValueNotifier<bool> visibilityReceipt = ValueNotifier<bool>(false);

  StakeholderGiveModelSearch? cStakeholderGiveModelSearch;

  void stakeholderSelected1(StakeholderGiveModelSearch? val) {
    if (val != null) {
      visibilityEdit.value = true;
      visibilityReceipt.value = true;
      cStakeholderGiveModelSearch = val;
    } else {
      visibilityEdit.value = false;
      visibilityReceipt.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    isExecuted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Gestione donatore",
            style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ShSearchTextfield(
                            textEditingController: cityController,
                            hintText: 'città',
                            prefixIcon: const Icon(Icons.location_city),
                            themeData: Theme.of(context),
                            validator: (val) => val!.length < 3
                                ? 'Inserire almeno 3 caratteri'
                                : null,
                          )))),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ShSearchTextfield(
                            textEditingController: emailController,
                            hintText: 'email',
                            prefixIcon: const Icon(Icons.email),
                            themeData: Theme.of(context),
                            validator: (val) => val!.length < 3
                                ? 'Inserire almeno 3 caratteri'
                                : null,
                          )))),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50, //height of button
                          width: double.infinity,
                          child: ShSearchTextfield(
                            textEditingController:
                                nameSurnameorBusinessNameController,
                            hintText: 'nome, cognome o ragione sociale',
                            prefixIcon: const Icon(Icons.person),
                            themeData: Theme.of(context),
                            validator: (val) => val!.length < 3
                                ? 'Inserire almeno 3 caratteri'
                                : null,
                          )))),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50, //height of button
                          width: double.infinity,
                          child: ShSearchTextfield(
                            textEditingController: cfController,
                            hintText: 'codice fiscale',
                            prefixIcon: const Icon(Icons.code),
                            themeData: Theme.of(context),
                            validator: (val) => val!.length < 3
                                ? 'Inserire almeno 3 caratteri'
                                : null,
                          )))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50, //height of button
                  width: 100,
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.05,
                    minWidth: MediaQuery.of(context).size.width * 0.25,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () {
                      setState(() {
                        isExecuted = true;
                      });
                    },
                    color: Colors.blueAccent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.search),
                        Text('Ricerca',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              isExecuted
                  ? ShowGiveShData(
                      nameSurnameOrBusinessName:
                          nameSurnameorBusinessNameController.text,
                      email: emailController.text,
                      city: cityController.text,
                      cf: cfController.text,
                      width: MediaQuery.of(context).size.width,
                      callback1: stakeholderSelected1)
                  : const Center(),
            ],
          )
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          ValueListenableBuilder<bool>(
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: value,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: FloatingActionButton(
                      shape: const CircleBorder(eccentricity: 0.5),
                      tooltip:
                          "Emissione ricevuta a favore di ${cStakeholderGiveModelSearch?.nome}",
                      heroTag: 'Receipt',
                      onPressed: () {
                        CartNotifier cartNotifier =
                            Provider.of<CartNotifier>(context, listen: false);
                        AuthenticationNotifier authenticationNotifier =
                            Provider.of<AuthenticationNotifier>(context,
                                listen: false);

                        UserAppInstitutionModel cUserAppInstitutionModel =
                            authenticationNotifier
                                .getSelectedUserAppInstitution();

                        cartNotifier
                            .cartToStakeholder(
                                context: context,
                                token: authenticationNotifier.token,
                                idCart: cartNotifier.getCart().idCart,
                                idUserAppInstitution: cUserAppInstitutionModel
                                    .idUserAppInstitution,
                                idStakeholder: cStakeholderGiveModelSearch!.id)
                            .then((value) {
                          if (value) {
                            Navigator.pop(context);
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const PdfInvoiceScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackUtil.stylishSnackBar(
                                text: 'Error Please Try Again , After a While',
                                context: context,
                              ),
                            );
                          }
                        });
                      },
                      backgroundColor: Colors.deepOrangeAccent,
                      child: const Icon(Icons.receipt),
                    )),
              );
            },
            valueListenable: visibilityReceipt,
          ),
          ValueListenableBuilder<bool>(
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: value,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: FloatingActionButton(
                      tooltip:
                          "Modifica anagrafica donatore ${cStakeholderGiveModelSearch?.nome}",
                      heroTag: 'Edit',
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: ShNewEditScreen(
                              cStakeholderGiveModelSearch:
                                  cStakeholderGiveModelSearch),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      backgroundColor: Colors.deepPurpleAccent,
                      child: const Icon(Icons.edit),
                    )),
              );
            },
            valueListenable: visibilityEdit,
          ),
          ValueListenableBuilder<bool>(
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: value,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    child: FloatingActionButton(
                      tooltip: "Nuova anagrafica donatore",
                      heroTag: 'New',
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const ShNewEditScreen(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      child: const Icon(Icons.add),
                    )),
              );
            },
            valueListenable: visibilityNew,
          ),

          // Add more buttons here
        ],
      ),
    );
  }
}
