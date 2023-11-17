import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String displayName;
  String email;
  DateTime createdAt;

  UserModel({required this.uid, required this.displayName, required this.email, required this.createdAt});

  UserModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : uid = doc.id,
        displayName = (doc.data() as Map<String, dynamic>)['displayName'],
        email = (doc.data() as Map<String, dynamic>)['email'],
        createdAt = (doc.data() as Map<String, dynamic>)['createdAt']?.toDate(); // Use `?.toDate()` to handle potential nulls

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'createdAt': createdAt,
      };
}
