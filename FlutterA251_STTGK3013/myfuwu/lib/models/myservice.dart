class MyService {
  String? serviceId;
  String? userId;
  String? serviceTitle;
  String? serviceDesc;
  String? serviceDistrict;
  String? serviceType;
  String? serviceRate;
  String? serviceDate;

  // Added user info
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userRegdate;

  MyService({
    this.serviceId,
    this.userId,
    this.serviceTitle,
    this.serviceDesc,
    this.serviceDistrict,
    this.serviceType,
    this.serviceRate,
    this.serviceDate,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userRegdate,
  });

  MyService.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    userId = json['user_id'];
    serviceTitle = json['service_title'];
    serviceDesc = json['service_desc'];
    serviceDistrict = json['service_district'];
    serviceType = json['service_type'];
    serviceRate = json['service_rate'];
    serviceDate = json['service_date'];

    // Mapping user fields
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    userRegdate = json['user_regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['user_id'] = userId;
    data['service_title'] = serviceTitle;
    data['service_desc'] = serviceDesc;
    data['service_district'] = serviceDistrict;
    data['service_type'] = serviceType;
    data['service_rate'] = serviceRate;
    data['service_date'] = serviceDate;

    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    data['user_regdate'] = userRegdate;

    return data;
  }
}
