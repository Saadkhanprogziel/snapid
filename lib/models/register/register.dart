class RegisterModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;
  String confirmPassword;
  String gender;
  String countryCode;
  String country;

  RegisterModel({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.gender = 'Male',
    this.countryCode = '+1',
    this.country = '',
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'emailAddress': email,
    'password': password,
    'confirmPassword': confirmPassword,
    'countryCode': countryCode,
    'phoneNo': countryCode+phone,
    'country': country,
    'gender': gender,
    "platform": "MOBILE_APP"
  };
}
