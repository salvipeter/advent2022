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

function maxGeodes(time, best,    i) {
    if (time == 0)
        return minerals[4]
    if (best >= minerals[4] + robots[4] * time + (time - 1) * time / 2)
        return minerals[4]

    for (i = 4; i >= 1; i--) {
        if ((i == 1 &&
             (robots[1] >= max_cost || minerals[1] >= max_cost + 1)) ||
            ((i == 2 || i == 3) &&
             (robots[i] >= costs[i+1,i] || minerals[i] >= costs[i+1,i] + 1)))
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
