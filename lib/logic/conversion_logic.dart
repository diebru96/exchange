import 'dart:async';
import 'dart:convert';

import 'package:exchange/api.dart';
import 'package:exchange/models/exchange_model.dart';

class ConversionLogic {
  Exchangerate? exchangerate;
  double newConversionConst = 1;
  String currentCurrency = 'USD';
  int number_of_decimals = 2;

  StreamController<Exchangerate> currencyStreamController =
      StreamController<Exchangerate>.broadcast();

  Future<Exchangerate?> getExchangeRates(String currency) async {
    String res = await Api().getExchangeRates(currency);
    exchangerate = Exchangerate.fromJson(json.decode(res));
    currencyStreamController.sink.add(exchangerate!);
    double findConversionRateWithHighestDecimals(Exchangerate exchangerate) {
      double highestDecimal = 0;

      if (exchangerate.conversionRates != null) {
        exchangerate.conversionRates!.forEach((key, value) {
          String valueString = value.toString();
          int decimalCount = 0;
          if (valueString.contains('.')) {
            decimalCount = valueString.length - valueString.indexOf('.') - 1;
          }
          if (decimalCount > highestDecimal) {
            number_of_decimals = decimalCount;
          }
        });
      }

      return highestDecimal;
    }

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
