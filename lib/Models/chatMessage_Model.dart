class ChatMessage {
  final String id;
  final String type;
  final ChatMessageAttributes attributes;

  ChatMessage({
    required this.id,
    required this.type,
    required this.attributes,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      type: json['type'],
      attributes: ChatMessageAttributes.fromJson(json['attributes']),
    );
  }
}

class ChatMessageAttributes {
  final String? message;
  final String? createdAt;
  final int? senderId;
  final int? receiverId;

  ChatMessageAttributes({
    this.message,
    this.createdAt,
    this.senderId,
    this.receiverId,
  });

  factory ChatMessageAttributes.fromJson(Map<String, dynamic> json) {
    return ChatMessageAttributes(
      message: json['message'],
      createdAt: json['created_at'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
    );
  }
}
