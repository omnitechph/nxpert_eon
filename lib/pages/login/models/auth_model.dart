enum AuthStatus { initial, loading, success, failure }

class AuthModel {
  final AuthStatus status;
  final String? token;
  final String? error;
  final String? userId;
  final String? user;

  const AuthModel({this.status = AuthStatus.initial, this.token, this.error, this.userId, this.user});

  AuthModel copyWith({AuthStatus? status, String? token, String? error, final String? userId, final String? user}) {
    return AuthModel(status: status ?? this.status, token: token ?? this.token, error: error ?? this.error, userId: userId ?? this.userId, user: user ?? this.user);
  }
}
