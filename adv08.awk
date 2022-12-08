BEGIN { FS = "" ; SUBSEP = "@" }
{
    for (i = 1; i <= NF; i++)
        grid[NR,i] = $i
}
END {
    for (pos in grid) {
        if (distance(pos, 1, 0) <= 0 || distance(pos, -1, 0) <= 0 ||
            distance(pos, 0, 1) <= 0 || distance(pos, 0, -1) <= 0)
            count++
        score = scenic(pos, 1, 0) * scenic(pos, -1, 0) \
            * scenic(pos, 0, 1) * scenic(pos, 0, -1)
        if (score > best)
            best = score
    }
    print count ", " best
}

# Distance from a tree at least as tall in the given direction
# If not found, returns the negative distance to the edge
function distance(pos, dx, dy) {
    height = grid[pos]
    split(pos, xy, "@")
    x = xy[1]; y = xy[2]
    for (k = 1; k <= NR; k++) {
        x += dx; y += dy
        if (x < 1 || x > NR || y < 1 || y > NR)
            return -(k-1)
        if (grid[x,y] >= height)
            return k
    }
}

function scenic(pos, dx, dy) {
    d = distance(pos, dx, dy)
    if (d < 0)
        return -d
    return d
}
