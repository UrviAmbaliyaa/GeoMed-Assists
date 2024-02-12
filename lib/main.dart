import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Doctor_flow/bottomsheet_doctor.dart';
import 'package:geomed_assist/Splashscreen.dart';
import 'package:geomed_assist/Store_flow/bottomNavigationBar_Shop.dart';
import 'package:geomed_assist/User_flow/BottonTabbar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart' as HF;
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.location.request();
  await Permission.locationAlways.request();
  await Permission.locationWhenInUse.request();
  try {
    await HF.Hive.initFlutter();
    await Hive.openBox("User");
  } catch (error) {
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: splashScreen(),
    );
  }
}
