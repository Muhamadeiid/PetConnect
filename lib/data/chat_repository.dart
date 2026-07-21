import '../core/supabase.dart';
import '../models/match_summary.dart';
import '../models/pet.dart';

class ChatRepository {
  const ChatRepository();

  Future<List<MatchSummary>> loadMatches() async {
    if (sb.auth.currentUser == null) return const [];

    final rows = await sb
        .from('match_inbox')
        .select('match_id, thread_id, pet, last_message, created_at')
        .order('created_at', ascending: false);
    return rows
        .map(
          (row) => MatchSummary(
            matchId: row['match_id'] as String,
            threadId: row['thread_id'] as String,
            pet: Pet.fromRow(Map<String, dynamic>.from(row['pet'] as Map)),
            lastMessage: row['last_message'] as String?,
          ),
        )
        .toList();
  }

  Stream<List<ChatMessage>> messages(String threadId) => sb
      .from('chat_messages')
      .stream(primaryKey: ['id'])
      .eq('thread_id', threadId)
      .order('created_at')
      .map((rows) => rows.map(ChatMessage.fromRow).toList());

  Future<void> send({required String threadId, required String body}) async {
    final userId = sb.auth.currentUser?.id;
    if (userId == null) throw StateError('You must be signed in.');
    final trimmed = body.trim();
    if (trimmed.isEmpty) return;
    await sb.from('chat_messages').insert({
      'thread_id': threadId,
      'sender_id': userId,
      'body': trimmed,
    });
  }
}
