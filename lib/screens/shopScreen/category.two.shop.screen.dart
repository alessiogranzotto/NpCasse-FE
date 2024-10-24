import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/screens/shopScreen/widget/category.card.dart';
import 'package:provider/provider.dart';

class CategoryTwoShopScreen extends StatelessWidget {
  const CategoryTwoShopScreen({
    Key? key,
    required this.masterCategoryCatalogModel,
  }) : super(key: key);
  final CategoryCatalogModel masterCategoryCatalogModel;

  final double widgetWitdh = 300;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    bool canAddProject = authenticationNotifier.canUserAddItem();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          masterCategoryCatalogModel.nameCategory,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Consumer<CategoryCatalogNotifier>(
              builder: (context, categoryCatalogNotifier, _) {
                return FutureBuilder(
                  future: categoryCatalogNotifier.getCategories(
                      context: context,
                      token: authenticationNotifier.token,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      idCategory: masterCategoryCatalogModel.idCategory,
                      levelCategory: "SubCategory",
                      numberResult: "All",
                      orderBy: "NameCategory",
                      nameDescSearch: '',
                      readAlsoDeleted: false,
                      readImageData: true),
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
                      return const Center(
                        child: Text(
                          'No data...',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    } else {
                      var tSnapshot =
                          snapshot.data as List<CategoryCatalogModel>;

                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                            crossAxisCount:
                                (MediaQuery.of(context).size.width) ~/
                                    widgetWitdh,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: gridMainAxisSpacing,
                            height: 300,
                          ),
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: tSnapshot.length,
                          // scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            CategoryCatalogModel category = tSnapshot[index];
                            return GestureDetector(
                              onTap: () {
                                categoryCatalogNotifier
                                    .setCurrentCategoryCatalog(category);
                                Navigator.of(context).pushNamed(
                                    AppRouter.categoryProductShopRoute);
                              },
                              child: CategoryCard(
                                categoryCatalogModel: category,
                              ),
                            );
                          });
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
