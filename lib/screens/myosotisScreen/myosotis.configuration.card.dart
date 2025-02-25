import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/myosotis.configuration.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class MyosotisConfigurationCard extends StatelessWidget {
  const MyosotisConfigurationCard(
      {Key? key, required this.myosotisConfiguration})
      : super(key: key);
  final MyosotisConfigurationModel myosotisConfiguration;

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
            // readImageData
            //     ? Container(
            //         margin: const EdgeInsets.symmetric(horizontal: 0),
            //         height: 150,
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //               fit: BoxFit.cover,
            //               image: (ImageUtils.getImageFromStringBase64(
            //                       stringImage: category.imageData)
            //                   .image)),
            //         ),
            //       )
            //     : SizedBox.shrink(),
            SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  myosotisConfiguration.nameMyosotisConfiguration,
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
                  myosotisConfiguration.descriptionMyosotisConfiguration,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
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
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.myosotisConfigurationDetailRoute,
                              arguments: MyosotisConfigurationModel(
                                idMyosotisConfiguration: myosotisConfiguration
                                    .idMyosotisConfiguration,
                                nameMyosotisConfiguration: myosotisConfiguration
                                    .nameMyosotisConfiguration,
                                descriptionMyosotisConfiguration:
                                    myosotisConfiguration
                                        .descriptionMyosotisConfiguration,
                                enabledDeviceMyosotisConfiguration:
                                    myosotisConfiguration
                                        .enabledDeviceMyosotisConfiguration,
                                archived: myosotisConfiguration.archived,
                                myosotisConfigurationDetailModel:
                                    myosotisConfiguration
                                        .myosotisConfigurationDetailModel,
                                idInstitution: cUserAppInstitutionModel
                                    .idInstitutionNavigation.idInstitution,
                                idUserAppInstitution: cUserAppInstitutionModel
                                    .idUserAppInstitution,
                              ),
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
