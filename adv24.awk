BEGIN { FS = ""; SUBSEP = "," }
{
    for (i = 1; i <= NF; i++)
        if (match($i, /[<>^v]/)) {
            bd[++n] = $i
            bx[n] = i; by[n] = NR
        }
}
END {
    x = 2; y = 1; goalx = NF - 1; goaly = NR
    for (m = 0; !cycle; m++) {
        buildMap()
        if (checkCycle())
            cycle = m
        moveBlizzards()
    }

    part1 = shortest(0, x, y, goalx, goaly)
    part2a = part1 + shortest(part1 % cycle, goalx, goaly, x, y)
    part2 = part2a + shortest(part2a % cycle, x, y, goalx, goaly)
    print part1 ", " part2
}

function buildMap() {
    for (i = 1; i <= n; i++) {
        map[m,i,1] = "#"
        map[m,i,NR] = "#"
        map[m,1,i] = "#"
        map[m,NF,i] = "#"
    }
    delete map[m,x,y]
    delete map[m,goalx,goaly]
    for (i = 1; i <= n; i++)
        if ((m,bx[i],by[i]) in map)
            map[m,bx[i],by[i]] = "+"
        else
            map[m,bx[i],by[i]] = bd[i]
}

function moveBlizzards() {
    for (i = 1; i <= n; i++)
        switch(bd[i]) {
        case "<": bx[i]--; if (bx[i] == 1)  bx[i] = NF - 1; break
        case ">": bx[i]++; if (bx[i] == NF) bx[i] = 2;      break
        case "^": by[i]--; if (by[i] == 1)  by[i] = NR - 1; break
        case "v": by[i]++; if (by[i] == NR) by[i] = 2;      break
        }
}

function checkCycle() {
    for (j = 1; j <= NR; j++)
        for (i = 1; i <= NF; i++) {
            if (!((0,i,j) in map) && !((m,i,j) in map))
                continue
            if (!((0,i,j) in map) || !((m,i,j) in map))
                return 0
            if (map[0,i,j] != map[m,i,j])
                return 0
        }
    return 1
}

function computeAdjacent() {
    split(pos, mxy, ",")
    m = (mxy[1] + 1) % cycle
    adjacent[1] = m "," mxy[2] - 1  "," mxy[3]
    adjacent[2] = m "," mxy[2] + 1  "," mxy[3]
    adjacent[3] = m "," mxy[2] "," mxy[3] - 1
    adjacent[4] = m "," mxy[2] "," mxy[3] + 1
    adjacent[5] = m "," mxy[2] "," mxy[3]
}

function inside(pos) {
    split(pos, mxy, ",")
    return !(mxy[2] == 2 && mxy[3] == 0) &&
        !(mxy[2] == goalx && mxy[3] == NR + 1)
}

function shortest(m, x, y, goalx, goaly,    distance, queue, k, best) {
    distance[m,x,y] = 0
    queue[q=1] = m "," x "," y
    while (k < q) {
        pos = queue[++k]
        d = distance[pos] + 1
        computeAdjacent()
        for (i in adjacent) {
            a = adjacent[i]
            if (inside(a) && !(a in map) &&
                (!(a in distance) || distance[a] > d)) {
                distance[a] = d
                queue[++q] = a
            }
        }
    }
    for (i = 0; i < cycle; i++)
        if (((i,goalx,goaly) in distance) &&
            (!best || best > distance[i,goalx,goaly]))
            best = distance[i,goalx,goaly]
    return best
}
