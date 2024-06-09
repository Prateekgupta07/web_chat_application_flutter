import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:hive/hive.dart';
import '../models/chat_message.dart';

class WebSocketService {
  late WebSocketChannel channel;
  final Box<ChatMessage> chatBox;

  WebSocketService(this.chatBox);

  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void sendMessage(String message, String session) {
    channel.sink.add(message);
    final chatMessage = ChatMessage(message: message, origin: 'user', session: session);
    chatBox.add(chatMessage);
  }

  Stream get messages => channel.stream;

  void saveReceivedMessage(String message, String session) {
    final chatMessage = ChatMessage(message: message, origin: 'server', session: session);
    chatBox.add(chatMessage);
  }

  void disconnect() {
    channel.sink.close(status.goingAway);
  }
}
