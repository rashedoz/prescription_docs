import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/controllers/firebase_controller.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:prescription_document/views/members/member_details_page.dart';
import 'package:prescription_document/views/visits/visits_list_page.dart';

Future<void> addUser() async {
  // Get to page AddMemberPage
  Get.toNamed('/add-member');
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeFirebaseController memberController =
        Get.find<HomeFirebaseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                      // Add your logic for the avatar here
                      ),
                  const Text(
                    'Hi, Riyad 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
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
                // if (memberController.members.isEmpty) {
                //   return const Center(child: Text('No members found.'));
                // }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2,
                  ),
                  itemCount: memberController.members.length +
                      1, // Add one for the 'Add' button
                  itemBuilder: (context, index) {
                    if (index < memberController.members.length) {
                      return MemberWidget(
                          member: memberController.members[index]);
                    } else {
                      return const AddFamilyMemberButton();
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
          Get.to(() => const MemberDetailsPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MemberWidget extends StatelessWidget {
  final MemberModel member;

  const MemberWidget({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the MemberDetailsPage
        // Log going to member.name Visits Page
        log('Going to ${member.name} page');
        Get.to(() => VisitsPage(member: member));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person), // Replace with actual data
            Text(member.name), // Replace with actual data
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
      ),
    );
  }
}

class AddFamilyMemberButton extends StatelessWidget {
  const AddFamilyMemberButton({super.key});

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
        child: const Icon(Icons.add),
      ),
    );
  }
}
