import 'package:flutter/material.dart';
import 'package:itx/Serializers/ChatMessages.dart';
import 'package:itx/chatbox/ChatBox.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<ChatsMessages>>(
        future: CommodityService.getAllChats(context: context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          // Group chats by sender
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.message),
      ),
    );
  }

  List<BundledChat> _groupChats(List<ChatsMessages> chats) {
    // Group chats by sender name
    final groupedMap = <String, List<ChatsMessages>>{};
    
    for (var chat in chats) {
      if (!groupedMap.containsKey(chat.senderName)) {
        groupedMap[chat.senderName] = [];
      }
      groupedMap[chat.senderName]!.add(chat);
    }

    // Convert grouped map to list of BundledChat objects
    return groupedMap.entries.map((entry) {
      final messages = entry.value;
      return BundledChat(
        senderName: entry.key,
        messages: messages,
        lastMessage: messages.reduce((a, b) => 
          DateTime.parse(a.created_at).isAfter(DateTime.parse(b.created_at)) ? a : b
        ),
        unreadCount: messages.where((m) => m.is_read == 0).length,
      );
    }).toList()
      ..sort((a, b) => DateTime.parse(b.lastMessage.created_at)
          .compareTo(DateTime.parse(a.lastMessage.created_at)));
  }
}

class BundledChat {
  final String senderName;
  final List<ChatsMessages> messages;
  final ChatsMessages lastMessage;
  final int unreadCount;

  BundledChat({
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
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ChatScreen(
      messages: bundledChat.messages.first, // Pass first message for metadata
      allMessages: bundledChat.messages, // Pass all messages from this sender
    ),
          withNavBar: true,
        );
      },
    );
  }
}