import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
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
  late final TextEditingController nameSurnameorBusinessNameController;
  late final TextEditingController emailController;
  late final TextEditingController cityController;
  late final TextEditingController cfController;
  late final TextEditingController fiscalCardController;
  final formKey = GlobalKey<FormState>();
  bool isExecuted = false;
  bool fromReader = false;
  ValueNotifier<bool> visibilityNew = ValueNotifier<bool>(true);
  ValueNotifier<bool> visibilityEdit = ValueNotifier<bool>(false);
  ValueNotifier<bool> visibilityReceipt = ValueNotifier<bool>(false);

  StakeholderGiveModelSearch? cStakeholderGiveModelSearch;

  void initializeControllers() {
    nameSurnameorBusinessNameController = TextEditingController()
      ..addListener(nameOrEmailControllerListener);
    emailController = TextEditingController()
      ..addListener(nameOrEmailControllerListener);
    cityController = TextEditingController();
    cfController = TextEditingController();
    fiscalCardController = TextEditingController()
      ..addListener(fiscalCardControllerListener);
  }

  void disposeControllers() {
    nameSurnameorBusinessNameController.dispose();
    emailController.dispose();
    cityController.dispose();
    cfController.dispose();
    fiscalCardController.dispose();
  }

  void fiscalCardControllerListener() {
    try {
      if (!fiscalCardController.text.isEmpty) {
        String temp = fiscalCardController.text.replaceAll('  ', ' ');
        cfController.text = temp.substring(1, 17);
        nameSurnameorBusinessNameController.text =
            temp.substring(17, temp.length - 23);
        fromReader = true;
      } else {
        fromReader = false;
      }
    } catch (e) {
      fromReader = false;
    }
  }

  void nameOrEmailControllerListener() {
    if (!nameSurnameorBusinessNameController.text.isEmpty ||
        !emailController.text.isEmpty) {
      fromReader = false;
    } else {
      fromReader = true;
    }
  }

  void submitSearch() {
    final isValid = nameSurnameorBusinessNameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        cityController.text.isNotEmpty ||
        cfController.text.isNotEmpty ||
        fiscalCardController.text.isNotEmpty;

    if (isValid) {
      GiveNotifier giveNotifier =
          Provider.of<GiveNotifier>(context, listen: false);
      giveNotifier.setStakeholder(StakeholderGiveModelSearch.empty());

      setState(() {
        isExecuted = true;
      });
    }
  }

  void clearSearch() {
    nameSurnameorBusinessNameController.text = "";
    emailController.text = "";
    cityController.text = "";
    cfController.text = "";
    fiscalCardController.text = "";
  }

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
    initializeControllers();
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

  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      //drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text("Gestione stakeholder",
            style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
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
                                    // validator: (val) => val!.length < 3
                                    //     ? 'Inserire almeno 3 caratteri'
                                    //     : null,
                                    onFieldSubmitted: (_) => submitSearch())))),
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
                                    // validator: (val) => val!.length < 3
                                    //     ? 'Inserire almeno 3 caratteri'
                                    //     : null,
                                    onFieldSubmitted: (_) => submitSearch())))),
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
                                    // validator: (val) => val!.length < 3
                                    //     ? 'Inserire almeno 3 caratteri'
                                    //     : null,
                                    onFieldSubmitted: (_) => submitSearch())))),
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
                                    // validator: (val) => val!.length < 3
                                    //     ? 'Inserire almeno 3 caratteri'
                                    //     : null,
                                    onFieldSubmitted: (_) => submitSearch())))),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 50, //height of button
                                width: double.infinity,
                                child: ShSearchTextfield(
                                    textEditingController: fiscalCardController,
                                    hintText:
                                        'Lettura da tessera Codice Fiscale',
                                    prefixIcon: const Icon(Icons.person),
                                    themeData: Theme.of(context),
                                    // validator: (val) => val!.length < 3
                                    //     ? 'Inserire almeno 3 caratteri'
                                    //     : null,
                                    onFieldSubmitted: (_) => submitSearch())))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50, //height of button
                        // width: 80,
                        child: MaterialButton(
                          hoverColor: Colors.blueAccent[100],
                          // height: MediaQuery.of(context).size.height * 0.05,
                          // minWidth: MediaQuery.of(context).size.width * 0.20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary)),

                          onPressed: submitSearch,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.search,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              Text('Ricerca',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50, //height of button
                        // width: 80,
                        child: MaterialButton(
                          hoverColor: Colors.blueAccent[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary)),
                          onPressed: clearSearch,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.cleaning_services,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              Text('Svuota',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
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
                      fromReader: fromReader,
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
                        List<String> item =
                            nameSurnameorBusinessNameController.text.split(' ');

                        String name = '';
                        String surname = '';

                        if (item.length == 1) {
                          surname = item[0];
                        } else if (item.length > 1) {
                          surname = item[0];
                          name = item[1];
                        }

                        ShManageMultipleArgument cShManageMultipleArgument =
                            new ShManageMultipleArgument(
                                idCart: widget.idCart,
                                cStakeholderGiveModelSearch:
                                    StakeholderGiveModelSearch(
                                        id: 0,
                                        nome: name,
                                        cognome: surname,
                                        ragionesociale: '',
                                        codfisc: cfController.text,
                                        email: emailController.text,
                                        tel: '',
                                        cell: '',
                                        dataNascita: '',
                                        recapitoGiveModel:
                                            RecapitoGiveModel.empty()));

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
