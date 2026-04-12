class ErrorLog {
  String? timestamp;
  String? errorMessage;
  String? stackTrace;
  int? isUpload = 0;

  ErrorLog({
    this.timestamp,
    this.errorMessage,
    this.stackTrace,
    this.isUpload,
  });

  factory ErrorLog.fromMap(Map<String, dynamic> map) {
    return ErrorLog(
      timestamp: map['timestamp'],
      errorMessage: map['errorMessage'],
      stackTrace: map['stackTrace'],
      isUpload: map['IsUpload'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'errorMessage': errorMessage,
      'stackTrace': stackTrace,
      'IsUpload': isUpload,
    };
  }
}
