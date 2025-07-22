class Customer {
  final String id;
  final String type;
  final CustomerAttributes attributes;

  Customer({
    required this.id,
    required this.type,
    required this.attributes,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      type: json['type'],
      attributes: CustomerAttributes.fromJson(json),
    );
  }
}

class CustomerAttributes {
  final String? name;
  final String? username;
  final int? userId;
  final String? email;
  final String? phone;
  final bool? isOnline;
  final String? profilePhotoUrl;
  final String? lastMessage;

  CustomerAttributes({
    this.name,
    this.username,
    this.userId,
    this.email,
    this.phone,
    this.isOnline,
    this.profilePhotoUrl,
    this.lastMessage,
  });

  factory CustomerAttributes.fromJson(Map<String, dynamic> json) {
    return CustomerAttributes(
      name: json['name'],
      username: json['username'],
      userId: json['auth_user_id'],
      email: json['email'],
      phone: json['phone'],
      isOnline: json['is_online'],
      profilePhotoUrl: json['profile_photo_url'],
      lastMessage: json['message_received_from_partner_at'],
    );
  }
}
