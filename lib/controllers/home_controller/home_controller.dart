import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/views/members/add_member_page.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isSelected = false.obs;
  Future<void> addUser(BuildContext context) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddMemberPage()))
        .then((value) {
      update();
    });
    // Get to page AddMemberPage
    // Get.toNamed('/add-member');
  }
  selectedPatient(int index){
    log('selected item:$index');
    selectedIndex.value = index;
    update();
  }
}
