import 'package:flutter/foundation.dart';

class ProjectModel {
  ProjectModel(
      {required this.idProject,
      required this.idUserAppInstitution,
      required this.nameProject,
      required this.descriptionProject,
      required this.imageProject});
  late int idProject;
  late int idUserAppInstitution;
  late String nameProject;
  late String descriptionProject;
  late String imageProject;

  ProjectModel.empty() {
    idProject = 0;
    idUserAppInstitution = 0;
    nameProject = "";
    descriptionProject = "";
    imageProject = "";
  }
  ProjectModel.fromJson(Map<String, dynamic> json) {
    idProject = json['idProject'];
    idUserAppInstitution = json['idUserAppInstitution'];
    nameProject = json['nameProject'];
    descriptionProject = json['descriptionProject'];
    imageProject = json['imageProject'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProject'] = idProject;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['nameProject'] = nameProject;
    data['descriptionProject'] = descriptionProject;
    data['imageProject'] = imageProject;
    return data;
  }
}
