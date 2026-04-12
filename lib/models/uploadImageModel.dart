class UploadImageModel {
  String? image;
  String? registrationGuid;
  String? isUploaded;

  UploadImageModel(this.image, this.registrationGuid, this.isUploaded);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'image': image,
      'registrationGuid': registrationGuid,
      'isUploaded': isUploaded
    };
    return map;
  }

  UploadImageModel.fromMap(Map<String, dynamic> map) {
    image = map['image'];
    registrationGuid = map["registrationGuid"];
    isUploaded = map["isUploaded"];
  }
}
