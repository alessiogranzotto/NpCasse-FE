import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/mass.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:uiblock/uiblock.dart';

class MassSendingPlanScreen extends StatefulWidget {
  final MassSendingModel massSendingModel;
  const MassSendingPlanScreen({super.key, required this.massSendingModel});

  @override
  State<MassSendingPlanScreen> createState() =>
      _MyosotisConfigurationDetailState();
}

class _MyosotisConfigurationDetailState extends State<MassSendingPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isLoadingData = true;
  bool isLoading = true;

  //PLANNING DATE MASS SENDING
  DateTime? planningDate;
  TimeOfDay? planningTime;

  //DATE PLAN MASS SENDING
  late final TextEditingController datePlanController;

  //TIME PLAN MASS SENDING
  late final TextEditingController timePlanController;

  void initializeControllers() {
    datePlanController = TextEditingController()
      ..addListener(dataControllerListener);
    timePlanController = TextEditingController()
      ..addListener(dataControllerListener);
  }

  void disposeControllers() {
    datePlanController.dispose();
    timePlanController.dispose();
  }

  void dataControllerListener() {}

  void setInitialData() {
    isEdit = widget.massSendingModel.idMassSending != 0;
    DateTime? dateTimePlanning = widget.massSendingModel.planningDate;

    if (dateTimePlanning != null) {
      //DATE PLAN MASS SENDING
      datePlanController.text =
          '${dateTimePlanning.day}/${dateTimePlanning.month}/${dateTimePlanning.year}';
      planningDate = DateTime(
          dateTimePlanning.year, dateTimePlanning.month, dateTimePlanning.day);
      //TIME PLAN MASS SENDING
      timePlanController.text =
          '${dateTimePlanning.hour}:${dateTimePlanning.minute}';
      planningTime = TimeOfDay(
          hour: dateTimePlanning.hour, minute: dateTimePlanning.minute);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    setInitialData();
  }

  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Dettaglio invio massivo: ${widget.massSendingModel.nameMassSending}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.redAccent,
                    )))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 200,
                              child: CustomTextFormField(
                                enabled: false,
                                controller: datePlanController,
                                labelText: AppStrings.datePlanMassSending,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                // onChanged: (_) => _formKey.currentState?.validate(),
                                validator: (value) {
                                  return value!.isNotEmpty
                                      ? null
                                      : AppStrings
                                          .pleaseEnterdatePlanMassSending;
                                },
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                final DateTime? date = await showDatePicker(
                                  context: context,
                                  initialDate: planningDate ?? DateTime.now(),
                                  firstDate: DateTime(2025),
                                  lastDate: DateTime(2050),
                                  locale: Locale('en', 'GB'),
                                  cancelText: 'Annulla',
                                  confirmText: 'Conferma',
                                  helpText: 'Data comunicazione ' +
                                      widget.massSendingModel.nameMassSending,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        datePickerTheme: DatePickerThemeData(
                                            //dayPeriodColor: Colors.blue.shade100,
                                            // backgroundColor: CustomColors
                                            //     .darkBlue, // Background color
                                            // hourMinuteTextColor: Colors
                                            //     .green, // Text color for hours and minutes
                                            // dayPeriodTextColor: Colors
                                            //     .amberAccent, // Text color for AM/PM
                                            // dayPeriodBorderSide: BorderSide(
                                            //     color: CustomColors
                                            //         .darkBlue), // Border color for AM/PM
                                            // dialHandColor: Colors
                                            //     .lightGreenAccent, // Color of the hour hand
                                            // dialTextColor: Colors
                                            //     .green, // Text color on the clock dial
                                            // dialBackgroundColor:
                                            //     Colors.brown.shade300,
                                            // entryModeIconColor: Colors.blue,
                                            // helpTextStyle: const TextStyle(
                                            //   color: Colors
                                            //       .blue, // Set the text color for "Enter time"
                                            // ),
                                            // hourMinuteTextStyle: TextStyle(
                                            //     fontSize:
                                            //         30), // Text style for hours and minutes
                                            ),
                                        colorScheme: ColorScheme.light(
                                          // change the border color
                                          primary: CustomColors.darkBlue,
                                          // change the text color
                                          onSurface: CustomColors.darkBlue,
                                        ),

                                        // button colors
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                setState(() {
                                  planningDate = date;

                                  if (date != null) {
                                    datePlanController.text =
                                        '${planningDate!.day}/${planningDate!.month}/${planningDate!.year}';
                                  } else {
                                    datePlanController.text = '';
                                  }
                                });
                              },
                              icon: Icon(Icons.date_range)),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 200,
                              child: CustomTextFormField(
                                enabled: false,
                                controller: timePlanController,
                                labelText: AppStrings.datePlanMassSending,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                // onChanged: (_) => _formKey.currentState?.validate(),
                                validator: (value) {
                                  return value!.isNotEmpty
                                      ? null
                                      : AppStrings
                                          .pleaseEnterdatePlanMassSending;
                                },
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                final TimeOfDay? time = await showTimePicker(
                                  cancelText: 'Annulla',
                                  confirmText: 'Conferma',
                                  helpText: 'Orario comunicazione ' +
                                      widget.massSendingModel.nameMassSending,
                                  hourLabelText: 'Ore',
                                  minuteLabelText: 'Minuti',
                                  context: context,
                                  initialTime: planningTime ?? TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.dial,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        timePickerTheme: TimePickerThemeData(
                                          dayPeriodColor: Colors.blue.shade100,
                                          // backgroundColor: CustomColors
                                          //     .darkBlue, // Background color
                                          // hourMinuteTextColor: Colors
                                          //     .green, // Text color for hours and minutes
                                          // dayPeriodTextColor: Colors
                                          //     .amberAccent, // Text color for AM/PM
                                          // dayPeriodBorderSide: BorderSide(
                                          //     color: CustomColors
                                          //         .darkBlue), // Border color for AM/PM
                                          // dialHandColor: Colors
                                          //     .lightGreenAccent, // Color of the hour hand
                                          // dialTextColor: Colors
                                          //     .green, // Text color on the clock dial
                                          // dialBackgroundColor:
                                          //     Colors.brown.shade300,
                                          // entryModeIconColor: Colors.blue,
                                          // helpTextStyle: const TextStyle(
                                          //   color: Colors
                                          //       .blue, // Set the text color for "Enter time"
                                          // ),
                                          // hourMinuteTextStyle: TextStyle(
                                          //     fontSize:
                                          //         30), // Text style for hours and minutes
                                        ),
                                        colorScheme: ColorScheme.light(
                                          // change the border color
                                          primary: CustomColors.darkBlue,
                                          // change the text color
                                          onSurface: CustomColors.darkBlue,
                                        ),

                                        // button colors
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                setState(() {
                                  planningTime = time;
                                  if (time != null) {
                                    timePlanController.text =
                                        '${time.hour}:${time.minute}';
                                  } else {
                                    timePlanController.text = '';
                                  }
                                });
                              },
                              icon: Icon(Icons.date_range)),
                        ],
                      ),

                      // if (planningTime != null)
                      //   Text('Selected time: ${planningTime!.format(context)}'),
                    ],
                  ),
                ),
              ),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  UIBlock.block(context);

                  // massSendingNotifier
                  //     .updateMassSendingGiveAccumulator(
                  //         context: context,
                  //         token: authenticationNotifier.token,
                  //         idMassSending: widget.massSendingModel.idMassSending,
                  //         idUserAppInstitution:
                  //             cUserAppInstitutionModel.idUserAppInstitution,
                  //         massSendingGiveAccumulator:
                  //             massSendingGiveAccumulator)
                  //     .then((value) {
                  //   if (value) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackUtil.stylishSnackBar(
                  //             title: "Comunicazioni",
                  //             message: "Informazioni aggiornate",
                  //             contentType: "success"));
                  //     UIBlock.unblock(context);
                  //     Navigator.of(context).pop();
                  //     massSendingNotifier.refresh();
                  //   } else {
                  //     UIBlock.unblock(context);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackUtil.stylishSnackBar(
                  //             title: "Comunicazioni",
                  //             message: "Errore di connessione",
                  //             contentType: "failure"));
                  //   }
                  // });
                }
              },

              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.check),
            ),
          ),
        ]));
  }
}
