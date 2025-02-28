class ApiRoutes {
  static const String devAuthURL = "https://localhost:7262";
  static const String devCasseURL = "https://localhost:7263";
  static const String devWhURL = "https://localhost:7264";

  static const String testAuthURL = "https://auth-test.giveapp.it";
  static const String testCasseURL = "https://apicasse-test.giveapp.it";
  static const String testWhURL = "https://wh-test.giveapp.it";

  static const String prodAuthURL = "https://auth.giveapp.it";
  static const String prodCasseURL = "https://apicasse.giveapp.it";
  static const String prodWhURL = "https://wh.giveapp.it";

  static const String authURL = testAuthURL;
  static const String casseURL = testCasseURL;
  static const String whURL = testWhURL;

  static const String authenticateURL =
      "$authURL/api/user/utility/authenticate";
  static const String checkOtpURL = "$authURL/api/user/utility/check_otp";
  static const String registerURL = "$authURL/api/user/utility/registration";

  static const String authUserAppInstitutionURL =
      "$authURL/api/User/Utility/get-institution-by-user-and-app";
  static const String authUserAppInstitutionGrantURL =
      "$authURL/api/User/Utility/get-user-app-institution-grant";

  static const String updateUserDetailsURL =
      "$authURL/api/User/Utility/Update-user";
  static const String changePasswordURL =
      "$authURL/api/User/Utility/Update-user-password";

  static const String updateUserAttributeURL =
      "$authURL/api/User/Utility/Update-user-attribute";

  static const String updateInstitutionAttributeURL =
      "$authURL/api/Institution/Utility/Update-institution-attribute";

  static const String baseInstitutionAttributeURL =
      "$authURL/api/Institution/Utility";
  static const String baseUserAppInstitutionURL =
      "$casseURL/api/UserAppInstitution";

  static const String cartURL = "$casseURL/api/Cart/Utility";
  static const String geoSuggestionsURL = "$authURL/api/Geo/Utility";

  static const String reportURL = "$casseURL/api/Report";

  static const String giveURL = "$casseURL/api/Give/Utility";

  static const String comunicationURL = "$casseURL/api/Comunication/Utility";

  static const String baseMyosotisConfigurationURL =
      "$casseURL/api/MyosotisConfiguration";

  static const String downloadAppURL = "$casseURL/api/DownloadApp";
  static const String MyosotisConfigurationURL =
      "$casseURL/api/MyosotisConfiguration";

  // static const String storeURL = "$baseURL/api/Store";

  static const String baseProductURL = "$whURL/api/Product";
  static const String baseCategoryURL = "$whURL/api/Category";
  static const String baseProductAttributeURL = "$whURL/api/ProductAttribute";
  static const String wishlistProductURL = "$whURL/api/Wishlist/utility";

  static const String baseVatURL = "$whURL/api/Vat";
}
