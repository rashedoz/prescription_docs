import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/views/doctors/add_doctor_page.dart';

class MemberDetailsPage extends StatelessWidget {
  // Dummy data for member details
  final String memberName = "Father";
  final String memberDOB = "14 Sep 1980 (43y/2m)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memberName),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(memberName),
            subtitle: Text(memberDOB),
            leading: Icon(Icons.person),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 10, // Replace with your dynamic doctor count
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the doctor details or edit page
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medical_services, size: 40), // Replace with doctor image
                        Text('Doctor Name'),
                        Text('Specialization'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the Add Doctor Page
              Get.to(() => AddDoctorPage());
            },
            child: Text('Add Doctor'),
          ),
        ],
      ),
    );
  }
}
