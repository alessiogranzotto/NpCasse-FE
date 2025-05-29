import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfReceiptScreen extends StatefulWidget {
  const PdfReceiptScreen({
    Key? key,
    required this.fiscalizationExternalId,
  }) : super(key: key);
  final String fiscalizationExternalId;

  @override
  State<PdfReceiptScreen> createState() => _PdfReceiptScreenState();
}

class _PdfReceiptScreenState extends State<PdfReceiptScreen> {
  List<PdfPreviewAction> actions = List.empty();
  late String emailName = '';

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
    cartNotifier.sendTransactionalInvoice(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idCart: 0,
        emailName: emailName,
        nameTransactionalSending: "");
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
  }

  Future<Uint8List> generatePdf(
      BuildContext context, PdfPageFormat format, String emailName) async {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    var pdfExp = await cartNotifier.getReceipt(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        fiscalizationExternalId: widget.fiscalizationExternalId);

    return pdfExp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text('Visualizzazione scontrino',
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        body: PdfPreview(
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            maxPageWidth: 600,
            actions: <PdfPreviewAction>[],
            build: (
              format,
            ) =>
                generatePdf(context, format, widget.fiscalizationExternalId),
            onError: (context, error) => AlertDialog(
                  content: Text(error.toString() + context.toString()),
                )));
  }
}
