import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/core/models/task.common.model.dart';

class TaskPlannedModel {
  TaskPlannedModel(
      {required this.idTaskPlanned,
      required this.nameTaskPlanned,
      required this.idTaskCommon,
      required this.idInstitution,
      required this.rangeExtractionTaskPlanned,
      required this.timePlanTaskPlanned,
      required this.exportModeTaskPlanned,
      required this.sendModeTaskPlanned,
      this.recipientEmailTaskPlanned,
      this.ftpServerTaskPlanned,
      this.ftpUsernameTaskPlanned,
      this.ftpPasswordTaskPlanned,
      required this.deleted,
      this.dateIns,
      this.idUserAppInstitutionIns,
      this.dateMod,
      this.idUserAppInstitutionMod,
      this.idUserAppInstitution,
      this.idTaskCommonNavigation});

  late final int idTaskPlanned;
  late final String nameTaskPlanned;
  late final int idTaskCommon;
  late final int idInstitution;
  late final String rangeExtractionTaskPlanned;
  late final TimeOfDay? timePlanTaskPlanned;
  late final String exportModeTaskPlanned;
  late final String sendModeTaskPlanned;
  late final String? recipientEmailTaskPlanned;
  late final String? ftpServerTaskPlanned;
  late final String? ftpUsernameTaskPlanned;
  late final String? ftpPasswordTaskPlanned;
  late final bool deleted;
  DateTime? dateIns;
  int? idUserAppInstitutionIns;
  DateTime? dateMod;
  int? idUserAppInstitutionMod;
  int? idUserAppInstitution;
  TaskCommonModel? idTaskCommonNavigation;

  TaskPlannedModel.empty() {
    idTaskPlanned = 0;
    nameTaskPlanned = '';
    idTaskCommon = 0;
    idInstitution = 0;
    rangeExtractionTaskPlanned = '';
    timePlanTaskPlanned = null;
    exportModeTaskPlanned = '';
    sendModeTaskPlanned = '';
    recipientEmailTaskPlanned = null;
    ftpServerTaskPlanned = null;
    ftpUsernameTaskPlanned = null;
    ftpPasswordTaskPlanned = null;
    deleted = false;
    dateIns = null;
    idUserAppInstitutionIns = null;
    dateMod = null;
    idUserAppInstitutionMod = null;
    idUserAppInstitution = null;
    idTaskCommonNavigation = TaskCommonModel.empty();
  }

  TaskPlannedModel.fromJson(Map<String, dynamic> json) {
    idTaskPlanned = json['idTaskPlanned'];
    nameTaskPlanned = json['nameTaskPlanned'];
    idTaskCommon = json['idTaskCommon'];
    idInstitution = json['idInstitution'];
    rangeExtractionTaskPlanned = json['rangeExtractionTaskPlanned'];

    String? timeString = json['timePlanTaskPlanned'];

    if (timeString != null && timeString.contains(':')) {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      final rebuildDate = DateTime.utc(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      var localRebuildDate = rebuildDate.toLocal();

      timePlanTaskPlanned = TimeOfDay(
          hour: localRebuildDate.hour, minute: localRebuildDate.minute);
    }
    exportModeTaskPlanned = json['exportModeTaskPlanned'];
    sendModeTaskPlanned = json['sendModeTaskPlanned'];
    if (json['recipientEmailTaskPlanned'] != null) {
      recipientEmailTaskPlanned = json['recipientEmailTaskPlanned'];
    }
    if (json['ftpServerTaskPlanned'] != null) {
      ftpServerTaskPlanned = json['ftpServerTaskPlanned'];
    }
    if (json['ftpUsernameTaskPlanned'] != null) {
      ftpUsernameTaskPlanned = json['ftpUsernameTaskPlanned'];
    }
    if (json['ftpPasswordTaskPlanned'] != null) {
      ftpPasswordTaskPlanned = json['ftpPasswordTaskPlanned'];
    }
    deleted = json['deleted'];

    var dateTimeC =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateIns'], true);
    var dateLocalC = dateTimeC.toLocal();
    dateIns = dateLocalC;
    idUserAppInstitutionIns = json['idUserAppInstitutionIns'];

    if (json['dateMod'] != null) {
      var dateTimeU =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateMod'], true);
      var dateLocalU = dateTimeU.toLocal();
      dateMod = dateLocalU;
    }
    if (json['idUserAppInstitutionMod'] != null) {
      idUserAppInstitutionMod = json['idUserAppInstitutionMod'];
    }
    idTaskCommonNavigation =
        TaskCommonModel.fromJson(json['idTaskCommonNavigation']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idTaskPlanned'] = idTaskPlanned;
    data['nameTaskPlanned'] = nameTaskPlanned;
    data['idTaskCommon'] = idTaskCommon;
    data['idInstitution'] = idInstitution;
    data['rangeExtractionTaskPlanned'] = rangeExtractionTaskPlanned;
    data['timePlanTaskPlanned'] = timePlanTaskPlanned != null
        ? '${timePlanTaskPlanned!.hour.toString().padLeft(2, '0')}:${timePlanTaskPlanned!.minute.toString().padLeft(2, '0')}'
        : null;
    data['exportModeTaskPlanned'] = exportModeTaskPlanned;
    data['sendModeTaskPlanned'] = sendModeTaskPlanned;
    data['recipientEmailTaskPlanned'] = recipientEmailTaskPlanned;
    data['ftpServerTaskPlanned'] = ftpServerTaskPlanned;
    data['ftpUsernameTaskPlanned'] = ftpUsernameTaskPlanned;
    data['ftpPasswordTaskPlanned'] = ftpPasswordTaskPlanned;
    data['deleted'] = deleted;
    data['idUserAppInstitution'] = idUserAppInstitution;

    return data;
  }
}
