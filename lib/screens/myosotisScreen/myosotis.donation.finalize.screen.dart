import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/myosotis.donation.model.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/screens/comunicationSendingScreen/comunication.sending.utility.dart';

class MyosotisDonationFinalizeScreen extends StatefulWidget {
  final MyosotisDonationModel myosotisDonationModel;
  const MyosotisDonationFinalizeScreen(
      {super.key, required this.myosotisDonationModel});

  @override
  State<MyosotisDonationFinalizeScreen> createState() =>
      _MassSendingStatisticsState();
}

class _MassSendingStatisticsState
    extends State<MyosotisDonationFinalizeScreen> {
  String? _selectedMethod; // "iban" o "card"

  // Controller per IBAN e titolare
  final bankAccountIbanController = TextEditingController();
  final bankAccountHolderController = TextEditingController();

  // Controller per carta di credito
  final creditCardNumberController = TextEditingController();
  final creditCardHolderController = TextEditingController();
  final creditCardExpireDateController = TextEditingController();
  final creditCardCvvController = TextEditingController();

  void initializeControllers() {}

  void disposeControllers() {}

  void dataControllerListener() {}

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Finalizzazione donazione: ${widget.myosotisDonationModel.idMyosotisFormData}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Seleziona il metodo di pagamento:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              RadioListTile<String>(
                title: const Text("Bonifico bancario"),
                value: "iban",
                groupValue: _selectedMethod,
                onChanged: (value) {
                  setState(() => _selectedMethod = value);
                },
              ),
              RadioListTile<String>(
                title: const Text("Carta di credito"),
                value: "card",
                groupValue: _selectedMethod,
                onChanged: (value) {
                  setState(() => _selectedMethod = value);
                },
              ),
              const SizedBox(height: 16),
              if (_selectedMethod == "iban") ...[
                CustomTextFormField(
                  enabled: true,
                  controller: bankAccountIbanController,
                  labelText: AppStrings.bankAccountIban,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  enabled: true,
                  controller: bankAccountHolderController,
                  labelText: AppStrings.bankAccountHolder,
                ),
              ] else if (_selectedMethod == "card") ...[
                CustomTextFormField(
                  enabled: true,
                  controller: creditCardNumberController,
                  keyboardType: TextInputType.number,
                  labelText: AppStrings.creditCardNumber,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  enabled: true,
                  controller: creditCardHolderController,
                  labelText: AppStrings.creditCardHolder,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        enabled: true,
                        controller: creditCardExpireDateController,
                        labelText: AppStrings.creditCardExpireDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormField(
                        enabled: true,
                        controller: creditCardCvvController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        labelText: AppStrings.creditCardCVV,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {},

              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.check),
            ),
          ),
        ]));
  }
}
