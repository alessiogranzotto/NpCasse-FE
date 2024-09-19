import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/shop.category.notifier.dart';
import 'package:np_casse/screens/shopScreen/widget/category.card.dart';
import 'package:provider/provider.dart';

class CategoryOneShopScreen extends StatelessWidget {
  const CategoryOneShopScreen({super.key});

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
    //canAddProject = true;
    // // Set the default number of columns to 3.
    // int columnsCount = 3;
    // // Define the icon size based on the screen width
    // double iconSize = 45;

    // // Use the ResponsiveUtils class to determine the device's screen size.
    // if (ResponsiveUtils.isMobile(context)) {
    //   columnsCount = 2;
    //   iconSize = 30;
    // } else if (ResponsiveUtils.isDesktop(context)) {
    //   columnsCount = 4;
    //   iconSize = 50;
    // }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Shop ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Consumer<ShopCategoryNotifier>(
              builder: (context, shopCategoryNotifier, _) {
                return FutureBuilder(
                  future: shopCategoryNotifier.getCategories(
                      context: context,
                      token: authenticationNotifier.token,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      idCategory: 0,
                      levelCategory: "FirstLevelCategory",
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
                                //projectNotifier.setProject(project);

                                Navigator.of(context).pushNamed(
                                    AppRouter.categoryTwoShopRoute,
                                    arguments: category);
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
