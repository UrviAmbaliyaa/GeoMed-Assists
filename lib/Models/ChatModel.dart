import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final DocumentReference user;
  final DocumentReference otherUser;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final DocumentReference? lastMessageSender;
  final List<MessageItem>? messageList;
  final List<MessageItem>? userMessageList;
  final DocumentReference reference;

  ChatModel({
    required this.user,
    required this.otherUser,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSender,
    this.messageList,
    this.userMessageList,
    required this.reference,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    List<MessageItem>? messages;
    if (json['messageList'] != null) {
      messages = List<MessageItem>.from(json['messageList'].map((item) => MessageItem.fromJson(item)));
    }

    List<MessageItem>? userMessages;
    if (json['userMessageList'] != null) {
      userMessages = List<MessageItem>.from(json['userMessageList'].map((item) => MessageItem.fromJson(item)));
    }

    return ChatModel(
      user: json['user'],
      otherUser: json['otherUser'],
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] != null ? (json['last_message_time'] as Timestamp).toDate() : DateTime.now(),
      lastMessageSender: json['lastMessageSender'],
      messageList: messages,
      userMessageList: userMessages,
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? messages = messageList?.map((item) => item.toJson()).toList();
    List<Map<String, dynamic>>? userMessages = userMessageList?.map((item) => item.toJson()).toList();

    return {
      'user': user,
      'otherUser': otherUser,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'lastMessageSender': lastMessageSender,
      'messageList': messages,
      'userMessageList': userMessages,
      'reference': reference,
    };
  }
}

class MessageItem {
  DocumentReference sender;
  DocumentReference receiver;
  String message;
  DateTime messageTime;
  bool seenByReceiver;

  MessageItem({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.messageTime,
    required this.seenByReceiver,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      sender: json['sender'],
      receiver: json['receiver'],
      message: json['message'],
      messageTime: (json['messageTime'] as Timestamp).toDate(),
      seenByReceiver: json['seenByReceiver'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'messageTime': messageTime,
      'seenByReceiver': seenByReceiver,
    };
  }
}
