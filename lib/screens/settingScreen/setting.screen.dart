import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(50),
              child: 
            Text('Impostazioni',
          style: Theme.of(context).textTheme.headlineLarge,)),
      ]),
    ),
    body: ListView(
      padding: EdgeInsets.all(10),
        children: [
          const ExpansionTile(
            shape:BeveledRectangleBorder(
              side: BorderSide(color: Colors.lightBlue)
            ),
          leading: Icon(Icons.account_circle_outlined),
          iconColor: Colors.lightBlue,
          title: Text('Gestione Account'),
          collapsedShape: BeveledRectangleBorder(
            side: BorderSide(color: Colors.lightBlue)),
          children: [
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: [
              CustomTextField(label: 'Nome'),
              CustomTextField(label: 'Cognome'),
              CustomTextField(label: 'Lingua'),
          ]),
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: [
              CustomTextField(label: 'Nazione'),
              CustomTextField(label: 'E-mail'),
              CustomTextField(label: 'Telefono'),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              //child: ElevatedButton(onPressed: onPressed, child: Text('Salva')),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.edit),
              Icon(Icons.bookmark),
            ],),
          ],
        ),
        ExpansionTile(
          shape:BeveledRectangleBorder(
              side: BorderSide(color: Colors.lightBlue)
          ),
          leading: Icon(Icons.build_circle_outlined),
          iconColor: Colors.lightBlue,
          title: const Text('Personalizzazione'),
          collapsedShape: BeveledRectangleBorder(
            side: BorderSide(color: Colors.lightBlue)),
          ),
        ExpansionTile(
          shape:BeveledRectangleBorder(
              side: BorderSide(color: Colors.lightBlue)
          ),
          leading: Icon(Icons.password_rounded),
          iconColor: Colors.lightBlue,
          title: const Text('Password e Privacy'),
          collapsedShape: BeveledRectangleBorder(
            side: BorderSide(color: Colors.lightBlue)),
          children: [
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: [
              CustomTextField(label: 'Password'),
              CustomTextField(label: 'Privacy'),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.edit),
              Icon(Icons.bookmark),
            ],),
          ],
          ),
        ],
      ),
    );
  }
}
class CustomTextField extends StatelessWidget {
  final String label;
  const CustomTextField({Key?key,required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width / 4 - 16,
      margin: EdgeInsets.all(4.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

