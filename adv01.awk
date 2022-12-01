BEGIN { RS = "" }
{
    for (i = 1; i <= NF; i++)
        sum[NR] += $i
}
END {
    asort(sum, sum, "@val_num_desc")
    print sum[1] ", " sum[1] + sum[2] + sum[3]
}
