class IndirectDataUploadImageModel {
  String? image;
  String? indirectDataGuid;
  String? isUploaded;

  IndirectDataUploadImageModel(
      this.image, this.indirectDataGuid, this.isUploaded);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'image': image,
      'IndirectDataGuid': indirectDataGuid,
      'isUploaded': isUploaded
    };
    return map;
  }

  IndirectDataUploadImageModel.fromMap(Map<String, dynamic> map) {
    image = map['image'];
    indirectDataGuid = map["IndirectDataGuid"];
    isUploaded = map["isUploaded"];
  }
}
