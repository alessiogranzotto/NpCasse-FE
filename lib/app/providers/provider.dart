import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/core/notifiers/home.notifier.dart';
import 'package:np_casse/core/notifiers/product.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/core/notifiers/store.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
    // ChangeNotifierProvider(create: (_) => UserNotifier()),
    // ChangeNotifierProvider(create: (_) => UserAppInstitutionNotifier()),
    ChangeNotifierProvider(create: (_) => ProjectNotifier()),
    ChangeNotifierProvider(create: (_) => ProductNotifier()),
    ChangeNotifierProvider(create: (_) => StoreNotifier()),
    // ChangeNotifierProvider(create: (_) => SizeNotifier()),
    ChangeNotifierProvider(create: (_) => CartNotifier()),
    // ChangeNotifierProvider(create: (_) => PaymentService()),
    // ChangeNotifierProvider(create: (_) => ProductCardNotifier()),
    ChangeNotifierProvider(create: (_) => GiveNotifier()),
    ChangeNotifierProvider(create: (_) => WishlistProductNotifier()),
    ChangeNotifierProvider(create: (_) => HomeNotifier()),
  ];
}
