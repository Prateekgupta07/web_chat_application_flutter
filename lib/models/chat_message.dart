import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String message;

  @HiveField(1)
  String origin;

  @HiveField(2)
  String session;

  ChatMessage({required this.message, required this.origin, required this.session});
}
