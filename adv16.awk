{
    match($0, /Valve (.*) has.*rate=(.*);.*valves? (.*)$/, a)
    if (a[1] == "AA" || a[2] != 0) {
        flow[a[1]] = a[2]
        sorted[++n] = a[1]
    }
    split(a[3], tunnels[a[1]], ", ")
}
END {
    for (i = 2; i <= n; i++)
        for (j = i - 1; j >= 1 && flow[sorted[j+1]] > flow[sorted[j]]; j--) {
            tmp = sorted[j]
            sorted[j] = sorted[j+1]
            sorted[j+1] = tmp
        }
    for (pos in flow)
        computeRoutes(pos)
    print maxPressure("AA", 30) ", " maxPressure("AA", 26, "AA", 26)
}

function computeRoutes(start) {
    route[start,start] = 0
    queue[len=1] = start
    while (len > 0) {
        from = queue[len--]
        d = route[start,from] + 1
        for (t in tunnels[from]) {
            to = tunnels[from][t]
            if (!((start,to) in route) || d < route[start,to]) {
                route[start,to] = d
                queue[++len] = to
            }
        }
    }
    delete route[start,start]
}

function max(a, b) { return a >= b ? a : b }

function maxPressure(p1, t1, p2, t2, pressure,    m, i, opened) {
    if (t1 < t2)
        return maxPressure(p2, t2, p1, t1, pressure)
    if (t1 == 0)
        return pressure
    if (!valve[p1] && flow[p1]) {
        pressure += flow[p1] * (--t1)
        valve[p1] = 1
        opened = 1
    }
    m = pressure
    for (i = 1; i <= n; i++) {
        r = route[p1,sorted[i]]
        if (!valve[sorted[i]] && flow[sorted[i]] && r < t1)
            m = max(m, maxPressure(sorted[i], t1 - r, p2, t2, pressure))
    }
    # Maybe it's better to let the other one take the rest
    m = max(m, maxPressure(p2, t2, p1, 0, pressure))
    if (m > best) {
        best = m
        print best # very(!) slow ... print current best
    }
    if (opened)
        valve[p1] = 0
    return m
}