BEGIN { FS = "[-,]" }
{
    if ($1 <= $3 && $2 >= $4 || $3 <= $1 && $4 >= $2)
        count1++
    if ($1 <= $4 && $2 >= $3)
        count2++
}
END { print count1 ", " count2 }
