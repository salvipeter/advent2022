BEGIN { FS = "" }
{
    for (i = 1; i <= NF; i++)
        grid[NR,i] = $i
}
END {
    for (pos in grid) {
        if (distance(1, 0) <= 0 || distance(-1, 0) <= 0 ||
            distance(0, 1) <= 0 || distance(0, -1) <= 0)
            count++
        score = scenic(1, 0) * scenic(-1, 0) * scenic(0, 1) * scenic(0, -1)
        if (score > best)
            best = score
    }
    print count ", " best
}

# Distance of grid[pos] from a tree at least as tall in the given direction
# If not found, returns the negative distance to the edge
function distance(dx, dy) {
    height = grid[pos]
    split(pos, xy, SUBSEP)
    x = xy[1]; y = xy[2]
    for (k = 1; k <= NR; k++) {
        x += dx; y += dy
        if (x < 1 || x > NR || y < 1 || y > NR)
            return -(k-1)
        if (grid[x,y] >= height)
            return k
    }
}

function scenic(dx, dy) {
    d = distance(dx, dy)
    if (d < 0)
        return -d
    return d
}
