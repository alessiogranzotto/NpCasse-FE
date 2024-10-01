import 'package:flutter/material.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/models/product.attribute.mapping.model.dart';
import 'package:np_casse/core/models/product.attribute.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:np_casse/screens/cartScreen/pdf.invoice.screen.dart';
import 'package:np_casse/screens/cartScreen/sh.manage.screen.dart';
import 'package:np_casse/screens/cartScreen/sh.new.edit.sh.screen.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.detail.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.screen.dart';
import 'package:np_casse/screens/homeScreen/master.screen.dart';
import 'package:np_casse/screens/loginScreen/login.view.dart';
import 'package:np_casse/screens/loginScreen/register.view.dart';
import 'package:np_casse/screens/onBoardingScreen/onBoarding.screen.dart';
import 'package:np_casse/screens/productAttributeScreen/product.attribute.detail.screen.dart';
import 'package:np_casse/screens/productAttributeScreen/productAttribute.screen.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.detail.attribute.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.detail.data.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.dart';
import 'package:np_casse/screens/shopScreen/category.two.shop.screen.dart';
import 'package:np_casse/screens/shopScreen/product.three.shop.screen.dart';
import 'package:np_casse/screens/splashScreen/splash.screen.dart';

class ProductCatalogDetailAttributeMultipleArgument {
  final ProductCatalogModel product;
  final List<ProductAttributeMappingModel> productAttributeMappingModelList;

  ProductCatalogDetailAttributeMultipleArgument({
    required this.product,
    required this.productAttributeMappingModelList,
  });
}

class AppRouter {
  static const String splashRoute = "/splash"; //
  static const String onBoardRoute = "/onBoard";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String signUpRoute = "/signup";

  // static const String projectRoute = "/project";
  // static const String projectDetailRoute = "/projectDetail";
  // static const String storeRoute = "/store";
  // static const String storeDetailRoute = "/storeDetail";
  // static const String productRoute = "/product";
  // static const String productDetailRoute = "/productDetail";

  static const String userRoute = "/user";
  static const String settingRoute = "/setting";

  static const String logoutRoute = "/logout";

  // static const String appSettingsRoute = "/appSettings";
  static const String homeRoute = "/home";
  static const String wishListRoute = "/wishList";
  static const String institutionRoute = "/institution";
  static const String cartRoute = "/cart";

  static const String shManage = "/shManage";
  static const String shManageNewEdit = "/shManageNewEdit";
  static const String shPdfInvoice = "/shPdfInvoice";

  static const String productAttributeRoute = "/productAttribute";
  static const String productAttributeDetailRoute = "/productAttributeDetail";

  static const String productCatalogRoute = "/productCatalog";
  static const String productCatalogDetailDataRoute =
      "/productCatalogDetailData";
  static const String productCatalogDetailAttributeRoute =
      "/productCatalogDetailAttribute";

  static const String categoryCatalogRoute = "/categoryCatalog";
  static const String categoryCatalogDetailRoute = "/categoryCatalogDetail";

  static const String categoryOneShopRoute = "/categoryoneshop";
  static const String categoryTwoShopRoute = "/categorytwoshop";
  static const String categoryProductShopRoute = "/categoryproductshop";

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
        }
      case registerRoute:
        {
          return MaterialPageRoute(
            builder: (_) => RegisterScreen(),
          );
        }
      // case wishListRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const WishlistScreen(),
      //     );
      //   }
      // case projectRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const ProjectScreen(),
      //     );
      //   }
      // case projectDetailRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (context) => ProjectDetailScreen(
      //         projectModelArgument:
      //             ModalRoute.of(context)!.settings.arguments as ProjectModel,
      //       ),
      //       settings: settings,
      //     );
      //   }
      case loginRoute: //
        {
          return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const LoginScreen(),
          );
        }
      // case storeRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const StoreScreen(),
      //     );
      //   }
      // case storeDetailRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (context) => StoreDetailScreen(
      //         storeModelArgument:
      //             ModalRoute.of(context)!.settings.arguments as StoreModel,
      //       ),
      //       settings: settings,
      //     );
      //   }
      // case productRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (_) => const ProductScreen(),
      //     );
      //   }
      // case productDetailRoute:
      //   {
      //     return MaterialPageRoute(
      //       builder: (context) => ProductDetailScreen(
      //         productModelArgument:
      //             ModalRoute.of(context)!.settings.arguments as ProductModel,
      //       ),
      //       settings: settings,
      //     );
      //   }

      case productAttributeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ProductAttributeScreen(),
          );
        }
      case productAttributeDetailRoute:
        {
          return MaterialPageRoute(
            builder: (context) => ProductAttributeDetailScreen(
              productAttributeModelArgument: ModalRoute.of(context)!
                  .settings
                  .arguments as ProductAttributeModel,
            ),
            settings: settings,
          );
        }

      case productCatalogRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ProductCatalogScreen(),
          );
        }
      case productCatalogDetailDataRoute:
        {
          return MaterialPageRoute(
            builder: (context) => ProductCatalogDetailDataScreen(
              productCatalogModelArgument: ModalRoute.of(context)!
                  .settings
                  .arguments as ProductCatalogModel,
            ),
            settings: settings,
          );
        }
      case productCatalogDetailAttributeRoute:
        {
          final args = settings.arguments
              as ProductCatalogDetailAttributeMultipleArgument;
          return MaterialPageRoute(
            builder: (context) => ProductCatalogDetailAttributeScreen(
              productAttributeMappingModel:
                  args.productAttributeMappingModelList,
              product: args.product,
            ),
            settings: settings,
          );
        }

      case categoryCatalogRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const CategoryCatalogScreen(),
          );
        }

      case categoryCatalogDetailRoute:
        {
          return MaterialPageRoute(
            builder: (context) => CategoryCatalogDetailScreen(
              categoryCatalogModelArgument: ModalRoute.of(context)!
                  .settings
                  .arguments as CategoryCatalogModel,
            ),
            settings: settings,
          );
        }
      case categoryTwoShopRoute:
        {
          return MaterialPageRoute(
            builder: (context) => CategoryTwoShopScreen(
              masterCategoryCatalogModel: ModalRoute.of(context)!
                  .settings
                  .arguments as CategoryCatalogModel,
            ),
            settings: settings,
          );
        }
      case categoryProductShopRoute:
        {
          return MaterialPageRoute(
            builder: (context) => ProductThreeShopScreen(
              childCategoryCatalogModel: ModalRoute.of(context)!
                  .settings
                  .arguments as CategoryCatalogModel,
            ),
            settings: settings,
          );
        }
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
      case shManage:
        {
          return MaterialPageRoute(
            builder: (_) => const ShManageScreen(),
          );
        }
      case shManageNewEdit:
        {
          return MaterialPageRoute(
            builder: (context) => ShNewEditScreen(
              editStakeholderGiveModelSearch: ModalRoute.of(context)!
                  .settings
                  .arguments as StakeholderGiveModelSearch?,
            ),
            settings: settings,
          );
        }
      case shPdfInvoice:
        {
          return MaterialPageRoute(
            builder: (_) => const PdfInvoiceScreen(),
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
