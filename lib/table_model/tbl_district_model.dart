class TblDistrictModel {
  int? stateId;
  int? districtId;
  String? districtName;
  bool? active;

  TblDistrictModel({
    this.stateId,
    this.districtId,
    this.districtName,
    this.active,
  });

  factory TblDistrictModel.fromJson(Map<String, dynamic> json) =>
      TblDistrictModel(
        stateId: json["stateID"],
        districtId: json["districtID"],
        districtName: json["districtName"],
        active: json["Active"] == null
            ? null
            : json["Active"].toString() == 'true' ||
                    json["Active"].toString() == '1'
                ? true
                : false,
      );

  Map<String, dynamic> toJson() => {
        "stateID": stateId,
        "districtID": districtId,
        "districtName": districtName,
        "Active": active.toString(),
      };
}
