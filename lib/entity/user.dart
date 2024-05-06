class User {
  final String email;
  final String password;

  const User({
    required this.email,
    required this.password,
  });

  User.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        password = map['password'];

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  static const empty = User(email: '', password: '');

  bool get isEmpty => this == User.empty;
}
