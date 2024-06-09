import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/websocket_service.dart';
import 'package:hive/hive.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final String session;

  ChatScreen({required this.session});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late Box<ChatMessage> chatBox;
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    chatBox = Hive.box<ChatMessage>('chatMessages');
    final webSocketService = context.read<WebSocketService>();
    webSocketService.connect('wss://echo.websocket.org');

    webSocketService.messages.listen((message) {
      webSocketService.saveReceivedMessage(message.toString(), widget.session);
      setState(() {
        messages.add(ChatMessage(message: message.toString(), origin: 'server', session: widget.session));
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    loadMessages();
  }

  void loadMessages() {
    final allMessages = chatBox.values.where((msg) => msg.session == widget.session).toList();
    setState(() {
      messages = allMessages.cast<ChatMessage>();
    });
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session != widget.session) {
      loadMessages();
    }
  }

  @override
  void dispose() {
    final webSocketService = context.read<WebSocketService>();
    webSocketService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final webSocketService = context.read<WebSocketService>();
      webSocketService.sendMessage(_controller.text, widget.session);
      setState(() {
        messages.add(ChatMessage(message: _controller.text, origin: 'user', session: widget.session));
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isUserMessage = message.origin == 'user';
              return Align(
                alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isUserMessage ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: isUserMessage ? Colors.black : Colors.green,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'Send a message...'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
