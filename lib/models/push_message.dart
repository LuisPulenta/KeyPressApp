class PushMessage {
  final int? id;
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final String user;
  final String? imageUrl;
  bool readed;

  PushMessage({
    this.id = 0,
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    required this.user,
    this.imageUrl,
    this.readed = false,
  });

  factory PushMessage.fromJson(Map<String, dynamic> json) => PushMessage(
    id: json['id'],
    messageId: json['messageId'],
    title: json['title'],
    body: json['body'],
    sentDate: DateTime.parse(json['sentDate']),
    user: json['user'],
    imageUrl: json['imageUrl'] ?? '',
    readed: json['readed'] == 1,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'messageId': messageId,
    'title': title,
    'body': body,
    'sentDate': sentDate,
    'user': user,
    'imageUrl': imageUrl,
    'readed': readed,
  };

  // Método copyWith
  PushMessage copyWith({
    int? id,
    String? messageId,
    String? title,
    String? body,
    DateTime? sentDate,
    String? user,
    String? imageUrl,
    bool? readed,
  }) {
    return PushMessage(
      id: id ?? this.id, // Si no se pasa un nuevo id, mantén el anterior
      messageId: messageId ?? this.messageId,
      title: title ?? this.title,
      body: body ?? this.body,
      sentDate: sentDate ?? this.sentDate,
      user: user ?? this.user,
      imageUrl: imageUrl ?? this.imageUrl,
      readed: readed ?? this.readed,
    );
  }

  @override
  String toString() {
    return '''
  Pushmessage 
  id:       $id
  messageId:$messageId
  title:    $title
  body:     $body
  sentDate: $sentDate
  user:     $user
  imageUrl: $imageUrl
  readed:   $readed

''';
  }
}
