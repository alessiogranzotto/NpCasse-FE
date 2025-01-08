import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/widgets/pdf.preview.wrapper.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfInvoiceScreen extends StatefulWidget {
  const PdfInvoiceScreen({
    Key? key,
    required this.idCart,
  }) : super(key: key);
  final int idCart;

  @override
  State<PdfInvoiceScreen> createState() => _PdfInvoiceScreenState();
}

class _PdfInvoiceScreenState extends State<PdfInvoiceScreen> {
  List<InvoiceTypeModel> invoiceTypeModelList = List.empty();
  List<PdfPreviewAction> actions = List.empty();
  late String emailName = '';

  static void closeCart(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          title: "Carrello",
          message: "Carrello chiuso correttamente",
          contentType: "success"));
    }
    // homeNotifier.setHomeIndex(0);
    Navigator.of(context).popUntil((route) => route.isFirst);
    cartNotifier.refresh();
  }

  void sendInvoice(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    cartNotifier.sendInvoice(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idCart: widget.idCart,
        emailName: emailName);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          title: "Carrello",
          message: "Invio email preso in carico",
          contentType: "success"));
    }
    // homeNotifier.setHomeIndex(0);
    //Navigator.of(context).popUntil((route) => route.isFirst);
    //cartNotifier.refresh();
  }

  @override
  void initState() {
    super.initState();
    // preparePdfAction();
  }

  Future preparePdfAction() async {
    if (invoiceTypeModelList.isNotEmpty) {
      return true;
    }
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    invoiceTypeModelList = await cartNotifier.getInvoiceType(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution);
    emailName = invoiceTypeModelList.first.emailName;
    actions = <PdfPreviewAction>[
      const PdfPreviewAction(
        icon: Icon(Icons.home),
        onPressed: closeCart,
      ),
      PdfPreviewAction(
        icon: Icon(Icons.email),
        onPressed: sendInvoice,
      ),
      PdfPreviewAction(
        icon: SizedBox(
          height: 60,
          child: DropdownMenu<InvoiceTypeModel>(
              initialSelection: invoiceTypeModelList.first,
              // controller: colorController,
              label: const Text('Tipi ricevuta:'),
              onSelected: (val) => setState(() {
                    if (val == null) {
                      emailName = invoiceTypeModelList.first.emailName;
                    } else {
                      emailName = val.emailName;
                    }
                  }),
              dropdownMenuEntries: (invoiceTypeModelList)
                  .map<DropdownMenuEntry<InvoiceTypeModel>>(
                      (InvoiceTypeModel item) {
                return DropdownMenuEntry<InvoiceTypeModel>(
                    value: item, label: item.emailName);
              }).toList()),
        ),
        onPressed: null,
      ),
    ];
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text('Ricevuta acquisto',
            style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: FutureBuilder(
        future: preparePdfAction(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PdfPreviewWrapper(
              actions: actions,
              emailName: emailName,
              idCart: widget.idCart,
            );
          } else if (snapshot.hasError) {
            return const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            );
          } else {
            return const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.redAccent,
                    )));
          }
        },
      ),
    );
  }
}
