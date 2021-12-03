with open("./data.txt", "r") as f:
    data = f.read()

vec = [int(i) for i in data.split() if i]

diffvec = [j - i > 0 for i, j in zip(vec[:-1], vec[1:])]

print(sum(diffvec))
