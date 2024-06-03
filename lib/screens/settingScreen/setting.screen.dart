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
        children: [
          const ExpansionTile(
          title: Text('Gestione Account'),
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
          title: const Text('Personalizzazione'),
          ),
        ExpansionTile(
          title: const Text('Password e Privacy'),
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

