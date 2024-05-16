class ProjectGrantStructureModel {
  ProjectGrantStructureModel(
      {required this.idProjectGrant,
      required this.idProject,
      required this.idUserAppInstitution,
      required this.roleUserAppInstitution,
      required this.operationRead,
      required this.operationEdit,
      required this.idUser,
      required this.nameUser,
      required this.surnameUser,
      required this.emailUser});

  late final int idProjectGrant;
  late final int idProject;
  late final int idUserAppInstitution;
  late final String roleUserAppInstitution;
  late bool operationRead;
  late bool operationEdit;
  late final int idUser;
  late final String nameUser;
  late final String surnameUser;
  late final String emailUser;
  ProjectGrantStructureModel.empty() {
    idProjectGrant = 0;
    idProject = 0;
    idUserAppInstitution = 0;
    operationRead = false;
    operationEdit = false;
    idUser = 0;
    nameUser = "";
    surnameUser = "";
    emailUser = "";
  }
  ProjectGrantStructureModel.fromJson(Map<String, dynamic> json) {
    idProjectGrant = json['idProjectGrant'];
    idProject = json['idProject'];
    idUserAppInstitution = json['idUserAppInstitution'];
    roleUserAppInstitution = json['roleUserAppInstitution'];
    operationRead = json['operationRead'];
    operationEdit = json['operationEdit'];
    idUser = json['idUser'];
    nameUser = json['nameUser'];
    surnameUser = json['surnameUser'];
    emailUser = json['emailUser'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProjectGrant'] = idProjectGrant;
    data['idProject'] = idProject;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['roleUserAppInstitution'] = roleUserAppInstitution;
    data['operationRead'] = operationRead;
    data['operationEdit'] = operationEdit;
    data['idUser'] = idUser;
    data['nameUser'] = nameUser;
    data['surnameUser'] = surnameUser;
    data['emailUser'] = emailUser;
    return data;
  }
}
