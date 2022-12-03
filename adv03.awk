BEGIN {
    FS = ""
    priorities = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
}
{
    found = 0
    for (i = 1; !found && i <= NF / 2; i++)
        for (j = NF; !found && j > NF / 2; j--)
            if ($i == $j) {
                sum1 += index(priorities, $i)
                found = 1
            }
    if (NR % 3 == 0)
        for (i = 1; i <= NF; i++)
            if (prev1 ~ $i && prev2 ~ $i) {
                sum2 += index(priorities, $i)
                break
            }
    prev2 = prev1; prev1 = $0
}
END { print sum1 ", " sum2 }
