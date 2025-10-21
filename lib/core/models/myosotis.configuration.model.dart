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

import 'package:flutter/material.dart';

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
    // idUserAppInstitution = json['idUserAppInstitution'] ?? 0; // Handle null

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
      required this.buttonColor,
      required this.formFont,
      required this.showLogo,
      required this.bigImageString,
      required this.smallImageString,
      required this.title,
      required this.subtitle,
      required this.showPreestablishedAmount,
      required this.preestablishedAmount,
      required this.showFreePrice,
      required this.showContinuousDonation,
      required this.frequencyContinuousDonation,
      required this.setContinuousDonationAsPredefined,
      required this.buttonNoAmountsText,
      required this.causalDonationText,
      required this.idFormGive,
      required this.idSubCategoryCausalDonation,
      required this.idGiveFromProjectOrFixedValue,
      required this.customIdGive,
      required this.showCausalBeforeAmount,
      required this.showPrivacy,
      required this.textPrivacy,
      required this.urlPrivacy,
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
      required this.paymentManager,
      required this.thankYouMethod,
      required this.idTransactionalSending,
      required this.waTemplateName,
      required this.tyEndMessage,
      required this.optionalField});
  late String typeFormStartup;
  late int buttonColor;
  late String formFont;
  late bool showLogo;
  late String logoEncoded;
  late String bigImageString;
  late String smallImageString;
  late String title;
  late String subtitle;
  late bool showPreestablishedAmount;
  late bool showFreePrice;
  late List<String> preestablishedAmount;
  late bool showContinuousDonation;
  late List<FrequencyContinuousDonation> frequencyContinuousDonation;
  late bool setContinuousDonationAsPredefined;
  late String buttonNoAmountsText;

  //
  late String idGiveFromProjectOrFixedValue;
  late List<String> customIdGive;
  late bool showCausalBeforeAmount;
  //
  late String causalDonationText;
  late int idFormGive;
  late int idSubCategoryCausalDonation;
  late List<ProductCausalDonation> productCausalDonation;
  late bool showPrivacy;
  late String textPrivacy;
  late String urlPrivacy;
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
  late String paymentManager;

  late String thankYouMethod;
  late int idTransactionalSending;
  late String waTemplateName;

  late String tyEndMessage;

  late List<OptionalField> optionalField;

  MyosotisConfigurationDetailModel.empty() {
    typeFormStartup = "";
    buttonColor = 0;
    formFont = "";
    showLogo = false;
    logoEncoded = "";
    bigImageString = "";
    smallImageString = "";
    title = "";
    subtitle = "";
    showPreestablishedAmount = false;
    preestablishedAmount = [];
    showFreePrice = false;
    showContinuousDonation = false;
    frequencyContinuousDonation = [];
    setContinuousDonationAsPredefined = false;
    buttonNoAmountsText = '';

    idGiveFromProjectOrFixedValue = "";
    customIdGive = [];
    showCausalBeforeAmount = false;
    causalDonationText = '';
    idFormGive = 0;
    idSubCategoryCausalDonation = 0;
    productCausalDonation = [];
    showPrivacy = false;
    textPrivacy = '';
    urlPrivacy = '';
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
    paymentManager = "";
    thankYouMethod = "";
    idTransactionalSending = 0;
    waTemplateName = "";
    tyEndMessage = "";

    optionalField = [];
  }
  // JSON deserialization
  MyosotisConfigurationDetailModel.fromJson(Map<String, dynamic> json) {
    typeFormStartup = json['typeFormStartup'];

    if (json['buttonColor'] != null) {
      buttonColor = json['buttonColor'];
    } else {
      buttonColor = Colors.red.toARGB32();
      ;
    }
    if (json['formFont'] != '') {
      formFont = json['formFont'];
    }

    showLogo = json['showLogo'] == true;
    logoEncoded = json['logoEncoded'] ?? '';
    bigImageString = json['bigImageString'];
    smallImageString = json['smallImageString'];
    title = json['title'];
    subtitle = json['subtitle'];
    showPreestablishedAmount = json['showPreestablishedAmount'] == true;

    preestablishedAmount = List.from(json['preestablishedAmount']);
    showFreePrice = json['showFreePrice'] == true;

    showContinuousDonation = json['showContinuousDonation'] == true;

    if (json['frequencyContinuousDonation'] != null) {
      frequencyContinuousDonation =
          List.from(json['frequencyContinuousDonation'])
              .map((e) => FrequencyContinuousDonation.fromJson(e))
              .toList();
    } else {
      frequencyContinuousDonation = List.empty();
    }
    buttonNoAmountsText = json['buttonNoAmountsText'];
    setContinuousDonationAsPredefined =
        json['setContinuousDonationAsPredefined'];

    idGiveFromProjectOrFixedValue = json['idGiveFromProjectOrFixedValue'];

    if (json['customIdGive'] != null) {
      customIdGive = (json['customIdGive'] as List<dynamic>)
          .map((item) =>
              '${item['customIdGiveName']}=${item['customIdGiveValue']}')
          .toList();
    } else {
      customIdGive = List.empty();
    }
    showCausalBeforeAmount = json['showCausalBeforeAmount'] == true;

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

    showPrivacy = json['showPrivacy'] == true;
    textPrivacy = json['textPrivacy'];
    urlPrivacy = json['urlPrivacy'];
    isMandatoryPrivacy = json['isMandatoryPrivacy'] == true;
    showNewsletter = json['showNewsletter'] == true;
    textNewsletter = json['textNewsletter'];
    isMandatoryNewsletter = json['isMandatoryNewsletter'] == true;

    visiblePersonalFormField = List.from(json['visiblePersonalFormField']);
    mandatoryPersonalFormField = List.from(json['mandatoryPersonalFormField']);

    showCompanyForm = json['showCompanyForm'] == true;
    visibleCompanyFormField = List.from(json['visibleCompanyFormField']);
    mandatoryCompanyFormField = List.from(json['mandatoryCompanyFormField']);

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

    paymentManager = json['paymentManager'];

    thankYouMethod = json['thankYouMethod'];
    if (json['idTransactionalSending'] != null) {
      idTransactionalSending = json['idTransactionalSending'];
    } else {
      idTransactionalSending = 0;
    }
    waTemplateName = json['waTemplateName'];

    tyEndMessage = json['tyEndMessage'];

    if (json['optionalField'] != null) {
      optionalField = List.from(json['optionalField'])
          .map((e) => OptionalField.fromJson(e))
          .toList();
    } else {
      optionalField = List.empty();
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['typeFormStartup'] = typeFormStartup;
    data['buttonColor'] = buttonColor;
    data['formFont'] = formFont;
    data['showLogo'] = showLogo;
    data['bigImageString'] = bigImageString;
    data['smallImageString'] = smallImageString;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['showPreestablishedAmount'] = showPreestablishedAmount;
    data['preestablishedAmount'] = preestablishedAmount;
    data['showFreePrice'] = showFreePrice;
    data['showContinuousDonation'] = showContinuousDonation;
    data['frequencyContinuousDonation'] =
        frequencyContinuousDonation.map((e) => e.toJson()).toList();
    data['setContinuousDonationAsPredefined'] =
        setContinuousDonationAsPredefined;
    data['buttonNoAmountsText'] = buttonNoAmountsText;

    data['causalDonationText'] = causalDonationText;
    data['idFormGive'] = idFormGive;
    data['idSubCategoryCausalDonation'] = idSubCategoryCausalDonation;

    data['idGiveFromProjectOrFixedValue'] = idGiveFromProjectOrFixedValue;
    data['customIdGive'] = customIdGive;
    data['showCausalBeforeAmount'] = showCausalBeforeAmount;

    data['showPrivacy'] = showPrivacy;
    data['textPrivacy'] = textPrivacy;
    data['urlPrivacy'] = urlPrivacy;
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
    data['paymentManager'] = paymentManager;

    data['thankYouMethod'] = thankYouMethod;
    data['idTransactionalSending'] = idTransactionalSending;
    data['waTemplateName'] = waTemplateName;

    data['tyEndMessage'] = tyEndMessage;
    data['optionalField'] = optionalField.map((e) => e.toJson()).toList();

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
    required this.availableFrequencyContinuousDonation,
    required this.availableTypeOptionalField,
    required this.availableTextTypeOptionalField,
  });
  late final List<String> availableFormStartup;
  late final List<String> availablePaymentMethodApp;
  late final List<String> availablePaymentMethodWeb;
  late final List<String> availablePaymentManager;
  late final List<String> availablePersonalFormField;
  late final List<String> availableCompanyFormField;
  late final List<SubCategoryShort> availableSubCategoryCausalDonation;
  late final List<String> availableThankYouMethod;
  late final List<TransactionalSendingShort> availableTransactionalSending;
  late final List<String> availableFrequencyContinuousDonation;
  late final List<String> availableTypeOptionalField;
  late final List<String> availableTextTypeOptionalField;

  MyosotisConfigurationDetailEmpty.empty() {
    availableFormStartup = [];
    availablePaymentMethodApp = [];
    availablePaymentMethodWeb = [];
    availablePaymentManager = [];
    availablePersonalFormField = [];
    availableCompanyFormField = [];
    availableSubCategoryCausalDonation = [];
    availableThankYouMethod = [];
    availableTransactionalSending = [];
    availableFrequencyContinuousDonation = [];
    availableTypeOptionalField = [];
    availableTextTypeOptionalField = [];
  }

  // JSON deserialization
  MyosotisConfigurationDetailEmpty.fromJson(Map<String, dynamic> json) {
    availableFormStartup = List.from(json['availableFormStartup']);
    availablePaymentMethodApp = List.from(json['availablePaymentMethodApp']);
    availablePaymentMethodWeb = List.from(json['availablePaymentMethodWeb']);
    availablePaymentManager = List.from(json['availablePaymentManager']);
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

    availableFrequencyContinuousDonation =
        List.from(json['availableFrequencyContinuousDonation']);

    availableTypeOptionalField = List.from(json['availableTypeOptionalField']);
    availableTextTypeOptionalField =
        List.from(json['availableTextTypeOptionalField']);
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

class FrequencyContinuousDonation {
  FrequencyContinuousDonation(
      {required this.nameFrequencyContinuousDonation,
      required this.amountFrequencyContinuousDonation,
      required this.showFreeAmountNotifier});
  late String nameFrequencyContinuousDonation;
  late List<String> amountFrequencyContinuousDonation;
  late ValueNotifier<bool> showFreeAmountNotifier;

  FrequencyContinuousDonation.empty() {
    nameFrequencyContinuousDonation = '';
    amountFrequencyContinuousDonation = [];
    showFreeAmountNotifier = ValueNotifier(false);
  }

  // JSON deserialization
  FrequencyContinuousDonation.fromJson(Map<String, dynamic> json) {
    nameFrequencyContinuousDonation = json['nameFrequencyContinuousDonation'];
    amountFrequencyContinuousDonation =
        List.from(json['amountFrequencyContinuousDonation']);
    showFreeAmountNotifier = ValueNotifier(json['showFreeAmount'] ?? false);
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nameFrequencyContinuousDonation'] = nameFrequencyContinuousDonation;
    data['amountFrequencyContinuousDonation'] =
        amountFrequencyContinuousDonation;
    data['showFreeAmount'] = showFreeAmountNotifier.value;

    return data;
  }
}

class OptionalField {
  OptionalField({
    required this.labelOptionalField,
    required this.typeOptionalField,
    required this.selectableDDOptionalField,
    required this.mantainOptionalFieldOnTransactionNotifier,
    required this.giveFieldNameOptionalField,
    required this.mandatoryOptionalFieldNotifier,
    required this.textTypeOptionalField,
    required this.onOtherActivateFreeFieldNotifier,
    // required this.availableTextTypeOptionalField
  });
  late String labelOptionalField;
  late String typeOptionalField;
  late List<String> selectableDDOptionalField;
  late ValueNotifier<bool> mantainOptionalFieldOnTransactionNotifier;
  late String giveFieldNameOptionalField;
  late ValueNotifier<bool> mandatoryOptionalFieldNotifier;
  late String textTypeOptionalField;
  late ValueNotifier<bool> onOtherActivateFreeFieldNotifier;
  // late List<String> availableTextTypeOptionalField;

  OptionalField.empty() {
    labelOptionalField = '';
    typeOptionalField = '';
    selectableDDOptionalField = [];
    mantainOptionalFieldOnTransactionNotifier = ValueNotifier(false);
    giveFieldNameOptionalField = '';
    mandatoryOptionalFieldNotifier = ValueNotifier(false);
    // availableTextTypeOptionalField = [];
    textTypeOptionalField = '';
    onOtherActivateFreeFieldNotifier = ValueNotifier(false);
  }

  // JSON deserialization
  OptionalField.fromJson(Map<String, dynamic> json) {
    labelOptionalField = json['labelOptionalField'];
    typeOptionalField = json['typeOptionalField'];
    selectableDDOptionalField = List.from(json['selectableDDOptionalField']);
    mantainOptionalFieldOnTransactionNotifier =
        ValueNotifier(json['mantainOptionalFieldOnTransaction'] ?? false);
    giveFieldNameOptionalField = json['giveFieldNameOptionalField'];
    mandatoryOptionalFieldNotifier =
        ValueNotifier(json['mandatoryOptionalField'] ?? false);
    textTypeOptionalField = json['textTypeOptionalField'];
    onOtherActivateFreeFieldNotifier =
        ValueNotifier(json['onOtherActivateFreeField'] ?? false);
    // availableTextTypeOptionalField =
    //     List.from(json['availableTextTypeOptionalField']);
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['labelOptionalField'] = labelOptionalField;
    data['typeOptionalField'] = typeOptionalField;
    data['selectableDDOptionalField'] = selectableDDOptionalField;
    data['mantainOptionalFieldOnTransaction'] =
        mantainOptionalFieldOnTransactionNotifier.value;
    data['giveFieldNameOptionalField'] = giveFieldNameOptionalField;
    data['mandatoryOptionalField'] = mandatoryOptionalFieldNotifier.value;
    data['textTypeOptionalField'] = textTypeOptionalField;
    data['onOtherActivateFreeField'] = onOtherActivateFreeFieldNotifier.value;
    // data['availableTextTypeOptionalField'] = availableTextTypeOptionalField;

    return data;
  }
}
