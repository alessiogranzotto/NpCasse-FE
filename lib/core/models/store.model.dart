class StoreModel {
  StoreModel({
    required this.idStore,
    required this.idProject,
    required this.nameStore,
    required this.descriptionStore,
    required this.imageStore,
    this.isWishlisted = false,
  });
  late final int idStore;
  late final int idProject;
  late final String nameStore;
  late final String descriptionStore;
  late final String imageStore;
  late bool isWishlisted = false;

  StoreModel.empty() {
    idStore = 0;
    idProject = 0;
    nameStore = '';
    descriptionStore = "";
    imageStore = "";
  }

  StoreModel.fromJson(Map<String, dynamic> json) {
    idStore = json['idStore'];
    idProject = json['idProject'];
    nameStore = json['nameStore'];
    descriptionStore = json['descriptionStore'];
    imageStore = json['imageStore'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idStore'] = idStore;
    data['idProject'] = idProject;
    data['nameStore'] = nameStore;
    data['descriptionStore'] = descriptionStore;
    data['imageStore'] = imageStore;
    return data;
  }
}
