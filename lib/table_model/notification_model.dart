class NotificationModel{

  String? notificationtype;
  String? notificationmsg;
 NotificationModel({
    this.notificationtype,
    this.notificationmsg
  });

  Map<String, dynamic> toMap() {
    return {
      'notificationtype': notificationtype,
      'notificationmsg': notificationmsg,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationtype: map['notificationtype'],
      notificationmsg: map['notificationmsg'],
    );
  }
   
}