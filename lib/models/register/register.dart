class RegisterModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;
  String confirmPassword;
  String gender;
  String countryCode;

  RegisterModel({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.gender = 'Male',
    this.countryCode = '+1',
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': countryCode + phone,
    'password': password,
    'gender': gender,
  };
}