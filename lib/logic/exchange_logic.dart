import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:exchange/api.dart';
import 'package:exchange/models/exchange_model.dart';

class ConversionLogic {
  Exchangerate? exchangerate;
  double newConversionConst = 1;
  String currentCurrency = 'USD';
  int numberOfDecimals = 2;

  StreamController<Exchangerate> currencyStreamController =
      StreamController<Exchangerate>.broadcast();

  Future<Exchangerate?> getExchangeRates(String currency) async {
    try {
      String res = await Api().getExchangeRates(currency);
      exchangerate = Exchangerate.fromJson(json.decode(res));
      if (exchangerate != null) {
        findConversionRateWithHighestDecimals(exchangerate!);

        currencyStreamController.sink.add(exchangerate!);
        return exchangerate;
      } else {
        throw Exception('Failed to parse exchange rates');
      }
    } catch (e) {
      currencyStreamController.sink.addError(e.toString());
    }
    return null;
  }

  convertBasedOnCurrency(String currency) {
    if (exchangerate != null) {
      // update the conversion rates based on the new currency
      newConversionConst = exchangerate!.conversionRates![currentCurrency]! /
          exchangerate!.conversionRates![currency]!;

      exchangerate!.conversionRates!
          .updateAll((key, value) => (value * newConversionConst));
      currentCurrency = currency;

      // send data to UI
      currencyStreamController.sink.add(exchangerate!);
    }
  }

//find precision
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
          numberOfDecimals = decimalCount;
        }
      });
    }

    return highestDecimal;
  }
}
