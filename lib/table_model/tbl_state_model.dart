class TblStateModel {
  int? stateId;
  String? stateName;
  String? stateCode;
  bool? active;

  TblStateModel({
    this.stateId,
    this.stateName,
    this.stateCode,
    this.active,
  });

  factory TblStateModel.fromJson(Map<String, dynamic> json) => TblStateModel(
        stateId: json["StateID"],
        stateName: json["StateName"],
        stateCode: json["StateCode"],
        active: json["Active"] == null
            ? null
            : json["Active"].toString() == 'true' ||
                    json["Active"].toString() == '1'
                ? true
                : false,
      );

  Map<String, dynamic> toJson() => {
        "StateID": stateId,
        "StateName": stateName,
        "StateCode": stateCode,
        "Active": active.toString(),
      };
}
