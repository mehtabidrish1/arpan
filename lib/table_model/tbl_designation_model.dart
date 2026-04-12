class TblDesignationModel {
  int? id;
  String? ministryId;
  String? englishDesignation;
  String? marathiDesignation;
  String? hindiDesignation;

  TblDesignationModel({
    this.id,
    this.ministryId,
    this.englishDesignation,
    this.marathiDesignation,
    this.hindiDesignation,
  });

  factory TblDesignationModel.fromJson(Map<String, dynamic> json) =>
      TblDesignationModel(
        id: json['Id'],
        ministryId: json["MinistryId"].toString(),
        englishDesignation: json["EnglishDesignation"],
        marathiDesignation: json["MarathiDesignation"],
        hindiDesignation: json["HindiDesignation"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "MinistryId": ministryId,
        "EnglishDesignation": englishDesignation,
        "MarathiDesignation": marathiDesignation,
        "HindiDesignation": hindiDesignation,
      };
}
