import 'package:cloud_firestore/cloud_firestore.dart';

class VisitModel {
  String visitId;
  // String userId;
  // String memberId;
  String doctorId;
  String date;
  String reason;
  DateTime createdAt;

  VisitModel({required this.visitId, required this.doctorId, required this.date, required this.createdAt, required this.reason});

  factory VisitModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return VisitModel(
        visitId: doc.id,
        // userId: data['userId'] as String?,
        doctorId: data['doctorId'] as String,
        date: data['date'] as String,
        reason: data['reason'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      // Handle the exception, you might want to log this error or set default values
      print('Error converting document snapshot to VisitModel: $e');
      throw e; // Re-throw the exception after logging it or handling it as necessary
    }
  }
  Map<String, dynamic> toJson() => {
        // 'visitId': visitId,
        // 'userId': userId,
        // 'memberId': memberId,
        'doctorId': doctorId,
        'date': date,
        'createdAt': createdAt,
        'reason': reason,
      };
}
