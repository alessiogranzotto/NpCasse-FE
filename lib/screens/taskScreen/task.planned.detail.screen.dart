import 'package:flutter/material.dart';

import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/constants/regex.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/task.common.model.dart';
import 'package:np_casse/core/models/task.planned.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/task.common.notifier.dart';
import 'package:np_casse/core/notifiers/task.planned.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/taskScreen/task.utils.dart';
import 'package:provider/provider.dart';
import 'package:uiblock/uiblock.dart';

class TaskPlannedDetailScreen extends StatefulWidget {
  final TaskPlannedModel taskPlanned;
  const TaskPlannedDetailScreen({
    super.key,
    required this.taskPlanned,
  });

  @override
  State<TaskPlannedDetailScreen> createState() =>
      _ProductAttributeDetailState();
}

class _ProductAttributeDetailState extends State<TaskPlannedDetailScreen> {
  TimeOfDay? planningTime;
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool tempDeleted = false;
  bool isLoading = true;
  List<TaskCommonModel> availableTaskCommon = [];
  List<String> availableRangeExtractionTaskCommon = [];
  List<String> availableExportModeTaskCommon = [];
  List<String> availableSendModeTaskCommon = [];

  //TASK PLANNED NAME
  late final TextEditingController nameTaskPlannedController;

  //TASK PLANNED VALUE TASK COMMON
  late ValueNotifier<TaskCommonModel?> currentTaskCommonModel =
      ValueNotifier<TaskCommonModel?>(null);

  //RANGE EXTRACTION TASK PLANNED
  late String? selectedRangeExtractionTaskPlanned = null;

  //TIME PLAN TASK PLANNED
  late final TextEditingController timePlanTaskPlannedController;

  //EXPORT MODE TASK PLANNED
  late String? selectedExportModeTaskPlanned = null;

  //SEND MODE TASK PLANNED
  late ValueNotifier<String?> selectedSendModeTaskPlanned =
      ValueNotifier<String?>(null);

  //TASK PLANNED RECIPIENT EMAIL
  late final TextEditingController recipientEmailTaskPlannedController;

  //TASK PLANNED FTP SERVER
  late final TextEditingController ftpServerTaskPlannedController;

  //TASK PLANNED FTP USERNAME
  late final TextEditingController ftpUsernameTaskPlannedController;

  //TASK PLANNED FTP PASSWORD
  late final TextEditingController ftpPasswordTaskPlannedController;

  //DELETED TASK PLANNED
  final ValueNotifier<bool> deletedTaskPlannedNotifier =
      ValueNotifier<bool>(false);

  void initializeControllers() {
    nameTaskPlannedController = TextEditingController()
      ..addListener(dataControllerListener);
    timePlanTaskPlannedController = TextEditingController()
      ..addListener(dataControllerListener);
    recipientEmailTaskPlannedController = TextEditingController()
      ..addListener(dataControllerListener);
    ftpServerTaskPlannedController = TextEditingController()
      ..addListener(dataControllerListener);
    ftpUsernameTaskPlannedController = TextEditingController()
      ..addListener(dataControllerListener);
    ftpPasswordTaskPlannedController = TextEditingController()
      ..addListener(dataControllerListener);
  }

  void disposeControllers() {
    nameTaskPlannedController.dispose();
    timePlanTaskPlannedController.dispose();
    recipientEmailTaskPlannedController.dispose();
    ftpServerTaskPlannedController.dispose();
    ftpPasswordTaskPlannedController.dispose();
  }

  void dataControllerListener() {}

  Future<void> getAvailableCommonTask() async {
    setState(() {
      isLoading = true;
    });
    final authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    final cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    final taskCommonNotifier =
        Provider.of<TaskCommonNotifier>(context, listen: false);

    try {
      final value = await taskCommonNotifier.getTaskCommon(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idInstitution:
            cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
        readAlsoDeleted: false,
      );

      setState(() {
        availableTaskCommon = value;
        setWidgetDetail();
        isLoading = false;
      });
    } catch (e) {
      // eventuale gestione errore
      setState(() {
        isLoading = false;
      });
    }
  }

  setWidgetDetail() {
    if (isEdit) {
      var itemTaskCommonModel = availableTaskCommon
          .where((e) => e.idTaskCommon == widget.taskPlanned.idTaskCommon);
      if (itemTaskCommonModel.isNotEmpty) {
        var findedItem = itemTaskCommonModel.first;
        currentTaskCommonModel.value = findedItem;

        availableRangeExtractionTaskCommon =
            findedItem.rangeExtractionTaskCommon
                .split(";")
                .where((e) => e.isNotEmpty) // filtra le stringhe vuote
                .toList();
        availableExportModeTaskCommon = findedItem.exportExtensionsTaskCommon
            .split(";")
            .where((e) => e.isNotEmpty) // filtra le stringhe vuote
            .toList();
// selectedExportModeTaskCommon = widget.taskPlanned.exportExtensionTaskPlanned;
        availableSendModeTaskCommon = findedItem.enabledSendMethodTaskCommon
            .split(";")
            .where((e) => e.isNotEmpty) // filtra le stringhe vuote
            .toList();
// selectedSendModeTaskCommon = widget.taskPlanned.sendModeTaskPlanned;
      }
      nameTaskPlannedController.text = widget.taskPlanned.nameTaskPlanned;

      deletedTaskPlannedNotifier.value = widget.taskPlanned.deleted;
      selectedRangeExtractionTaskPlanned =
          widget.taskPlanned.rangeExtractionTaskPlanned;

      planningTime = widget.taskPlanned.timePlanTaskPlanned;

      if (planningTime != null) {
        timePlanTaskPlannedController.text =
            '${planningTime!.hour.toString().padLeft(2, '0')}:${planningTime!.minute.toString().padLeft(2, '0')}';
      } else {
        timePlanTaskPlannedController.text = '';
      }

      selectedExportModeTaskPlanned = widget.taskPlanned.exportModeTaskPlanned;

      selectedSendModeTaskPlanned.value =
          widget.taskPlanned.sendModeTaskPlanned;

      recipientEmailTaskPlannedController.text =
          widget.taskPlanned.recipientEmailTaskPlanned ?? "";
      ftpServerTaskPlannedController.text =
          widget.taskPlanned.ftpServerTaskPlanned ?? "";
      ftpUsernameTaskPlannedController.text =
          widget.taskPlanned.ftpServerTaskPlanned ?? "";
      ftpPasswordTaskPlannedController.text =
          widget.taskPlanned.ftpPasswordTaskPlanned ?? "";
      deletedTaskPlannedNotifier.value = widget.taskPlanned.deleted;
      tempDeleted = deletedTaskPlannedNotifier.value;
    } else {}
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    isEdit = widget.taskPlanned.idTaskPlanned != 0;
    getAvailableCommonTask();
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

    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    TaskPlannedNotifier taskPlannedNotifier =
        Provider.of<TaskPlannedNotifier>(context);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            isEdit
                ? 'Modifica procedura pianificata: ${widget.taskPlanned.nameTaskPlanned}'
                : 'Nuova procedura pianificata',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: (isLoading)
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: CustomTextFormField(
                                enabled: true,
                                controller: nameTaskPlannedController,
                                labelText: AppStrings.nameTaskPlanned,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => {},
                                //_formKey.currentState?.validate(),
                                validator: (value) {
                                  return value!.isNotEmpty
                                      ? null
                                      : AppStrings.pleaseEnterNameTaskPlanned;
                                },
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: deletedTaskPlannedNotifier,
                                  builder: (context, value, child) {
                                    return CheckboxListTile(
                                        title: Text("Archiviato"),
                                        value: value,
                                        onChanged: (bool? newValue) {
                                          if (isEdit && tempDeleted) {
                                            deletedTaskPlannedNotifier.value =
                                                newValue ?? false;
                                          }
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading);
                                  },
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: ValueListenableBuilder<TaskCommonModel?>(
                                  valueListenable: currentTaskCommonModel,
                                  builder: (context, value, _) {
                                    return CustomDropDownButtonFormField(
                                      enabled: true,
                                      actualValue: value,
                                      labelText: AppStrings.availableTaskCommon,
                                      listOfValue:
                                          availableTaskCommon.map((task) {
                                        return DropdownMenuItem<
                                            TaskCommonModel>(
                                          value: task,
                                          child: Row(
                                            children: [
                                              TaskUtils
                                                  .getIconByTaskCommonScope(
                                                      task.scopeTaskCommon),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                  child: Text(
                                                      '${task.nameTaskCommon} - ${task.descriptionTaskCommon}',
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onItemChanged: (value) {
                                        TaskCommonModel cItem =
                                            value as TaskCommonModel;
                                        currentTaskCommonModel.value = cItem;

                                        selectedRangeExtractionTaskPlanned =
                                            null;
                                        availableRangeExtractionTaskCommon =
                                            cItem.rangeExtractionTaskCommon
                                                .split(";")
                                                .where((e) => e.isNotEmpty)
                                                .toList();

                                        selectedExportModeTaskPlanned = null;
                                        availableExportModeTaskCommon = cItem
                                            .exportExtensionsTaskCommon
                                            .split(";")
                                            .where((e) => e.isNotEmpty)
                                            .toList();

                                        selectedSendModeTaskPlanned =
                                            ValueNotifier<String?>(null);
                                        availableSendModeTaskCommon = cItem
                                            .enabledSendMethodTaskCommon
                                            .split(";")
                                            .where((e) => e.isNotEmpty)
                                            .toList();
                                      },
                                      validator: (value) {
                                        if (currentTaskCommonModel.value ==
                                            null) {
                                          return AppStrings
                                              .pleaseEnterAvailableTaskCommon;
                                        } else {
                                          return null;
                                        }
                                      },
                                    );
                                  },
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomDropDownButtonFormField(
                                actualValue: selectedRangeExtractionTaskPlanned,
                                enabled: availableRangeExtractionTaskCommon
                                    .isNotEmpty,
                                labelText:
                                    AppStrings.rangeExtractionTaskPlanned,
                                listOfValue: availableRangeExtractionTaskCommon
                                    .map((rangeExtraction) {
                                  return DropdownMenuItem<String>(
                                    value: rangeExtraction,
                                    child: Row(
                                      children: [
                                        Icon(Icons.date_range_outlined),
                                        const SizedBox(width: 10),
                                        Flexible(
                                            child: Text('${rangeExtraction}',
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onItemChanged: (value) {
                                  selectedRangeExtractionTaskPlanned = value;
                                },
                                validator: (value) {
                                  print(value);
                                  if (selectedRangeExtractionTaskPlanned ==
                                      null) {
                                    return AppStrings
                                        .pleaseEnterRangeExtractionTaskPlanned;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 250,
                                    child: CustomTextFormField(
                                      enabled: false,
                                      controller: timePlanTaskPlannedController,
                                      labelText: AppStrings.timePlanTaskPlanned,
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
                                  onPressed: currentTaskCommonModel.value ==
                                          null
                                      ? null
                                      : () async {
                                          final TimeOfDay? time =
                                              await showTimePicker(
                                            cancelText: 'Annulla',
                                            confirmText: 'Conferma',
                                            helpText: 'Ora ' +
                                                widget.taskPlanned
                                                    .nameTaskPlanned,
                                            hourLabelText: 'Ore',
                                            minuteLabelText: 'Minuti',
                                            context: context,
                                            initialTime:
                                                planningTime ?? TimeOfDay.now(),
                                            initialEntryMode:
                                                TimePickerEntryMode.dial,
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  timePickerTheme:
                                                      TimePickerThemeData(
                                                    dayPeriodColor:
                                                        Colors.blue.shade100,
                                                  ),
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary:
                                                        CustomColors.darkBlue,
                                                    onSurface:
                                                        CustomColors.darkBlue,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          setState(() {
                                            planningTime = time;
                                            if (time != null) {
                                              timePlanTaskPlannedController
                                                      .text =
                                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                            } else {
                                              timePlanTaskPlannedController
                                                  .text = '';
                                            }
                                          });
                                        },
                                  icon: Icon(Icons.query_builder),
                                )
                              ],
                            ),
                          ],
                        ), // Row con AnimatedSwitcher
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomDropDownButtonFormField(
                                actualValue: selectedExportModeTaskPlanned,
                                enabled:
                                    availableExportModeTaskCommon.isNotEmpty,
                                labelText: AppStrings.exportModeTaskPlanned,
                                listOfValue: availableExportModeTaskCommon
                                    .map((exportMode) {
                                  return DropdownMenuItem<String>(
                                    value: exportMode,
                                    child: Row(
                                      children: [
                                        TaskUtils.getIconByTaskCommonExportMode(
                                            exportMode),
                                        const SizedBox(width: 10),
                                        Flexible(
                                            child: Text('${exportMode}',
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onItemChanged: (value) {
                                  selectedExportModeTaskPlanned = value;
                                },
                                validator: (value) {
                                  print(value);
                                  if (selectedExportModeTaskPlanned == null) {
                                    return AppStrings
                                        .pleaseEnterExportModeTaskPlanned;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: CustomDropDownButtonFormField(
                                  enabled: true,
                                  actualValue:
                                      selectedSendModeTaskPlanned.value,
                                  labelText: AppStrings.sendModeTaskPlanned,
                                  listOfValue: availableSendModeTaskCommon
                                      .map((sendMode) {
                                    return DropdownMenuItem<String>(
                                      value: sendMode,
                                      child: Row(
                                        children: [
                                          TaskUtils.getIconByTaskCommonSendMode(
                                              sendMode),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              child: Text('${sendMode}',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onItemChanged: (value) {
                                    String cItem = value as String;
                                    selectedSendModeTaskPlanned.value = cItem;
                                    if (value == 'email') {
                                      ftpServerTaskPlannedController.text = '';
                                      ftpUsernameTaskPlannedController.text =
                                          '';

                                      ftpPasswordTaskPlannedController.text =
                                          '';
                                    } else if (value == 'ftp') {
                                      recipientEmailTaskPlannedController.text =
                                          '';
                                    }
                                  },
                                  validator: (value) {
                                    print(value);
                                    if (selectedSendModeTaskPlanned.value ==
                                        null) {
                                      return AppStrings
                                          .pleaseEnterSendModeTaskPlanned;
                                    } else {
                                      return null;
                                    }
                                  },
                                )),
                          ],
                        ), // Row con AnimatedSwitcher
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: [
                                  ValueListenableBuilder<String?>(
                                    valueListenable:
                                        selectedSendModeTaskPlanned,
                                    builder: (context, value, _) {
                                      return AnimatedSwitcher(
                                        duration: Duration(milliseconds: 1000),
                                        child: value == "Email"
                                            ? Container(
                                                key: ValueKey(value),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          key: const ValueKey(
                                                              "Email"),
                                                          child:
                                                              CustomTextFormField(
                                                            controller:
                                                                recipientEmailTaskPlannedController,
                                                            labelText: AppStrings
                                                                .recipientEmailTaskPlanned,
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            validator: (value) {
                                                              return (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) &&
                                                                      selectedSendModeTaskPlanned
                                                                              .value ==
                                                                          "email"
                                                                  ? AppStrings
                                                                      .pleaseEnterRecipientEmailTaskPlanned
                                                                  : EmailValidator
                                                                          .areValidEmails(
                                                                              value!)
                                                                      ? null
                                                                      : AppStrings
                                                                          .invalidEmailAddress;
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : value == "Ftp"
                                                ? Container(
                                                    key: ValueKey(value),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  CustomTextFormField(
                                                                controller:
                                                                    ftpServerTaskPlannedController,
                                                                labelText:
                                                                    AppStrings
                                                                        .ftpServerTaskPlanned,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                validator: (value) => (value !=
                                                                            null &&
                                                                        value
                                                                            .isNotEmpty &&
                                                                        selectedSendModeTaskPlanned.value ==
                                                                            "Ftp")
                                                                    ? null
                                                                    : AppStrings
                                                                        .pleaseEnterFtpServerTaskPlanned,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 16),
                                                            Expanded(
                                                              child:
                                                                  CustomTextFormField(
                                                                controller:
                                                                    ftpUsernameTaskPlannedController,
                                                                labelText:
                                                                    AppStrings
                                                                        .ftpUsernameTaskPlanned,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                validator: (value) => (value !=
                                                                            null &&
                                                                        value
                                                                            .isNotEmpty &&
                                                                        selectedSendModeTaskPlanned.value ==
                                                                            "Ftp")
                                                                    ? null
                                                                    : AppStrings
                                                                        .pleaseEnterFtpUsernameTaskPlanned,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 16),
                                                            Expanded(
                                                              child:
                                                                  CustomTextFormField(
                                                                obscureText:
                                                                    true,
                                                                controller:
                                                                    ftpPasswordTaskPlannedController,
                                                                labelText:
                                                                    AppStrings
                                                                        .ftpPasswordTaskPlanned,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                validator: (value) => (value!
                                                                            .isNotEmpty &&
                                                                        selectedSendModeTaskPlanned.value ==
                                                                            "Ftp")
                                                                    ? null
                                                                    : AppStrings
                                                                        .pleaseEnterFtpPassword,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
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

                  TaskPlannedModel taskPlannedModel = TaskPlannedModel(
                    idTaskPlanned: widget.taskPlanned.idTaskPlanned,
                    nameTaskPlanned: nameTaskPlannedController.text,
                    idTaskCommon: currentTaskCommonModel.value!.idTaskCommon,
                    idInstitution: cUserAppInstitutionModel
                        .idInstitutionNavigation.idInstitution,
                    rangeExtractionTaskPlanned:
                        selectedRangeExtractionTaskPlanned!,
                    timePlanTaskPlanned: planningTime,
                    exportModeTaskPlanned: selectedExportModeTaskPlanned!,
                    sendModeTaskPlanned: selectedSendModeTaskPlanned.value!,
                    recipientEmailTaskPlanned:
                        recipientEmailTaskPlannedController.text,
                    ftpServerTaskPlanned: ftpServerTaskPlannedController.text,
                    ftpUsernameTaskPlanned:
                        ftpUsernameTaskPlannedController.text,
                    ftpPasswordTaskPlanned:
                        ftpPasswordTaskPlannedController.text,
                    deleted: deletedTaskPlannedNotifier.value,
                    idUserAppInstitution:
                        cUserAppInstitutionModel.idUserAppInstitution,
                  );

                  taskPlannedNotifier
                      .addOrUpdateTaskPlanned(
                          context: context,
                          token: authenticationNotifier.token,
                          taskPlannedModel: taskPlannedModel)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Procedure pianificate",
                              message: "Informazioni aggiornate",
                              contentType: "success"));
                      UIBlock.unblock(context);
                      Navigator.of(context).pop();
                      taskPlannedNotifier.refresh();
                    } else {
                      UIBlock.unblock(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Procedure pianificate",
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
                        title: "Archiviazione procedura pianificata",
                        content:
                            Text("Si desidera procedere alla archiviazione?"),
                        yesCallBack: () {
                          if (_formKey.currentState!.validate()) {
                            UIBlock.block(context);

                            TaskPlannedModel taskPlannedModel =
                                TaskPlannedModel(
                              idTaskPlanned: widget.taskPlanned.idTaskPlanned,
                              nameTaskPlanned: nameTaskPlannedController.text,
                              idTaskCommon:
                                  currentTaskCommonModel.value!.idTaskCommon,
                              idInstitution: cUserAppInstitutionModel
                                  .idInstitutionNavigation.idInstitution,
                              rangeExtractionTaskPlanned:
                                  selectedRangeExtractionTaskPlanned!,
                              timePlanTaskPlanned: planningTime,
                              exportModeTaskPlanned:
                                  selectedExportModeTaskPlanned!,
                              sendModeTaskPlanned:
                                  selectedSendModeTaskPlanned.value!,
                              recipientEmailTaskPlanned:
                                  recipientEmailTaskPlannedController.text,
                              ftpServerTaskPlanned:
                                  ftpServerTaskPlannedController.text,
                              ftpUsernameTaskPlanned:
                                  ftpUsernameTaskPlannedController.text,
                              ftpPasswordTaskPlanned:
                                  ftpPasswordTaskPlannedController.text,
                              deleted: true,
                              idUserAppInstitution:
                                  cUserAppInstitutionModel.idUserAppInstitution,
                            );

                            taskPlannedNotifier
                                .addOrUpdateTaskPlanned(
                                    context: context,
                                    token: authenticationNotifier.token,
                                    taskPlannedModel: taskPlannedModel)
                                .then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Procedure pianificate",
                                        message: "Informazioni aggiornate",
                                        contentType: "success"));
                                UIBlock.unblock(context);
                                Navigator.of(context).pop();
                                taskPlannedNotifier.refresh();
                              } else {
                                UIBlock.unblock(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Procedure pianificate",
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
