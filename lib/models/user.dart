class User {
  String id;
  String? email;
  String? name;
  String phone;
  String? latitude;
  String? longitude;
  String? address;
  String? pincode;
  String? city;
  String? state;
  String? country;
  String? notificationToken;
  bool isVerified;

  User({
    required this.id,
    this.email,
    this.name,
    required this.phone,
    this.latitude,
    this.longitude,
    this.address,
    this.pincode,
    this.city,
    this.state,
    this.country,
    this.notificationToken,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      notificationToken: json['notification_token'],
      isVerified: json['is_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'pincode': pincode,
      'city': city,
      'state': state,
      'country': country,
      'notification_token': notificationToken,
      'is_verified': isVerified,
    };
  }

  // Added copyWith method
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? latitude,
    String? longitude,
    String? address,
    String? pincode,
    String? city,
    String? state,
    String? country,
    String? notificationToken,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      notificationToken: notificationToken ?? this.notificationToken,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
