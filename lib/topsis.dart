import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';

class Topsis {
  late final _Row<String> _headers; // Linha de cabeçalhos
  late final _Row<String> _impacts; // Linha com os impactos
  late final _Row<num> _weights; // Linha com os pesos
  // Tabela com os valores originais
  late final _originalValues = <_Row<num>>[];
  // Tabela com os valores normalizados
  late final _normalizedValues = <_Row<num>>[];
  // Tabela com os valores processados
  late final _resultValues = <_Row<num>>[];
  late _Row<num> _vMax;
  late _Row<num> _vMin;

  // Contrutor da classe
  Topsis(String path) {
    final file = File(path);
    // Verifica se existe um arquivo no caminho "path"
    if (!file.existsSync()) {
      throw FileSystemException(
        'Arquivo não existe!',
        file.absolute.path,
      );
    }
    // Lê o arquivo csv
    final csv = file.readAsStringSync();
    // Monta a tabela para ser processada
    _mountTable(CsvToListConverter().convert(csv));
    // Executa o processamento dos dados
    _process();
  }

  void _mountTable(List<List<dynamic>> table) {
    // Cria uma linha com valores textuais do cabeçalho
    _headers = _Row<String>(table[0]);
    // Cria uma linha com valores textuais dos impactos
    _impacts = _Row<String>(table[1]);
    // Cria uma linha com valores numéricos dos pesos
    _weights = _Row<num>(table[2]);
    // Carrega as linhas com as alternativas a serem processadas
    for (final element in table.skip(3)) {
      _originalValues.add(_Row<num>(element));
    }
  }

  /// Retorna a tabela original
  List<List<Object>> get table {
    return [
      [_headers.name, ..._headers.values],
      [_impacts.name, ..._impacts.values],
      [_weights.name, ..._weights.values],
      for (var item in _originalValues) [item.name, ...item.values],
    ];
  }

  /// Retorna a tabela normalizada
  List<List<Object>> get normalizedTable {
    return [
      [_headers.name, ..._headers.values],
      [_impacts.name, ..._impacts.values],
      [_weights.name, ..._weights.values],
      for (var item in _normalizedValues)
        [item.name, ...item.values.map((e) => e.toStringAsFixed(6))],
    ];
  }

  /// Retorna a tabela processada
  List<List<Object>> get resultTable {
    final count = _resultValues.length;
    return [
      [
        _headers.name,
        ..._headers.values,
        '[+]Distance',
        '[-]Distance',
        'Score',
        'Ranking'
      ],
      for (var i = 0; i < count; i++)
        [_resultValues[i].name, ..._resultValues[i].values]
    ];
  }

  /// Retorna a tabela processada e ordenada
  List<List<Object>> get resultTableOrder {
    final count = _resultValues.length;
    _resultValues.sort(((a, b) => a.values.last.compareTo(b.values.last)));
    return [
      [
        _headers.name,
        ..._headers.values,
        '[+]Distance',
        '[-]Distance',
        'Score',
        'Ranking'
      ],
      for (var i = 0; i < count; i++)
        [_resultValues[i].name, ..._resultValues[i].values]
    ];
  }

  void _process() {
    // Count recebe a quantidade de colunas (critérios)
    var count = _headers.values.length;
    // Cria uma tabela temporária
    final tempTable = <_Row<num>>[];
    // Linha que armazena os valores máximos
    _vMax = _Row<num>(['V+']);
    // Linha que armazena os valores mínimos
    _vMin = _Row<num>(['V-']);
    // Itera sobre a tabela original contendo os critérios
    for (var column = 0; column < count; column++) {
      // Extrai a coluna da tabela
      final tempColumn = _extractColumn(_originalValues, column);
      // Normaliza os valores da coluna
      final normalizedColumn = _normalizer(tempColumn, _weights.values[column]);
      // Verifica se a coluna tem impacto positivo
      final posImpact = _impacts.values[column].toLowerCase() == 'max';
      // Extrai o valor máximo da coluna normaizada de acordo com o seu impacto,
      // e adiciona a linha de valores máximos
      _vMax.values.add(normalizedColumn.values.reduce(posImpact ? max : min));
      // Extrai o valor mínimo da coluna normaizada de acordo com o seu impacto,
      // e adiciona a linha de valores mínimos
      _vMin.values.add(normalizedColumn.values.reduce(posImpact ? min : max));
      // Adiciona a coluna a tabela temporária
      tempTable.add(normalizedColumn);
    }
    // Count agora recebe a quantidade de itens da primeria
    // linha da tabela temporária
    count = tempTable.first.values.length;
    // Itera sobre a tabela temporária
    for (var row = 0; row < count; row++) {
      // Converte as colunas da tabela temporária em linhas,
      // e adiciona as linhas na tabela normalizada
      _normalizedValues.add(_extractRow(tempTable, row));
    }
    // Count agora recebe a quantidade de linhas da tabela normalizada
    count = _normalizedValues.length;
    // Itera sobre a tabela normalizada
    for (var row = 0; row < count; row++) {
      // Calcula a distância euclidiana máxima, mínima e a similaridade
      final temp = _euclideanDistance(_normalizedValues[row]);
      // Adiciona o resultado na tabela de valores processados
      // Obs: Mantém os dados originais e adiciona mais três colunas
      // [+]Distance | [-]Distance | Score
      _resultValues.add(_Row<num>([
        _originalValues[row].name,
        ..._originalValues[row].values,
        ...temp.values
            .skip(_originalValues[row].values.length)
            .map((value) => double.parse(value.toStringAsFixed(6)))
      ]));
    }
    // Adiciona a coluna de ranking a tabela de resultados
    _ranking(_resultValues);
  }

  /// Normaliza uma coluna (critério) de acordo com o peso
  _Row<num> _normalizer(_Row<num> column, num weight) {
    // Armazena a raiz quadrada da somatória
    final soma = sqrt(
      // Faz a somatória de cada valor elevado ao quadrado
      column.values.fold<double>(0, (value, item) => value + pow(item, 2)),
    );
    // Normaliza cada valor, dividindo pelo resultado da "soma" e multiplicando
    // pelo seu peso
    final temp = column.values.map((item) => (item / soma) * weight).toList();
    // Retorna a coluna com os seus valores normalizados
    return _Row<num>([column.name, ...temp]);
  }

  /// Estrai uma coluna da tabela e retorna uma linha com valores numéricos
  _Row<num> _extractColumn(List<_Row<num>> values, int column) {
    final temp =
        values.map<double>((row) => row.values[column].toDouble()).toList();
    // Retorna uma linha de valores numéricos com o nome da coluna correspondente
    return _Row<num>([_headers.values[column], ...temp]);
  }

  /// Estrai uma coluna da tabela e retorna uma linha com valores numéricos
  _Row<num> _extractRow(List<_Row<num>> values, int column) {
    final temp =
        values.map<double>((row) => row.values[column].toDouble()).toList();
    // Retorna uma linha de valores numéricos com o nome da linha original correspondente
    return _Row<num>([_originalValues[column].name, ...temp]);
  }

  /// Calcula a distância euclidiana máxima e mínima de uma linha
  _Row<num> _euclideanDistance(_Row<num> row) {
    double siMax = 0; // Valor da melhor distância
    double siMin = 0; // Valor da pior distância
    final count = row.values.length; // Número de elementos da linha
    // Itera sobre os elementos da linha
    for (var i = 0; i < count; i++) {
      // Soma o resultado da diferênça elevado ao quadrado
      // Diferença entre o valor ideal positivo e o valor normalizado
      siMax += pow(_vMax.values[i] - row.values[i], 2);
      // Soma o resultado da diferênça elevado ao quadrado
      // Diferença entre o valor ideal negativo e o valor normalizado
      siMin += pow(_vMin.values[i] - row.values[i], 2);
    }
    // Extrai a raiz quadrada do resultado da soma da melhor distância
    siMax = sqrt(siMax);
    // Extrai a raiz quadrada do resultado da soma da pior distância
    siMin = sqrt(siMin);
    // Cria uma nova linha com os valores
    final res = _Row<num>([row.name, ...row.values]);
    res.values.add(siMax); // Adiciona o valor da melhor distância
    res.values.add(siMin); // Adiciona o valor da pior distância
    // Adiciona o valor calculado da proximidade relativa (Score)
    res.values.add(siMin / (siMax + siMin));
    // Retorna a nova linha com os valores calculados
    return res;
  }

  /// Gera a coluna de ranking de acordo com o resultado do score
  void _ranking(List<_Row<num>> result) {
    final temp = [...result]; // Gera uma cópia do resultado
    // Ordena a cópia dos resultados de acordo com a última coluna (score)
    temp.sort((a, b) => b.values.last.compareTo(a.values.last));
    // Adiciona a coluna de ranking na tabela de resultados
    // Obs: A tabela de resultados mantém a ordem original
    for (final item in result) {
      item.values.add(temp.indexOf(item) + 1);
    }
  }
}

/// Classe que repesenta uma linha com valores genéricos
class _Row<T> {
  final String name; // Nome da linha (Cabeçalho)
  final List<T> values; // Valores da linha
  // Contrutor
  _Row(List item)
      : name = item[0],
        values = item.skip(1).map<T>((value) => value).toList();
}
