BEGIN { FS = ""; digits = "=-012" }
{
    n = 0
    for (i = 1; i <= NF; i++)
        n = n * 5 + index(digits, $i) - 3
    sum += n
}
END { print SNAFU(sum) }

function SNAFU(n, power, max, negative) {
    if (power == 0)
        return SNAFU(n, 1, 2)
    if (n < 0)
        return SNAFU(-n, power, max, !negative)
    if (n == 0)
        return 0
    if (n > max)
        return SNAFU(n, power * 5, max * 5 + 2, negative)
    d = int(n / power)
    d = d > 2 ? 2 : d
    if (n - d * power > (max - 2) / 5)
        d++
    r = d
    if (r == 1 && negative) r = "-"
    if (r == 2 && negative) r = "="
    return r SNAFU(n - d * power, power / 5, (max - 2) / 5, negative)
}
