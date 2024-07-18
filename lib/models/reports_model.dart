//  |--- reports (Sub-collection)
//                         |--- RID202 (Document)
//                             |-- images: ["url3", "url4"]
//                             |-- reportedBy: "Dr. Smith"
//                             |-- createdAt: Timestamp

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String reportId;
  String reportedBy;
  List<dynamic> images;
  DateTime createdAt;

  ReportModel(
      {required this.reportId,
      required this.reportedBy,
      required this.images,
      required this.createdAt});

  factory ReportModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ReportModel(
        reportId: doc.id,
        reportedBy: data['reportedBy'] as String,
        images: data['images'] as List<dynamic>,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      // Handle the exception, you might want to log this error or set default values
      log('Error converting document snapshot to ReportModel: $e');
      rethrow; // Re-throw the exception after logging it or handling it as necessary
    }
  }

  Map<String, dynamic> toJson() => {
        'reportId': reportId,
        'reportedBy': reportedBy,
        'images': images,
        'createdAt': createdAt,
      };
}
