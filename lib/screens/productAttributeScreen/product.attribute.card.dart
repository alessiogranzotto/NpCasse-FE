import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/product.attribute.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class ProductAttributeCard extends StatelessWidget {
  const ProductAttributeCard({
    Key? key,
    required this.productAttributeModel,
  }) : super(key: key);
  final ProductAttributeModel productAttributeModel;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    child: Text(productAttributeModel.name.substring(0, 1),
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.productAttributeDetailRoute,
                            arguments: ProductAttributeModel(
                                idProductAttribute:
                                    productAttributeModel.idProductAttribute,
                                name: productAttributeModel.name,
                                description: productAttributeModel.description,
                                idUserAppInstitution: cUserAppInstitutionModel
                                    .idUserAppInstitution,
                                predefinedProductAttributeValues:
                                    productAttributeModel
                                        .predefinedProductAttributeValues),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productAttributeModel.name
                  //  +
                  //     (ProductAttributeModel.description.isNotEmpty
                  //         ? ' (${ProductAttributeModel.description})'
                  //         : '')
                  ,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  productAttributeModel.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
