

Board = list[list[str]]


def bingo(data: str) -> list[int]:
    scores = []
    numbers, boards = parse_bingo_data(data)
    for number in numbers:
        boards = list(map(lambda x: check_board(x, str(number)), boards))
        winners = list(map(check_winner, boards))
        if any(winners):
            winning_boards = [board for board, winner in zip(boards, winners) if winner]
            for board in winning_boards:
                score = get_board_score(board, number)
                scores.append((board, score))
            return scores

def bingo_last_winner(data: str) -> list[int]:
    scores = []
    numbers, boards = parse_bingo_data(data)
    for i, number in enumerate(numbers):
        boards = list(map(lambda x: check_board(x, str(number)), boards))
        winners = list(map(check_winner, boards))
        if all(winners) or len(numbers) == i:
            for board in boards:
                score = get_board_score(board, number)
                scores.append((board, score))
            return scores
        boards = [board for board, winner in zip(boards, winners) if not winner]

def check_winner(board: Board) -> bool:
    return check_rows(board) or check_cols(board)

def check_rows(board: Board) -> bool:
    for row in board:
        if all(["X" in num for num in row]):
            return True
    return False

def check_cols(board: Board) -> bool:
    ncol = len(board[0])
    num_col = 0
    for idx in range(ncol):
        for row in board:
            num = row[idx]
            if "X" in num:
                num_col += 1
            else:
                num_col = 0
                break
            if num_col == ncol:
                return True
    return False


def parse_bingo_data(data: str) -> tuple[list[int], Board]:
    numbers_txt, *boards_txt = data.split("\n\n")
    numbers = [int(i) for i in numbers_txt.split(",")]
    boards = [
        [row.split() for row in board_txt.split("\n")] for board_txt in boards_txt
    ]
    return numbers, boards


def check_board(board: Board, number: str) -> Board:
    """
    Checks if a board has a number. If so, return a board with an X prepended to the number.
    """
    new_board = board.copy()
    for i, row in enumerate(board):
        for j, num in enumerate(row):
            if num == number:
                new_board[i][j] = f"X{num}"
    return new_board

def get_board_score(board: Board, last_number: int) -> int:
    score = 0
    for row in board:
        for num in row:
            if num.isnumeric():
                score += int(num)
    return score * last_number

