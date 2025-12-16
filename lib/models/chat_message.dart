class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isMarkdown;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isMarkdown = false,
  });

  /// Create a ChatMessage from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] ?? '',
      isUser: json['is_user'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isMarkdown: json['is_markdown'] ?? false,
    );
  }

  /// Convert ChatMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'is_markdown': isMarkdown,
    };
  }

  /// Create a copy with modified fields
  ChatMessage copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isMarkdown,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isMarkdown: isMarkdown ?? this.isMarkdown,
    );
  }
}