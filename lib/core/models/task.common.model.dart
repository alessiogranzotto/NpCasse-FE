class TaskCommonModel {
  TaskCommonModel(
      {required this.idTaskCommon,
      required this.nameTaskCommon,
      required this.descriptionTaskCommon,
      required this.scopeTaskCommon,
      required this.rangeExtractionTaskCommon,
      required this.exportExtensionsTaskCommon,
      required this.enabledSendMethodTaskCommon,
      required this.configParameterTaskCommon});

  late final int idTaskCommon;
  late final String nameTaskCommon;
  late final String descriptionTaskCommon;
  late final String scopeTaskCommon;
  late final String rangeExtractionTaskCommon;
  late final String exportExtensionsTaskCommon;
  late final String enabledSendMethodTaskCommon;
  late final String configParameterTaskCommon;

  TaskCommonModel.empty() {
    idTaskCommon = 0;
    nameTaskCommon = '';
    descriptionTaskCommon = '';
    scopeTaskCommon = '';
    rangeExtractionTaskCommon = '';
    exportExtensionsTaskCommon = '';
    enabledSendMethodTaskCommon = '';
    configParameterTaskCommon = '';
  }
  TaskCommonModel.fromJson(Map<String, dynamic> json) {
    idTaskCommon = json['idTaskCommon'];
    nameTaskCommon = json['nameTaskCommon'];
    descriptionTaskCommon = json['descriptionTaskCommon'];
    scopeTaskCommon = json['scopeTaskCommon'];
    rangeExtractionTaskCommon = json['rangeExtractionTaskCommon'];
    exportExtensionsTaskCommon = json['exportExtensionsTaskCommon'];
    enabledSendMethodTaskCommon = json['enabledSendMethodTaskCommon'];
    configParameterTaskCommon = json['configParameterTaskCommon'];
  }
}
