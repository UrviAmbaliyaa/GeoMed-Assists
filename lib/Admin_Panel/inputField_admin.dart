import 'package:flutter/material.dart';
import 'package:geomed_assist/constants/Appcolors.dart';

class inputField_admin extends StatefulWidget {
  final TextEditingController contoller;
  final Function(String value) validation;
  final Widget sufixIcon;
  final String hintTest;
  final bool password;
  final bool readOnly;
  final TextInputType keybordType;
  final bool passwordvisiblity;
  final Iterable<String>? autofillHint;
  final Function()? onchageAction;
  
  const inputField_admin({super.key, required this.contoller, required this.validation, required this.sufixIcon, required this.hintTest, required this.password, required this.readOnly, required this.keybordType, required this.passwordvisiblity, this.autofillHint, this.onchageAction});

  @override
  State<inputField_admin> createState() => _inputField_adminState();
}

class _inputField_adminState extends State<inputField_admin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 6),
      child: TextFormField(
        controller: widget.contoller,
        keyboardType: widget.keybordType,
        autofillHints: widget.autofillHint,
        obscureText: widget.passwordvisiblity,
        validator: (value) => widget.validation(value!),
        readOnly: widget.readOnly,
        style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          suffixIcon:widget.sufixIcon,
          contentPadding: EdgeInsets.only(top: 15,bottom: 15,left: 13,right: 2),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: Colors.deepPurple, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),  width: 2
              ),
              borderRadius: BorderRadius.circular(15)),
          hintText: widget.hintTest,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.8),
              fontSize: 17,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
