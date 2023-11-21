import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String doctorId;
  String name;
  String specialty;
  String contact;
  DateTime createdAt;

  DoctorModel({required this.doctorId, required this.name, required this.specialty, required this.contact, required this.createdAt});

  DoctorModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : doctorId = doc.id,
        name = (doc.data() as Map<String, dynamic>)['name'],
        specialty = (doc.data() as Map<String, dynamic>)['specialty'],
        contact = (doc.data() as Map<String, dynamic>)['contact'],
        createdAt = (doc.data() as Map<String, dynamic>)['createdAt']?.toDate(); // Use `?.toDate()` to handle potential nulls

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'name': name,
        'specialty': specialty,
        'contact': contact,
        'createdAt': createdAt,
      };
}
