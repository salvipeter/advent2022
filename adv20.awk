BEGIN { # run with -v part=2 for part 2
    if (part == 2) { mult = 811589153; iterations = 10 }
    else           { mult = 1;         iterations = 1  }
}
{
    data[NR] = $0 * mult
    left[NR] = NR - 1
    right[NR-1] = NR
    if ($0 == 0)
        zero = NR
}
END {
    left[1] = NR
    right[NR] = 1
    for (k = 1; k <= iterations; k++)
        mix()
    print take(1000) + take(2000) + take(3000)
}

function mix() {
    for (i = 1; i <= NR; i++) {
        left[right[i]] = left[i]
        right[left[i]] = right[i]
        if (data[i] < 0)
            shift = NR - 1 - (-data[i] % (NR - 1))
        else
            shift = data[i] % (NR - 1)
        tmp = right[i]
        for (j = 1; j <= shift; j++)
            tmp = right[tmp]
        right[i] = tmp
        left[i] = left[tmp]
        right[left[tmp]] = i
        left[tmp] = i
    }
}

function take(n) {
    n = n % NR
    tmp = zero
    for (i = 1; i <= n; i++)
        tmp = right[tmp]
    return data[tmp]
}
