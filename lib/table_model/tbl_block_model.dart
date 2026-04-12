class BlockDatum {
  int? id;
  int? stateId;
  String? districtId;
  String? blockName;
  bool? active;

  BlockDatum({
    this.id,
    this.stateId,
    this.districtId,
    this.blockName,
    this.active,
  });

  factory BlockDatum.fromJson(Map<String, dynamic> json) => BlockDatum(
        id: json["ID"],
        stateId: json["stateID"],
        districtId: json["districtID"],
        blockName: json["BlockName"],
        active: json["Active"] == null
            ? null
            : json["Active"].toString() == 'true' ||
                    json["Active"].toString() == '1'
                ? true
                : false,
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "stateID": stateId,
        "districtID": districtId,
        "BlockName": blockName,
        "Active": active.toString(),
      };
}
