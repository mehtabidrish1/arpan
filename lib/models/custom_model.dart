class MyModel {
  String? id;
  String? value;

  MyModel({this.id, this.value});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
      };
}
