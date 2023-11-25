import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/controllers/firebase_controller.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prescription_document/views/members/member_details_page.dart';
import 'package:prescription_document/views/visits/eye_drop_page.dart.dart';
import 'package:prescription_document/views/visits/visits_list_page.dart';

Future<void> addUser() async {
  // Get to page AddMemberPage
  Get.toNamed('/add-member');
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeFirebaseController memberController = Get.find<HomeFirebaseController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      // Add your logic for the avatar here
                      ),
                  Text(
                    'Hi,  👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Add your logic for the settings icon here
                    },
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Obx(() {
            //     if (memberController.members.isEmpty) {
            //       return Center(child: Text('No members found.'));
            //     }
            //     return GridView.builder(
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2, // Number of columns
            //         crossAxisSpacing: 10, // Horizontal space between items
            //         mainAxisSpacing: 10, // Vertical space between items
            //       ),
            //       itemCount: memberController.members.length,
            //       itemBuilder: (context, index) {
            //         // Access the member model
            //         MemberModel member = memberController.members[index];
            //         return Card(
            //           // Implement your member card
            //           child: Text(member.name),
            //         );
            //       },
            //     );
            //   }),
            // ),

            Expanded(
              child: Obx(() {
                if (memberController.members.isEmpty) {
                  return Center(child: const Text('No members found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),

                  itemCount: memberController.members.length + 1, // Add one for the 'Add' button
                  itemBuilder: (context, index) {
                    if (index < memberController.members.length) {
                      return MemberWidget(member: memberController.members[index]);
                    } else {
                      return AddFamilyMemberButton();
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the MemberDetailsPage
          Get.to(() => MemberDetailsPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MemberWidget extends StatelessWidget {
  final MemberModel member;

  const MemberWidget({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person), // Replace with actual data
          Text(member.name), // Replace with actual data

          // TextButton(
          //   child: Text("Visits"),
          //   onPressed: () {
          //     // Navigate to the MemberDetailsPage
          //     // Log going to member.name Visits Page
          //     print('Going to ${member.name} page');
          //     Get.to(() => VisitsPage(member: member));
          //   },
          // ),

          TextButton(
            onPressed: () {
              // Navigate to the MemberDetailsPage
              // Log going to member.name Visits Page
              print('Going to ${member.name} Eyedrop page');
              Get.to(() => EyeDropsPage(member: member));
            },
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 107, 227, 27),
              primary: Colors.black,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_information),
                SizedBox(width: 8),
                Text("Eye Drops"),
              ],
            ),
          ),

          // Age from birthdate, Format and show birthdate("2023-11-18 00:00:00.000") string as DD/MM/YYYY

          // Text(
          //   "Birth Date: ${member.bithDate}",
          //   // Text decoration small and italic
          //   style: const TextStyle(
          //     fontSize: 12,
          //     fontStyle: FontStyle.italic,
          //   ),
          // ), // Replace with actual data
        ],
      ),
    );
  }
}

class AddFamilyMemberButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Logic to add a new family member
        addUser();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
