from bingo import bingo, bingo_last_winner
from typing import Any

def read_data() -> str | None:
    with open("data.txt", "r") as f:
        return f.read().strip()

def indexes(ls: list, val: Any) -> list[int]:
    idx = []
    for i, v in enumerate(ls):
        if v == val:
            idx.append(i)
    return idx

if __name__ == "__main__":
    data = read_data()
    print(bingo(data))
    print(bingo_last_winner(data))
