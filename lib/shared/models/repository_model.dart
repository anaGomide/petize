class Repository {
  final String name;
  final String? description;
  final int stars;
  final DateTime updatedAt;
  final String html_url;

  Repository({
    required this.name,
    this.description,
    required this.stars,
    required this.updatedAt,
    required this.html_url,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'],
      stars: json['stargazers_count'],
      updatedAt: DateTime.parse(json['updated_at']),
      html_url: json['html_url'],
    );
  }
}
