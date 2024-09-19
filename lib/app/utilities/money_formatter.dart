import 'package:currency_formatter/currency_formatter.dart';

class MoneyUtils {
  static String getFormattedCurrency(double amount) {
    const CurrencyFormat euroSettings = CurrencyFormat(
      code: 'eur',
      symbol: '€',
      symbolSide: SymbolSide.right,
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolSeparator: ' ',
    );
    return CurrencyFormatter.format(amount, euroSettings,
        decimal: 2, enforceDecimals: true); // 1.910,93 €
  }
}
