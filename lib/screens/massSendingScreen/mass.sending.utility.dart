import 'package:flutter/material.dart';
import 'package:np_casse/core/models/mass.sending.job.model.dart';

class MassSendingUtility {
  MassSendingUtility._(); // Private constructor to prevent instantiation

  static Color getWebhooksColor(String item) {
    if (item == 'Email prepared') {
      return Colors.blueGrey;
    } else if (item == 'Email processed') {
      return Colors.yellow;
    } else if (item == 'Bounced') {
      return Colors.blue;
    } else if (item == 'Rejected') {
      return Colors.cyanAccent;
    } else if (item == 'Marked as spam') {
      return Colors.brown;
    } else if (item == 'Delivered to recipient') {
      return Colors.red;
    } else if (item == 'Unsubscribed/Resuscribed') {
      return Colors.purple;
    } else if (item == 'Opened by recipient') {
      return Colors.green;
    } else if (item == 'Link clicked by recipient') {
      return Colors.orange;
    } else if (item == 'Error') {
      return Colors.black;
    }
    return Colors.transparent;
  }
}
