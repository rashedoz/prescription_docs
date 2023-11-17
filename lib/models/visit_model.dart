// import 'package:cloud_firestore/cloud_firestore.dart';

// class VisitModel {
//   String visitId;
//   String userId;
//   String memberId;
//   String doctorId;
//   DateTime date;
//   DateTime createdAt;

//   VisitModel({required this.visitId, required this.userId, required this.memberId, required this.doctorId, required this.date, required this.createdAt});

//   VisitModel.fromDocumentSnapshot(DocumentSnapshot doc)
//       : visitId = doc.id,
//         userId = (doc.data() as Map<String, dynamic>)['userId'],
//         memberId = (doc.data() as Map<String, dynamic>)['memberId'],
//         doctorId = (doc.data() as Map<String, dynamic>)['doctorId'],
//         date = (doc.data() as Map<String, dynamic>)['date']?.toDate(),
//         createdAt = (doc.data() as Map<String, dynamic>)['createdAt']?.toDate(); // Use `?.toDate()` to handle potential nulls

//   Map<String, dynamic> toJson() => {
//         'visitId': visitId,
//         'userId': userId,
//         'memberId': memberId,
//         'doctorId': doctorId,
//         'date': date,
//         'createdAt': createdAt,
//       };
// }
