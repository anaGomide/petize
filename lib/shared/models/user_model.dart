class User {
  final String login;
  final String? avatarUrl;
  final String? name;
  final String? company;
  final String? blog;
  final String? location;
  final String? email;
  final bool? siteAdmin;
  final String? bio;
  final String? twitterUsername;
  final int? publicRepos;
  final int? publicGists;
  final int? followers;
  final int? following;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.login,
    this.avatarUrl,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.siteAdmin,
    this.bio,
    this.twitterUsername,
    this.publicRepos,
    this.publicGists,
    this.followers,
    this.following,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      name: json['name'],
      company: json['company'],
      blog: json['blog'],
      location: json['location'],
      email: json['email'],
      siteAdmin: json['site_admin'] ?? false,
      bio: json['bio'],
      twitterUsername: json['twitter_username'],
      publicRepos: json['public_repos'],
      publicGists: json['public_gists'],
      followers: json['followers'],
      following: json['following'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
