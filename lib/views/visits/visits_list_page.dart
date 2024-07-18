import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/controllers/firebase_controller.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:prescription_document/models/visit_model.dart';
import 'package:prescription_document/views/visits/visit_details_page.dart';

class VisitsPage extends StatefulWidget {
  final MemberModel member;
  const VisitsPage({super.key, required this.member});

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  // Dummy data for member details
  HomeFirebaseController firebaseController =
      Get.find<HomeFirebaseController>();

  @override
  Widget build(BuildContext context) {
    // Stream Visits from Firestore
    firebaseController.visits
        .bindStream(firebaseController.listenToVisits(widget.member));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member.name),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.member.name),
            subtitle: Text(widget.member.bithDate.toString()),
            leading: const Icon(Icons.person),
          ),
          Expanded(
            child: Obx(() {
              if (firebaseController.members.isEmpty) {
                return const Center(child: Text('No Vistits found.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 2,
                  childAspectRatio: 4,
                ),
                itemCount: firebaseController.visits.length +
                    1, // Add one for the 'Add' button
                itemBuilder: (context, index) {
                  if (index < firebaseController.visits.length) {
                    return InkWell(
                      onTap: () {
                        // Navigate to the Visit Details Page
                        log('Going to ${firebaseController.visits[index].visitId} page');
                        Get.to(() => VisitsDetailsPage(
                            member: widget.member,
                            visit: firebaseController.visits[index]));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            // Visit Date formatted
                            Text(
                                "Visit date: ${firebaseController.visits[index].date}"),

                            Text(
                              "Visit ID: ${firebaseController.visits[index].visitId}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 8,
                              ),
                            ),
                            Text(
                                "Doctor: ${firebaseController.visits[index].doctorId}"),
                            Text(
                                "Visiting Reason: ${firebaseController.visits[index].reason}"),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                        onTap: () {
                          VisitModel visit = VisitModel(
                            visitId: 'VID1',
                            doctorId: 'DID1',
                            reason: 'Mohim',
                            createdAt: DateTime.now(),
                            // Todays date as a string

                            date: '2023-11-20',
                          );

                          firebaseController.addVisit(visit, widget.member);
                        },
                        child: const Text('Create a Visit'));
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
