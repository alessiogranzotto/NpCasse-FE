import 'package:flutter/material.dart';

import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/componenents/empty.data.widget.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.card.dart';
import 'package:np_casse/screens/shopScreen/widget/product.card.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    double widgetWidth = 290;
    double widgetHeight = 505;
    double widgetHeightHalf = 355;
    double gridChildSpace = 5;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Preferiti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<WishlistProductNotifier>(
              builder: (context, wishlistProductNotifier, _) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: wishlistProductNotifier.findWishlistedProducts(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 5,
                                        color: Colors.redAccent,
                                      ))),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return EmptyDataWidget(
                          title: "Dati non presenti",
                          message:
                              "Non ci sono elementi da mostrare al momento.",
                        );
                      } else {
                        var tSnapshot =
                            snapshot.data as List<ProductCatalogModel>;
                        if (tSnapshot.isEmpty) {
                          return EmptyDataWidget(
                            title: "Dati non presenti",
                            message:
                                "Non ci sono elementi da mostrare al momento.",
                          );
                        }
                        var t = tSnapshot
                            .any((element) => element.imageData.isNotEmpty);
                        bool areAllWithNoImage = !t;
                        double cHeight = 0;
                        if (areAllWithNoImage) {
                          cHeight = widgetHeightHalf;
                        } else {
                          cHeight = widgetHeight;
                        }
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount:
                                  (MediaQuery.of(context).size.width) ~/
                                      widgetWidth,
                              crossAxisSpacing: gridChildSpace,
                              mainAxisSpacing: gridChildSpace,
                              height: cHeight,
                            ),
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tSnapshot.length,
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              ProductCatalogModel product = tSnapshot[index];
                              return ProductCard(
                                productCatalog: product,
                                areAllWithNoImage: areAllWithNoImage,
                                comeFrom: "Wishlist",
                              );
                            });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ));
  }
}
