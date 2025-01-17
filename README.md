# cpuminer Docker Image

Este projeto cria uma imagem Docker para minerar Bitcoin usando o software **cpuminer** (minerd).

## Como Construir a Imagem

1. Certifique-se de ter o Docker instalado em sua máquina.
2. Clone este repositório ou copie o arquivo `Dockerfile`.
3. Construa a imagem usando o seguinte comando:

```bash
docker build -t minerd .
```

## Como Executar o Contêiner

Para começar a minerar, você pode executar o contêiner com o comando abaixo:

```bash
docker run -d minerd --url stratum+tcp://btc.pool.com:3333 --user user.worker --pass password
```

Substitua:
- `stratum+tcp://btc.pool.com:3333` pela URL do pool de mineração que você deseja usar.
- `user.worker` pelo nome de usuário e identificador do worker configurado no pool.
- `password` pela senha do worker, se exigida pelo pool.

## Testando o Desempenho com `--benchmark`

Se quiser testar o desempenho do **cpuminer** sem conectar-se a um pool, você pode executar o contêiner com a flag `--benchmark`. Isso executará um teste de benchmark no seu hardware.

```bash
docker run --rm minerd --benchmark
```

Isso é útil para determinar a taxa de hashes por segundo que o seu sistema pode alcançar com base no algoritmo suportado.

## Otimização

Esta imagem foi projetada para ser leve e eficiente, mas você pode personalizá-la caso precise de dependências adicionais ou queira utilizar configurações diferentes. Para modificações, ajuste o `Dockerfile` conforme necessário.
