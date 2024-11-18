import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.mapping.notifier.dart';
import 'package:provider/provider.dart';

class ProductCatalogCard extends StatelessWidget {
  const ProductCatalogCard({
    Key? key,
    required this.product,
    required this.readImageData,
    required this.areAllWithNoImage,
    required this.comeFromWishList,
  }) : super(key: key);
  final ProductCatalogModel product;
  final bool readImageData;
  final bool areAllWithNoImage;
  final bool comeFromWishList;

  String getProductCategoriesString(ProductCatalogModel product) {
    String result = '';
    for (int i = 0; i < product.productCategoryMappingModel.length; i++) {
      result = result +
          product.productCategoryMappingModel[i].categoryModel.nameCategory +
          ' - ';
    }
    if (result.length > 0) {
      result = result.substring(0, result.length - 3);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    ProductAttributeMappingNotifier productAttributeMappingNotifier =
        Provider.of<ProductAttributeMappingNotifier>(context);
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
                                  stringImage: product.imageData)
                              .image)),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.nameProduct,
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
                  product.descriptionProduct,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  getProductCategoriesString(product),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ),
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
                      child: Tooltip(
                        message: 'Gestione dati principali',
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRouter.productCatalogDetailDataRoute,
                                arguments: ProductCatalogModel(
                                    idProduct: product.idProduct,
                                    idCategory: product.idCategory,
                                    nameProduct: product.nameProduct,
                                    displayOrder: product.displayOrder,
                                    descriptionProduct:
                                        product.descriptionProduct,
                                    priceProduct: product.priceProduct,
                                    freePriceProduct: product.freePriceProduct,
                                    outOfAssortment: product.outOfAssortment,
                                    wishlisted: product.wishlisted,
                                    barcode: product.barcode,
                                    deleted: product.deleted,
                                    idUserAppInstitution:
                                        cUserAppInstitutionModel
                                            .idUserAppInstitution,
                                    imageData: product.imageData,
                                    // categoryName: product.categoryName,
                                    giveIdsFlatStructureModel:
                                        product.giveIdsFlatStructureModel,
                                    productAttributeCombination:
                                        product.productAttributeCombination,
                                    productCategoryMappingModel:
                                        product.productCategoryMappingModel,
                                    smartProductAttributeJson:
                                        product.smartProductAttributeJson),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Tooltip(
                        message: ' Gestione attributi',
                        child: IconButton(
                            onPressed: () {
                              productAttributeMappingNotifier
                                  .getProductAttributeMapping(
                                context: context,
                                token: authenticationNotifier.token,
                                idUserAppInstitution: cUserAppInstitutionModel
                                    .idUserAppInstitution,
                                idProduct: product.idProduct,
                                readAlsoDeleted: false,
                                numberResult: 'All',
                              )
                                  .then((value) {
                                ProductCatalogDetailAttributeMultipleArgument
                                    cProductCatalogDetailAttributeMultipleArgument =
                                    new ProductCatalogDetailAttributeMultipleArgument(
                                        product: product,
                                        productAttributeMappingModelList:
                                            value);

                                Navigator.of(context).pushNamed(
                                  AppRouter.productCatalogDetailAttributeRoute,
                                  arguments:
                                      cProductCatalogDetailAttributeMultipleArgument,
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.shopping_bag,
                              size: 20,
                            )),
                      ),
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
