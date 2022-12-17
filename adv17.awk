BEGIN {
    FS = ""
    rock[0][0,0] = rock[0][1,0] = rock[0][2,0] = rock[0][3,0] = 1
    rock[1][1,0] = rock[1][0,1] = rock[1][1,1] = rock[1][2,1] = rock[1][1,2] = 1
    rock[2][0,0] = rock[2][1,0] = rock[2][2,0] = rock[2][2,1] = rock[2][2,2] = 1
    rock[3][0,0] = rock[3][0,1] = rock[3][0,2] = rock[3][0,3] = 1
    rock[4][0,0] = rock[4][1,0] = rock[4][0,1] = rock[4][1,1] = 1
    for (i = 0; i < 7; i++)
        cave[i,0] = "-"
}
{   # call with -v part=2 for part 2, and -v part=code for code generation
    magic1 = 442; magic2 = 1740
    count = part == 2 ? magic1 + magic2 : 2022
    count2 = magic1 + (1000000000000 - magic1) % magic2
    cycle = int((1000000000000 - magic1) / magic2)

    max = 0
    for (i = 0; i < count; i++) {
        if (i == magic1)
            offset1 = max
        if (i == count2)
            offset2 = max
        r = i % 5

        if (part == "code") {
            count++
            gencode()
            if (code in seen) {
                print "magic1 = " seen[code] "; magic2 = " i - seen[code]
                exit
            } else
                seen[code] = i
        }

        x = 2; y = max + 4
        do {
            k++
            if (k > NF)
                k = 1
            dx = $k == "<" ? -1 : 1
            if (canMove(dx, 0))
                x += dx
        } while (fall())
    }
    print part == 2 ? (max - offset1) * cycle + offset2 : max
}

function canMove(dx, dy) {
    ok = 1
    for (pos in rock[r]) {
        split(pos, xy, SUBSEP)
        x1 = x + xy[1] + dx
        y1 = y + xy[2] + dy
        if (x1 < 0 || x1 > 6 || (x1,y1) in cave) {
            ok = 0
            break
        }
    }
    return ok
}

function fall() {
    if (canMove(0, -1)) {
        y--
        return 1
    }
    for (pos in rock[r]) {
        split(pos, xy, SUBSEP)
        cave[x+xy[1],y+xy[2]] = r
        if (y + xy[2] > max)
            max = y + xy[2]
    }
    return 0
}

# The situation is encoded as:
# - rock index
# - gas index
# - the cave from the top, until every column is filled
function gencode(found) {
    code = r k
    for (a = 0; a < 7; a++)
        filled[a] = 0
    for (b = max; !found; b--) {
        for (a = 0; a < 7; a++)
            if (!filled[a]) {
                if ((a,b) in cave) {
                    code = code "#"
                    filled[a] = 1
                } else
                    code = code "."
            }
        found = 1
        for (a = 0; a < 7; a++)
            if (!filled[a])
                found = 0
    }
}
