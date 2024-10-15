
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/controllers/user_controller/user_controller.dart';
import 'package:prescription_document/views/auth/widget/auth_form.dart';

class AuthScreen extends StatelessWidget {
  
  const AuthScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: GetBuilder<UserController>(builder: (userController){
        return AuthForm(
        submitFn: userController.signUp,
        isLoading: userController.isLoading.value,
      );
      }),
    );
  }
}
