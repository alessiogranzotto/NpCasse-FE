// class MyosotisConfigurationModelData {
//   MyosotisConfigurationModelData({
//     required this.myosotisConfigurationDetailEmpty,
//     this.myosotisConfigurationModelList,
//   });
//   late final MyosotisConfigurationDetailEmpty myosotisConfigurationDetailEmpty;
//   late final List<MyosotisConfigurationModel>? myosotisConfigurationModelList;

//   // JSON deserialization
//   MyosotisConfigurationModelData.fromJson(Map<String, dynamic> json) {
//     myosotisConfigurationDetailEmpty =
//         MyosotisConfigurationDetailEmpty.fromJson(
//             json['myosotisConfigurationDetailEmpty']);
//     myosotisConfigurationModelList =
//         List.from(json['myosotisConfigurationModel'])
//             .map((e) => MyosotisConfigurationModel.fromJson(e))
//             .toList();
//   }

//   // JSON serialization
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['myosotisConfigurationDetailEmpty'] = myosotisConfigurationDetailEmpty;
//     data['myosotisConfigurationModelList'] = myosotisConfigurationModelList;
//     return data;
//   }
// }

class MyosotisConfigurationModel {
  MyosotisConfigurationModel({
    required this.idMyosotisConfiguration,
    required this.nameMyosotisConfiguration, // Include this in the constructor
    required this.descriptionMyosotisConfiguration,
    required this.archived,
    required this.idUserAppInstitution,
    required this.idInstitution,
    required this.enabledDeviceMyosotisConfiguration,
    required this.myosotisConfigurationDetailModel,
  });
  late final int idMyosotisConfiguration;
  late final String nameMyosotisConfiguration;
  late final String descriptionMyosotisConfiguration;
  late final bool archived;
  late final int idUserAppInstitution;
  late final int idInstitution;
  late final List<String> enabledDeviceMyosotisConfiguration;
  late final MyosotisConfigurationDetailModel myosotisConfigurationDetailModel;

  MyosotisConfigurationModel.empty() {
    idMyosotisConfiguration = 0;
    nameMyosotisConfiguration = '';
    descriptionMyosotisConfiguration = '';
    archived = false;
    enabledDeviceMyosotisConfiguration = List.empty();
    idUserAppInstitution = 0;
    idInstitution = 0;
    myosotisConfigurationDetailModel = MyosotisConfigurationDetailModel.empty();
  }

  // JSON deserialization
  MyosotisConfigurationModel.fromJson(Map<String, dynamic> json) {
    idMyosotisConfiguration = json['idMyosotisConfiguration'];
    nameMyosotisConfiguration = json['nameMyosotisConfiguration'];
    descriptionMyosotisConfiguration = json['descriptionMyosotisConfiguration'];
    idInstitution = json['idInstitution'];

    archived = json['archived'];
    idUserAppInstitution = json['idUserAppInstitution'] ?? 0; // Handle null

    if (json['enabledDeviceMyosotisConfigurations'] != null) {
      var t = List.from(json['enabledDeviceMyosotisConfigurations'])
          .map((e) => EnabledDeviceMyosotisConfiguration.fromJson(e))
          .toList();
      enabledDeviceMyosotisConfiguration =
          t.map((data) => data.valueDeviceMyosotisConfiguration).toList();
    } else {
      enabledDeviceMyosotisConfiguration = List.empty();
    }

    myosotisConfigurationDetailModel =
        MyosotisConfigurationDetailModel.fromJson(
            json['myosotisConfigurationDetail']);
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idMyosotisConfiguration'] = idMyosotisConfiguration;
    data['nameMyosotisConfiguration'] = nameMyosotisConfiguration;
    data['descriptionMyosotisConfiguration'] = descriptionMyosotisConfiguration;
    data['idInstitution'] = idInstitution;
    data['enabledDeviceMyosotisConfiguration'] =
        enabledDeviceMyosotisConfiguration;
    data['archived'] = archived;
    data['idUserAppInstitution'] = idUserAppInstitution;
    data['myosotisConfigurationDetailRequest'] =
        myosotisConfigurationDetailModel.toJson();

    return data;
  }
}

class MyosotisConfigurationDetailModel {
  MyosotisConfigurationDetailModel(
      {required this.typeFormStartup,
      required this.showLogo,
      required this.bigImageString,
      required this.smallImageString,
      required this.title,
      required this.subtitle,
      required this.preestablishedAmount,
      required this.showFreePrice,
      required this.showCausalDonation,
      required this.causalDonationText,
      required this.idSubCategoryCausalDonation,
      required this.showPrivacy,
      required this.textPrivacy,
      required this.isMandatoryPrivacy,
      required this.showNewsletter,
      required this.textNewsletter,
      required this.isMandatoryNewsletter,
      required this.visiblePersonalFormField,
      required this.mandatoryPersonalFormField,
      required this.showCompanyForm,
      required this.visibleCompanyFormField,
      required this.mandatoryCompanyFormField,
      required this.preestablishedPaymentMethodApp,
      required this.preestablishedPaymentMethodWeb});
  late final String typeFormStartup;
  late final bool showLogo;
  late final String logoEncoded;
  late final String bigImageString;
  late final String smallImageString;
  late final String title;
  late final String subtitle;
  late final List<String> preestablishedAmount;
  late final bool showFreePrice;
  late final bool showCausalDonation;
  late final String causalDonationText;
  late final int idSubCategoryCausalDonation;
  late final List<String> subCategoryCausalDonation;
  late final bool showPrivacy;
  late final String textPrivacy;
  late final bool isMandatoryPrivacy;
  late final bool showNewsletter;
  late final String textNewsletter;
  late final bool isMandatoryNewsletter;
  late final List<String> visiblePersonalFormField;
  late final List<String> mandatoryPersonalFormField;
  late final bool showCompanyForm;
  late final List<String> visibleCompanyFormField;
  late final List<String> mandatoryCompanyFormField;
  late final List<String> preestablishedPaymentMethodApp;
  late final List<String> preestablishedPaymentMethodWeb;

  MyosotisConfigurationDetailModel.empty() {
    typeFormStartup = "";
    showLogo = false;
    logoEncoded = "";
    bigImageString = "";
    smallImageString = "";
    title = "";
    subtitle = "";
    preestablishedAmount = [];
    showFreePrice = false;
    showCausalDonation = false;
    causalDonationText = '';
    idSubCategoryCausalDonation = 0;
    subCategoryCausalDonation = [];
    showPrivacy = false;
    textPrivacy = '';
    isMandatoryPrivacy = false;

    showNewsletter = false;
    textNewsletter = '';
    isMandatoryNewsletter = false;

    visiblePersonalFormField = [];
    mandatoryPersonalFormField = [];
    showCompanyForm = false;
    visibleCompanyFormField = [];
    mandatoryCompanyFormField = [];
    preestablishedPaymentMethodApp = [];
    preestablishedPaymentMethodWeb = [];
  }
  // JSON deserialization
  MyosotisConfigurationDetailModel.fromJson(Map<String, dynamic> json) {
    typeFormStartup = json['typeFormStartup'];
    showLogo = json['showLogo'];
    logoEncoded = json['logoEncoded'] ?? '';
    bigImageString = json['bigImageString'];
    smallImageString = json['smallImageString'];
    title = json['title'];
    subtitle = json['subtitle'];

    if (json['preestablishedAmount'] != null) {
      preestablishedAmount = List.from(json['preestablishedAmount']);
    } else {
      preestablishedAmount = List.empty();
    }
    showFreePrice = json['showFreePrice'];

    showCausalDonation = json['showCausalDonation'];
    causalDonationText = json['causalDonationText'];
    idSubCategoryCausalDonation = json['idSubCategoryCausalDonation'];

    if (json['subCategoryCausalDonation'] != null) {
      subCategoryCausalDonation = List.from(json['subCategoryCausalDonation']);
    } else {
      subCategoryCausalDonation = List.empty();
    }

    showPrivacy = json['showPrivacy'];
    textPrivacy = json['textPrivacy'];
    isMandatoryPrivacy = json['isMandatoryPrivacy'];
    showNewsletter = json['showNewsletter'];
    textNewsletter = json['textNewsletter'];
    isMandatoryNewsletter = json['isMandatoryNewsletter'];

    if (json['visiblePersonalFormField'] != null) {
      visiblePersonalFormField = List.from(json['visiblePersonalFormField']);
    } else {
      preestablishedAmount = List.empty();
    }
    if (json['mandatoryPersonalFormField'] != null) {
      mandatoryPersonalFormField =
          List.from(json['mandatoryPersonalFormField']);
    } else {
      mandatoryPersonalFormField = List.empty();
    }

    showCompanyForm = json['showCompanyForm'];
    if (json['visibleCompanyFormField'] != null) {
      visibleCompanyFormField = List.from(json['visibleCompanyFormField']);
    } else {
      preestablishedAmount = List.empty();
    }
    if (json['mandatoryCompanyFormField'] != null) {
      mandatoryCompanyFormField = List.from(json['mandatoryCompanyFormField']);
    } else {
      mandatoryCompanyFormField = List.empty();
    }

    if (json['preestablishedPaymentMethodApp'] != null) {
      preestablishedPaymentMethodApp =
          List.from(json['preestablishedPaymentMethodApp']);
    } else {
      preestablishedPaymentMethodApp = List.empty();
    }
    if (json['preestablishedPaymentMethodWeb'] != null) {
      preestablishedPaymentMethodWeb =
          List.from(json['preestablishedPaymentMethodWeb']);
    } else {
      preestablishedPaymentMethodWeb = List.empty();
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['typeFormStartup'] = typeFormStartup;
    data['showLogo'] = showLogo;
    data['bigImageString'] = bigImageString;
    data['smallImageString'] = smallImageString;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['preestablishedAmount'] = preestablishedAmount;
    data['showFreePrice'] = showFreePrice;

    data['showCausalDonation'] = showCausalDonation;
    data['causalDonationText'] = causalDonationText;
    data['idSubCategoryCausalDonation'] = idSubCategoryCausalDonation;

    data['showPrivacy'] = showPrivacy;
    data['textPrivacy'] = textPrivacy;
    data['isMandatoryPrivacy'] = isMandatoryPrivacy;
    data['showNewsletter'] = showNewsletter;
    data['textNewsletter'] = textNewsletter;
    data['isMandatoryNewsletter'] = isMandatoryNewsletter;
    data['visiblePersonalFormField'] = visiblePersonalFormField;
    data['mandatoryPersonalFormField'] = mandatoryPersonalFormField;
    data['showCompanyForm'] = showCompanyForm;
    data['visibleCompanyFormField'] = visibleCompanyFormField;
    data['mandatoryCompanyFormField'] = mandatoryCompanyFormField;
    data['preestablishedPaymentMethodApp'] = preestablishedPaymentMethodApp;
    data['preestablishedPaymentMethodWeb'] = preestablishedPaymentMethodWeb;

    return data;
  }
}

class MyosotisConfigurationDetailEmpty {
  MyosotisConfigurationDetailEmpty({
    required this.availableFormStartup,
    required this.availablePaymentMethodApp,
    required this.availablePaymentMethodWeb,
    required this.availablePersonalFormField,
    required this.availableCompanyFormField,
    required this.availableSubCategoryCausalDonation,
  });
  late final List<String> availableFormStartup;
  late final List<String> availablePaymentMethodApp;
  late final List<String> availablePaymentMethodWeb;
  late final List<String> availablePersonalFormField;
  late final List<String> availableCompanyFormField;
  late final List<SubCategoryShort> availableSubCategoryCausalDonation;

  MyosotisConfigurationDetailEmpty.empty() {
    availableFormStartup = [];
    availablePaymentMethodApp = [];
    availablePaymentMethodWeb = [];
    availablePersonalFormField = [];
    availableCompanyFormField = [];
    availableSubCategoryCausalDonation = [];
  }

  // JSON deserialization
  MyosotisConfigurationDetailEmpty.fromJson(Map<String, dynamic> json) {
    availableFormStartup = List.from(json['availableFormStartup']);
    availablePaymentMethodApp = List.from(json['availablePaymentMethodApp']);
    availablePaymentMethodWeb = List.from(json['availablePaymentMethodWeb']);
    availablePersonalFormField = List.from(json['availablePersonalFormField']);
    availableCompanyFormField = List.from(json['availableCompanyFormField']);

    availableSubCategoryCausalDonation =
        List.from(json['availableSubCategoryCausalDonation'])
            .map((e) => SubCategoryShort.fromJson(e))
            .toList();
  }
}

class SubCategoryShort {
  SubCategoryShort(
      {required this.idSubCategory, required this.nameSubCategory});
  late final int idSubCategory;
  late final String nameSubCategory;

  SubCategoryShort.empty() {
    idSubCategory = 0;
    nameSubCategory = '';
  }

  // JSON deserialization
  SubCategoryShort.fromJson(Map<String, dynamic> json) {
    idSubCategory = json['idSubCategory'];
    nameSubCategory = json['nameSubCategory'];
  }
}

class EnabledDeviceMyosotisConfiguration {
  EnabledDeviceMyosotisConfiguration(
      {required this.valueDeviceMyosotisConfiguration});
  late final String valueDeviceMyosotisConfiguration;

  // JSON deserialization
  EnabledDeviceMyosotisConfiguration.fromJson(Map<String, dynamic> json) {
    valueDeviceMyosotisConfiguration = json['valueDeviceMyosotisConfiguration'];
  }
}
