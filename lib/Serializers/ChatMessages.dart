class ChatsMessages {
  final int id;
  final int sender_id;
  final int receiver_id;
  final String message;
  final String created_at;
  final int is_read;
  final String senderName;
  final String receiverName;

  ChatsMessages({
    required this.id,
    required this.sender_id,
    required this.receiver_id,
    required this.message,
    required this.created_at,
    required this.is_read,
    required this.senderName,
    required this.receiverName,
  });

  factory ChatsMessages.fromJson(Map<String, dynamic> json) {
    return ChatsMessages(
      id: json['id'],
      sender_id: json['sender_id'],
      receiver_id: json['receiver_id'],
      message: json['message'],
      created_at: json['created_at'],
      is_read: json['is_read'],
      senderName: json['senderName'],
      receiverName: json['receiverName'],
    );
  }
}
