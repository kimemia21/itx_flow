import 'package:flutter/material.dart';
import 'package:itx/Serializers/ChatMessages.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final ContractsModel? model;
  final ChatsMessages? messages;
  final List<ChatsMessages>? allMessages;

  ChatScreen({
    this.model,
    this.messages,
    this.allMessages,
  });

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
  late final _receiverId;
  late final String? _receiverName;

  @override
  void initState() {
    super.initState();
    print("this is reciever ${widget.messages?.receiver_id}");
    print("this is reciever ${widget.messages?.receiverName}");
    print("this is reciever ${widget.model?.user_id}");
    print("this is reciever ${widget.model?.contract_user}");

    _receiverId = widget.model != null
        ? widget.model!.user_id
        : widget.messages?.receiver_id;

    _receiverName = widget.model != null
        ? widget.model!.contract_user
        : widget.messages?.receiverName;

    _connectSocket();

    if (widget.allMessages != null) {
      setState(() {
        messages = List.from(widget.allMessages!);
        messages.sort((a, b) => DateTime.parse(a.created_at)
            .compareTo(DateTime.parse(b.created_at)));
        isLoading = false;
      });
      _scrollToBottom();
    } else {
      _loadMessages();
    }
  }

  Future<void> _loadMessages() async {
    try {
      if (_receiverId == null) {
        print("Error: Receiver ID is null");
        setState(() => isLoading = false);
        return;
      }

      final chatMessages = await CommodityService.getChatMessages(
        context: context,
        receiverId: _receiverId,
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
          .enableAutoConnect() // Enable auto-reconnect
          .enableReconnection() // Enable reconnection
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .build(),
    );
    socket.connect();

    socket.onError((error) => print('Socket error: $error'));

    socket.onConnect((_) => print('Connected to server'));

    socket.on('receiveMessage', (data) {
      print('Received message: $data');
      if (data != null) {
        if (data['receiverId'] == _receiverId ||
            data['senderId'] == _receiverId) {
          _handleReceivedMessage(data);
        }
      }
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
          receiver_id: _receiverId,
          message: data['message'],
          created_at: DateTime.now().toIso8601String(),
          is_read: 0,
          senderName: data['senderName'] ?? '',
          receiverName: _receiverName!,
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
        final Bloc = Provider.of<appBloc>(context, listen: false);

        // Ensure we have valid sender and receiver IDs
        final int senderId = Bloc.user_id;
        if (_receiverId == null || _receiverId == senderId) {
          print("Error: Invalid receiver ID or same as sender ID");
          return;
        }

        final newMessage = ChatsMessages(
          id: DateTime.now().millisecondsSinceEpoch,
          sender_id: senderId,
          receiver_id: _receiverId,
          message: message,
          created_at: DateTime.now().toIso8601String(),
          is_read: 0,
          senderName: Bloc.userEmail ?? '',
          receiverName: _receiverName ?? 'Unknown',
        );

        final Map<String, dynamic> payload = {
          "senderId": senderId,
          "receiverId": _receiverId,
          "message": message,
          "senderName": Bloc.userEmail ?? ''
          // Added sender name to payload
        };

        // Debug logging
        print("Sending message payload: $payload");

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
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser) // Show sender name for received messages
              Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 2.0),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
                _formatMessageTime(message.created_at),
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

  String _formatMessageTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }
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
          _receiverName!,
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
