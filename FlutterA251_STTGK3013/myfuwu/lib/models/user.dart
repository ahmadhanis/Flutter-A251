class User {
  String? userId;
  String? userEmail;
  String? userPassword;
  String? userOtp;
  String? userRegdate;

  User(
      {this.userId,
      this.userEmail,
      this.userPassword,
      this.userOtp,
      this.userRegdate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userOtp = json['user_otp'];
    userRegdate = json['user_regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_password'] = userPassword;
    data['user_otp'] = userOtp;
    data['user_regdate'] = userRegdate;
    return data;
  }
}
