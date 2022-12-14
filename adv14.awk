BEGIN { FS = " -> |," }
{
    for (i = 3; i < NF; i += 2) {
        x = $(i-2); y = $(i-1)
        x1 = $i; y1 = $(i+1)
        while (x != x1 || y != y1) {
            cave[x,y] = "#"
            if (x != x1)
                x += x < x1 ? 1 : -1
            if (y != y1)
                y += y < y1 ? 1 : -1
            if (y > maxy)
                maxy = y
        }
        cave[x1,y1] = "#"
    }
}
END {
    while (cave[500,0] != "o" && fall(500, 0))
        n++
    print n
}

function fall(x, y) {
    if (part == 2) { # call with -v part=2 for part 2
        if (y == maxy + 1) {
            cave[x,y] = "o"
            return 1
        }
    } else if (y > maxy)
        return 0
    if (!((x,y+1) in cave))
        return fall(x, y + 1)
    if (!((x-1,y+1) in cave))
        return fall(x - 1, y + 1)
    if (!((x+1,y+1) in cave))
        return fall(x + 1, y + 1)
    cave[x,y] = "o"
    return 1
}
