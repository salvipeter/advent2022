# Not a general solution, assumes this shape:
# ..1122
# ..33..
# 4455..
# 66....

BEGIN { FS = ""; n = 50 }
/^[ .#]+$/ {
    for (i = 1; i <= NF; i++)
        map[i,NR] = $i
}
/^[0-9LR]+$/ { # run with -v part=2 for part 2
    FS = " "; gsub(/[LR]/, " & ")
    x = n + 1; y = 1; dx = 1; dy = 0
    for (i = 1; i <= NF; i++)
        switch ($i) {
        case "L": tmp = dx; dx = dy; dy = -tmp; break
        case "R": tmp = dx; dx = -dy; dy = tmp; break
        default:
            for (j = 1; j <= $i; j++) {
                x1 = x + dx; y1 = y + dy; dx1 = dx; dy1 = dy
                if (part == 2)
                    wrapCube()
                else
                    wrap()
                if (map[x1,y1] == "#")
                    break
                x = x1; y = y1; dx = dx1; dy = dy1
            }
        }
    print 1000 * y + 4 * x + (dx == 0 ? 2 - dy : 1 - dx)
}

function wrap() {
    if (x > 2*n) {                 # Region 2
        if (y1 == 0)      y1 = n
        if (x1 == 3*n+1)  x1 = n+1
        if (y1 == n+1)    y1 = 1
    } else if (y <= n) {           # Region 1
        if (y1 == 0)      y1 = 3*n
        if (x1 == n)      x1 = 3*n
    } else if (y <= 2*n) {         # Region 3
        if (x1 == n)      x1 = 2*n
        if (x1 == 2*n+1)  x1 = n+1
    } else if (x > n) {            # Region 5
        if (x1 == 2*n+1)  x1 = 1
        if (y1 == 3*n+1)  y1 = 1
    } else if (y <= 3*n) {         # Region 4
        if (y1 == 2*n)    y1 = 4*n
        if (x1 == 0)      x1 = 2*n
    } else {                       # Region 6
        if (x1 == 0)      x1 = n
        if (x1 == n+1)    x1 = 1
        if (y1 == 4*n+1)  y1 = 2*n+1
    }
}

function wrapCube() {
    if (x > 2*n) {                 # Region 2
        if (y1 == 0)      { x1 = x-2*n;     y1 = 4*n;         dx1 =  0; dy1 = -1 }
        if (x1 == 3*n+1)  { x1 = 2*n;       y1 = 2*n+(n-y+1); dx1 = -1; dy1 =  0 }
        if (y1 == n+1)    { x1 = 2*n;       y1 = n+(x-2*n);   dx1 = -1; dy1 =  0 }
    } else if (y <= n) {           # Region 1
        if (y1 == 0)      { x1 = 1;         y1 = 3*n+(x-n);   dx1 =  1; dy1 =  0 }
        if (x1 == n)      { x1 = 1;         y1 = 2*n+(n-y+1); dx1 =  1; dy1 =  0 }
    } else if (y <= 2*n) {         # Region 3
        if (x1 == n)      { x1 = y-n;       y1 = 2*n+1;       dx1 =  0; dy1 =  1 }
        if (x1 == 2*n+1)  { x1 = 2*n+(y-n); y1 = n;           dx1 =  0; dy1 = -1 }
    } else if (x > n) {            # Region 5
        if (x1 == 2*n+1)  { x1 = 3*n;       y1 = 3*n-y+1;     dx1 = -1; dy1 =  0 }
        if (y1 == 3*n+1)  { x1 = n;         y1 = 3*n+(x-n);   dx1 = -1; dy1 =  0 }
    } else if (y <= 3*n) {         # Region 4
        if (y1 == 2*n)    { x1 = n+1;       y1 = n+x;         dx1 =  1; dy1 =  0 }
        if (x1 == 0)      { x1 = n+1;       y1 = 3*n-y+1;     dx1 =  1; dy1 =  0 }
    } else {                       # Region 6
        if (x1 == 0)      { x1 = n+(y-3*n); y1 = 1;           dx1 =  0; dy1 =  1 }
        if (x1 == n+1)    { x1 = n+(y-3*n); y1 = 3*n;         dx1 =  0; dy1 = -1 }
        if (y1 == 4*n+1)  { x1 = 2*n+x;     y1 = 1;           dx1 =  0; dy1 =  1 }
    }
}
