class ChatMessage {
  final String id;
  final String authorName;
  final String authorInitials;
  final String text;
  final DateTime createdAt;
  final bool isMine;

  const ChatMessage({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.text,
    required this.createdAt,
    required this.isMine,
  });
}
