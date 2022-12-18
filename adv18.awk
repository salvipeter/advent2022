BEGIN { FS = "," }
{
    cubes[$1,$2,$3] = 1
    for (i = 1; i <= 3; i++) {
        min = $i < min ? $i : min
        max = $i > max ? $i : max
        j = i == 2 ? 1 : 2
        k = i == 3 ? 1 : 3
        for (d = 0; d <= 1; d++) {
            if ($i + d in faces[i,$j,$k]) {
                delete faces[i,$j,$k][$i+d]
                count--
            } else {
                faces[i,$j,$k][$i+d] = 1
                count++
            }
        }
    }
}
END {
    if (part != 2) {
        print count
        exit
    }
    # Show air pocket cube positions when called with -v part=2
    min--; max++
    for (x = min; x < max; x++)
        for (y = min; y < max; y++)
            for (z = min; z <= max; z += max - min) {
                air[x,y,z] = 1; queue[++n] = x SUBSEP y SUBSEP z
                air[x,z,y] = 1; queue[++n] = x SUBSEP z SUBSEP y
                air[z,y,x] = 1; queue[++n] = z SUBSEP y SUBSEP x
            }
    while (++k <= n) {
        for (i = 1; i <= 3; i++)
            for (d = -1; d <= 1; d += 2) {
                split(queue[k], xyz, SUBSEP)
                xyz[i] += d
                if (xyz[i] < min || xyz[i] > max)
                    continue
                v = xyz[1] SUBSEP xyz[2] SUBSEP xyz[3]
                if (!(v in cubes) && !(v in air)) {
                    air[v] = 1
                    queue[++n] = v
                }
            }
    }
    for (x = min; x <= max; x++)
        for (y = min; y <= max; y++)
            for (z = min; z <= max; z++)
                if (!((x,y,z) in air) && !((x,y,z) in cubes))
                    print x "," y "," z
}
