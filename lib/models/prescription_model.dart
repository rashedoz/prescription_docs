// // |--- prescriptions (Sub-collection)
//                         |--- PID101 (Document)
//                             |-- images: ["url1", "url2"]
//                             |-- prescribedBy: "Dr. Smith"
//                             |-- createdAt: Timestamp

import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionModel {
  String prescriptionId;
  String prescribedBy;
  List<dynamic> images;
  DateTime createdAt;

  PrescriptionModel({required this.prescriptionId, required this.prescribedBy, required this.images, required this.createdAt});

  factory PrescriptionModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return PrescriptionModel(
        prescriptionId: doc.id,
        prescribedBy: data['prescribedBy'] as String,
        images: data['images'] as List<dynamic>,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      // Handle the exception, you might want to log this error or set default values
      print('Error converting document snapshot to PrescriptionModel: $e');
      throw e; // Re-throw the exception after logging it or handling it as necessary
    }
  }

  Map<String, dynamic> toJson() => {
        'prescriptionId': prescriptionId,
        'prescribedBy': prescribedBy,
        'images': images,
        'createdAt': createdAt,
      };
}
