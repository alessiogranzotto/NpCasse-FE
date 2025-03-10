import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.chips.input/custom.chips.input.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/myosotis.configuration.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/myosotis.configuration.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:uiblock/uiblock.dart';

class MyosotisConfigurationDetailScreen extends StatefulWidget {
  final MyosotisConfigurationModel myosotisConfiguration;
  const MyosotisConfigurationDetailScreen(
      {super.key, required this.myosotisConfiguration});

  @override
  State<MyosotisConfigurationDetailScreen> createState() =>
      _MyosotisConfigurationDetailState();
}

class _MyosotisConfigurationDetailState
    extends State<MyosotisConfigurationDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _chipFocusNode = FocusNode();
  final ValueNotifier<bool> createMyosotisConfigurationValidNotifier =
      ValueNotifier(false);

  bool isEdit = false;
  bool isLoading = true;
  bool isLoadingDetailEmpty = true;
  bool isLoadingDetail = true;

  late MyosotisConfigurationDetailEmpty myosotisConfigurationDetailEmpty;
  late MyosotisConfigurationDetailModel myosotisConfigurationDetailModel;
  //NAME CONFIGURATION
  late final TextEditingController nameMyosotisConfigurationController;

  //ISARCHIVED CONFIGURATION
  final ValueNotifier<bool> archiviedNotifier = ValueNotifier<bool>(false);

  //DESCRIPTION CONFIGURATION
  late final TextEditingController descriptionMyosotisConfigurationController;

  //ID DEVICE CONFIGURATION
  late List<String> enabledDeviceMyosotisConfiguration = [];

  //SHOW LOGO CONFIGURATION
  final ValueNotifier<bool> showLogoNotifier = ValueNotifier<bool>(false);

  //IMAGE CONFIGURATION
  String bigImageString = '';
  String smallImageString = '';

  //TITLE CONFIGURATION
  late final TextEditingController titleMyosotisConfigurationController;

  //SUBTITLE CONFIGURATION
  late final TextEditingController subtitleMyosotisConfigurationController;

  //FORM STARTUP CONFIGURATION-VALUE
  late String? typeFormStartup;

  //FORM STARTUP CONFIGURATION-AVAILABLE VALUE
  late List<String> preetablishedFormStartup = [];

  //PREESTABLISHED AMOUNTS CONFIGURATION
  late List<String> preetablishedAmounts = [];

  //SHOW FREE PRICE CONFIGURATION
  final ValueNotifier<bool> showFreePriceNotifier = ValueNotifier<bool>(false);

  //SHOW CAUSAL DONATION
  final ValueNotifier<bool> showCausalDonationNotifier =
      ValueNotifier<bool>(false);

  //CAUSAL DONATION TEXT
  late final TextEditingController
      causalDonationTextMyosotisConfigurationController;

  //SUBCATEGORY CAUSAL DONATION CONFIGURATION-VALUE
  late int idSubCategoryCausalDonation;

  //SUBCATEGORY CAUSAL DONATION CONFIGURATION-AVAILABLE VALUE
  late List<SubCategoryShort> availableSubCategoryCausalDonation = [];

  //SHOW PRIVACY CONFIGURATION
  final ValueNotifier<bool> showPrivacyNotifier = ValueNotifier<bool>(false);

  //TEXT PRIVACY CONFIGURATION
  late final TextEditingController textPrivacyMyosotisConfigurationController;

  //MANDATORY PRIVACY CONFIGURATION//TEXT PRIVACY CONFIGURATION
  final ValueNotifier<bool> isMandatoryPrivacyNotifier =
      ValueNotifier<bool>(false);

  //SHOW NEWSLETTER CONFIGURATION
  final ValueNotifier<bool> showNewsletterNotifier = ValueNotifier<bool>(false);

  //TEXT NEWSLETTER CONFIGURATION
  late final TextEditingController
      textNewsletterMyosotisConfigurationController;

  //MANDATORY NEWSLETTER CONFIGURATION
  final ValueNotifier<bool> isMandatoryNewsletterNotifier =
      ValueNotifier<bool>(false);

  //VISIBLE PERSONAL FORM FIELD  CONFIGURATION
  final visiblePersonalFormFieldController = MultiSelectController<String>();
  List<DropdownItem<String>> availableVisiblePersonalFormField = [];

  //MANDATORY PERSONAL FORM FIELD  CONFIGURATION
  final mandatoryPersonalFormFieldController = MultiSelectController<String>();
  List<DropdownItem<String>> availableMandatoryPersonalFormField = [];

  //SHOW COMPANY FORM
  final ValueNotifier<bool> showCompanyFormNotifier =
      ValueNotifier<bool>(false);

  //VISIBLE COMPANY FORM FIELD  CONFIGURATION
  final visibleCompanyFormFieldController = MultiSelectController<String>();
  List<DropdownItem<String>> availableVisibleCompanyFormField = [];

  //MANDATORY COMPANY FORM FIELD  CONFIGURATION
  final mandatoryCompanyFormFieldController = MultiSelectController<String>();
  List<DropdownItem<String>> availableMandatoryCompanyFormField = [];

  //PAYMENT METHOD APP CONFIGURATION
  final paymentMethodAppController = MultiSelectController<String>();
  List<DropdownItem<String>> availablePaymentMethodApp = [];

  //PAYMENT METHOD APP CONFIGURATION
  final paymentMethodWebController = MultiSelectController<String>();
  List<DropdownItem<String>> availablePaymentMethodWeb = [];

  void initializeControllers() {
    nameMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    descriptionMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    titleMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    subtitleMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    causalDonationTextMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    textPrivacyMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    textNewsletterMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    visiblePersonalFormFieldController.addListener(dataControllerListener);
    mandatoryPersonalFormFieldController.addListener(dataControllerListener);

    visibleCompanyFormFieldController.addListener(dataControllerListener);
    mandatoryCompanyFormFieldController.addListener(dataControllerListener);
    paymentMethodAppController.addListener(dataControllerListener);
    paymentMethodWebController.addListener(dataControllerListener);
  }

  void disposeControllers() {
    nameMyosotisConfigurationController.dispose();
    descriptionMyosotisConfigurationController.dispose();
    titleMyosotisConfigurationController.dispose();
    subtitleMyosotisConfigurationController.dispose();
    causalDonationTextMyosotisConfigurationController.dispose();
    textPrivacyMyosotisConfigurationController.dispose();
    textNewsletterMyosotisConfigurationController.dispose();
    visiblePersonalFormFieldController.dispose();
    mandatoryPersonalFormFieldController.dispose();

    visibleCompanyFormFieldController.dispose();
    mandatoryCompanyFormFieldController.dispose();
    paymentMethodAppController.dispose();
    paymentMethodWebController.dispose();

    createMyosotisConfigurationValidNotifier.dispose();
    showPrivacyNotifier.dispose();
    isMandatoryPrivacyNotifier.dispose();
    showCompanyFormNotifier.dispose();
  }

  void dataControllerListener() {
    createMyosotisConfigurationValidNotifier.value = false;
    if (nameMyosotisConfigurationController.text.isEmpty) return;
  }

  Future<void> getMyosotisConfigurationData() async {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    MyosotisConfigurationNotifier myosotisConfigurationNotifier =
        Provider.of<MyosotisConfigurationNotifier>(context, listen: false);

    await myosotisConfigurationNotifier
        .getMyosotisConfigurationDetailEmpty(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idInstitution:
                cUserAppInstitutionModel.idInstitutionNavigation.idInstitution)
        .then((value) {
      var snapshot = value as MyosotisConfigurationDetailEmpty;
      myosotisConfigurationDetailEmpty = snapshot;
      setState(() {
        isLoadingDetailEmpty = false;
        checkLoading();
      });
    });
    if (widget.myosotisConfiguration.idMyosotisConfiguration > 0) {
      myosotisConfigurationNotifier
          .getMyosotisConfigurationDetail(
              context: context,
              token: authenticationNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idInstitution: cUserAppInstitutionModel
                  .idInstitutionNavigation.idInstitution,
              idMyosotisConfiguration:
                  widget.myosotisConfiguration.idMyosotisConfiguration)
          .then((value) {
        var snapshot = value as MyosotisConfigurationDetailModel;
        myosotisConfigurationDetailModel = snapshot;
        setState(() {
          isLoadingDetail = false;
          checkLoading();
        });
      });
    } else {
      setState(() {
        isLoadingDetail = false;
        checkLoading();
      });
    }
  }

  checkLoading() {
    if (!isLoadingDetailEmpty && !isLoadingDetail) {
      if (widget.myosotisConfiguration.idMyosotisConfiguration > 0) {
        setWidgetDetail(myosotisConfigurationDetailModel);
      }
      setInitialData(myosotisConfigurationDetailEmpty);
      setState(() {
        isLoading = false;
      });
    }
  }

  setWidgetDetail(
      MyosotisConfigurationDetailModel myosotisConfigurationDetailModel) {
    //SHOWLOGO CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.showLogo =
        myosotisConfigurationDetailModel.showLogo;

    //IMAGE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .bigImageString = myosotisConfigurationDetailModel.bigImageString;
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .smallImageString = myosotisConfigurationDetailModel.smallImageString;

    // //TITLE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.title =
        myosotisConfigurationDetailModel.title;

    //SUBTITLE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.subtitle =
        myosotisConfigurationDetailModel.subtitle;

    //FORM STARTUP CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .typeFormStartup = myosotisConfigurationDetailModel.typeFormStartup;

    //PREESTABLISHED AMOUNTS CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .preestablishedAmount =
        myosotisConfigurationDetailModel.preestablishedAmount;

    //SHOW FREE PRICE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .showFreePrice = myosotisConfigurationDetailModel.showFreePrice;

    //SHOW CAUSAL DONATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .showCausalDonation =
        myosotisConfigurationDetailModel.showCausalDonation;

    //TEXT CAUSAL DONATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .causalDonationText =
        myosotisConfigurationDetailModel.causalDonationText;

    //ID SUBCATEGORY CASUAL DONATION VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .idSubCategoryCausalDonation =
        myosotisConfigurationDetailModel.idSubCategoryCausalDonation;

    //SHOW PRIVACY CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.showPrivacy =
        myosotisConfigurationDetailModel.showPrivacy;

    //TEXT PRIVACY CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.textPrivacy =
        myosotisConfigurationDetailModel.textPrivacy;

    //MANDATORY PRIVACY CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .isMandatoryPrivacy =
        myosotisConfigurationDetailModel.isMandatoryPrivacy;

    //SHOW NEWSLETTER CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .showNewsletter = myosotisConfigurationDetailModel.showNewsletter;

    //TEXT NEWSLETTER CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .textNewsletter = myosotisConfigurationDetailModel.textNewsletter;

    //MANDATORY NEWSLETTER CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .isMandatoryNewsletter =
        myosotisConfigurationDetailModel.isMandatoryNewsletter;

    // VISIBLE PERSONAL FORM FIELD CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .visiblePersonalFormField =
        myosotisConfigurationDetailModel.visiblePersonalFormField;

    //MANDATORY PERSONAL FORM FIELD  CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .mandatoryPersonalFormField =
        myosotisConfigurationDetailModel.mandatoryPersonalFormField;

    //SHOW COMPANY FORM
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .showCompanyForm = myosotisConfigurationDetailModel.showCompanyForm;

    //VISIBLE COMPANY FORM FIELD CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .visibleCompanyFormField =
        myosotisConfigurationDetailModel.visibleCompanyFormField;

    //MANDATORY COMPANY FORM FIELD CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .mandatoryCompanyFormField =
        myosotisConfigurationDetailModel.mandatoryCompanyFormField;

    //PAYMENT METHOD APP CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .preestablishedPaymentMethodApp =
        myosotisConfigurationDetailModel.preestablishedPaymentMethodApp;

    //PAYMENT METHOD WEB CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .preestablishedPaymentMethodWeb =
        myosotisConfigurationDetailModel.preestablishedPaymentMethodWeb;
  }

  setInitialData(
      MyosotisConfigurationDetailEmpty myosotisConfigurationDetailEmpty) {
    isEdit = widget.myosotisConfiguration.idMyosotisConfiguration != 0;

    //NAME CONFIGURATION
    nameMyosotisConfigurationController.text =
        widget.myosotisConfiguration.nameMyosotisConfiguration.toString();

    //ISARCHIVED CONFIGURATION
    archiviedNotifier.value = widget.myosotisConfiguration.archived;

    //DESCRIPTION CONFIGURATION
    descriptionMyosotisConfigurationController.text = widget
        .myosotisConfiguration.descriptionMyosotisConfiguration
        .toString();

    //ID DEVICE CONFIGURATION
    enabledDeviceMyosotisConfiguration = new List<String>.from(
        widget.myosotisConfiguration.enabledDeviceMyosotisConfiguration);

    //SHOWLOGO CONFIGURATION
    showLogoNotifier.value =
        widget.myosotisConfiguration.myosotisConfigurationDetailModel.showLogo;

    //IMAGE CONFIGURATION
    bigImageString = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.bigImageString;
    smallImageString = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.smallImageString;

    //TITLE CONFIGURATION
    titleMyosotisConfigurationController.text =
        widget.myosotisConfiguration.myosotisConfigurationDetailModel.title;

    //SUBTITLE CONFIGURATION
    subtitleMyosotisConfigurationController.text =
        widget.myosotisConfiguration.myosotisConfigurationDetailModel.subtitle;

    //FORM STARTUP CONFIGURATION-VALUE
    typeFormStartup = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.typeFormStartup;

    //FORM STARTUP CONFIGURATION-AVAILABLE VALUE
    preetablishedFormStartup =
        myosotisConfigurationDetailEmpty.availableFormStartup;

    //PREESTABLISHED AMOUNTS CONFIGURATION
    preetablishedAmounts = new List<String>.from(widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.preestablishedAmount);

    //SHOW FREE PRICE CONFIGURATION
    showFreePriceNotifier.value = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.showFreePrice;

    //SHOW CAUSAL DONATION
    showCausalDonationNotifier.value = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.showCausalDonation;

    //TEXT CAUSAL DONATION
    causalDonationTextMyosotisConfigurationController.text = widget
        .myosotisConfiguration
        .myosotisConfigurationDetailModel
        .causalDonationText;

    //ID SUBCATEGORY CASUAL DONATION VALUE
    idSubCategoryCausalDonation = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.idSubCategoryCausalDonation;

    //SUBCATEGORY CASUAL DONATION-AVAILABLE VALUE
    availableSubCategoryCausalDonation =
        myosotisConfigurationDetailEmpty.availableSubCategoryCausalDonation;

    //SHOW PRIVACY CONFIGURATION
    showPrivacyNotifier.value = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.showPrivacy;

    //TEXT PRIVACY CONFIGURATION
    textPrivacyMyosotisConfigurationController.text = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.textPrivacy;

    //MANDATORY PRIVACY CONFIGURATION
    isMandatoryPrivacyNotifier.value = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.isMandatoryPrivacy;

    //SHOW NEWSLETTER CONFIGURATION
    showNewsletterNotifier.value = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.showNewsletter;

    //TEXT NEWSLETTER CONFIGURATION
    textNewsletterMyosotisConfigurationController.text = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.textNewsletter;

    //MANDATORY NEWSLETTER CONFIGURATION
    isMandatoryNewsletterNotifier.value = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.isMandatoryNewsletter;

    //VISIBLE PERSONAL FORM FIELD CONFIGURATION
    var tempListOfPersonalFormField = [];
    for (int i = 0;
        i < myosotisConfigurationDetailEmpty.availablePersonalFormField.length;
        i++) {
      var isPresent = widget.myosotisConfiguration
          .myosotisConfigurationDetailModel.visiblePersonalFormField
          .map((e) => e)
          .contains(
              myosotisConfigurationDetailEmpty.availablePersonalFormField[i]);
      if (isPresent) {
        tempListOfPersonalFormField.add(
            myosotisConfigurationDetailEmpty.availablePersonalFormField[i]);
      }
      availableVisiblePersonalFormField.add(
        DropdownItem(
            selected: isPresent,
            label:
                myosotisConfigurationDetailEmpty.availablePersonalFormField[i],
            value:
                myosotisConfigurationDetailEmpty.availablePersonalFormField[i]),
      );
    }

    //MANDATORY PERSONAL FORM FIELD  CONFIGURATION
    for (int i = 0; i < tempListOfPersonalFormField.length; i++) {
      var isPresent = widget.myosotisConfiguration
          .myosotisConfigurationDetailModel.mandatoryPersonalFormField
          .map((e) => e)
          .contains(tempListOfPersonalFormField[i]);

      availableMandatoryPersonalFormField.add(
        DropdownItem(
            selected: isPresent,
            label: tempListOfPersonalFormField[i],
            value: tempListOfPersonalFormField[i]),
      );
    }

    //SHOW COMPANY FORM
    showCompanyFormNotifier.value = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.showCompanyForm;

    //VISIBLE COMPANY FORM FIELD CONFIGURATION
    var tempListOfCompanyFormField = [];
    for (int i = 0;
        i < myosotisConfigurationDetailEmpty.availableCompanyFormField.length;
        i++) {
      var isPresent = widget.myosotisConfiguration
          .myosotisConfigurationDetailModel.visibleCompanyFormField
          .map((e) => e)
          .contains(
              myosotisConfigurationDetailEmpty.availableCompanyFormField[i]);
      if (isPresent) {
        tempListOfCompanyFormField
            .add(myosotisConfigurationDetailEmpty.availableCompanyFormField[i]);
      }
      availableVisibleCompanyFormField.add(
        DropdownItem(
            selected: isPresent,
            label:
                myosotisConfigurationDetailEmpty.availableCompanyFormField[i],
            value:
                myosotisConfigurationDetailEmpty.availableCompanyFormField[i]),
      );
    }

    //MANDATORY COMPANY FORM FIELD CONFIGURATION
    for (int i = 0; i < tempListOfCompanyFormField.length; i++) {
      var isPresent = widget.myosotisConfiguration
          .myosotisConfigurationDetailModel.mandatoryCompanyFormField
          .map((e) => e)
          .contains(tempListOfCompanyFormField[i]);

      availableMandatoryCompanyFormField.add(
        DropdownItem(
            selected: isPresent,
            label: tempListOfCompanyFormField[i],
            value: tempListOfCompanyFormField[i]),
      );
    }

    //PAYMENT METHOD APP CONFIGURATION-VALUE
    for (int i = 0;
        i < myosotisConfigurationDetailEmpty.availablePaymentMethodApp.length;
        i++) {
      var isPresent = widget.myosotisConfiguration
          .myosotisConfigurationDetailModel.preestablishedPaymentMethodApp
          .map((e) => e)
          .contains(
              myosotisConfigurationDetailEmpty.availablePaymentMethodApp[i]);

      availablePaymentMethodApp.add(
        DropdownItem(
            selected: isPresent,
            label:
                myosotisConfigurationDetailEmpty.availablePaymentMethodApp[i],
            value:
                myosotisConfigurationDetailEmpty.availablePaymentMethodApp[i]),
      );
    }

    //PAYMENT METHOD WEB CONFIGURATION-VALUE
    for (int i = 0;
        i < myosotisConfigurationDetailEmpty.availablePaymentMethodWeb.length;
        i++) {
      var isPresent = widget.myosotisConfiguration
          .myosotisConfigurationDetailModel.preestablishedPaymentMethodWeb
          .map((e) => e)
          .contains(
              myosotisConfigurationDetailEmpty.availablePaymentMethodWeb[i]);

      availablePaymentMethodWeb.add(
        DropdownItem(
            selected: isPresent,
            label:
                myosotisConfigurationDetailEmpty.availablePaymentMethodWeb[i],
            value:
                myosotisConfigurationDetailEmpty.availablePaymentMethodWeb[i]),
      );
    }

    if (isEdit) {
      //MASTER

      //DETAIL
    } else {}
  }

  void refreshAvailableMandatoryPersonalFormField(List<String> selectedItems) {
    //REFRESH MANDATORY PERSONAL FORM FIELD  CONFIGURATION

    List<String> moreItems = selectedItems
        .where((item) =>
            !(availableMandatoryPersonalFormField.map((e) => e.value).toList())
                .contains(item))
        .toList(); // In list1 but not in list2
    if (moreItems.length > 0) {
      availableMandatoryPersonalFormField.add(
        DropdownItem(selected: false, label: moreItems[0], value: moreItems[0]),
      );
      mandatoryPersonalFormFieldController.items.add(
        DropdownItem(selected: false, label: moreItems[0], value: moreItems[0]),
      );
    } else {
      List<String> lessItems = availableMandatoryPersonalFormField
          .map((e) => e.value)
          .toList()
          .where((item) => !(selectedItems).contains(item))
          .toList(); // In list2 but not in list1
      if (lessItems.length > 0) {
        availableMandatoryPersonalFormField
            .removeWhere((e) => e.value == lessItems[0]);
        mandatoryPersonalFormFieldController.items
            .removeWhere((e) => e.value == lessItems[0]);
      }
    }
  }

  void refreshAvailableMandatoryCompanyFormField(List<String> selectedItems) {
    //REFRESH MANDATORY COMPANY FORM FIELD  CONFIGURATION

    List<String> moreItems = selectedItems
        .where((item) =>
            !(availableMandatoryCompanyFormField.map((e) => e.value).toList())
                .contains(item))
        .toList(); // In list1 but not in list2
    if (moreItems.length > 0) {
      availableMandatoryCompanyFormField.add(
        DropdownItem(selected: false, label: moreItems[0], value: moreItems[0]),
      );
      mandatoryCompanyFormFieldController.items.add(
        DropdownItem(selected: false, label: moreItems[0], value: moreItems[0]),
      );
    } else {
      List<String> lessItems = availableMandatoryCompanyFormField
          .map((e) => e.value)
          .toList()
          .where((item) => !(selectedItems).contains(item))
          .toList(); // In list2 but not in list1
      if (lessItems.length > 0) {
        availableMandatoryCompanyFormField
            .removeWhere((e) => e.value == lessItems[0]);
        mandatoryCompanyFormFieldController.items
            .removeWhere((e) => e.value == lessItems[0]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    getMyosotisConfigurationData();
  }

  Widget chipBuilderIdDevice(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'idDevice'),
      onSelected: (data) => onChipTapped(data, 'idDevice'),
    );
  }

  Widget chipBuilderPreetablishedAmounts(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'preetablishedAmounts'),
      onSelected: (data) => onChipTapped(data, 'preetablishedAmounts'),
    );
  }

  Widget chipBuilderProjectToHelp(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'projectToHelp'),
      onSelected: (data) => onChipTapped(data, 'projectToHelp'),
    );
  }

  void onChipTapped(String topping, String area) {}

  void onChipDeleted(String topping, String area) {
    setState(() {
      if (area == 'idDevice') {
        enabledDeviceMyosotisConfiguration.remove(topping);
      } else if (area == 'preetablishedAmounts') {
        preetablishedAmounts.remove(topping);
      }
    });
  }

  void onSubmitted(String text, String area) {
    if (area == 'idDevice') {
      if (text.trim().isNotEmpty) {
        setState(() {
          enabledDeviceMyosotisConfiguration = <String>[
            ...enabledDeviceMyosotisConfiguration,
            text.trim()
          ];
        });
      } else {
        _chipFocusNode.unfocus();
        setState(() {
          enabledDeviceMyosotisConfiguration = <String>[];
        });
      }
    } else if (area == 'preestablishedAmount') {
      if (text.trim().isNotEmpty) {
        setState(() {
          preetablishedAmounts = <String>[...preetablishedAmounts, text.trim()];
        });
      } else {
        _chipFocusNode.unfocus();
        setState(() {
          preetablishedAmounts = <String>[];
        });
      }
    }
  }

  void onChanged(List<String> data, String area) {
    setState(() {
      if (area == 'idDevice') {
        enabledDeviceMyosotisConfiguration = data;
      } else if (area == 'preestablishedAmount') {
        preetablishedAmounts = data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    MyosotisConfigurationNotifier myosotisConfigurationNotifier =
        Provider.of<MyosotisConfigurationNotifier>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Dettaglio configurazione myosotis: ${widget.myosotisConfiguration.nameMyosotisConfiguration}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.redAccent,
                    )))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                              enabled: true,
                              controller: nameMyosotisConfigurationController,
                              labelText: AppStrings.nameMyosotisConfiguration,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : AppStrings
                                        .pleaseEnterNameMyosotisConfiguration;
                              },
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: ValueListenableBuilder<bool>(
                                valueListenable:
                                    archiviedNotifier, // Ascolta i cambiamenti del ValueNotifier
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: Text("Archiviata"),
                                      value: value,
                                      onChanged: (bool? newValue) {
                                        archiviedNotifier.value = newValue ??
                                            false; // Aggiorna il valore del ValueNotifier
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                },
                              )),
                        ],
                      ),
                      CustomTextFormField(
                        enabled: true,
                        controller: descriptionMyosotisConfigurationController,
                        labelText: AppStrings.descriptionMyosotisConfiguration,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        // validator: (value) {
                        //   return value!.isNotEmpty
                        //       ? null
                        //       : AppStrings
                        //           .pleaseEnterDescriptionMyosotisConfiguration;
                        // },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ChipsInput<String>(
                          values: enabledDeviceMyosotisConfiguration,
                          label: AppStrings.idDeviceMyosotisConfiguration,
                          strutStyle: const StrutStyle(fontSize: 12),
                          onChanged: (data) => onChanged(data, 'idDevice'),
                          onSubmitted: (data) => onSubmitted(data, 'idDevice'),
                          chipBuilder: chipBuilderIdDevice,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(height: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 240,
                            child: Card(
                              elevation: 8,
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.6),
                                      offset: const Offset(0.0, 0.0), //(x,y)
                                      blurRadius: 4.0,
                                      blurStyle: BlurStyle.solid)
                                ], color: Theme.of(context).cardColor),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      height: 180,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: (ImageUtils
                                                    .getImageFromStringBase64(
                                                        stringImage:
                                                            bigImageString)
                                                .image)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Immagine di sfondo grande"),
                                        Tooltip(
                                          message:
                                              'Upload immagine di sfondo grande',
                                          child: IconButton(
                                              onPressed: () {
                                                ImageUtils.imageSelectorFile()
                                                    .then((value) {
                                                  setState(() {
                                                    bigImageString = value;
                                                  });
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.upload,
                                                size: 20,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 240,
                            child: Card(
                              elevation: 8,
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.6),
                                      offset: const Offset(0.0, 0.0), //(x,y)
                                      blurRadius: 4.0,
                                      blurStyle: BlurStyle.solid)
                                ], color: Theme.of(context).cardColor),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      height: 180,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: (ImageUtils
                                                    .getImageFromStringBase64(
                                                        stringImage:
                                                            smallImageString)
                                                .image)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Immagine di sfondo piccola"),
                                        Tooltip(
                                          message:
                                              'Upload immagine di sfondo piccola',
                                          child: IconButton(
                                              onPressed: () {
                                                ImageUtils.imageSelectorFile()
                                                    .then((value) {
                                                  setState(() {
                                                    smallImageString = value;
                                                  });
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.upload,
                                                size: 20,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                              enabled: true,
                              controller: titleMyosotisConfigurationController,
                              labelText: AppStrings.titleMyosotisConfiguration,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  _formKey.currentState?.validate(),
                              // validator: (value) {
                              //   return value!.isNotEmpty
                              //       ? null
                              //       : AppStrings
                              //           .pleaseEnterTitleMyosotisConfiguration;
                              // },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: showLogoNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: const SizedBox(
                                          width: 100,
                                          child: Text(AppStrings
                                              .showLogoConfiguration)),
                                      value: value,
                                      onChanged: (bool? newValue) {
                                        showLogoNotifier.value = newValue ??
                                            false; // Aggiorna il valore del ValueNotifier
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        enabled: true,
                        controller: subtitleMyosotisConfigurationController,
                        labelText: AppStrings.subtitleMyosotisConfiguration,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        // validator: (value) {
                        //   return value!.isNotEmpty
                        //       ? null
                        //       : AppStrings
                        //           .pleaseEnterTitleMyosotisConfiguration;
                        // },
                      ),
                      CustomDropDownButtonFormField(
                        enabled: true,
                        actualValue: typeFormStartup,
                        labelText: AppStrings.formStartupMyosotisConfiguration,
                        listOfValue: preetablishedFormStartup
                            .map((value) => DropdownMenuItem(
                                child: Text(value), value: value))
                            .toList(),
                        onItemChanged: (value) {
                          typeFormStartup = value;
                        },
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : AppStrings
                                  .pleaseEnterFormStartupMyosotisConfiguration;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ChipsInput<String>(
                                values: preetablishedAmounts,
                                label: AppStrings.preestablishedAmount,
                                decoration: const InputDecoration(),
                                strutStyle: const StrutStyle(fontSize: 12),
                                onChanged: (data) =>
                                    onChanged(data, 'preestablishedAmount'),
                                onSubmitted: (data) =>
                                    onSubmitted(data, 'preestablishedAmount'),
                                chipBuilder: chipBuilderPreetablishedAmounts,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: showFreePriceNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: SizedBox(
                                          width: 100,
                                          child: Text(AppStrings
                                              .showFreePriceConfiguration)),
                                      value: value,
                                      onChanged: (bool? value) {
                                        showFreePriceNotifier.value =
                                            value ?? false;
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: showCausalDonationNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: SizedBox(
                                          width: 100,
                                          child: Text(
                                              AppStrings.showCausalDonation)),
                                      value: value,
                                      onChanged: (bool? value) {
                                        showCausalDonationNotifier.value =
                                            value ?? false;
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomTextFormField(
                              enabled: true,
                              controller:
                                  causalDonationTextMyosotisConfigurationController,
                              labelText: AppStrings.causalDonationText,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  _formKey.currentState?.validate(),
                              // validator: (value) {
                              //   return value!.isNotEmpty
                              //       ? null
                              //       : AppStrings
                              //           .pleaseEnterTitleMyosotisConfiguration;
                              // },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: idSubCategoryCausalDonation,
                              labelText:
                                  AppStrings.availableSubCategoryCausalDonation,
                              listOfValue: availableSubCategoryCausalDonation
                                  .map((value) => DropdownMenuItem(
                                      child: Text(value.nameSubCategory),
                                      value: value.idSubCategory))
                                  .toList(),
                              onItemChanged: (value) {
                                idSubCategoryCausalDonation = value;
                              },
                              // validator: (value) {
                              //   return value!.isNotEmpty
                              //       ? null
                              //       : AppStrings
                              //           .pleaseEnterFormStartupMyosotisConfiguration;
                              // },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: showPrivacyNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: SizedBox(
                                          width: 100,
                                          child: Text(AppStrings.showPrivacy)),
                                      value: value,
                                      onChanged: (bool? value) {
                                        showPrivacyNotifier.value =
                                            value ?? false;
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                              enabled: true,
                              controller:
                                  textPrivacyMyosotisConfigurationController,
                              labelText:
                                  AppStrings.textPrivacyMyosotisConfiguration,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  _formKey.currentState?.validate(),
                              // validator: (value) {
                              //   return value!.isNotEmpty
                              //       ? null
                              //       : AppStrings
                              //           .pleaseEnterTextPrivacyMyosotisConfiguration;
                              // },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: isMandatoryPrivacyNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: SizedBox(
                                          width: 100,
                                          child: Text(
                                              AppStrings.isMandatoryPrivacy)),
                                      value: value,
                                      onChanged: (bool? value) {
                                        isMandatoryPrivacyNotifier.value =
                                            value ?? false;
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: showNewsletterNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: SizedBox(
                                          width: 100,
                                          child:
                                              Text(AppStrings.showNewsletter)),
                                      value: value,
                                      onChanged: (bool? value) {
                                        showNewsletterNotifier.value =
                                            value ?? false;
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                              enabled: true,
                              controller:
                                  textNewsletterMyosotisConfigurationController,
                              labelText: AppStrings
                                  .textNewsletterMyosotisConfiguration,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) =>
                                  _formKey.currentState?.validate(),
                              // validator: (value) {
                              //   return value!.isNotEmpty
                              //       ? null
                              //       : AppStrings
                              //           .pleaseEnterTextPrivacyMyosotisConfiguration;
                              // },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: isMandatoryNewsletterNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: SizedBox(
                                          width: 100,
                                          child: Text(AppStrings
                                              .isMandatoryNewsletter)),
                                      value: value,
                                      onChanged: (bool? value) {
                                        isMandatoryNewsletterNotifier.value =
                                            value ?? false;
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiDropdown<String>(
                          items: availableVisiblePersonalFormField,
                          controller: visiblePersonalFormFieldController,
                          enabled: true,
                          searchEnabled: false,
                          chipDecoration: ChipDecoration(
                            labelStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1.5),
                            backgroundColor: Colors.transparent,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          fieldDecoration: FieldDecoration(
                            labelText: "Campi form persona",
                            labelStyle: Theme.of(context).textTheme.labelLarge!,
                            hintText: 'Selezionare i campi del form persona',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3)),
                            prefixIcon: const Icon(Icons.person),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please select a country';
                          //   }
                          //   return null;
                          // },
                          onSelectionChange: (selectedItems) {
                            refreshAvailableMandatoryPersonalFormField(
                                selectedItems);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiDropdown<String>(
                          items: availableMandatoryPersonalFormField,
                          controller: mandatoryPersonalFormFieldController,
                          enabled: true,
                          searchEnabled: false,
                          chipDecoration: ChipDecoration(
                            labelStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1.5),
                            backgroundColor: Colors.transparent,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          fieldDecoration: FieldDecoration(
                            labelText: "Campi obbligatori form persona",
                            labelStyle: Theme.of(context).textTheme.labelLarge!,
                            hintText:
                                'Selezionare i campi obbligatori del form persona',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3)),
                            prefixIcon: const Icon(Icons.person),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please select a country';
                          //   }
                          //   return null;
                          // },
                          onSelectionChange: (selectedItems) {},
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                                valueListenable: showCompanyFormNotifier,
                                builder: (context, value, child) {
                                  return CheckboxListTile(
                                      title: SizedBox(
                                          width: 100,
                                          child:
                                              Text(AppStrings.showCompanyForm)),
                                      value: value,
                                      onChanged: (bool? value) {
                                        showCompanyFormNotifier.value =
                                            value ?? false;
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading);
                                }),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiDropdown<String>(
                          items: availableVisibleCompanyFormField,
                          controller: visibleCompanyFormFieldController,
                          enabled: true,
                          searchEnabled: false,
                          chipDecoration: ChipDecoration(
                            labelStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1.5),
                            backgroundColor: Colors.transparent,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          fieldDecoration: FieldDecoration(
                            labelText: "Campi form azienda",
                            labelStyle: Theme.of(context).textTheme.labelLarge!,
                            hintText: 'Selezionare i campi del form azienda',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3)),
                            prefixIcon: const Icon(Icons.business),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please select a country';
                          //   }
                          //   return null;
                          // },
                          onSelectionChange: (selectedItems) {
                            refreshAvailableMandatoryCompanyFormField(
                                selectedItems);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiDropdown<String>(
                          items: availableMandatoryCompanyFormField,
                          controller: mandatoryCompanyFormFieldController,
                          enabled: true,
                          searchEnabled: false,
                          chipDecoration: ChipDecoration(
                            labelStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1.5),
                            backgroundColor: Colors.transparent,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          fieldDecoration: FieldDecoration(
                            labelText: "Campi obbligatori form azienda",
                            labelStyle: Theme.of(context).textTheme.labelLarge!,
                            hintText:
                                'Selezionare i campi obbligatori del form azienda',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3)),
                            prefixIcon: const Icon(Icons.business),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please select a country';
                          //   }
                          //   return null;
                          // },
                          onSelectionChange: (selectedItems) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiDropdown<String>(
                          items: availablePaymentMethodApp,
                          controller: paymentMethodAppController,
                          enabled: true,
                          searchEnabled: false,
                          chipDecoration: ChipDecoration(
                            labelStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1.5),
                            backgroundColor: Colors.transparent,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          fieldDecoration: FieldDecoration(
                            labelText: "Metodi di pagamento App",
                            labelStyle: Theme.of(context).textTheme.labelLarge!,
                            hintText:
                                'Selezionare i metodi di pagamento per la APP...',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3)),
                            prefixIcon: const Icon(Icons.payment),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserire modalità di pagamento APP';
                            }
                            return null;
                          },
                          onSelectionChange: (selectedItems) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiDropdown<String>(
                          items: availablePaymentMethodWeb,
                          controller: paymentMethodWebController,
                          enabled: true,
                          searchEnabled: false,
                          chipDecoration: ChipDecoration(
                            labelStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1.5),
                            backgroundColor: Colors.transparent,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          fieldDecoration: FieldDecoration(
                            labelText: "Metodi di pagamento Web",
                            labelStyle: Theme.of(context).textTheme.labelLarge!,
                            hintText:
                                'Selezionare i metodi di pagamento per il web...',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.3)),
                            prefixIcon: const Icon(Icons.payment),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserire modalità di pagamento Web';
                            }
                            return null;
                          },
                          onSelectionChange: (selectedItems) {},
                        ),
                      ),
                      SizedBox(height: 120),
                    ],
                  ),
                )),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                UIBlock.block(context);
                if (_formKey.currentState!.validate()) {
                  MyosotisConfigurationDetailModel myosotisConfigurationDetailModel = MyosotisConfigurationDetailModel(
                      typeFormStartup: typeFormStartup!,
                      showLogo: showLogoNotifier.value,
                      bigImageString: bigImageString,
                      smallImageString: smallImageString,
                      title: titleMyosotisConfigurationController.text,
                      subtitle: subtitleMyosotisConfigurationController.text,
                      preestablishedAmount: preetablishedAmounts,
                      showFreePrice: showFreePriceNotifier.value,
                      showPrivacy: showPrivacyNotifier.value,
                      textPrivacy:
                          textPrivacyMyosotisConfigurationController.text,
                      isMandatoryPrivacy: isMandatoryPrivacyNotifier.value,
                      showNewsletter: showNewsletterNotifier.value,
                      textNewsletter:
                          textNewsletterMyosotisConfigurationController.text,
                      isMandatoryNewsletter:
                          isMandatoryNewsletterNotifier.value,
                      visiblePersonalFormField:
                          visiblePersonalFormFieldController.selectedItems
                              .map((e) => e.value)
                              .toList(),
                      mandatoryPersonalFormField:
                          mandatoryPersonalFormFieldController.selectedItems
                              .map((e) => e.value)
                              .toList(),
                      showCompanyForm: showCompanyFormNotifier.value,
                      visibleCompanyFormField: visibleCompanyFormFieldController
                          .selectedItems
                          .map((e) => e.value)
                          .toList(),
                      mandatoryCompanyFormField:
                          mandatoryCompanyFormFieldController.selectedItems
                              .map((e) => e.value)
                              .toList(),
                      preestablishedPaymentMethodApp: paymentMethodAppController
                          .selectedItems
                          .map((e) => e.value)
                          .toList(),
                      preestablishedPaymentMethodWeb: paymentMethodWebController
                          .selectedItems
                          .map((e) => e.value)
                          .toList(),
                      showCausalDonation: showCausalDonationNotifier.value,
                      causalDonationText:
                          causalDonationTextMyosotisConfigurationController.text,
                      idSubCategoryCausalDonation: idSubCategoryCausalDonation);
                  MyosotisConfigurationModel myosotisConfigurationModel =
                      MyosotisConfigurationModel(
                          idMyosotisConfiguration: widget
                              .myosotisConfiguration.idMyosotisConfiguration,
                          nameMyosotisConfiguration:
                              nameMyosotisConfigurationController.text,
                          descriptionMyosotisConfiguration:
                              descriptionMyosotisConfigurationController.text,
                          enabledDeviceMyosotisConfiguration:
                              enabledDeviceMyosotisConfiguration,
                          archived: archiviedNotifier.value,
                          idUserAppInstitution:
                              cUserAppInstitutionModel.idUserAppInstitution,
                          idInstitution: cUserAppInstitutionModel
                              .idInstitutionNavigation.idInstitution,
                          myosotisConfigurationDetailModel:
                              myosotisConfigurationDetailModel);
                  myosotisConfigurationNotifier
                      .addOrUpdateMyosotisConfiguration(
                          context: context,
                          token: authenticationNotifier.token,
                          myosotisConfigurationModel:
                              myosotisConfigurationModel)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Configurazione Myosotis",
                              message: "Informazioni aggiornate",
                              contentType: "success"));
                      UIBlock.unblock(context);
                      Navigator.of(context).pop();
                      myosotisConfigurationNotifier.refresh();
                    } else {
                      UIBlock.unblock(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackUtil.stylishSnackBar(
                              title: "Configurazione Myosotis",
                              message: "Errore di connessione",
                              contentType: "failure"));
                      // Navigator.of(context).pop();
                    }
                  });
                }
              },

              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.check),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                // var dialog = CustomAlertDialog(
                //   title: "Eliminazione categoria",
                //   content: Text("Si desidera procedere alla cancellazione?"),
                //   yesCallBack: () {
                //     deleted = true;
                //     CategoryCatalogModel categoryCatalogModel =
                //         CategoryCatalogModel(
                //             idCategory:
                //                 widget.categoryCatalogModelArgument.idCategory,
                //             nameCategory:
                //                 textEditingControllerNameCategory.text,
                //             descriptionCategory:
                //                 textEditingControllerDescriptionCategory.text,
                //             parentIdCategory: parentIdCategory,
                //             parentCategoryName: '',
                //             displayOrder: int.tryParse(
                //                     textEditingControllerDisplayOrderCategory
                //                         .text) ??
                //                 0,
                //             deleted: deleted,
                //             idUserAppInstitution:
                //                 cUserAppInstitutionModel.idUserAppInstitution,
                //             imageData: tImageString,
                //             giveIdsFlatStructureModel:
                //                 GiveIdsFlatStructureModel(
                //               idFinalizzazione: int.tryParse(
                //                       textEditingControllerIdFinalizzazione
                //                           .text) ??
                //                   0,
                //               idEvento: int.tryParse(
                //                       textEditingControllerIdEvento.text) ??
                //                   0,
                //               idAttivita: int.tryParse(
                //                       textEditingControllerIdAttivita.text) ??
                //                   0,
                //               idAgenda: int.tryParse(
                //                       textEditingControllerIdAgenda.text) ??
                //                   0,
                //               idComunicazioni: int.tryParse(
                //                       textEditingControllerIdComunicazioni
                //                           .text) ??
                //                   0,
                //               idTipDonazione: int.tryParse(
                //                       textEditingControllerIdTipDonazione
                //                           .text) ??
                //                   0,
                //               idCatalogo: int.tryParse(
                //                       textEditingControllerIdCatalogo.text) ??
                //                   0,
                //             ));

                //     categoryCatalogNotifier
                //         .addOrUpdateCategory(
                //             context: context,
                //             token: authenticationNotifier.token,
                //             categoryCatalogModel: categoryCatalogModel)
                //         .then((value) {
                //       if (value) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //             SnackUtil.stylishSnackBar(
                //                 title: "Categorie",
                //                 message: "Informazioni aggiornate",
                //                 contentType: "success"));
                //         Navigator.of(context).pop();
                //         // categoryCatalogNotifier.refresh();
                //       } else {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //             SnackUtil.stylishSnackBar(
                //                 title: "Categorie",
                //                 message: "Errore di connessione",
                //                 contentType: "failure"));
                //         Navigator.of(context).pop();
                //       }
                //     });
                //   },
                //   noCallBack: () {},
                // );
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) => dialog);
              },
              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.delete),
            ),
          )
        ]));
  }

  // Future<void> _onSearchChanged(String value) async {
  //   final List<String> results = await _suggestionCallback(value);
  //   setState(() {
  //     _suggestions = results
  //         .where((String topping) => !_toppings.contains(topping))
  //         .toList();
  //   });
  // }

  // FutureOr<List<String>> _suggestionCallback(String text) {
  //   if (text.isNotEmpty) {
  //     return _pizzaToppings.where((String topping) {
  //       return topping.toLowerCase().contains(text.toLowerCase());
  //     }).toList();
  //   }
  //   return const <String>[];
  // }
}
