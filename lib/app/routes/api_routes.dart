class ApiRoutes {
  static const String androidCasseURL = "https://10.0.2.2:7263";
  static const String androidAuthURL = "https://10.0.2.2:7262";

  static const String devAuthURL = "https://localhost:7262";
  static const String devCasseURL = "https://localhost:7263";
  static const String devWhURL = "https://localhost:7264";

  static const String testAuthURL = "https://auth-test.giveapp.it";
  static const String testCasseURL = "https://apicasse-test.giveapp.it";
  static const String testWhURL = "https://wh-test.giveapp.it";

  static const String prodAuthURL = "https://auth.giveapp.it";
  static const String prodCasseURL = "https://apicasse.giveapp.it";
  static const String prodWhURL = "https://wh.giveapp.it";

  // static const String prodAuthURL = "http://31.14.141.7:8083";
  // static const String testAuthURL = "http://31.14.141.7:8444";
  // static const String localWebAuthURL = "http://31.14.141.7:8084";
  // static const String testBaseURL = "http://31.14.141.7:8443";

  static const String authURL = devAuthURL;
  static const String casseURL = devCasseURL;
  static const String whURL = devWhURL;

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
      "$authURL/api/Institution/Utility/Update-institution-admin-attribute";

  static const String baseInstitutionAttributeURL =
      "$authURL/api/Institution/Utility";
  static const String baseUserAppInstitutionURL =
      "$casseURL/api/UserAppInstitution";

  static const String cartURL = "$casseURL/api/Cart/Utility";
  static const String geoSuggestionsURL = "$authURL/api/Geo/Utility";

  static const String reportURL = "$casseURL/api/Report";

  static const String giveURL = "$casseURL/api/Give/Utility";

  static const String comunicationURL = "$casseURL/api/Comunication/Utility";
  // static const String storeURL = "$baseURL/api/Store";

  static const String baseProductURL = "$whURL/api/Product";
  static const String baseCategoryURL = "$whURL/api/Category";
  static const String baseProductAttributeURL = "$whURL/api/ProductAttribute";
  static const String wishlistProductURL = "$whURL/api/Wishlist/utility";
}
