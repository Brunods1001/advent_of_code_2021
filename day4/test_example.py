from bingo import (
    bingo,
    bingo_last_winner,
    check_board,
    check_rows,
    check_cols,
    check_winner,
    get_board_score,
)

DATA = """7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"""


NUMBERS = [
    7,
    4,
    9,
    5,
    11,
    17,
    23,
    2,
    0,
    14,
    21,
    24,
    10,
    16,
    13,
    6,
    15,
    25,
    12,
    22,
    18,
    20,
    8,
    19,
    3,
    26,
    1,
]


def test_bingo():
    scores = bingo(DATA)
    assert scores[0][1] == 4512

def test_bingo_last_winner():
    scores = bingo_last_winner(DATA)
    assert scores[0][1] == 1924

def test_parse_bingo_data():
    numbers, boards = parse_bingo_data(DATA)
    assert numbers == NUMBERS
    assert len(boards) == 3
    assert boards[0] == [
        ["22", "13", "17", "11", "0"],
        ["8", "2", "23", "4", "24"],
        ["21", "9", "14", "16", "7"],
        ["6", "10", "3", "18", "5"],
        ["1", "12", "20", "15", "19"],
    ]


def test_check_board():
    numbers, boards = parse_bingo_data(DATA)
    board = boards[0]
    board = check_board(board, "13")
    assert board == [
        ["22", "X13", "17", "11", "0"],
        ["8", "2", "23", "4", "24"],
        ["21", "9", "14", "16", "7"],
        ["6", "10", "3", "18", "5"],
        ["1", "12", "20", "15", "19"],
    ]


def test_check_winner():
    winner_row = [
        ["22", "13", "17", "11", "0"],
        ["8", "2", "23", "4", "24"],
        ["X21", "X9", "X14", "X16", "X7"],
        ["6", "10", "3", "18", "5"],
        ["1", "12", "20", "15", "19"],
    ]
    winner_col = [
        ["22", "X13", "17", "11", "0"],
        ["8", "X2", "23", "4", "24"],
        ["21", "X9", "14", "16", "7"],
        ["6", "X10", "3", "18", "5"],
        ["1", "X12", "20", "15", "19"],
    ]
    not_winner = [
        ["22", "13", "17", "11", "0"],
        ["8", "X2", "X23", "X4", "X24"],
        ["21", "X9", "14", "16", "7"],
        ["6", "X10", "3", "18", "5"],
        ["1", "X12", "20", "15", "19"],
    ]
    assert check_winner(winner_row)
    assert check_winner(winner_col)
    assert not check_winner(not_winner)


def test_score_board():
    board = [
        ["X14", "X21", "X17", "X24", "X4"],
        ["10", "16", "15", "X9", "19"],
        ["18", "8", "X23", "26", "20"],
        ["22", "X11", "13", "6", "X5"],
        ["X2", "X0", "12", "3", "X7"],
    ]
    last_number = 24
    score = get_board_score(board, 24)
    assert score == 4512


