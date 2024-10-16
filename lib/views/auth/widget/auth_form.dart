import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/common/widgets/common_app_button.dart';
import 'package:prescription_document/controllers/user_controller/user_controller.dart';
import 'package:prescription_document/views/auth/widget/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  
  // final Function submitFn;
  final void Function(
    String email,
    String password,
    String username,
    XFile image,
  ) submitRegFn;
  final void Function(String email,String password) submitLoginFn;
  AuthForm({super.key, required this.submitLoginFn,required this.submitRegFn, });
  

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  

  void _tryRegisterSubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // if (_userImageFile == null && !_isLogin) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: const Text('Please Pick An Image'),
    //     backgroundColor: Colors.red,
    //   ));
    // }

    if (isValid) {
      _formKey.currentState!.save();
      log(_userName);
      widget.submitRegFn(
        _userEmail.trim(), _userPassword.trim(),_userName.trim(),
           Get.find<UserController>().pickedImage!
          );
    }
  }

  void _tryLoginSubmit(){
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // if (_userImageFile == null && !_isLogin) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: const Text('Please Pick An Image'),
    //     backgroundColor: Colors.red,
    //   ));
    // }

    if (isValid) {
      _formKey.currentState!.save();
      log(_userName);
      widget.submitLoginFn(
        _userEmail.trim(), _userPassword.trim()
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xFFDAD5F8),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin)
                    const UserImagePicker(
                      containerColor: Colors.white,
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2)),
                      // labelStyle: TextStyle(color: Colors.white,fontSize: 14)
                    ),
                    validator: ((value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please Use Valid Email';
                      }
                      return null;
                    }),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!isLogin) const SizedBox(height: 16),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey('name'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please Use Valid Name';
                        }
                        return null;
                      }),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: ((value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Please Use Valid Password';
                      }
                      return null;
                    }),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CommonAppButton(
                      onTapButton: isLogin? _tryLoginSubmit: _tryRegisterSubmit,
                      btnContent: isLogin ? 'Login' : 'SignUp',
                      btnIcon: Icons.app_registration),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'Create New Account'
                          : 'Already have an account',
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
