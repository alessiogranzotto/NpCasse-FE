import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/download.app.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.notifier.dart';
import 'package:np_casse/core/notifiers/mass.sending.notifier.dart';
import 'package:np_casse/core/notifiers/myosotis.configuration.notifier.dart';
import 'package:np_casse/core/notifiers/report.cart.notifier.dart';
import 'package:np_casse/core/notifiers/report.massive.sending.notifier.dart';
import 'package:np_casse/core/notifiers/report.myosotis.access.notifier.dart';
import 'package:np_casse/core/notifiers/report.myosotis.donation.notifier.dart';
import 'package:np_casse/core/notifiers/report.product.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/give.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.combination.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.mapping.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/report.transactional.sending.notifier.dart';
import 'package:np_casse/core/notifiers/shop.navigate.notifier.dart';
import 'package:np_casse/core/notifiers/shop.search.notifier.dart';
import 'package:np_casse/core/notifiers/task.common.notifier.dart';
import 'package:np_casse/core/notifiers/task.planned.notifier.dart';
import 'package:np_casse/core/notifiers/transactional.sending.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/screens/homeScreen/theme.mode.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
    ChangeNotifierProvider(create: (_) => DownloadAppNotifier()),
    // ChangeNotifierProvider(create: (_) => UserNotifier()),
    // ChangeNotifierProvider(create: (_) => UserAppInstitutionNotifier()),
    // ChangeNotifierProvider(create: (_) => ProjectNotifier()),
    // ChangeNotifierProvider(create: (_) => ProductNotifier()),
    ChangeNotifierProvider(create: (_) => ProductCatalogNotifier()),
    // ChangeNotifierProvider(create: (_) => StoreNotifier()),
    // ChangeNotifierProvider(create: (_) => SizeNotifier()),
    ChangeNotifierProvider(create: (_) => CartNotifier()),
    ChangeNotifierProvider(create: (_) => ReportProductNotifier()),
    ChangeNotifierProvider(create: (_) => ReportCartNotifier()),

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
    ChangeNotifierProvider(create: (_) => InstitutionAttributeNotifier()),
    // ChangeNotifierProvider(create: (_) => InstitutionAttributeAdminNotifier()),
    // ChangeNotifierProvider(create: (_) => ComunicationNotifier()),
    ChangeNotifierProvider(create: (_) => MyosotisConfigurationNotifier()),
    ChangeNotifierProvider(create: (_) => ReportMyosotisDonationNotifier()),
    ChangeNotifierProvider(create: (_) => ReportMyosotisAccessNotifier()),
    ChangeNotifierProvider(create: (_) => MassSendingNotifier()),
    ChangeNotifierProvider(create: (_) => TransactionalSendingNotifier()),
    ChangeNotifierProvider(create: (_) => ReportMassSendingNotifier()),
    ChangeNotifierProvider(create: (_) => ReportTransactionalSendingNotifier()),
    ChangeNotifierProvider(create: (_) => TaskCommonNotifier()),
    ChangeNotifierProvider(create: (_) => TaskPlannedNotifier()),
    ChangeNotifierProvider(create: (_) => ThemeProviderNotifier()),

    // ChangeNotifierProvider(create: (_) => ShopCategoryNotifier()),
  ];
}
