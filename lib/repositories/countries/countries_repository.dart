import 'package:dartz/dartz.dart';
import 'package:snapid/models/countries/countries.dart';
import 'package:snapid/network/network_repository.dart';

class CountriesRepository {
  final networkRepository = NetworkRepository();

  Future<Either<String, CountriesResponse>> getCountries({
    int page = 1,
    int pageSize = 10,
    String searchQuery = ""
  }) async {
    final response = await networkRepository.get(
      url: "/country/get-all-countries-data",
      extraQuery: {
        "page": page,
        "pageSize": pageSize,
        "searchQuery": searchQuery,
      },
    );

    if (!response.failed) {
    
      final Map<String, dynamic> data = response.data['data'];
      CountriesResponse countriesResponse = CountriesResponse.fromJson(data);
      return right(countriesResponse);
    }

    return left(response.message);
  }
}
