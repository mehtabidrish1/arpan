class TblMasterModel {
  TblMasterModel({
    required this.id,
    required this.value,
    required this.text,
    required this.flag,
  });

  int id;
  String value;
  String text;
  String flag;

  factory TblMasterModel.fromJson(Map<String, dynamic> json) => TblMasterModel(
        id: json["Id"],
        value: json["Value"].toString(),
        text: json["Text"],
        flag: json["Flag"]!,
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Value": value,
        "Text": text,
        "Flag": flag,
      };
}
