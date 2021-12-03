from functools import reduce

with open("./data.txt", "r") as f:
    data = f.read()

vec = [int(i) for i in data.split() if i]

def diffvec(vec):
    return [j - i > 0 for i, j in zip(vec[:-1], vec[1:])]

print(sum(diffvec(vec)))

def rolling_sum(vec: list[float], step: int) -> list[float]:
    window_sums = [sum(vec[i:i + step]) for i in range(len(vec))]
    return window_sums

print(sum(diffvec(rolling_sum(vec, 3))))

