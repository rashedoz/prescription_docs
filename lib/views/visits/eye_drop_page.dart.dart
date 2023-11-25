import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prescription_document/controllers/firebase_controller.dart';
import 'package:prescription_document/models/eye_drop_moderl.dart';
import 'package:prescription_document/models/member_model.dart';
import 'package:prescription_document/models/prescription_model.dart';
import 'package:prescription_document/models/reports_model.dart';
import 'package:prescription_document/models/visit_model.dart';
import 'package:prescription_document/views/doctors/add_doctor_page.dart';

class EyeDropsPage extends StatefulWidget {
  final MemberModel member;

  const EyeDropsPage({super.key, required this.member});

  @override
  State<EyeDropsPage> createState() => _EyeDropsPageState();
}

class _EyeDropsPageState extends State<EyeDropsPage> {
  // Dummy data for member details
  HomeFirebaseController firebaseController = Get.find<HomeFirebaseController>();

  @override
  Widget build(BuildContext context) {
    // Stream Prescriptions from Firestore
    firebaseController.eyeDrops.bindStream(firebaseController.listenToEyeDrops(widget.member));

    return Scaffold(
      appBar: AppBar(
        title: Text("Eye Drops"),
      ),
      body: Column(
        children: [
          // ListTile(
          //   title: Text("Member: ${widget.member.name}"),
          //   leading: Icon(Icons.view_list_rounded),
          // ),
          // const Text("Eye Drops"),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: firebaseController.eyeDrops.length + 1, // Add one for the 'Add' button
                itemBuilder: (context, index) {
                  if (index < firebaseController.eyeDrops.length) {
                    return Card(
                      elevation: 30,
                      child: Row(
                        children: [
                          // for (var image in firebaseController.eyeDrops[index].eyeDropPhotoUrl)
                          // On click show the full image in a dialog
                          InkWell(
                            onTap: () {
                              // Show the full image in a dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Eyedrop Image"),
                                    content: Image.network(
                                      firebaseController.eyeDrops[index].eyeDropPhotoUrl,
                                      width: 500,
                                      height: 500,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                // Serial No.
                                Text("${index + 1}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                                Image.network(
                                  firebaseController.eyeDrops[index].eyeDropPhotoUrl,
                                  width: 70,
                                  height: 70,
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${firebaseController.eyeDrops[index].name} (${firebaseController.eyeDrops[index].banglaName})",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                // Text("Eyedrop ID: ${firebas eController.eyeDrops[index].eyeDropId.toString()}"),

                                Text(
                                  "নিয়ম: ${firebaseController.eyeDrops[index].description}",
                                  softWrap: true, // Wrap text onto multiple lines
                                  overflow: TextOverflow.visible, // Allow the text to be visible
                                ),
                                Text("Interval: ${firebaseController.eyeDrops[index].intervalHours.toString()} Hours (${firebaseController.eyeDrops[index].intervalHours.toString()}  ঘন্টা পর পর)"),

                                // Format the date and time as Aug 29, 2021 10:30 AM
                                Text("শেষ দেওয়া: ${DateFormat('h:mm a, MMM dd').format(firebaseController.eyeDrops[index].lastTakenTime)}",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 10, 195, 81)),
                                      onPressed: () => _eyedropUpdateTime(firebaseController.eyeDrops[index], DateTime.now()),
                                      child: Text('এখন নিলাম'),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 141, 168, 5)),
                                      onPressed: () => _showDateTimePicker(context, firebaseController.eyeDrops[index]),
                                      child: Text('কিছুক্ষণ আগে নিলাম'),
                                    ),
                                  ],
                                ),
                                //Counter till next reminder

                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    // Decorate the container with re border and hightlight text
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text("পরবর্তী দেওয়া: ${DateFormat('h:mm a, MMM dd').format(firebaseController.eyeDrops[index].nextReminderTime)}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              // Create Eyedrop
                              // EyeDropModel eyeDrop = EyeDropModel(
                              //   eyeDropId: 'Nevan TS',
                              //   name: 'Neva TS',
                              //   banglaName: "",
                              //   description: "",
                              //   intervalHours: 12,
                              //   lastTakenTime: DateTime.now(),
                              //   nextReminderTime: DateTime.now(),
                              //   eyeDropPhotoUrl: 'https://goldshirorom.com/wp-content/uploads/2023/11/3.jpg',
                              // );

                              // firebaseController.addEyeDrop(eyeDrop, widget.member);
                            },
                            child: Text('Add a Eye Drop')),
                      ],
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDateTimePicker(BuildContext context, EyeDropModel eyeDrop) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eyeDrop.lastTakenTime,
      firstDate: eyeDrop.lastTakenTime,
      lastDate: DateTime(2025), // Adjust as needed
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(eyeDrop.lastTakenTime),
      );
      if (timePicked != null) {
        DateTime newLastTakenTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );
        _eyedropUpdateTime(eyeDrop, newLastTakenTime);
      }
    }
  }

  void _eyedropUpdateTime(EyeDropModel eyeDrop, DateTime newLastTakenTime) {
    eyeDrop.lastTakenTime = newLastTakenTime;
    int totalMinutes = (eyeDrop.intervalHours * 60).round(); // Convert hours to minutes
    eyeDrop.nextReminderTime = newLastTakenTime.add(Duration(minutes: totalMinutes));
    firebaseController.updateEyeDrop(eyeDrop, widget.member);
  }
}
