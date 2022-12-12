BEGIN { FS = ""; height = "abcdefghijklmnopqrstuvwxyz" }
{
    for (i = 1; i <= NF; i++) {
        if ($i == "S") {
            map[NR,i] = 1
            start = NR SUBSEP i
        } else if ($i == "E") {
            map[NR,i] = 26
            goal = NR SUBSEP i
        } else
            map[NR,i] = index(height, $i)
    }
}
END {
    for (pos in map) {
        addEdge(1, 0); addEdge(-1, 0)
        addEdge(0, 1); addEdge(0, -1)
    }
    for (pos in map) {
        if (map[pos] != 1)
            continue
        delete distance
        distance[pos] = 0
        queue[len=k=1] = pos
        while (k <= len && !(goal in distance)) {
            from = queue[k++]
            d = distance[from] + 1
            for (i = 1; i <= n[from]; i++) {
                to = edges[from,i]
                if (!(to in distance) || d < distance[to]) {
                    distance[to] = d
                    queue[++len] = to
                }
            }
        }
        if (pos == start)
            print distance[goal]
        if (goal in distance && (best == 0 || best > distance[goal]))
            best = distance[goal]
    }
    print best
}

function addEdge(dx, dy) {
    split(pos, xy, SUBSEP)
    x = xy[1] + dx; y = xy[2] + dy
    if (x >= 1 && y >= 1 && x <= NF && y <= NF && map[x,y] <= map[pos] + 1)
        edges[pos,++n[pos]] = x SUBSEP y
}
