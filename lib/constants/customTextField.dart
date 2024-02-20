import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/constants/Appcolors.dart';

class customeTextFormField extends StatefulWidget {
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

  const customeTextFormField({super.key, required this.contoller, required this.validation, required this.hintTest, required this.password, required this.keybordType, required this.autofillHint, required this.sufixIcon, required this.passwordvisiblity, this.readOnly = false, this.onchageAction});

  @override
  State<customeTextFormField> createState() => _customeTextFormFieldState();
}

class _customeTextFormFieldState extends State<customeTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 6),
      child: TextFormField(
        onChanged: (value) {
          widget.onchageAction!.call();
        },
        controller: widget.contoller,
        keyboardType: widget.keybordType,
        autofillHints: widget.autofillHint,
        obscureText: widget.passwordvisiblity,
        validator: (value) => widget.validation(value!),
        cursorColor: AppColor.primaryColor,
        readOnly: widget.readOnly,
        style: TextStyle(
            color: AppColor.textColor,
            fontSize: 17,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          suffixIcon:widget.sufixIcon,
          contentPadding: EdgeInsets.only(top: 13,bottom: 13,left: 13,right: 2),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: AppColor.primaryColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)),
          fillColor: AppColor.inputTextfill,
          filled: true,
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
