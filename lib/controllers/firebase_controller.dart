import 'dart:developer';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prescription_document/controllers/user_controller/user_controller.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:prescription_document/models/prescription_model.dart';
import 'package:prescription_document/models/reports_model.dart';
import 'package:prescription_document/models/visit_model.dart';

class HomeFirebaseController extends GetxController {
  var members = <MemberModel>[].obs; // Observable list of members
  // final String userId; // ID of the specific user

  var visits = <VisitModel>[].obs; // Observable list of visits
  var prescriptions =
      <PrescriptionModel>[].obs; // Observable list of prescriptions
  var report = <ReportModel>[].obs; // Observable list of reports

  // HomeFirebaseController({required this.userId});
  var userId = ''.obs;
  // UserController userController = UserController();

  // When the user logs in or signs up
  void setUserId(String id) {
    userId.value = id;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    var userData = Get.find<UserController>().getUserData();
    userId.value = userData['uid'];
    // print("User ID: ${userData['uid']}");
    if (userId.value.isNotEmpty) {
      members.bindStream(listenToMembers());
    }
    // Bind the stream to the observable list
  }

  // Members collection stream
  Stream<List<MemberModel>> listenToMembers() {
    // Stream of members from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members')
        .snapshots()
        .map((query) => query.docs
            .map((item) => MemberModel.fromDocumentSnapshot(item))
            .toList());
  }

  // Visits collection stream
  Stream<List<VisitModel>> listenToVisits(MemberModel member) {
    // |--- UID123 (Document)
    // |--- members (Sub-collection)
    //     |--- MID456 (Document)
    //         |--- visits (Sub-collection)
    //             |--- VID789 (Document)
    // Stream of visits from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .snapshots()
        .map((query) => query.docs
            .map((item) => VisitModel.fromDocumentSnapshot(item))
            .toList());
  }

  // Prescription and Reports collection stream
  Stream<List<PrescriptionModel>> listenToPrescriptions(
      MemberModel member, VisitModel visit) {
    //  |--- VID789 (Document)
    //                 |--- prescriptions (Sub-collection)
    //                     |--- PID101 (Document)
    //                         |-- images: ["url1", "url2"]
    //                         |-- prescribedBy: "Dr. Smith"
    //                         |-- createdAt: Timestamp
    //                 |--- reports (Sub-collection)
    //                     |--- RID202 (Document)
    //                         |-- images: ["url3", "url4"]
    //                         |-- reportedBy: "Dr. Smith"
    //                         |-- createdAt: Timestamp
    // Stream of prescriptions from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .doc(visit.visitId)
        .collection('prescriptions')
        .snapshots()
        .map((query) => query.docs
            .map((item) => PrescriptionModel.fromDocumentSnapshot(item))
            .toList());
  }

  Stream<List<ReportModel>> listenToReports(
      MemberModel member, VisitModel visit) {
    //  |--- VID789 (Document)
    //                 |--- prescriptions (Sub-collection)
    //                     |--- PID101 (Document)
    //                         |-- images: ["url1", "url2"]
    //                         |-- prescribedBy: "Dr. Smith"
    //                         |-- createdAt: Timestamp
    //                 |--- reports (Sub-collection)
    //                     |--- RID202 (Document)
    //                         |-- images: ["url3", "url4"]
    //                         |-- reportedBy: "Dr. Smith"
    //                         |-- createdAt: Timestamp
    // Stream of prescriptions from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .doc(visit.visitId)
        .collection('reports')
        .snapshots()
        .map((query) => query.docs
            .map((item) => ReportModel.fromDocumentSnapshot(item))
            .toList());
  }

  //=================== Prescription Realted Functions ================================
  Future<void> addPrescription(PrescriptionModel prescription,
      MemberModel member, VisitModel visit) async {
    // Get reference to Firestore
    CollectionReference prescriptions = FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .doc(visit.visitId)
        .collection('prescriptions');

    // Add to Firestore under the test user
    await prescriptions
        .add(prescription.toJson())
        .then((docRef) => log('Prescription added with ID: ${docRef.id}'))
        .catchError((error) => log('Failed to add prescription: $error'));
  }

  //=================== Report Realted Functions ================================
  Future<void> addReport(
      ReportModel report, MemberModel member, VisitModel visit) async {
    // Get reference to Firestore
    CollectionReference reports = FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .doc(visit.visitId)
        .collection('reports');

    // Add to Firestore under the test user
    await reports
        .add(report.toJson())
        .then((docRef) => log('Report added with ID: ${docRef.id}'))
        .catchError((error) => log('Failed to add report: $error'));
  }

  //=================== Visit Realted Functions ================================
  // Add Visit to the current User's Firestore collection
  Future<void> addVisit(VisitModel visit, MemberModel member) async {
    // Get reference to Firestore
    CollectionReference visits = FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members')
        .doc(member.memberId)
        .collection('visits');

    // Add to Firestore under the test user
    await visits
        .add(visit.toJson())
        .then((docRef) => log('Visit added with ID: ${docRef.id}'))
        .catchError((error) => log('Failed to add visit: $error'));
  }

  //=================== Member Realted Functions ================================
  Future<void> addMember(MemberModel member) async {
    // Get reference to Firestore
    CollectionReference members = FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members');

    // Add to Firestore under the test user
    await members
        .add(member.toJson())
        .then((docRef) => log('Member added with ID: ${docRef.id}'))
        .catchError((error) => log('Failed to add member: $error'));
  }

  Future<void> updateMember(MemberModel member) async {
    // Get reference to Firestore
    CollectionReference members = FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members');

    // Update to Firestore under the test user
    await members
        .doc(member.memberId)
        .update(member.toJson())
        .then((docRef) => log('Member updated with ID: ${member.memberId}'))
        .catchError((error) => log('Failed to update member: $error'));
  }

  Future<void> deleteMember(MemberModel member) async {
    // Get reference to Firestore
    CollectionReference members = FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .collection('members');

    // Delete from Firestore under the test user
    await members
        .doc(member.memberId)
        .delete()
        .then((docRef) => log('Member deleted with ID: ${member.memberId}'))
        .catchError((error) => log('Failed to delete member: $error'));
  }
}
