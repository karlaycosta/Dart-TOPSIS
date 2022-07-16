# Dart - TOPSIS (Technique for Order Preference by Similarity to Ideal Solution)

#### Programa desenvolvido em linguagem de programação [Dart](https://dart.dev/) para o trabalho de conclusão de curso de Tecnologia em Análise e Desenvolvimento de Sistemas no Instituto Federal de Educação, Ciência e Tecnologia do Pará campus Altamira.

## O que é TOPSIS
É a técnica para ordenamento de preferências por semelhança com a solução ideal, surgiu na década de 1980 como um método de tomada de decisão multicritério.
O TOPSIS escolhe a melhor alternativa com base na menor distância euclidiana da solução ideal e maior distância da solução não ideal. Para mais detalhes [wikipedia](https://en.wikipedia.org/wiki/TOPSIS).

## Formato de entrada dos dados (CSV)
| Operadoras | P01 | P02  | P04  | P05  | P06  | P07  | P09  | P10  | P11  |
| :--------: | :-: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
| **Impacto**| max | max  | max  | max  | max  | max  | max  | max  | max  |
| **peso**   | 0.2 | 0.15 | 0.05 | 0.05 | 0.05 | 0.05 | 0.15 | 0.15 | 0.15 |
| **A**      |  1  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |
| **B**      |  3  |   2  |   1  |   1  |   1  |   1  |   2  |   2  |   3  |
| **C**      |  3  |   1  |   2  |   2  |   2  |   4  |   1  |   2  |   3  |
| **D**      |  1  |   0  |   0  |   0  |   0  |   0  |   1  |   2  |   0  |
| **E**      |  3  |   1  |   2  |   2  |   1  |   4  |   2  |   1  |   4  |
| **F**      |  3  |   3  |   2  |   1  |   1  |   3  |   1  |   1  |   1  |
| **G**      |  3  |   1  |   2  |   0  |   1  |   1  |   0  |   2  |   3  |
| **H**      |  1  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |

A primeira linha deve conter a descrição dos critérios.<br>
A segunda linha deve conter o impacto, sendo `max` para positivo e `min` para negativo.<br>
A terceira linha deve conter o peso que cada critério deve receber.<br>
As demais linhas são as alternativas a serem avaliadas.

## Como usá-lo
#### O aplicativo tem opções de linha de comando:
```Shell
Opções de comando:

    -i, --entrada            Arquivo no formato CSV a ser processado
    -n, --[no-]normalizar    Exibir a tabela normalizada
    -o, --[no-]ordenar       Ordenar resultado
    -h, --help               Ajuda
```
Existem duas formas de executar o aplicativo:
1. Execução direta -> `dart run bin/main.dart -i dados.csv`
2. Compilar o aplicativo -> `dart compile exe bin/main.dart`

**OBS: Após compilado, executar conforme as opções de linha de comando.**

## Dados de saída

#### Formato de saída padrão

| Provedores | P01 | P02 | P04 | P05 | P06 | P07 | P09 | P10 | P11 | [+]Distance | [-]Distance |    Score | Ranking |
|:----------:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:-----------:|------------:|---------:|:-------:|
| **A**      |   1 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |    0.202785 |         0.0 |      0.0 |   **7** |
| **B**      |   3 |   2 |   1 |   1 |   1 |   1 |   2 |   2 |   3 |    0.056129 |    0.165862 | 0.747157 |   **1** |
| **C**      |   3 |   1 |   2 |   2 |   2 |   4 |   1 |   2 |   3 |    0.090453 |    0.141971 | 0.610827 |   **4** |
| **D**      |   1 |   0 |   0 |   0 |   0 |   0 |   1 |   2 |   0 |    0.173163 |    0.083937 | 0.326477 |   **6** |
| **E**      |   3 |   1 |   2 |   2 |   1 |   4 |   2 |   1 |   4 |    0.084779 |    0.158695 | 0.651794 |   **2** |
| **F**      |   3 |   3 |   2 |   1 |   1 |   3 |   1 |   1 |   1 |    0.092295 |    0.146528 | 0.613542 |   **3** |
| **G**      |   3 |   1 |   2 |   0 |   1 |   1 |   0 |   2 |   3 |    0.127098 |    0.123696 | 0.493218 |   **5** |
| **H**      |   1 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |    0.202785 |         0.0 |      0.0 |   **8** |

#### Formato de saída ordenada adicionando o comando `-o, --[no-]ordenar`

| Provedores | P01 | P02 | P04 | P05 | P06 | P07 | P09 | P10 | P11 | [+]Distance | [-]Distance |    Score | Ranking |
|:----------:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:-----------:|------------:|---------:|:-------:|
| **B**      |   3 |   2 |   1 |   1 |   1 |   1 |   2 |   2 |   3 |    0.056129 |    0.165862 | 0.747157 |   **1** |
| **E**      |   3 |   1 |   2 |   2 |   1 |   4 |   2 |   1 |   4 |    0.084779 |    0.158695 | 0.651794 |   **2** |
| **F**      |   3 |   3 |   2 |   1 |   1 |   3 |   1 |   1 |   1 |    0.092295 |    0.146528 | 0.613542 |   **3** |
| **C**      |   3 |   1 |   2 |   2 |   2 |   4 |   1 |   2 |   3 |    0.090453 |    0.141971 | 0.610827 |   **4** |
| **G**      |   3 |   1 |   2 |   0 |   1 |   1 |   0 |   2 |   3 |    0.127098 |    0.123696 | 0.493218 |   **5** |
| **D**      |   1 |   0 |   0 |   0 |   0 |   0 |   1 |   2 |   0 |    0.173163 |    0.083937 | 0.326477 |   **6** |
| **A**      |   1 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |    0.202785 |         0.0 |      0.0 |   **7** |
| **H**      |   1 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |   0 |    0.202785 |         0.0 |      0.0 |   **8** |

#### Exibir os dados normalizados adicionando o comando `-n, --[no-]normalizar`

| Provedores | P01      | P02      | P04      | P05      | P06      | P07      | P09      | P10      | P11      |
|:----------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
| **Impacto**| max      | max      | max      | max      | max      | max      | max      | max      | max      |
| **peso**   | 0.2      | 0.15     | 0.05     | 0.05     | 0.05     | 0.05     | 0.15     | 0.15     | 0.15     |
| **A**      | 0.028868 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |
| **B**      | 0.086603 | 0.075000 | 0.012127 | 0.015811 | 0.017678 | 0.007625 | 0.090453 | 0.070711 | 0.067840 |
| **C**      | 0.086603 | 0.037500 | 0.024254 | 0.031623 | 0.035355 | 0.030500 | 0.045227 | 0.070711 | 0.067840 |
| **D**      | 0.028868 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.045227 | 0.070711 | 0.000000 |
| **E**      | 0.086603 | 0.037500 | 0.024254 | 0.031623 | 0.017678 | 0.030500 | 0.090453 | 0.035355 | 0.090453 |
| **F**      | 0.086603 | 0.112500 | 0.024254 | 0.015811 | 0.017678 | 0.022875 | 0.045227 | 0.035355 | 0.022613 |
| **G**      | 0.086603 | 0.037500 | 0.024254 | 0.000000 | 0.017678 | 0.007625 | 0.000000 | 0.070711 | 0.067840 |
| **H**      | 0.028868 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 | 0.000000 |

## Licença

Este repositório está licenciado sob a licença MIT. Consulte [LICENSE](LICENSE.md) para obter detalhes.