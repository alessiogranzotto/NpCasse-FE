import 'package:flutter/material.dart';

const List<String> idGiveListNameProduct = [
  'IdFinalizzazione',
  'IdEvento',
  'IdAttività',
  'IdAgenda',
  'IdComunicazioni',
  'IdTipDonazione',
  'IdCatalogo',
  'IdPromotore',
  'CodiceSottoconto',
  'CodiceCentroRicavo',
  'FonteSh',
  'Ringraziato'
];

const List<String> idGiveListNameCategory = [
  'IdFinalizzazione',
  'IdEvento',
  'IdAttività',
  'IdAgenda',
  'IdComunicazioni',
  'IdTipDonazione',
  'IdCatalogo',
  'IdPromotore',
  'CodiceSottoconto',
  'CodiceCentroRicavo',
  'IdPagamentoContante',
  'IdPagamentoBancomat',
  'IdPagamentoCartaDiCredito',
  'IdPagamentoAssegno',
  'IdPagamentoPaypal',
  'IdPagamentoEsterno',
  'IdPagamentoSdd',
  'IdPagamentoBonificoPromessa',
  'IdPagamentoBonificoIstantaneo',
  'IdPagamentoBonificoLink',
  'FonteSh',
  'Ringraziato'
];

const List<String> idGiveListNameMyosotis = [
  'IdFinalizzazione',
  'IdEvento',
  'IdAttività',
  'IdAgenda',
  'IdComunicazioni',
  'IdTipDonazione',
  'IdCatalogo',
  'IdPromotore',
  'IdPagamentoContante',
  'IdPagamentoBancomat',
  'IdPagamentoCartaDiCredito',
  'IdPagamentoAssegno',
  'IdPagamentoPaypal',
  'IdPagamentoEsterno',
  'IdPagamentoSdd',
  'IdPagamentoBonificoPromessa',
  'IdPagamentoBonificoIstantaneo',
  'IdPagamentoBonificoLink',
  'FonteSh',
  'Ringraziato'
];

const List<String> idGivePaymentType = [
  'IdPagamentoContante',
  'IdPagamentoBancomat',
  'IdPagamentoCartaDiCredito',
  'IdPagamentoAssegno',
  'IdPagamentoPaypal',
  'IdPagamentoEsterno',
  'IdPagamentoSdd',
  'IdPagamentoBonificoPromessa',
  'IdPagamentoBonificoIstantaneo',
  'IdPagamentoBonificoLink',
];

enum PaymentType {
  Nessuno,
  Contanti,
  Bancomat,
  CartaCredito,
  Assegni,
  Paypal,
  PagamentoEsterno,
  Sdd,
  BonificoPromessa,
  BonificoIstantaneo,
  BonificoLink
}

PaymentType? mapDbValueToPaymentType(String dbValue) {
  switch (dbValue) {
    case "IdPagamentoContante":
      return PaymentType.Contanti;
    case "IdPagamentoBancomat":
      return PaymentType.Bancomat;
    case "IdPagamentoCartaDiCredito":
      return PaymentType.CartaCredito;
    case "IdPagamentoAssegno":
      return PaymentType.Assegni;
    case "IdPagamentoPaypal":
      return PaymentType.Paypal;
    case "IdPagamentoEsterno":
      return PaymentType.PagamentoEsterno;
    case "IdPagamentoSdd":
      return PaymentType.Sdd;
    case "IdPagamentoBonificoPromessa":
      return PaymentType.BonificoPromessa;
    case "IdPagamentoBonificoIstantaneo":
      return PaymentType.BonificoIstantaneo;
    case "IdPagamentoBonificoLink":
      return PaymentType.BonificoLink;
    default:
      return null; // valore non gestito
  }
}

final Map<String, Map<String, dynamic>> paymentTypeInfo = {
  'IdPagamentoContante': {
    'icon': Icons.euro,
    'tooltip': 'Pagamento in contanti',
  },
  'IdPagamentoBancomat': {
    'icon': Icons.card_giftcard,
    'tooltip': 'Pagamento con Bancomat',
  },
  'IdPagamentoCartaDiCredito': {
    'icon': Icons.credit_card,
    'tooltip': 'Pagamento con carta di credito',
  },
  'IdPagamentoAssegno': {
    'icon': Icons.fact_check,
    'tooltip': 'Pagamento con assegno',
  },
  'IdPagamentoPaypal': {
    'icon': Icons.account_balance_wallet,
    'tooltip': 'Pagamento con PayPal',
  },
  'IdPagamentoEsterno': {
    'icon': Icons.cloud,
    'tooltip': 'Pagamento esterno',
  },
  'IdPagamentoSdd': {
    'icon': Icons.autorenew,
    'tooltip': 'Pagamento SDD',
  },
  'IdPagamentoBonificoPromessa': {
    'icon': Icons.send,
    'tooltip': 'Bonifico promessa',
  },
  'IdPagamentoBonificoIstantaneo': {
    'icon': Icons.flash_on,
    'tooltip': 'Bonifico istantaneo',
  },
  'IdPagamentoBonificoLink': {
    'icon': Icons.link,
    'tooltip': 'Bonifico tramite link',
  },
};

String? mapPaymentTypeToDbValue(PaymentType type) {
  switch (type) {
    case PaymentType.Nessuno:
      return "";
    case PaymentType.Contanti:
      return "IdPagamentoContante";
    case PaymentType.Bancomat:
      return "IdPagamentoBancomat";
    case PaymentType.CartaCredito:
      return "IdPagamentoCartaDiCredito";
    case PaymentType.Assegni:
      return "IdPagamentoAssegno";
    case PaymentType.Paypal:
      return "IdPagamentoPaypal";
    case PaymentType.PagamentoEsterno:
      return "IdPagamentoEsterno";
    case PaymentType.Sdd:
      return "IdPagamentoSdd";
    case PaymentType.BonificoPromessa:
      return "IdPagamentoBonificoPromessa";
    case PaymentType.BonificoIstantaneo:
      return "IdPagamentoBonificoIstantaneo";
    case PaymentType.BonificoLink:
      return "IdPagamentoBonificoLink";
  }
}

class FunctionalColorUtils {
  static Color getColorForTag(String tag) {
    try {
      String idType = tag.split("=").first;
      switch (idType) {
        case 'IdFinalizzazione':
          return Colors.blue[100]!;
        case 'IdEvento':
          return Colors.red[100]!;
        case 'IdAttività':
          return Colors.orange[100]!;
        case 'IdAgenda':
          return Colors.blueGrey[100]!;
        case 'IdComunicazioni':
          return Colors.yellow[100]!;
        case 'IdTipDonazione':
          return Colors.deepPurple[100]!;
        case 'IdCatalogo':
          return Colors.green[100]!;
        case 'IdPromotore':
          return Colors.lime[100]!;
        case 'IdPagamentoContante':
          return Colors.teal[100]!;
        case 'IdPagamentoBancomat':
          return Colors.cyan[100]!;
        case 'IdPagamentoCartaDiCredito':
          return Colors.brown[100]!;
        case 'IdPagamentoAssegno':
          return Colors.indigo[100]!;
        case 'IdPagamentoPaypal':
          return Colors.deepOrange[100]!;
        case 'IdPagamentoEsterno':
          return Colors.lightBlue[100]!;
        case 'IdPagamentoSdd':
          return Colors.red[200]!;
        case 'IdPagamentoBonificoPromessa':
          return Colors.green[200]!;
        case 'IdPagamentoBonificoIstantaneo':
          return Colors.yellow[200]!;
        case 'IdPagamentoBonificoLink':
          return Colors.tealAccent[100]!;
        case 'FonteSh':
          return Colors.purple[100]!;
        case 'Ringraziato':
          return Colors.purpleAccent[100]!;
        case 'CodiceSottoconto':
          return Colors.orangeAccent[100]!;
        case 'CodiceCentroRicavo':
          return Colors.tealAccent[100]!;

        default:
          return Colors.transparent;
      }
    } catch (e) {
      return Colors.transparent;
    }
  }
}
