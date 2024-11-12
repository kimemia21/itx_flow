// chat_model.dart
import 'package:flutter/material.dart';
class ChatModel {
  final String name;
  final String lastMessage;
  final String avatarUrl;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatModel({
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}

// chat_service.dart
class ChatService {
  Future<List<ChatModel>> getChats() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Dummy data
    return [
      ChatModel(
        name: "Sarah Wilson",
        lastMessage: "See you tomorrow at the meeting! 👋",
        avatarUrl: "https://i.pravatar.cc/150?img=1",
        time: "10:45 AM",
        unreadCount: 2,
        isOnline: true,
      ),
      ChatModel(
        name: "John Developer",
        lastMessage: "The new feature is ready for testing",
        avatarUrl: "https://i.pravatar.cc/150?img=2",
        time: "9:30 AM",
        unreadCount: 0,
        isOnline: false,
      ),
      ChatModel(
        name: "kikebe",
        lastMessage: "2500 per kg",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        time: "Yesterday",
        unreadCount: 4,
        isOnline: true,
      ),
      ChatModel(
        name: "kikuyutea1",
        lastMessage: "too low ",
        avatarUrl: "https://i.pravatar.cc/150?img=4",
        time: "Yesterday",
        unreadCount: 1,
        isOnline: false,
      ),
      // ChatModel(
      //   name: "Project X Group",
      //   lastMessage: "T",
      //   avatarUrl: "https://i.pravatar.cc/150?img=5",
      //   time: "Tuesday",
      //   unreadCount: 0,
      //   isOnline: true,
      // ),
    ];
  }
}

// chat_list_screen.dart


class ChatListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  ChatListScreen({Key? key}) : super(key: key);

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
      body: FutureBuilder<List<ChatModel>>(
        future: _chatService.getChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chat = snapshot.data![index];
              return ChatListTile(chat: chat);
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
}

class ChatListTile extends StatelessWidget {
  final ChatModel chat;

  const ChatListTile({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(chat.avatarUrl),
          ),
          if (chat.isOnline)
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
      title: Text(
        chat.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: chat.unreadCount > 0 ? Colors.black87 : Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: TextStyle(
              color: chat.unreadCount > 0 ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
          if (chat.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        // Handle chat item tap
      },
    );
  }
}