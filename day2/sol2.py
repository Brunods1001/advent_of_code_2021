state = (0, 0, 0)  # forward, depth, aim

def increment(state: tuple[int, int], command: str, num: int) -> tuple[int, int]:
    if command == "forward":
        new_state = (state[0] + num, state[1] + num * state[2], state[2])
    elif command == "down":
        new_state = (state[0], state[1], state[2] + num)
    elif command == "up":
        new_state = (state[0], state[1], state[2] - num)
    else:
        new_state = state
    return new_state

with open("./data.txt", "r") as f:
    while line := f.readline():
        command, num = line.split()
        state = increment(state, command, int(num))

print(state)
print(state[0] * state[1])
