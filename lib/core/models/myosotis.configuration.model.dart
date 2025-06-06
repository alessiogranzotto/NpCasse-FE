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

import 'package:np_casse/core/models/comunication.sending.model.dart';

class MyosotisConfigurationModel {
  MyosotisConfigurationModel({
    required this.idMyosotisConfiguration,
    required this.nameMyosotisConfiguration, // Include this in the constructor
    required this.descriptionMyosotisConfiguration,
    required this.archived,
    required this.idUserAppInstitution,
    required this.idInstitution,
    required this.enabledDeviceMyosotisConfiguration,
    required this.enabledUrlMyosotisConfiguration,
    required this.myosotisConfigurationDetailModel,
  });
  late final int idMyosotisConfiguration;
  late final String nameMyosotisConfiguration;
  late final String descriptionMyosotisConfiguration;
  late final bool archived;
  late final int idUserAppInstitution;
  late final int idInstitution;
  late final List<String> enabledDeviceMyosotisConfiguration;
  late final List<String> enabledUrlMyosotisConfiguration;
  late final MyosotisConfigurationDetailModel myosotisConfigurationDetailModel;

  MyosotisConfigurationModel.empty() {
    idMyosotisConfiguration = 0;
    nameMyosotisConfiguration = '';
    descriptionMyosotisConfiguration = '';
    archived = false;
    enabledUrlMyosotisConfiguration = List.empty();
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

    if (json['enabledUrlMyosotisConfigurations'] != null) {
      var t = List.from(json['enabledUrlMyosotisConfigurations'])
          .map((e) => EnabledUrlMyosotisConfiguration.fromJson(e))
          .toList();
      enabledUrlMyosotisConfiguration =
          t.map((data) => data.valueUrlMyosotisConfiguration).toList();
    } else {
      enabledUrlMyosotisConfiguration = List.empty();
    }

    if (json['myosotisConfigurationDetail'] != null) {
      myosotisConfigurationDetailModel =
          MyosotisConfigurationDetailModel.fromJson(
              json['myosotisConfigurationDetail']);
    } else {
      myosotisConfigurationDetailModel =
          MyosotisConfigurationDetailModel.empty();
    }
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
    data['enabledUrlMyosotisConfiguration'] = enabledUrlMyosotisConfiguration;
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
      required this.causalDonationText,
      required this.idFormGive,
      required this.idSubCategoryCausalDonation,
      required this.idGiveFromProjectOrFixedValue,
      required this.customIdGive,
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
      required this.preestablishedPaymentMethodWeb,
      required this.thankYouMethod,
      required this.idTransactionalSending,
      required this.idWaMessageToSend});
  late String typeFormStartup;
  late bool showLogo;
  late String logoEncoded;
  late String bigImageString;
  late String smallImageString;
  late String title;
  late String subtitle;
  late List<String> preestablishedAmount;
  late bool showFreePrice;
  //
  late String idGiveFromProjectOrFixedValue;
  late List<String> customIdGive;
  //
  late String causalDonationText;
  late int idFormGive;
  late int idSubCategoryCausalDonation;
  late List<ProductCausalDonation> productCausalDonation;
  late bool showPrivacy;
  late String textPrivacy;
  late bool isMandatoryPrivacy;
  late bool showNewsletter;
  late String textNewsletter;
  late bool isMandatoryNewsletter;
  late List<String> visiblePersonalFormField;
  late List<String> mandatoryPersonalFormField;
  late bool showCompanyForm;
  late List<String> visibleCompanyFormField;
  late List<String> mandatoryCompanyFormField;
  late List<String> preestablishedPaymentMethodApp;
  late List<String> preestablishedPaymentMethodWeb;

  late String thankYouMethod;
  late int idTransactionalSending;
  late int idWaMessageToSend;

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
    idGiveFromProjectOrFixedValue = "";
    customIdGive = [];
    causalDonationText = '';
    idFormGive = 0;
    idSubCategoryCausalDonation = 0;
    productCausalDonation = [];
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
    thankYouMethod = "";
    idTransactionalSending = 0;
    idWaMessageToSend = 0;
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

    idGiveFromProjectOrFixedValue = json['idGiveFromProjectOrFixedValue'];
    if (json['customIdGive'] != null) {
      // customIdGive = List.from(json['customIdGive']);
      customIdGive = (json['customIdGive'] as List<dynamic>)
          .map((item) =>
              '${item['customIdGiveName']}=${item['customIdGiveValue']}')
          .toList();
    } else {
      customIdGive = List.empty();
    }
    causalDonationText = json['causalDonationText'];
    idFormGive = json['idFormGive'];
    idSubCategoryCausalDonation = json['idSubCategoryCausalDonation'];

    if (json['productCausalDonation'] != null) {
      productCausalDonation = List.from(json['productCausalDonation'])
          .map((e) => ProductCausalDonation.fromJson(e))
          .toList();
    } else {
      productCausalDonation = List.empty();
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
    if (json['thankYouMethod'] != null) {
      thankYouMethod = json['thankYouMethod'];
    } else {
      thankYouMethod = 'Nessun ringraziamento';
    }
    if (json['idTransactionalSending'] != null) {
      idTransactionalSending = json['idTransactionalSending'];
    } else {
      idTransactionalSending = 0;
    }
    if (json['idWAMessageToSend'] != null) {
      idWaMessageToSend = json['idWAMessageToSend'];
    } else {
      idWaMessageToSend = 0;
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

    data['causalDonationText'] = causalDonationText;
    data['idFormGive'] = idFormGive;
    data['idSubCategoryCausalDonation'] = idSubCategoryCausalDonation;

    data['idGiveFromProjectOrFixedValue'] = idGiveFromProjectOrFixedValue;
    data['customIdGive'] = customIdGive;

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

    data['thankYouMethod'] = thankYouMethod;
    data['idTransactionalSending'] = idTransactionalSending;
    data['idWaMessageToSend'] = idWaMessageToSend;

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
    required this.availableThankYouMethod,
    required this.availableTransactionalSending,
  });
  late final List<String> availableFormStartup;
  late final List<String> availablePaymentMethodApp;
  late final List<String> availablePaymentMethodWeb;
  late final List<String> availablePersonalFormField;
  late final List<String> availableCompanyFormField;
  late final List<SubCategoryShort> availableSubCategoryCausalDonation;
  late final List<String> availableThankYouMethod;
  late final List<TransactionalSendingShort> availableTransactionalSending;

  MyosotisConfigurationDetailEmpty.empty() {
    availableFormStartup = [];
    availablePaymentMethodApp = [];
    availablePaymentMethodWeb = [];
    availablePersonalFormField = [];
    availableCompanyFormField = [];
    availableSubCategoryCausalDonation = [];
    availableThankYouMethod = [];
    availableTransactionalSending = [];
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

    availableThankYouMethod = List.from(json['availableThankYouMethod']);

    availableTransactionalSending =
        List.from(json['availableTransactionalSending'])
            .map((e) => TransactionalSendingShort.fromJson(e))
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

class TransactionalSendingShort {
  TransactionalSendingShort(
      {required this.idTransactionalSending,
      required this.nameTransactionalSending});
  late final int idTransactionalSending;
  late final String nameTransactionalSending;

  TransactionalSendingShort.empty() {
    idTransactionalSending = 0;
    nameTransactionalSending = '';
  }

  // JSON deserialization
  TransactionalSendingShort.fromJson(Map<String, dynamic> json) {
    idTransactionalSending = json['idTransactionalSending'];
    nameTransactionalSending = json['nameTransactionalSending'];
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

class EnabledUrlMyosotisConfiguration {
  EnabledUrlMyosotisConfiguration(
      {required this.valueUrlMyosotisConfiguration});
  late final String valueUrlMyosotisConfiguration;

  // JSON deserialization
  EnabledUrlMyosotisConfiguration.fromJson(Map<String, dynamic> json) {
    valueUrlMyosotisConfiguration = json['valueUrlMyosotisConfiguration'];
  }
}

class ProductCausalDonation {
  ProductCausalDonation({
    required this.idProduct,
    required this.nameProduct,
    required this.priceProduct,
    required this.freePriceProduct,
  });
  late final int idProduct;
  late final String nameProduct;
  late final double priceProduct;
  late final bool freePriceProduct;

  ProductCausalDonation.empty() {
    idProduct = 0;
    nameProduct = '';
    priceProduct = 0;
    freePriceProduct = false;
  }

  // JSON deserialization
  ProductCausalDonation.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    priceProduct = json['priceProduct'];
    freePriceProduct = json['freePriceProduct'];
  }
}
