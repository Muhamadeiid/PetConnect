import 'pet.dart';

class MatchSummary {
  const MatchSummary({
    required this.matchId,
    required this.threadId,
    required this.pet,
    this.lastMessage,
  });

  final String matchId;
  final String threadId;
  final Pet pet;
  final String? lastMessage;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String senderId;
  final String body;
  final DateTime createdAt;

  factory ChatMessage.fromRow(Map<String, dynamic> row) => ChatMessage(
    id: row['id'] as String,
    senderId: row['sender_id'] as String,
    body: row['body'] as String? ?? '',
    createdAt: DateTime.parse(row['created_at'] as String),
  );
}
