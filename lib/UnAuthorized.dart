import 'package:flutter/material.dart';

class unAuthorized extends StatefulWidget {
  const unAuthorized({super.key});

  @override
  State<unAuthorized> createState() => _unAuthorizedState();
}

class _unAuthorizedState extends State<unAuthorized> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("UnAuthorized person",style: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
