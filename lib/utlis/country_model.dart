class Country {
  String name;
  String code;
  String flag;
  String currencySign;
  String dialCode;        // New: telephone dialing prefix

  Country({required this.name, required this.code, required this.flag, required this.currencySign,required this.dialCode});
}