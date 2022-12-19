BEGIN { prod = 1 }
{
    costs[1,1] = $7
    costs[2,1] = $13
    costs[3,1] = $19; costs[3,2] = $22
    costs[4,1] = $28; costs[4,3] = $31
    max_cost = max(costs[1,1], max(costs[2,1], max(costs[3,1], costs[4,1])))
    robots[1] = 1
    sum += NR * maxGeodes(24)
    if (NR <= 3)
        prod *= maxGeodes(32)
}
END { print sum ", " prod }

function max(a, b) { return a >= b ? a : b }

# Rough upper bound on the quantity of material i after time t
# (assumes that we use all the time to build robots for it)
function upperBound(i, t) {
    return minerals[i] + robots[i] * t + (t - 1) * t / 2
}

# Better upper bound for material 4
# (computes a lower bound for the time needed to start making new robots)
function guessMax(t,    t0) {
    while (upperBound(1, t0) < costs[4,1] || upperBound(3, t0) < costs[4,3])
        t0++
    return upperBound(4, t - t0) + robots[4] * t0
}

function maxGeodes(time, best,    i) {
    if (time == 0 || best >= guessMax(time))
        return minerals[4]

    for (i = 4; i >= 1; i--) {
        if ((i == 1 && robots[1] >= max_cost) ||
            ((i == 2 || i == 3) && robots[i] >= costs[i+1,i]))
            continue
        can_build = 1
        for (j = 1; j <= 3; j++)
            if (costs[i,j] > minerals[j])
                can_build = 0
        if (can_build) {
            for (j = 1; j <= 4; j++)
                minerals[j] += robots[j] - costs[i,j]
            robots[i]++
            best = max(best, maxGeodes(time - 1, best))
            robots[i]--
            for (j = 1; j <= 4; j++)
                minerals[j] -= robots[j] - costs[i,j]
        }
    }

    for (j = 1; j <= 4; j++)
        minerals[j] += robots[j]
    best = max(best, maxGeodes(time - 1, best))
    for (j = 1; j <= 4; j++)
        minerals[j] -= robots[j]

    return best
}
