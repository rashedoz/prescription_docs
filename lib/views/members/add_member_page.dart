import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/common/widgets/common_app_button.dart';
import 'package:prescription_document/controllers/image_controller/image_picker_controller.dart';
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
  final TextEditingController _birthdateController = TextEditingController();

  late DateTime birthDate;

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
      bithDate: birthDate.toIso8601String(),
      relationship: _relationshipController.text,
      createdAt: DateTime.now().toIso8601String(),
      memberId: "MID1",
      imageData: Get.find<ImagePickerController>().selectedImagePath.value,
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
      body: GetBuilder<ImagePickerController>(builder: (imagePickerController) {
        return Padding(
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
                      _showImageSourceActionSheet(
                          context, imagePickerController);
                      // TODO: Implement image upload functionality
                    },
                    child: imagePickerController.selectedImagePath.value == ''
                        ? Container(
                            height: 150,
                            color: const Color(0xFFCAC4ED),
                            alignment: Alignment.center,
                            child:
                                Icon(Icons.camera_alt, color: Colors.grey[800]),
                          )
                        : Container(
                            height: 150,
                            color: const Color(0xFFCAC4ED),
                            alignment: Alignment.center,
                            child: Image.file(
                              File(imagePickerController
                                  .selectedImagePath.value),
                              width: double.infinity,
                              height: 150,
                            ),
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
                    controller: _birthdateController,
                    decoration: const InputDecoration(
                      labelText: 'Birth Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today,color: AppColors.primaryColor,),
                    ),
                    readOnly: true, // Prevent manual editing
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        birthDate = selectedDate;
                        _birthdateController
                          ..text = DateFormat.yMMMd().format(birthDate)
                          ..selection = TextSelection.fromPosition(TextPosition(
                              offset: _birthdateController.text.length,
                              affinity: TextAffinity.upstream));
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _relationshipController,
                    decoration: const InputDecoration(
                      labelText: 'Relationship',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the relation with patient';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CommonAppButton(
                    onTapButton: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Implement the logic to save the member
                        log('Save the member');
                        _addMemberToFirestore();
                        // Get.back();
                        Navigator.pop(context);
                        // addUser();
                      }
                    },
                    btnContent: 'SAVE',
                    btnIcon: Icons.save_sharp,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showImageSourceActionSheet(
      BuildContext context, ImagePickerController imagePickerController) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(
                  'Camera',
                  style: Get.theme.textTheme.bodyMedium,
                ),
                onTap: () {
                  imagePickerController.pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  'Gallery',
                  style: Get.theme.textTheme.bodyMedium,
                ),
                onTap: () {
                  imagePickerController.pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
