class ProjectGrantStructureModel {
  ProjectGrantStructureModel(
      {required this.idProjectGrant,
      required this.idProject,
      required this.idUserAppInstitution,
      required this.operationRead,
      required this.operationEdit,
      required this.idUser,
      required this.nameUser,
      required this.surnameUser,
      required this.emailUser});

  late final int idProjectGrant;
  late final int idProject;
  late final int idUserAppInstitution;
  late final bool operationRead;
  late final bool operationEdit;
  late final int idUser;
  late final String nameUser;
  late final String surnameUser;
  late final String emailUser;

  ProjectGrantStructureModel.fromJson(Map<String, dynamic> json) {
    idProjectGrant = json['idProjectGrant'];
    idProject = json['idProject'];
    idUserAppInstitution = json['idUserAppInstitution'];
    operationRead = json['operationRead'];
    operationEdit = json['operationEdit'];
    idUser = json['idUser'];
    nameUser = json['nameUser'];
    surnameUser = json['surnameUser'];
    emailUser = json['emailUser'];
  }
}
