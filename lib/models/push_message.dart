class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final String user;
  final String? imageUrl;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    required this.user,
    this.imageUrl,
  });

  @override
  String toString() {
    return '''
  Pushmessage 
  id:       $messageId
  title:    $title
  body:     $body
  sentDate: $sentDate
  user:     $user
  imageUrl: $imageUrl

''';
  }
}
