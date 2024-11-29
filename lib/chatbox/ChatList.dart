import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:itx/Serializers/ChatMessages.dart';
import 'package:itx/chatbox/ChatBox.dart';
import 'package:itx/global/comms.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<Map<String, List<ChatsMessages>>> futureChats;

  @override
  void initState() {
    super.initState();
    futureChats = fetchChats();
  }

  Future<Map<String, List<ChatsMessages>>> fetchChats() async {
    try {
      final chats = await CommodityService.getAllChats(context: context);
      return chats;
    } catch (e) {
      print('Error fetching chats: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            futureChats = fetchChats();
          });
          return futureChats;
        },
        child: FutureBuilder<Map<String, List<ChatsMessages>>>(
          future: futureChats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.green,
                size: 40,
              ));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No chats available'));
            }

            final groupedChats = _groupChats(snapshot.data!);

            return ListView.builder(
              itemCount: groupedChats.length,
              itemBuilder: (context, index) {
                final bundledChat = groupedChats[index];
                return BundledChatListTile(bundledChat: bundledChat);
              },
            );
          },
        ),
      ),
    );
  }

  List<BundledChat> _groupChats(Map<String, List<ChatsMessages>> chatsMap) {
    final currentUserId =
        Provider.of<appBloc>(context, listen: false).user_id;
    
    List<BundledChat> bundledChats = [];

    chatsMap.forEach((receiverId, messages) {
      // Sort messages by date
      messages.sort((a, b) =>
          DateTime.parse(b.created_at).compareTo(DateTime.parse(a.created_at)));

      // Determine conversation partner name
      final isCurrentUserSender = messages.first.sender_id == currentUserId;
      final conversationPartnerName = isCurrentUserSender 
          ? messages.first.receiverName 
          : messages.first.senderName;

      final bundledChat = BundledChat(
        receiverId: int.parse(receiverId),
        senderName: conversationPartnerName,
        messages: messages,
        lastMessage: messages.first,
        unreadCount: messages
            .where((m) => m.is_read == 0 && m.sender_id != currentUserId)
            .length,
      );

      bundledChats.add(bundledChat);
    });

    // Sort bundled chats by most recent message
    bundledChats.sort((a, b) => DateTime.parse(b.lastMessage.created_at)
        .compareTo(DateTime.parse(a.lastMessage.created_at)));

    return bundledChats;
  }
}

class BundledChat {
  final int receiverId;
  final String senderName;
  final List<ChatsMessages> messages;
  final ChatsMessages lastMessage;
  final int unreadCount;

  BundledChat({
    required this.receiverId,
    required this.senderName,
    required this.messages,
    required this.lastMessage,
    required this.unreadCount,
  });
}

class BundledChatListTile extends StatelessWidget {
  final BundledChat bundledChat;

  const BundledChatListTile({
    Key? key,
    required this.bundledChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/profile.jpg"),
          ),
          if (bundledChat.unreadCount > 0)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              bundledChat.senderName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (bundledChat.messages.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${bundledChat.messages.length} messages',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bundledChat.lastMessage.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: bundledChat.unreadCount > 0 ? Colors.black87 : Colors.grey,
            ),
          ),
          Text(
            bundledChat.lastMessage.created_at,
            style: TextStyle(
              fontSize: 12,
              color: bundledChat.unreadCount > 0 ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
      trailing: bundledChat.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Text(
                bundledChat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            )
          : null,
      onTap: () {
        final currentUserId =
            Provider.of<appBloc>(context, listen: false).user_id;
        final metadataMessage = bundledChat.messages.firstWhere(
          (msg) => msg.receiver_id == currentUserId,
          orElse: () => bundledChat.messages.first,
        );

        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ChatScreen(
            messages: metadataMessage,
            allMessages: bundledChat.messages,
            receiverId: bundledChat.receiverId, // Pass the receiver ID
          ),
          withNavBar: true,
        );
      },
    );
  }
}

// Update the CommodityService to return Map instead of List
class CommodityService {
  static Future<Map<String, List<ChatsMessages>>> getAllChats({
    required BuildContext context,
  }) async {
    try {
      final Uri uri = Uri.parse("http://185.141.63.56:3067/api/v1/chats");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": currentUser.token
      };

      final http.Response response = await http.get(uri, headers: headers);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body["rsp"]) {
        final Map<String, dynamic> data = body["data"];
        
        // Convert each list of messages to ChatsMessages objects
        final Map<String, List<ChatsMessages>> processedData = 
            data.map((receiverId, messages) => MapEntry(
              receiverId, 
              (messages as List)
                .map((json) => ChatsMessages.fromJson(json))
                .toList()
            ));

        return processedData;
      } else {
        throw Exception("Failed to load chat messages");
      }
    } catch (e) {
      print("Error fetching chat messages: $e");
      return {};
    }
  }
}