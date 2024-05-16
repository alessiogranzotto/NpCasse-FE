import 'package:flutter/material.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/models/project.model.dart';
import 'package:np_casse/core/models/store.model.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:np_casse/screens/homeScreen/home.screen.dart';
import 'package:np_casse/screens/loginScreen/login.view.dart';
import 'package:np_casse/screens/loginScreen/register.view.dart';
import 'package:np_casse/screens/onBoardingScreen/onBoarding.screen.dart';
import 'package:np_casse/screens/productScreen/product.detail.screen.dart';
import 'package:np_casse/screens/productScreen/product.screen.dart';
import 'package:np_casse/screens/projectScreen/project.detail.screen.dart';
import 'package:np_casse/screens/projectScreen/project.screen.dart';
import 'package:np_casse/screens/splashScreen/splash.screen.dart';
import 'package:np_casse/screens/storeScreen/store.detail.screen.dart';
import 'package:np_casse/screens/storeScreen/store.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';

class AppRouter {
  static const String splashRoute = "/splash"; //
  static const String onBoardRoute = "/onBoard";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String signUpRoute = "/signup";
  static const String projectRoute = "/project";
  static const String projectDetailRoute = "/projectDetail";
  static const String storeRoute = "/store";
  static const String storeDetailRoute = "/storeDetail";
  static const String productRoute = "/product";
  static const String productDetailRoute = "/productDetail";

  static const String logoutRoute = "/logout";

  // static const String appSettingsRoute = "/appSettings";
  static const String homeRoute = "/home";
  static const String wishListRoute = "/wishList";
  static const String associazioniRoute = "/associazioni";
  static const String cartRoute = "/cart";
  // static const String searchRoute = "/search";
  // static const String profileRoute = "/profile";
  // static const String accountInfo = "/accountInfo";
  // static const String categoryRoute = "/category";
  // static const String prodDetailRoute = "/productDetail";
  // static const String editProfileRoute = "/editProfile";
  // static const String changePassRoute = "/changePassword";

// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return child;
//     },
//   );
// }

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute: //
        {
          return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const SplashScreen(),
          );
        }
      case homeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const MasterScreen(),
          );
          // return PageRouteBuilder(
          //   pageBuilder: (context, animation, secondaryAnimation) =>
          //       const HomeScreen(),
          //   transitionsBuilder:
          //       (context, animation, secondaryAnimation, child) {
          //     const begin = Offset(0.0, 1.0);
          //     const end = Offset.zero;
          //     const curve = Curves.ease;

          //     var tween =
          //         Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          //     return SlideTransition(
          //       position: animation.drive(tween),
          //       child: child,
          //     );
          //   },
          // );
        }
      case loginRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          );
          // return PageRouteBuilder(
          //   pageBuilder: (context, animation, secondaryAnimation) =>
          //       const LoginScreen(),
          //   transitionsBuilder:
          //       (context, animation, secondaryAnimation, child) {
          //     const begin = Offset(1.0, 0.0);
          //     const end = Offset.zero;
          //     const curve = Curves.ease;

          //     var tween =
          //         Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          //     return SlideTransition(
          //       position: animation.drive(tween),
          //       child: child,
          //     );
          //   },
          // );
        }
      case registerRoute:
        {
          return MaterialPageRoute(
            builder: (_) => RegisterScreen(),
          );
        }
      case wishListRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const WishlistScreen(),
          );
        }
      case projectRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ProjectScreen(),
          );
        }
      case projectDetailRoute:
        {
          return MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(
              projectModelArgument:
                  ModalRoute.of(context)!.settings.arguments as ProjectModel,
            ),
            settings: settings,
          );
        }
      case logoutRoute: //
        {
          return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const LoginScreen(),
          );
        }
      case storeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const StoreScreen(),
          );
        }
      case storeDetailRoute:
        {
          return MaterialPageRoute(
            builder: (context) => StoreDetailScreen(
              storeModelArgument:
                  ModalRoute.of(context)!.settings.arguments as StoreModel,
            ),
            settings: settings,
          );
        }
      case productRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ProductScreen(),
          );
        }
      case productDetailRoute:
        {
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productModelArgument:
                  ModalRoute.of(context)!.settings.arguments as ProductModel,
            ),
            settings: settings,
          );
        }
      // case editProfileRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => EditProfileScreen(),
      //     );
      //   }
      // case appSettingsRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const AppSettings(),
      //     );
      //   }
      case onBoardRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const OnBoardingScreen(),
          );
        }
      // case productRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const ProductScreen(),
      //     );
      //   }
      // case signUpRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => SignUpScreen(),
      //     );
      //   }
      // case prodDetailRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (context) => ProductDetail(
      //         productDetailsArguements: ModalRoute.of(context)!
      //             .settings
      //             .arguments as ProductDetailsArgs,
      //       ),
      //       settings: settings,
      //     );
      //   }
      case cartRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const CartScreen(),
          );
        }
      // case searchRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const SearchScreen(),
      //     );
      //   }
      // case profileRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const ProfileScreen(),
      //     );
      //   }
      // case categoryRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (context) => CategoryScreen(
      //         categoryScreenArgs: ModalRoute.of(context)!.settings.arguments
      //             as CategoryScreenArgs,
      //       ),
      //       settings: settings,
      //     );
      //   }
      // case accountInfo:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const AccountInformationScreen(),
      //     );
      //   }
      // case changePassRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => ChangePasswordScreen(),
      //     );
      //   }
    }
    return null;
  }
}
