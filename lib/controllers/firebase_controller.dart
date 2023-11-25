import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prescription_document/models/eye_drop_moderl.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:prescription_document/models/prescription_model.dart';
import 'package:prescription_document/models/reports_model.dart';
import 'package:prescription_document/models/visit_model.dart';

class HomeFirebaseController extends GetxController {
  var members = <MemberModel>[].obs; // Observable list of members
  final String userId; // ID of the specific user

  var visits = <VisitModel>[].obs; // Observable list of visits
  var eyeDrops = <EyeDropModel>[].obs; // Observable list of eye drops
  var prescriptions = <PrescriptionModel>[].obs; // Observable list of prescriptions
  var report = <ReportModel>[].obs; // Observable list of reports

  HomeFirebaseController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    members.bindStream(listenToMembers()); // Bind the stream to the observable list
  }

  // Members collection stream
  Stream<List<MemberModel>> listenToMembers() {
    // Stream of members from Firestore
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('members').snapshots().map((query) => query.docs.map((item) => MemberModel.fromDocumentSnapshot(item)).toList());
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
        .doc(userId)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .snapshots()
        .map((query) => query.docs.map((item) => VisitModel.fromDocumentSnapshot(item)).toList());
  }

  // Eyedrops collection stream
  Stream<List<EyeDropModel>> listenToEyeDrops(MemberModel member) {
    // |--- UID123 (Document)
    // |--- members (Sub-collection)
    //     |--- MID456 (Document)
    //         |--- eyeDrops (Sub-collection)
    //             |--- EID789 (Document)
    // Stream of eye drops from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('members')
        .doc(member.memberId)
        .collection('eyeDrops')
        .snapshots()
        .map((query) => query.docs.map((item) => EyeDropModel.fromDocumentSnapshot(item)).toList()..sort((a, b) => a.intervalHours.compareTo(b.intervalHours)));
  }

  // Prescription and Reports collection stream
  Stream<List<PrescriptionModel>> listenToPrescriptions(MemberModel member, VisitModel visit) {
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
        .doc(userId)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .doc(visit.visitId)
        .collection('prescriptions')
        .snapshots()
        .map((query) => query.docs.map((item) => PrescriptionModel.fromDocumentSnapshot(item)).toList());
  }

  Stream<List<ReportModel>> listenToReports(MemberModel member, VisitModel visit) {
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
        .doc(userId)
        .collection('members')
        .doc(member.memberId)
        .collection('visits')
        .doc(visit.visitId)
        .collection('reports')
        .snapshots()
        .map((query) => query.docs.map((item) => ReportModel.fromDocumentSnapshot(item)).toList());
  }

  //=================== Prescription Realted Functions ================================
  Future<void> addPrescription(PrescriptionModel prescription, MemberModel member, VisitModel visit) async {
    // Get reference to Firestore
    CollectionReference prescriptions =
        FirebaseFirestore.instance.collection('users').doc(userId).collection('members').doc(member.memberId).collection('visits').doc(visit.visitId).collection('prescriptions');

    // Add to Firestore under the test user
    await prescriptions.add(prescription.toJson()).then((docRef) => print('Prescription added with ID: ${docRef.id}')).catchError((error) => print('Failed to add prescription: $error'));
  }

  //=================== Report Realted Functions ================================
  Future<void> addReport(ReportModel report, MemberModel member, VisitModel visit) async {
    // Get reference to Firestore
    CollectionReference reports = FirebaseFirestore.instance.collection('users').doc(userId).collection('members').doc(member.memberId).collection('visits').doc(visit.visitId).collection('reports');

    // Add to Firestore under the test user
    await reports.add(report.toJson()).then((docRef) => print('Report added with ID: ${docRef.id}')).catchError((error) => print('Failed to add report: $error'));
  }

  //=================== Visit Realted Functions ================================
  // Add Visit to the current User's Firestore collection
  Future<void> addVisit(VisitModel visit, MemberModel member) async {
    // Get reference to Firestore
    CollectionReference visits = FirebaseFirestore.instance.collection('users').doc(userId).collection('members').doc(member.memberId).collection('visits');

    // Add to Firestore under the test user
    await visits.add(visit.toJson()).then((docRef) => print('Visit added with ID: ${docRef.id}')).catchError((error) => print('Failed to add visit: $error'));
  }

  //=================== Eye Drop Related Functions ================================
  // Add Eye Drop to the current User's Firestore collection
  Future<void> addEyeDrop(EyeDropModel eyeDrop, MemberModel member) async {
    // Get reference to Firestore
    CollectionReference eyeDrops = FirebaseFirestore.instance.collection('users').doc(userId).collection('members').doc(member.memberId).collection('eyeDrops');

    // Add to Firestore under the test user
    await eyeDrops.add(eyeDrop.toJson()).then((docRef) => print('Eye Drop added with ID: ${docRef.id}')).catchError((error) => print('Failed to add eye drop: $error'));
  }

  // Update Eye Drop to the current User's Firestore collection
  Future<void> updateEyeDrop(EyeDropModel eyeDrop, MemberModel member) async {
    // Get reference to Firestore
    CollectionReference eyeDrops = FirebaseFirestore.instance.collection('users').doc(userId).collection('members').doc(member.memberId).collection('eyeDrops');

    // Update to Firestore under the test user
    await eyeDrops
        .doc(eyeDrop.eyeDropId)
        .update(eyeDrop.toJson())
        .then((docRef) => print('Eye Drop updated with ID: ${eyeDrop.eyeDropId}'))
        .catchError((error) => print('Failed to update eye drop: $error'));
  }

  //=================== Member Realted Functions ================================
  Future<void> addMember(MemberModel member) async {
    // Get reference to Firestore
    CollectionReference members = FirebaseFirestore.instance.collection('users').doc(userId).collection('members');

    // Add to Firestore under the test user
    await members.add(member.toJson()).then((docRef) => print('Member added with ID: ${docRef.id}')).catchError((error) => print('Failed to add member: $error'));
  }

  Future<void> updateMember(MemberModel member) async {
    // Get reference to Firestore
    CollectionReference members = FirebaseFirestore.instance.collection('users').doc(userId).collection('members');

    // Update to Firestore under the test user
    await members.doc(member.memberId).update(member.toJson()).then((docRef) => print('Member updated with ID: ${member.memberId}')).catchError((error) => print('Failed to update member: $error'));
  }

  Future<void> deleteMember(MemberModel member) async {
    // Get reference to Firestore
    CollectionReference members = FirebaseFirestore.instance.collection('users').doc(userId).collection('members');

    // Delete from Firestore under the test user
    await members.doc(member.memberId).delete().then((docRef) => print('Member deleted with ID: ${member.memberId}')).catchError((error) => print('Failed to delete member: $error'));
  }
}
