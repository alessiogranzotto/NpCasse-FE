class ApiRoutes {
  static const String localBaseURL = "https://10.0.2.2:7263";
  static const String testBaseURL = "http://31.14.141.7:8443";
  static const String localDevBaseURL = "https://localhost:7263";
  static const String localWebBaseURL = "http://31.14.141.7:8083";
  static const String dnsWebBaseURL = "https://apicasse.giveapp.it";

  static const String localAuthURL = "https://10.0.2.2:7262";
  static const String testAuthURL = "http://31.14.141.7:8444";
  static const String localDevAuthURL = "https://localhost:7262";
  static const String localWebAuthURL = "http://31.14.141.7:8084";
  static const String dnsWebAuthURL = "https://auth.giveapp.it";

  static const String baseURL = dnsWebBaseURL;
  static const String authURL = dnsWebAuthURL;

  static const String loginURL = "$authURL/api/user/utility/authenticate";
  static const String registerURL = "$authURL/api/user/utility/registration";

  static const String authUserAppInstitutionURL =
      "$authURL/api/User/Utility/get-institution-by-user-and-app";
  static const String authUserAppInstitutionGrantURL =
      "$authURL/api/User/Utility/get-user-app-institution-grant";

  static const String baseUserAppInstitutionURL =
      "$baseURL/api/UserAppInstitution";

  static const String cartURL = "$baseURL/api/Cart/Utility";
  static const String wishlistProductURL = "$baseURL/api/Wishlist/utility";
  static const String geoSuggestionsURL = "$authURL/api/Geo/Utility";

  static const String giveURL = "$baseURL/api/Give/Utility";
  // static const String storeURL = "$baseURL/api/Store";
}
