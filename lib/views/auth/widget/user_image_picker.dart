
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../../controllers/image_controller/image_picker_controller.dart';

class UserImagePicker extends StatelessWidget {
  final Color containerColor;
  // final void Function(XFile pickImage) imagePickFn;
  const UserImagePicker({super.key,required this.containerColor});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePickerController>(builder: (imagePickerController){
      return GestureDetector(
                    onTap: () {
                      _showImageSourceActionSheet(
                          context, imagePickerController);
                      // TODO: Implement image upload functionality
                    },
                    child: imagePickerController.selectedImagePath.value == ''
                        ? Container(
                            height: 150,
                            color: containerColor,
                            alignment: Alignment.center,
                            child:
                                Icon(Icons.camera_alt, color: Colors.grey[800]),
                          )
                        : Container(
                            height: 150,
                            color: const Color(0xFFCAC4ED),
                            alignment: Alignment.center,
                            child: Image.file(
                              fit: BoxFit.cover,
                              File(imagePickerController
                                  .selectedImagePath.value),
                              width: double.infinity,
                              height: 150,
                            ),
                          ),
                  );
    });
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