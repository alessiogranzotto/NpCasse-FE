import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/report.history.notifier.dart';
import 'package:np_casse/core/notifiers/report.product.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.combination.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.mapping.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/shop.navigate.notifier.dart';
import 'package:np_casse/core/notifiers/shop.search.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
    // ChangeNotifierProvider(create: (_) => UserNotifier()),
    // ChangeNotifierProvider(create: (_) => UserAppInstitutionNotifier()),
    // ChangeNotifierProvider(create: (_) => ProjectNotifier()),
    // ChangeNotifierProvider(create: (_) => ProductNotifier()),
    ChangeNotifierProvider(create: (_) => ProductCatalogNotifier()),
    // ChangeNotifierProvider(create: (_) => StoreNotifier()),
    // ChangeNotifierProvider(create: (_) => SizeNotifier()),
    ChangeNotifierProvider(create: (_) => CartNotifier()),
    ChangeNotifierProvider(create: (_) => ReportProductNotifier()),
    ChangeNotifierProvider(create: (_) => ReportHistoryNotifier()),

    // ChangeNotifierProvider(create: (_) => PaymentService()),
    // ChangeNotifierProvider(create: (_) => ProductCardNotifier()),
    ChangeNotifierProvider(create: (_) => GiveNotifier()),
    ChangeNotifierProvider(create: (_) => WishlistProductNotifier()),
    ChangeNotifierProvider(create: (_) => ProductAttributeNotifier()),
    ChangeNotifierProvider(create: (_) => ProductAttributeMappingNotifier()),
    ChangeNotifierProvider(
        create: (_) => ProductAttributeCombinationNotifier()),
    // ChangeNotifierProvider(create: (_) => HomeNotifier()),
    ChangeNotifierProvider(create: (_) => CategoryCatalogNotifier()),
    ChangeNotifierProvider(create: (_) => ShopNavigateNotifier()),
    ChangeNotifierProvider(create: (_) => ShopSearchNotifier()),
    // ChangeNotifierProvider(create: (_) => ShopCategoryNotifier()),
  ];
}
