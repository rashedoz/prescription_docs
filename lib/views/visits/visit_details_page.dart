import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/controllers/firebase_controller.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:prescription_document/models/prescription_model.dart';
import 'package:prescription_document/models/reports_model.dart';
import 'package:prescription_document/models/visit_model.dart';
import 'package:prescription_document/views/doctors/add_doctor_page.dart';

class VisitsDetailsPage extends StatefulWidget {
  final MemberModel member;
  final VisitModel visit;
  const VisitsDetailsPage({super.key, required this.member, required this.visit});

  @override
  State<VisitsDetailsPage> createState() => _VisitsDetailsPageState();
}

class _VisitsDetailsPageState extends State<VisitsDetailsPage> {
  // Dummy data for member details
  HomeFirebaseController firebaseController = Get.find<HomeFirebaseController>();

  @override
  Widget build(BuildContext context) {
    // Stream Prescriptions from Firestore
    firebaseController.prescriptions.bindStream(firebaseController.listenToPrescriptions(widget.member, widget.visit));
    firebaseController.report.bindStream(firebaseController.listenToReports(widget.member, widget.visit));

    return Scaffold(
      appBar: AppBar(
        title: Text("Visit Details"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Member: ${widget.member.name}"),
            subtitle: Text("Visit: ${widget.visit.visitId.toString()}"),
            leading: Icon(Icons.view_list_rounded),
          ),

          const Text("Reports"),
          Expanded(
            child: Obx(() {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                ),
                itemCount: firebaseController.report.length + 1, // Add one for the 'Add' button
                itemBuilder: (context, index) {
                  if (index < firebaseController.report.length) {
                    return Card(
                      child: Column(
                        children: [
                          Text(firebaseController.report[index].createdAt.toString()),
                          Text("Report ID: ${firebaseController.report[index].reportId.toString()}"),

                          // Text(firebaseController.prescriptions[index].images.toString()),
                          // Show the images here from the images list in a Row
                          Row(
                            children: [
                              for (var image in firebaseController.report[index].images)
                                // On click show the full image in a dialog
                                InkWell(
                                  onTap: () {
                                    // Show the full image in a dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Report Image"),
                                          content: Image.network(
                                            image,
                                            width: 500,
                                            height: 500,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.network(
                                    image,
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              // Create a report
                              ReportModel report = ReportModel(
                                reportId: 'RID1',
                                reportedBy: 'DID1',
                                images: ['https://goldshirorom.com/wp-content/uploads/2023/11/report.png'],
                                createdAt: DateTime.now(),
                              );

                              firebaseController.addReport(report, widget.member, widget.visit);
                            },
                            child: Text('Add a Report')),
                      ],
                    );
                  }
                },
              );
            }),
          ),

          const Text("Prescriptions"),
          Expanded(
            child: Obx(() {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 2,
                ),
                itemCount: firebaseController.prescriptions.length + 1, // Add one for the 'Add' button
                itemBuilder: (context, index) {
                  if (index < firebaseController.prescriptions.length) {
                    return Card(
                      child: Column(
                        children: [
                          Text(firebaseController.prescriptions[index].createdAt.toString()),
                          Text("Prescription ID: ${firebaseController.prescriptions[index].prescriptionId.toString()}"),
                          Text("Prescribed By: ${firebaseController.prescriptions[index].prescribedBy.toString()}"),

                          // Text(firebaseController.prescriptions[index].images.toString()),
                          // Show the images here from the images list in a Row
                          Row(
                            children: [
                              for (var image in firebaseController.prescriptions[index].images)
                                // On click show the full image in a dialog
                                // Image.network(
                                //   image,
                                //   width: 70,
                                //   height: 70,
                                // ),
                                InkWell(
                                  onTap: () {
                                    // Show the full image in a dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Prescription Image"),
                                          content: Image.network(
                                            image,
                                            width: 500,
                                            height: 500,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.network(
                                    image,
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              // Create a prescription
                              //                               String prescriptionId;
                              // String prescribedBy;
                              // List<String> images;
                              // DateTime createdAt;
                              PrescriptionModel prescription = PrescriptionModel(
                                prescriptionId: 'PID1',
                                prescribedBy: 'DID1',
                                images: [
                                  'https://goldshirorom.com/wp-content/uploads/2023/11/prescription.png',
                                  'https://goldshirorom.com/wp-content/uploads/2023/11/prescription.png',
                                  'https://goldshirorom.com/wp-content/uploads/2023/11/prescription.png'
                                ],
                                createdAt: DateTime.now(),
                              );

                              firebaseController.addPrescription(prescription, widget.member, widget.visit);
                            },
                            child: Text('Create a Prescription')),
                      ],
                    );
                  }
                },
              );
            }),
          ),

          // ElevatedButton(
          //   onPressed: () {
          //     VisitModel visit = VisitModel(
          //       visitId: 'VID1',
          //       doctorId: 'DID1',
          //       reason: 'Mohim',
          //       createdAt: DateTime.now(),
          //       // Todays date as a string

          //       date: '2023-11-20',
          //     );

          //     firebaseController.addVisit(visit, widget.member);
          //   },
          //   child: Text('Create a Visit'),
          // ),
        ],
      ),
    );
  }
}
