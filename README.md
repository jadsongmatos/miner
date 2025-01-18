# cpuminer Docker Image

Este projeto cria uma imagem Docker para minerar Bitcoin utilizando o software **cpuminer** (minerd). O foco principal está em explorar otimizações para maximizar a eficiência e o desempenho do minerador, aproveitando combinações avançadas de flags de compilação e configurações personalizadas.

## Como Rodar na Versão Mais Otimizada

Para executar o **cpuminer** com a configuração mais otimizada encontrada até o momento, utilize o seguinte comando:

```bash
docker run -d --cap-add SYS_NICE --network host --restart always minerd --algo=sha256d --url stratum+tcp://btc.pool.com:3333 --user user.worker --pass x
```

- `--cap-add SYS_NICE`: Permite ajustar a prioridade do processo.
- `--network host`: Minimiza a latência de rede.
- `--restart always`: Garante que o contêiner seja reiniciado automaticamente em caso de falha.
- Substitua:
  - `stratum+tcp://btc.pool.com:3333` pela URL do pool de mineração desejado.
  - `user.worker` pelo nome de usuário e identificador do worker configurado no pool.
  - `x` pela senha do worker, se exigida pelo pool.

## Como Chegar na Configuração Otimizada

### Melhor Combinação de Flags

Com base em extensivos testes utilizando scripts automatizados, a combinação de flags abaixo foi identificada como a mais eficiente, proporcionando um aumento significativo na taxa de hashes por segundo (H/s):

```text
-O3 -ftree-parallelize-loops=20 -floop-nest-optimize -floop-interchange -ftree-loop-distribution -ftree-loop-vectorize -floop-parallelize-all -fopenmp -march=native -mtune=native -flto -fprefetch-loop-arrays -ffast-math -fwhole-program -funroll-loops -fpeel-loops -fsplit-loops -fpredictive-commoning -fipa-cp-clone -ftree-slp-vectorize -falign-functions=32 -fopt-info-vec -fno-math-errno
```

Essa configuração utiliza otimizações avançadas, como vetorização de loops, prefetch de memória e otimizações específicas para arquiteturas nativas.

### Scripts para Testes

#### `benchmark.sh`

Este script facilita o processo de benchmarking automatizado para diferentes combinações de flags de compilação, registrando os resultados em um arquivo para análise posterior.

- **Funcionalidades:**
  - Compila e testa o **cpuminer** com várias configurações.
  - Salva os resultados em `benchmark_results.txt`.

**Como executar:**
```bash
./benchmark.sh
```

#### `flags.py`

Este script gera até 1.000 combinações únicas de flags de compilação para explorar possibilidades de otimização em larga escala.

- **Funcionalidades:**
  - Cria combinações baseadas em uma lista predefinida de flags.
  - Salva as combinações no arquivo `top_1000_combinations.txt`.

**Como executar:**
```bash
python flags.py
```

> Use esses scripts para identificar combinações personalizadas que melhor se adequem ao seu hardware.
