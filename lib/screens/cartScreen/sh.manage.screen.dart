import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/widgets/sh.search.textfield.dart';
import 'package:np_casse/screens/cartScreen/widgets/show.GiveSh.data.dart';
import 'package:provider/provider.dart';

class ShManageScreen extends StatefulWidget {
  const ShManageScreen({
    Key? key,
    required this.idCart,
  }) : super(key: key);
  final int idCart;
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
    // visibilityEdit.value = !visibilityEdit.value;
    // visibilityReceipt.value = !visibilityReceipt.value;
    cStakeholderGiveModelSearch = val;
    if (val != null) {
      visibilityEdit.value = true;
      visibilityReceipt.value = true;
    } else {
      visibilityEdit.value = false;
      visibilityReceipt.value = false;
    }
    if (widget.idCart == 0) {
      visibilityReceipt.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    GiveNotifier giveNotifier =
        Provider.of<GiveNotifier>(context, listen: false);
    var fromSaveUpdateStakeholder = giveNotifier.getStakeholder();
    if (fromSaveUpdateStakeholder.id != 0) {
      isExecuted = true;
    } else {
      isExecuted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //HomeNotifier homeNotifier = Provider.of<HomeNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      //drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
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
                        GiveNotifier giveNotifier =
                            Provider.of<GiveNotifier>(context, listen: false);
                        giveNotifier
                            .setStakeholder(StakeholderGiveModelSearch.empty());
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
                      // heroTag: 'Receipt',
                      onPressed: () {
                        CartNotifier cartNotifier =
                            Provider.of<CartNotifier>(context, listen: false);
                        AuthenticationNotifier authenticationNotifier =
                            Provider.of<AuthenticationNotifier>(context,
                                listen: false);

                        UserAppInstitutionModel cUserAppInstitutionModel =
                            authenticationNotifier
                                .getSelectedUserAppInstitution();

                        String denominationStakeholder =
                            cStakeholderGiveModelSearch!
                                    .ragionesociale.isNotEmpty
                                ? cStakeholderGiveModelSearch!.ragionesociale
                                : "${cStakeholderGiveModelSearch!.nome} ${cStakeholderGiveModelSearch!.cognome}";
                        cartNotifier
                            .cartToStakeholder(
                                context: context,
                                token: authenticationNotifier.token,
                                idCart: widget.idCart,
                                idUserAppInstitution: cUserAppInstitutionModel
                                    .idUserAppInstitution,
                                idStakeholder: cStakeholderGiveModelSearch!.id,
                                denominationStakeholder:
                                    denominationStakeholder)
                            .then((value) {
                          if (value) {
                            Navigator.of(context).pushNamed(
                                AppRouter.shPdfInvoice,
                                arguments: widget.idCart);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackUtil.stylishSnackBar(
                                    title: "Anagrafiche",
                                    message: "Errore di connessione",
                                    contentType: "failure"));
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
                      shape: const CircleBorder(eccentricity: 0.5),
                      tooltip:
                          "Modifica anagrafica donatore ${cStakeholderGiveModelSearch?.nome}",
                      // heroTag: 'Edit',
                      onPressed: () {
                        ShManageMultipleArgument cShManageMultipleArgument =
                            new ShManageMultipleArgument(
                                idCart: widget.idCart,
                                cStakeholderGiveModelSearch:
                                    cStakeholderGiveModelSearch);

                        Navigator.of(context).pushNamed(
                            AppRouter.shManageNewEdit,
                            arguments: cShManageMultipleArgument);
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
                      shape: const CircleBorder(eccentricity: 0.5),
                      tooltip: "Nuova anagrafica donatore",
                      // heroTag: 'New',
                      onPressed: () {
                        ShManageMultipleArgument cShManageMultipleArgument =
                            new ShManageMultipleArgument(
                                idCart: widget.idCart,
                                cStakeholderGiveModelSearch: null);

                        Navigator.of(context).pushNamed(
                            AppRouter.shManageNewEdit,
                            arguments: cShManageMultipleArgument);
                      },
                      child: const Icon(Icons.add),
                    )),
              );
            },
            valueListenable: visibilityNew,
          ),
          // Container(
          //     margin: const EdgeInsets.all(10),
          //     child:
          //     FloatingActionButton(
          //       shape: const CircleBorder(eccentricity: 0.5),
          //       tooltip: "Abbandona gestione donatori",
          //       heroTag: 'Exit',
          //       onPressed: () {
          //         Navigator.pop(context);
          //         PersistentNavBarNavigator.pushNewScreen(
          //           context,
          //           screen: const WishlistScreen(),
          //           withNavBar: true,
          //           pageTransitionAnimation: PageTransitionAnimation.fade,
          //         );

          //         // Navigator.of(context).pushAndRemoveUntil(
          //         //     MaterialPageRoute(
          //         //         builder: (context) => const WishlistScreen()),
          //         //     (Route route) => false);

          //         //               Navigator.pushNamedAndRemoveUntil(
          //         // ContextKeeper.buildContext, AppRouter.loginRoute, (_) => true);
          //         homeNotifier.setHomeIndex(0);
          //       },
          //       backgroundColor: Colors.redAccent,
          //       child: const Icon(Icons.leave_bags_at_home),
          //     )),

          // Add more buttons here
        ],
      ),
    );
  }
}
