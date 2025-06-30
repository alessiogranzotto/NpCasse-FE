import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

// Custom Table Footer Widget
class CustomTableFooter<K extends Comparable<K>, T> extends StatelessWidget {
  final int totalItems;
  final double totalAmount;
  final Widget? child;
  final PagedDataTableController<K, T> controller;

  const CustomTableFooter({
    required this.totalItems,
    required this.totalAmount, // Ensure totalItems is required
    required this.controller, // Pass the controller here
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Record totali: $totalItems', // Display totalItems in footer
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        totalAmount > 0
            ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Importi totali: ' +
                      totalAmount.toStringAsFixed(2).replaceAll('.', ',') +
                      ' €', // Display totalAmount in footer
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              )
            : SizedBox.shrink(),
        if (child != null) Expanded(child: child!) else const Spacer(),
        RefreshTable<K, T>(),
        const VerticalDivider(
            color: Color(0xFFD6D6D6), width: 3, indent: 10, endIndent: 10),
        PageSizeSelector<K, T>(),
        const VerticalDivider(
            color: Color(0xFFD6D6D6), width: 3, indent: 10, endIndent: 10),
        CurrentPage<K, T>(),
        const VerticalDivider(
            color: Color(0xFFD6D6D6), width: 3, indent: 10, endIndent: 10),
        NavigationButtons<K, T>(),
      ],
    );
  }
}
