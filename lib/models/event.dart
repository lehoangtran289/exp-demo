class Event {
  String eventSrc;
  String objectName;
  String objectType;
  String action;

  // identity
  String? identity;
  String? installId;

  // session
  String? deviceSessionId;
  String? userSessionId;

  // device
  String? manufacturer;
  String? model;
  String? language;
  String? os;
  String? osVersion;
  String? ipAddr;

  Event({required this.objectName,
      required this.objectType,
      required this.eventSrc,
      required this.action,
      this.identity,
      this.installId,
      this.deviceSessionId,
      this.userSessionId,
      this.manufacturer,
      this.model,
      this.language,
      this.os,
      this.osVersion,
      this.ipAddr});


}
