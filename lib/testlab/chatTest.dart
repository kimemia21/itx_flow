import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:itx/Serializers/ChatMessages.dart';
import 'package:itx/global/comms.dart';
import 'package:http/http.dart' as http;

class TestChatsMessages {
  final chat_id;
  final int id;
  final int sender_id;
  final int receiver_id;
  final String message;
  final String created_at;
  final int is_read;
  final String senderName;
  final String receiverName;

  TestChatsMessages({
    required this.chat_id,
    required this.id,
    required this.sender_id,
    required this.receiver_id,
    required this.message,
    required this.created_at,
    required this.is_read,
    required this.senderName,
    required this.receiverName,
  });

  factory TestChatsMessages.fromJson(Map<String, dynamic> json, String chatId) {
    return TestChatsMessages(
      chat_id: chatId,
      id: json['id'],
      sender_id: json['sender_id'],
      receiver_id: json['receiver_id'],
      message: json['message'],
      created_at: json['created_at'],
      is_read: json['is_read'],
      senderName: json['senderName'],
      receiverName: json['receiverName'],
    );
  }
}

class testAuth {
  static Future<List<TestChatsMessages>> TestChats({
    required BuildContext context,
  }) async {
    try {
      final Uri uri = Uri.parse("http://185.141.63.56:3067/api/v1/chats");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiYXBpIjoiQVBQIiwiaWF0IjoxNzMzMTE5MjAzLCJleHAiOjE3MzMxMzcyMDN9.vVEjrp6jA6v3cZf_sHETJln91DhcJHTOle-uKDpRGAk"
      };

      final http.Response response = await http.get(uri, headers: headers);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body["rsp"]) {
        Map<String, dynamic> data = body["data"];
        data.forEach((key, value) {
          print("Receiver ID: $key");
          // print("Messages: $value");
        });

        List<TestChatsMessages> allMessages = [];

        data.forEach((receiverId, messages) {
          List<TestChatsMessages> receiverMessages = (messages as List)
              .map((json) => TestChatsMessages.fromJson(json, receiverId))
              .toList();

          allMessages.addAll(receiverMessages);
        });

        // allMessages.sort((a, b) => DateTime.parse(a.created_at)
        //     .compareTo(DateTime.parse(b.created_at)));

        return allMessages;
      } else {
        throw Exception("Failed to load chat messages");
      }
    } catch (e) {
      print("Error fetching chat messages: $e");
      return [];
    }
  }
}

class bundleChat {
  final int length;
  final TestChatsMessages items;
  bundleChat({required this.length, required this.items});
}

bundleChat groupchat(List<TestChatsMessages> items) {
  final length = items.length;

  items.forEach((element) => bundleChat(length: length, items: element));
  return bundleChat(length: length, items: items[0]);
}

class testChat extends StatefulWidget {
  const testChat({super.key});

  @override
  State<testChat> createState() => _testChatState();
}

class _testChatState extends State<testChat> {
  @override
  void initState() {
    super.initState();
    testAuth.TestChats(context: context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TestChatsMessages>>(
        future: testAuth.TestChats(context: context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No chat messages available.');
          } else {
              groupchat(snapshot.data!);
              

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final message = snapshot.data![index];
              

                return ListTile(
                  title: Text(index.toString()),
                  leading: Text(snapshot.data!.length.toString()),
                  subtitle: Text(message.created_at),
                );
              },
            );
          }
        },
      ),
    );
  }
}
