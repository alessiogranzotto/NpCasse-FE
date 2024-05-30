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
    body: Column(
        children: [
          Expanded(
            child:  ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.black,
              width: 0.4,
            ),
          ),
          child: ExpansionTile(
            leading: const Icon(Icons.check),
            title: Text('Gestione Account'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        visualDensity:
                            VisualDensity(vertical: -4, horizontal: 0),
                        contentPadding: EdgeInsets.zero,
                        title: Text('Your Title $index'),
                        subtitle: Text('Your Description $index'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.edit),
                          Icon(Icons.bookmark),
                          Icon(Icons.delete),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ],
              
            ),
            );
            },
          ),
          ),
        ],
      ),
    );
  }
}
