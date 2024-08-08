import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/screens/productScreen/widgets/product.card.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    double widgetWitdh = 320;
    double widgetHeight = 350;
    double widgetHeightHalf = 200;
    // double widgetRatio = 1.1;
    // double widgetRatioHalf = 0.65;
    double gridMainAxisSpacing = 10;

    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            // const CustomDrawerWidget(),
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false, 
              title: Text(
                'Preferiti di ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                            return const Center(
                              child: Text(
                                'No data...',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          } else {
                            var tSnapshot = snapshot.data as List<ProductModel>;
                            var t = tSnapshot.any(
                                (element) => element.imageProduct.isNotEmpty);
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
                                          widgetWitdh,
                                  crossAxisSpacing: 10,
                                  // (((MediaQuery.of(context)
                                  //             .size
                                  //             .width) -
                                  //         (widgetWitdh *
                                  //             ((MediaQuery.of(context)
                                  //                     .size
                                  //                     .width) ~/
                                  //                 widgetWitdh))) /
                                  //     ((MediaQuery.of(context).size.width) ~/
                                  //         widgetWitdh)),
                                  mainAxisSpacing: gridMainAxisSpacing,
                                  height: cHeight,
                                ),
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tSnapshot.length,
                                // scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  ProductModel product = tSnapshot[index];
                                  return ProductCard(
                                    product: product,
                                    areAllWithNoImage: areAllWithNoImage,
                                    comeFromWishList: true,
                                  );
                                });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            )));
  }
}
