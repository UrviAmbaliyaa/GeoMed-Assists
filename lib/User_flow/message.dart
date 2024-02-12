import 'package:flutter/material.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:hive/hive.dart';

class messageScreen extends StatefulWidget {
  const messageScreen({super.key});

  @override
  State<messageScreen> createState() => _messageScreenState();
}

class _messageScreenState extends State<messageScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  TextStyle title = TextStyle(color: AppColor.textColor, fontSize: 20);
  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
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
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  style: TextStyle(color: AppColor.textColor,fontSize: 15),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Send a message',
                    hintStyle: TextStyle(color: AppColor.greycolor.withOpacity(0.5),fontSize: 15),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww"),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Urvi Ambaliya", style: title),
                  Text("Last seen Today's 8:15 PM",style: TextStyle(color: AppColor.greycolor,fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.call,color: AppColor.textColor,size: 30)
          ],
        )
      ),
      body: Column(
        children: [
          Divider(
            color: AppColor.greycolor.withOpacity(0.5),
          ),
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: 1,
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.greycolor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("10 Feb 2023",style: TextStyle(color: AppColor.textColor,fontSize: 15)),
                    ),
                    Container(
                      width: width*0.9,
                      margin: EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("Hello Sir, Good Morning!",style: TextStyle(color: AppColor.textColor,fontSize: 15)),
                          ),
                          SizedBox(height: 2),
                          Text("8 PM",style: TextStyle(color: AppColor.greycolor,fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      width: width*0.9,
                      margin: EdgeInsets.only(top: 15),
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColor.greycolor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("Hello Ma'am, Good Morning!\nHave a Nice day",style: TextStyle(color: AppColor.textColor,fontSize: 15),textAlign: TextAlign.start),
                          ),
                          SizedBox(height: 2),
                          Text("8:30 PM",style: TextStyle(color: AppColor.greycolor,fontSize: 12)),
                        ],
                      ),
                    )
                  ],
                );
              },

            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;

  ChatMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(text,style: TextStyle(color: AppColor.textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}