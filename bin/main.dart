import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_topsis/topsis.dart';
import 'package:tabular/tabular.dart';

void main(List<String> arguments) async {
  final parser = ArgParser();
  parser.addOption('entrada',
      abbr: 'i', help: 'Arquivo no formato CSV a ser processado');
  parser.addFlag('normalizar', abbr: 'n', help: 'Exibir a tabela normalizada');
  parser.addFlag('ordenar', abbr: 'o', help: 'Ordenar resultado');
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Ajuda');
  try {
    final result = parser.parse(arguments);
    if (result['help']) {
      print('Aplicativo de linha de comando TOPSIS.\n');
      print('Opções de comando:\n');
      print(parser.usage);
      exit(0);
    }
    if (result['entrada'] == null) {
      print('Informe um arquivo de entrada.');
      exit(2);
    }
    final path = result['entrada'];
    if (await FileSystemEntity.isFile(path)) {
      final topsis = Topsis(path);
      if (result['normalizar']) {
        print(tabular(
          topsis.normalizedTable,
          style: Style.mysql,
          border: Border.all,
        ));
      }
      print(tabular(
        result['ordenar'] ? topsis.resultTableOrder : topsis.resultTable,
        style: Style.mysql,
        border: Border.all,
      ));
    } else {
      print('Error: $path não é um arquivo.');
      exit(2);
    }
  } on FormatException catch (e) {
    print('Erro: ${e.message}');
  }
}
