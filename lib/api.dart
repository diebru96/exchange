import 'package:exchange/consts/consts.dart';
import 'package:http/http.dart';

class Api {
  Future<String> getExchangeRates(String currency) async {
    try {
      Response response = await get(
        Uri.parse("$exchange_endpoint/$key_exchange/latest/$currency"),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load exchange rates ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
