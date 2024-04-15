import 'package:exchange/language/language.dart';

class LanguageEn extends Languages {
  @override
  String get currentExchange => "Current Exchange Rates";

  @override
  String get currencySelected => "Currency selected:";

  @override
  String get errorLoadingExchangeRates => "Error loading exchange rates";

  @override
  String get apiError => "Failed to load exchange rates ";
}
