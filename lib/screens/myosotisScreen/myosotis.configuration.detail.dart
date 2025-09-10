import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/functional.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.chips.input/custom.chips.input.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/myosotis.configuration.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/myosotis.configuration.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/myosotisScreen/myosotis.configuration.detail.widget/myosotis.configuration.detail.widget.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:string_similarity/string_similarity.dart';
import 'package:uiblock/uiblock.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final FocusNode chipFocusNode = FocusNode();
  final ValueNotifier<bool> createMyosotisConfigurationValidNotifier =
      ValueNotifier(false);
  ValueNotifier<bool> isButtonNoAmountTextEnabledNotifier =
      ValueNotifier(false);
  ValueNotifier<bool> isSetContinuousDonationAsPreferedEnabledNotifier =
      ValueNotifier(false);

  bool isEdit = false;
  bool isLoading = true;
  bool isLoadingDetailEmpty = true;
  bool isLoadingDetail = true;

  ValueNotifier<List<String>> selectedFrequenciesNotifier = ValueNotifier([]);

  List<String> idGiveFromProjectOrFixedOption = [
    'Id Give da prodotti',
    'Id Give fissi'
  ];

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

  //URL CONFIGURATION
  late List<String> enabledUrlMyosotisConfiguration = [];

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

  //BUTTON COLOR CONFIGURATION-VALUE
  late ValueNotifier<Color> buttonColorNotifier =
      ValueNotifier<Color>(Colors.red);

  //FONT STYLE CONFIGURATION-VALUE
  late ValueNotifier<String> formFontNotifier = ValueNotifier<String>('Roboto');

  //FORM STARTUP CONFIGURATION-AVAILABLE VALUE
  late List<String> preetablishedFormStartup = [];

  //SHOW PREESTABLISHED AMOUNTS DONATION CONFIGURATION  - SINGLE DONATION
  final ValueNotifier<bool> showPreestablishedAmountNotifier =
      ValueNotifier<bool>(false);

  //PREESTABLISHED AMOUNTS CONFIGURATION  - SINGLE DONATION
  late List<String> preetablishedAmounts = [];

  //SHOW FREE PRICE CONFIGURATION - SINGLE DONATION
  final ValueNotifier<bool> showFreePriceNotifier = ValueNotifier<bool>(false);

  //SHOW FREQUENCY CONTINUOUS DONATION CONFIGURATION
  final ValueNotifier<bool> showContinuousDonationNotifier =
      ValueNotifier<bool>(false);

  //AVAILABLE FREQUENCY CONTINUOUS DONATION CONFIGURATION
  List<String> availableFrequencyContinuousDonation = [];

  //FREQUENCY CONTINUOUS DONATION CONFIGURATION
  List<FrequencyContinuousDonation> frequencyContinuousDonation = [];

  //BUTTON TEXT NO AMOUNTS
  late final TextEditingController
      buttonNoAmountsTextMyosotisConfigurationController;

  //SET CONTINUOUS DONATION AS PREDEFINED CONFIGURATION
  final ValueNotifier<bool> setContinuousDonationAsPredefinedNotifier =
      ValueNotifier<bool>(false);

  //ID GIVE FROM PROJECT OR FIXED
  final ValueNotifier<String> idGiveFromProjectOrFixedValue =
      ValueNotifier<String>('');

  // //SHOW CAUSAL DONATION
  // final ValueNotifier<bool> showCausalDonationNotifier =
  //     ValueNotifier<bool>(false);

  //CAUSAL DONATION TEXT
  late final TextEditingController
      causalDonationTextMyosotisConfigurationController;

  //SUBCATEGORY CAUSAL DONATION CONFIGURATION-VALUE
  late int idSubCategoryCausalDonation;

  //SUBCATEGORY CAUSAL DONATION CONFIGURATION-AVAILABLE VALUE
  late List<SubCategoryShort> availableSubCategoryCausalDonation = [];

  //CUSTOM FIXED ID GIVE
  late List<String> customIdGive = [];

  //ID FORM GIVE
  late final TextEditingController idFormGiveConfigurationController;

  //SHOW PRIVACY CONFIGURATION
  final ValueNotifier<bool> showPrivacyNotifier = ValueNotifier<bool>(false);

  //TEXT PRIVACY CONFIGURATION
  late final TextEditingController textPrivacyMyosotisConfigurationController;

  //URL PRIVACY CONFIGURATION
  late final TextEditingController urlPrivacyMyosotisConfigurationController;

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

  //PAYMENT MANAGER CONFIGURATION-AVAILABLE VALUE
  late List<String> availablePaymentManager = [];

  //PAYMENT MANAGER APP CONFIGURATION
  late String? paymentManager;

  //THANK YOU CONFIGURATION-VALUE
  final ValueNotifier<String> thankYouMethod = ValueNotifier<String>('');

  //THANK YOU CONFIGURATION-AVAILABLE VALUE
  late List<String> availableThankYouMethod = [];

  //TRANSACTIONAL SENDING-VALUE
  late int idTransactionalSending;

  //TRANSACTIONAL SENDING-AVAILABLE VALUE
  late List<TransactionalSendingShort> availableTransactionalSending = [];

  //ID WA MESSAGE TO SEND
  late TextEditingController waTemplateNameController;

  //THANK YOU END MESSAGE
  late final TextEditingController tyEndMessageMyosotisConfigurationController;

  //OPTIONAL FIELDS CONFIGURATION
  List<OptionalField> optionalField = [];

  //OPTIONAL FIELDS CONFIGURATION
  List<String> availableTypeOptionalField = [];

  //OPTIONAL FIELDS CONFIGURATION
  List<String> availableTextTypeOptionalField = [];

  void _showColorPicker() {
    Color tempColor = buttonColorNotifier.value; // copia temporanea del colore

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scegli un colore'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color; // aggiorna la copia temporanea
              },
              pickerAreaBorderRadius:
                  const BorderRadius.all(Radius.circular(12)),
              paletteType: PaletteType.hsl,
              labelTypes: [
                ColorLabelType.rgb,
                ColorLabelType.hsv,
                ColorLabelType.hex,
              ],
              displayThumbColor: true,
              pickerAreaHeightPercent: 0.7,
              colorPickerWidth: 300,
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Annulla'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300],
              ),
              onPressed: () {
                Navigator.of(context).pop(); // chiude senza salvare
              },
            ),
            ElevatedButton(
              child: const Text('Conferma'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
              ),
              onPressed: () {
                buttonColorNotifier.value =
                    tempColor; // salva il colore selezionato
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFontPicker() {
    final List<String> fontNames = GoogleFonts.asMap().keys.toList()..sort();
    final TextEditingController controller = TextEditingController();
    String? tempFont;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Scegli un Google Font'),
              content: SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return fontNames.where((font) => font
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (String font) {
                        controller.text = font;
                        setState(() => tempFont = font);
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 220,
                            child: Material(
                              elevation: 4.0,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final font = options.elementAt(index);
                                  return ListTile(
                                    title: Text(font),
                                    onTap: () => onSelected(font),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      fieldViewBuilder: (context, textEditingController,
                          focusNode, onFieldSubmitted) {
                        controller.text = textEditingController.text;
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Selezionare un font...',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey), // bordo quando non focus
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2), // bordo quando focus
                            ),
                          ),
                          onChanged: (value) {
                            if (fontNames.contains(value)) {
                              setState(() => tempFont = value);
                            } else {
                              setState(() => tempFont = null);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    if (tempFont != null)
                      Text(
                        'The quick brown fox jumps over the lazy dog',
                        style: GoogleFonts.getFont(tempFont!, fontSize: 20),
                      ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annulla'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                  ),
                  onPressed: tempFont != null
                      ? () {
                          formFontNotifier.value = tempFont!;
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Conferma'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void initializeControllers() {
    nameMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    descriptionMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    titleMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    subtitleMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    buttonNoAmountsTextMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    causalDonationTextMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    idFormGiveConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    textPrivacyMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    urlPrivacyMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
    textNewsletterMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);

    visiblePersonalFormFieldController.addListener(dataControllerListener);
    mandatoryPersonalFormFieldController.addListener(dataControllerListener);

    visibleCompanyFormFieldController.addListener(dataControllerListener);
    mandatoryCompanyFormFieldController.addListener(dataControllerListener);
    paymentMethodAppController.addListener(dataControllerListener);
    paymentMethodWebController.addListener(dataControllerListener);

    waTemplateNameController = TextEditingController()
      ..addListener(dataControllerListener);
    tyEndMessageMyosotisConfigurationController = TextEditingController()
      ..addListener(dataControllerListener);
  }

  void disposeControllers() {
    nameMyosotisConfigurationController.dispose();
    descriptionMyosotisConfigurationController.dispose();
    titleMyosotisConfigurationController.dispose();
    subtitleMyosotisConfigurationController.dispose();
    buttonNoAmountsTextMyosotisConfigurationController.dispose();
    causalDonationTextMyosotisConfigurationController.dispose();
    idFormGiveConfigurationController.dispose();
    textPrivacyMyosotisConfigurationController.dispose();
    urlPrivacyMyosotisConfigurationController.dispose();
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

    waTemplateNameController.dispose();
    tyEndMessageMyosotisConfigurationController.dispose();
  }

  void dataControllerListener() {}

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

    //TITLE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.title =
        myosotisConfigurationDetailModel.title;

    //SUBTITLE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.subtitle =
        myosotisConfigurationDetailModel.subtitle;

    //FORM STARTUP CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .typeFormStartup = myosotisConfigurationDetailModel.typeFormStartup;

    //BUTTON COLOR CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.buttonColor =
        myosotisConfigurationDetailModel.buttonColor;

    //FONT STYLE CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.formFont =
        myosotisConfigurationDetailModel.formFont;

    //SHOW PREESTABLISHED AMOUNTS DONATION CONFIGURATION  - SINGLE DONATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .showPreestablishedAmount =
        myosotisConfigurationDetailModel.showPreestablishedAmount;

    //PREESTABLISHED AMOUNTS CONFIGURATION - SINGLE DONATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .preestablishedAmount =
        myosotisConfigurationDetailModel.preestablishedAmount;

    //SHOW FREE PRICE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .showFreePrice = myosotisConfigurationDetailModel.showFreePrice;

    //SHOW FREQUENCY CONTINUOUS DONATION CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .showContinuousDonation =
        myosotisConfigurationDetailModel.showContinuousDonation;

    //AVAILABLE FREQUENCY CONTINUOUS DONATION CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .frequencyContinuousDonation =
        myosotisConfigurationDetailModel.frequencyContinuousDonation;

    //BUTTON TEXT NO AMOUNTS CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .buttonNoAmountsText =
        myosotisConfigurationDetailModel.buttonNoAmountsText;

    //SET CONTINUOUS DONATION AS PREDEFINED CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .setContinuousDonationAsPredefined =
        myosotisConfigurationDetailModel.setContinuousDonationAsPredefined;

    // //SHOW CAUSAL DONATION
    // widget.myosotisConfiguration.myosotisConfigurationDetailModel
    //         .showCausalDonation =
    //     myosotisConfigurationDetailModel.showCausalDonation;

    //ID GIVE FROM PROJECT OR FIXED
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .idGiveFromProjectOrFixedValue =
        myosotisConfigurationDetailModel.idGiveFromProjectOrFixedValue;

    //CUSTOM ID GIVE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.customIdGive =
        myosotisConfigurationDetailModel.customIdGive;

    //ID FORM GIVE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.idFormGive =
        myosotisConfigurationDetailModel.idFormGive;

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

    //URL PRIVACY CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.urlPrivacy =
        myosotisConfigurationDetailModel.urlPrivacy;

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

    //PAYMENT MANAGER CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .paymentManager = myosotisConfigurationDetailModel.paymentManager;

    //THANK YOU CONFIGURATION-VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .thankYouMethod = myosotisConfigurationDetailModel.thankYouMethod;

    //TRANSACTIONAL SENDING VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
            .idTransactionalSending =
        myosotisConfigurationDetailModel.idTransactionalSending;

    //ID WA MESSAGE TO SEND VALUE
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .waTemplateName = myosotisConfigurationDetailModel.waTemplateName;

    //THANK YOU END MESSAGE CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel.tyEndMessage =
        myosotisConfigurationDetailModel.tyEndMessage;

    //OPTIONAL FIELDS CONFIGURATION
    widget.myosotisConfiguration.myosotisConfigurationDetailModel
        .optionalField = myosotisConfigurationDetailModel.optionalField;
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

    //URL CONFIGURATION
    enabledUrlMyosotisConfiguration = new List<String>.from(
        widget.myosotisConfiguration.enabledUrlMyosotisConfiguration);

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

    //BUTTON COLOR CONFIGURATION-VALUE
    int rawColor = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.buttonColor;
    Color colorToUse;
    if (isValidColor(rawColor)) {
      colorToUse = Color(rawColor);
    } else {
      colorToUse = Colors.red; // Colore di default se non valido
    }
    buttonColorNotifier.value = colorToUse;

    //FONT STYLE CONFIGURATION-VALUE
    String rawFont =
        widget.myosotisConfiguration.myosotisConfigurationDetailModel.formFont;
    String fontToUse;
    if (isValidFont(rawFont)) {
      fontToUse = rawFont;
    } else {
      fontToUse = 'Roboto'; // Font di default se non valido
    }
    formFontNotifier.value = fontToUse;

    //FORM STARTUP CONFIGURATION-AVAILABLE VALUE
    preetablishedFormStartup =
        myosotisConfigurationDetailEmpty.availableFormStartup;

    //SHOW PREESTABLISHED AMOUNTS DONATION CONFIGURATION  - SINGLE DONATION
    showPreestablishedAmountNotifier.value = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.showPreestablishedAmount;

    //PREESTABLISHED AMOUNTS CONFIGURATION - SINGLE DONATION
    preetablishedAmounts = new List<String>.from(widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.preestablishedAmount);

    //SHOW FREE PRICE CONFIGURATION - SINGLE DONATION
    showFreePriceNotifier.value = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.showFreePrice;

    //SHOW FREQUENCY CONTINUOUS DONATION CONFIGURATION
    showContinuousDonationNotifier.value = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.showContinuousDonation;

    //AVAILABLE FREQUENCY CONTINUOUS DONATION CONFIGURATION
    availableFrequencyContinuousDonation =
        myosotisConfigurationDetailEmpty.availableFrequencyContinuousDonation;

    //FREQUENCY CONTINUOUS DONATION CONFIGURATION
    frequencyContinuousDonation = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.frequencyContinuousDonation;

    //SET CONTINUOUS DONATION AS PREDEFINED CONFIGURATION
    setContinuousDonationAsPredefinedNotifier.value = widget
        .myosotisConfiguration
        .myosotisConfigurationDetailModel
        .setContinuousDonationAsPredefined;

    //BUTTON TEXT NO AMOUNTS CONFIGURATION
    buttonNoAmountsTextMyosotisConfigurationController.text = widget
        .myosotisConfiguration
        .myosotisConfigurationDetailModel
        .buttonNoAmountsText;

    // //SHOW CAUSAL DONATION
    // showCausalDonationNotifier.value = widget.myosotisConfiguration
    //     .myosotisConfigurationDetailModel.showCausalDonation;

    //ID GIVE FROM PROJECT OR FIXED
    idGiveFromProjectOrFixedValue.value = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.idGiveFromProjectOrFixedValue;
    if (idGiveFromProjectOrFixedValue.value.isEmpty) {
      idGiveFromProjectOrFixedValue.value = "Id Give da prodotti";
    }
    //CUSTOM ID GIVE
    customIdGive = new List<String>.from(widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.customIdGive);

    //ID FORM GIVE
    idFormGiveConfigurationController.text = widget.myosotisConfiguration
                .myosotisConfigurationDetailModel.idFormGive ==
            0
        ? ""
        : widget
            .myosotisConfiguration.myosotisConfigurationDetailModel.idFormGive
            .toString();

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

    //URL PRIVACY CONFIGURATION
    urlPrivacyMyosotisConfigurationController.text = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.urlPrivacy;

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

    //PAYMENT MANAGER CONFIGURATION-AVAILABLE VALUE
    availablePaymentManager =
        myosotisConfigurationDetailEmpty.availablePaymentManager;

    //PAYMENT MANAGER CONFIGURATION-VALUE
    paymentManager = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.paymentManager;

    //THANK YOU CONFIGURATION-VALUE
    thankYouMethod.value = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.thankYouMethod;
    if (thankYouMethod.value.isEmpty) {
      thankYouMethod.value = "Nessun ringraziamento";
    }

    //THANK YOU CONFIGURATION-AVAILABLE VALUE
    availableThankYouMethod =
        myosotisConfigurationDetailEmpty.availableThankYouMethod;

    //TRANSACTIONAL SENDING-AVAILABLE VALUE
    idTransactionalSending = widget.myosotisConfiguration
        .myosotisConfigurationDetailModel.idTransactionalSending;

    //TRANSACTIONAL SENDING-AVAILABLE VALUE
    availableTransactionalSending =
        myosotisConfigurationDetailEmpty.availableTransactionalSending;

    //ID WA MESSAGE TO SEND
    waTemplateNameController.text = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.waTemplateName;

    //THANK YOU END MESSAGE CONFIGURATION-VALUE
    tyEndMessageMyosotisConfigurationController.text = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.tyEndMessage;

    //OPTIONAL FIELD CONFIGURATION
    optionalField = widget
        .myosotisConfiguration.myosotisConfigurationDetailModel.optionalField;

    //AVAILABLE TYPE OPTIONAL FIELDS CONFIGURATION
    availableTypeOptionalField =
        myosotisConfigurationDetailEmpty.availableTypeOptionalField;

    //AVAILABLE TEXT TYPE OPTIONAL FIELDS CONFIGURATION
    availableTextTypeOptionalField =
        myosotisConfigurationDetailEmpty.availableTextTypeOptionalField;
    if (isEdit) {
      //MASTER

      //DETAIL
    } else {}

    isButtonNoAmountTextEnabledNotifier = ValueNotifier<bool>(
        !showPreestablishedAmountNotifier.value &&
            !showContinuousDonationNotifier.value);
    isSetContinuousDonationAsPreferedEnabledNotifier = ValueNotifier<bool>(
        showPreestablishedAmountNotifier.value &&
            showContinuousDonationNotifier.value);
  }

  void updateAdditionalControlNotifier() {
    final shouldEnableNoAmountText = !showPreestablishedAmountNotifier.value &&
        !showContinuousDonationNotifier.value;
    isButtonNoAmountTextEnabledNotifier.value = shouldEnableNoAmountText;
    if (!shouldEnableNoAmountText) {
      buttonNoAmountsTextMyosotisConfigurationController.text = "";
    }
    final shouldEnableSetContinuosDonationAsPrefered =
        showPreestablishedAmountNotifier.value &&
            showContinuousDonationNotifier.value;
    isSetContinuousDonationAsPreferedEnabledNotifier.value =
        shouldEnableSetContinuosDonationAsPrefered;
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

// Funzione helper per verificare se il colore è valido
  bool isValidColor(int colorValue) {
    // Per esempio, controlla che non sia null e che rientri nell'intervallo dei colori ARGB validi
    return colorValue != null &&
        colorValue > 0x00000000 &&
        colorValue <= 0xFFFFFFFF;
  }

// Funzione helper per verificare se il font è valido
  bool isValidFont(String fontValue) {
    try {
      // Proviamo a ottenere il font
      if (fontValue.isNotEmpty) {
        final textStyle = GoogleFonts.getFont(fontValue);
      } else {
        return false;
      }
      // Se la chiamata va a buon fine, il font è valido
      return true;
    } catch (e) {
      // Se c'è un errore, significa che il font non è valido
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    getMyosotisConfigurationData();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Widget chipBuilderIdDevice(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'idDevice'),
      onSelected: (data) => onChipTapped(data, 'idDevice'),
    );
  }

  Widget chipBuilderUrl(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'url'),
      onSelected: (data) => onChipTapped(data, 'url'),
    );
  }

  Widget chipBuilderPreetablishedAmounts(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'preetablishedAmounts'),
      onSelected: (data) => onChipTapped(data, 'preetablishedAmounts'),
    );
  }

  Widget chipBuilderCustomIdGive(BuildContext context, String topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: (data) => onChipDeleted(data, 'customIdGive'),
      onSelected: (data) => onChipTapped(data, 'customIdGive'),
    );
  }

  void onChipTapped(String topping, String area) {}

  void onChipDeleted(String topping, String area) {
    setState(() {
      if (area == 'idDevice') {
        enabledDeviceMyosotisConfiguration.remove(topping);
      } else if (area == 'url') {
        enabledUrlMyosotisConfiguration.remove(topping);
      } else if (area == 'preetablishedAmounts') {
        preetablishedAmounts.remove(topping);
      } else if (area == 'customIdGive') {
        customIdGive.remove(topping);
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
        // _chipFocusNode.unfocus();
        // setState(() {
        //   enabledDeviceMyosotisConfiguration = <String>[];
        // });
      }
    } else if (area == 'url') {
      if (text.trim().isNotEmpty) {
        setState(() {
          enabledUrlMyosotisConfiguration = <String>[
            ...enabledUrlMyosotisConfiguration,
            text.trim()
          ];
        });
      } else {
        // _chipFocusNode.unfocus();
        // setState(() {
        //   enabledUrlMyosotisConfiguration = <String>[];
        // });
      }
    } else if (area == 'preestablishedAmount') {
      if (text.trim().isNotEmpty) {
        setState(() {
          preetablishedAmounts = <String>[...preetablishedAmounts, text.trim()];
        });
      } else {
        // _chipFocusNode.unfocus();
        // setState(() {
        //   preetablishedAmounts = <String>[];
        // });
      }
    } else if (area == 'customIdGive') {
      if (text.trim().isNotEmpty) {
        bool isOk = false;
        String input = text.trim();
        try {
          var splitOnEqual = input.split('=');

          //CONTROL FOR INT OR STRING
          bool canContinue = false;
          if (splitOnEqual.length == 2) {
            final bestMatch = StringSimilarity.findBestMatch(
                splitOnEqual[0].toLowerCase(), idGiveListNameMyosotis);

            if (bestMatch.bestMatch.rating != null) {
              if (bestMatch.bestMatch.rating! > 0.40) {
                String finalString =
                    bestMatch.bestMatch.target! + "=" + splitOnEqual[1];
                if (finalString.startsWith('Id') &&
                    num.tryParse(splitOnEqual[1]) != null) {
                  canContinue = true;
                } else if (finalString.startsWith('Codice') &&
                    splitOnEqual[1].isNotEmpty) {
                  canContinue = true;
                } else if (finalString.startsWith('FonteSh') &&
                    num.tryParse(splitOnEqual[1]) != null) {
                  canContinue = true;
                } else if (finalString.startsWith('Ringraziato') &&
                    ["0", "1"].contains(splitOnEqual[1])) {
                  canContinue = true;
                }
                if (canContinue) {
                  if (!customIdGive.any((item) => item
                      .toLowerCase()
                      .contains(bestMatch.bestMatch.target!.toLowerCase()))) {
                    setState(() {
                      customIdGive = <String>[...customIdGive, finalString];
                    });
                    isOk = true;
                  }
                }
              }
            }
          }

          if (!isOk) {
            ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                title: "Configurazione Myosotis",
                message:
                    "Parametro Id Give non trovato, non corretto o già presente",
                contentType: "warning"));
          }
        } catch (e) {}
      } else {
        // _chipFocusNode.unfocus();
        // setState(() {
        //   giveIds = <String>[];
        // });
      }
    }
  }

  void onChanged(List<String> data, String area) {
    setState(() {
      if (area == 'idDevice') {
        enabledDeviceMyosotisConfiguration = data;
      } else if (area == 'url') {
        enabledUrlMyosotisConfiguration = data;
      } else if (area == 'preestablishedAmount') {
        preetablishedAmounts = data;
      } else if (area == 'customIdGive') {
        customIdGive = data;
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
                              onChanged: (_) => {},
                              //_formKey.currentState?.validate(),
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
                          controller:
                              descriptionMyosotisConfigurationController,
                          labelText:
                              AppStrings.descriptionMyosotisConfiguration,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => {}
                          // _formKey.currentState?.validate(),
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
                        padding: const EdgeInsets.all(8),
                        child: ChipsInput<String>(
                          values: enabledUrlMyosotisConfiguration,
                          label: AppStrings.urlMyosotisConfiguration,
                          strutStyle: const StrutStyle(fontSize: 12),
                          onChanged: (data) => onChanged(data, 'url'),
                          onSubmitted: (data) => onSubmitted(data, 'url'),
                          chipBuilder: chipBuilderUrl,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(height: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ImagePickerCard(
                            label: 'Immagine di sfondo grande',
                            imageBase64: bigImageString,
                            onPick: (img) =>
                                setState(() => bigImageString = img),
                          ),
                          ImagePickerCard(
                            label: 'Immagine di sfondo piccola',
                            imageBase64: smallImageString,
                            onPick: (img) =>
                                setState(() => smallImageString = img),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                                enabled: true,
                                controller:
                                    titleMyosotisConfigurationController,
                                labelText:
                                    AppStrings.titleMyosotisConfiguration,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => {}
                                // _formKey.currentState?.validate(),
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
                          onChanged: (_) => {}
                          // _formKey.currentState?.validate(),
                          // validator: (value) {
                          //   return value!.isNotEmpty
                          //       ? null
                          //       : AppStrings
                          //           .pleaseEnterTitleMyosotisConfiguration;
                          // },
                          ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: typeFormStartup,
                              labelText:
                                  AppStrings.formStartupMyosotisConfiguration,
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
                          ),
                          SizedBox(
                            width: 200,
                            child: ValueListenableBuilder<Color>(
                              valueListenable: buttonColorNotifier,
                              child: Text(
                                'Colore bottoni: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: Colors.blueGrey),
                              ),
                              builder: (BuildContext context, Color value,
                                  Widget? child) {
                                return InkWell(
                                  onTap: _showColorPicker,
                                  child: Tooltip(
                                    message: 'Seleziona un colore',
                                    child: Container(
                                      // opzionale: margine esterno
                                      padding:
                                          EdgeInsets.all(8), // spazio interno
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // oppure Theme.of(context).cardColor
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10),
                                          child!, // il Text passato come child
                                          SizedBox(width: 20),
                                          Container(
                                            width: 32,
                                            height: 32,
                                            color: value,
                                          ),
                                          SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 250,
                            child: ValueListenableBuilder<String>(
                              valueListenable: formFontNotifier,
                              builder: (BuildContext context, String value,
                                  Widget? child) {
                                return InkWell(
                                  onTap: _showFontPicker,
                                  child: Tooltip(
                                    message: 'Seleziona un font',
                                    child: Container(
                                      height: 48,
                                      // opzionale: margine esterno
                                      padding:
                                          EdgeInsets.all(8), // spazio interno
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // oppure Theme.of(context).cardColor
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10),
                                          Text(
                                            'Font: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                    color: Colors.blueGrey),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            ' ${value}',
                                            style: GoogleFonts.getFont(value),
                                          ),
                                          SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: showPreestablishedAmountNotifier,
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                  title:
                                      Text(AppStrings.showPreestablishedAmount),
                                  value: value,
                                  onChanged: (bool? newValue) {
                                    showPreestablishedAmountNotifier.value =
                                        newValue ?? false;
                                    updateAdditionalControlNotifier();
                                    if (!showPreestablishedAmountNotifier
                                        .value) {
                                      showFreePriceNotifier.value = false;
                                      setState(() {
                                        preetablishedAmounts.clear();
                                      });
                                    }
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: showPreestablishedAmountNotifier,
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: value
                                        ? Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: ChipsInput<String>(
                                                    values:
                                                        preetablishedAmounts,
                                                    label: AppStrings
                                                        .preestablishedAmount,
                                                    decoration:
                                                        const InputDecoration(),
                                                    strutStyle:
                                                        const StrutStyle(
                                                            fontSize: 12),
                                                    onChanged: (data) {
                                                      onChanged(data,
                                                          'preestablishedAmount');
                                                    },
                                                    onSubmitted: (data) {
                                                      onSubmitted(data,
                                                          'preestablishedAmount');
                                                    },
                                                    chipBuilder:
                                                        chipBuilderPreetablishedAmounts,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: ValueListenableBuilder<
                                                        bool>(
                                                    valueListenable:
                                                        showFreePriceNotifier,
                                                    builder: (context, value,
                                                        child) {
                                                      return CheckboxListTile(
                                                          title: SizedBox(
                                                              width: 100,
                                                              child: Text(AppStrings
                                                                  .showFreePriceConfiguration)),
                                                          value: value,
                                                          onChanged:
                                                              (bool? value) {
                                                            showFreePriceNotifier
                                                                    .value =
                                                                value ?? false;
                                                            updateAdditionalControlNotifier();
                                                          },
                                                          controlAffinity:
                                                              ListTileControlAffinity
                                                                  .leading);
                                                    }),
                                              ),
                                            ],
                                          )
                                        : SizedBox(
                                            height:
                                                76), // Contenitore vuoto che occupa lo spazio senza causare problemi
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: showContinuousDonationNotifier,
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                  title:
                                      Text(AppStrings.showContinuousDonation),
                                  value: value,
                                  onChanged: (bool? newValue) {
                                    showContinuousDonationNotifier.value =
                                        newValue ?? false;
                                    updateAdditionalControlNotifier();
                                    if (!showContinuousDonationNotifier.value &&
                                        frequencyContinuousDonation
                                            .isNotEmpty) {
                                      frequencyContinuousDonation.clear();
                                    }
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: showContinuousDonationNotifier,
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1000),
                              child: value
                                  ? FrequencyDonationAmountList(
                                      frequencyContinuousDonationList:
                                          frequencyContinuousDonation,
                                      availableFrequencies:
                                          availableFrequencyContinuousDonation,
                                      onChanged: (updatedList) {
                                        setState(() {
                                          frequencyContinuousDonation =
                                              updatedList;
                                        });
                                      },
                                    )
                                  : Container(), // Contenitore vuoto che occupa lo spazio senza causare problemi
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isButtonNoAmountTextEnabledNotifier,
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1000),
                              child: value
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: ValueListenableBuilder<bool>(
                                            valueListenable:
                                                isButtonNoAmountTextEnabledNotifier,
                                            builder: (context, isEnabled, _) {
                                              return CustomTextFormField(
                                                enabled: isEnabled,
                                                controller:
                                                    buttonNoAmountsTextMyosotisConfigurationController,
                                                labelText: AppStrings
                                                    .buttonNoAmountsText,
                                                keyboardType:
                                                    TextInputType.name,
                                                textInputAction:
                                                    TextInputAction.next,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(), // Contenitore vuoto che occupa lo spazio senza causare problemi
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable:
                            isSetContinuousDonationAsPreferedEnabledNotifier,
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1000),
                              child: value
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: ValueListenableBuilder<bool>(
                                            valueListenable:
                                                setContinuousDonationAsPredefinedNotifier,
                                            builder: (context, value, child) {
                                              return CheckboxListTile(
                                                title: Text(AppStrings
                                                    .setContinuousDonationAsPredefined),
                                                value: value,
                                                onChanged: (bool? newValue) {
                                                  setContinuousDonationAsPredefinedNotifier
                                                          .value =
                                                      newValue ?? false;
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(), // Contenitore vuoto che occupa lo spazio senza causare problemi
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // allinea a sinistra
                                          mainAxisAlignment: MainAxisAlignment
                                              .start, // in alto
                                          children: [
                                            ValueListenableBuilder<String?>(
                                              valueListenable:
                                                  idGiveFromProjectOrFixedValue,
                                              builder: (context, value, _) {
                                                return Column(
                                                  children: [
                                                    RadioListTile<String>(
                                                      value:
                                                          idGiveFromProjectOrFixedOption[
                                                              0],
                                                      groupValue: value,
                                                      onChanged: (val) =>
                                                          idGiveFromProjectOrFixedValue
                                                              .value = val!,
                                                      title: Text(
                                                        idGiveFromProjectOrFixedOption[
                                                            0],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: value ==
                                                                  idGiveFromProjectOrFixedOption[
                                                                      0]
                                                              ? CustomColors
                                                                  .darkBlue
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      // subtitle:
                                                      //     Text('Descrizione opzione 1'),
                                                      activeColor:
                                                          CustomColors.darkBlue,
                                                      // tileColor: Colors.grey[100],
                                                      // selectedTileColor: Colors.red[50],
                                                      selected: value ==
                                                          idGiveFromProjectOrFixedOption[
                                                              0],
                                                      // shape: RoundedRectangleBorder(
                                                      //   borderRadius:
                                                      //       BorderRadius.circular(12),
                                                      //   side: BorderSide(
                                                      //       color: Colors.blue),
                                                      // ),
                                                      // contentPadding:
                                                      //     EdgeInsets.symmetric(
                                                      //         horizontal: 16,
                                                      //         vertical: 8),
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                    ),
                                                    RadioListTile<String>(
                                                      value:
                                                          idGiveFromProjectOrFixedOption[
                                                              1],
                                                      groupValue: value,
                                                      onChanged: (val) =>
                                                          idGiveFromProjectOrFixedValue
                                                              .value = val!,
                                                      title: Text(
                                                        idGiveFromProjectOrFixedOption[
                                                            1],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: value ==
                                                                  idGiveFromProjectOrFixedOption[
                                                                      1]
                                                              ? CustomColors
                                                                  .darkBlue
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      // subtitle:
                                                      //     Text('Descrizione opzione 2'),
                                                      activeColor:
                                                          CustomColors.darkBlue,
                                                      // tileColor: Colors.grey[100],
                                                      // selectedTileColor: Colors.green[50],
                                                      selected: value ==
                                                          idGiveFromProjectOrFixedOption[
                                                              1],
                                                      // shape: RoundedRectangleBorder(
                                                      //   borderRadius:
                                                      //       BorderRadius.circular(12),
                                                      //   side: BorderSide(
                                                      //       color: Colors.blue),
                                                      // ),
                                                      // contentPadding:
                                                      //     EdgeInsets.symmetric(
                                                      //         horizontal: 16,
                                                      //         vertical: 8),
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          children: [
                                            ValueListenableBuilder<String?>(
                                              valueListenable:
                                                  idGiveFromProjectOrFixedValue,
                                              builder: (context, value, _) {
                                                return AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  child: idGiveFromProjectOrFixedValue
                                                              .value ==
                                                          idGiveFromProjectOrFixedOption[
                                                              0]
                                                      ? Container(
                                                          key: ValueKey(value),
                                                          // height: 145,
                                                          // padding: EdgeInsets.all(8),
                                                          // color: Colors.grey[200],
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        CustomTextFormField(
                                                                      enabled:
                                                                          true,
                                                                      controller:
                                                                          causalDonationTextMyosotisConfigurationController,
                                                                      labelText:
                                                                          AppStrings
                                                                              .causalDonationText,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .name,
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      // onChanged: (_) =>
                                                                      // _formKey
                                                                      //     .currentState
                                                                      //     ?.validate(),
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
                                                                    child:
                                                                        CustomDropDownButtonFormField(
                                                                      enabled:
                                                                          true,
                                                                      actualValue:
                                                                          idSubCategoryCausalDonation,
                                                                      labelText:
                                                                          AppStrings
                                                                              .availableSubCategoryCausalDonation,
                                                                      listOfValue: availableSubCategoryCausalDonation
                                                                          .map((value) => DropdownMenuItem(
                                                                              child: Text(value.nameSubCategory),
                                                                              value: value.idSubCategory))
                                                                          .toList(),
                                                                      onItemChanged:
                                                                          (value) {
                                                                        idSubCategoryCausalDonation =
                                                                            value;
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
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          key: ValueKey(value),
                                                          // height: 145,
                                                          // padding: EdgeInsets.all(8),
                                                          // color: Colors.blueAccent[200],
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 50,
                                                                    child:
                                                                        Tooltip(
                                                                      message: idGiveListNameMyosotis
                                                                          .join(
                                                                              "\n"),
                                                                      preferBelow:
                                                                          false,
                                                                      verticalOffset:
                                                                          12,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              16),
                                                                      child: Icon(
                                                                          Icons
                                                                              .help_outline),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              8),
                                                                      child: ChipsInput<
                                                                          String>(
                                                                        values:
                                                                            customIdGive,
                                                                        label: AppStrings
                                                                            .giveIds,
                                                                        decoration:
                                                                            const InputDecoration(),
                                                                        strutStyle:
                                                                            const StrutStyle(fontSize: 12),
                                                                        onChanged: (data) => onChanged(
                                                                            data,
                                                                            'customIdGive'),
                                                                        onSubmitted: (data) => onSubmitted(
                                                                            data,
                                                                            'customIdGive'),
                                                                        chipBuilder:
                                                                            chipBuilderCustomIdGive,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomTextFormField(
                                          enabled: true,
                                          controller:
                                              idFormGiveConfigurationController,
                                          labelText: AppStrings
                                              .idFormGiveMyosotisConfiguration,
                                          keyboardType: TextInputType.number,
                                          inputFormatter: [
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Allow only digits
                                          ],
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) => {},

                                          validator: (value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : AppStrings
                                                    .pleaseEnterIdFormGiveMyosotisConfiguration;
                                          },

                                          // _formKey.currentState?.validate(),
                                          // validator: (value) {
                                          //   return value!.isNotEmpty
                                          //       ? null
                                          //       : AppStrings
                                          //           .pleaseEnterTitleMyosotisConfiguration;
                                          // },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: SizedBox.shrink(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 8,
                              top: 4,
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  'Gestione Id Give',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            flex: 2,
                            child: CustomTextFormField(
                                enabled: true,
                                controller:
                                    textPrivacyMyosotisConfigurationController,
                                labelText:
                                    AppStrings.textPrivacyMyosotisConfiguration,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => {}
                                // _formKey.currentState?.validate(),
                                // validator: (value) {
                                //   return value!.isNotEmpty
                                //       ? null
                                //       : AppStrings
                                //           .pleaseEnterTextPrivacyMyosotisConfiguration;
                                // },
                                ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomTextFormField(
                                enabled: true,
                                controller:
                                    urlPrivacyMyosotisConfigurationController,
                                labelText:
                                    AppStrings.urlPrivacyMyosotisConfiguration,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => {}
                                // _formKey.currentState?.validate(),
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
                            flex: 4,
                            child: CustomTextFormField(
                                enabled: true,
                                controller:
                                    textNewsletterMyosotisConfigurationController,
                                labelText: AppStrings
                                    .textNewsletterMyosotisConfiguration,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => {}
                                // _formKey.currentState?.validate(),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                color: CustomColors.darkBlue),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                color: CustomColors.darkBlue),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                color: CustomColors.darkBlue),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                color: CustomColors.darkBlue),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                color: CustomColors.darkBlue),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Inserire modalità di pagamento APP';
                          //   }
                          //   return null;
                          // },
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                                color: CustomColors.darkBlue),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Inserire modalità di pagamento Web';
                          //   }
                          //   return null;
                          // },
                          onSelectionChange: (selectedItems) {},
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: paymentManager,
                              labelText: AppStrings
                                  .paymentManagerMyosotisConfiguration,
                              listOfValue: availablePaymentManager
                                  .map((value) => DropdownMenuItem(
                                      child: Text(value), value: value))
                                  .toList(),
                              onItemChanged: (value) {
                                paymentManager = value;
                              },
                              validator: (value) {
                                bool managerNotNeeded = true;
                                var cAppMethod = paymentMethodAppController
                                    .selectedItems
                                    .map((e) => e.value)
                                    .toList();
                                if (cAppMethod.contains("POS") ||
                                    cAppMethod.contains("NFC")) {
                                  managerNotNeeded = false;
                                  return value!.isNotEmpty
                                      ? null
                                      : AppStrings
                                          .pleaseEnterPaymentManagerMyosotisConfiguration;
                                }
                                var cWebMethod = paymentMethodWebController
                                    .selectedItems
                                    .map((e) => e.value)
                                    .toList();
                                if (cWebMethod.contains("Carta di credito")) {
                                  managerNotNeeded = false;
                                  return value!.isNotEmpty
                                      ? null
                                      : AppStrings
                                          .pleaseEnterPaymentManagerMyosotisConfiguration;
                                }
                                if (managerNotNeeded) {
                                  return value!.isNotEmpty
                                      ? AppStrings
                                          .paymentManagerNotNeededMyosotisConfiguration
                                      : null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              enabled: true,
                              controller:
                                  tyEndMessageMyosotisConfigurationController,
                              labelText: AppStrings.tyEndMessageConfiguration,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => {},
                              // _formKey.currentState?.validate(),
                              validator: (value) {
                                return value!.isNotEmpty
                                    ? null
                                    : AppStrings
                                        .pleaseEntertTyEndMessageConfiguration;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: thankYouMethod.value,
                              labelText: AppStrings
                                  .thankYouMethodMyosotisConfiguration,
                              listOfValue: availableThankYouMethod
                                  .map((value) => DropdownMenuItem(
                                      child: Text(value), value: value))
                                  .toList(),
                              onItemChanged: (value) {
                                thankYouMethod.value = value;
                                if (thankYouMethod.value ==
                                    availableThankYouMethod[0]) {
                                  idTransactionalSending = 0;
                                  waTemplateNameController.text = "";
                                } else if (thankYouMethod.value ==
                                    availableThankYouMethod[1]) {
                                  idTransactionalSending = 0;
                                } else if (thankYouMethod.value ==
                                    availableThankYouMethod[2]) {
                                  waTemplateNameController.text = "";
                                }
                              },
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                ValueListenableBuilder<String?>(
                                  valueListenable: thankYouMethod,
                                  builder: (context, value, _) {
                                    return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 1000),
                                      child: thankYouMethod.value ==
                                              availableThankYouMethod[0]
                                          ? SizedBox.shrink()
                                          : thankYouMethod.value ==
                                                  availableThankYouMethod[1]
                                              ? Container(
                                                  key: ValueKey(value),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                CustomDropDownButtonFormField(
                                                              enabled: true,
                                                              actualValue:
                                                                  idTransactionalSending,
                                                              labelText: AppStrings
                                                                  .availableTransactionalSending,
                                                              listOfValue: availableTransactionalSending
                                                                  .map((value) => DropdownMenuItem(
                                                                      child: Text(
                                                                          value
                                                                              .nameTransactionalSending),
                                                                      value: value
                                                                          .idTransactionalSending))
                                                                  .toList(),
                                                              onItemChanged:
                                                                  (value) {
                                                                idTransactionalSending =
                                                                    value;
                                                              },
                                                              validator:
                                                                  (value) {
                                                                if (thankYouMethod
                                                                        .value ==
                                                                    availableThankYouMethod[
                                                                        1]) {
                                                                  return (value!
                                                                              .isNotEmpty &&
                                                                          int.tryParse(value)! >
                                                                              0)
                                                                      ? null
                                                                      : AppStrings
                                                                          .pleaseEnterIdTransactionalSending;
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : CustomTextFormField(
                                                  enabled: true,
                                                  controller:
                                                      waTemplateNameController,
                                                  labelText: AppStrings
                                                      .waTemplateNameMyosotisConfiguration,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onChanged: (_) => {},
                                                  validator: (value) {
                                                    if (thankYouMethod.value ==
                                                        availableThankYouMethod[
                                                            2]) {
                                                      return (value!.isNotEmpty)
                                                          ? null
                                                          : AppStrings
                                                              .pleaseEnterWaTemplateNameMyosotisConfiguration;
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      OptionalFieldWidget(
                        optionalFieldList: optionalField,
                        availableTypeOptionalField: availableTypeOptionalField,
                        availableTextTypeOptionalField:
                            availableTextTypeOptionalField,
                        onChanged: (updatedList) {
                          setState(() {
                            optionalField = updatedList;
                          });
                        },
                      ),
                      SizedBox(height: 180),
                    ],
                  ),
                )),
        floatingActionButton: Wrap(direction: Axis.vertical, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  UIBlock.block(context);
                  MyosotisConfigurationDetailModel myosotisConfigurationDetailModel =
                      MyosotisConfigurationDetailModel(
                          typeFormStartup: typeFormStartup!,
                          buttonColor: buttonColorNotifier.value.toARGB32(),
                          formFont: formFontNotifier.value,
                          showLogo: showLogoNotifier.value,
                          bigImageString: bigImageString,
                          smallImageString: smallImageString,
                          title: titleMyosotisConfigurationController.text,
                          subtitle:
                              subtitleMyosotisConfigurationController.text,
                          showPreestablishedAmount:
                              showPreestablishedAmountNotifier.value,
                          preestablishedAmount: preetablishedAmounts,
                          showFreePrice: showFreePriceNotifier.value,
                          showContinuousDonation:
                              showContinuousDonationNotifier.value,
                          frequencyContinuousDonation:
                              frequencyContinuousDonation,
                          setContinuousDonationAsPredefined:
                              setContinuousDonationAsPredefinedNotifier.value,
                          buttonNoAmountsText: buttonNoAmountsTextMyosotisConfigurationController
                              .text,
                          showPrivacy: showPrivacyNotifier.value,
                          textPrivacy:
                              textPrivacyMyosotisConfigurationController.text,
                          urlPrivacy:
                              urlPrivacyMyosotisConfigurationController.text,
                          isMandatoryPrivacy: isMandatoryPrivacyNotifier.value,
                          showNewsletter: showNewsletterNotifier.value,
                          textNewsletter: textNewsletterMyosotisConfigurationController
                              .text,
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
                          visibleCompanyFormField:
                              visibleCompanyFormFieldController.selectedItems
                                  .map((e) => e.value)
                                  .toList(),
                          mandatoryCompanyFormField:
                              mandatoryCompanyFormFieldController.selectedItems
                                  .map((e) => e.value)
                                  .toList(),
                          preestablishedPaymentMethodApp:
                              paymentMethodAppController.selectedItems.map((e) => e.value).toList(),
                          preestablishedPaymentMethodWeb: paymentMethodWebController.selectedItems.map((e) => e.value).toList(),
                          paymentManager: paymentManager!,
                          // showCausalDonation: showCausalDonationNotifier.value,
                          causalDonationText: causalDonationTextMyosotisConfigurationController.text,
                          idSubCategoryCausalDonation: idSubCategoryCausalDonation,

                          //
                          idGiveFromProjectOrFixedValue: idGiveFromProjectOrFixedValue.value,
                          customIdGive: customIdGive,
                          idFormGive: int.parse(idFormGiveConfigurationController.text),
                          thankYouMethod: thankYouMethod.value,
                          idTransactionalSending: idTransactionalSending,
                          waTemplateName: waTemplateNameController.text,
                          tyEndMessage: tyEndMessageMyosotisConfigurationController.text,
                          optionalField: optionalField);

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
                          enabledUrlMyosotisConfiguration:
                              enabledUrlMyosotisConfiguration,
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
}
