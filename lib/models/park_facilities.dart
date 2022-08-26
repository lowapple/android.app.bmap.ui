class ParkFacilities {
  bool? elevator;
  bool? wideExit;
  bool? ramp;
  bool? accessRoads;
  bool? wheelchairLift;
  bool? brailleBlock;
  bool? exGuidance;
  bool? exTicketOffice;
  bool? exRestroom;

  ParkFacilities(
      {this.elevator,
      this.wideExit,
      this.ramp,
      this.accessRoads,
      this.wheelchairLift,
      this.brailleBlock,
      this.exGuidance,
      this.exTicketOffice,
      this.exRestroom});

  ParkFacilities.fromJson(Map<String, dynamic> json) {
    elevator = json['elevator'] ?? false;
    wideExit = json['wideExit'] ?? false;
    ramp = json['ramp'] ?? false;
    accessRoads = json['accessRoads'] ?? false;
    wheelchairLift = json['wheelchairLift'] ?? false;
    brailleBlock = json['brailleBlock'] ?? false;
    exGuidance = json['exGuidance'] ?? false;
    exTicketOffice = json['exTicketOffice'] ?? false;
    exRestroom = json['exRestroom'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['elevator'] = elevator;
    data['wideExit'] = wideExit;
    data['ramp'] = ramp;
    data['accessRoads'] = accessRoads;
    data['wheelchairLift'] = wheelchairLift;
    data['brailleBlock'] = brailleBlock;
    data['exGuidance'] = exGuidance;
    data['exTicketOffice'] = exTicketOffice;
    data['exRestroom'] = exRestroom;
    return data;
  }
}
