def get_gamma_rate(num):
    ...

def get_epsilon_rate(num):
    ...

def get_power_consumption(num):
    gamma, epsilon = get_gamma_rate(num), get_epsilon_rate(num)
    return gamma * epsilon

def update_position_count(position: dict[int, int], line: str):
    for i in range(len(line)):
        position[i] += line[i] == "1"

def main():
    position = {i:0 for i in range(12)}
    num_lines = 0
    with open("./data.txt", "r") as data:
        while line := data.readline():
            clean_line = line.strip()
            if clean_line:
                update_position_count(position, clean_line)
                num_lines += 1
    gamma_list, epsilon_list = [], []
    print(position)
    for k, v in position.items():
        rate = v / num_lines
        mostly_one = rate >= 0.5
        gamma_list.append(str(int(mostly_one)))
        epsilon_list.append(str(int(not mostly_one)))
    gamma, epsilon = "".join(gamma_list), "".join(epsilon_list)
    gamma, epsilon = int(gamma, 2), int(epsilon, 2)
    print(gamma * epsilon)


if __name__ == "__main__":
    main()
