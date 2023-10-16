import 'dart:convert';

class Plan {
  Plan({
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

  factory Plan.fromJson(String str) => Plan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Plan.fromMap(Map<String, dynamic> json) => Plan(
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
