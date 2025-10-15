// import 'package:flutter/material.dart';
// import 'dart:convert';

// // Simuliamo la risposta dell'API
// const sampleApiResponse = '''
// {
//   "name": "Cart",
//   "children": [
//     { "name": "IdCart", "type": "long" },
//     { "name": "IdUserAppInstitution", "type": "long" },
//     { "name": "IdInstitution", "type": "int" },
//     { "name": "DateCreatedCart", "type": "DateTime" },
//     { "name": "StateCart", "type": "int" },
//     { "name": "PaymentTypeCart", "type": "string" },
//     { "name": "DocNumberCart", "type": "int" },
//     { "name": "NotesCart", "type": "string?" },
//     { "name": "CartProduct", "children": [
//         { "name": "IdCartProduct", "type": "long" },
//         { "name": "IdCart", "type": "long" },
//         { "name": "IdProduct", "type": "long" },
//         { "name": "NameProduct", "type": "string" },
//         { "name": "PriceCartProduct", "type": "decimal" }
//       ]
//     }
//   ]
// }
// ''';

// // Funzione ricorsiva per creare TreeNode da JSON
// List<TreeNode<String>> buildNodes(Map<String, dynamic> json) {
//   final children = <TreeNode<String>>[];
//   if (json.containsKey('children')) {
//     for (var child in json['children']) {
//       children.addAll(buildNodes(child));
//     }
//   }

//   // Nodo con figli se ci sono children
//   return [
//     TreeNode<String>(
//       label: Text(json['type'] != null
//           ? "${json['name']} : ${json['type']}"
//           : json['name']),
//       value: json['name'],
//       children: json.containsKey('children')
//           ? (json['children'] as List)
//               .map<TreeNode<String>>((c) => buildNodes(c)[0])
//               .toList()
//           : [],
//     ),
//   ];
// }

// class ExtractionMainScreen extends StatefulWidget {
//   const ExtractionMainScreen({super.key});

//   @override
//   State<ExtractionMainScreen> createState() => _ExtractionMainScreenState();
// }

// class _ExtractionMainScreenState extends State<ExtractionMainScreen> {
//   final _treeKey = GlobalKey<TreeViewState<String>>();
//   List<String> _selectedValues = [];
//   List<TreeNode<String>> nodes = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() {
//     // Simuliamo la chiamata API
//     final jsonData = json.decode(sampleApiResponse) as Map<String, dynamic>;
//     setState(() {
//       nodes = buildNodes(jsonData);
//     });
//   }

//   void _expandAll() => _treeKey.currentState?.expandAll();
//   void _collapseAll() => _treeKey.currentState?.collapseAll();
//   void _selectAll(bool v) => _treeKey.currentState?.setSelectAll(v);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("CartModel Explorer")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Wrap(
//               spacing: 8,
//               children: [
//                 ElevatedButton(
//                     onPressed: _expandAll, child: const Text('Expand All')),
//                 ElevatedButton(
//                     onPressed: _collapseAll, child: const Text('Collapse All')),
//                 ElevatedButton(
//                     onPressed: () => _selectAll(true),
//                     child: const Text('Select All')),
//                 ElevatedButton(
//                     onPressed: () => _selectAll(false),
//                     child: const Text('Deselect All')),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: TreeView<String>(
//                 key: _treeKey,
//                 nodes: nodes,
//                 initialExpandedLevels: 1,
//                 showExpandCollapseButton: true,
//                 showSelectAll: true,
//                 selectAllWidget: const Text('Select All'),
//                 onSelectionChanged: (values) {
//                   setState(() =>
//                       _selectedValues = values.whereType<String>().toList());
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _selectedValues.isEmpty
//           ? null
//           : Padding(
//               padding: const EdgeInsets.all(12),
//               child: Text("Selezionati: ${_selectedValues.join(', ')}"),
//             ),
//     );
//   }
// }

// void main() {
//   runApp(const MaterialApp(home: ExtractionMainScreen()));
// }
