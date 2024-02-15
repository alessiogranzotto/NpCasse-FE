import 'package:flutter/material.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';

Widget showUserInstitution(
    {required snapshot,
    required selection,
    required BuildContext context,
    required Function callback}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        DropdownMenu<UserAppInstitutionModel>(
            initialSelection: selection,
            // controller: colorController,
            label: const Text('Associazione:'),
            onSelected: (val) => {callback(val)},
            dropdownMenuEntries: snapshot
                .map<DropdownMenuEntry<UserAppInstitutionModel>>(
                    (UserAppInstitutionModel item) {
              return DropdownMenuEntry<UserAppInstitutionModel>(
                  value: item,
                  label: item.idInstitutionNavigation.nameInstitution);
            }).toList()),
      ],
    ),
  );
}
