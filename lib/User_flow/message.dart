import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geomed_assist/Doctor_flow/bottomsheet_doctor.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/ChatModel.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/Store_flow/bottomNavigationBar_Shop.dart';
import 'package:geomed_assist/User_flow/BottonTabbar.dart';
import 'package:geomed_assist/User_flow/map.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:intl/intl.dart';

class messageScreen extends StatefulWidget {
  final DocumentReference chatrefe;
  final UserModel user;

  const messageScreen({super.key, required this.chatrefe, required this.user});

  @override
  State<messageScreen> createState() => _messageScreenState();
}

class _messageScreenState extends State<messageScreen> {

  final TextEditingController _textController = TextEditingController();
  List<DateTime> listDates = [];
  bool isload = false;
  TextStyle title = TextStyle(color: AppColor.textColor, fontSize: 20);
  List<Map<String,dynamic>> maindata = [];
  final FocusNode _focusNode = FocusNode();
  Future<void> _handleSubmitted() async {
    if(_textController.text.trim().length != 0){
      var mapdata = {
        'sender': currentUserDocument!.reference,
        'receiver': widget.user.reference,
        'message': _textController.text,
        'messageTime': DateTime.now(),
      };
      maindata.add(mapdata);
      await widget.chatrefe.update({
        'last_message': _textController.text,
        'last_message_time': DateTime.now(),
        'lastMessageSender': currentUserDocument!.reference,
        'messageList': maindata,
        'userMessageList': maindata
      });
      _textController.clear();
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: AppColor.primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: AppColor.textColor, fontSize: 15),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Send a message',
                    hintStyle: TextStyle(
                        color: AppColor.greycolor.withOpacity(0.5),
                        fontSize: 15),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    maindata.clear();
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          primary: true,
          leadingWidth: 50,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.user.imagePath!),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user.name, style: title),
                    // Text("Last seen Today's 8:15 PM",style: TextStyle(color: AppColor.greycolor,fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.call, color: AppColor.textColor, size: 30)
            ],
          )),
      body: WillPopScope(
        onWillPop: () async{
          var Screens;
          switch (currentUserDocument!.type) {
            case "User":
              Screens = MapScreen();
            case "ShopKeeper":
              Screens = shop_bottomNavigationbar();
            case "Doctore":
              Screens = bottomSheet_doctor();
          }
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute<bool>(
              fullscreenDialog: true,
              builder: (BuildContext context) => Screens,
            ),
          );
          return true;
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: widget.chatrefe.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                          data.addAll({"reference": snapshot.data!.reference});
                          var chatmodeldata = ChatModel.fromJson(data);
                          var maindata2 = currentUserDocument!.type == "User"
                              ? chatmodeldata.userMessageList == null ? [] : chatmodeldata.userMessageList!
                              : chatmodeldata.messageList == null ? [] : chatmodeldata.messageList!;
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: maindata2.length,
                                  padding: EdgeInsets.all(20),
                                  itemBuilder: (context, index) {
                                    index == 0 ? maindata.clear():null;
                                    var data = maindata2[index];
                                    String date = DateFormat('dd MMM yyyy')
                                        .format(data.messageTime);
                                    maindata.add({
                                      'sender': data.sender,
                                      'receiver': data.receiver,
                                      'message': data.message,
                                      'messageTime': data.messageTime,
                                    });
                                    var listdata2 = listDates.where((element) => DateFormat('dd MMM yyyy')
                                        .format(data.messageTime) == DateFormat('dd MMM yyyy')
                                        .format(element));
                                    listdata2.length == 0? listDates.add(data.messageTime) :null;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        listDates.contains(data.messageTime) ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: AppColor.greycolor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(date,
                                              style: TextStyle(
                                                  color: AppColor.textColor,
                                                  fontSize: 15)),
                                        ):SizedBox.shrink(),
                                        data.sender != currentUserDocument!.reference?
                                        Container(
                                          width: width * 0.9,
                                          margin: EdgeInsets.only(top: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8, horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: AppColor.primaryColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(data.message,
                                                    style: TextStyle(
                                                        color: AppColor.textColor,
                                                        fontSize: 15)),
                                              ),
                                              SizedBox(height: 2),
                                              Text(DateFormat('hh:mm:ss a')
                                                  .format(data.messageTime),
                                                  style: TextStyle(
                                                      color: AppColor.greycolor,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ):
                                        Container(
                                          width: width * 0.9,
                                          margin: EdgeInsets.only(top: 15),
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8, horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColor.greycolor.withOpacity(0.8),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                    data.message,
                                                    style: TextStyle(
                                                        color: AppColor.textColor,
                                                        fontSize: 15),
                                                    textAlign: TextAlign.start),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                  DateFormat('h:mm a')
                                                      .format(data.messageTime),
                                                  style: TextStyle(
                                                      color: AppColor.greycolor,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Divider(height: 1.0),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    }
                 ),
              ),
              _buildTextComposer()
            ],
          ),
        ),
      ),
    );
  }
}

