import 'package:flutter/material.dart';

class ComunicationSendingUtility {
  ComunicationSendingUtility._(); // Private constructor to prevent instantiation

  static Color getWebhooksColor(String item) {
    if (item.startsWith('Email prepared')) {
      return Colors.blueGrey;
    } else if (item.startsWith('Email processed')) {
      return Colors.yellow;
    } else if (item.startsWith('Bounced soft')) {
      return Colors.blue;
    } else if (item.startsWith('Bounced hard')) {
      return Colors.pink;
    } else if (item.startsWith('Rejected')) {
      return Colors.cyanAccent;
    } else if (item.startsWith('Marked as spam')) {
      return Colors.brown;
    } else if (item.startsWith('Delivered to recipient')) {
      return Colors.red;
    } else if (item.startsWith('Unsubscribed/Resuscribed')) {
      return Colors.purple;
    } else if (item.startsWith('Opened by recipient')) {
      return Colors.green;
    } else if (item.startsWith('Link clicked by recipient')) {
      return Colors.orange;
    } else if (item.startsWith('Error')) {
      return Colors.black;
    }
    return Colors.transparent;
  }
}
