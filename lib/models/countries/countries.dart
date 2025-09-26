class CountriesResponse {
  final List<Country> countries;
  final Pagination pagination;

  CountriesResponse({
    required this.countries,
    required this.pagination,
  });

  factory CountriesResponse.fromJson(Map<String, dynamic> json) {
    return CountriesResponse(
      countries: (json['countries'] as List)
          .map((e) => Country.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countries': countries.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Country {
  final int id;
  final String code;
  final String name;
  final String flag;
  final String passportSize;
  final String visaSize;
  final String drivingLicense;
  final DateTime createdAt;
  final DateTime updatedAt;

  Country({
    required this.id,
    required this.code,
    required this.name,
    required this.flag,
    required this.passportSize,
    required this.visaSize,
    required this.drivingLicense,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      flag: json['flag'],
      passportSize: json['passportSize'],
      visaSize: json['visaSize'],
      drivingLicense: json['drivingLicense'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'flag': flag,
      'passportSize': passportSize,
      'visaSize': visaSize,
      'drivingLicense': drivingLicense,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
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

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalCountries: json['totalCountries'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCountries': totalCountries,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}
