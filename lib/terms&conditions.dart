import 'package:flutter/material.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';

class terms_conditions extends StatefulWidget {
  const terms_conditions({super.key});

  @override
  State<terms_conditions> createState() => _terms_conditionsState();
}

class _terms_conditionsState extends State<terms_conditions> {
  String reaction = """ It’s the classic sign of a heart attack, yet many people don’t realise this could be a medical emergency.

Professor Newby says: “If you have chest pain and you feel extremely unwell, you should dial 999 and get an ambulance as soon as possible. If it’s a heart attack, it’s usually described as a heaviness, tightness or pressure in the chest; people will often describe it as ‘an elephant sat on my chest’ or ‘it felt like a tight band around my chest,’ that sort of constricting feeling.

“If chest pains occur when you are exerting yourself, but go away when you stop, that would suggest it’s more likely to be angina. That would still mean you should go and see a doctor, but you don’t have to call 999.”

Professor Newby advises that chest pains accompanied by feeling extremely unwell, mean it is probably the right time to call 999 and request an ambulance.
It’s the classic sign of a heart attack, yet many people don’t realise this could be a medical emergency.

Professor Newby says: “If you have chest pain and you feel extremely unwell, you should dial 999 and get an ambulance as soon as possible. If it’s a heart attack, it’s usually described as a heaviness, tightness or pressure in the chest; people will often describe it as ‘an elephant sat on my chest’ or ‘it felt like a tight band around my chest,’ that sort of constricting feeling.

“If chest pains occur when you are exerting yourself, but go away when you stop, that would suggest it’s more likely to be angina. That would still mean you should go and see a doctor, but you don’t have to call 999.”

Professor Newby advises that chest pains accompanied by feeling extremely unwell, mean it is probably the right time to call 999 and request an ambulance.
""";
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context,Name: "Terms and Conditions",backbutton: true),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: width * 0.4,
                alignment: Alignment.bottomCenter,
                child: Image.asset("assets/logo/Logo.png", color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Terms and Conditions",
                style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text(
                  reaction,
                  style: TextStyle(color: AppColor.textColor, fontSize: 13)),

            ],
          ),
        ),
      ),
    );
  }
}
