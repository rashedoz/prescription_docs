import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  RxString selectedImagePath = ''.obs;
  RxBool isUploading = false.obs;
  RxString imageUrl = ''.obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  XFile? pickedImage;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      pickedImage = pickedFile;
    } else {
      Get.snackbar('Error', 'No image selected');
    }
    update();
  }
  Future<void> uploadImage() async {
    if (selectedImagePath.value != '') {
      isUploading.value = true;
      try {
        File imageFile = File(selectedImagePath.value);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Upload to Firebase Storage
        var storageRef = storage.ref().child('images/$fileName');
        await storageRef.putFile(imageFile);

        // Get the download URL of the uploaded image
        String downloadUrl = await storageRef.getDownloadURL();

        // Save the image URL to Firestore
        await firestore.collection('images').add({'url': downloadUrl});

        Get.snackbar('Success', 'Image uploaded successfully');
        fetchImages(); // Fetch images after uploading
      } catch (e) {
        Get.snackbar('Error', 'An error occurred while uploading');
      } finally {
        isUploading.value = false;
      }
    } else {
      Get.snackbar('Error', 'No image selected');
    }
    update();
  }
    Future<void> fetchImages() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('images').get();
      // imageUrl.value = snapshot.docs.map((doc) => doc['url'] as String);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch images');
    }
  }
}

// try {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     return pickedFile;
//   } catch (e) {
//     // Handle errors (e.g., user cancels selection, permission denied)
//     print(e);
//     return null;
//   }