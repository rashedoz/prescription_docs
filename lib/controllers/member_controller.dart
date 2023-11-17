import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prescription_document/models/member_model.dart';

class MemberController extends GetxController {
  var members = <MemberModel>[].obs; // Observable list of members
  final String userId; // ID of the specific user

  MemberController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    members.bindStream(listenToMembers()); // Bind the stream to the observable list
  }

  Stream<List<MemberModel>> listenToMembers() {
    // Stream of members from Firestore
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('members').snapshots().map((query) => query.docs.map((item) => MemberModel.fromDocumentSnapshot(item)).toList());
  }
}
