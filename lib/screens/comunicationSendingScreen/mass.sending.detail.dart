import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:uiblock/uiblock.dart';

class MassSendingDetailScreen extends StatefulWidget {
  final MassSendingModel massSendingModel;
  const MassSendingDetailScreen({super.key, required this.massSendingModel});

  @override
  State<MassSendingDetailScreen> createState() => _MassSendingDetailState();
}

class _MassSendingDetailState extends State<MassSendingDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool tempDeleted = false;
  bool isLoading = true;
  bool allMassSendingGiveAccumulatorsArePresent = true;

  //NAME MASS SENDING
  late final TextEditingController nameMassSendingController;

  //ISARCHIVED MASS SENDING
  final ValueNotifier<bool> archiviedNotifier = ValueNotifier<bool>(false);

  //DESCRIPTION MASS SENDING
  late final TextEditingController descriptionMassSendingController;

  //SENDER MASS SENDING
  late final TextEditingController senderMassSendingController;

  //EMAIL SENDER MASS SENDING
  late final TextEditingController emailSenderMassSendingController;

  //AVAILABLE SMTP2GO TEMPLATE MASS SENDING
  List<TemplateSmtp2GoModel> availableSmtp2GoTemplate = List.empty();
  List<DropdownMenuItem> availableSmtp2GoTemplateItem = List.empty();

  //SMTP2GO TEMPLATE MASS SENDING
  TemplateSmtp2GoModel? smtp2GoTemplate;

  final ValueNotifier<bool> viewTemplateValidNotifier = ValueNotifier(false);

  //GIVE ACCUMULATOR
  final accumulatorGiveController =
      MultiSelectController<AccumulatorGiveModel>();
  List<AccumulatorGiveModel> availableAccumulatorGive = List.empty();
  List<DropdownItem<AccumulatorGiveModel>> availableAccumulatorGiveItem = [];

  //PLANNING DATE MASS SENDING
  DateTime? planningDate;
  TimeOfDay? planningTime;

  //DATE PLAN MASS SENDING
  late final TextEditingController datePlanController;

  //TIME PLAN MASS SENDING
  late final TextEditingController timePlanController;

  //AVAILABLE FREQUENCY TYPE MASS SENDING
  List<DropdownMenuItem<String>> availableFrequencyTypeMassSending = [
    DropdownMenuItem(child: Text("Singola"), value: "Single"),
    DropdownMenuItem(child: Text("Oraria"), value: "Hourly"),
    DropdownMenuItem(child: Text("Giornaliera"), value: "Daily"),
    DropdownMenuItem(child: Text("Mensile"), value: "Monthly")
  ];

  // FREQUENCY TYPE MASS SENDING
  late ValueNotifier<String?> frequencyTypeMassSending =
      ValueNotifier<String?>(null);

  //EXECUTE STEP MASS SENDING
  late final TextEditingController executeStepController;

  //ADVANCE HOURS LOAD ACCUMULATORS MASS SENDING
  late final TextEditingController advanceHoursLoadAccumulatorController;

  //EMAIL DEDUPLICATION MASS SENDING
  final ValueNotifier<bool> emailDeduplicationNotifier =
      ValueNotifier<bool>(false);

  //ONLY TO NEW SEND MASS SENDING
  final ValueNotifier<bool> onlyToNewSendNotifier = ValueNotifier<bool>(false);

  //ONLY TO NOT OPEN SEND MASS SENDING
  final ValueNotifier<bool> onlyToNotOpenNotifier = ValueNotifier<bool>(false);

  getFriendlyFrequencyDescription(String? frequency) {
    if (frequency == 'Hourly') {
      return 'Intervallo esecuzione (in ore)';
    } else if (frequency == 'Daily') {
      return 'Intervallo esecuzione (in giorni)';
    } else if (frequency == 'Monthly') {
      return 'Intervallo esecuzione (in mesi)';
    } else {
      return 'Intervallo esecuzione ';
    }
  }

  void initializeControllers() {
    nameMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    descriptionMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    senderMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    emailSenderMassSendingController = TextEditingController()
      ..addListener(dataControllerListener);
    datePlanController = TextEditingController()
      ..addListener(dataControllerListener);
    timePlanController = TextEditingController()
      ..addListener(dataControllerListener);
    executeStepController = TextEditingController()
      ..addListener(dataControllerListener);
    advanceHoursLoadAccumulatorController = TextEditingController()
      ..addListener(dataControllerListener);
  }

  void disposeControllers() {
    nameMassSendingController.dispose();
    descriptionMassSendingController.dispose();
    senderMassSendingController.dispose();
    emailSenderMassSendingController.dispose();
    datePlanController.dispose();
    timePlanController.dispose();
    executeStepController.dispose();
    advanceHoursLoadAccumulatorController.dispose();
  }

  void dataControllerListener() {}

  Future<void> getEmailTemplatesFromSmtp2Go() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    final value = await massSendingNotifier.getEmailTemplatesFromSmtp2Go(
      context: context,
      token: authenticationNotifier.token,
      idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
      idInstitution:
          cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
    );

    if (value is List<TemplateSmtp2GoModel>) {
      availableSmtp2GoTemplate = value;
    }
  }

  Future<void> getAccumulatorFromGive() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context, listen: false);

    final value = await massSendingNotifier.getAccumulatorFromGive(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution);

    if (value is List<AccumulatorGiveModel>) {
      availableAccumulatorGive = value;
    }
  }

  void downloadEmailTemplateDetailFromSmtp2Go() {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    MassSendingNotifier massSendingNotifier =
        Provider.of<MassSendingNotifier>(context, listen: false);
    massSendingNotifier.downloadEmailTemplateDetailFromSmtp2Go(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        idtemplate: smtp2GoTemplate!.id);
  }

  Future<void> initData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      getEmailTemplatesFromSmtp2Go(),
      getAccumulatorFromGive(),
    ]);

    setInitialData();
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    isEdit = widget.massSendingModel.idMassSending != 0;
    initData();
  }

  void setInitialData() {
    //NAME MASS SENDING
    nameMassSendingController.text =
        widget.massSendingModel.nameMassSending.toString();

    //ISARCHIVED MASS SENDING
    archiviedNotifier.value = widget.massSendingModel.deleted;
    tempDeleted = archiviedNotifier.value;

    //DESCRIPTION MASS SENDING
    descriptionMassSendingController.text =
        widget.massSendingModel.descriptionMassSending.toString();

    //SENDER MASS SENDING
    senderMassSendingController.text =
        widget.massSendingModel.senderMassSending.toString();

    //EMAIL SENDER MASS SENDING
    emailSenderMassSendingController.text =
        widget.massSendingModel.emailSenderMassSending.toString();

    //AVAILABLE SMTP2GO TEMPLATE MASS SENDING
    availableSmtp2GoTemplateItem = availableSmtp2GoTemplate
        .map<DropdownMenuItem<TemplateSmtp2GoModel>>(
            (TemplateSmtp2GoModel item) {
      return DropdownMenuItem<TemplateSmtp2GoModel>(
          value: item, child: Text(item.id + " - " + item.name));
    }).toList();

    //SMTP2GO TEMPLATE MASS SENDING
    var itemSmtp2GoTemplate = availableSmtp2GoTemplate
        .where((e) => e.id == widget.massSendingModel.idTemplateMassSending);

    smtp2GoTemplate = itemSmtp2GoTemplate.firstOrNull;
    if (smtp2GoTemplate != null) {
      viewTemplateValidNotifier.value = true;
    }

    //AVAILABLE GIVE ACCUMULATOR MASS SENDING
    for (final acc in availableAccumulatorGive) {
      final isPresent = widget.massSendingModel.massSendingGiveAccumulators
          .any((e) => e.idGiveAccumulator == acc.id);

      availableAccumulatorGiveItem.add(
        DropdownItem(
          selected: isPresent,
          label: "${acc.id} - ${acc.titolo}",
          value: acc,
        ),
      );
    }

    allMassSendingGiveAccumulatorsArePresent =
        widget.massSendingModel.massSendingGiveAccumulators.every(
      (selected) => availableAccumulatorGive.any(
        (available) => available.id == selected.idGiveAccumulator,
      ),
    );

    if (!allMassSendingGiveAccumulatorsArePresent) {
      // Forzo la validazione immediata
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    }

    DateTime? dateTimePlanning = widget.massSendingModel.planningDate;

    if (dateTimePlanning != null) {
      //DATE PLAN MASS SENDING
      datePlanController.text =
          '${dateTimePlanning.day.toString().padLeft(2, '0')}/${dateTimePlanning.month.toString().padLeft(2, '0')}/${dateTimePlanning.year}';
      planningDate = DateTime(
          dateTimePlanning.year, dateTimePlanning.month, dateTimePlanning.day);
      //TIME PLAN MASS SENDING
      timePlanController.text =
          '${dateTimePlanning.hour.toString().padLeft(2, '0')}:${dateTimePlanning.minute.toString().padLeft(2, '0')}';
      planningTime = TimeOfDay(
          hour: dateTimePlanning.hour, minute: dateTimePlanning.minute);
    }

    //EXECUTE STEP MASS SENDING
    executeStepController.text =
        widget.massSendingModel.executeStepMassSending?.toString() ?? '';

    //ADVANCE HOURS LOAD ACCUMULATORS MASS SENDING
    advanceHoursLoadAccumulatorController.text = widget
            .massSendingModel.advanceHoursLoadAccumulatorMassSending
            ?.toString() ??
        '';

    //FREQUENCY TYPE MASS SENDING
    frequencyTypeMassSending.value =
        widget.massSendingModel.frequencyTypeMassSending;

    //ISARCHIVED MASS SENDING
    emailDeduplicationNotifier.value =
        widget.massSendingModel.emailDeduplicationMassSending;

    //ISARCHIVED MASS SENDING
    onlyToNewSendNotifier.value =
        widget.massSendingModel.onlyToNewSendMassSending;

    //ISARCHIVED MASS SENDING
    onlyToNotOpenNotifier.value =
        widget.massSendingModel.onlyToNotOpenMassSending;

    setState(() {
      isLoading = false;
    });
  }

  @override
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
            isEdit
                ? 'Modifica invio massivo: ${widget.massSendingModel.nameMassSending}'
                : 'Nuovo invio massivo',
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
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CustomTextFormField(
                              enabled: true,
                              controller: nameMassSendingController,
                              labelText: AppStrings.nameComunicationSending,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              // onChanged: (_) =>
                              //     _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : AppStrings
                                        .pleaseEnterNameComunicationSending;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                              valueListenable:
                                  archiviedNotifier, // Ascolta i cambiamenti del ValueNotifier
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                    title: Text("Archiviata"),
                                    value: value,
                                    onChanged: (bool? newValue) {
                                      if (isEdit && tempDeleted) {
                                        archiviedNotifier.value =
                                            newValue ?? false;
                                      }
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading);
                              },
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomTextFormField(
                        enabled: true,
                        controller: descriptionMassSendingController,
                        labelText: AppStrings.descriptionComunicationSending,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        // onChanged: (_) => _formKey.currentState?.validate(),
                        // validator: (value) {
                        //   return value!.isNotEmpty
                        //       ? null
                        //       : AppStrings.pleaseEnterSenderMassSending;
                        // },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CustomTextFormField(
                              enabled: true,
                              controller: senderMassSendingController,
                              labelText: AppStrings.senderComunicationSending,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              // onChanged: (_) => _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : AppStrings
                                        .pleaseEnterSenderComunicationSending;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CustomTextFormField(
                              enabled: true,
                              controller: emailSenderMassSendingController,
                              labelText:
                                  AppStrings.emailSenderComunicationSending,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              // onChanged: (_) => _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isEmpty
                                    ? AppStrings
                                        .pleaseEnterEmailSenderComunicationSending
                                    : AppConstants.emailRegex.hasMatch(value)
                                        ? null
                                        : AppStrings.invalidEmailAddress;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: smtp2GoTemplate,
                              labelText: AppStrings.comunicationSendingTemplate,
                              listOfValue: availableSmtp2GoTemplateItem,
                              onItemChanged: (value) {
                                smtp2GoTemplate = value;
                                viewTemplateValidNotifier.value = true;
                                dataControllerListener();
                                // _formKey.currentState?.validate();
                              },
                              validator: (value) {
                                if (smtp2GoTemplate == null) {
                                  return AppStrings
                                      .pleaseEnterComunicationSendingTemplate;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: viewTemplateValidNotifier,
                          builder: (_, isValid, __) {
                            return IconButton(
                              tooltip: 'Scarica',
                              iconSize: 32,
                              icon: Icon(Icons.download),
                              onPressed: isValid
                                  ? () {
                                      downloadEmailTemplateDetailFromSmtp2Go();
                                    }
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 12,
                          child: Column(
                            children: [
                              Tooltip(
                                message: 'Accumulatori Give',
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: MultiDropdown<AccumulatorGiveModel>(
                                    items: availableAccumulatorGiveItem,
                                    controller: accumulatorGiveController,
                                    enabled: true,
                                    searchEnabled: true,
                                    chipDecoration: ChipDecoration(
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(width: 1.5),
                                      backgroundColor: Colors.transparent,
                                      wrap: true,
                                      runSpacing: 2,
                                      spacing: 10,
                                    ),
                                    fieldDecoration: FieldDecoration(
                                      hintText: 'Selezionare accumulatori',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.3)),
                                      prefixIcon:
                                          const Icon(Icons.article_outlined),
                                      showClearIcon: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    dropdownItemDecoration:
                                        DropdownItemDecoration(
                                      selectedIcon: const Icon(Icons.check_box,
                                          color: CustomColors.darkBlue),
                                      disabledIcon: Icon(Icons.lock,
                                          color: Colors.grey.shade300),
                                    ),
                                    validator: (value) {
                                      if (!allMassSendingGiveAccumulatorsArePresent) {
                                        return 'Alcuni accumulatori non sono disponibili';
                                      }
                                      if (value == null || value.isEmpty) {
                                        return 'Inserire accumulatore';
                                      }
                                      return null; // valido
                                    },
                                    onSelectionChange: (selectedItems) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                          child: SizedBox(
                            width: 150,
                            child: CustomTextFormField(
                              enabled: false,
                              controller: datePlanController,
                              labelText: AppStrings.datePlanComunicationSending,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              // onChanged: (_) => _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : AppStrings
                                        .pleaseEnterDatePlanComunicationSending;
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
                                lastDate: DateTime(DateTime.now().year + 1),
                                locale: Locale('it', 'IT'),
                                cancelText: 'Annulla',
                                confirmText: 'Conferma',
                                helpText: 'Data ' +
                                    widget.massSendingModel.nameMassSending,
                                builder: (BuildContext context, Widget? child) {
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

                                planningDate = date;
                                datePlanController.text = date != null
                                    ? '${date.day.toString().padLeft(2, '0')}/'
                                        '${date.month.toString().padLeft(2, '0')}/'
                                        '${date.year}'
                                    : '';
                              });
                            },
                            icon: Icon(Icons.date_range)),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 32),
                          child: SizedBox(
                            width: 150,
                            child: CustomTextFormField(
                              enabled: false,
                              controller: timePlanController,
                              labelText: AppStrings.hourPlanComunicationSending,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              // onChanged: (_) => _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : AppStrings
                                        .pleaseEnterHourPlanComunicationSending;
                              },
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                cancelText: 'Annulla',
                                confirmText: 'Conferma',
                                helpText: 'Ora ' +
                                    widget.massSendingModel.nameMassSending,
                                hourLabelText: 'Ore',
                                minuteLabelText: 'Minuti',
                                context: context,
                                initialTime: planningTime ?? TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.dial,
                                builder: (BuildContext context, Widget? child) {
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
                                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                } else {
                                  timePlanController.text = '';
                                }
                              });
                            },
                            icon: Icon(Icons.query_builder)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: frequencyTypeMassSending.value,
                              labelText: AppStrings.frequencyMassSending,
                              listOfValue: availableFrequencyTypeMassSending,
                              onItemChanged: (value) {
                                frequencyTypeMassSending.value = value;
                                String cItem = value as String;
                                frequencyTypeMassSending.value = cItem;
                                if (value == 'Single') {
                                  executeStepController.text = '';
                                } else {}
                                dataControllerListener();
                              },
                              validator: (value) {
                                if (frequencyTypeMassSending.value == null) {
                                  return AppStrings
                                      .pleaseEnterFrequencyMassSending;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              ValueListenableBuilder<String?>(
                                valueListenable: frequencyTypeMassSending,
                                builder: (context, value, _) {
                                  return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 1000),
                                      child: (value == null)
                                          ? const SizedBox.shrink()
                                          : (value == "Single")
                                              ? Container(
                                                  key: ValueKey(value),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 250,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CustomTextFormField(
                                                                enabled: true,
                                                                controller:
                                                                    advanceHoursLoadAccumulatorController,
                                                                labelText:
                                                                    AppStrings
                                                                        .advanceHoursLoadAccumulatorMassSending,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatter: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  key: ValueKey(value),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 250,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CustomTextFormField(
                                                                enabled: true,
                                                                controller:
                                                                    advanceHoursLoadAccumulatorController,
                                                                labelText:
                                                                    AppStrings
                                                                        .advanceHoursLoadAccumulatorMassSending,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatter: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 250,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CustomTextFormField(
                                                                enabled: true,
                                                                controller:
                                                                    executeStepController,
                                                                labelText: getFriendlyFrequencyDescription(
                                                                    frequencyTypeMassSending
                                                                        .value),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatter: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                validator:
                                                                    (value) {
                                                                  return value!
                                                                          .isNotEmpty
                                                                      ? null
                                                                      : AppStrings
                                                                          .pleaseEnterExecuteStepMassSending;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: emailDeduplicationNotifier,
                            builder: (context, value, child) {
                              return CheckboxListTile(
                                title: const Text("Deduplica per email"),
                                value: value,
                                onChanged: (bool? newValue) {
                                  emailDeduplicationNotifier.value =
                                      newValue ?? false;
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: onlyToNewSendNotifier,
                            builder: (context, value, child) {
                              return CheckboxListTile(
                                title: const Text("Invia solo ai nuovi"),
                                value: value,
                                onChanged: (bool? newValue) {
                                  onlyToNewSendNotifier.value =
                                      newValue ?? false;
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: onlyToNotOpenNotifier,
                            builder: (context, value, child) {
                              return CheckboxListTile(
                                title: const Text(
                                    "Invia solo a chi non l'ha aperta"),
                                value: value,
                                onChanged: (bool? newValue) {
                                  onlyToNotOpenNotifier.value =
                                      newValue ?? false;
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [],
                    ),
                  ],
                ))),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  UIBlock.block(context);
                  DateTime dateTimePlanMassSending = new DateTime(
                      planningDate!.year,
                      planningDate!.month,
                      planningDate!.day,
                      planningTime!.hour,
                      planningTime!.minute,
                      0);

                  List<MassSendingGiveAccumulator> massSendingGiveAccumulator =
                      [];
                  for (int i = 0;
                      i < accumulatorGiveController.selectedItems.length;
                      i++) {
                    massSendingGiveAccumulator.add(MassSendingGiveAccumulator(
                        idGiveAccumulator:
                            accumulatorGiveController.selectedItems[i].value.id,
                        titleGiveAccumulator: accumulatorGiveController
                            .selectedItems[i].value.titolo));
                  }

                  MassSendingModel massSendingModel = MassSendingModel(
                      idMassSending: widget.massSendingModel.idMassSending,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      idInstitution: cUserAppInstitutionModel
                          .idInstitutionNavigation.idInstitution,
                      deleted: archiviedNotifier.value,
                      nameMassSending: nameMassSendingController.text,
                      descriptionMassSending:
                          descriptionMassSendingController.text,
                      senderMassSending: senderMassSendingController.text,
                      emailSenderMassSending:
                          emailSenderMassSendingController.text,
                      idTemplateMassSending:
                          smtp2GoTemplate == null ? '' : smtp2GoTemplate!.id,
                      planningDate: dateTimePlanMassSending,
                      frequencyTypeMassSending: frequencyTypeMassSending.value!,
                      executeStepMassSending:
                          int.parse(executeStepController.text),
                      advanceHoursLoadAccumulatorMassSending: int.tryParse(
                          advanceHoursLoadAccumulatorController.text),
                      emailDeduplicationMassSending:
                          emailDeduplicationNotifier.value,
                      onlyToNewSendMassSending: onlyToNewSendNotifier.value,
                      onlyToNotOpenMassSending: onlyToNotOpenNotifier.value,
                      massSendingGiveAccumulators: massSendingGiveAccumulator);

                  massSendingNotifier
                      .addOrUpdateMassSending(
                          context: context,
                          token: authenticationNotifier.token,
                          massSendingModel: massSendingModel)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Comunicazioni",
                              message: "Informazioni aggiornate",
                              contentType: "success"));
                      UIBlock.unblock(context);
                      Navigator.of(context).pop();
                      massSendingNotifier.refresh();
                    } else {
                      UIBlock.unblock(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Comunicazioni",
                              message: "Errore di connessione",
                              contentType: "failure"));
                    }
                  });
                }
              },

              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.check),
            ),
          ),
          (isEdit && !tempDeleted)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    tooltip: "Archivia",
                    shape: const CircleBorder(eccentricity: 0.5),
                    onPressed: () {
                      var dialog = CustomAlertDialog(
                        title: "Archiviazione comunicazione",
                        content:
                            Text("Si desidera procedere alla archiviazione?"),
                        yesCallBack: () {
                          if (_formKey.currentState!.validate()) {
                            UIBlock.block(context);
                            DateTime dateTimePlanMassSending = new DateTime(
                                planningDate!.year,
                                planningDate!.month,
                                planningDate!.day,
                                planningTime!.hour,
                                planningTime!.minute,
                                0);

                            List<MassSendingGiveAccumulator>
                                massSendingGiveAccumulator = [];
                            for (int i = 0;
                                i <
                                    accumulatorGiveController
                                        .selectedItems.length;
                                i++) {
                              massSendingGiveAccumulator.add(
                                  MassSendingGiveAccumulator(
                                      idGiveAccumulator:
                                          accumulatorGiveController
                                              .selectedItems[i].value.id,
                                      titleGiveAccumulator:
                                          accumulatorGiveController
                                              .selectedItems[i].value.titolo));
                            }

                            MassSendingModel massSendingModel = MassSendingModel(
                                idMassSending:
                                    widget.massSendingModel.idMassSending,
                                idUserAppInstitution: cUserAppInstitutionModel
                                    .idUserAppInstitution,
                                idInstitution: cUserAppInstitutionModel
                                    .idInstitutionNavigation.idInstitution,
                                deleted: true,
                                nameMassSending: nameMassSendingController.text,
                                descriptionMassSending:
                                    descriptionMassSendingController.text,
                                senderMassSending:
                                    senderMassSendingController.text,
                                emailSenderMassSending:
                                    emailSenderMassSendingController.text,
                                idTemplateMassSending: smtp2GoTemplate == null
                                    ? ''
                                    : smtp2GoTemplate!.id,
                                planningDate: dateTimePlanMassSending,
                                frequencyTypeMassSending:
                                    frequencyTypeMassSending.value!,
                                executeStepMassSending:
                                    int.parse(executeStepController.text),
                                advanceHoursLoadAccumulatorMassSending: int.tryParse(
                                    advanceHoursLoadAccumulatorController.text),
                                emailDeduplicationMassSending:
                                    emailDeduplicationNotifier.value,
                                onlyToNewSendMassSending:
                                    onlyToNewSendNotifier.value,
                                onlyToNotOpenMassSending:
                                    onlyToNotOpenNotifier.value,
                                massSendingGiveAccumulators:
                                    massSendingGiveAccumulator);

                            massSendingNotifier
                                .addOrUpdateMassSending(
                                    context: context,
                                    token: authenticationNotifier.token,
                                    massSendingModel: massSendingModel)
                                .then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Comunicazioni",
                                        message: "Informazioni aggiornate",
                                        contentType: "success"));
                                UIBlock.unblock(context);
                                Navigator.of(context).pop();
                                massSendingNotifier.refresh();
                              } else {
                                UIBlock.unblock(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Comunicazioni",
                                        message: "Errore di connessione",
                                        contentType: "failure"));
                              }
                            });
                          }
                        },
                        noCallBack: () {},
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog);
                    },
                    //backgroundColor: Colors.deepOrangeAccent,
                    child: const Icon(Icons.archive),
                  ),
                )
              : const SizedBox.shrink()
        ]));
  }
}
