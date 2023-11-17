import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  String memberId;
  String name;
  String relationship;
  String bithDate;
  String createdAt;

  MemberModel({required this.memberId, required this.name, required this.relationship, required this.createdAt, required this.bithDate});

  MemberModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : memberId = doc.id,
        name = (doc.data() as Map<String, dynamic>)['name'],
        relationship = (doc.data() as Map<String, dynamic>)['relationship'],
        bithDate = (doc.data() as Map<String, dynamic>)['bithDate'],
        createdAt = (doc.data() as Map<String, dynamic>)['createdAt'];

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'name': name,
        'relationship': relationship,
        'bithDate': bithDate,
        'createdAt': createdAt,
      };
}
