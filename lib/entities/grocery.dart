import 'dart:convert';

class Grocery {
  Grocery({
    required this.content,
    this.isComplete = false,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  String content;
  bool isComplete;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions;

  factory Grocery.fromJson(String str) => Grocery.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Grocery.fromMap(Map<String, dynamic> json) => Grocery(
        content: json["content"],
        isComplete: json["isComplete"],
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "content": content,
      "isComplete": isComplete,
    };

    return map;
  }
}
