import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class EyeDropModel {
  String eyeDropId;
  String name;
  var intervalHours;
  DateTime lastTakenTime;
  DateTime nextReminderTime;
  String eyeDropPhotoUrl;
  String banglaName;
  String description;

  EyeDropModel({
    required this.eyeDropId,
    required this.name,
    required this.intervalHours,
    required this.lastTakenTime,
    required this.nextReminderTime,
    required this.eyeDropPhotoUrl,
    required this.banglaName,
    required this.description,
  });

  factory EyeDropModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return EyeDropModel(
        eyeDropId: doc.id,
        name: data['name'] as String,
        // if int convert to double or double

        intervalHours: data['intervalHours'],
        lastTakenTime: (data['lastTakenTime'] as Timestamp).toDate(),
        nextReminderTime: (data['nextReminderTime'] as Timestamp).toDate(),
        eyeDropPhotoUrl: data['eyeDropPhotoUrl'] as String,

        // If banglaName is not present, set it to empty string
        banglaName: data['banglaName'] == null ? '' : data['banglaName'] as String,
        description: data['description'] == null ? '' : data['description'] as String,
      );
    } catch (e) {
      // Handle the exception, you might want to log this error or set default values
      print('Error converting document snapshot to EyeDropModel: $e');
      throw e; // Re-throw the exception after logging it or handling it as necessary
    }
  }

  Map<String, dynamic> toJson() => {
        'eyeDropId': eyeDropId,
        'name': name,
        'intervalHours': intervalHours,
        'lastTakenTime': lastTakenTime,
        'nextReminderTime': nextReminderTime,
        'eyeDropPhotoUrl': eyeDropPhotoUrl,
        'banglaName': banglaName,
        'description': description,
      };
}
