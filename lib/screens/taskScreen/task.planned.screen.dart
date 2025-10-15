import 'dart:async';

import 'package:flutter/material.dart';

import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/componenents/empty.data.widget.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/task.planned.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/task.planned.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/screens/taskScreen/task.planned.card.dart';
import 'package:provider/provider.dart';

class TaskPlannedScreen extends StatefulWidget {
  const TaskPlannedScreen({super.key});

  @override
  State<TaskPlannedScreen> createState() => _TaskPlannedScreenState();
}

class _TaskPlannedScreenState extends State<TaskPlannedScreen> {
  bool filtersExpanded = true;
  final double widgetWitdh = 300;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;
  final double widgetHeight = 150;
  bool readAlsoDeleted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          'Procedure pianificate ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fila fissa dei filtri
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: CheckboxListTile(
                        side: const BorderSide(color: Colors.blueGrey),
                        checkColor: Colors.blueAccent,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        activeColor: Colors.blueAccent,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: readAlsoDeleted,
                        onChanged: (bool? value) {
                          setState(() {
                            readAlsoDeleted = value!;
                          });
                        },
                        title: Text(
                          'Mostra anche archiviate',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.blueGrey),
                        ),
                      )),
                ],
              ),
            ),

            // Griglia di card
            Expanded(
              child: Consumer<TaskPlannedNotifier>(
                builder: (context, taskPlannedNotifier, child) {
                  return FutureBuilder(
                    future: taskPlannedNotifier.getTaskPlanned(
                      context: context,
                      token: authenticationNotifier.token,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      idInstitution: cUserAppInstitutionModel
                          .idInstitutionNavigation.idInstitution,
                      readAlsoDeleted: readAlsoDeleted,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            color: Colors.redAccent,
                          ),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Errore: ${snapshot.error}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        );
                      } else if (!snapshot.hasData ||
                          (snapshot.data as List).isEmpty) {
                        return const EmptyDataWidget(
                          title: "Dati non presenti",
                          message:
                              "Non ci sono elementi da mostrare al momento.",
                        );
                      } else {
                        List<TaskPlannedModel> tSnapshot =
                            snapshot.data as List<TaskPlannedModel>;
                        if (tSnapshot.isEmpty) {
                          return EmptyDataWidget(
                            title: "Dati non presenti",
                            message:
                                "Non ci sono elementi da mostrare al momento.",
                          );
                        }
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                            crossAxisCount:
                                (MediaQuery.of(context).size.width) ~/
                                    widgetWitdh,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: gridMainAxisSpacing,
                            height: widgetHeight,
                          ),
                          physics: const ScrollPhysics(),
                          itemCount: tSnapshot.length,
                          itemBuilder: (context, index) {
                            TaskPlannedModel taskPlanned = tSnapshot[index];
                            return TaskPlannedCard(taskPlanned: taskPlanned);
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRouter.taskPlannedDetailRoute,
                  arguments: TaskPlannedModel.empty(),
                );
              },
              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
