import 'dart:async';
import 'dart:convert';

import 'package:exchange/api.dart';
import 'package:exchange/models/exchange_model.dart';

class ConversionLogic {
  Exchangerate? exchangerate;
  double newConversionConst = 1;
  String currentCurrency = 'USD';

  StreamController<Exchangerate> currencyStreamController =
      StreamController<Exchangerate>.broadcast();

  Future<Exchangerate?> getExchangeRates(String currency) async {
    String res = await Api().getExchangeRates(currency);
    exchangerate = Exchangerate.fromJson(json.decode(res));
    currencyStreamController.sink.add(exchangerate!);
    return exchangerate;
  }

  convertBasedOnCurrency(String currency) {
    if (exchangerate != null) {
      newConversionConst = exchangerate!.conversionRates![currentCurrency]! /
          exchangerate!.conversionRates![currency]!;
      exchangerate!.conversionRates!
          .updateAll((key, value) => value * newConversionConst);
      currentCurrency = currency;
      currencyStreamController.sink.add(exchangerate!);
    }
  }
}
