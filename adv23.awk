BEGIN { FS = ""; split("14223311", patrol) }
{
    for (i = 1; i <= NF; i++)
        if ($i == "#")
            elves[i,NR] = 0
}
END {
    for (round = 0; !done; round++) {
        done = 1
        for (elf in elves) {
            split(elf, xy, SUBSEP)
            if (shouldMove(xy[1], xy[2])) {
                dir = bestDir(xy[1], xy[2])
                if (dir)
                    elves[elf] = canMove(xy[1], xy[2], dir)
            }
        }
        for (elf in elves)
            if (elves[elf] > 0) {
                split(elf, xy, SUBSEP)
                x1 = xy[1]; y1 = xy[2]
                move(elves[elf])
                elves[x1,y1] = 0
                delete elves[elf]
                done = 0
            }
        if (round == 9) {
            computeBBox()
            print (maxx - minx + 1) * (maxy - miny + 1) - length(elves)
        }
    }
    print round
}

# 0: N/A, 1: N, 2: S, 3: W, 4: E
function bestDir(x, y) {
    for (i = 0; i < 4; i++) {
        x1 = x; y1 = y
        dir = (round + i) % 4 + 1
        move(dir)
        if ((x1,y1) in elves)
            continue
        if (dir <= 2) { # check WE
            move(3)
            if ((x1,y1) in elves)
                continue
            move(4); move(4)
            if ((x1,y1) in elves)
                continue
        } else {        # check NS
            move(1)
            if ((x1,y1) in elves)
                continue
            move(2); move(2)
            if ((x1,y1) in elves)
                continue
        }
        return dir
    }
    return 0
}

function canMove(x, y, dir) {
    x1 = x; y1 = y
    move(dir); move(dir)
    if (!(x1,y1) in elves)
        return dir
    x = x1; y = y1
    if (!shouldMove(x, y) || bestDir(x, y) != opposite(dir))
        return dir
    return 0
}

function shouldMove(x, y) {
    x1 = x; y1 = y
    for (i = 1; i <= 8; i++) {
        move(patrol[i])
        if ((x1,y1) in elves)
            return 1
    }
    return 0
}

function move(dir) {
    switch (dir) {
    case 1: y1--; break
    case 2: y1++; break
    case 3: x1--; break
    case 4: x1++; break
    }
}

function opposite(dir) {
    switch (dir) {
    case 0: return 0
    case 1: return 2
    case 2: return 1
    case 3: return 4
    case 4: return 3
    }
}

function computeBBox() {
    for (elf in elves) {
        split(elf, xy, SUBSEP)
        minx = maxx = xy[1]
        miny = maxy = xy[2]
        break
    }
    for (elf in elves) {
        split(elf, xy, SUBSEP)
        if (xy[1] < minx)
            minx = xy[1]
        if (xy[1] > maxx)
            maxx = xy[1]
        if (xy[2] < miny)
            miny = xy[2]
        if (xy[2] > maxy)
            maxy = xy[2]
    }
}
