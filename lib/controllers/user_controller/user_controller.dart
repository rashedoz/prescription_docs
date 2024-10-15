import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prescription_document/controllers/image_controller/image_picker_controller.dart';
import 'package:prescription_document/views/home/home_page.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  GetStorage localStorage = GetStorage();
  ImagePickerController imagePickerController = ImagePickerController();
   Rx<bool> isLoggedIn = false.obs;

  var isLoading = false.obs;
  var isUserLoading = false.obs;
  var selectedProfileImagePath = ''.obs;
  XFile? pickedImage;

  // Future<void> pickProfileImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     selectedProfileImagePath.value = pickedFile.path;
  //   } else {
  //     Get.snackbar('Error', 'No image selected');
  //   }
  // }


  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      selectedProfileImagePath.value = pickedFile.path;
      pickedImage = pickedFile;
    } else {
      Get.snackbar('Error', 'No image selected');
    }
    update();
  }

  Future<void> signUp(String email, String password, String username, XFile image) async {
    try {
      isLoading.value = true;

      // Sign up with Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;



      if (user != null) {
        // Upload profile image to Firebase Storage if selected
        String profileImageUrl = '';
        if(selectedProfileImagePath.value != ''){
        // if (selectedProfileImagePath.value != '') {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          var storageRef = firebaseStorage.ref().child('User').child('own').child('${user.uid}$fileName.jpg');
          await storageRef.putFile(File(selectedProfileImagePath.value));
          profileImageUrl = await storageRef.getDownloadURL();
        }

        // Save user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': profileImageUrl,
          'uid': user.uid,
          'createdAt': Timestamp.now(),
        });
      

        // Save user data locally using GetStorage
        localStorage.write('uid', user.uid);
        localStorage.write('email', email);
        localStorage.write('username', username);
        localStorage.write('profileImageUrl', profileImageUrl);

        Get.snackbar('Success', 'User signed up successfully',backgroundColor: Colors.green);
        Get.offAll(const HomePage());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
    update();
  }

  // Function to retrieve user data from GetStorage
  Map<String, dynamic> getUserData() {
    log('image data:${localStorage.read('profileImageUrl') ?? ''}');
    return {
      'uid': localStorage.read('uid') ?? '',
      'email': localStorage.read('email') ?? '',
      'username': localStorage.read('username') ?? '',
      'image_url': localStorage.read('profileImageUrl') ?? '',
    };
  }
  // Future<void> signIn(String email, String password) async {
  //   try {
  //     isLoading.value = true;

  //     // Sign in with Firebase Authentication
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     User? user = userCredential.user;
  //     if (user != null) {
  //       // Fetch user data from Firestore
  //       DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();
  //       if (userDoc.exists) {
  //         String username = userDoc['username'];
  //         String profileImageUrl = userDoc['image_url'];

  //         // Save user data locally in GetStorage
  //         localStorage.write('uid', user.uid);
  //         localStorage.write('email', email);
  //         localStorage.write('username', username);
  //         localStorage.write('profileImageUrl', profileImageUrl);

  //         // Navigate to Home Page
  //         Get.offAll(HomePage());  // Replace with your HomePage widget
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Function to clear user data from GetStorage (logout)
  void clearUserData() {
    localStorage.erase();
  }


  Future<void> fetchUserInfo() async {
    try {
      isUserLoading.value = true;

      // Get the current user
      User? user = auth.currentUser;
      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // Save user data in GetStorage for local access
          localStorage.write('uid', userDoc['uid']);
          localStorage.write('email', userDoc['email']);
          localStorage.write('username', userDoc['username']);
          localStorage.write('profileImageUrl', userDoc['image_url']);

          Get.snackbar('Success', 'User data fetched successfully');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user info');
    } finally {
      isUserLoading.value = false;
    }
    update();
  }



}
