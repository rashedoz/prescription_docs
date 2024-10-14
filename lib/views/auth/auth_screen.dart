import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prescription_document/common/app_colors.dart';
import 'package:prescription_document/views/auth/widget/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading=false;
  String _imageUrl='';

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    XFile image,
    //BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading=true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref= FirebaseStorage.instance.ref().child('User').child('own').child(authResult.user!.uid + '.jpg');
       await ref.putFile(File(image.path));
       final url=await ref.getDownloadURL();
       //_imageUrl=await ref;
      

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'username': username, 'email': email,'image_url':url});
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred,please check your credential';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _isLoading=false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: AuthForm(
        submitFn: _submitAuthForm,
        isLoading:_isLoading,
      ),
    );
  }
}