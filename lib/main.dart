import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Splashscreen.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    if(kIsWeb){
      await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyCfevzKUflwesQW8MBCr62PjhYT0H3qhyI",
              authDomain: "geomed-assistans.firebaseapp.com",
              databaseURL: "https://geomed-assistans-default-rtdb.firebaseio.com",
              projectId: "geomed-assistans",
              storageBucket: "geomed-assistans.appspot.com",
              messagingSenderId: "755110933607",
              appId: "1:755110933607:web:bc399e61617948ebccd0c2",
              measurementId: "G-C1TG2PZ5S6"
          )
      );
    }else{
      await Firebase.initializeApp();
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
      ),
      home: splashScreen(),
    );
  }
}
