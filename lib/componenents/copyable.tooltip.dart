import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableTooltip extends StatelessWidget {
  final List<String> items;
  final String tooltipMessage;

  const CopyableTooltip({
    Key? key,
    required this.items,
    this.tooltipMessage = "Cliccare per copiare un elemento",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      preferBelow: false,
      verticalOffset: 12,
      margin: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          showCopyMenu(context);
        },
        child: const Icon(Icons.help_outline),
      ),
    );
  }

  void showCopyMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300, // limite massimo altezza
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      item,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.copy, size: 18),
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: item));
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
