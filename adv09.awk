BEGIN { visited[0,0] = 1 }
/U/ { dy = $2 }
/D/ { dy = -$2 }
/L/ { dx = -$2 }
/R/ { dx = $2 }
{   # call with -v len=2 or -v len=10
    while (dx != 0 || dy != 0) {
        move(1, dx, dy)
        dx -= sx; dy -= sy
        for (i = 2; i <= len; i++)
            move(i, x[i-1] - x[i], y[i-1] - y[i])
    }
}
END { print length(visited) }

function move(i, dx, dy) {
    ax = dx < 0 ? -dx : dx
    ay = dy < 0 ? -dy : dy
    sx = ax == 0 ? 0 : dx / ax
    sy = ay == 0 ? 0 : dy / ay
    if (i > 1 && ax <= 1 && ay <= 1)
        return
    x[i] += sx; y[i] += sy
    if (i == len)
        visited[x[i],y[i]] = 1
}
