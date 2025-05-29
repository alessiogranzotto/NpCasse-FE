import 'package:intl/intl.dart';

class WebhooksEvent {
  WebhooksEvent({
    required this.event,
    required this.dateUpdate,
  });

  late final String event;
  late final DateTime dateUpdate;

  // Empty constructor with default values
  WebhooksEvent.empty() {
    event = '';
    dateUpdate = DateTime.now();
  }
  // JSON deserialization
  WebhooksEvent.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    var dateTimeU =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['dateUpdate'], true);
    dateUpdate = dateTimeU.toLocal();
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['event'] = event;
    data['dateUpdate'] = dateUpdate;
    return data;
  }
}

class ComunicationModelForEventDetail {
  ComunicationModelForEventDetail({
    required this.emailSh,
    required this.emailId,
    required this.webhooksEvent,
    required this.dateLastUpdate,
  });

  late final String emailSh;
  late final String emailId;
  late final List<WebhooksEvent>? webhooksEvent;
  late final DateTime? dateLastUpdate;
}
