BEGIN { m = -1; mod = 1 }
/Monkey/ { m++ }
/Starting/ {
    for (i = 3; i <= NF; i++)
        items[m,++n[m]] = int($i)
}
/Operation/ { op[m] = $5; operand[m] = $6 }
/Test/ { test[m] = $4; mod *= $4 }
/true/ { true[m] = $6 }
/false/ { false[m] = $6 }
END { # call with -v part=2 for part 2
    for (i = 1; i <= (part == 2 ? 10000 : 20); i++)
        for (j = 0; j <= m; j++) {
            for (k = 1; k <= n[j]; k++) {
                count[j]++
                t = items[j,k]
                x = operand[j] == "old" ? t : operand[j]
                t = op[j] == "*" ? t * x : t + x
                t = part == 2 ? t % mod : int(t / 3)
                to = t % test[j] == 0 ? true[j] : false[j]
                items[to,++n[to]] = t
            }
            n[j] = 0
        }
    asort(count, sorted, "@val_num_desc")
    print sorted[1] * sorted[2]
}
