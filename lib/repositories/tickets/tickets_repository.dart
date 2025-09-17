import 'package:dartz/dartz.dart';
import 'package:snapid/models/tickets/tickets_model.dart';
import 'package:snapid/network/network_repository.dart';

class TicketsRepository {
  final NetworkRepository networkRepository = NetworkRepository();

  Future<Either<String, List<Ticket>>> fetchTickets() async {
    try {
      final response = await networkRepository.get(url: "/ticket/get-all-tickets");
      
      if (response.success) {
        final List<dynamic> data = response.data['data'];

        List<Ticket> tickets =
            data.map((item) => Ticket.fromJson(item)).toList();

        return Right(tickets);
      }

      return Left(response.message);
    } on Exception catch (e) {
      return Left(e.toString()); 
    }
  }
}
