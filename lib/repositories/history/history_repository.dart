import 'package:dartz/dartz.dart';
import 'package:snapid/models/photo_creation/photo_creation_model.dart';
import 'package:snapid/network/network_repository.dart';

class HistoryRepository {
  final NetworkRepository networkRepository = NetworkRepository();

  Future<Either<String, List<PhotoCreationModel>>> fetchHistory({
    int page = 1,
    int pageSize = 10,
    String status = "ALL",
  }) async {
    try {
      final response = await networkRepository.get(
        url:
            '/session/get-all-photos-sessions?page=$page&pageSize=$pageSize&status=$status',
      );

      if (response.success) {
        final List<dynamic> sessions = response.data['data']['sessions'];

        List<PhotoCreationModel> history =
            sessions.map((item) => PhotoCreationModel.fromJson(item)).toList();

        return Right(history);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  Future<Either<String, bool>> deleteSession(id) async {
    try {
      final response = await networkRepository.delete(
          url: "/session/delete-photo-session", data: {"sessionID": id});

      if (response.success) {
        return right(true);
      } else {
        return Left(response.message);
      }
    } on Exception catch (e) {
      return Left('An error occurred: $e');
    }
  }
}
