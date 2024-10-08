import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/models/member_model.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  AddMemberPageState createState() => AddMemberPageState();
}

class AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();

  late String birthDate;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _nameController.dispose();
    _ageController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  // Add Member to the current User's Firestore collection
  void _addMemberToFirestore() async {
    // Create a new member model
    final member = MemberModel(
      name: _nameController.text,
      bithDate: birthDate,
      relationship: _relationshipController.text,
      createdAt: DateTime.now().toString(),
      memberId: "MID1",
    );

    // Get reference to Firestore
    CollectionReference members = FirebaseFirestore.instance
        .collection('users')
        // Static User ID for testing
        .doc("UID123")
        .collection('members');

    // Add to Firestore under the test user
    await members
        .add(member.toJson())
        .then((docRef) => log('Member added with ID: ${docRef.id}'))
        .catchError((error) => log('Failed to add member: $error'));
  }

  // Future<void> addUser() async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');

  //   print('Adding user...' + FirebaseFirestore.instance.toString());

  //   return users
  //       .add({
  //         'displayName': 'John Doe',
  //         'email': 'johndoe@example.com',
  //         'createdAt': FieldValue.serverTimestamp(), // Automatically sets server-side timestamp
  //         //Add the Document reference to uid
  //       })
  //       .then((DocumentReference doc) => print('User added with ID: ${doc.id}'))
  //       .catchError((e) => print('Error adding user: $e'));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // TODO: Implement image upload functionality
                  },
                  child: Container(
                    height: 150,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Icon(Icons.camera_alt, color: Colors.grey[800]),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Patient Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Patient Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient\'s age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _relationshipController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Prevent manual editing
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      birthDate = selectedDate.toString();
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Implement the logic to save the member
                      log('Save the member');
                      _addMemberToFirestore();
                      // Get.back();
                      Navigator.pop(context);
                      // addUser();
                    }
                  },
                  child: const Text('SAVE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
