import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfPreviewWrapper extends StatefulWidget {
  final List<PdfPreviewAction> actions;
  final String emailName;
  final int idCart;
  const PdfPreviewWrapper(
      {Key? key,
      required this.actions,
      required this.emailName,
      required this.idCart})
      : super(key: key);

  @override
  State<PdfPreviewWrapper> createState() => _PdfPreviewWrapperState();
}

class _PdfPreviewWrapperState extends State<PdfPreviewWrapper> {
  Future<Uint8List> generatePdf(
      BuildContext context, PdfPageFormat format, String emailName) async {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    var pdfExp = await cartNotifier.getInvoice(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idCart: widget.idCart,
        emailName: emailName);

    // final pdf = pw.Document(
    //   version: PdfVersion.pdf_1_5,
    //   compress: true,
    // );
    return pdfExp;
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  // Future<void> _saveAsFile(
  //   BuildContext context,
  //   LayoutCallback build,
  //   PdfPageFormat pageFormat,
  // ) async {
  //   final bytes = await build(pageFormat);

  //   final appDocDir = await getApplicationDocumentsDirectory();
  //   final appDocPath = appDocDir.path;
  //   final file = File('$appDocPath/document.pdf');
  //   print('Save as file ${file.path} ...');
  //   await file.writeAsBytes(bytes);
  //   await OpenFile.open(file.path);
  // }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        maxPageWidth: 600,
        actions: widget.actions,
        build: (
          format,
        ) =>
            generatePdf(context, format, widget.emailName),
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
        onError: (context, error) => AlertDialog(
              content: Text(error.toString() + context.toString()),
            ));
  }
}
