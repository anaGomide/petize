class User {
  final String login;
  final String avatarUrl;
  final String bio;
  final String? blog;
  final String? twitterUsername;

  User({required this.login, required this.avatarUrl, required this.bio, this.blog, this.twitterUsername});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      blog: json['blog'],
      twitterUsername: json['twitter_username'],
    );
  }
}
