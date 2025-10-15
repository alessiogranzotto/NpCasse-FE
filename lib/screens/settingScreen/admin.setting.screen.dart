// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:np_casse/app/constants/keys.dart';
// import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
// import 'package:np_casse/componenents/custom.text.form.field.dart';
// import 'package:np_casse/core/models/institution.model.dart';
// import 'package:np_casse/core/models/user.app.institution.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/notifiers/institution.attribute.admin.notifier.dart';
// import 'package:np_casse/core/notifiers/institution.attribute.institution.admin.notifier.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';
// import 'package:provider/provider.dart';

// class AdminSettingScreen extends StatefulWidget {
//   const AdminSettingScreen({super.key});
//   @override
//   State<AdminSettingScreen> createState() => _AdminSettingScreenState();
// }

// class _AdminSettingScreenState extends State<AdminSettingScreen> {
//   final _formKey1 = GlobalKey<FormState>();

//   final ValueNotifier<bool> giveValidNotifier = ValueNotifier(false);

//   late final TextEditingController giveNomeLoginController;
//   late final TextEditingController giveBaseAddressController;
//   late final TextEditingController giveUsernameController;
//   late final TextEditingController givePasswordController;

//   List<bool> panelOpen = [false, false];

//   void initializeControllers() {
//     giveNomeLoginController = TextEditingController()
//       ..addListener(giveControllerListener);
//     giveBaseAddressController = TextEditingController()
//       ..addListener(giveControllerListener);
//     giveUsernameController = TextEditingController()
//       ..addListener(giveControllerListener);
//     givePasswordController = TextEditingController()
//       ..addListener(giveControllerListener);
//   }

//   void disposeControllers() {
//     giveNomeLoginController.dispose();
//     giveBaseAddressController.dispose();
//     giveUsernameController.dispose();
//     givePasswordController.dispose();
//   }

//   void giveControllerListener() {
//     if (giveNomeLoginController.text.isEmpty ||
//         giveBaseAddressController.text.isEmpty ||
//         giveUsernameController.text.isEmpty ||
//         givePasswordController.text.isEmpty) {
//       giveValidNotifier.value = false;
//     } else {
//       giveValidNotifier.value = true;
//     }
//   }

//   Future<void> getInstitutionAttributes() async {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context, listen: false);
//     InstitutionAttributeAdminNotifier institutionAttributeAdminNotifier =
//         Provider.of<InstitutionAttributeAdminNotifier>(context, listen: false);
//     UserAppInstitutionModel cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     await institutionAttributeAdminNotifier
//         .getInstitutionAttribute(
//             context: context,
//             token: authenticationNotifier.token,
//             idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
//             idInstitution:
//                 cUserAppInstitutionModel.idInstitutionNavigation.idInstitution)
//         .then((value) {
//       List<InstitutionAttributeModel> cValue =
//           value as List<InstitutionAttributeModel>;

//       //GIVE
//       var itemGiveNomeLogin = cValue
//           .where((element) => element.attributeName == 'Give.NomeLogin')
//           .firstOrNull;
//       if (itemGiveNomeLogin != null) {
//         giveNomeLoginController.text = itemGiveNomeLogin.attributeValue;
//       }

//       var itemGiveBaseAddress = cValue
//           .where((element) => element.attributeName == 'Give.BaseAddress')
//           .firstOrNull;
//       if (itemGiveBaseAddress != null) {
//         giveBaseAddressController.text = itemGiveBaseAddress.attributeValue;
//       }

//       var itemGiveUsername = cValue
//           .where((element) => element.attributeName == 'Give.Username')
//           .firstOrNull;
//       if (itemGiveUsername != null) {
//         giveUsernameController.text = itemGiveUsername.attributeValue;
//       }

//       var itemGivePassword = cValue
//           .where((element) => element.attributeName == 'Give.Password')
//           .firstOrNull;
//       if (itemGivePassword != null) {
//         givePasswordController.text = itemGivePassword.attributeValue;
//       }
//     });
//   }

//   updateGiveData() {
//     if (_formKey1.currentState!.validate()) {
//       var authNotifier =
//           Provider.of<AuthenticationNotifier>(context, listen: false);
//       UserAppInstitutionModel cUserAppInstitutionModel =
//           authNotifier.getSelectedUserAppInstitution();

//       var institutionAttributeAdminNotifier =
//           Provider.of<InstitutionAttributeAdminNotifier>(context,
//               listen: false);

//       institutionAttributeAdminNotifier
//           .updateGiveAttribute(
//               context: context,
//               token: authNotifier.token,
//               idUserAppInstitution:
//                   cUserAppInstitutionModel.idUserAppInstitution,
//               idInstitution: cUserAppInstitutionModel
//                   .idInstitutionNavigation.idInstitution,
//               giveNomeLogin: giveNomeLoginController.text,
//               giveBaseAddress: giveBaseAddressController.text,
//               giveUserName: giveUsernameController.text,
//               givePassword: givePasswordController.text)
//           .then((value) {
//         if (value) {
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Impostazioni amministratore",
//                     message: "Parametri Give aggiornati correttamente",
//                     contentType: "success"));
//           }
//         }
//       });
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     InstitutionAttributeInstitutionAdminNotifier
//         institutionAttributeInstitutionAdminNotifier =
//         Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context);
//     // Ensure the refresh only happens when 'isUpdated' is true and the table isn't already refreshing
//     if (institutionAttributeInstitutionAdminNotifier.isUpdated) {
//       // Post-frame callback to avoid infinite loop during build phase
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         institutionAttributeInstitutionAdminNotifier
//             .setUpdate(false); // Reset the update flag
//         getInstitutionAttributes();
//       });
//     }
//   }

//   @override
//   void initState() {
//     initializeControllers();
//     // getInstitutionAttributes();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     disposeControllers();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context, listen: false);
//     UserAppInstitutionModel cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         backgroundColor: CustomColors.darkBlue,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Impostazioni amministratore ente ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution} ',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ExpansionPanelList(
//                           expansionCallback: (int index, bool isExpanded) {
//                             setState(() {
//                               panelOpen[index] = isExpanded;
//                             });
//                           },
//                           animationDuration: Duration(milliseconds: 500),
//                           elevation: 1,
//                           children: [
//                             ExpansionPanel(
//                               canTapOnHeader: true,
//                               headerBuilder:
//                                   (BuildContext context, bool isExpanded) {
//                                 return ListTile(
//                                   title: Text('Give'),
//                                   leading: const Icon(
//                                       Icons.app_settings_alt_outlined),
//                                 );
//                               },
//                               body: Form(
//                                 key: _formKey1,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(30),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(bottom: 20),
//                                         child: CustomTextFormField(
//                                           controller: giveNomeLoginController,
//                                           labelText: AppStrings.GiveNomeLogin,
//                                           keyboardType: TextInputType.name,
//                                           textInputAction: TextInputAction.next,
//                                           onChanged: (_) => _formKey1
//                                               .currentState
//                                               ?.validate(),
//                                           validator: (value) {
//                                             return value!.isNotEmpty
//                                                 ? null
//                                                 : AppStrings
//                                                     .pleaseEnterGiveNomeLogin;
//                                           },
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(bottom: 20),
//                                         child: CustomTextFormField(
//                                           controller: giveBaseAddressController,
//                                           labelText: AppStrings.GiveBaseAddress,
//                                           keyboardType: TextInputType.url,
//                                           textInputAction: TextInputAction.next,
//                                           onChanged: (_) => _formKey1
//                                               .currentState
//                                               ?.validate(),
//                                           validator: (value) {
//                                             return value!.isNotEmpty
//                                                 ? null
//                                                 : AppStrings
//                                                     .pleaseEnterGiveBaseAddress;
//                                           },
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(bottom: 20),
//                                         child: CustomTextFormField(
//                                           controller: giveUsernameController,
//                                           labelText: AppStrings.GiveUsername,
//                                           keyboardType: TextInputType.name,
//                                           textInputAction: TextInputAction.next,
//                                           onChanged: (_) => _formKey1
//                                               .currentState
//                                               ?.validate(),
//                                           validator: (value) {
//                                             return value!.isNotEmpty
//                                                 ? null
//                                                 : AppStrings
//                                                     .pleaseEnterGiveUsername;
//                                           },
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(bottom: 20),
//                                         child: CustomTextFormField(
//                                           controller: givePasswordController,
//                                           labelText: AppStrings.GivePassword,
//                                           keyboardType: TextInputType.name,
//                                           inputFormatter: <TextInputFormatter>[
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           textInputAction: TextInputAction.next,
//                                           onChanged: (_) => _formKey1
//                                               .currentState
//                                               ?.validate(),
//                                           validator: (value) {
//                                             return value!.isNotEmpty
//                                                 ? null
//                                                 : AppStrings
//                                                     .pleaseEnterGivePassword;
//                                           },
//                                         ),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: ValueListenableBuilder(
//                                               valueListenable:
//                                                   giveValidNotifier,
//                                               builder: (_, isValid, __) {
//                                                 return ElevatedButton(
//                                                   onPressed: isValid
//                                                       ? () {
//                                                           updateGiveData();
//                                                         }
//                                                       : null,
//                                                   style:
//                                                       ElevatedButton.styleFrom(
//                                                     side: BorderSide(
//                                                       width: 1.0,
//                                                     ),
//                                                   ),
//                                                   child: const Text(
//                                                     AppStrings.update,
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 14),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               isExpanded: panelOpen[0],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
