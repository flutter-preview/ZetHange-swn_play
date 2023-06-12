class User {
  final String email;
  final int id;
  final String login;
  final String role;

  User({required this.email,
    required this.id,
    required this.login,
    required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['id'],
      login: json['login'],
      role: json['role'],
    );
  }
}

class UserPagination {
  final int contentSize;
  final int page;
  final int pageSize;
  final int lastPage;
  final List<User> content;

  const UserPagination({
    required this.contentSize,
    required this.page,
    required this.pageSize,
    required this.lastPage,
    required this.content,
  });

  @override
  toString() {
    return "Pagination{contentSize: $contentSize, page: $page, pageSize: $pageSize, lastPage: $lastPage, content: $content}";
  }

  factory UserPagination.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>;
    final content = contentList.map((item) => User.fromJson(item)).toList();

    return UserPagination(
      contentSize: json['contentSize'],
      page: json['page'],
      pageSize: json['pageSize'],
      lastPage: json['lastPage'],
      content: content,
    );
  }
}

class SuccessAuth {
  final String token;

  const SuccessAuth({
    required this.token,
  });

  factory SuccessAuth.fromJson(Map<String, dynamic> json) {
    return SuccessAuth(token: json["token"]);
  }
}
