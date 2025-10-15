import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/image.utils.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class CategoryCatalogCard extends StatelessWidget {
  const CategoryCatalogCard({
    Key? key,
    required this.category,
    required this.readImageData,
  }) : super(key: key);
  final CategoryCatalogModel category;
  final bool readImageData;

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Card(
      elevation: 8,
      child: Container(
        //margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.6),
                  offset: const Offset(0.0, 0.0), //(x,y)
                  blurRadius: 4.0,
                  blurStyle: BlurStyle.solid)
            ],
            //color: Colors.white,
            color: Theme.of(context).cardColor),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            readImageData
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (ImageUtils.getImageFromStringBase64(
                                  stringImage: category.imageData)
                              .image)),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.nameCategory,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  category.descriptionCategory,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            category.parentCategoryName.isNotEmpty
                ? SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Appartiene a: ' + category.parentCategoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                  )
                : SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.categoryCatalogDetailRoute,
                              arguments: CategoryCatalogModel(
                                  idCategory: category.idCategory,
                                  nameCategory: category.nameCategory,
                                  descriptionCategory:
                                      category.descriptionCategory,
                                  parentIdCategory: category.parentIdCategory,
                                  displayOrder: category.displayOrder,
                                  deleted: category.deleted,
                                  idUserAppInstitution: cUserAppInstitutionModel
                                      .idUserAppInstitution,
                                  imageData: category.imageData,
                                  parentCategoryName:
                                      category.parentCategoryName,
                                  giveIdsFlatStructureModel:
                                      category.giveIdsFlatStructureModel),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
