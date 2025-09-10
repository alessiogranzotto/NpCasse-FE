import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/task.planned.model.dart';
import 'package:np_casse/screens/taskScreen/task.utils.dart';

class TaskPlannedCard extends StatelessWidget {
  const TaskPlannedCard({
    Key? key,
    required this.taskPlanned,
  }) : super(key: key);
  final TaskPlannedModel taskPlanned;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icona in base allo scope del task
                  TaskUtils.getIconByTaskCommonScope(
                    taskPlanned.idTaskCommonNavigation!.scopeTaskCommon,
                  ),
                  const SizedBox(width: 10),

                  // Testo adattabile con ellissi
                  Flexible(
                    child: Text(
                      taskPlanned.idTaskCommonNavigation!.nameTaskCommon,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),

                  // Spacer per spingere l'IconButton a destra
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRouter.taskPlannedDetailRoute,
                                arguments: TaskPlannedModel(
                                  idTaskPlanned: taskPlanned.idTaskPlanned,
                                  nameTaskPlanned: taskPlanned.nameTaskPlanned,
                                  idTaskCommon: taskPlanned.idTaskCommon,
                                  idInstitution: taskPlanned.idInstitution,
                                  rangeExtractionTaskPlanned:
                                      taskPlanned.rangeExtractionTaskPlanned,
                                  timePlanTaskPlanned:
                                      taskPlanned.timePlanTaskPlanned,
                                  exportModeTaskPlanned:
                                      taskPlanned.exportModeTaskPlanned,
                                  sendModeTaskPlanned:
                                      taskPlanned.sendModeTaskPlanned,
                                  recipientEmailTaskPlanned:
                                      taskPlanned.recipientEmailTaskPlanned,
                                  ftpServerTaskPlanned:
                                      taskPlanned.ftpServerTaskPlanned,
                                  ftpUsernameTaskPlanned:
                                      taskPlanned.ftpUsernameTaskPlanned,
                                  ftpPasswordTaskPlanned:
                                      taskPlanned.ftpPasswordTaskPlanned,
                                  deleted: taskPlanned.deleted,
                                ));
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    taskPlanned.nameTaskPlanned,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.query_builder),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    taskPlanned.timePlanTaskPlanned == null
                        ? ""
                        : '${taskPlanned.timePlanTaskPlanned!.hour.toString().padLeft(2, '0')}:${taskPlanned.timePlanTaskPlanned!.minute.toString().padLeft(2, '0')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
