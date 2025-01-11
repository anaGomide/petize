class Repository {
  final String name;
  final String description;
  final int stars;
  final String htmlUrl;

  Repository({
    required this.name,
    this.description = '',
    required this.stars,
    required this.htmlUrl,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'] ?? '',
      stars: json['stargazers_count'],
      htmlUrl: json['html_url'],
    );
  }
}
