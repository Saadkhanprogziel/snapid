class CountryResponse {
  final Map<String, Country> formatted;
  final Pagination pagination;

  CountryResponse({
    required this.formatted,
    required this.pagination,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
  final formattedMap = (json['countries'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, Country.fromJson(value)))
    ?? {};

    return CountryResponse(
      formatted: formattedMap,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
        'countries': formatted.map((key, value) => MapEntry(key, value.toJson())),
        'pagination': pagination.toJson(),
      };
}

class Country {
  final String countryName;
  final String countryCode;
  final String countryFlag;
  final String passport;
  final String visa;
  final String drivingLicense;
  final CountryColor color;

  Country({
    required this.countryName,
    required this.countryCode,
    required this.countryFlag,
    required this.passport,
    required this.visa,
    required this.drivingLicense,
    required this.color,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryName: json['country_name'],
        countryCode: json['country_code'],
        countryFlag: json['country_flag'],
        passport: json['passport'],
        visa: json['visa'],
        drivingLicense: json['driving_license'],
        color: CountryColor.fromJson(json['color']),
      );

  Map<String, dynamic> toJson() => {
        'country_name': countryName,
        'country_code': countryCode, // ✅ fixed key
        'country_flag': countryFlag,
        'passport': passport,
        'visa': visa,
        'driving_license': drivingLicense,
        'color': color.toJson(),
      };
}

class CountryColor {
  final ColorScheme passport;
  final ColorScheme visa;
  final ColorScheme drivingLicense;

  CountryColor({
    required this.passport,
    required this.visa,
    required this.drivingLicense,
  });

  factory CountryColor.fromJson(Map<String, dynamic> json) => CountryColor(
        passport: ColorScheme.fromJson(json['passport']),
        visa: ColorScheme.fromJson(json['visa']),
        drivingLicense: ColorScheme.fromJson(json['driving_license']),
      );

  Map<String, dynamic> toJson() => {
        'passport': passport.toJson(),
        'visa': visa.toJson(),
        'driving_license': drivingLicense.toJson(),
      };
}

class ColorScheme {
  final String whiteDefault;
  final String blue;

  ColorScheme({
    required this.whiteDefault,
    required this.blue,
  });

  factory ColorScheme.fromJson(Map<String, dynamic> json) => ColorScheme(
        whiteDefault: json['white-default'],
        blue: json['blue'],
      );

  Map<String, dynamic> toJson() => {
        'white-default': whiteDefault,
        'blue': blue,
      };
}

class Pagination {
  final int totalCountries;
  final int currentPage;
  final int totalPages;

  Pagination({
    required this.totalCountries,
    required this.currentPage,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCountries: json['totalCountries'],
        currentPage: json['currentPage'],
        totalPages: json['totalPages'],
      );

  Map<String, dynamic> toJson() => {
        'totalCountries': totalCountries,
        'currentPage': currentPage,
        'totalPages': totalPages,
      };
}

