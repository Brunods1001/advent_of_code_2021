DATA = """0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"""

RES = """.......1..
..1....1..
..1....1..
.......1..
.112111211
..........
..........
..........
..........
222111...."""

DEFAULT_DIAGRAM = """..........
..........
..........
..........
..........
..........
..........
..........
..........
.........."""

DIAGRAM_5_5 = """..........
..........
..........
..........
..........
.....1....
..........
..........
..........
.........."""

DIAGRAM2_5_5 = """..........
..........
..........
..........
..........
.....2....
..........
..........
..........
.........."""

PATH1 = "1,1 -> 1,3"
PATH2 = "9,7 -> 7,7"

def test_prob1():
    assert prob1(DATA) == RES

def prob1(data: str) -> str:
    paths = data.split("\n")
    nrow = len(paths)
    ncol = len(paths[0])
    diagram = draw_diagram(nrow, ncol)
    for path in paths:
        print(path)
        points = get_points(path)
        for point in points:
            print(point)
            diagram = increment_point(diagram, point)
    return diagram


def test_get_points():
    assert get_points(PATH1) == set(["1,1", "1,2", "1,3"])
    assert get_points(PATH2) == set(["9,7", "8,7", "7,7"])

def get_points(path: str) -> set[str]:
    p1, p2 = path.split(" -> ")
    p11, p12 = [int(i) for i in p1.split(",")]
    p21, p22 = [int(i) for i in p2.split(",")]
    if p11 != p21 and p12 != p22:
        return set("")
    if p11 > p21:
        ps1 = [str(i) + "," + str(p21) for i in range(p11, p21 - 1, -1)]
    else:
        ps1 = [str(p11) + "," + str(i) for i in range(p11, p21 + 1)]
    if p12 > p22:
        ps2 = [str(i) + "," + str(p12) for i in range(p12, p22 - 1, -1)]
    else:
        ps2 = [str(p12) + "," + str(i) for i in range(p12, p22 + 1)]
    points = set(ps1).union(ps2)
    return points


def test_draw_diagram():
    assert draw_diagram(10, 10) == DEFAULT_DIAGRAM

def draw_diagram(nrow: int, ncol: int) -> str:
    diagram = ["".join(["." for _ in range(nrow)]) for __ in range(ncol)]
    return "\n".join(diagram)

def test_increment_point():
    diagram = draw_diagram(10, 10)
    diagram2 = increment_point(diagram, "5,5")
    diagram3 = increment_point(diagram2, "5,5")
    assert diagram2 == DIAGRAM_5_5
    assert diagram3 == DIAGRAM2_5_5

def increment_point(diagram: str, point: str):
    nrow, ncol = point.split(",")
    nrow, ncol = int(nrow), int(ncol)
    diagram_split = diagram.split("\n")
    diagram_point = diagram_split[nrow][ncol]
    if diagram_point.isnumeric():
        new_point = int(diagram_point) + 1
    else:
        new_point = 1
    diagram_split[nrow] = diagram_split[nrow][:ncol] + str(new_point) + diagram_split[nrow][ncol+1:]
    new_diagram = "\n".join(diagram_split)
    return new_diagram

