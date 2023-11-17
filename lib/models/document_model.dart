// import 'package:cloud_firestore/cloud_firestore.dart';

// class DocumentModel {
//   String documentId;
//   String visitId;
//   String type;
//   String url;
//   DateTime createdAt;

//   DocumentModel({required this.documentId, required this.visitId, required this.type, required this.url, required this.createdAt});

//   DocumentModel.fromDocumentSnapshot(DocumentSnapshot doc)
//       : documentId = doc.id,
//         visitId = (doc.data() as Map<String, dynamic>)['visitId'],
//         type = (doc.data() as Map<String, dynamic>)['type'],
//         url = (doc.data() as Map<String, dynamic>)['url'],
//         createdAt = (doc.data() as Map<String, dynamic>)['createdAt']?.toDate(); // Use `?.toDate()` to handle potential nulls

//   Map<String, dynamic> toJson() => {
//         'documentId': documentId,
//         'visitId': visitId,
//         'type': type,
//         'url': url,
//         'createdAt': createdAt,
//       };
// }
