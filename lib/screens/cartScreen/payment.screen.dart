import 'package:flutter/material.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/home.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/sh.manage.screen.dart';
import 'package:np_casse/screens/cartScreen/toggle.search.new.sh.dart';
import 'package:np_casse/screens/cartScreen/widgets/numeric.keypad.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

enum PaymentType { contanti, bancomat, cartaCredito, assegni }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController givenMoneyController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController textControllerAdj = TextEditingController();
  final TextEditingController textControllerResto = TextEditingController();
  bool disabledFinalizeButton = true;
  int indexPayment = 0;

  @override
  void initState() {
    disabledFinalizeButton = true;
    super.initState();
  }

  void checkImport(int index, double rest) {
    print(index);
    print(rest);
    setState(() {
      indexPayment = index;
      disabledFinalizeButton = true;
      if (index > 0) {
        disabledFinalizeButton = false;
      } else {
        if (rest >= 0) {
          disabledFinalizeButton = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    HomeNotifier homeNotifier = Provider.of<HomeNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    void finalizeFunction() {
      var strTypePayment = PaymentType.values[indexPayment].toString();
      cartNotifier
          .finalizeCart(
              context: context,
              token: authenticationNotifier.token,
              idCart: cartNotifier.getCart().idCart,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              typePayment: strTypePayment)
          .then((value) {
        if (value > 0) {
          showModalBottomSheet(
            // backgroundColor: Colors.red,
            useSafeArea: true,
            isDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return Wrap(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      child: Text(value.toString(),
                          style: Theme.of(context).textTheme.headlineLarge),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text('Abbina ad anagrafica (richiedi ricevuta)',
                        style: Theme.of(context).textTheme.titleMedium),
                    onTap: () {
                      Navigator.pop(context);
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const ShManageScreen(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.undo),
                    title: Text('Donazione anonima (ritorna a progetti)',
                        style: Theme.of(context).textTheme.titleMedium),
                    onTap: () {
                      homeNotifier.setHomeIndex(1);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      //Navigator.of(context)
                      // .pushNamed(AppRouter.homeRoute);
                    },
                  ),
                  const ListTile(
                    title: Text(''),
                  ),
                ],
              );
            },
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
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Pagamento del carrello',
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        body: Column(
          children: [
            Text(
                'Numero prodotti nel carrello: ${cartNotifier.nrProductInCart}',
                style: Theme.of(context).textTheme.titleSmall),
            Text(
                'Numero tipologie prodotti nel carrello: ${cartNotifier.nrProductTypeInCart}',
                style: Theme.of(context).textTheme.titleSmall),
            Text('Totale carrello: € ${cartNotifier.totalCartMoney.value}',
                style: Theme.of(context).textTheme.titleSmall),
            TextField(
              controller: textControllerAdj,
              // keyboardType: TextInputType.none,
              readOnly: true,
            ),
            Visibility(
              visible: false,
              child: TextField(
                controller: textController,
                // keyboardType: TextInputType.none,
                readOnly: true,
              ),
            ),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[100],
                  side: const BorderSide(
                      width: 1, // the thickness
                      color: Colors.grey // the color of the border
                      ),
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  // textStyle:
                  //     const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                ),
                onPressed: disabledFinalizeButton ? null : finalizeFunction,
                child: const Column(children: [
                  Icon(Icons.next_plan),
                  Text("Finalizza pagamento",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))
                ])),
            NumericKeypad(
                checkImport: checkImport,
                controller: textController,
                controllerAdj: textControllerAdj,
                moneyValueCart: cartNotifier.totalCartMoney.value)
          ],
        ));
  }
}
