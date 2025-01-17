import itertools

# Lista de flags fornecidas
flags = [
    "-O3", "-ftree-parallelize-loops=20", "-floop-nest-optimize", "-floop-interchange",
    "-ftree-loop-distribution", "-ftree-loop-vectorize", "-floop-parallelize-all", "-fopenmp",
    "-march=native", "-mtune=native", "-flto", "-fprefetch-loop-arrays", "-ffast-math",
    "-fprofile-generate", "-fwhole-program", "-funroll-loops", "-fpeel-loops", "-fsplit-loops",
    "-fpredictive-commoning", "-fipa-cp-clone", "-ftree-slp-vectorize", "-falign-functions=32",
    "-fopt-info-vec", "-fno-math-errno"
]

# Gerar todas as combinações de flags
all_combinations = []
for r in range(len(flags), 0, -1):  # Começar com o maior número de flags
    combinations = itertools.combinations(flags, r)
    all_combinations.extend(combinations)

# Limitar às 1000 combinações com o maior número de flags
top_100_combinations = all_combinations[:1000]

# Salvar combinações em um arquivo
with open("top_1000_combinations.txt", "w") as file:
    for i, combo in enumerate(top_100_combinations, 1):
        combo_str = " ".join(combo)
        file.write(f"\"{combo_str}\"\n")

print("Top 1000 combinations saved to 'top_1000_combinations.txt'.")