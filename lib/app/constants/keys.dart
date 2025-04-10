import 'package:flutter/material.dart';

class AppKeys {
  static String appMode = 'darkMode';
  static String userData = 'user_data';

  static String userInstitutionData = 'userInstitution_data';
  static String razorKey = 'rzp_test_ImLClDOqMc2kc1';
  static String onBoardDone = 'onBoard';

  static String appName = 'np_casse';
  static String version = '1.20.023';
}

// class AppRegex {
//   const AppRegex._();

//   static final RegExp emailRegex = RegExp(
//       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+");
//   // static final RegExp passwordRegex = RegExp(
//   //     r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&_])[A-Za-z\d@#$!%*?&_].{7,}$');

//   static final RegExp passwordRegex =
//       RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{7,}$');
// }

class AppConstants {
  AppConstants._();

  static final navigationKey = GlobalKey<NavigatorState>();

  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
  );

  // static final RegExp passwordRegex = RegExp(
  //   r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&_])[A-Za-z\d@#$!%*?&_].{7,}$',
  // );

  static final RegExp passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{7,}$');
}

class AppStrings {
  const AppStrings._();

  static const String loginAndRegister = 'Login and Register UI';
  static const String uhOhPageNotFound = 'uh-oh!\nPage not found';
  static const String register = 'Register';
  static const String sendOtp = 'Invia OTP';
  static const String confirmOtp = 'Conferma OTP';
  static const String login = 'Login';
  static const String back = 'Back';
  static const String createYourAccount = 'Create your account';
  static const String doNotHaveAnAccount = "Don't have an account?";
  static const String facebook = 'Facebook';
  static const String google = 'Google';
  static const String signInToYourNAccount = 'Sign in to your\nAccount';
  static const String signInToYourAccount = 'Sign in to your Account';
  static const String iHaveAnAccount = 'I have an account?';
  static const String forgotPassword = 'Forgot Password?';
  static const String orLoginWith = 'or Login with';
  static const String downloadApp = 'Download Android App';

  static const String loggedIn = 'Logged In!';
  static const String registrationComplete = 'Registration Complete!';
  static const String cancel = 'Annulla';
  static const String generate = 'Genera';
  static const String update = 'Aggiorna';
  static const String changePassword = 'Modifica Password';

  // static const String name = 'Name';
  // static const String pleaseEnterName = 'Please, Enter Name';
  // static const String invalidName = 'Invalid Name';

  static const String firstName = 'Nome';
  static const String pleaseEnterFirstName = 'Inserire il nome';
  static const String invalidFirstName = 'Nome invalido';

  static const String lastName = 'Cognome';
  static const String pleaseEnterLastName = 'Inserire il cognome';
  static const String invalidLastName = 'Cognome invalido';

  static const String telephoneNumber = 'Numero di telefono';
  static const String pleaseEnterTelephoneNumber =
      'Inserire il numero di telefono';
  static const String invalidTelephoneNumber = 'Numero di telefono invalido';

  static const String email = 'Email';
  static const String pleaseEnterEmailAddress = 'Inserire Email';
  static const String invalidEmailAddress = 'Email invalida';

  static const String otpMode = 'Modalità OTP';
  static const String tokenExpiration =
      'Durata token di autenticazione (in minuti)';
  static const String userMaxInactivity =
      'Tempo massimo inattività (in minuti)';
  static const String pleaseEnterTokenExpiration =
      'Inserire la durata del token';
  static const String pleaseEnterUserMaxInactivity =
      'Inserire il tempo massimo di inattività';

  static const String password = 'Password';
  static const String pleaseEnterPassword = 'Inserire la password';
  static const String invalidPassword = 'Password invalida';

  static const String confirmPassword = 'Conferma Password';
  static const String pleaseReEnterPassword = 'Reinserire la password';
  static const String passwordNotMatched = 'Password non coincidenti!';

  static const String IdPaymentTypeContanti = 'Id pagamento contanti';
  static const String pleaseEnterIdPaymentTypeContanti =
      'Inserire Id di pagamento';
  static const String IdPaymentTypeBancomat = 'Id pagamento bancomat';
  static const String pleaseEnterIdPaymentTypeBancomat =
      'Inserire Id di pagamento';
  static const String IdPaymentTypeAssegno = 'Id pagamento assegno';
  static const String pleaseEnterIdPaymentTypeAssegno =
      'Inserire Id di pagamento';
  static const String IdPaymentTypeCartaCredito =
      'Id pagamento carta di credito';
  static const String pleaseEnterIdPaymentTypeCartaCredito =
      'Inserire Id di pagamento';

  static const String stripeApiKey = 'Stripe api key';
  static const String pleaseEnterstripeApiKey = 'Inserire api key di Stripe';

  static const String paypalApiKey = 'Paypal Client Id';

  static const GiveNomeLogin = 'Nome login Give Api';
  static const pleaseEnterGiveNomeLogin = 'Inserire nome login Api Give';

  static const GiveUsername = 'Username Give Api';
  static const pleaseEnterGiveUsername = 'Inserire username Api Give';
  static const GiveBaseAddress = 'Url di riferimento Api Give';
  static const pleaseEnterGiveBaseAddress =
      'Inserire Url di riferimento Api Give';

  static const GivePassword = 'Password Api Key';
  static const pleaseEnterGivePassword = 'Inserire password Api Give';

  static const emailSendAccompaniment = 'Id mail di accompagnamento';
  static const pleaseEnterEmailSendAccompaniment =
      'Inseire id email di accompagnamento';

  static const emailSendFrom = 'Email di invio';
  static const pleaseEnterEmailSendFrom = 'Inserire email di invio';

  static const parameterIdShAnonymous = "Id Stakeholder anonimo";

  //COMUNICATION
  static const nameComunication = 'Nome comunicazione';
  static const pleaseEnterNameComunication = 'Inserire nome comunicazione';

  static const senderComunication = 'Mittente comunicazione';
  static const pleaseEnterSenderComunication =
      'Inserire mittente comunicazione';

  static const emailSenderComunication = 'Email mittente comunicazione';
  static const pleaseEnterEmailSenderComunication =
      'Inserire email mittente comunicazione';
  static const subjectEmailComunication = 'Oggetto comunicazione';
  static const pleaseEnterSubjectEmailComunication =
      'Inserire oggetto comunicazione';

  static const comunicationTemplate = 'Template comunicazione';

  static const institutionFiscalizationCf = 'Codice fiscale amministratore';
  static const pleaseEnterInstitutionFiscalizationCf =
      'Inserire codice fiscale amministratore';
  static const institutionFiscalizationPassword =
      'Password Agenzia delle Entrate';
  static const pleaseEnterInstitutionFiscalizationPin =
      'Inserire password Agenzia delle Entrate';
  static const institutionFiscalizationPin = 'PIN Agenzia delle Entrate';
  static const pleaseEnterInstitutionFiscalizationPassword =
      'Inserire PIN Agenzia delle Entrate';

  static const nameMyosotisConfiguration = 'Nome configurazione';
  static const pleaseEnterNameMyosotisConfiguration =
      'Inserire nome configurazione';

  static const descriptionMyosotisConfiguration = 'Descrizione configurazione';
  static const pleaseEnterDescriptionMyosotisConfiguration =
      'Inserire descrizione configurazione';

  static const idDeviceMyosotisConfiguration = 'Id device abilitati';
  static const urlMyosotisConfiguration = 'Url abilitati';
  static const preestablishedAmount = 'Importi predefiniti';

  static const formStartupMyosotisConfiguration =
      'Configurazione form di avvio';
  static const pleaseEnterFormStartupMyosotisConfiguration =
      'Configurazione form di avvio';

  static const titleMyosotisConfiguration = 'Titolo form';
  static const pleaseEnterTitleMyosotisConfiguration = 'Inserire titolo form';
  static const subtitleMyosotisConfiguration = 'Sottotitolo form';
  static const pleaseEnterSubtitleMyosotisConfiguration =
      'Inserire sottotitolo form';
  static const showLogoConfiguration = 'Mostra logo associazione';

  static const textPrivacyMyosotisConfiguration = 'Testo privacy';
  static const textNewsletterMyosotisConfiguration = 'Testo newletter';

  static const projectToHelp = 'Progetti da sostenere';

  static const showFreePriceConfiguration = 'Mostra importo libero';
  static const showCausalDonation = 'Mostra progetti da sostenere';

  static const showPrivacy = 'Mostra accetta privacy';

  static const isMandatoryPrivacy = "Accettazione privacy obbligatoria";

  static const showNewsletter = "Mostra accetta newsletter";

  static const isMandatoryNewsletter = "Accettazione newsletter obbligatoria";

  static const showCompanyForm = "Mostra form azienda";

  static const causalDonationText = "Testo causale donazione";
  static const availableSubCategoryCausalDonation = "Categoria causali";

  //COMUNICAZIONI
  static const nameMassSending = "Nome comunicazione";
  static const pleaseEnterNameMassSending = "Inserire nome comunicazione";

  static const descriptionMassSending = "Descrizione comunicazione";
  static const pleaseEnterDescriptionMassSending =
      "Inserire descrizione comunicazione";

  static const senderMassSending = "Mittente comunicazione";
  static const pleaseEnterSenderMassSending = "Inserire mittente comunicazione";

  static const emailSenderMassSending = "Email mittente comunicazione";
  static const pleaseEnterEmailSenderMassSending =
      "Inserire email mittente comunicazione";

  static const subjectEmailMassSending = "Oggetto comunicazione";
  static const pleaseEnterSubjectEmailMassSending =
      "Inserire oggetto comunicazione";

  static const massSendingTemplate = "Template comunicazione";

  static const datePlanMassSending = "Data spedizione pianificata";
  static const pleaseEnterDatePlanMassSending =
      "Inserire data spedizione pianificata";

  static const hourPlanMassSending = "Ora spedizione pianificata";
  static const pleaseEnterHourPlanMassSending =
      "Inserire ora spedizione pianificata";
}

class AppColors {
  const AppColors._();

  static const Color primaryColor = Color(0xffBAE162);
  static const Color darkBlue = Color(0xff1E2E3D);
  static const Color darkerBlue = Color(0xff152534);
  static const Color darkestBlue = Color(0xff0C1C2E);

  static const List<Color> defaultGradient = [
    darkBlue,
    darkerBlue,
    darkestBlue,
  ];
}

// class AGTheme {
//   static const textFormFieldBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(12)),
//     borderSide: BorderSide(color: Colors.grey, width: 1.6),
//   );

//   static final ThemeData themeData = ThemeData(
//     useMaterial3: true,
//     colorSchemeSeed: AppColors.primaryColor,
//     scaffoldBackgroundColor: Colors.white,
//     textTheme: const TextTheme(
//       titleLarge: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//         fontSize: 34,
//         letterSpacing: 0.5,
//       ),
//       bodySmall: TextStyle(
//         color: Colors.grey,
//         fontSize: 14,
//         letterSpacing: 0.5,
//       ),
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.transparent,
//       errorStyle: TextStyle(fontSize: 12),
//       contentPadding: EdgeInsets.symmetric(
//         horizontal: 24,
//         vertical: 14,
//       ),
//       border: textFormFieldBorder,
//       errorBorder: textFormFieldBorder,
//       focusedBorder: textFormFieldBorder,
//       focusedErrorBorder: textFormFieldBorder,
//       enabledBorder: textFormFieldBorder,
//       labelStyle: TextStyle(
//         fontSize: 17,
//         color: Colors.grey,
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: AppColors.primaryColor,
//         padding: const EdgeInsets.all(4),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//         ),
//         textStyle: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//     ),
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: AppColors.primaryColor,
//         minimumSize: const Size(double.infinity, 50),
//         side: BorderSide(color: Colors.grey.shade200),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//       ),
//     ),
//     filledButtonTheme: FilledButtonThemeData(
//       style: FilledButton.styleFrom(
//         foregroundColor: Colors.black,
//         backgroundColor: AppColors.primaryColor,
//         disabledBackgroundColor: Colors.grey.shade300,
//         minimumSize: const Size(double.infinity, 52),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//       ),
//     ),
//   );

//   static const TextStyle titleLarge = TextStyle(
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//     fontSize: 34,
//     letterSpacing: 0.5,
//   );

//   static const TextStyle bodySmall = TextStyle(
//     color: Colors.grey,
//     letterSpacing: 0.5,
//   );
// }

class Vectors {
  Vectors._();

  static const String facebook = 'assets/vectors/facebook.svg';
  static const String google = 'assets/vectors/google.svg';
}
