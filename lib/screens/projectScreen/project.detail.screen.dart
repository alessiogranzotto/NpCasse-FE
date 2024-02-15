import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/project.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel projectModelArgument;
  // final ProjectDetailsArgs projectDetailsArguments;
  const ProjectDetailScreen({
    Key? key,
    required this.projectModelArgument,
  }) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetailScreen> {
  final TextEditingController textEditingControllerNameProject =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionProject =
      TextEditingController();
  String tImageString = '';
  // final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.projectModelArgument.idProject != 0) {
      textEditingControllerNameProject.text =
          widget.projectModelArgument.nameProject;
      textEditingControllerDescriptionProject.text =
          widget.projectModelArgument.descriptionProject;
      tImageString = widget.projectModelArgument.imageProject;
    } else {
      //tImageString = AppAssets.noImageString;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);

    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Dettaglio progetto: ${projectNotifier.getNameProject}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                ProjectModel projectModel = ProjectModel(
                    idProject: widget.projectModelArgument.idProject,
                    idUserAppInstitution:
                        widget.projectModelArgument.idUserAppInstitution,
                    nameProject: textEditingControllerNameProject.text,
                    descriptionProject:
                        textEditingControllerDescriptionProject.text,
                    imageProject: tImageString);
                projectNotifier
                    .addOrUpdateProject(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        projectModel: projectModel)
                    .then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                        text: 'Info Updated',
                        context: context,
                      ),
                    );
                    Navigator.of(context).pop();
                    projectNotifier.refresh();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                        text: 'Error Please Try Again , After a While',
                        context: context,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                });
              },
              icon: const Icon(Icons.check)),
        ],
      ),
      body: ListView(
        children: [
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) / 5,
                    height: (MediaQuery.of(context).size.width) / 2,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.width) / 2,
                      width: (MediaQuery.of(context).size.width) / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        image: DecorationImage(
                                          image: ImageUtils.getImageFromString(
                                                  stringImage: tImageString)
                                              .image,
                                        )),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: ImageUtils.getImageFromString(
                                            stringImage: tImageString)
                                        .image,
                                    fit: BoxFit.contain),
                              ),
                            )

                            // CircleAvatar(
                            //     backgroundImage: ImageUtils.getImageFromString(
                            //             stringImage: tImageString)
                            //         .image),
                            ),
                      ),
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.width) / 2,
                    width: (MediaQuery.of(context).size.width) / 5,
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.photo_camera),
                      onPressed: () {
                        showModalBottomSheet(
                          isDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: Text(
                                    'Capture Image',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    ImageUtils.imageSelectorCamera()
                                        .then((value) {
                                      setState(() {
                                        tImageString = value;
                                      });
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.folder),
                                  title: Text(
                                    'Select Image',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    ImageUtils.imageSelectorFile()
                                        .then((value) {
                                      setState(() {
                                        tImageString = value;
                                      });
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: Text(
                                    'Delete Image',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      tImageString = tImageString =
                                          ImageUtils.setNoImage();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.undo),
                                  title: Text(
                                    'Undo',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const ListTile(
                                  title: Text(''),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: ListTile(
              // title: Text(
              //   'Nome Progetto',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              // ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //onChanged: ,
                      controller: textEditingControllerNameProject,
                      minLines: 3,
                      maxLines: 3,
                      //maxLength: 300,
                      //keyboardType: ,
                      // decoration: const InputDecoration(
                      //   prefixText: '€ ',
                      //   label: Text('amount'),
                      // ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.edit),
              leading: const Icon(Icons.title),
              onTap: () {},
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: ListTile(
              // title: Text(
              //   'qui ci va la descrizione del progetto',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, ),
              // ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //onChanged: ,
                      controller: textEditingControllerDescriptionProject,

                      minLines: 5,
                      maxLines: 5,

                      //maxLength: 300,
                      //keyboardType: ,
                      // decoration: const InputDecoration(
                      //   prefixText: '€ ',
                      //   label: Text('amount'),
                      // ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.edit),
              leading: const Icon(Icons.topic),
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }
}
