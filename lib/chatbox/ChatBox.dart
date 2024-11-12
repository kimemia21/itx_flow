import 'package:flutter/material.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io(
         'ws://192.168.100.56:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
        socket.connect();

if (socket.connected) {
  print('Socket is connected');
} else {
  print('Socket is not connected');
  socket.onError((error) {
  print('Socket error: $error');
});
}


socket.onConnect((_) {
  print('Connected to server');
});




    socket.onConnect((_) {
      print('Connected to server');
    });

    socket.on('receiveMessage', (data) {
      print('Received message: $data');
      setState(() {
        messages.add({
          'message': data,
          'isUser': false,
          'timestamp': DateTime.now(),
          'isNew': true,
        });
      });
      _scrollToBottom();
    });

    socket.on('typing', (_) {
      setState(() {
        isTyping = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isTyping = false;
        });
      });
    });

    socket.onDisconnect((_) => print('Disconnected from server'));
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage(String message) {
    try {
      print("called");
      if (message.trim().isNotEmpty) {
        final appBloc bloc = Provider.of<appBloc>(context, listen: false);

        final Map<String, dynamic> payload = {
          "senderId": bloc.user_id,
          "receiverId": 2,
          "message": message
        };
        socket.emit('sendMessage', payload);
        setState(() {
          messages.add({
            'text': message,
            'isUser': true,
            'timestamp': DateTime.now(),
            'isNew': true,
          });
        });
        _controller.clear();
        _scrollToBottom();

        // Remove the 'isNew' flag after animation
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            messages.last['isNew'] = false;
          });
        });
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  void dispose() {
    socket.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('HH:mm').format(timestamp);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This will resize the body when the keyboard opens
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chat',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Your notice container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 20.0,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'For quality purposes, we are monitoring your communication to ensure a better user experience and to help us improve our services. Your data will be kept confidential and used strictly for service improvement.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13.0,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded list of messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: message['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: message['isUser']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: message['isUser']
                                  ? Colors.green.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 14.0,
                            ),
                            child: Text(
                              message['text'],
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 4.0,
                              right: message['isUser'] ? 8.0 : 0,
                              left: message['isUser'] ? 0 : 8.0,
                            ),
                            child: Text(
                              _formatTimestamp(message['timestamp']),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Text input field with padding for the keyboard
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: () => _sendMessage(_controller.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
