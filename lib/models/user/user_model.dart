class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profilePicture;
  final String? phoneNo;
  final String? country;
  final String? gender;
  final int? credits;
  final String? isActive;
  final String? stripeCustomerId;
  final String? defaultPaymentMethodId;
  final String? role;
  final String? platform; // still keeping this in case it's needed
  final String? authProvider;
  final List<dynamic>? photoSessions;
  final List<dynamic>? transactions;
  final List<dynamic>? cards;
  final UserAuthentication? userAuthentication;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.profilePicture,
    this.phoneNo,
    this.country,
    this.gender,
    this.credits,
    this.isActive,
    this.stripeCustomerId,
    this.defaultPaymentMethodId,
    this.role,
    this.platform,
    this.authProvider,
    this.photoSessions,
    this.transactions,
    this.cards,
    this.userAuthentication,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
      phoneNo: json['phoneNo'] as String?,
      country: json['country'] as String?,
      gender: json['gender'] as String?,
      credits: json['credits'] as int?,
      isActive: json['isActive'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      defaultPaymentMethodId: json['defaultPaymentMethodId'] as String?,
      role: json['role'] as String?,
      platform: json['platform'] as String?,
      authProvider: json['authProvider'] as String?,
      photoSessions: json['photoSessions'] != null
          ? List<dynamic>.from(json['photoSessions'])
          : [],
      transactions: json['transactions'] != null
          ? List<dynamic>.from(json['transactions'])
          : [],
      cards: json['cards'] != null ? List<dynamic>.from(json['cards']) : [],
      userAuthentication: json['userAuthentication'] != null
          ? UserAuthentication.fromJson(json['userAuthentication'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "profilePicture": profilePicture,
      "phoneNo": phoneNo,
      "country": country,
      "gender": gender,
      "credits": credits,
      "isActive": isActive,
      "stripeCustomerId": stripeCustomerId,
      "defaultPaymentMethodId": defaultPaymentMethodId,
      "role": role,
      "platform": platform,
      "authProvider": authProvider,
      "photoSessions": photoSessions ?? [],
      "transactions": transactions ?? [],
      "cards": cards ?? [],
      "userAuthentication": userAuthentication?.toJson(),
    };
  }
}

class UserAuthentication {
  final String? id;
  final String? isEmailVerified;

  UserAuthentication({
    this.id,
    this.isEmailVerified,
  });

  factory UserAuthentication.fromJson(Map<String, dynamic> json) {
    return UserAuthentication(
      id: json['id'] as String?,
      isEmailVerified: json['isEmailVerified'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "isEmailVerified": isEmailVerified,
    };
  }
}
