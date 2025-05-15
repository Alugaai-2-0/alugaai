class ConnectionModel {
  final int? id;
  final int studentId;
  final String studentName;
  final String status;
  final String? requestDate;
  final String? responseDate;

  ConnectionModel({
    this.id,
    required this.studentId,
    required this.studentName,
    required this.status,
    this.requestDate,
    this.responseDate,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      status: json['status'],
      requestDate: json['requestDate'],
      responseDate: json['responseDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'status': status,
      'requestDate': requestDate,
      'responseDate': responseDate,
    };
  }
}