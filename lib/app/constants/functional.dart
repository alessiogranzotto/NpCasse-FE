import 'package:flutter/material.dart';

const List<String> idGiveListNameAll = [
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
  'FonteSh'
];

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
  'CodiceCentroRicavo'
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
  'IdPagamentoAssegno'
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
  'FonteSh',
  'Ringraziato'
];

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
          return Colors.blue[100]!;
        case 'IdPagamentoAssegno':
          return Colors.indigo[100]!;
        case 'FonteSh':
          return Colors.purple[100]!;
        case 'CodiceSottoconto':
          return Colors.amber[100]!;
        case 'CodiceCentroRicavo':
          return Colors.deepOrange[100]!;

        default:
          return Colors.transparent;
      }
    } catch (e) {
      return Colors.transparent;
    }
  }
}
