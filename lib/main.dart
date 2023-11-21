import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:prescription_document/bindings/home_page_binding.dart';
import 'package:prescription_document/firebase_options.dart';
import 'package:prescription_document/views/home/home_page.dart';
import 'package:prescription_document/routes/app_pages.dart';
import 'package:prescription_document/routes/app_routes.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prescription Records',
      // theme: AppTheme.lightTheme(),
      initialBinding: HomeBinding(),
      initialRoute: AppRoutes.home_screen,
      getPages: AppPages.list,
    );
  }
}
