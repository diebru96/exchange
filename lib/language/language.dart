import 'package:exchange/language/en.dart';

abstract class Languages {
  static Languages of() {
    return LanguageEn();
  }

  String get currentExchange;
  String get currencySelected;
  String get errorLoadingExchangeRates;
  String get apiError;
}
