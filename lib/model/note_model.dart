
class Note{

  final int? id;
  final String title;
  final String content;
  final int color;

  Note({required this.title, required this.content, required this.id, required this.color});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    color: json['color'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'color': color,
  };

  // Map<String, dynamic> toMap() {
  //   var map = <String, dynamic>{};
  //   map['id'] = _id;
  //   map['title'] = _title;
  //   map['content'] = _content;
  //
  //   return map;
  // }
}