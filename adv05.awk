BEGIN { ORS = "" }
/^\[/ {
    for (i = 1; i <= 9; i++) {
        c = substr($0, 4 * i - 2, 1)
        if (c != " ") {
            height[i]++
            for (j = height[i]; j > 1; j--)
                crates[i,j] = crates[i,j-1]
            crates[i,1] = c
        }
    }
}
/move/ {
    for (i = 1; i <= $2; i++) {
        height[$6]++
        if (part == 2)              # run with -v part=2
            crates[$6,height[$6]] = crates[$4,height[$4]-$2+i]
        else
            crates[$6,height[$6]] = crates[$4,height[$4]-i+1]
    }
    height[$4] -= $2
}
END {
    for (i = 1; i <= 9; i++)
        print crates[i,height[i]]
    print "\n"
}
