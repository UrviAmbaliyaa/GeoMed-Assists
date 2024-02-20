import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Splashscreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await Permission.location.request();
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
    await Hive.initFlutter();
    await Hive.openBox("User");
  }catch(error){
    print("Error ====>$error");
  }
    runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoMep Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: splashScreen(),
    );
  }
}
