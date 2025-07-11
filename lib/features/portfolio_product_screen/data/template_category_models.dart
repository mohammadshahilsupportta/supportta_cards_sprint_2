class TemplateCategory {
  final String id;
  final String name;

  TemplateCategory({required this.id, required this.name});

  factory TemplateCategory.fromJson(Map<String, dynamic> json) {
    return TemplateCategory(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
