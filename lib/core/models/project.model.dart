import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/project.grant.structure.model.dart';

class ProjectModel {
  ProjectModel(
      {required this.idProject,
      required this.idUserAppInstitution,
      required this.nameProject,
      required this.descriptionProject,
      required this.imageProject,
      required this.giveIdsFlatStructureModel});
  late final int idProject;
  late final int idUserAppInstitution;
  late final String nameProject;
  late final String descriptionProject;
  late final String imageProject;
  late final GiveIdsFlatStructureModel giveIdsFlatStructureModel;
  late final List<ProjectGrantStructureModel> projectGrantStructure;

  ProjectModel.empty() {
    idProject = 0;
    idUserAppInstitution = 0;
    nameProject = "";
    descriptionProject = "";
    imageProject = "";
    giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
    projectGrantStructure = List.empty();
  }
  ProjectModel.fromJson(Map<String, dynamic> json) {
    idProject = json['idProject'];
    idUserAppInstitution = json['idUserAppInstitution'];
    nameProject = json['nameProject'];
    descriptionProject = json['descriptionProject'];
    imageProject = json['imageProject'];
    giveIdsFlatStructureModel =
        GiveIdsFlatStructureModel.fromJson(json['giveIdsFlatStructure']);
    if (json['projectGrantStructure'] != null) {
      projectGrantStructure = List.from(json['projectGrantStructure'])
          .map((e) => ProjectGrantStructureModel.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idProject'] = idProject;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['nameProject'] = nameProject;
    data['descriptionProject'] = descriptionProject;
    data['imageProject'] = imageProject;
    data['giveIdsFlatStructure'] = giveIdsFlatStructureModel.toJson();
    return data;
  }
}
