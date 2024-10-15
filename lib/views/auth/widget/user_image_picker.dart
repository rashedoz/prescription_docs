
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../controllers/user_controller/user_controller.dart';

class UserImagePicker extends StatelessWidget {
  final Color containerColor;
  // final void Function(XFile pickImage) imagePickFn;
  const UserImagePicker({super.key,required this.containerColor});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController){
      return GestureDetector(
                    onTap: () {
                      _showImageSourceActionSheet(
                          context, userController);
                      // TODO: Implement image upload functionality
                    },
                    child: userController.selectedProfileImagePath.value == ''
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
                              File(userController
                                  .selectedProfileImagePath.value),
                              width: double.infinity,
                              height: 150,
                            ),
                          ),
                  );
    });
  }
  void _showImageSourceActionSheet(
      BuildContext context, UserController userController) {
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
                  userController.pickImage(ImageSource.camera);
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
                  userController.pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}