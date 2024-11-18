import 'package:flutter/material.dart';
import 'package:itx/Serializers/ChatMessages.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final ContractsModel model;
  ChatScreen({required this.model});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  List<ChatsMessages> messages = [];
  bool isTyping = false;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final chatMessages = await CommodityService.getChatMessages(
        context: context,
        receiverId: widget.model.user_id,
      );
      
      setState(() {
        messages = chatMessages;
        isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      print("Error loading messages: $e");
      setState(() => isLoading = false);
    }
  }

  void _connectSocket() {
    socket = IO.io(
      'ws://185.141.63.56:3067',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    socket.onError((error) => print('Socket error: $error'));
    socket.onConnect((_) => print('Connected to server'));

    socket.on('receiveMessage', (data) {
      print('Received message: $data');
      _handleReceivedMessage(data);
    });

    socket.on('typing', (_) => _handleTypingEvent());
    socket.onDisconnect((_) => print('Disconnected from server'));
  }

  void _handleReceivedMessage(dynamic data) {
    if (data != null) {
      setState(() {
        messages.add(ChatsMessages(
          id: DateTime.now().millisecondsSinceEpoch,
          sender_id: data['senderId'],
          receiver_id: widget.model.user_id,
          message: data['message'],
          created_at: DateTime.now().toIso8601String(),
          is_read: 0,
          senderName: data['senderName'] ?? '',
          receiverName: widget.model.contract_user!,
        ));
      });
      _scrollToBottom();
    }
  }

  void _handleTypingEvent() {
    setState(() => isTyping = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() => isTyping = false);
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String message) {
    try {
      if (message.trim().isNotEmpty) {
        final appBloc bloc = Provider.of<appBloc>(context, listen: false);
        final newMessage = ChatsMessages(
          id: DateTime.now().millisecondsSinceEpoch,
          sender_id: bloc.user_id,
          receiver_id: widget.model.user_id,
          message: message,
          created_at: DateTime.now().toIso8601String(),
          is_read: 0,
          senderName: bloc.userEmail ?? '',
          receiverName: widget.model.contract_user!,
        );

        final Map<String, dynamic> payload = {
          "senderId": bloc.user_id,
          "receiverId": widget.model.user_id,
          "message": message
        };
        
        socket.emit('sendMessage', payload);
        setState(() => messages.add(newMessage));
        _controller.clear();
        _scrollToBottom();
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

  Widget _buildMessageBubble(ChatsMessages message) {
    final appBloc bloc = Provider.of<appBloc>(context, listen: false);
    final isUser = message.sender_id == bloc.user_id;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isUser ? Colors.green.shade100 : Colors.white,
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
                message.message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 4.0,
                right: isUser ? 8.0 : 0,
                left: isUser ? 0 : 8.0,
              ),
              child: Text(
                DateFormat('HH:mm').format(DateTime.parse(message.created_at)),
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
  }

  Widget _buildMessageList() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.0),
      itemCount: messages.length,
      itemBuilder: (context, index) => _buildMessageBubble(messages[index]),
    );
  }

  Widget _buildInputField() {
    return Padding(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.model.contract_user!,
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
            Expanded(child: _buildMessageList()),
            _buildInputField(),
          ],
        ),
      ),
    );
  }
}