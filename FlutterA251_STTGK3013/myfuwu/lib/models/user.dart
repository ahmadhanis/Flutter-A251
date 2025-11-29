class User {
  String? userId;
  String? userEmail;
  String? userName;
  String? userPhone;
  String? userPassword;
  String? userOtp;
  String? userRegdate;

  String? userAddress; // NEW
  String? userLatitude; // Existing new
  String? userLongitude; // Existing new

  User({
    this.userId,
    this.userEmail,
    this.userName,
    this.userPhone,
    this.userPassword,
    this.userOtp,
    this.userRegdate,
    this.userAddress,
    this.userLatitude,
    this.userLongitude,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userPassword = json['user_password'];
    userOtp = json['user_otp'];
    userRegdate = json['user_regdate'];

    userAddress = json['user_address']; // NEW
    userLatitude = json['user_latitude']; // NEW
    userLongitude = json['user_longitude']; // NEW
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['user_password'] = userPassword;
    data['user_otp'] = userOtp;
    data['user_regdate'] = userRegdate;

    data['user_address'] = userAddress; // NEW
    data['user_latitude'] = userLatitude; // NEW
    data['user_longitude'] = userLongitude; // NEW

    return data;
  }
}
