import 'package:http/http.dart' as http;

class BudgetRepository {
  final http.Client _client;
  //takes a http client and create a client by default if no client is passed in
  BudgetRepository({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }
}
