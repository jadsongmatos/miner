#!/bin/bash

# Lista de combinações de flags
FLAGS_LIST=(
"-O3 -ftree-parallelize-loops=20 -floop-nest-optimize -floop-interchange -ftree-loop-distribution -ftree-loop-vectorize -floop-parallelize-all -fopenmp -march=native -mtune=native -flto -fprefetch-loop-arrays -ffast-math -fprofile-generate -fwhole-program -funroll-loops -fpeel-loops -fsplit-loops -fpredictive-commoning -fipa-cp-clone -ftree-slp-vectorize -falign-functions=32 -fopt-info-vec -fno-math-errno"
"-O3 -ftree-parallelize-loops=20 -floop-nest-optimize -floop-interchange -ftree-loop-distribution -ftree-loop-vectorize -floop-parallelize-all -fopenmp -march=native -mtune=native -flto -fprefetch-loop-arrays -ffast-math -fprofile-generate -fwhole-program -funroll-loops -fpeel-loops -fsplit-loops -fpredictive-commoning -fipa-cp-clone -ftree-slp-vectorize -falign-functions=32 -fopt-info-vec"
)

# Arquivo para salvar os resultados
RESULT_FILE="benchmark_results.txt"
echo "Benchmark Results" > $RESULT_FILE

# Tempo limite em segundos para cada benchmark
TIMEOUT=10

for FLAGS in "${FLAGS_LIST[@]}"; do
    echo "Testing flags: $FLAGS"

    # Construir a imagem Docker com as flags atuais
    docker build --build-arg CFLAGS="$FLAGS" -t minerd .

    # Executar o contêiner em segundo plano
    CONTAINER_ID=$(docker run -d --cap-add SYS_NICE --network host minerd --benchmark --algo=sha256d)

    # Aguardar o tempo limite e forçar a interrupção do contêiner
    sleep $TIMEOUT
    docker stop $CONTAINER_ID > /dev/null 2>&1

    # Capturar os logs do contêiner para obter o resultado
    RESULT=$(docker logs $CONTAINER_ID | grep "Total:" | sed -n 's/.*Total: \([0-9.]*\).*/\1/p')

    docker rm $CONTAINER_ID > /dev/null 2>&1

    # Remover a imagem Docker
    docker rmi minerd > /dev/null 2>&1

    # Salvar o resultado no arquivo
    echo "Flags: $FLAGS | Total kH/s: ${RESULT:-N/A}" >> $RESULT_FILE
done

echo "Tests completed. Results saved to $RESULT_FILE."