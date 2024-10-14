
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/common/widgets/common_app_button.dart';
import 'package:prescription_document/controllers/image_controller/image_picker_controller.dart';
import 'package:prescription_document/views/auth/widget/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitFn, required this.isLoading});
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    XFile image,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  XFile? _userImageFile;

  void _pickImage(XFile image) {
    
      _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please Pick An Image'),
        backgroundColor: Colors.red,
      ));
    }

    if (isValid) {
      _formKey.currentState!.save();
      print(_userName);
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(), _isLogin,Get.find<ImagePickerController>().pickedImage!);
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
                  if (!_isLogin) UserImagePicker(containerColor: Colors.white,),
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
                        borderSide: BorderSide(
                          color: Colors.yellow,
                          width: 2
                        )
                      ),
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
                  const SizedBox(height: 16),
                  if (!_isLogin)
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
                  CommonAppButton(onTapButton: _trySubmit, btnContent: _isLogin ? 'Login' : 'SignUp', btnIcon: Icons.app_registration),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Create New Account'
                          : 'Already have an account',
                          style: Get.theme.textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.w600),
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