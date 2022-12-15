BEGIN { y = 2000000; max = 4000000 }
{
    match($0, /x=(.*), y=(.*):.*x=(.*), y=(.*)$/, a)
    sensor[a[1],a[2]] = abs(a[3] - a[1]) + abs(a[4] - a[2])
    if (a[4] == y)
        beacon[a[3]] = 1
}
END {
    calcRanges()
    for (i = 1; i <= NR; i++)
        if (x == "" || (l[i] < r[i] && l[i] < x))
            x = l[i]
    do {
        x1 = nextOut(x)
        count += x1 - x
        x = nextIn(x1)
    } while (x != "")
    for (y = 0; y <= max; y++) {
        calcRanges()
        x = nextOut(0)
        if (x <= max)
            break
    }
    print count - length(beacon) ", " x * 4000000 + y
}

function abs(x) { return x < 0 ? -x : x }

function calcRanges() {
    n = 0
    for (s in sensor) {
        split(s, xy, SUBSEP)
        d = sensor[s] - abs(y - xy[2])
        if (d < 0)
            continue
        l[++n] = xy[1] - d
        r[n] = xy[1] + d
    }
}

function nextIn(x,    m) {
    for (i = 1; i <= n; i++)
        if (l[i] > x && (!m || l[i] < m))
            m = l[i]
    return m
}

function nextOut(x) {
    do {
        changed = 0
        for (i = 1; i <= n; i++)
            if (l[i] <= x && r[i] >= x) {
                x = r[i] + 1
                changed = 1
            }
    } while (changed)
    return x
}
