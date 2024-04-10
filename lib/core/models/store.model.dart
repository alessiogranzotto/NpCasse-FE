import 'package:np_casse/core/models/give.id.flat.structure.model.dart';

class StoreModel {
  StoreModel(
      {required this.idStore,
      required this.idProject,
      required this.nameStore,
      required this.descriptionStore,
      required this.imageStore,
      required this.giveIdsFlatStructureModel});
  late final int idStore;
  late final int idProject;
  late final String nameStore;
  late final String descriptionStore;
  late final String imageStore;
  late final GiveIdsFlatStructureModel giveIdsFlatStructureModel;

  StoreModel.empty() {
    idStore = 0;
    idProject = 0;
    nameStore = '';
    descriptionStore = "";
    imageStore = "";
    giveIdsFlatStructureModel = GiveIdsFlatStructureModel.empty();
  }

  StoreModel.fromJson(Map<String, dynamic> json) {
    idStore = json['idStore'];
    idProject = json['idProject'];
    nameStore = json['nameStore'];
    descriptionStore = json['descriptionStore'];
    imageStore = json['imageStore'];
    giveIdsFlatStructureModel =
        GiveIdsFlatStructureModel.fromJson(json['giveIdsFlatStructure']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idStore'] = idStore;
    data['idProject'] = idProject;
    data['nameStore'] = nameStore;
    data['descriptionStore'] = descriptionStore;
    data['imageStore'] = imageStore;
    data['giveIdsFlatStructure'] = giveIdsFlatStructureModel.toJson();
    return data;
  }
}
